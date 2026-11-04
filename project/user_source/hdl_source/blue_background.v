// Frozen eight-frame background, averaged spatially over 8x8 tiles.
// Optional eight additional frames learn a frozen per-channel noise envelope.
// Input/output raster has three register stages; RGB and mask travel together.
module blue_background #(
    parameter integer IMG_W = 1280,
    parameter integer IMG_H = 720,
    parameter integer SETTLE_CYCLES = 37500000,
    parameter integer MIN_DELTA = 16,
    parameter integer MIN_SUM = 48,
    parameter integer CHROMA_SHIFT = 4,
    parameter integer NOISE_CAL_ENABLE = 0,
    parameter integer NOISE_MARGIN = 8
)(
    input wire clk, rst_n,
    input wire calibrate_i,
    input wire valid_i, user_i, last_i,
    input wire [23:0] rgb_i,
    output reg valid_o, user_o, last_o,
    output reg [23:0] rgb_o,
    output reg allow_o,
    output wire ready_o,
    output wire busy_o
);
    localparam integer COLS = IMG_W/8;
    localparam integer CELLS = (IMG_W/8)*(IMG_H/8);
    localparam [2:0] IDLE=0, SETTLE=1, ARM=2, CAPTURE=3, COMMIT=4, READY=5, NOISE=6;
    reg [2:0] state;
    reg [25:0] settle_count;
    reg [2:0] frame_count;
    reg [11:0] px, py;
    wire [11:0] x = user_i ? 12'd0 : px;
    wire [11:0] y = user_i ? 12'd0 : py;
    wire [13:0] cell_addr = (y >> 3)*COLS + (x >> 3);
    wire [13:0] column_addr = x >> 3;
    wire capturing = (state==CAPTURE || (state==ARM && user_i)) && !calibrate_i;
    wire ready_now = (state==READY || (state==COMMIT && user_i)) && !calibrate_i;
    assign ready_o = state==READY;
    assign busy_o = state!=IDLE && state!=READY;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            px<=0;py<=0;state<=IDLE;settle_count<=0;frame_count<=0;
        end else begin
            if (valid_i) begin
                if (user_i) begin px<=1;py<=0;end
                else if (last_i) begin px<=0;py<=py+1'b1;end
                else px<=px+1'b1;
            end
            if (calibrate_i) begin
                state<=SETTLE;settle_count<=0;frame_count<=0;
            end else begin
                case(state)
                    SETTLE: if(settle_count==SETTLE_CYCLES-1) state<=ARM;
                            else settle_count<=settle_count+1'b1;
                    ARM: if(valid_i && user_i) begin state<=CAPTURE;frame_count<=0;end
                    CAPTURE: if(valid_i && last_i && y==IMG_H-1) begin
                        if(frame_count==7) begin
                            state<=NOISE_CAL_ENABLE!=0 ? NOISE : COMMIT;
                            frame_count<=0;
                        end
                        else frame_count<=frame_count+1'b1;
                    end
                    NOISE: if(valid_i && last_i && y==IMG_H-1) begin
                        if(frame_count==7) state<=COMMIT;
                        else frame_count<=frame_count+1'b1;
                    end
                    COMMIT: if(valid_i && user_i) state<=READY;
                    default: state<=state;
                endcase
            end
        end
    end

    // Partial tile-row sums require only COLS words, reused every eight lines.
    reg [10:0] row_r,row_g,row_b;
    wire [10:0] row_r_next = (x[2:0]==0 ? 11'd0 : row_r)+{3'd0,rgb_i[23:16]};
    wire [10:0] row_g_next = (x[2:0]==0 ? 11'd0 : row_g)+{3'd0,rgb_i[15:8]};
    wire [10:0] row_b_next = (x[2:0]==0 ? 11'd0 : row_b)+{3'd0,rgb_i[7:0]};
    wire [41:0] partial;
    wire [13:0] total_r = (y[2:0]==0 ? 14'd0 : partial[41:28])+{3'd0,row_r_next};
    wire [13:0] total_g = (y[2:0]==0 ? 14'd0 : partial[27:14])+{3'd0,row_g_next};
    wire [13:0] total_b = (y[2:0]==0 ? 14'd0 : partial[13:0])+{3'd0,row_b_next};
    reg partial_we;
    reg [13:0] partial_addr;
    reg [41:0] partial_data;
    image_eram #(.WIDTH(42),.DEPTH(COLS)) partial_memory (
        .clk(clk),.we_i(partial_we),.wr_addr_i(partial_addr),.data_i(partial_data),
        .rd_addr_i(column_addr),.data_o(partial));
    wire [50:0] accumulated;
    wire [16:0] accum_r = (frame_count==0 ? 17'd0 : accumulated[50:34])+{3'd0,total_r};
    wire [16:0] accum_g = (frame_count==0 ? 17'd0 : accumulated[33:17])+{3'd0,total_g};
    wire [16:0] accum_b = (frame_count==0 ? 17'd0 : accumulated[16:0])+{3'd0,total_b};
    reg background_we;
    reg [13:0] background_addr;
    reg [50:0] background_data;
    image_eram #(.WIDTH(51),.DEPTH(CELLS)) background_memory (
        .clk(clk),.we_i(background_we),.wr_addr_i(background_addr),.data_i(background_data),
        .rd_addr_i(cell_addr),.data_o(accumulated));
    // Noise samples use the synchronous memory read aligned with rgb_first.
    // During learning the low three nine-bit lanes hold maxima (0..255);
    // the last learning frame replaces them with max(MIN_DELTA, maximum+margin).
    reg noise_first,model_format_first;
    reg [2:0] noise_frame_first;
    reg [11:0] noise_x,noise_y;
    reg [13:0] noise_cell,noise_column;
    reg [7:0] noise_row_r,noise_row_g,noise_row_b;
    // Stage one aligns input RGB with synchronous background reads.
    reg [23:0] rgb_first,rgb_second;
    reg valid_first,user_first,last_first,ready_first;
    reg valid_second,user_second,last_second,ready_second;
    wire [7:0] back_r=accumulated[50:43];
    wire [7:0] back_g=model_format_first ? accumulated[42:35] : accumulated[33:26];
    wire [7:0] back_b=model_format_first ? accumulated[34:27] : accumulated[16:9];
    wire [8:0] limit_r=NOISE_CAL_ENABLE!=0 ? accumulated[26:18] : MIN_DELTA;
    wire [8:0] limit_g=NOISE_CAL_ENABLE!=0 ? accumulated[17:9] : MIN_DELTA;
    wire [8:0] limit_b=NOISE_CAL_ENABLE!=0 ? accumulated[8:0] : MIN_DELTA;
    wire [7:0] delta_r=rgb_first[23:16]>=back_r ? rgb_first[23:16]-back_r : back_r-rgb_first[23:16];
    wire [7:0] delta_g=rgb_first[15:8]>=back_g ? rgb_first[15:8]-back_g : back_g-rgb_first[15:8];
    wire [7:0] delta_b=rgb_first[7:0]>=back_b ? rgb_first[7:0]-back_b : back_b-rgb_first[7:0];
    reg absolute_ok,dark_background;
    reg [15:0] red_cross_a,red_cross_b,green_cross_a,green_cross_b,blue_product;
    wire [15:0] red_distance=red_cross_a>=red_cross_b ? red_cross_a-red_cross_b : red_cross_b-red_cross_a;
    wire [15:0] green_distance=green_cross_a>=green_cross_b ? green_cross_a-green_cross_b : green_cross_b-green_cross_a;
    wire chroma_ok=dark_background || (({4'd0,red_distance} << CHROMA_SHIFT)>={4'd0,blue_product}) ||
                    (({4'd0,green_distance} << CHROMA_SHIFT)>={4'd0,blue_product});

    // Learning has its own pipeline: memory/delta -> maxima -> margin/write.
    // This does not add latency to RGB, raster markers or the detection mask.
    reg sample_valid,sample_first_frame,sample_last_frame;
    reg [2:0] sample_x,sample_y;
    reg [13:0] sample_cell,sample_column;
    reg [23:0] sample_delta,sample_mean,sample_partial;
    reg [26:0] sample_previous;
    reg commit_valid,commit_last_frame;
    reg [13:0] commit_cell;
    reg [23:0] commit_mean;
    reg [8:0] commit_r,commit_g,commit_b;
    wire [7:0] noise_row_r_next=(sample_x==0 || sample_delta[23:16]>noise_row_r) ? sample_delta[23:16] : noise_row_r;
    wire [7:0] noise_row_g_next=(sample_x==0 || sample_delta[15:8]>noise_row_g) ? sample_delta[15:8] : noise_row_g;
    wire [7:0] noise_row_b_next=(sample_x==0 || sample_delta[7:0]>noise_row_b) ? sample_delta[7:0] : noise_row_b;
    wire [7:0] noise_total_r=(sample_y==0 || noise_row_r_next>sample_partial[23:16]) ? noise_row_r_next : sample_partial[23:16];
    wire [7:0] noise_total_g=(sample_y==0 || noise_row_g_next>sample_partial[15:8]) ? noise_row_g_next : sample_partial[15:8];
    wire [7:0] noise_total_b=(sample_y==0 || noise_row_b_next>sample_partial[7:0]) ? noise_row_b_next : sample_partial[7:0];
    wire [8:0] noise_max_r=(sample_first_frame || {1'b0,noise_total_r}>sample_previous[26:18]) ? {1'b0,noise_total_r} : sample_previous[26:18];
    wire [8:0] noise_max_g=(sample_first_frame || {1'b0,noise_total_g}>sample_previous[17:9]) ? {1'b0,noise_total_g} : sample_previous[17:9];
    wire [8:0] noise_max_b=(sample_first_frame || {1'b0,noise_total_b}>sample_previous[8:0]) ? {1'b0,noise_total_b} : sample_previous[8:0];
    wire [8:0] margin_r=commit_r+NOISE_MARGIN;
    wire [8:0] margin_g=commit_g+NOISE_MARGIN;
    wire [8:0] margin_b=commit_b+NOISE_MARGIN;
    wire [8:0] tolerance_r=margin_r<MIN_DELTA ? MIN_DELTA : margin_r;
    wire [8:0] tolerance_g=margin_g<MIN_DELTA ? MIN_DELTA : margin_g;
    wire [8:0] tolerance_b=margin_b<MIN_DELTA ? MIN_DELTA : margin_b;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sample_valid<=0;sample_first_frame<=0;sample_last_frame<=0;
            sample_x<=0;sample_y<=0;sample_cell<=0;sample_column<=0;
            sample_delta<=0;sample_mean<=0;sample_partial<=0;sample_previous<=0;
        end else begin
            sample_valid<=NOISE_CAL_ENABLE!=0 && valid_first && noise_first && !calibrate_i;
            sample_first_frame<=noise_frame_first==0;sample_last_frame<=noise_frame_first==7;
            sample_x<=noise_x[2:0];sample_y<=noise_y[2:0];
            sample_cell<=noise_cell;sample_column<=noise_column;
            sample_delta<={delta_r,delta_g,delta_b};sample_mean<={back_r,back_g,back_b};
            sample_partial<=partial[23:0];sample_previous<=accumulated[26:0];
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            row_r<=0;row_g<=0;row_b<=0;
            partial_we<=0;partial_addr<=0;partial_data<=0;
            background_we<=0;background_addr<=0;background_data<=0;
            noise_row_r<=0;noise_row_g<=0;noise_row_b<=0;
            commit_valid<=0;commit_last_frame<=0;commit_cell<=0;commit_mean<=0;
            commit_r<=0;commit_g<=0;commit_b<=0;
        end else begin
            partial_we<=0;background_we<=0;
            commit_valid<=0;
            if(valid_i && capturing) begin
                row_r<=row_r_next;row_g<=row_g_next;row_b<=row_b_next;
                if(x[2:0]==7) begin
                    partial_we<=1;partial_addr<=column_addr;
                    partial_data<={total_r,total_g,total_b};
                    if(y[2:0]==7) begin
                        background_we<=1;background_addr<=cell_addr;
                        background_data<={accum_r,accum_g,accum_b};
                    end
                end
            end
            if(sample_valid && !calibrate_i) begin
                noise_row_r<=noise_row_r_next;noise_row_g<=noise_row_g_next;noise_row_b<=noise_row_b_next;
                if(sample_x==7) begin
                    partial_we<=1;partial_addr<=sample_column;
                    partial_data<={18'd0,noise_total_r,noise_total_g,noise_total_b};
                    if(sample_y==7) begin
                        commit_valid<=1;commit_cell<=sample_cell;commit_mean<=sample_mean;
                        commit_last_frame<=sample_last_frame;
                        commit_r<=noise_max_r;commit_g<=noise_max_g;commit_b<=noise_max_b;
                    end
                end
            end
            if(commit_valid && !calibrate_i) begin
                background_we<=1;background_addr<=commit_cell;
                background_data<={commit_mean,
                    (commit_last_frame ? tolerance_r : commit_r),
                    (commit_last_frame ? tolerance_g : commit_g),
                    (commit_last_frame ? tolerance_b : commit_b)};
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rgb_first<=0;rgb_second<=0;rgb_o<=0;
            valid_first<=0;user_first<=0;last_first<=0;ready_first<=0;
            valid_second<=0;user_second<=0;last_second<=0;ready_second<=0;
            valid_o<=0;user_o<=0;last_o<=0;allow_o<=0;
            absolute_ok<=0;dark_background<=0;
            red_cross_a<=0;red_cross_b<=0;green_cross_a<=0;green_cross_b<=0;blue_product<=0;
            noise_first<=0;model_format_first<=0;noise_frame_first<=0;
            noise_x<=0;noise_y<=0;noise_cell<=0;noise_column<=0;
        end else begin
            rgb_first<=rgb_i;valid_first<=valid_i;user_first<=user_i;last_first<=last_i;
            ready_first<=ready_now;
            noise_first<=state==NOISE && !calibrate_i;
            model_format_first<=NOISE_CAL_ENABLE!=0 && (ready_now || (state==NOISE && frame_count!=0));
            noise_frame_first<=frame_count;noise_x<=x;noise_y<=y;
            noise_cell<=cell_addr;noise_column<=column_addr;
            rgb_second<=rgb_first;valid_second<=valid_first;user_second<=user_first;last_second<=last_first;
            ready_second<=ready_first;
            absolute_ok<=(({1'b0,delta_r}>=limit_r)||({1'b0,delta_g}>=limit_g)||({1'b0,delta_b}>=limit_b)) &&
                         ({2'd0,delta_r}+{2'd0,delta_g}+{2'd0,delta_b}>=MIN_SUM);
            dark_background<=back_b<16;
            red_cross_a<=rgb_first[23:16]*back_b;
            red_cross_b<=back_r*rgb_first[7:0];
            green_cross_a<=rgb_first[15:8]*back_b;
            green_cross_b<=back_g*rgb_first[7:0];
            blue_product<=rgb_first[7:0]*back_b;
            rgb_o<=rgb_second;valid_o<=valid_second;user_o<=user_second;last_o<=last_second;
            allow_o<=ready_second && absolute_ok && chroma_ok && valid_second && !calibrate_i;
        end
    end
endmodule
