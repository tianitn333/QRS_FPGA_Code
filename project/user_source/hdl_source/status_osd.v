// ============================================================================
// status_osd —— 画面右上角状态显示：分辨率、帧率、FILL run 和诊断（本工程自研）
//
// 显示内容（字符格缩为 24x24，保留 16x16 字形采样）：
//     1280x720
//     60FPS        （帧率每秒更新一次）
//
// 帧率测量：用像素时钟数 1 秒（CLK_HZ 拍），统计该秒内的帧首脉冲数。
//           板卡实际像素时钟 75.000 MHz / (1650x750) = 60.6 Hz，故读数在 60/61 间跳动，属正常。
//
// 分辨率：本设计固定 1280x720（由 uivtc 与 sensor 寄存器表共同决定），故直接以常量显示。
//
// 位置默认右上角 (992,0)，避开安路 Logo(x<160)、动态 OSD 区(x 375..575) 与检测标签行(y>=640)。
// 纯组合输出 + 一个帧率计数器；不引入除法器到像素路径（除 10 仅在每秒一次的锁存路径上）。
// ============================================================================

module status_osd #(
    parameter integer AE_ENABLE = 0,
    parameter integer DDR_DIAG_ENABLE = 0,
    parameter integer IMG_W  = 1280,
    parameter integer IMG_H  = 720,
    parameter integer BASE_X = 992,
    parameter integer BASE_Y = 0,
    parameter integer CLK_HZ = 75000000,     // 像素时钟频率，用于 1 秒计时
    parameter [23:0]  COLOR  = 24'h1ff01f   // 状态文字颜色（亮绿）
)(
    input wire [59:0] ae_i,
    input wire [15:0] ddr_i,
    input  wire        clk,
    input  wire        rst_n,
    input  wire        de_i,                 // 与输出像素同拍的 DE
    input  wire        user_i,               // 帧首（帧率统计用）
    input  wire [11:0] x_i,                  // 与输出像素同拍的坐标
    input  wire [11:0] y_i,
    input wire        fill_active_i,
    input wire [12:0] fill_run_count_i,
    input wire        fill_overflow_i,
    input wire        fill_edit_i,
    input wire [2:0]  fill_sel_i,
    input wire [11:0] fill_filter_i,
    input wire [11:0] fill_gap_i,
    input wire [3:0]  fill_gap_count_i,
    input wire [11:0] fill_border_i,
    input wire [11:0] fill_minw_i,
    output reg         hit_o,
    output reg  [23:0] color_o,
    output reg  [15:0] fps_o                 // 观测：最近一秒的帧数
);

    // ------------------------------------------------------------------
    // 1) 帧率统计：每秒锁存一次
    // ------------------------------------------------------------------
    localparam integer SEC_CNT = CLK_HZ;
    localparam integer CELL = 24;
    localparam integer OSD_LINES = 10;

    reg [26:0] S_sec;
    reg [15:0] S_fsec;      // 本秒累计帧数
    reg [15:0] S_fps;       // 上一秒帧数
    reg [3:0]  S_tens;      // 十位
    reg [3:0]  S_ones;      // 个位
    reg [12:0] S_run_count;
    reg        S_run_overflow;
    reg [3:0]  S_run_d3,S_run_d2,S_run_d1,S_run_d0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_sec  <= 27'd0;
            S_fsec <= 16'd0;
            S_fps  <= 16'd0;
            S_tens <= 4'd0;
            S_ones <= 4'd0;
            S_run_count <= 13'd0;
            S_run_overflow <= 1'b0;
            S_run_d3 <= 0;S_run_d2 <= 0;S_run_d1 <= 0;S_run_d0 <= 0;
        end
        else begin
            if (user_i)
                S_fsec <= S_fsec + 16'd1;

            if (user_i && fill_active_i) begin
                S_run_count <= fill_run_count_i;
                S_run_overflow <= fill_overflow_i;
                if(fill_run_count_i>13'd6144) begin
                    S_run_d3<=4'd6;S_run_d2<=4'd1;S_run_d1<=4'd4;S_run_d0<=4'd4;
                end else begin
                    S_run_d3 <= fill_run_count_i / 13'd1000;
                    S_run_d2 <= (fill_run_count_i / 13'd100) % 13'd10;
                    S_run_d1 <= (fill_run_count_i / 13'd10) % 13'd10;
                    S_run_d0 <= fill_run_count_i % 13'd10;
                end
            end

            if (S_sec == (SEC_CNT - 1)) begin
                S_sec  <= 27'd0;
                S_fps  <= S_fsec;
                // 限幅到 0..199，避免异常帧数把个/十位算错
                if (S_fsec > 16'd199) begin
                    S_tens <= 4'd9;
                    S_ones <= 4'd9;
                end
                else begin
                    S_tens <= S_fsec / 16'd10;                       // 每秒才走一次，不在像素路径
                    S_ones <= S_fsec - (S_fsec / 16'd10) * 16'd10;
                end
                S_fsec <= 16'd0;
            end
            else begin
                S_sec <= S_sec + 27'd1;
            end

            fps_o <= S_fps;
        end
    end

    // ------------------------------------------------------------------
    // 2) 区域内像素定位
    // ------------------------------------------------------------------
    wire [11:0] lx = x_i - BASE_X[11:0];
    wire [11:0] ly = y_i - BASE_Y[11:0];

    function [3:0] F_cell_index;
        input [11:0] p;
        begin
            if(p<12'd24) F_cell_index=0; else if(p<12'd48) F_cell_index=1;
            else if(p<12'd72) F_cell_index=2; else if(p<12'd96) F_cell_index=3;
            else if(p<12'd120) F_cell_index=4; else if(p<12'd144) F_cell_index=5;
            else if(p<12'd168) F_cell_index=6; else if(p<12'd192) F_cell_index=7;
            else if(p<12'd216) F_cell_index=8; else F_cell_index=9;
        end
    endfunction
    function [4:0] F_cell_pos;
        input [11:0] p;
        begin
            if(p<12'd24) F_cell_pos=p;
            else if(p<12'd48) F_cell_pos=p-12'd24;
            else if(p<12'd72) F_cell_pos=p-12'd48;
            else if(p<12'd96) F_cell_pos=p-12'd72;
            else if(p<12'd120) F_cell_pos=p-12'd96;
            else if(p<12'd144) F_cell_pos=p-12'd120;
            else if(p<12'd168) F_cell_pos=p-12'd144;
            else if(p<12'd192) F_cell_pos=p-12'd168;
            else if(p<12'd216) F_cell_pos=p-12'd192;
            else F_cell_pos=0;
        end
    endfunction
    function [3:0] F_font_pos;
        input [4:0] p;
        begin
            case(p)
                0,1:F_font_pos=0; 2:F_font_pos=1; 3,4:F_font_pos=2;
                5:F_font_pos=3; 6,7:F_font_pos=4; 8:F_font_pos=5;
                9,10:F_font_pos=6; 11:F_font_pos=7; 12,13:F_font_pos=8;
                14:F_font_pos=9; 15,16:F_font_pos=10; 17:F_font_pos=11;
                18,19:F_font_pos=12; 20:F_font_pos=13; 21,22:F_font_pos=14;
                default:F_font_pos=15;
            endcase
        end
    endfunction
    function [3:0] F_line_index;
        input [11:0] p;
        begin
            if(p<12'd24) F_line_index=0; else if(p<12'd48) F_line_index=1;
            else if(p<12'd72) F_line_index=2; else if(p<12'd96) F_line_index=3;
            else if(p<12'd120) F_line_index=4; else if(p<12'd144) F_line_index=5;
            else if(p<12'd168) F_line_index=6; else if(p<12'd192) F_line_index=7;
            else if(p<12'd216) F_line_index=8; else F_line_index=9;
        end
    endfunction
    wire in_area = de_i &&
                   (x_i >= BASE_X[11:0]) && (x_i < (BASE_X + 8*CELL)) &&
                   (y_i >= BASE_Y[11:0]) && (y_i < (BASE_Y + 2*CELL));
    wire [3:0] ci = F_cell_index(lx);
    wire [3:0] col = F_font_pos(F_cell_pos(lx));
    wire [3:0] row = F_font_pos(F_cell_pos(ly));
    wire [3:0] line_idx = F_line_index(ly);
    wire line2 = line_idx==4'd1;
    wire run_area = fill_active_i && de_i && x_i>=BASE_X && x_i<BASE_X+8*CELL &&
                    y_i>=BASE_Y+2*CELL && y_i<BASE_Y+3*CELL;
    wire param_area = fill_edit_i && de_i && x_i>=BASE_X && x_i<BASE_X+8*CELL &&
                      y_i>=BASE_Y+3*CELL && y_i<BASE_Y+4*CELL;

    // ------------------------------------------------------------------
    // 3) 字符选择
    // ------------------------------------------------------------------
    reg [7:0] ch;
    always @(*) begin
        if (!line2) begin
            case (ci)               // "1280x720"
                3'd0:    ch = 8'h31;    // '1'
                3'd1:    ch = 8'h32;    // '2'
                3'd2:    ch = 8'h38;    // '8'
                3'd3:    ch = 8'h30;    // '0'
                3'd4:    ch = 8'h78;    // 'x'
                3'd5:    ch = 8'h37;    // '7'
                3'd6:    ch = 8'h32;    // '2'
                default: ch = 8'h30;    // '0'
            endcase
        end
        else begin
            case (ci)               // "<fps>FPS"
                3'd0:    ch = 8'h30 + {4'd0, S_tens};
                3'd1:    ch = 8'h30 + {4'd0, S_ones};
                3'd2:    ch = 8'h46;    // 'F'
                3'd3:    ch = 8'h50;    // 'P'
                3'd4:    ch = 8'h53;    // 'S'
                default: ch = 8'h00;    // 超出第二行字符范围 → 不显示
            endcase
        end
    end

    reg [7:0] fill_ch;
    reg [3:0] fill_digit;
    reg [11:0] fill_value;
    always @(*) begin
        fill_ch=8'h20; fill_digit=0; fill_value=0;
        if(run_area)begin
            case(ci)
                0:fill_ch="R";1:fill_ch="U";2:fill_ch="N";3:fill_ch=":";
                4:fill_ch=8'h30+S_run_d3;5:fill_ch=8'h30+S_run_d2;
                6:fill_ch=8'h30+S_run_d1;7:fill_ch=8'h30+S_run_d0;
                default:fill_ch=8'h20;
            endcase
        end else if(param_area)begin
            case(fill_sel_i)
                3'd0:begin fill_ch=(ci==0)?"R":(ci==1)?"F":(ci==2)?":" : 8'h20; fill_value=fill_filter_i; end
                3'd1:begin fill_ch=(ci==0)?"C":(ci==1)?"G":(ci==2)?":" : 8'h20; fill_value=fill_gap_i; end
                3'd2:begin fill_ch=(ci==0)?"B":(ci==1)?"T":(ci==2)?":" : 8'h20; fill_value=fill_border_i; end
                3'd3:begin fill_ch=(ci==0)?"G":(ci==1)?"C":(ci==2)?":" : 8'h20; fill_value={8'd0,fill_gap_count_i}; end
                default:begin fill_ch=(ci==0)?"M":(ci==1)?"W":(ci==2)?":" : 8'h20; fill_value=fill_minw_i; end
            endcase
            if(ci==3) fill_ch=8'h30+(fill_value/12'd100);
            else if(ci==4) fill_ch=8'h30+((fill_value/12'd10)%12'd10);
            else if(ci==5) fill_ch=8'h30+(fill_value%12'd10);
        end
    end

    // ------------------------------------------------------------------
    // 4) 16x16 字形（数据取自官方 osd_char_lib.v 的对应条目）
    // ------------------------------------------------------------------
    function [15:0] F_glyph;
        input [7:0] c;
        input [3:0] r;
        begin
            case (c)
                8'h30: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h1ff8;
                    4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h300c;
                    4'd4 : F_glyph = 16'h300c;
                    4'd5 : F_glyph = 16'h300c;
                    4'd6 : F_glyph = 16'h0000;
                    4'd7 : F_glyph = 16'h0000;
                    4'd8 : F_glyph = 16'h300c;
                    4'd9 : F_glyph = 16'h300c;
                    4'd10: F_glyph = 16'h300c;
                    4'd11: F_glyph = 16'h1ff8;
                    4'd12: F_glyph = 16'h1ff8;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h31: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h000c;
                    4'd2 : F_glyph = 16'h000c;
                    4'd3 : F_glyph = 16'h000c;
                    4'd4 : F_glyph = 16'h000c;
                    4'd5 : F_glyph = 16'h000c;
                    4'd6 : F_glyph = 16'h0000;
                    4'd7 : F_glyph = 16'h0000;
                    4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c;
                    4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h000c;
                    4'd12: F_glyph = 16'h000c;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h32: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h1ff8;
                    4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h000c;
                    4'd4 : F_glyph = 16'h000c;
                    4'd5 : F_glyph = 16'h000c;
                    4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8;
                    4'd8 : F_glyph = 16'h3000;
                    4'd9 : F_glyph = 16'h3000;
                    4'd10: F_glyph = 16'h3000;
                    4'd11: F_glyph = 16'h1ff8;
                    4'd12: F_glyph = 16'h1ff8;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h36: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h1ff8;
                    4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h3000;
                    4'd4 : F_glyph = 16'h3000;
                    4'd5 : F_glyph = 16'h3000;
                    4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8;
                    4'd8 : F_glyph = 16'h300c;
                    4'd9 : F_glyph = 16'h300c;
                    4'd10: F_glyph = 16'h300c;
                    4'd11: F_glyph = 16'h1ff8;
                    4'd12: F_glyph = 16'h1ff8;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h37: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h1ff8;
                    4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h000c;
                    4'd4 : F_glyph = 16'h000c;
                    4'd5 : F_glyph = 16'h000c;
                    4'd6 : F_glyph = 16'h0000;
                    4'd7 : F_glyph = 16'h0000;
                    4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c;
                    4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h000c;
                    4'd12: F_glyph = 16'h000c;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h38: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h1ff8;
                    4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h300c;
                    4'd4 : F_glyph = 16'h300c;
                    4'd5 : F_glyph = 16'h300c;
                    4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8;
                    4'd8 : F_glyph = 16'h300c;
                    4'd9 : F_glyph = 16'h300c;
                    4'd10: F_glyph = 16'h300c;
                    4'd11: F_glyph = 16'h1ff8;
                    4'd12: F_glyph = 16'h1ff8;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h78: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h0000;
                    4'd2 : F_glyph = 16'h3e00;
                    4'd3 : F_glyph = 16'h1c00;
                    4'd4 : F_glyph = 16'h1c00;
                    4'd5 : F_glyph = 16'h0800;
                    4'd6 : F_glyph = 16'h1c00;
                    4'd7 : F_glyph = 16'h1400;
                    4'd8 : F_glyph = 16'h3600;
                    4'd9 : F_glyph = 16'h3200;
                    4'd10: F_glyph = 16'h0000;
                    4'd11: F_glyph = 16'h0000;
                    4'd12: F_glyph = 16'h0000;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h46: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h0000;
                    4'd2 : F_glyph = 16'h3e00;
                    4'd3 : F_glyph = 16'h3000;
                    4'd4 : F_glyph = 16'h3000;
                    4'd5 : F_glyph = 16'h3000;
                    4'd6 : F_glyph = 16'h3e00;
                    4'd7 : F_glyph = 16'h3000;
                    4'd8 : F_glyph = 16'h3000;
                    4'd9 : F_glyph = 16'h3000;
                    4'd10: F_glyph = 16'h0000;
                    4'd11: F_glyph = 16'h0000;
                    4'd12: F_glyph = 16'h0000;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h50: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h0000;
                    4'd2 : F_glyph = 16'h3e00;
                    4'd3 : F_glyph = 16'h3300;
                    4'd4 : F_glyph = 16'h3300;
                    4'd5 : F_glyph = 16'h3300;
                    4'd6 : F_glyph = 16'h3e00;
                    4'd7 : F_glyph = 16'h3000;
                    4'd8 : F_glyph = 16'h3000;
                    4'd9 : F_glyph = 16'h3000;
                    4'd10: F_glyph = 16'h0000;
                    4'd11: F_glyph = 16'h0000;
                    4'd12: F_glyph = 16'h0000;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                8'h53: case (r)
                    4'd0 : F_glyph = 16'h0000;
                    4'd1 : F_glyph = 16'h0000;
                    4'd2 : F_glyph = 16'h1e00;
                    4'd3 : F_glyph = 16'h3000;
                    4'd4 : F_glyph = 16'h3000;
                    4'd5 : F_glyph = 16'h3c00;
                    4'd6 : F_glyph = 16'h0f00;
                    4'd7 : F_glyph = 16'h0300;
                    4'd8 : F_glyph = 16'h0300;
                    4'd9 : F_glyph = 16'h3e00;
                    4'd10: F_glyph = 16'h0000;
                    4'd11: F_glyph = 16'h0000;
                    4'd12: F_glyph = 16'h0000;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                endcase
                default: F_glyph = 16'h0000;
            endcase
        end
    endfunction

    wire [15:0] bits = F_glyph(ch, row);
    wire [15:0] fill_bits;
    generate if(1) begin:g_fill_font
      osd_char_lib u_fill_font(.I_char(fill_ch),.I_row(row),.O_row_bits(fill_bits));
    end endgenerate
    reg [59:0] ae_snap;
    reg [15:0] ddr_snap;
    always @(posedge clk or negedge rst_n)
      if(!rst_n) ddr_snap<=0;else if(user_i && DDR_DIAG_ENABLE) ddr_snap<=ddr_i;
    always @(posedge clk or negedge rst_n)
      if(!rst_n) ae_snap<=0;else if(user_i && AE_ENABLE) ae_snap<=ae_i;
    reg [7:0] ae_ch;reg [15:0] ae_value;reg [3:0] nib;
    wire [3:0] ae_line=(line_idx>=4) ? line_idx-4'd4 : 4'd0;
    wire [3:0] ae_src_line=ae_line+4'd2;
    wire ae_area=AE_ENABLE && de_i && x_i>=BASE_X && x_i<BASE_X+8*CELL &&
                 y_i>=BASE_Y+4*CELL && y_i<BASE_Y+10*CELL;
    always @* begin
      ae_value=0;ae_ch=0;nib=0;
      case(ae_src_line)
       2:ae_value={8'd0,ae_snap[55:48]};3:ae_value=ae_snap[47:32];
       4:ae_value=ae_snap[31:16];5:ae_value=ae_snap[15:0];default:ae_value=0;
      endcase
      if(DDR_DIAG_ENABLE && ae_src_line==7) begin
       ae_value=ddr_snap;
       if(ci==0)ae_ch="V";else if(ci==1)ae_ch="H";else if(ci==2)ae_ch=":";
       else if(ci>=3 && ci<=6)begin
        case(ci)3:nib=ae_value[15:12];4:nib=ae_value[11:8];5:nib=ae_value[7:4];default:nib=ae_value[3:0];endcase
        ae_ch=(nib<10)?8'h30+nib:8'h41+nib-10;
       end
      end else if(ae_src_line<6) begin
       if(ci==0) begin
         if(ae_snap[59:56]>=6) case(ae_src_line) 2:ae_ch="C";3:ae_ch="R";4:ae_ch="N";default:ae_ch="T";endcase
         else case(ae_src_line) 2:ae_ch="Y";3:ae_ch="E";4:ae_ch="A";default:ae_ch="D";endcase
       end
       else if(ci==1) ae_ch="H";
       else if(ci==2) ae_ch=":";
       else if(ci>=3 && ci<=6) begin
        case(ci) 3:nib=ae_value[15:12];4:nib=ae_value[11:8];5:nib=ae_value[7:4];default:nib=ae_value[3:0];endcase
        ae_ch=(nib<10)?8'h30+nib:8'h41+nib-10;
       end
      end else begin
       case(ae_snap[59:56])
        0:case(ci) 0:ae_ch="I";1:ae_ch="N";2:ae_ch="I";3:ae_ch="T";default:ae_ch=0;endcase
        1:case(ci) 0:ae_ch="W";1:ae_ch="A";2:ae_ch="I";3:ae_ch="T";default:ae_ch=0;endcase
        2:case(ci) 0:ae_ch="A";1:ae_ch="D";2:ae_ch="J";3:ae_ch="U";4:ae_ch="S";5:ae_ch="T";default:ae_ch=0;endcase
        3:case(ci) 0:ae_ch="S";1:ae_ch="T";2:ae_ch="A";3:ae_ch="B";4:ae_ch="L";5:ae_ch="E";default:ae_ch=0;endcase
        4:case(ci) 0:ae_ch="L";1:ae_ch="I";2:ae_ch="M";3:ae_ch="I";4:ae_ch="T";default:ae_ch=0;endcase
        6:case(ci) 0:ae_ch="R";1:ae_ch="E";2:ae_ch="T";3:ae_ch="R";4:ae_ch="Y";default:ae_ch=0;endcase
        7:case(ci) 0:ae_ch="C";1:ae_ch="A";2:ae_ch="M";3:ae_ch="E";4:ae_ch="R";5:ae_ch="R";default:ae_ch=0;endcase
        default:case(ci) 0:ae_ch="E";1:ae_ch="R";2:ae_ch="R";3:ae_ch="O";4:ae_ch="R";default:ae_ch=0;endcase
       endcase
      end
    end
    wire [15:0] ae_bits;
    generate if(AE_ENABLE) begin:g_ae_font
      osd_char_lib u_font(.I_char(ae_ch),.I_row(row),.O_row_bits(ae_bits));
    end else begin:g_no_ae_font
      assign ae_bits=0;
    end endgenerate

    // ------------------------------------------------------------------
    // 5) 输出
    // ------------------------------------------------------------------
    always @(*) begin
        hit_o   = 1'b0;
        color_o = 24'd0;
       if ((in_area && bits[4'd15 - col]) || ((run_area || param_area) && fill_bits[4'd15-col]) ||
           (ae_area && ae_bits[4'd15-col])) begin
            hit_o   = 1'b1;
            // Capacity warning: green below 80% of the 6144-run budget,
            // amber from 80%, red once the frame is discarded.
            if (run_area && S_run_overflow) color_o = 24'hff0000;
            else if (run_area && S_run_count >= 13'd4915) color_o = 24'hffc000;
            else color_o = COLOR;
        end
    end

endmodule
