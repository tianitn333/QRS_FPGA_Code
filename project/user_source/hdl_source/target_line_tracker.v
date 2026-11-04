// -----------------------------------------------------------------------------
// Module: target_line_tracker
// 功能：完整源帧观测的单目标关联、滞回过线与双向饱和计数。
// Clock/reset: 75 MHz, I_rst_n asynchronous active low.
// 接口：无反压，每拍最多一个原子观测；输出为接受沿后的寄存结果。
// Source: team RTL. Same-colour multiple objects are not separated.
// -----------------------------------------------------------------------------
module target_line_tracker #(
    parameter integer AXIS_Y = 0,
    parameter integer LINE_POSITION = 640,
    parameter integer HALF_WIDTH = 12,
    parameter integer DETECTION_CONFIRM = 2,
    parameter integer SIDE_CONFIRM = 2,
    parameter integer MAX_MISSED = 3,
    parameter integer MAX_SOURCE_GAP = 4,
    parameter integer MAX_STEP = 96,
    parameter integer COUNT_WIDTH = 24,
    parameter integer TRACK_ID_WIDTH = 16
)(
    input I_clk,
    input I_rst_n,
    input I_sample_valid,
    input I_source_id_valid,
    input [31:0] I_source_id,
    input I_target_valid,
    input [11:0] I_x,
    input [11:0] I_y,
    input I_enable,
    input I_clear,
    input I_source_restart,
    output O_sample_accepted,
    output O_duplicate,
    output O_rejected,
    output [1:0] O_track_state,
    output O_track_valid,
    output [TRACK_ID_WIDTH-1:0] O_track_id,
    output [11:0] O_x,
    output [11:0] O_y,
    output O_cross_forward,
    output O_cross_reverse,
    output [COUNT_WIDTH-1:0] O_count_forward,
    output [COUNT_WIDTH-1:0] O_count_reverse
);

    // 状态和动作分开：下一状态进程不直接修改坐标或计数寄存器。
    localparam [1:0] ST_IDLE = 2'd0, ST_CANDIDATE = 2'd1,
                     ST_TRACKED = 2'd2, ST_LOST = 2'd3;
    localparam [2:0] C_KEEP = 3'd0, C_CLEAR = 3'd1, C_START = 3'd2,
                     C_MISS = 3'd3, C_CANDIDATE = 3'd4,
                     C_TRACK = 3'd5, C_RESET = 3'd6;
    localparam [11:0] C_LOW = LINE_POSITION-HALF_WIDTH;
    localparam [11:0] C_HIGH = LINE_POSITION+HALF_WIDTH;
    localparam [7:0] C_DETECTION_PREVIOUS = DETECTION_CONFIRM-1;
    localparam [7:0] C_SIDE_CONFIRM = SIDE_CONFIRM;
    localparam [31:0] C_MAX_GAP = MAX_SOURCE_GAP;
    localparam [32:0] C_MAX_MISSED = MAX_MISSED;
    localparam [32:0] C_MAX_AGE = MAX_MISSED+1;
    localparam [8:0] C_MAX_SCALE = MAX_SOURCE_GAP;
    localparam [11:0] C_MAX_STEP = MAX_STEP;
    localparam [COUNT_WIDTH-1:0] C_COUNT_MAX = {COUNT_WIDTH{1'b1}};

    // 源帧历史、关联历史和已发布结果。
    reg [1:0] S_state, S_state_next;
    reg [2:0] S_action;
    reg S_seen;
    reg [31:0] S_source;
    reg [7:0] S_hits, S_missed, S_pending_hits;
    reg [1:0] S_stable_side, S_pending_side;
    reg [TRACK_ID_WIDTH-1:0] S_track_id_o;
    reg [11:0] S_x_o, S_y_o;
    reg [COUNT_WIDTH-1:0] S_count_forward_o, S_count_reverse_o;
    reg S_accepted_o, S_duplicate_o, S_rejected_o;
    reg S_cross_forward_o, S_cross_reverse_o;

    // 32位模差仅在半周期以内解释为向前，首个观测的间隔定义为1。
    wire [31:0] S_delta_raw = I_source_id-S_source;
    wire [31:0] S_delta = S_seen ? S_delta_raw : 32'd1;
    wire S_rejected = I_sample_valid &&
                      (!I_source_id_valid || (S_seen && S_delta[31]));
    wire S_duplicate = I_sample_valid && I_source_id_valid &&
                       S_seen && (S_delta == 32'd0);
    wire S_accepted = I_sample_valid && !S_rejected && !S_duplicate;

    // 33位累计避免大跳号加缺失数回绕成一个很小的合法间隔。
    wire [32:0] S_elapsed = {1'b0,S_delta}+{25'd0,S_missed};
    wire [8:0] S_scale = (S_elapsed > {1'b0,C_MAX_GAP}) ?
                         C_MAX_SCALE : S_elapsed[8:0];
    wire [20:0] S_radius = S_scale*C_MAX_STEP;
    wire [12:0] S_distance_x = (I_x >= S_x_o) ?
                              ({1'b0,I_x}-{1'b0,S_x_o}) :
                              ({1'b0,S_x_o}-{1'b0,I_x});
    wire [12:0] S_distance_y = (I_y >= S_y_o) ?
                              ({1'b0,I_y}-{1'b0,S_y_o}) :
                              ({1'b0,S_y_o}-{1'b0,I_y});
    wire S_matches = ({8'd0,S_distance_x} <= S_radius) &&
                     ({8'd0,S_distance_y} <= S_radius);
    wire S_has_track = (S_state == ST_TRACKED) || (S_state == ST_LOST);
    wire S_expired = S_has_track && (S_elapsed > C_MAX_AGE);
    wire S_recovering = (S_state == ST_LOST) || (S_delta != 32'd1);

    // 中性区包含两个边界；连续外侧确认采用饱和计数。
    wire [11:0] S_coordinate = AXIS_Y ? I_y : I_x;
    wire [1:0] S_side = (S_coordinate < C_LOW) ? 2'd1 :
                       ((S_coordinate > C_HIGH) ? 2'd2 : 2'd0);
    wire [7:0] S_pending_increment = (S_pending_hits >= C_SIDE_CONFIRM) ?
                                     C_SIDE_CONFIRM : S_pending_hits+8'd1;
    wire [7:0] S_pending_next = (S_side == 2'd0) ? 8'd0 :
                               ((S_side == S_pending_side) ? S_pending_increment : 8'd1);

    // 进程一：状态寄存器。异步复位可在没有观测时立即撤销跟踪。
    always @(posedge I_clk or negedge I_rst_n) begin
        if (!I_rst_n)
            S_state <= ST_IDLE;
        else
            S_state <= S_state_next;
    end

    // 进程二：转移优先级为清零/重启、关闭、有效新观测。
    always @(*) begin
        S_state_next = S_state;
        S_action = C_KEEP;
        if (I_clear || I_source_restart) begin
            S_state_next = ST_IDLE;
            S_action = C_RESET;
        end else if (!I_enable) begin
            S_state_next = ST_IDLE;
            S_action = C_CLEAR;
        end else if (S_accepted) begin
            if (S_delta > C_MAX_GAP) begin
                S_state_next = I_target_valid ? ST_CANDIDATE : ST_IDLE;
                S_action = I_target_valid ? C_START : C_CLEAR;
            end else if (!I_target_valid) begin
                if (S_has_track && (S_elapsed <= C_MAX_MISSED)) begin
                    S_state_next = ST_LOST;
                    S_action = C_MISS;
                end else begin
                    S_state_next = ST_IDLE;
                    S_action = C_CLEAR;
                end
            end else if ((S_state == ST_IDLE) || !S_matches || S_expired ||
                         ((S_state == ST_CANDIDATE) && (S_delta != 32'd1))) begin
                S_state_next = ST_CANDIDATE;
                S_action = C_START;
            end else begin
                case (S_state)
                    ST_CANDIDATE: begin
                        S_action = C_CANDIDATE;
                        if (S_hits >= C_DETECTION_PREVIOUS)
                            S_state_next = ST_TRACKED;
                    end
                    ST_TRACKED, ST_LOST: begin
                        S_state_next = ST_TRACKED;
                        S_action = C_TRACK;
                    end
                    default: begin
                        S_state_next = ST_IDLE;
                        S_action = C_CLEAR;
                    end
                endcase
            end
        end
    end

    // 进程三：原子提交数据。重复帧不会增长命中数或缺失数。
    always @(posedge I_clk or negedge I_rst_n) begin
        if (!I_rst_n) begin
            S_seen <= 1'b0;
            S_source <= 32'd0;
            S_hits <= 8'd0;
            S_missed <= 8'd0;
            S_pending_hits <= 8'd0;
            S_pending_side <= 2'd0;
            S_stable_side <= 2'd0;
            S_track_id_o <= {TRACK_ID_WIDTH{1'b0}};
            S_x_o <= 12'd0;
            S_y_o <= 12'd0;
            S_count_forward_o <= {COUNT_WIDTH{1'b0}};
            S_count_reverse_o <= {COUNT_WIDTH{1'b0}};
            S_accepted_o <= 1'b0;
            S_duplicate_o <= 1'b0;
            S_rejected_o <= 1'b0;
            S_cross_forward_o <= 1'b0;
            S_cross_reverse_o <= 1'b0;
        end else begin
            S_accepted_o <= S_accepted && !I_clear && !I_source_restart;
            S_duplicate_o <= S_duplicate && !I_clear && !I_source_restart;
            S_rejected_o <= S_rejected && !I_clear && !I_source_restart;
            S_cross_forward_o <= 1'b0;
            S_cross_reverse_o <= 1'b0;
            if (S_accepted) begin
                S_seen <= 1'b1;
                S_source <= I_source_id;
            end
            case (S_action)
                C_RESET: begin
                    S_seen <= 1'b0;
                    S_source <= 32'd0;
                    S_hits <= 8'd0;
                    S_missed <= 8'd0;
                    S_pending_hits <= 8'd0;
                    S_pending_side <= 2'd0;
                    S_stable_side <= 2'd0;
                    S_x_o <= 12'd0;
                    S_y_o <= 12'd0;
                    if (I_clear) begin
                        S_track_id_o <= {TRACK_ID_WIDTH{1'b0}};
                        S_count_forward_o <= {COUNT_WIDTH{1'b0}};
                        S_count_reverse_o <= {COUNT_WIDTH{1'b0}};
                    end
                end
                C_CLEAR: begin
                    S_hits <= 8'd0;
                    S_missed <= 8'd0;
                    S_pending_hits <= 8'd0;
                    S_pending_side <= 2'd0;
                    S_stable_side <= 2'd0;
                end
                C_START: begin
                    S_hits <= 8'd1;
                    S_missed <= 8'd0;
                    S_pending_hits <= (S_side == 2'd0) ? 8'd0 : 8'd1;
                    S_pending_side <= S_side;
                    S_stable_side <= 2'd0;
                    S_x_o <= I_x;
                    S_y_o <= I_y;
                end
                C_MISS: begin
                    S_missed <= S_elapsed[7:0];
                    S_pending_hits <= 8'd0;
                    S_pending_side <= 2'd0;
                    S_stable_side <= 2'd0;
                end
                C_CANDIDATE: begin
                    S_hits <= S_hits+8'd1;
                    S_x_o <= I_x;
                    S_y_o <= I_y;
                    S_pending_hits <= S_pending_next;
                    S_pending_side <= S_side;
                    if (S_hits >= C_DETECTION_PREVIOUS) begin
                        S_track_id_o <= S_track_id_o+{{(TRACK_ID_WIDTH-1){1'b0}},1'b1};
                        S_stable_side <= (S_pending_next >= C_SIDE_CONFIRM) ? S_side : 2'd0;
                    end
                end
                C_TRACK: begin
                    S_x_o <= I_x;
                    S_y_o <= I_y;
                    S_missed <= 8'd0;
                    S_pending_side <= S_side;
                    if (S_recovering) begin
                        S_stable_side <= 2'd0;
                        S_pending_hits <= (S_side == 2'd0) ? 8'd0 : 8'd1;
                    end else begin
                        S_pending_hits <= S_pending_next;
                        if ((S_side != 2'd0) && (S_pending_next >= C_SIDE_CONFIRM)) begin
                            S_stable_side <= S_side;
                            if ((S_stable_side != 2'd0) && (S_stable_side != S_side)) begin
                                if (S_side == 2'd2) begin
                                    S_cross_forward_o <= 1'b1;
                                    if (S_count_forward_o != C_COUNT_MAX)
                                        S_count_forward_o <= S_count_forward_o+{{(COUNT_WIDTH-1){1'b0}},1'b1};
                                end else begin
                                    S_cross_reverse_o <= 1'b1;
                                    if (S_count_reverse_o != C_COUNT_MAX)
                                        S_count_reverse_o <= S_count_reverse_o+{{(COUNT_WIDTH-1){1'b0}},1'b1};
                                end
                            end
                        end
                    end
                end
                default: begin
                    // 无新观测时保留结果，仅上方的一拍事件归零。
                end
            endcase
        end
    end

    // 对外结果桥接；状态和数据均来自同一个接受沿。
    assign O_sample_accepted = S_accepted_o;
    assign O_duplicate = S_duplicate_o;
    assign O_rejected = S_rejected_o;
    assign O_track_state = S_state;
    assign O_track_valid = (S_state == ST_TRACKED);
    assign O_track_id = S_track_id_o;
    assign O_x = S_x_o;
    assign O_y = S_y_o;
    assign O_cross_forward = S_cross_forward_o;
    assign O_cross_reverse = S_cross_reverse_o;
    assign O_count_forward = S_count_forward_o;
    assign O_count_reverse = S_count_reverse_o;

    // synthesis translate_off
    initial begin
        if ((AXIS_Y < 0) || (AXIS_Y > 1) || (HALF_WIDTH < 0) ||
            (LINE_POSITION < HALF_WIDTH) || (LINE_POSITION+HALF_WIDTH > 4095) ||
            (DETECTION_CONFIRM < 2) || (DETECTION_CONFIRM > 255) ||
            (SIDE_CONFIRM < 2) || (SIDE_CONFIRM > 255) ||
            (MAX_MISSED < 0) || (MAX_MISSED > 255) ||
            (MAX_SOURCE_GAP < 1) || (MAX_SOURCE_GAP > 255) ||
            (MAX_STEP < 1) || (MAX_STEP > 4095) ||
            (COUNT_WIDTH < 1) || (COUNT_WIDTH > 32) ||
            (TRACK_ID_WIDTH < 1) || (TRACK_ID_WIDTH > 32)) begin
            $display("FAIL: target_line_tracker invalid parameter configuration");
            $finish;
        end
    end
    // synthesis translate_on
endmodule
