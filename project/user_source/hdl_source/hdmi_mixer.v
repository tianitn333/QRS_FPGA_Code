module hdmi_mixer #(
    parameter integer AE_DEBUG_ENABLE = 0,
    parameter integer DDR_DIAG_ENABLE = 0,
    parameter H_OFFSET = 128,
    parameter V_OFFSET = 60,
    parameter IMG_WIDTH = 1280,
    parameter IMG_HEIGHT = 720,
    parameter integer DEBUG_MODE = 0,
    // 上电默认显示源（本工程扩展，2026-10 M3 自动曝光轮次）：
    //   1 = 原图直通（彩色），0 = 灰度（V0.1 原行为）
    // 运行期可用板载按键（D5）在「原图 → 灰度 → 边缘」之间循环切换；
    // 该参数只决定**上电时的默认档**，不再固定整机行为。
    parameter integer VIDEO_SRC = 1,
    // 运行时颜色参数 + 四键 UI（2026-10 色块 UI 轮次）：
    //   0 = 旧行为（按键触发、模块参数门限；旧独立测试不连新端口即保持原样）
    //   1 = 模式/参数来自 color_ui_fsm，门限来自 color_param_bank（帧尾提交）
    parameter integer UI_ENABLE = 0,
    // ---- 检测判据参数（透传给 color_detect_box；见该模块内注释与参数扫描依据）----
    parameter integer DET_RATIO_SHIFT    = 0,  // 红判据比例：0 → 2.0 倍（1.5 倍会把皮肤/手算成红，皮肤 R/G≈1.3~1.6）
    parameter integer DET_RATIO_SHIFT_G  = 3,  // 绿判据对 R：1.125 倍，保留偏黄弱绿区域
    parameter integer DET_RATIO_SHIFT_GB = 1,  // 绿判据(对 B)比例：1 → 1.5 倍
    parameter integer DET_MIN_SAT     = 18,   // 饱和度门限（配合亮度门槛提升暗角下的检出率）
    parameter integer DET_MIN_LUMA    = 44,   // 最小亮度门限（48 → 40：避免两侧暗角下丢框）
    parameter integer DET_MIN_ROW_CNT = 6,    // 红色每行至少 6 个采样点，允许部分入画
    parameter integer DET_MIN_DIFF_R  = 48,   // 红判据绝对差下限 R-max(G,B)（48 可消除框抖动）
    parameter integer DET_MIN_DIFF_G  = 12,   // 绿判据绝对差下限 G-max(R,B)
    parameter integer DET_MIN_ROW_CNT_G = 4,  // 绿色每行至少 4 个采样点
    parameter integer DET_MIN_ROW_RUN_G = 2,  // 保留绿色连续两行确认
    parameter integer DET_B_R_RATIO_Q2 = 6,
    parameter integer DET_B_G_RATIO_Q2 = 7,
    parameter integer BLUE_BACKGROUND_ENABLE = 0,
    parameter integer EDGE_DENOISE_ENABLE = 0,
    parameter integer EDGE_REFINE_ENABLE = 1,
    parameter integer EDGE_PRECISE_ENABLE = 1,
    parameter integer EDGE_COHERENCE_ENABLE = 0,
    parameter integer EDGE_OPT_ENABLE = 0, // 2026-10-25 threshold + tangent support trial
    parameter integer EDGE_COMPARE_ENABLE = 0,
    parameter integer EDGE_FILL_ENABLE = 0, // closed-region replay; formal top enables it
    parameter integer EDGE_FILL_MIN_BG_RUN = 1, // ignore short background runs in FILL capture
    parameter integer EDGE_FILL_ROW_STEP = 1, // 2 = capture OR of row pairs, halves run pressure
    parameter integer BG_NOISE_CAL_ENABLE = 0,
    parameter integer BG_NOISE_MARGIN = 8,
    parameter integer EDGE_EXTRACT_ENABLE = 1,
    parameter integer EDGE_STATS_ENABLE = 1,
    parameter integer H_TOTAL = 1650,
    parameter integer BG_SETTLE_CYCLES = 37500000,
    parameter integer DET_EXTENDED_BLUE = 0,
    parameter integer DET_LIGHT_B_R_Q2 = 5,
    parameter integer DET_LIGHT_G_R_Q2 = 5,
    parameter integer DET_LIGHT_MIN_DIFF = 20,
    parameter integer DET_LIGHT_BALANCE_SHIFT = 2,
    parameter integer DET_MIN_DIFF_B = 20,
    parameter integer DET_MIN_ROW_CNT_B = 4,
    parameter integer DET_MIN_ROW_RUN_B = 2,
    parameter integer DET_MIN_AREA = 32      // 合格行累计的采样点数，不是原图像素面积
)(
    input wire        I_clk,
    input wire        I_rst_n,

    input wire        I_video_vsync,
    input wire        I_video_hsync,
    input wire        I_video_de,
    input wire        I_video_user,
    input wire        I_video_last,

    input wire [59:0] I_ae_status,
    input wire [15:0] I_ddr_status,
    input wire[3:0]   I_debug_status,

    // 板载按键事件（已去抖、单拍脉冲、与 I_clk 同域；来源见 design_top_wrapper.v）
    input wire        I_key_src_trig,     // KEY1/D5：循环切换显示源
    input wire        I_bg_calibrate,
    input wire        I_key_det_trig,     // KEY2/A9：对比模式切换；EDGE_COMPARE_ENABLE=0时保持旧叠加开关
    input wire        I_fill_k1_short,
    input wire        I_fill_k1_long,
    input wire        I_fill_k3_step,
    input wire        I_fill_k4_step,

    // 运行时 UI（仅 UI_ENABLE=1 时使用；旧测试不连接这些端口）
    input wire [1:0]   I_ui_mode,         // 0=ORIG 1=GRAY 2=EDGE 3=COLOR
    // View request: {panel, edit, page[2:0], cursor[1:0], preview}.
    // The returned snapshot prefixes mode[1:0]; menu and preview share it.
    input wire [7:0]   I_ui_view,
    output reg [9:0]   O_ui_view,
    input wire         I_ui_edge_toggle,  // DETECT/EXTRACT 切换
    input wire [239:0] I_ui_edit_bus,     // 编辑值（Q5 打包，见 color_param_bank.v）
    input wire         I_ui_commit_req,   // 存在待生效修改
    output wire [239:0] O_param_eff,      // 生效值（供菜单显示"生效/待生效"）
    output wire [31:0] O_param_version,
    output wire         O_param_committed, // 生效值已提交单拍脉冲

    output wire       O_video_rd_en,
    input wire[23:0]  I_video_rd_data,

    output reg        O_hdmi_vsync,
    output reg        O_hdmi_hsync,
    output reg        O_hdmi_de,
    output reg[23:0]  O_hdmi_data,
    // Dense, overlay-free edge stream; active when EDGE_DENOISE_ENABLE is set.
    output wire O_edge_valid, O_edge_user, O_edge_last, O_edge_bit,
    output wire [11:0] O_edge_x, O_edge_y,
    output wire O_edge_point_valid,
    output wire [11:0] O_edge_point_x,O_edge_point_y,
    output wire [15:0] O_edge_point_frame,
    output wire O_edge_run_valid,
    output wire [11:0] O_edge_run_start,O_edge_run_end,O_edge_run_y,
    output wire [12:0] O_edge_run_length,
    output wire [15:0] O_edge_run_frame,
    output wire O_edge_frame_done,
    output wire [15:0] O_edge_frame_id,
    output wire [23:0] O_edge_frame_points,O_edge_frame_runs,
    output wire O_edge_bbox_valid,
    output wire [11:0] O_edge_xmin,O_edge_xmax,O_edge_ymin,O_edge_ymax,
    output wire O_fill_edit,
    output wire [12:0] O_fill_run_count,
    output wire O_fill_overflow
);

    reg        S_video_vsync_1d;
    reg        S_video_vsync_2d;
    reg        S_video_hsync_1d;
    reg        S_video_hsync_2d;
    reg        S_video_de_1d;
    reg        S_video_de_2d;
    reg [23:0] S_video_data_2d;
    reg [23:0] S_rd_data_1d;      // VIDEO_SRC=1 时替代灰度寄存，保持同级延迟
    reg        S_video_user_1d;   // 与 S_video_de_1d 同拍（供 sobel3x3 用）
    reg        S_video_last_1d;
    // 前级（既有 2 拍对齐）
    reg        S_pre_vsync;
    reg        S_pre_hsync;
    reg        S_pre_de;
    reg [23:0] S_pre_data;
    // 末级：统一再延迟 2 拍（第 3 拍 S_p3_* → 第 4 拍 S_pd_*）
    reg        S_p3_de, S_p3_hsync, S_p3_vsync;
    reg [23:0] S_p3_data;
    reg        S_p3_ohit, S_p3_dhit, S_p3_shit;
    reg [23:0] S_p3_ocol, S_p3_dcol, S_p3_scol;
    reg        S_pd_de, S_pd_hsync, S_pd_vsync;
    reg [23:0] S_pd_data;
    reg        S_pd_ohit, S_pd_dhit, S_pd_shit;
    reg [23:0] S_pd_ocol, S_pd_dcol, S_pd_scol;
    wire       S_gray_valid;
    wire [7:0] S_gray_pixel;
    reg [11:0] S_x;
    reg [11:0] S_y;
    reg [11:0] S_x_1d;
    reg [11:0] S_x_2d;
    reg [11:0] S_y_1d;
    reg [11:0] S_y_2d;

    reg        S_osd_hit;
    reg [23:0] S_osd_color;
    reg [11:0] S_logo_x;
    reg [11:0] S_logo_y;
    reg [3:0]  S_char_idx;
    reg [2:0]  S_char_row;
    reg [2:0]  S_char_col;
    reg [4:0]  S_char_bits;
    reg        S_char_on;
    reg        S_logo_blue_on;
    reg        S_logo_red_on;
    reg [11:0] S_logo_tmp_y;
    reg [3:0]  S_logo_red_band;
    reg [11:0] S_logo_red_x_start;
    reg [11:0] S_logo_red_x_end;
    reg [14:0] S_logo_addr;
    wire[24:0] S_logo_pixel;
    reg [31:0] S_frame_cnt;
    reg [11:0] S_dyn_x;
    reg [11:0] S_dyn_y;
    reg [3:0]  S_dyn_char;
    reg [2:0]  S_dyn_col;
    reg [2:0]  S_dyn_row;
    reg [4:0]  S_dyn_bits;
    reg        S_dyn_on;
    reg [3:0]  S_dyn_digit_idx;
    reg [11:0] S_dyn_digit_x;
    reg [6:0]  S_dyn_seg;
    reg [3:0]  S_cnt_d0;
    reg [3:0]  S_cnt_d1;
    reg [3:0]  S_cnt_d2;
    reg [3:0]  S_cnt_d3;
    reg [3:0]  S_cnt_d4;
    reg [3:0]  S_cnt_d5;
    reg [2:0]  S_lbl_row;
    reg [2:0]  S_lbl_col;
    reg [1:0]  S_lbl_idx;
    reg [4:0]  S_lbl_bits;
    reg [6:0]  S_lbl_local_x;
    reg [3:0]  S_dyn_dec_digit;
    reg [4:0]  S_cn_local_x;
    reg [4:0]  S_cn_local_y;
    reg [3:0]  S_cn_col;
    reg [3:0]  S_cn_row;
    reg [15:0] S_cn_row_bits;
    reg        S_cn_on;
    reg [9:0]  S_cn_scale_x;
    reg [9:0]  S_cn_scale_y;
    reg [7:0]  S_pf_char;
    reg [4:0]  S_pf_local_x;
    reg [4:0]  S_pf_local_y;
    reg [3:0]  S_pf_col;
    reg [3:0]  S_pf_row;
    wire [15:0] S_pf_row_bits;
    reg        S_pf_on;
    reg [9:0]  S_pf_scale_x;
    reg [9:0]  S_pf_scale_y;

    // ---- M3 颜色检测：color_detect_box + detect_osd ----
    wire        S_det_r_valid;
    wire [31:0] S_det_r_area;
    wire [11:0] S_det_r_xmin;
    wire [11:0] S_det_r_xmax;
    wire [11:0] S_det_r_ymin;
    wire [11:0] S_det_r_ymax;
    wire        S_det_g_valid;
    wire [31:0] S_det_g_area;
    wire [11:0] S_det_g_xmin;
    wire [11:0] S_det_g_xmax;
    wire [11:0] S_det_g_ymin;
    wire [11:0] S_det_g_ymax;
    // 检测叠加判定：坐标/DE 保持既有相位（S_*_2d，与输出像素严格同拍），
    // 输出为组合信号；末级（见文件末尾的「末级」always）统一延迟后再采样，
    // 因此判定相位与原方案完全一致。
    wire        S_det_hit;
    wire [23:0] S_det_color;

    // ---- 显示模式（运行期切换 + 帧首锁存 → 一帧内恒定，满足 T05）----
    localparam [1:0] SRC_ORIG = 2'd0;   // 原图直通（彩色）
    localparam [1:0] SRC_GRAY = 2'd1;   // 灰度（V0.1 原行为）
    localparam [1:0] SRC_EDGE = 2'd2;   // 边缘档（预留：3×3 邻域接入前回退为原图）
    localparam [1:0] SRC_COLOR= 2'd3;   // 色块检测档（彩色底图 + 检测叠加）

    // Snapshot in input vertical blank BEFORE the first active pixel.
    // Keep this bundle fixed through the output menu's delayed VS capture.
    reg S_view_vs_d;
    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)begin S_view_vs_d<=1'b1;O_ui_view<=10'd0;end
        else begin
            S_view_vs_d<=I_video_vsync;
            if(UI_ENABLE!=0 && S_view_vs_d && !I_video_vsync)
                O_ui_view<={I_ui_mode,I_ui_view};
        end
    end
    wire S_preview_active=(UI_ENABLE!=0) && O_ui_view[9:8]==SRC_COLOR && O_ui_view[6] && O_ui_view[0];
    wire [3:0] S_pixel_hit;
    reg [3:0] S_pixel_hit_1d;
    always @(posedge I_clk or negedge I_rst_n)begin
        if(!I_rst_n)S_pixel_hit_1d<=0;
        else S_pixel_hit_1d<=S_pixel_hit;
    end
    // Background gate adds three registered stages in historical configurations.
    // With bypass, register hits once alongside S_rd_data_1d and select at stage2;
    // with the gate, its raw classification is already at stage3, select at stage4.
    wire [3:0] S_view_hits=(BLUE_BACKGROUND_ENABLE!=0) ? S_pixel_hit : S_pixel_hit_1d;
    reg S_view_hit;
    always @*begin
        case(O_ui_view[5:3])
            0:S_view_hit=S_view_hits[0];
            1:S_view_hit=S_view_hits[1];
            2:S_view_hit=S_view_hits[2];
            3:S_view_hit=S_view_hits[3];
            4:S_view_hit=|S_view_hits;
            default:S_view_hit=1'b0;
        endcase
    end

    reg [1:0] S_src_run;    // 按键更新的运行值（可在帧内任意时刻改变）
    reg [1:0] S_src_eff;    // 帧首锁存后的生效值（像素通路只读这一个）
    reg       S_det_run;
    reg       S_det_eff;
    reg S_extract_run, S_extract_eff;
    reg S_fill_run, S_fill_eff;

    // FILL runtime controls. Values are edited in the FILL view and latched
    // by edge_fill_buffer at the next source-frame boundary.
    reg [11:0] S_fill_filter_cfg, S_fill_gap_cfg, S_fill_border_cfg, S_fill_minw_cfg;
    reg [3:0]  S_fill_gap_count_cfg;
    reg [2:0]  S_fill_param_sel;
    reg        S_fill_edit;
    wire [12:0] fill_run_count;
    wire        fill_overflow;
    wire       S_fill_ui_active = (UI_ENABLE != 0) && (S_src_run == SRC_EDGE) && S_fill_run;
    assign O_fill_edit = S_fill_edit;

    always @(posedge I_clk or negedge I_rst_n) begin
        if (!I_rst_n) begin
            S_src_run <= (VIDEO_SRC == 0) ? SRC_GRAY : SRC_ORIG;
            S_src_eff <= (VIDEO_SRC == 0) ? SRC_GRAY : SRC_ORIG;
            S_det_run <= 1'b1;
            S_det_eff <= 1'b1;
            S_extract_run <= 1'b0; S_extract_eff <= 1'b0;
            S_fill_run <= 1'b0; S_fill_eff <= 1'b0;
        end
        else begin
            if (UI_ENABLE != 0) begin
                // 模式由 color_ui_fsm 决定；本模块只做帧首锁存
                S_src_run <= O_ui_view[9:8];
                if (I_ui_edge_toggle) begin
                    S_extract_run <= EDGE_FILL_ENABLE != 0 ? !S_fill_run : ~S_extract_run;
                    S_fill_run <= EDGE_FILL_ENABLE != 0 && S_extract_run && !S_fill_run;
                end
            end
            else begin
                if (I_key_src_trig)
                    S_src_run <= (S_src_run == SRC_EDGE) ? SRC_ORIG : (S_src_run + 2'd1);
                if (I_key_det_trig) begin
                    if (EDGE_COMPARE_ENABLE != 0) begin
                        S_src_run <= SRC_EDGE;
                        S_extract_run <= S_src_run == SRC_EDGE ? (EDGE_FILL_ENABLE != 0 ? !S_fill_run : ~S_extract_run) : 1'b0;
                        S_fill_run <= S_src_run == SRC_EDGE && EDGE_FILL_ENABLE != 0 && S_extract_run && !S_fill_run;
                    end else S_det_run <= ~S_det_run;
                end
            end

            if (I_video_user) begin
                S_src_eff <= S_src_run;
                // 颜色叠加只在 COLOR 档生效（后台检测继续运行，不门控像素时钟）
                S_det_eff <= (UI_ENABLE != 0) ? (S_src_run == SRC_COLOR) : S_det_run;
                S_extract_eff <= S_extract_run;
                S_fill_eff <= S_fill_run;
            end
        end
    end

    // FILL editor: long K1 enters/exits, short K1 advances one field, and
    // K3/K4 decrement/increment the selected value. The values remain stable
    // when leaving FILL and take effect in the fill capture block at frame
    // start, so a frame never mixes two threshold sets.
    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)begin
            S_fill_filter_cfg <= 12'd8;
            S_fill_gap_cfg    <= 12'd0;
            S_fill_border_cfg <= 12'd0;
            S_fill_gap_count_cfg <= 4'd0;
            S_fill_minw_cfg   <= 12'd24;
            S_fill_param_sel  <= 3'd0;
            S_fill_edit       <= 1'b0;
        end else begin
            if(!S_fill_ui_active)begin
                S_fill_edit <= 1'b0;
                S_fill_param_sel <= 3'd0;
            end else if(!S_fill_edit)begin
                if(I_fill_k1_long)begin
                    S_fill_edit <= 1'b1;
                    S_fill_param_sel <= 3'd0;
                end
            end else begin
                if(I_fill_k1_long)begin
                    S_fill_edit <= 1'b0;
                end else if(I_fill_k1_short)begin
                    S_fill_param_sel <= (S_fill_param_sel==3'd4) ? 3'd0 : S_fill_param_sel+1'b1;
                end
                if(I_fill_k3_step && !I_fill_k4_step)begin
                    case(S_fill_param_sel)
                        3'd0:if(S_fill_filter_cfg>12'd1) S_fill_filter_cfg<=S_fill_filter_cfg-1'b1;
                        3'd1:if(S_fill_gap_cfg!=0)       S_fill_gap_cfg<=S_fill_gap_cfg-1'b1;
                        3'd2:if(S_fill_border_cfg!=0)    S_fill_border_cfg<=S_fill_border_cfg-1'b1;
                        3'd3:if(S_fill_gap_count_cfg!=0) S_fill_gap_count_cfg<=S_fill_gap_count_cfg-1'b1;
                        3'd4:if(S_fill_minw_cfg!=0)      S_fill_minw_cfg<=S_fill_minw_cfg-1'b1;
                        default:begin end
                    endcase
                end else if(I_fill_k4_step && !I_fill_k3_step)begin
                    case(S_fill_param_sel)
                        3'd0:if(S_fill_filter_cfg<12'd255) S_fill_filter_cfg<=S_fill_filter_cfg+1'b1;
                        3'd1:if(S_fill_gap_cfg<12'd255)    S_fill_gap_cfg<=S_fill_gap_cfg+1'b1;
                        3'd2:if(S_fill_border_cfg<12'd255) S_fill_border_cfg<=S_fill_border_cfg+1'b1;
                        3'd3:if(S_fill_gap_count_cfg<4'd15) S_fill_gap_count_cfg<=S_fill_gap_count_cfg+1'b1;
                        3'd4:if(S_fill_minw_cfg<12'd255)   S_fill_minw_cfg<=S_fill_minw_cfg+1'b1;
                        default:begin end
                    endcase
                end
            end
        end
    end

    localparam LOGO_X = 12'd0;
    localparam LOGO_Y = 12'd0;
    localparam LOGO_W = 12'd160;
    localparam LOGO_H = 12'd160;

    localparam COLOR_LOGO_BLUE   = 24'h1f315c;
    localparam COLOR_LOGO_RED    = 24'hec1c2d;
    localparam COLOR_TEXT        = 24'h00e6ff;
    localparam DYN_OSD_X         = 12'd375;
    localparam DYN_OSD_Y         = 12'd120;
    localparam DYN_OSD_W         = 12'd200;
    localparam DYN_OSD_H         = 12'd24;
    localparam CN_Y_OFFSET       = 12'd2;
    localparam COLOR_DYN_TEXT    = 24'hfff200;
    localparam CHAR_AN           = 8'h80;
    localparam CHAR_LU           = 8'h81;
    localparam CHAR_C            = 8'h43;
    localparam CHAR_N            = 8'h4e;
    localparam CHAR_T            = 8'h54;
    localparam CHAR_0            = 8'h30;
    localparam CHAR_COLON        = 8'h3a;

    function [4:0] F_logo_text_bits;
        input [3:0] I_char;
        input [2:0] I_row;
        begin
            case(I_char)
                4'd0: begin
                    case(I_row) // A
                        3'd0: F_logo_text_bits = 5'b01110;
                        3'd1: F_logo_text_bits = 5'b10001;
                        3'd2: F_logo_text_bits = 5'b10001;
                        3'd3: F_logo_text_bits = 5'b11111;
                        3'd4: F_logo_text_bits = 5'b10001;
                        3'd5: F_logo_text_bits = 5'b10001;
                        3'd6: F_logo_text_bits = 5'b10001;
                        default: F_logo_text_bits = 5'b00000;
                    endcase
                end
                4'd1: begin
                    case(I_row) // N
                        3'd0: F_logo_text_bits = 5'b10001;
                        3'd1: F_logo_text_bits = 5'b11001;
                        3'd2: F_logo_text_bits = 5'b10101;
                        3'd3: F_logo_text_bits = 5'b10011;
                        3'd4: F_logo_text_bits = 5'b10001;
                        3'd5: F_logo_text_bits = 5'b10001;
                        3'd6: F_logo_text_bits = 5'b10001;
                        default: F_logo_text_bits = 5'b00000;
                    endcase
                end
                4'd2: begin
                    case(I_row) // L
                        3'd0: F_logo_text_bits = 5'b10000;
                        3'd1: F_logo_text_bits = 5'b10000;
                        3'd2: F_logo_text_bits = 5'b10000;
                        3'd3: F_logo_text_bits = 5'b10000;
                        3'd4: F_logo_text_bits = 5'b10000;
                        3'd5: F_logo_text_bits = 5'b10000;
                        3'd6: F_logo_text_bits = 5'b11111;
                        default: F_logo_text_bits = 5'b00000;
                    endcase
                end
                4'd3: begin
                    case(I_row) // O
                        3'd0: F_logo_text_bits = 5'b01110;
                        3'd1: F_logo_text_bits = 5'b10001;
                        3'd2: F_logo_text_bits = 5'b10001;
                        3'd3: F_logo_text_bits = 5'b10001;
                        3'd4: F_logo_text_bits = 5'b10001;
                        3'd5: F_logo_text_bits = 5'b10001;
                        3'd6: F_logo_text_bits = 5'b01110;
                        default: F_logo_text_bits = 5'b00000;
                    endcase
                end
                4'd4: begin
                    case(I_row) // G
                        3'd0: F_logo_text_bits = 5'b01110;
                        3'd1: F_logo_text_bits = 5'b10001;
                        3'd2: F_logo_text_bits = 5'b10000;
                        3'd3: F_logo_text_bits = 5'b10111;
                        3'd4: F_logo_text_bits = 5'b10001;
                        3'd5: F_logo_text_bits = 5'b10001;
                        3'd6: F_logo_text_bits = 5'b01110;
                        default: F_logo_text_bits = 5'b00000;
                    endcase
                end
                4'd5: begin
                    case(I_row) // I
                        3'd0: F_logo_text_bits = 5'b11111;
                        3'd1: F_logo_text_bits = 5'b00100;
                        3'd2: F_logo_text_bits = 5'b00100;
                        3'd3: F_logo_text_bits = 5'b00100;
                        3'd4: F_logo_text_bits = 5'b00100;
                        3'd5: F_logo_text_bits = 5'b00100;
                        3'd6: F_logo_text_bits = 5'b11111;
                        default: F_logo_text_bits = 5'b00000;
                    endcase
                end
                4'd6: begin
                    case(I_row) // C
                        3'd0: F_logo_text_bits = 5'b01110;
                        3'd1: F_logo_text_bits = 5'b10001;
                        3'd2: F_logo_text_bits = 5'b10000;
                        3'd3: F_logo_text_bits = 5'b10000;
                        3'd4: F_logo_text_bits = 5'b10000;
                        3'd5: F_logo_text_bits = 5'b10001;
                        3'd6: F_logo_text_bits = 5'b01110;
                        default: F_logo_text_bits = 5'b00000;
                    endcase
                end
                default: F_logo_text_bits = 5'b00000;
            endcase
        end
    endfunction

    // 7-seg bit mapping: {a,b,c,d,e,f,g}
    function [6:0] F_hex7seg;
        input [3:0] I_hex;
        begin
            case(I_hex)
                4'h0: F_hex7seg = 7'b1111110;
                4'h1: F_hex7seg = 7'b0110000;
                4'h2: F_hex7seg = 7'b1101101;
                4'h3: F_hex7seg = 7'b1111001;
                4'h4: F_hex7seg = 7'b0110011;
                4'h5: F_hex7seg = 7'b1011011;
                4'h6: F_hex7seg = 7'b1011111;
                4'h7: F_hex7seg = 7'b1110000;
                4'h8: F_hex7seg = 7'b1111111;
                4'h9: F_hex7seg = 7'b1111011;
                4'ha: F_hex7seg = 7'b1110111;
                4'hb: F_hex7seg = 7'b0011111;
                4'hc: F_hex7seg = 7'b1001110;
                4'hd: F_hex7seg = 7'b0111101;
                4'he: F_hex7seg = 7'b1001111;
                4'hf: F_hex7seg = 7'b1000111;
                default: F_hex7seg = 7'b0000000;
            endcase
        end
    endfunction

    // Exact fixed-cell scaling. A 24-pixel extent maps onto 16 glyph bits.
    // All five-bit inputs are defined; only 0..23 are visible in this layout.
    function [3:0] F_scale24;
        input [4:0] local_coord;
        begin
            case(local_coord)
                5'd0: F_scale24 = 4'd0;
                5'd1: F_scale24 = 4'd0;
                5'd2: F_scale24 = 4'd1;
                5'd3: F_scale24 = 4'd2;
                5'd4: F_scale24 = 4'd2;
                5'd5: F_scale24 = 4'd3;
                5'd6: F_scale24 = 4'd4;
                5'd7: F_scale24 = 4'd4;
                5'd8: F_scale24 = 4'd5;
                5'd9: F_scale24 = 4'd6;
                5'd10: F_scale24 = 4'd6;
                5'd11: F_scale24 = 4'd7;
                5'd12: F_scale24 = 4'd8;
                5'd13: F_scale24 = 4'd8;
                5'd14: F_scale24 = 4'd9;
                5'd15: F_scale24 = 4'd10;
                5'd16: F_scale24 = 4'd10;
                5'd17: F_scale24 = 4'd11;
                5'd18: F_scale24 = 4'd12;
                5'd19: F_scale24 = 4'd12;
                5'd20: F_scale24 = 4'd13;
                5'd21: F_scale24 = 4'd14;
                5'd22: F_scale24 = 4'd14;
                5'd23: F_scale24 = 4'd15;
                5'd24: F_scale24 = 4'd0;
                5'd25: F_scale24 = 4'd0;
                5'd26: F_scale24 = 4'd1;
                5'd27: F_scale24 = 4'd2;
                5'd28: F_scale24 = 4'd2;
                5'd29: F_scale24 = 4'd3;
                5'd30: F_scale24 = 4'd4;
                5'd31: F_scale24 = 4'd4;
                default: F_scale24 = 4'd0;
            endcase
        end
    endfunction

    function [4:0] F_cnt_label_bits;
        input [1:0] I_idx;
        input [2:0] I_row;
        begin
            case(I_idx)
                2'd0: begin // C
                    case(I_row)
                        3'd0: F_cnt_label_bits = 5'b01110;
                        3'd1: F_cnt_label_bits = 5'b10001;
                        3'd2: F_cnt_label_bits = 5'b10000;
                        3'd3: F_cnt_label_bits = 5'b10000;
                        3'd4: F_cnt_label_bits = 5'b10000;
                        3'd5: F_cnt_label_bits = 5'b10001;
                        3'd6: F_cnt_label_bits = 5'b01110;
                        default: F_cnt_label_bits = 5'b00000;
                    endcase
                end
                2'd1: begin // N
                    case(I_row)
                        3'd0: F_cnt_label_bits = 5'b10001;
                        3'd1: F_cnt_label_bits = 5'b11001;
                        3'd2: F_cnt_label_bits = 5'b10101;
                        3'd3: F_cnt_label_bits = 5'b10011;
                        3'd4: F_cnt_label_bits = 5'b10001;
                        3'd5: F_cnt_label_bits = 5'b10001;
                        3'd6: F_cnt_label_bits = 5'b10001;
                        default: F_cnt_label_bits = 5'b00000;
                    endcase
                end
                2'd2: begin // T
                    case(I_row)
                        3'd0: F_cnt_label_bits = 5'b11111;
                        3'd1: F_cnt_label_bits = 5'b00100;
                        3'd2: F_cnt_label_bits = 5'b00100;
                        3'd3: F_cnt_label_bits = 5'b00100;
                        3'd4: F_cnt_label_bits = 5'b00100;
                        3'd5: F_cnt_label_bits = 5'b00100;
                        3'd6: F_cnt_label_bits = 5'b00100;
                        default: F_cnt_label_bits = 5'b00000;
                    endcase
                end
                default: begin // ':'
                    case(I_row)
                        3'd2: F_cnt_label_bits = 5'b00100;
                        3'd5: F_cnt_label_bits = 5'b00100;
                        default: F_cnt_label_bits = 5'b00000;
                    endcase
                end
            endcase
        end
    endfunction

    // Minimal 16x16 Chinese bitmap rows for "an" and "lu".
    function [15:0] F_cn16_row;
        input I_char; // 0: an, 1: lu
        input [3:0] I_row;
        begin
            if(!I_char) begin
                case(I_row)
                    4'd0:  F_cn16_row = 16'h0200;
                    4'd1:  F_cn16_row = 16'h7ff0;
                    4'd2:  F_cn16_row = 16'h4410;
                    4'd3:  F_cn16_row = 16'h0400;
                    4'd4:  F_cn16_row = 16'h7ff0;
                    4'd5:  F_cn16_row = 16'h0840;
                    4'd6:  F_cn16_row = 16'h1040;
                    4'd7:  F_cn16_row = 16'h1c80;
                    4'd8:  F_cn16_row = 16'h0300;
                    4'd9:  F_cn16_row = 16'h0cc0;
                    4'd10: F_cn16_row = 16'h7020;
                    4'd11: F_cn16_row = 16'h0000;
                    4'd12: F_cn16_row = 16'h0000;
                    4'd13: F_cn16_row = 16'h0000;
                    4'd14: F_cn16_row = 16'h0000;
                    4'd15: F_cn16_row = 16'h0000;
                    default: F_cn16_row = 16'h0000;
                endcase
            end
            else begin
                case(I_row)
                    4'd0:  F_cn16_row = 16'h79e0;
                    4'd1:  F_cn16_row = 16'h4a20;
                    4'd2:  F_cn16_row = 16'h4d40;
                    4'd3:  F_cn16_row = 16'h7880;
                    4'd4:  F_cn16_row = 16'h1140;
                    4'd5:  F_cn16_row = 16'h1630;
                    4'd6:  F_cn16_row = 16'h5be0;
                    4'd7:  F_cn16_row = 16'h5220;
                    4'd8:  F_cn16_row = 16'h5220;
                    4'd9:  F_cn16_row = 16'h5be0;
                    4'd10: F_cn16_row = 16'h6220;
                    4'd11: F_cn16_row = 16'h0000;
                    4'd12: F_cn16_row = 16'h0000;
                    4'd13: F_cn16_row = 16'h0000;
                    4'd14: F_cn16_row = 16'h0000;
                    4'd15: F_cn16_row = 16'h0000;
                    default: F_cn16_row = 16'h0000;
                endcase
            end
        end
    endfunction

    function [4:0] F_dyn_char_bits;
        input [3:0] I_char;
        input [2:0] I_row;
        begin
            case(I_char)
                4'h0: begin case(I_row) 3'd0:F_dyn_char_bits=5'b01110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b10011; 3'd3:F_dyn_char_bits=5'b10101; 3'd4:F_dyn_char_bits=5'b11001; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b01110; default:F_dyn_char_bits=5'b00000; endcase end
                4'h1: begin case(I_row) 3'd0:F_dyn_char_bits=5'b00100; 3'd1:F_dyn_char_bits=5'b01100; 3'd2:F_dyn_char_bits=5'b00100; 3'd3:F_dyn_char_bits=5'b00100; 3'd4:F_dyn_char_bits=5'b00100; 3'd5:F_dyn_char_bits=5'b00100; 3'd6:F_dyn_char_bits=5'b01110; default:F_dyn_char_bits=5'b00000; endcase end
                4'h2: begin case(I_row) 3'd0:F_dyn_char_bits=5'b01110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b00001; 3'd3:F_dyn_char_bits=5'b00110; 3'd4:F_dyn_char_bits=5'b01000; 3'd5:F_dyn_char_bits=5'b10000; 3'd6:F_dyn_char_bits=5'b11111; default:F_dyn_char_bits=5'b00000; endcase end
                4'h3: begin case(I_row) 3'd0:F_dyn_char_bits=5'b11110; 3'd1:F_dyn_char_bits=5'b00001; 3'd2:F_dyn_char_bits=5'b00001; 3'd3:F_dyn_char_bits=5'b01110; 3'd4:F_dyn_char_bits=5'b00001; 3'd5:F_dyn_char_bits=5'b00001; 3'd6:F_dyn_char_bits=5'b11110; default:F_dyn_char_bits=5'b00000; endcase end
                4'h4: begin case(I_row) 3'd0:F_dyn_char_bits=5'b00010; 3'd1:F_dyn_char_bits=5'b00110; 3'd2:F_dyn_char_bits=5'b01010; 3'd3:F_dyn_char_bits=5'b10010; 3'd4:F_dyn_char_bits=5'b11111; 3'd5:F_dyn_char_bits=5'b00010; 3'd6:F_dyn_char_bits=5'b00010; default:F_dyn_char_bits=5'b00000; endcase end
                4'h5: begin case(I_row) 3'd0:F_dyn_char_bits=5'b11111; 3'd1:F_dyn_char_bits=5'b10000; 3'd2:F_dyn_char_bits=5'b11110; 3'd3:F_dyn_char_bits=5'b00001; 3'd4:F_dyn_char_bits=5'b00001; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b01110; default:F_dyn_char_bits=5'b00000; endcase end
                4'h6: begin case(I_row) 3'd0:F_dyn_char_bits=5'b00110; 3'd1:F_dyn_char_bits=5'b01000; 3'd2:F_dyn_char_bits=5'b10000; 3'd3:F_dyn_char_bits=5'b11110; 3'd4:F_dyn_char_bits=5'b10001; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b01110; default:F_dyn_char_bits=5'b00000; endcase end
                4'h7: begin case(I_row) 3'd0:F_dyn_char_bits=5'b11111; 3'd1:F_dyn_char_bits=5'b00001; 3'd2:F_dyn_char_bits=5'b00010; 3'd3:F_dyn_char_bits=5'b00100; 3'd4:F_dyn_char_bits=5'b01000; 3'd5:F_dyn_char_bits=5'b01000; 3'd6:F_dyn_char_bits=5'b01000; default:F_dyn_char_bits=5'b00000; endcase end
                4'h8: begin case(I_row) 3'd0:F_dyn_char_bits=5'b01110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b10001; 3'd3:F_dyn_char_bits=5'b01110; 3'd4:F_dyn_char_bits=5'b10001; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b01110; default:F_dyn_char_bits=5'b00000; endcase end
                4'h9: begin case(I_row) 3'd0:F_dyn_char_bits=5'b01110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b10001; 3'd3:F_dyn_char_bits=5'b01111; 3'd4:F_dyn_char_bits=5'b00001; 3'd5:F_dyn_char_bits=5'b00010; 3'd6:F_dyn_char_bits=5'b11100; default:F_dyn_char_bits=5'b00000; endcase end
                4'ha: begin case(I_row) 3'd0:F_dyn_char_bits=5'b01110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b10001; 3'd3:F_dyn_char_bits=5'b11111; 3'd4:F_dyn_char_bits=5'b10001; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b10001; default:F_dyn_char_bits=5'b00000; endcase end
                4'hb: begin case(I_row) 3'd0:F_dyn_char_bits=5'b11110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b10001; 3'd3:F_dyn_char_bits=5'b11110; 3'd4:F_dyn_char_bits=5'b10001; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b11110; default:F_dyn_char_bits=5'b00000; endcase end
                4'hc: begin case(I_row) 3'd0:F_dyn_char_bits=5'b01110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b10000; 3'd3:F_dyn_char_bits=5'b10000; 3'd4:F_dyn_char_bits=5'b10000; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b01110; default:F_dyn_char_bits=5'b00000; endcase end
                4'hd: begin case(I_row) 3'd0:F_dyn_char_bits=5'b11110; 3'd1:F_dyn_char_bits=5'b10001; 3'd2:F_dyn_char_bits=5'b10001; 3'd3:F_dyn_char_bits=5'b10001; 3'd4:F_dyn_char_bits=5'b10001; 3'd5:F_dyn_char_bits=5'b10001; 3'd6:F_dyn_char_bits=5'b11110; default:F_dyn_char_bits=5'b00000; endcase end
                4'he: begin case(I_row) 3'd0:F_dyn_char_bits=5'b11111; 3'd1:F_dyn_char_bits=5'b10000; 3'd2:F_dyn_char_bits=5'b10000; 3'd3:F_dyn_char_bits=5'b11110; 3'd4:F_dyn_char_bits=5'b10000; 3'd5:F_dyn_char_bits=5'b10000; 3'd6:F_dyn_char_bits=5'b11111; default:F_dyn_char_bits=5'b00000; endcase end
                4'hf: begin case(I_row) 3'd0:F_dyn_char_bits=5'b11111; 3'd1:F_dyn_char_bits=5'b10000; 3'd2:F_dyn_char_bits=5'b10000; 3'd3:F_dyn_char_bits=5'b11110; 3'd4:F_dyn_char_bits=5'b10000; 3'd5:F_dyn_char_bits=5'b10000; 3'd6:F_dyn_char_bits=5'b10000; default:F_dyn_char_bits=5'b00000; endcase end
                default: F_dyn_char_bits = 5'b00000;
            endcase
        end
    endfunction

    // Unified prefix character library (16x16 rows): an/lu/C/N/T/:
    function [15:0] F_osd_char16_row;
        input [7:0] I_char;
        input [3:0] I_row;
        begin
            case(I_char)
                CHAR_AN: begin
                    case(I_row)
                        4'd0:  F_osd_char16_row = 16'h0200;
                        4'd1:  F_osd_char16_row = 16'h7ff0;
                        4'd2:  F_osd_char16_row = 16'h4410;
                        4'd3:  F_osd_char16_row = 16'h0400;
                        4'd4:  F_osd_char16_row = 16'h7ff0;
                        4'd5:  F_osd_char16_row = 16'h0840;
                        4'd6:  F_osd_char16_row = 16'h1040;
                        4'd7:  F_osd_char16_row = 16'h1c80;
                        4'd8:  F_osd_char16_row = 16'h0300;
                        4'd9:  F_osd_char16_row = 16'h0cc0;
                        4'd10: F_osd_char16_row = 16'h7020;
                        default: F_osd_char16_row = 16'h0000;
                    endcase
                end
                CHAR_LU: begin
                    case(I_row)
                        4'd0:  F_osd_char16_row = 16'h79e0;
                        4'd1:  F_osd_char16_row = 16'h4a20;
                        4'd2:  F_osd_char16_row = 16'h4d40;
                        4'd3:  F_osd_char16_row = 16'h7880;
                        4'd4:  F_osd_char16_row = 16'h1140;
                        4'd5:  F_osd_char16_row = 16'h1630;
                        4'd6:  F_osd_char16_row = 16'h5be0;
                        4'd7:  F_osd_char16_row = 16'h5220;
                        4'd8:  F_osd_char16_row = 16'h5220;
                        4'd9:  F_osd_char16_row = 16'h5be0;
                        4'd10: F_osd_char16_row = 16'h6220;
                        default: F_osd_char16_row = 16'h0000;
                    endcase
                end
                CHAR_C: begin
                    case(I_row)
                        4'd2:  F_osd_char16_row = 16'h03f0;
                        4'd3:  F_osd_char16_row = 16'h0c0c;
                        4'd4:  F_osd_char16_row = 16'h1800;
                        4'd5:  F_osd_char16_row = 16'h3000;
                        4'd6:  F_osd_char16_row = 16'h3000;
                        4'd7:  F_osd_char16_row = 16'h3000;
                        4'd8:  F_osd_char16_row = 16'h3000;
                        4'd9:  F_osd_char16_row = 16'h3000;
                        4'd10: F_osd_char16_row = 16'h1800;
                        4'd11: F_osd_char16_row = 16'h0c0c;
                        4'd12: F_osd_char16_row = 16'h03f0;
                        default: F_osd_char16_row = 16'h0000;
                    endcase
                end
                CHAR_N: begin
                    case(I_row)
                        4'd2:  F_osd_char16_row = 16'h300c;
                        4'd3:  F_osd_char16_row = 16'h380c;
                        4'd4:  F_osd_char16_row = 16'h3c0c;
                        4'd5:  F_osd_char16_row = 16'h360c;
                        4'd6:  F_osd_char16_row = 16'h330c;
                        4'd7:  F_osd_char16_row = 16'h318c;
                        4'd8:  F_osd_char16_row = 16'h30cc;
                        4'd9:  F_osd_char16_row = 16'h306c;
                        4'd10: F_osd_char16_row = 16'h303c;
                        4'd11: F_osd_char16_row = 16'h301c;
                        4'd12: F_osd_char16_row = 16'h300c;
                        default: F_osd_char16_row = 16'h0000;
                    endcase
                end
                CHAR_T: begin
                    case(I_row)
                        4'd2:  F_osd_char16_row = 16'h3ffc;
                        4'd3:  F_osd_char16_row = 16'h03c0;
                        4'd4:  F_osd_char16_row = 16'h03c0;
                        4'd5:  F_osd_char16_row = 16'h03c0;
                        4'd6:  F_osd_char16_row = 16'h03c0;
                        4'd7:  F_osd_char16_row = 16'h03c0;
                        4'd8:  F_osd_char16_row = 16'h03c0;
                        4'd9:  F_osd_char16_row = 16'h03c0;
                        4'd10: F_osd_char16_row = 16'h03c0;
                        4'd11: F_osd_char16_row = 16'h03c0;
                        4'd12: F_osd_char16_row = 16'h03c0;
                        default: F_osd_char16_row = 16'h0000;
                    endcase
                end
                CHAR_COLON: begin
                    case(I_row)
                        4'd6:  F_osd_char16_row = 16'h0180;
                        4'd7:  F_osd_char16_row = 16'h0180;
                        4'd10: F_osd_char16_row = 16'h0180;
                        4'd11: F_osd_char16_row = 16'h0180;
                        default: F_osd_char16_row = 16'h0000;
                    endcase
                end
                default: F_osd_char16_row = 16'h0000;
            endcase
        end
    endfunction

    assign O_video_rd_en = I_video_de;

    // Autonomous V0.1 algorithm: 1-cycle RGB888 to BT.601-style grayscale.
    pixel_gray_pipe u_pixel_gray_pipe (
        .clk     (I_clk),
        .rst_n   (I_rst_n),
        .valid_i (I_video_de),
        .rgb_i   (I_video_rd_data),
        .valid_o (S_gray_valid),
        .gray_o  (S_gray_pixel)
    );

    // Prefetch exactly one existing raster stage before the Logo overlay.
    wire [11:0] logo_prefetch_x = S_x_1d - LOGO_X;
    wire [11:0] logo_prefetch_y = S_y_1d - LOGO_Y;
    wire logo_prefetch_inside = S_video_de_1d &&
        S_x_1d >= LOGO_X && S_x_1d < LOGO_X + LOGO_W &&
        S_y_1d >= LOGO_Y && S_y_1d < LOGO_Y + LOGO_H;
    wire [14:0] logo_prefetch_address = logo_prefetch_inside ?
        ((logo_prefetch_y << 7) + (logo_prefetch_y << 5) + logo_prefetch_x) : 15'd0;
    anlogic_logo_palette u_anlogic_logo_rom(
        .clk(I_clk), .rst_n(I_rst_n),
        .I_addr(logo_prefetch_address), .O_pixel(S_logo_pixel)
    );

    osd_char_lib u_osd_char_lib(
        .I_char     ( S_pf_char     ),
        .I_row      ( S_pf_row      ),
        .O_row_bits ( S_pf_row_bits )
    );

    // ------------------------------------------------------------------
    // M3：颜色阈值目标检测 + 检测结果叠加
    //   接入点 = I_video_rd_data（原始 RGB888，位于灰度之前；灰度之后颜色已丢失）
    //   结果为帧末封存、下一帧显示，结果帧龄 1 帧（见 docs/interfaces.md）
    // ------------------------------------------------------------------
    wire S_det_b_valid;
    wire [31:0] S_det_b_area;
    wire [11:0] S_det_b_xmin, S_det_b_xmax, S_det_b_ymin, S_det_b_ymax;
    wire bg_valid,bg_user,bg_last,bg_allow,bg_ready,bg_busy;
    wire [23:0] bg_rgb;
    reg bg_snapshot;
    generate if(BLUE_BACKGROUND_ENABLE!=0) begin: g_background
        blue_background #(.IMG_W(IMG_WIDTH),.IMG_H(IMG_HEIGHT),.SETTLE_CYCLES(BG_SETTLE_CYCLES),
            .NOISE_CAL_ENABLE(BG_NOISE_CAL_ENABLE),.NOISE_MARGIN(BG_NOISE_MARGIN)) background (
            .clk(I_clk),.rst_n(I_rst_n),.calibrate_i(I_bg_calibrate),
            .valid_i(I_video_de),.user_i(I_video_user),.last_i(I_video_last),.rgb_i(I_video_rd_data),
            .valid_o(bg_valid),.user_o(bg_user),.last_o(bg_last),.rgb_o(bg_rgb),
            .allow_o(bg_allow),.ready_o(bg_ready),.busy_o(bg_busy));
    end else begin: g_background_bypass
        assign bg_valid=I_video_de;assign bg_user=I_video_user;assign bg_last=I_video_last;
        assign bg_rgb=I_video_rd_data;assign bg_allow=1'b1;assign bg_ready=1'b1;assign bg_busy=1'b0;
    end endgenerate
    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n) bg_snapshot<=0;
        else bg_snapshot<=bg_user;
    end

    // 运行时参数库：编辑值 → 帧尾（y=IMG_HEIGHT-1 的 last 像素）整组提交
    wire [239:0] S_eff_bus;
    wire         S_bank_committed;
    wire [31:0] S_param_version,S_result_version;wire S_result_complete;
    reg S_result_match;
    always @(posedge I_clk or negedge I_rst_n)begin
      if(!I_rst_n)S_result_match<=0;
      else if(bg_snapshot)S_result_match<=S_result_complete&&S_result_version==S_param_version;
    end
    generate if (UI_ENABLE != 0) begin: g_param_bank
        color_param_bank #(
            .IMG_H      (IMG_HEIGHT),
            .DEF_R_DIFF (DET_MIN_DIFF_R),
            .DEF_R_RG_Q5(32 + (32 >> DET_RATIO_SHIFT)),
            .DEF_R_RB_Q5(32 + (32 >> DET_RATIO_SHIFT)),
            .DEF_G_DIFF (DET_MIN_DIFF_G),
            .DEF_G_GR_Q5(32 + (32 >> DET_RATIO_SHIFT_G)),
            .DEF_G_GB_Q5(32 + (32 >> DET_RATIO_SHIFT_GB)),
            .DEF_DB_DIFF(DET_MIN_DIFF_B),
            .DEF_DB_BR_Q5(DET_B_R_RATIO_Q2 * 8),
            .DEF_DB_BG_Q5(DET_B_G_RATIO_Q2 * 8),
            .DEF_LB_DIFF(DET_LIGHT_MIN_DIFF),
            .DEF_LB_BR_Q5(DET_LIGHT_B_R_Q2 * 8),
            .DEF_LB_GR_Q5(DET_LIGHT_G_R_Q2 * 8),
            .DEF_MIN_LUMA(DET_MIN_LUMA),
            .DEF_MIN_SAT (DET_MIN_SAT),
            .DEF_MIN_AREA(DET_MIN_AREA)
        ) u_param_bank (
            .clk          (I_clk),
            .rst_n        (I_rst_n),
            .valid_i      (I_video_de),
            .last_i       (I_video_last),
            .y_i          (S_y),
            .I_edit       (I_ui_edit_bus),
            .I_commit_req (I_ui_commit_req),
            .O_eff        (S_eff_bus),
            .O_version    (S_param_version),
            .O_committed  (S_bank_committed)
        );
    end else begin: g_no_param_bank
        assign S_eff_bus = 240'd0;
        assign S_bank_committed = 1'b0;
        assign S_param_version = 0;
    end endgenerate
    assign O_param_eff       = S_eff_bus;
    assign O_param_version = S_param_version;
    assign O_param_committed = S_bank_committed;
    color_detect_box #(
        .IMG_W      (IMG_WIDTH),
        .IMG_H      (IMG_HEIGHT),
        .RATIO_SHIFT  (DET_RATIO_SHIFT),
        .RATIO_SHIFT_G (DET_RATIO_SHIFT_G),
        .RATIO_SHIFT_GB(DET_RATIO_SHIFT_GB),
        .B_R_RATIO_Q2(DET_B_R_RATIO_Q2),
        .B_G_RATIO_Q2(DET_B_G_RATIO_Q2),
        .MIN_DIFF_B(DET_MIN_DIFF_B),
        .EXTENDED_BLUE(DET_EXTENDED_BLUE),
        .USE_BLUE_GATE(BLUE_BACKGROUND_ENABLE),
        .LIGHT_B_R_Q2(DET_LIGHT_B_R_Q2),
        .LIGHT_G_R_Q2(DET_LIGHT_G_R_Q2),
        .LIGHT_MIN_DIFF(DET_LIGHT_MIN_DIFF),
        .LIGHT_BALANCE_SHIFT(DET_LIGHT_BALANCE_SHIFT),
        .MIN_ROW_CNT_B(DET_MIN_ROW_CNT_B),
        .MIN_ROW_RUN_B(DET_MIN_ROW_RUN_B),
        .MIN_DIFF_R (DET_MIN_DIFF_R),
        .MIN_DIFF_G (DET_MIN_DIFF_G),
        .MIN_SAT    (DET_MIN_SAT),
        .MIN_LUMA   (DET_MIN_LUMA),
        .MIN_AREA   (DET_MIN_AREA),
        .STAT_DECIM (4),
        .MIN_RUN    (3),
        .MIN_ROW_CNT(DET_MIN_ROW_CNT),
        .MIN_ROW_CNT_G(DET_MIN_ROW_CNT_G),
        .MIN_ROW_RUN_G(DET_MIN_ROW_RUN_G),
        .RUNTIME_PARAM_EN(UI_ENABLE)
    ) u_color_detect_box (
        .clk       (I_clk),
        .rst_n     (I_rst_n),
        .valid_i   (bg_valid),
        .user_i    (bg_user),
        .last_i    (bg_last),
        .rgb_i     (bg_rgb),
        .I_param_bus(S_eff_bus),
        .I_param_version(S_param_version),.O_result_version(S_result_version),.O_result_complete(S_result_complete),

        .blue_allow_i(bg_allow),
        .O_pixel_hit(S_pixel_hit),
        .o_r_valid (S_det_r_valid),
        .o_r_area  (S_det_r_area),
        .o_r_xmin  (S_det_r_xmin),
        .o_r_xmax  (S_det_r_xmax),
        .o_r_ymin  (S_det_r_ymin),
        .o_r_ymax  (S_det_r_ymax),

        .o_g_valid (S_det_g_valid),
        .o_g_area  (S_det_g_area),
        .o_g_xmin  (S_det_g_xmin),
        .o_g_xmax  (S_det_g_xmax),
        .o_g_ymin  (S_det_g_ymin),
        .o_g_ymax  (S_det_g_ymax),
        .o_b_valid(S_det_b_valid),
        .o_b_area(S_det_b_area),
        .o_b_xmin(S_det_b_xmin),
        .o_b_xmax(S_det_b_xmax),
        .o_b_ymin(S_det_b_ymin),
        .o_b_ymax(S_det_b_ymax)
    );

    // 坐标送 S_x_2d / S_y_2d：与既有 OSD（Logo/文字/计数）同一相位。
    // S_x/S_y 的值即"本拍像素"坐标；O_hdmi_data 比输入晚 3 拍，判定用两拍前的
    // 坐标寄存器值，正好与输出像素严格对齐（见 docs/source_map.md §3.2）。
    detect_osd #(
        .IMG_W     (IMG_WIDTH),
        .IMG_H     (IMG_HEIGHT),
        .BOX_W     (3),
        .COLOR_RED (24'hff0000),
        .COLOR_GRN (24'h00ff00),
        .COLOR_LBL (24'hffffff),
        .COLOR_CTR (24'hffd000),
        .CX_BASE   (96)
    ) u_detect_osd (
        .clk       (I_clk),
        .rst_n     (I_rst_n),
        // 检测结果在 I_video_user 同拍由非阻塞赋值封存；次拍才读取该快照。
        // 中心值和字符码随后分两拍更新，框线与文字使用同一帧检测结果。
        .user_i    (bg_snapshot),
        .de_i      (S_video_de_2d),
        .x_i       (S_x_2d),
        .y_i       (S_y_2d),

        .r_valid_i (S_det_r_valid),
        .r_area_i  (S_det_r_area),
        .r_xmin_i  (S_det_r_xmin),
        .r_xmax_i  (S_det_r_xmax),
        .r_ymin_i  (S_det_r_ymin),
        .r_ymax_i  (S_det_r_ymax),

        .g_valid_i (S_det_g_valid),
        .g_area_i  (S_det_g_area),
        .g_xmin_i  (S_det_g_xmin),
        .g_xmax_i  (S_det_g_xmax),
        .g_ymin_i  (S_det_g_ymin),
        .g_ymax_i  (S_det_g_ymax),
        .b_valid_i(S_det_b_valid && bg_ready),
        .b_area_i(S_det_b_area),
        .b_xmin_i(S_det_b_xmin),
        .b_xmax_i(S_det_b_xmax),
        .b_ymin_i(S_det_b_ymin),
        .b_ymax_i(S_det_b_ymax),


        .hit_o     (S_det_hit),
        .color_o   (S_det_color)
    );

    // ------------------------------------------------------------------
    // 状态显示（本工程自研，2026-10）：右上角显示分辨率 + 实时帧率
    //   位置 x[992,1248) y[0,64)，避开 Logo(x<160)、DYN_OSD(x 375..575) 与检测标签行(y>=640)
    //   优先级低于检测框（框更重要），高于原始像素
    // ------------------------------------------------------------------
    wire bg_status_hit;
    wire native_status_hit;
    wire [23:0] native_status_color;
    generate if(BLUE_BACKGROUND_ENABLE!=0) begin: g_background_hint
        background_status_osd hint (
            .clk(I_clk),.rst_n(I_rst_n),.user_i(I_video_user),
            .de_i(S_video_de_2d),.x_i(S_x_2d),.y_i(S_y_2d),
            .ready_i(bg_ready),.busy_i(bg_busy),.hit_o(bg_status_hit));
    end else begin: g_no_background_hint
        assign bg_status_hit=1'b0;
    end endgenerate
    wire        S_sts_hit;
    wire [23:0] S_sts_color;
    assign S_sts_hit=native_status_hit || bg_status_hit;
    assign S_sts_color=native_status_hit ? native_status_color : 24'h0080ff;

    status_osd #(
        .AE_ENABLE(AE_DEBUG_ENABLE),
        .DDR_DIAG_ENABLE(DDR_DIAG_ENABLE),
        .IMG_W  (IMG_WIDTH),
        .IMG_H  (IMG_HEIGHT),
        .BASE_X (992),
        .BASE_Y (0),
        .CLK_HZ (75000000),          // 像素时钟 75 MHz（见 source_map.md）
        .COLOR  (24'h1ff01f)
    ) u_status_osd (
        .ae_i(I_ae_status),
        .ddr_i(I_ddr_status),
        .clk     (I_clk),
        .rst_n   (I_rst_n),
        .de_i    (S_video_de_2d),
        .user_i  (I_video_user),     // 帧首，仅用于帧率统计
        .x_i     (S_x_2d),
        .y_i     (S_y_2d),
        .fill_active_i(S_fill_eff),
        .fill_run_count_i(fill_run_count),
        .fill_overflow_i(fill_overflow),
        .fill_edit_i(S_fill_edit),
        .fill_sel_i(S_fill_param_sel),
        .fill_filter_i(S_fill_filter_cfg),
        .fill_gap_i(S_fill_gap_cfg),
        .fill_gap_count_i(S_fill_gap_count_cfg),
        .fill_border_i(S_fill_border_cfg),
        .fill_minw_i(S_fill_minw_cfg),
        .hit_o   (native_status_hit),
        .color_o (native_status_color),
        .fps_o   ()
    );

    // ------------------------------------------------------------------
    // 3×3 邻域 Sobel 边缘检测（边缘档的数据源；工程规划 §6.1 与 T03）
    //   输入取灰度流（pixel_gray_pipe 的寄存输出，比 I_video_de 晚 1 拍），
    //   因此 user_i / last_i 用同相位的 1 拍延迟版本 S_video_user_1d / S_video_last_1d。
    //   sobel3x3 输出相对其输入晚 3 拍 → 相对 I_video_de 晚 4 拍，
    //   与"末级统一再延迟 2 拍"后的输出（既有 2 拍 + 2 拍 = 4 拍）正好对齐。
    // ------------------------------------------------------------------
    wire        S_edge_valid;
    wire [7:0]  S_edge_pixel;

    wire smooth_valid,smooth_user,smooth_last;
    wire [7:0] smooth_gray;
    wire [11:0] edge_x,edge_y;
    wire gradient_valid,gradient_user,gradient_last;
    wire [12:0] gradient_word;
    wire [1:0] gradient_fine;
    wire gradient_polarity;
    wire refined_valid,refined_bit,detected_bit;
    wire [11:0] refined_x,refined_y;
    generate if(EDGE_DENOISE_ENABLE!=0 && EDGE_REFINE_ENABLE!=0)begin: g_refinement
        edge_refine #(.IMG_W(IMG_WIDTH),.IMG_H(IMG_HEIGHT),.FULL_PRECISION(EDGE_PRECISE_ENABLE),.COHERENCE_ENABLE(EDGE_COHERENCE_ENABLE),.TANGENT_SUPPORT_ENABLE(EDGE_OPT_ENABLE)) refine (
            .clk(I_clk),.rst_n(I_rst_n),.valid_i(gradient_valid),.user_i(gradient_user),
            .last_i(gradient_last),.gradient_i(gradient_word),.fine_i(gradient_fine),.polarity_i(gradient_polarity),.valid_o(refined_valid),
            .edge_o(refined_bit),.detection_o(detected_bit),.x_o(refined_x),.y_o(refined_y));
    end else begin: g_refinement_bypass
        assign refined_valid=1'b0;assign refined_bit=1'b0;assign detected_bit=1'b0;
        assign refined_x=12'd0;assign refined_y=12'd0;
    end endgenerate
    generate if(EDGE_DENOISE_ENABLE!=0) begin: g_smoothing
        gray_gaussian3x3 #(.IMG_W(IMG_WIDTH),.IMG_H(IMG_HEIGHT)) gaussian (
            .clk(I_clk),.rst_n(I_rst_n),.valid_i(S_gray_valid),
            .user_i(S_video_user_1d),.last_i(S_video_last_1d),.gray_i(S_gray_pixel),
            .valid_o(smooth_valid),.user_o(smooth_user),.last_o(smooth_last),.gray_o(smooth_gray));
    end else begin: g_smoothing_bypass
        assign smooth_valid=S_gray_valid;assign smooth_user=S_video_user_1d;
        assign smooth_last=S_video_last_1d;assign smooth_gray=S_gray_pixel;
    end endgenerate
    sobel3x3 #(
        .IMG_W   (IMG_WIDTH),
        .IMG_H   (IMG_HEIGHT),
        .TH      (EDGE_OPT_ENABLE!=0 ? 80 : (EDGE_DENOISE_ENABLE!=0 ? 96 : 128)),      // 明亮区域使用的阈值上限
        .OUT_BIN (1),
        .ADAPTIVE_TH (1),
        .TH_SCALE_Q2(EDGE_OPT_ENABLE!=0 ? 2 : (EDGE_DENOISE_ENABLE!=0 ? 3 : 4)),
        .TH_MIN  (EDGE_OPT_ENABLE!=0 ? 48 : 32) // Optimized high threshold: clamp(local luma/2,48,80)
    ) u_sobel3x3 (
        .clk     (I_clk),
        .rst_n   (I_rst_n),
        .valid_i (smooth_valid),
        .user_i  (smooth_user),
        .last_i  (smooth_last),
        .gray_i  (smooth_gray),
        .valid_o (S_edge_valid),
        .edge_o  (S_edge_pixel),
        .x_o     (edge_x),
        .y_o     (edge_y),
        .raster_valid_o(gradient_valid),.raster_user_o(gradient_user),.raster_last_o(gradient_last),
        .gradient_o(gradient_word),.gradient_fine_o(gradient_fine),.gradient_polarity_o(gradient_polarity)
    );

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n) begin
            S_x <= 12'd0;
            S_y <= 12'd0;
        end
        else if(I_video_user) begin
            S_x <= 12'd0;
            S_y <= 12'd0;
        end
        else if(I_video_de) begin
            if(I_video_last) begin
                S_x <= 12'd0;
                S_y <= S_y + 12'd1;
            end
            else begin
                S_x <= S_x + 12'd1;
            end
        end
    end

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n) begin
            S_frame_cnt <= 32'd0;
            S_cnt_d0 <= 4'd0;
            S_cnt_d1 <= 4'd0;
            S_cnt_d2 <= 4'd0;
            S_cnt_d3 <= 4'd0;
            S_cnt_d4 <= 4'd0;
            S_cnt_d5 <= 4'd0;
        end
        else if(I_video_user) begin
            S_frame_cnt <= S_frame_cnt + 32'd1;
            if(S_cnt_d0 == 4'd9) begin
                S_cnt_d0 <= 4'd0;
                if(S_cnt_d1 == 4'd9) begin
                    S_cnt_d1 <= 4'd0;
                    if(S_cnt_d2 == 4'd9) begin
                        S_cnt_d2 <= 4'd0;
                        if(S_cnt_d3 == 4'd9) begin
                            S_cnt_d3 <= 4'd0;
                            if(S_cnt_d4 == 4'd9) begin
                                S_cnt_d4 <= 4'd0;
                                if(S_cnt_d5 == 4'd9)
                                    S_cnt_d5 <= 4'd0;
                                else
                                    S_cnt_d5 <= S_cnt_d5 + 4'd1;
                            end
                            else
                                S_cnt_d4 <= S_cnt_d4 + 4'd1;
                        end
                        else
                            S_cnt_d3 <= S_cnt_d3 + 4'd1;
                    end
                    else
                        S_cnt_d2 <= S_cnt_d2 + 4'd1;
                end
                else
                    S_cnt_d1 <= S_cnt_d1 + 4'd1;
            end
            else
                S_cnt_d0 <= S_cnt_d0 + 4'd1;
        end
    end

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n) begin
            S_x_1d <= 12'd0;
            S_x_2d <= 12'd0;
            S_y_1d <= 12'd0;
            S_y_2d <= 12'd0;
        end
        else begin
            S_x_1d <= S_x;
            S_x_2d <= S_x_1d;
            S_y_1d <= S_y;
            S_y_2d <= S_y_1d;
        end
    end

    always @(*) begin
        S_osd_hit   = 1'b0;
        S_osd_color = 24'd0;
        S_logo_addr = 15'd0;

        S_logo_x = 12'd0;
        S_logo_y = 12'd0;
        S_char_idx = 4'd0;
        S_char_row = 3'd0;
        S_char_col = 3'd0;
        S_char_bits = 5'd0;
        S_char_on = 1'b0;
        S_logo_blue_on = 1'b0;
        S_logo_red_on = 1'b0;
        S_logo_tmp_y = 12'd0;
        S_logo_red_band = 4'd0;
        S_logo_red_x_start = 12'd0;
        S_logo_red_x_end = 12'd0;
        S_dyn_x = 12'd0;
        S_dyn_y = 12'd0;
        S_dyn_char = 4'd0;
        S_dyn_col = 3'd0;
        S_dyn_row = 3'd0;
        S_dyn_bits = 5'd0;
        S_dyn_on = 1'b0;
        S_dyn_digit_idx = 4'd0;
        S_dyn_digit_x = 12'd0;
        S_dyn_seg = 7'd0;
        S_lbl_row = 3'd0;
        S_lbl_col = 3'd0;
        S_lbl_idx = 2'd0;
        S_lbl_bits = 5'd0;
        S_lbl_local_x = 7'd0;
        S_dyn_dec_digit = 4'd0;
        S_cn_local_x = 5'd0;
        S_cn_local_y = 5'd0;
        S_cn_col = 4'd0;
        S_cn_row = 4'd0;
        S_cn_row_bits = 16'd0;
        S_cn_on = 1'b0;
        S_cn_scale_x = 10'd0;
        S_cn_scale_y = 10'd0;
        S_pf_char = 8'd0;
        S_pf_local_x = 5'd0;
        S_pf_local_y = 5'd0;
        S_pf_col = 4'd0;
        S_pf_row = 4'd0;
        S_pf_on = 1'b0;
        S_pf_scale_x = 10'd0;
        S_pf_scale_y = 10'd0;

        if(S_video_de_2d) begin
            if((S_x_2d >= LOGO_X) && (S_x_2d < (LOGO_X + LOGO_W)) &&
               (S_y_2d >= LOGO_Y) && (S_y_2d < (LOGO_Y + LOGO_H))) begin
                S_logo_x = S_x_2d - LOGO_X;
                S_logo_y = S_y_2d - LOGO_Y;
                // 160 = 128 + 32：用移位加法代替乘法器，避免 DSP 落在
                // logo 地址 -> ROM -> OSD 颜色这条 15 级组合路径上（时序收敛用）
                S_logo_addr = (S_logo_y << 7) + (S_logo_y << 5) + S_logo_x;
                if(S_logo_pixel[24]) begin
                    S_osd_hit   = 1'b1;
                    S_osd_color = S_logo_pixel[23:0];
                end
            end

            if((!S_osd_hit) &&
               (S_x_2d >= DYN_OSD_X) && (S_x_2d < (DYN_OSD_X + DYN_OSD_W)) &&
               (S_y_2d >= DYN_OSD_Y) && (S_y_2d < (DYN_OSD_Y + DYN_OSD_H))) begin
                S_dyn_x = S_x_2d - DYN_OSD_X;
                S_dyn_y = S_y_2d - DYN_OSD_Y;

                // Unified prefix render using one character library.
                // an:[0..23], lu:[24..47], C:[52..67], N:[68..83], T:[84..99], :[100..107]
                if((S_dyn_x < 12'd108) && (S_dyn_y < 12'd24)) begin
                    if((S_dyn_x < 12'd24) || ((S_dyn_x >= 12'd24) && (S_dyn_x < 12'd48))) begin
                        if(S_dyn_y >= CN_Y_OFFSET)
                            S_pf_local_y = S_dyn_y - CN_Y_OFFSET;
                        else
                            S_pf_local_y = 5'd31;

                        if(S_dyn_x < 12'd24) begin
                            S_pf_char = CHAR_AN;
                            S_pf_local_x = S_dyn_x;
                        end
                        else begin
                            S_pf_char = CHAR_LU;
                            S_pf_local_x = S_dyn_x - 12'd24;
                        end

                        if((S_pf_local_x < 5'd24) && (S_pf_local_y < 5'd24)) begin
                            S_pf_scale_x = S_pf_local_x * 10'd16;
                            S_pf_scale_y = S_pf_local_y * 10'd16;
                            S_pf_col = F_scale24(S_pf_local_x);
                            S_pf_row = F_scale24(S_pf_local_y);
                            case(S_pf_col)
                                4'd0:  S_pf_on = S_pf_row_bits[15];
                                4'd1:  S_pf_on = S_pf_row_bits[14];
                                4'd2:  S_pf_on = S_pf_row_bits[13];
                                4'd3:  S_pf_on = S_pf_row_bits[12];
                                4'd4:  S_pf_on = S_pf_row_bits[11];
                                4'd5:  S_pf_on = S_pf_row_bits[10];
                                4'd6:  S_pf_on = S_pf_row_bits[9];
                                4'd7:  S_pf_on = S_pf_row_bits[8];
                                4'd8:  S_pf_on = S_pf_row_bits[7];
                                4'd9:  S_pf_on = S_pf_row_bits[6];
                                4'd10: S_pf_on = S_pf_row_bits[5];
                                4'd11: S_pf_on = S_pf_row_bits[4];
                                4'd12: S_pf_on = S_pf_row_bits[3];
                                4'd13: S_pf_on = S_pf_row_bits[2];
                                4'd14: S_pf_on = S_pf_row_bits[1];
                                4'd15: S_pf_on = S_pf_row_bits[0];
                                default: S_pf_on = 1'b0;
                            endcase
                        end
                    end
                    else if((S_dyn_x >= 12'd52) && (S_dyn_x < 12'd100) && (S_dyn_y >= 12'd4) && (S_dyn_y < 12'd20)) begin
                        if(S_dyn_x < 12'd68) begin
                            S_pf_char = CHAR_C;
                            S_pf_local_x = S_dyn_x - 12'd52;
                        end
                        else if(S_dyn_x < 12'd84) begin
                            S_pf_char = CHAR_N;
                            S_pf_local_x = S_dyn_x - 12'd68;
                        end
                        else begin
                            S_pf_char = CHAR_T;
                            S_pf_local_x = S_dyn_x - 12'd84;
                        end
                        S_pf_local_y = S_dyn_y - 12'd4;
                        S_pf_col = S_pf_local_x[3:0];
                        S_pf_row = S_pf_local_y[3:0];
                        case(S_pf_col)
                            4'd0:  S_pf_on = S_pf_row_bits[15];
                            4'd1:  S_pf_on = S_pf_row_bits[14];
                            4'd2:  S_pf_on = S_pf_row_bits[13];
                            4'd3:  S_pf_on = S_pf_row_bits[12];
                            4'd4:  S_pf_on = S_pf_row_bits[11];
                            4'd5:  S_pf_on = S_pf_row_bits[10];
                            4'd6:  S_pf_on = S_pf_row_bits[9];
                            4'd7:  S_pf_on = S_pf_row_bits[8];
                            4'd8:  S_pf_on = S_pf_row_bits[7];
                            4'd9:  S_pf_on = S_pf_row_bits[6];
                            4'd10: S_pf_on = S_pf_row_bits[5];
                            4'd11: S_pf_on = S_pf_row_bits[4];
                            4'd12: S_pf_on = S_pf_row_bits[3];
                            4'd13: S_pf_on = S_pf_row_bits[2];
                            4'd14: S_pf_on = S_pf_row_bits[1];
                            4'd15: S_pf_on = S_pf_row_bits[0];
                            default: S_pf_on = 1'b0;
                        endcase
                    end
                    else if((S_dyn_x >= 12'd100) && (S_dyn_x < 12'd108) && (S_dyn_y >= 12'd4) && (S_dyn_y < 12'd20)) begin
                        S_pf_char = CHAR_COLON;
                        S_pf_local_x = S_dyn_x - 12'd100;
                        S_pf_local_y = S_dyn_y - 12'd4;
                        S_pf_scale_x = S_pf_local_x * 10'd16;
                        S_pf_col = {S_pf_local_x[2:0],1'b0};
                        S_pf_row = S_pf_local_y[3:0];
                        case(S_pf_col)
                            4'd0:  S_pf_on = S_pf_row_bits[15];
                            4'd1:  S_pf_on = S_pf_row_bits[14];
                            4'd2:  S_pf_on = S_pf_row_bits[13];
                            4'd3:  S_pf_on = S_pf_row_bits[12];
                            4'd4:  S_pf_on = S_pf_row_bits[11];
                            4'd5:  S_pf_on = S_pf_row_bits[10];
                            4'd6:  S_pf_on = S_pf_row_bits[9];
                            4'd7:  S_pf_on = S_pf_row_bits[8];
                            4'd8:  S_pf_on = S_pf_row_bits[7];
                            4'd9:  S_pf_on = S_pf_row_bits[6];
                            4'd10: S_pf_on = S_pf_row_bits[5];
                            4'd11: S_pf_on = S_pf_row_bits[4];
                            4'd12: S_pf_on = S_pf_row_bits[3];
                            4'd13: S_pf_on = S_pf_row_bits[2];
                            4'd14: S_pf_on = S_pf_row_bits[1];
                            4'd15: S_pf_on = S_pf_row_bits[0];
                            default: S_pf_on = 1'b0;
                        endcase
                    end

                    if(S_pf_on)
                        S_dyn_on = 1'b1;
                end

                // Decimal 6 digits starts at x=110. Each digit is 15x24.
                if((S_dyn_x >= 12'd110) && (S_dyn_x < 12'd200)) begin
                    if(S_dyn_x < 12'd125) begin
                        S_dyn_digit_idx = 4'd0;
                        S_dyn_digit_x = S_dyn_x - 12'd110;
                        S_dyn_dec_digit = S_cnt_d5;
                    end
                    else if(S_dyn_x < 12'd140) begin
                        S_dyn_digit_idx = 4'd1;
                        S_dyn_digit_x = S_dyn_x - 12'd125;
                        S_dyn_dec_digit = S_cnt_d4;
                    end
                    else if(S_dyn_x < 12'd155) begin
                        S_dyn_digit_idx = 4'd2;
                        S_dyn_digit_x = S_dyn_x - 12'd140;
                        S_dyn_dec_digit = S_cnt_d3;
                    end
                    else if(S_dyn_x < 12'd170) begin
                        S_dyn_digit_idx = 4'd3;
                        S_dyn_digit_x = S_dyn_x - 12'd155;
                        S_dyn_dec_digit = S_cnt_d2;
                    end
                    else if(S_dyn_x < 12'd185) begin
                        S_dyn_digit_idx = 4'd4;
                        S_dyn_digit_x = S_dyn_x - 12'd170;
                        S_dyn_dec_digit = S_cnt_d1;
                    end
                    else begin
                        S_dyn_digit_idx = 4'd5;
                        S_dyn_digit_x = S_dyn_x - 12'd185;
                        S_dyn_dec_digit = S_cnt_d0;
                    end

                    // Render decimal digits through unified 16x16 character library.
                    // Keep enlarged 15x24 box for readability.
                    if((S_dyn_digit_x < 12'd15) && (S_dyn_y < 12'd24)) begin
                        S_pf_char = CHAR_0 + {4'd0, S_dyn_dec_digit};
                        S_pf_local_x = S_dyn_digit_x[4:0];
                        S_pf_local_y = S_dyn_y[4:0];
                        S_pf_scale_x = S_pf_local_x * 10'd16;
                        S_pf_scale_y = S_pf_local_y * 10'd16;
                        // Under the existing x < 15 guard, floor(16*x/15) equals x.
                        S_pf_col = S_pf_local_x[3:0];
                        S_pf_row = F_scale24(S_pf_local_y);
                        case(S_pf_col)
                            4'd0:  S_pf_on = S_pf_row_bits[15];
                            4'd1:  S_pf_on = S_pf_row_bits[14];
                            4'd2:  S_pf_on = S_pf_row_bits[13];
                            4'd3:  S_pf_on = S_pf_row_bits[12];
                            4'd4:  S_pf_on = S_pf_row_bits[11];
                            4'd5:  S_pf_on = S_pf_row_bits[10];
                            4'd6:  S_pf_on = S_pf_row_bits[9];
                            4'd7:  S_pf_on = S_pf_row_bits[8];
                            4'd8:  S_pf_on = S_pf_row_bits[7];
                            4'd9:  S_pf_on = S_pf_row_bits[6];
                            4'd10: S_pf_on = S_pf_row_bits[5];
                            4'd11: S_pf_on = S_pf_row_bits[4];
                            4'd12: S_pf_on = S_pf_row_bits[3];
                            4'd13: S_pf_on = S_pf_row_bits[2];
                            4'd14: S_pf_on = S_pf_row_bits[1];
                            4'd15: S_pf_on = S_pf_row_bits[0];
                            default: S_pf_on = 1'b0;
                        endcase
                        if(S_pf_on)
                            S_dyn_on = 1'b1;
                    end
                end

                if(S_dyn_on) begin
                    S_osd_hit = 1'b1;
                    S_osd_color = COLOR_DYN_TEXT;
                end
            end
        end
    end

    // ==================================================================
    // 输出级（前级）：像素/同步信号的 2 拍对齐（保持与既有实现完全一致），
    //   同时生成调试图案用的 S_pre_data（DEBUG_MODE != 0 时）。
    //   正常路径的底图是 S_video_data_2d，由末级直接采样——这样它与 OSD / 检测 /
    //   状态判定（都是同一拍的组合信号）严格同步，不会引入额外的相位偏差。
    // ==================================================================
    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n) begin
            S_video_vsync_1d <= 1'b0;
            S_video_vsync_2d <= 1'b0;
            S_video_hsync_1d <= 1'b0;
            S_video_hsync_2d <= 1'b0;
            S_video_de_1d    <= 1'b0;
            S_video_de_2d    <= 1'b0;
            S_video_user_1d  <= 1'b0;
            S_video_last_1d  <= 1'b0;
            S_pre_data       <= 24'd0;
        end
        else begin
            S_video_vsync_1d <= I_video_vsync;
            S_video_vsync_2d <= S_video_vsync_1d;

            S_video_hsync_1d <= I_video_hsync;
            S_video_hsync_2d <= S_video_hsync_1d;

            S_video_de_1d    <= I_video_de;
            S_video_de_2d    <= S_video_de_1d;

            // 与 S_video_de_1d 同拍（灰度流的相位），供 sobel3x3 使用
            S_video_user_1d  <= I_video_user;
            S_video_last_1d  <= I_video_last;

            // 原图直通路径：同样打 1 拍，与灰度路径（pixel_gray_pipe 的寄存输出）
            // 保持同延迟，因此三级像素/DE/OSD 对齐关系不变。
            S_rd_data_1d <= I_video_rd_data;

            // 底图选择：灰度档 → 灰度通路；原图档 / 边缘档 → 原图直通
            // （边缘档的底图在末级被 3×3 输出替换）
            S_video_data_2d <= (S_src_eff == SRC_GRAY)
                                ? (S_gray_valid ? {S_gray_pixel, S_gray_pixel, S_gray_pixel} : 24'd0)
                                : (S_preview_active && BLUE_BACKGROUND_ENABLE==0) ? {24{S_view_hit}} : S_rd_data_1d;

            // 调试图案（只有 DEBUG_MODE != 0 时被末级使用）
            if(DEBUG_MODE == 1) begin
                if(S_video_de_2d) begin
                    if(S_x < 12'd128)
                        S_pre_data <= 24'hff0000;
                    else if(S_x < 12'd256)
                        S_pre_data <= 24'h00ff00;
                    else if(S_x < 12'd384)
                        S_pre_data <= 24'h0000ff;
                    else if(S_x < 12'd512)
                        S_pre_data <= 24'hffff00;
                    else if(S_x < 12'd640)
                        S_pre_data <= 24'h00ffff;
                    else if(S_x < 12'd768)
                        S_pre_data <= 24'hff00ff;
                    else if(S_x < 12'd896)
                        S_pre_data <= 24'hffffff;
                    else
                        S_pre_data <= 24'h202020;
                end
                else begin
                    S_pre_data <= 24'd0;
                end
            end
            else if(DEBUG_MODE == 2) begin
                if(S_video_de_2d) begin
                    case (I_debug_status)
                        4'b0000: S_pre_data <= 24'h000000;
                        4'b0001: S_pre_data <= 24'hff0000;
                        4'b0011: S_pre_data <= 24'hffff00;
                        4'b0111: S_pre_data <= 24'h00ff00;
                        4'b1111: S_pre_data <= I_video_rd_data;
                        default: S_pre_data <= 24'h0000ff;
                    endcase
                end
                else begin
                    S_pre_data <= 24'd0;
                end
            end
            else if(DEBUG_MODE == 3) begin
                if(S_video_de_2d) begin
                    if(S_x < 12'd256)
                        S_pre_data <= I_debug_status[0] ? 24'hff8000 : 24'h201000;
                    else if(S_x < 12'd512)
                        S_pre_data <= I_debug_status[1] ? 24'hffff00 : 24'h202000;
                    else if(S_x < 12'd768)
                        S_pre_data <= I_debug_status[2] ? 24'hff0000 : 24'h200000;
                    else
                        S_pre_data <= I_debug_status[3] ? 24'h00ffff : 24'h002020;
                end
                else begin
                    S_pre_data <= 24'd0;
                end
            end
            else begin
                S_pre_data <= S_video_data_2d;
            end
        end
    end

    // ------------------------------------------------------------------
    // 末级：在既有 2 拍对齐之后再统一延迟 2 拍（为「3×3 边缘档」腾出对齐空间），
    // 然后按优先级叠加覆盖层。所有被延迟的信号都取自**同一拍**（S_video_*_2d 与
    // S_*_hit），因此相对相位与原实现完全一致（由 tb_hdmi_mixer_detect 保证）。
    // 底图：边缘档用 sobel3x3 的输出（valid 时），其余档用像素通路。
    // （sobel3x3 输出与 S_pd_data 同拍——都是相对 I_video_de 晚 4 拍）
    // ------------------------------------------------------------------
    wire [23:0] S_edge_rgb = {S_edge_pixel, S_edge_pixel, S_edge_pixel};
    wire [23:0] S_base_4d  = (S_src_eff == SRC_EDGE)
                                ? (S_edge_valid ? S_edge_rgb : 24'd0)
                                : S_pd_data;

    // 覆盖优先级：既有 OSD（Logo/文字/计数） > 检测叠加 > 状态显示 > 底图
    wire [23:0] S_mix_4d   = S_pd_ohit ? S_pd_ocol :
                             (S_pd_dhit && (UI_ENABLE!=0 || S_det_eff)) ? S_pd_dcol :
                             S_pd_shit ? S_pd_scol : S_base_4d;

    // Prepare overlays before delaying the entire raster to the 5x5 center.
    wire overlay_present=S_pd_ohit || (S_pd_dhit && (UI_ENABLE!=0 || S_det_eff)) || S_pd_shit;
    wire [23:0] prepared_pixel=S_pd_ohit ? S_pd_ocol :
        ((S_pd_dhit && (UI_ENABLE!=0 || S_det_eff)) ? S_pd_dcol : (S_pd_shit ? S_pd_scol : S_pd_data));
    wire [32:0] delayed_raster;
    // Frame/line markers follow exactly the same pipeline as the prepared image.
    reg [3:0] edge_user_pipe,edge_last_pipe;
    always @(posedge I_clk or negedge I_rst_n)begin
        if(!I_rst_n)begin edge_user_pipe<=0;edge_last_pipe<=0;end
        else begin edge_user_pipe<={edge_user_pipe[2:0],I_video_user};edge_last_pipe<={edge_last_pipe[2:0],I_video_last};end
    end
    localparam integer EDGE_RASTER_DELAY=EDGE_REFINE_ENABLE!=0 ? 3*H_TOTAL+8+(EDGE_COHERENCE_ENABLE!=0 ? 2 : 0) : 2*H_TOTAL+4;
    generate if(EDGE_DENOISE_ENABLE!=0) begin: g_center_alignment
        video_stream_delay #(.WIDTH(33),.DELAY(EDGE_RASTER_DELAY)) raster_delay (
            .clk(I_clk),.rst_n(I_rst_n),
            .data_i({S_fill_eff,S_extract_eff,edge_user_pipe[3],edge_last_pipe[3],S_pd_vsync,S_pd_hsync,S_pd_de,(S_src_eff==SRC_EDGE),overlay_present,prepared_pixel}),
            .data_o(delayed_raster));
    end else begin: g_center_bypass
        assign delayed_raster=33'd0;
    end endgenerate
    wire centered_edge_valid=S_edge_valid && edge_x>=3 && edge_y>=3;
    wire [23:0] centered_edge=EDGE_REFINE_ENABLE!=0 ?
        (refined_valid && refined_bit ? 24'hffffff : 24'd0) :
        (centered_edge_valid ? S_edge_rgb : 24'd0);
    reg [11:0] extraction_x,extraction_y;
    wire extraction_active=EDGE_DENOISE_ENABLE!=0 && delayed_raster[26];
    always @(posedge I_clk or negedge I_rst_n)begin
        if(!I_rst_n)begin extraction_x<=0;extraction_y<=0;end
        else if(extraction_active)begin
            if(delayed_raster[30])begin extraction_x<=1;extraction_y<=0;end
            else if(delayed_raster[29])begin extraction_x<=0;extraction_y<=extraction_y+1'b1;end
            else extraction_x<=extraction_x+1'b1;
        end
    end
    assign O_edge_valid=extraction_active;
    assign O_edge_user=extraction_active && delayed_raster[30];
    assign O_edge_last=extraction_active && delayed_raster[29];
    assign O_edge_x=delayed_raster[30] ? 12'd0 : extraction_x;
    assign O_edge_y=delayed_raster[30] ? 12'd0 : extraction_y;
    assign O_edge_bit=extraction_active && centered_edge[0];
    generate if(EDGE_DENOISE_ENABLE!=0 && EDGE_EXTRACT_ENABLE!=0)begin: g_extraction
        edge_extract #(.IMG_H(IMG_HEIGHT)) extract (
            .clk(I_clk),.rst_n(I_rst_n),.valid_i(O_edge_valid),.user_i(O_edge_user),.last_i(O_edge_last),
            .edge_i(O_edge_bit),.x_i(O_edge_x),.y_i(O_edge_y),
            .point_valid_o(O_edge_point_valid),.point_x_o(O_edge_point_x),.point_y_o(O_edge_point_y),.point_frame_o(O_edge_point_frame),
            .run_valid_o(O_edge_run_valid),.run_start_o(O_edge_run_start),.run_end_o(O_edge_run_end),
            .run_y_o(O_edge_run_y),.run_length_o(O_edge_run_length),.run_frame_o(O_edge_run_frame),
            .frame_done_o(O_edge_frame_done),.frame_id_o(O_edge_frame_id),
            .frame_points_o(O_edge_frame_points),.frame_runs_o(O_edge_frame_runs),
            .bbox_valid_o(O_edge_bbox_valid),.xmin_o(O_edge_xmin),.xmax_o(O_edge_xmax),.ymin_o(O_edge_ymin),.ymax_o(O_edge_ymax));
    end else begin: g_extraction_bypass
        assign {O_edge_point_valid,O_edge_point_x,O_edge_point_y,O_edge_point_frame,
            O_edge_run_valid,O_edge_run_start,O_edge_run_end,O_edge_run_y,O_edge_run_length,O_edge_run_frame,
            O_edge_frame_done,O_edge_frame_id,O_edge_frame_points,O_edge_frame_runs,
            O_edge_bbox_valid,O_edge_xmin,O_edge_xmax,O_edge_ymin,O_edge_ymax}=0;
    end endgenerate
    wire fill_available;
    wire [23:0] fill_pixel;
    generate if(EDGE_DENOISE_ENABLE!=0 && EDGE_REFINE_ENABLE!=0 && EDGE_FILL_ENABLE!=0)begin: g_region_fill
        reg previous_vsync;
        always @(posedge I_clk or negedge I_rst_n)begin
            if(!I_rst_n)previous_vsync<=1'b0;
            else previous_vsync<=delayed_raster[28];
        end
        edge_fill_buffer #(.IMG_W(IMG_WIDTH),.IMG_H(IMG_HEIGHT),.MAX_RUNS(6144),.MIN_BG_RUN(EDGE_FILL_MIN_BG_RUN),
                           .ROW_STEP(EDGE_FILL_ROW_STEP)) fill_engine (
            .clk(I_clk),.rst_n(I_rst_n),.valid_i(O_edge_valid),.user_i(O_edge_user),.last_i(O_edge_last),
            .frame_tick_i(delayed_raster[28] && !previous_vsync),
            .edge_i(O_edge_bit),.x_i(O_edge_x),.y_i(O_edge_y),
            .available_o(fill_available),.pixel_o(fill_pixel),.display_frame_o(),.process_cycles_o(),
            .cfg_valid_i(1'b1),.run_filter_threshold_i(S_fill_filter_cfg),
            .closure_gap_tolerance_i(S_fill_gap_cfg),.gap_count_tolerance_i(S_fill_gap_count_cfg),
            .border_contact_tolerance_i(S_fill_border_cfg),.min_fill_width_i(S_fill_minw_cfg),
            .run_count_o(fill_run_count),.run_overflow_o(fill_overflow));
    end else begin: g_region_fill_bypass
        assign fill_available=1'b0;
        assign fill_pixel=24'd0;
        assign fill_run_count=13'd0;
        assign fill_overflow=1'b0;
    end endgenerate
    assign O_fill_run_count=fill_run_count;
    assign O_fill_overflow=fill_overflow;
    wire edge_stats_hit;
    generate if(EDGE_DENOISE_ENABLE!=0 && EDGE_REFINE_ENABLE!=0 && EDGE_EXTRACT_ENABLE!=0 && EDGE_STATS_ENABLE!=0)begin: g_edge_statistics
        edge_stats_osd #(.IMG_H(IMG_HEIGHT)) statistics (
            .clk(I_clk),.rst_n(I_rst_n),.frame_done_i(O_edge_frame_done),
            .points_i(O_edge_frame_points),.runs_i(O_edge_frame_runs),.frame_start_i(O_edge_user),
            .enable_i(delayed_raster[25] && !delayed_raster[24] && !delayed_raster[32] && (EDGE_COMPARE_ENABLE==0 || delayed_raster[31])),.de_i(O_edge_valid),
            .x_i(O_edge_x),.y_i(O_edge_y),.hit_o(edge_stats_hit));
    end else begin: g_edge_statistics_bypass
        assign edge_stats_hit=1'b0;
    end endgenerate
    // DETECT and EXTRACT share the same center, blanking and output register.
    wire [23:0] comparison_edge=(delayed_raster[32] && fill_available) ? fill_pixel : (EDGE_COMPARE_ENABLE!=0 && !delayed_raster[31]) ?
        (refined_valid && detected_bit ? 24'hffffff : 24'd0) : centered_edge;
    wire mode_label_hit;
    generate if(EDGE_COMPARE_ENABLE!=0)begin: g_mode_label
        reg [7:0] letter;
        wire [15:0] glyph_row;
        wire [11:0] local_x=O_edge_x-12'd176;
        wire [11:0] local_y=O_edge_y-12'd72;
        always @(*)begin
            letter=8'h20;
            if(delayed_raster[32])begin
                case(local_x[6:4])
                    0:letter="F";1:letter="I";2:letter="L";3:letter="L";
                    default:letter=8'h20;
                endcase
            end else if(delayed_raster[31])begin
                case(local_x[6:4])
                    0:letter="E";1:letter="X";2:letter="T";3:letter="R";
                    4:letter="A";5:letter="C";6:letter="T";
                    default:letter=8'h20;
                endcase
            end else begin
                case(local_x[6:4])
                    0:letter="D";1:letter="E";2:letter="T";3:letter="E";
                    4:letter="C";5:letter="T";
                    default:letter=8'h20;
                endcase
            end
        end
        osd_char_lib label_font(.I_char(letter),.I_row(local_y[3:0]),.O_row_bits(glyph_row));
        assign mode_label_hit=O_edge_valid && delayed_raster[25] && !delayed_raster[24] &&
            O_edge_x>=176 && O_edge_x<288 && O_edge_y>=72 && O_edge_y<88 && glyph_row[15-local_x[3:0]];
    end else begin: g_no_mode_label
        assign mode_label_hit=1'b0;
    end endgenerate
    wire [23:0] delayed_pixel=mode_label_hit ? (delayed_raster[32] ? 24'h20c080 : (delayed_raster[31] ? 24'h00e6ff : 24'hfff200)) :
        (edge_stats_hit ? 24'h40ff80 : (delayed_raster[25] && !delayed_raster[24] ? comparison_edge : delayed_raster[23:0]));
    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n) begin
            S_p3_de    <= 1'b0; S_p3_hsync <= 1'b0; S_p3_vsync <= 1'b0; S_p3_data  <= 24'd0;
            S_p3_ohit  <= 1'b0; S_p3_dhit  <= 1'b0; S_p3_shit  <= 1'b0;
            S_p3_ocol  <= 24'd0; S_p3_dcol <= 24'd0; S_p3_scol <= 24'd0;
            S_pd_de    <= 1'b0; S_pd_hsync <= 1'b0; S_pd_vsync <= 1'b0; S_pd_data  <= 24'd0;
            S_pd_ohit  <= 1'b0; S_pd_dhit  <= 1'b0; S_pd_shit  <= 1'b0;
            S_pd_ocol  <= 24'd0; S_pd_dcol <= 24'd0; S_pd_scol <= 24'd0;
            O_hdmi_vsync <= 1'b0;
            O_hdmi_hsync <= 1'b0;
            O_hdmi_de    <= 1'b0;
            O_hdmi_data  <= 24'd0;
        end
        else begin
            // 第 3 拍（取与判定同一拍的信号：S_video_*_2d 与 S_*_hit）
            S_p3_de    <= S_video_de_2d;    S_p3_hsync <= S_video_hsync_2d; S_p3_vsync <= S_video_vsync_2d;
            S_p3_data  <= (DEBUG_MODE == 0) ? S_video_data_2d : S_pre_data;
            S_p3_ohit  <= S_osd_hit;   S_p3_ocol  <= S_osd_color;
            S_p3_dhit  <= S_det_hit && (UI_ENABLE==0 || (S_src_eff==SRC_COLOR && S_result_match && !S_preview_active));   S_p3_dcol  <= S_det_color;
            S_p3_shit  <= S_sts_hit;   S_p3_scol  <= S_sts_color;
            // 第 4 拍（末级）
            S_pd_de    <= S_p3_de;     S_pd_hsync <= S_p3_hsync; S_pd_vsync <= S_p3_vsync;
            S_pd_data  <= (S_preview_active && BLUE_BACKGROUND_ENABLE!=0) ? {24{S_view_hit}} : S_p3_data;
            S_pd_ohit  <= S_p3_ohit;   S_pd_ocol  <= S_p3_ocol;
            S_pd_dhit  <= S_p3_dhit;   S_pd_dcol  <= S_p3_dcol;
            S_pd_shit  <= S_p3_shit;   S_pd_scol  <= S_p3_scol;
            // 输出
            O_hdmi_vsync <= EDGE_DENOISE_ENABLE!=0 ? delayed_raster[28] : S_pd_vsync;
            O_hdmi_hsync <= EDGE_DENOISE_ENABLE!=0 ? delayed_raster[27] : S_pd_hsync;
            O_hdmi_de    <= EDGE_DENOISE_ENABLE!=0 ? delayed_raster[26] : S_pd_de;
            O_hdmi_data  <= EDGE_DENOISE_ENABLE!=0 ? delayed_pixel : S_mix_4d;
        end
    end

endmodule
