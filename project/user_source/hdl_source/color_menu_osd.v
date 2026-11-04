// ============================================================================
// color_menu_osd —— 参数编辑的小面积 OSD 面板（不做全屏菜单/中央弹窗）
//
// 依据：docs/handoff_color_ui_20261021/EXECUTION_CONSTRAINTS.md §7
//
// 几何（按最终输出像素坐标）：
//   面板 x=[992,1280)、y=[256,480)：288×224 = 18 列 × 14 行字符格（每格 16×16），
//   占 1280×720 的 7.0%；观察区 x=[192,960)、y=[128,592) 完全不被遮挡。
//   面板隐藏时只在同一矩形顶部保留一行状态。
//
// 字形：复用 osd_char_lib 的 16×16 字符；'.' '-' '/' '>' 由本模块按像素程序化
//       绘制，不扩字体 ROM。
//
// 数字：逐拍双 dabble（只做"比较+3、左移"，无除法器）把 3 个可见槽位换算成
//       显示字符；整数 4 位右对齐，比例 1 位整数 + 3 位小数（Q5 小数查表）。
//       场同步下降沿快照后启动，44 拍内完成，早于有效图像。
// ============================================================================

module color_menu_osd (
    input  wire         clk,
    input  wire         rst_n,

    input  wire         de_i,          // 输出像素有效
    input  wire         vsync_i,       // 输出场同步：uivtc 高有效，活动图像期间为低

    input  wire         show_i,        // 编辑面板可见
    input  wire         status_i,      // 面板隐藏后仍显示一行状态
    input  wire [2:0]   page_i,
    input  wire [1:0]   cursor_i,
    input  wire [239:0] value_bus,     // 生效值（Q5）
    input  wire [2:0]   save_state,    // 0 IDLE 1 PENDING 2 SAVING 3 SAVED 4 ERR
    input wire pending_i,
    input wire loading_i,

    output reg          hit_o,
    output reg  [23:0]  color_o
);

    reg snap_show_i,snap_status_i,snap_pending,snap_loading;
    reg[2:0]snap_page_i,snap_save_state;reg[1:0]snap_cursor_i;
    reg[239:0]snap_values;reg vs_d;
    wire capture=vs_d&&!vsync_i;
    always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin vs_d<=1;snap_show_i<=0;snap_status_i<=0;snap_page_i<=0;snap_cursor_i<=0;
        snap_values<=0;snap_save_state<=0;snap_pending<=0;snap_loading<=0;end
      else begin vs_d<=vsync_i;
        if(capture)begin snap_show_i<=show_i;snap_status_i<=status_i;snap_page_i<=page_i;
          snap_cursor_i<=cursor_i;snap_values<=value_bus;snap_save_state<=save_state;
          snap_pending<=pending_i;snap_loading<=loading_i;end
      end
    end
    localparam [11:0] PANEL_X0 = 12'd992;
    localparam [11:0] PANEL_Y0 = 12'd256;

    localparam [23:0] C_BG     = 24'h102028;
    localparam [23:0] C_TEXT   = 24'h30ff80;
    localparam [23:0] C_CURSOR = 24'hffd000;
    localparam [23:0] C_STATUS = 24'h00e6ff;
    localparam [23:0] C_ERR    = 24'hff4040;

    // ------------------------------------------------------------------
    // 输出光栅坐标（与 de 同拍；高有效场同步期间清零）
    // ------------------------------------------------------------------
    reg [11:0] C_x, C_y;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            C_x <= 12'd0;
            C_y <= 12'd0;
        end
        else if (vsync_i) begin
            C_x <= 12'd0;
            C_y <= 12'd0;
        end
        else if (de_i) begin
            if (C_x == 12'd1279) begin
                C_x <= 12'd0;
                C_y <= (C_y >= 12'd719) ? 12'd0 : (C_y + 12'd1);
            end
            else
                C_x <= C_x + 12'd1;
        end
    end

    wire [11:0] x_i = C_x;
    wire [11:0] y_i = C_y;

    // 本模块自己的帧首：de 的第一个像素
    wire menu_fs = de_i && (C_x == 12'd0) && (C_y == 12'd0);

    // ------------------------------------------------------------------
    // 几何
    // ------------------------------------------------------------------
    wire [11:0] dx = x_i - PANEL_X0;
    wire [11:0] dy = y_i - PANEL_Y0;

    wire in_panel = (x_i >= PANEL_X0) && (x_i < (PANEL_X0 + 12'd288)) &&
                    (y_i >= PANEL_Y0) && (y_i < (PANEL_Y0 + 12'd224));
    wire in_line  = (x_i >= PANEL_X0) && (x_i < (PANEL_X0 + 12'd288)) &&
                    (y_i >= PANEL_Y0) && (y_i < (PANEL_Y0 + 12'd16));
    wire visible  = snap_show_i ? in_panel : (snap_status_i && in_line);

    wire [4:0] ccol = dx[8:4];
    wire [3:0] crow = dy[7:4];
    wire [3:0] px   = dx[3:0];
    wire [3:0] py   = dy[3:0];

    wire [3:0] row = snap_show_i ? crow : 4'd0;

    // ------------------------------------------------------------------
    // 参数槽
    // ------------------------------------------------------------------
    function [15:0] f_param;
        input [3:0] idx;
        input [239:0] param_values;
        begin
            case (idx)
                4'd0:  f_param = param_values[15:0];
                4'd1:  f_param = param_values[31:16];
                4'd2:  f_param = param_values[47:32];
                4'd3:  f_param = param_values[63:48];
                4'd4:  f_param = param_values[79:64];
                4'd5:  f_param = param_values[95:80];
                4'd6:  f_param = param_values[111:96];
                4'd7:  f_param = param_values[127:112];
                4'd8:  f_param = param_values[143:128];
                4'd9:  f_param = param_values[159:144];
                4'd10: f_param = param_values[175:160];
                4'd11: f_param = param_values[191:176];
                4'd12: f_param = param_values[207:192];
                4'd13: f_param = param_values[223:208];
                default: f_param = param_values[239:224];
            endcase
        end
    endfunction

    reg [3:0] idx0, idx1, idx2, idx3;
    reg       rat0, rat1, rat2, rat3;
    always @(*) begin
        case (snap_page_i)
            3'd0: begin idx0=4'd0;  idx1=4'd1;  idx2=4'd2;  idx3=4'd0;  rat0=1'b0; rat1=1'b1; rat2=1'b1; rat3=1'b0; end
            3'd1: begin idx0=4'd3;  idx1=4'd4;  idx2=4'd5;  idx3=4'd0;  rat0=1'b0; rat1=1'b1; rat2=1'b1; rat3=1'b0; end
            3'd2: begin idx0=4'd6;  idx1=4'd7;  idx2=4'd8;  idx3=4'd0;  rat0=1'b0; rat1=1'b1; rat2=1'b1; rat3=1'b0; end
            3'd3: begin idx0=4'd9;  idx1=4'd10; idx2=4'd11; idx3=4'd0;  rat0=1'b0; rat1=1'b1; rat2=1'b1; rat3=1'b0; end
            default: begin idx0=4'd12; idx1=4'd13; idx2=4'd14; idx3=4'd0; rat0=1'b0; rat1=1'b0; rat2=1'b0; rat3=1'b0; end
        endcase
    end

    // Q5 小数表：rem*1000/32 四舍五入（0..969）
    function [9:0] f_frac;
        input [4:0] rem;
        begin
            case (rem)
                5'd0:  f_frac = 10'd0;   5'd1:  f_frac = 10'd31;  5'd2:  f_frac = 10'd63;
                5'd3:  f_frac = 10'd94;  5'd4:  f_frac = 10'd125; 5'd5:  f_frac = 10'd156;
                5'd6:  f_frac = 10'd188; 5'd7:  f_frac = 10'd219; 5'd8:  f_frac = 10'd250;
                5'd9:  f_frac = 10'd281; 5'd10: f_frac = 10'd313; 5'd11: f_frac = 10'd344;
                5'd12: f_frac = 10'd375; 5'd13: f_frac = 10'd406; 5'd14: f_frac = 10'd438;
                5'd15: f_frac = 10'd469; 5'd16: f_frac = 10'd500; 5'd17: f_frac = 10'd531;
                5'd18: f_frac = 10'd563; 5'd19: f_frac = 10'd594; 5'd20: f_frac = 10'd625;
                5'd21: f_frac = 10'd656; 5'd22: f_frac = 10'd688; 5'd23: f_frac = 10'd719;
                5'd24: f_frac = 10'd750; 5'd25: f_frac = 10'd781; 5'd26: f_frac = 10'd813;
                5'd27: f_frac = 10'd844; 5'd28: f_frac = 10'd875; 5'd29: f_frac = 10'd906;
                5'd30: f_frac = 10'd938; default: f_frac = 10'd969;
            endcase
        end
    endfunction

    // 每槽显示 5 个字符位 V4..V0：
    //   整数：V4 空，V3..V0 = 千/百/十/个
    //   比例：V4 = 整数位，V3..V1 = 三位小数，V0 不用
    reg [3:0] A4,A3,A2,A1,A0;
    reg [3:0] B4,B3,B2,B1,B0;
    reg [3:0] C4,C3,C2,C1,C0;
    reg [3:0] E4,E3,E2,E1,E0;

    // 双 dabble：每个 BCD 位 >=5 先 +3，再整体左移并入 1 位
    function [15:0] f_dabble;
        input [15:0] bcd;
        input        bit_in;
        reg [3:0] n0, n1, n2, n3;
        begin
            n0 = (bcd[3:0]   >= 4'd5) ? (bcd[3:0]   + 4'd3) : bcd[3:0];
            n1 = (bcd[7:4]   >= 4'd5) ? (bcd[7:4]   + 4'd3) : bcd[7:4];
            n2 = (bcd[11:8]  >= 4'd5) ? (bcd[11:8]  + 4'd3) : bcd[11:8];
            n3 = (bcd[15:12] >= 4'd5) ? (bcd[15:12] + 4'd3) : bcd[15:12];
            f_dabble = {n3[2:0], n2, n1, n0, bit_in};
        end
    endfunction

    reg[1:0]S_slot;reg[3:0]S_bit;reg[15:0]S_bcd;reg[12:0]S_src;
    reg S_busy,S_start;
    wire[3:0]slot_index=S_slot==0?idx0:S_slot==1?idx1:idx2;
    wire slot_rat=S_slot==0?rat0:S_slot==1?rat1:rat2;
    wire[15:0]slot_value=f_param(slot_index,snap_values);
    wire[15:0]S_bcd_new=f_dabble(S_bcd,S_src[12]);
    reg vs_d2;
    always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin
        {A4,A3,A2,A1,A0}<=0;{B4,B3,B2,B1,B0}<=0;{C4,C3,C2,C1,C0}<=0;
        {E4,E3,E2,E1,E0}<=0;S_slot<=0;S_bit<=0;S_bcd<=0;S_src<=0;S_busy<=0;S_start<=0;vs_d2<=0;
      end else begin
        vs_d2<=capture;
        if(vs_d2)begin S_busy<=1;S_start<=1;S_slot<=0;end
        else if(S_busy)begin
          if(S_start)begin
            S_src<=slot_rat?{3'd0,f_frac(slot_value[4:0])}:slot_value[12:0];
            S_bcd<=0;S_bit<=0;S_start<=0;
          end else begin
            S_src<={S_src[11:0],1'b0};S_bcd<=S_bcd_new;
            if(S_bit==12)begin
              case(S_slot)
                0:begin A4<=slot_rat?slot_value[8:5]:0;A3<=S_bcd_new[15:12];A2<=S_bcd_new[11:8];A1<=S_bcd_new[7:4];A0<=S_bcd_new[3:0];end
                1:begin B4<=slot_rat?slot_value[8:5]:0;B3<=S_bcd_new[15:12];B2<=S_bcd_new[11:8];B1<=S_bcd_new[7:4];B0<=S_bcd_new[3:0];end
                2:begin C4<=slot_rat?slot_value[8:5]:0;C3<=S_bcd_new[15:12];C2<=S_bcd_new[11:8];C1<=S_bcd_new[7:4];C0<=S_bcd_new[3:0];end
              endcase
              if(S_slot==2)S_busy<=0;else begin S_slot<=S_slot+1'b1;S_start<=1;end
            end else S_bit<=S_bit+1'b1;
          end
        end
      end
    end

    // ------------------------------------------------------------------
    // 文本
    // ------------------------------------------------------------------
    reg [7:0] S_char;

    function [7:0] f_hex;
        input [3:0] n;
        begin
            f_hex = (n < 4'd10) ? ({4'd0, n} + 8'h30) : ({4'd0, n} + 8'h37);
        end
    endfunction

    function [7:0] f_status_char;
        input [3:0] c;
        reg  [7:0] o;
        begin
            o = 8'h20;
            case (snap_save_state)
                3'd1: case (c) 4'd0:o="P";4'd1:o="E";4'd2:o="N";4'd3:o="D";4'd4:o="I";4'd5:o="N";4'd6:o="G";default:; endcase
                3'd2: case (c) 4'd0:o="S";4'd1:o="A";4'd2:o="V";4'd3:o="I";4'd4:o="N";4'd5:o="G";default:; endcase
                3'd3: case (c) 4'd0:o="S";4'd1:o="A";4'd2:o="V";4'd3:o="E";4'd4:o="D";default:; endcase
                3'd4: case (c) 4'd0:o="S";4'd1:o="A";4'd2:o="V";4'd3:o="E";4'd5:o="E";4'd6:o="R";4'd7:o="R";default:; endcase
                default: case (c) 4'd0:o="I";4'd1:o="D";4'd2:o="L";4'd3:o="E";default:; endcase
            endcase
            f_status_char = o;
        end
    endfunction

    function [7:0] f_page_char;
        input [3:0] c;
        reg  [7:0] o;
        begin
            o = 8'h20;
            case (snap_page_i)
                3'd0: case (c) 4'd0:o="R";4'd1:o="E";4'd2:o="D";default:; endcase
                3'd1: case (c) 4'd0:o="G";4'd1:o="R";4'd2:o="E";4'd3:o="E";4'd4:o="N";default:; endcase
                3'd2: case (c) 4'd0:o="D";4'd1:o="E";4'd2:o="E";4'd3:o="P";4'd4:o=" ";4'd5:o="B";4'd6:o="L";4'd7:o="U";4'd8:o="E";default:; endcase
                3'd3: case (c) 4'd0:o="L";4'd1:o="I";4'd2:o="G";4'd3:o="H";4'd4:o="T";4'd5:o=" ";4'd6:o="B";4'd7:o="L";4'd8:o="U";4'd9:o="E";default:; endcase
                3'd4: case (c) 4'd0:o="G";4'd1:o="L";4'd2:o="O";4'd3:o="B";4'd4:o="A";4'd5:o="L";default:; endcase
                default:;
            endcase
            f_page_char = o;
        end
    endfunction

    function [7:0] f_name;
        input [3:0] c;
        input [1:0] w;
        reg  [7:0] o;
        begin
            o = 8'h20;
            if (snap_page_i == 3'd4) begin
                if (w == 2'd0) begin
                    if (c == 4'd2) o = "L";
                    if (c == 4'd3) o = "U";
                    if (c == 4'd4) o = "M";
                    if (c == 4'd5) o = "A";
                end
                else if (w == 2'd1) begin
                    if (c == 4'd2) o = "S";
                    if (c == 4'd3) o = "A";
                    if (c == 4'd4) o = "T";
                end
                else begin
                    if (c == 4'd1) o = "A";
                    if (c == 4'd2) o = "R";
                    if (c == 4'd3) o = "E";
                    if (c == 4'd4) o = "A";
                    if (c == 4'd6) o = "S";
                    if (c == 4'd7) o = "A";
                    if (c == 4'd8) o = "M";
                    if (c == 4'd9) o = "P";
                    if (c == 4'd10) o = "L";
                    if (c == 4'd11) o = "E";
                    if (c == 4'd12) o = "S";

                end
            end
            else if (w == 2'd0) begin
                if (c == 4'd2) o = "D";
                if (c == 4'd3) o = "I";
                if (c == 4'd4) o = "F";
                if (c == 4'd5) o = "F";
            end
            else begin
                if (c == 4'd2) o = (snap_page_i == 3'd0) ? "R" : (snap_page_i == 3'd1 || (snap_page_i == 3'd3 && w == 2'd2)) ? "G" : "B";
                if (c == 4'd3) o = "/";
                if (c == 4'd4) o = (w == 2'd1) ?
                                   ((snap_page_i == 3'd0) ? "G" : (snap_page_i == 3'd1) ? "R" : "R") :
                                   ((snap_page_i == 3'd0) ? "B" : (snap_page_i == 3'd1) ? "B" : (snap_page_i == 3'd2) ? "G" : "R");
            end
            f_name = o;
        end
    endfunction

    function [7:0] f_val;
        input [4:0] c;
        input [1:0] w;
        reg [3:0] v4,v3,v2,v1,v0;
        reg       is_rat;
        begin
            case (w)
                2'd0: begin v4=A4;v3=A3;v2=A2;v1=A1;v0=A0; is_rat=rat0; end
                2'd1: begin v4=B4;v3=B3;v2=B2;v1=B1;v0=B0; is_rat=rat1; end
                default: begin v4=C4;v3=C3;v2=C2;v1=C1;v0=C0; is_rat=rat2; end
            endcase

            f_val = 8'h20;
            if (is_rat) begin
                if (c == 5'd13) f_val = {4'd0, v4} + 8'h30;
                if (c == 5'd14) f_val = ".";
                if (c == 5'd15) f_val = {4'd0, v2} + 8'h30;
                if (c == 5'd16) f_val = {4'd0, v1} + 8'h30;
                if (c == 5'd17) f_val = {4'd0, v0} + 8'h30;
            end
            else begin
                if (c == 5'd14 && v3 != 4'd0) f_val = {4'd0, v3} + 8'h30;
                if (c == 5'd15 && (v3 != 4'd0 || v2 != 4'd0)) f_val = {4'd0, v2} + 8'h30;
                if (c == 5'd16 && (v3 != 4'd0 || v2 != 4'd0 || v1 != 4'd0)) f_val = {4'd0, v1} + 8'h30;
                if (c == 5'd17) f_val = {4'd0, v0} + 8'h30;
            end
        end
    endfunction

    always @(*) begin
        S_char = 8'h20;

        if (!snap_show_i) begin
            // Ten cells for a short page label plus eight for SAVE ERR.
            // LIGHTBLUE uses nine cells; cell nine stays blank on every page.
            if (ccol <= 5'd9) begin
                if (snap_page_i == 3'd3) begin
                    case (ccol)
                        5'd0:S_char="L";5'd1:S_char="I";5'd2:S_char="G";
                        5'd3:S_char="H";5'd4:S_char="T";5'd5:S_char="B";
                        5'd6:S_char="L";5'd7:S_char="U";5'd8:S_char="E";
                        default:S_char=" ";
                    endcase
                end else S_char = f_page_char(ccol[3:0]);
            end else if (ccol >= 5'd10)
                S_char = f_status_char(ccol[3:0] - 4'd10);
        end
        else begin
            case (row)
                4'd0: begin
                    case (ccol)
                        5'd0: S_char = "C";
                        5'd1: S_char = "O";
                        5'd2: S_char = "L";
                        5'd3: S_char = "O";
                        5'd4: S_char = "R";
                        default: if (ccol >= 5'd6) S_char = f_page_char(ccol[3:0] - 4'd6);
                    endcase
                end
                4'd2: begin
                    if (ccol == 5'd0) S_char = (snap_cursor_i == 2'd0) ? ">" : 8'h20;
                    else if (ccol <= 5'd10) S_char = f_name(ccol[3:0], 2'd0);
                    else S_char = f_val(ccol, 2'd0);
                end
                4'd3: begin
                    if (ccol == 5'd0) S_char = (snap_cursor_i == 2'd1) ? ">" : 8'h20;
                    else if (ccol <= 5'd10) S_char = f_name(ccol[3:0], 2'd1);
                    else S_char = f_val(ccol, 2'd1);
                end
                4'd4: begin
                    if (ccol == 5'd0) S_char = (snap_cursor_i == 2'd2) ? ">" : 8'h20;
                    else if (ccol <= (snap_page_i==4 ? 5'd12 : 5'd10)) S_char = f_name(ccol[3:0], 2'd2);
                    else S_char = f_val(ccol, 2'd2);
                end
                4'd5: begin
                    if (snap_page_i == 3'd4) begin
                        if (ccol == 5'd0) S_char = (snap_cursor_i == 2'd3) ? ">" : 8'h20;
                        if (ccol == 5'd2) S_char = "D";
                        if (ccol == 5'd3) S_char = "E";
                        if (ccol == 5'd4) S_char = "F";
                        if (ccol == 5'd5) S_char = "A";
                        if (ccol == 5'd6) S_char = "U";
                        if (ccol == 5'd7) S_char = "L";
                        if (ccol == 5'd8) S_char = "T";
                    end
                end
                4'd7: begin
                    case (ccol)
                        5'd0: S_char="K"; 5'd1: S_char="1"; 5'd3: S_char="P";
                        5'd4: S_char="R"; 5'd5: S_char="E"; 5'd6: S_char="V";
                        5'd8: S_char="K"; 5'd9: S_char="2"; 5'd11:S_char="N";
                        5'd12:S_char="E"; 5'd13:S_char="X"; 5'd14:S_char="T";
                        default: ;
                    endcase
                end
                4'd8: begin
                    case (ccol)
                        5'd0: S_char="K"; 5'd1: S_char="3"; 5'd2: S_char="-";
                        5'd4: S_char="K"; 5'd5: S_char="4"; 5'd6: S_char="+";
                        5'd8: S_char="K"; 5'd9: S_char="2"; 5'd10:S_char="H";
                        5'd11:S_char="O"; 5'd12:S_char="L"; 5'd13:S_char="D";
                        default: ;
                    endcase
                end
                4'd9: if (ccol <= 5'd9) S_char = f_status_char(ccol[3:0]);
                4'd10: begin
                    case (ccol) // SW1 physical down=0, up=1.
                        5'd0:S_char="S";5'd1:S_char="W";5'd2:S_char="1";
                        5'd4:S_char="0";5'd5:S_char="R";5'd6:S_char="G";5'd7:S_char="B";
                        5'd9:S_char="1";5'd10:S_char="H";5'd11:S_char="I";5'd12:S_char="T";
                        default:;
                    endcase
                end
                default: ;
            endcase
        end
    end

    // ------------------------------------------------------------------
    // 字形 + 程序化标点
    // ------------------------------------------------------------------
    wire [7:0]draw_char=(row==11&&snap_show_i&&snap_pending&&ccol<8)?
      ((64'h4150504c59494e47 >> ((7-ccol)*8))&255):
      (row==0&&!snap_show_i&&snap_loading&&ccol<10)?
      ((ccol<7)?((56'h4c4f4144494e47 >> ((6-ccol)*8))&255):8'h20):S_char;
    wire [15:0] S_glyph;
    osd_char_lib u_font (
        .I_char     (draw_char),
        .I_row      (py),
        .O_row_bits (S_glyph)
    );

    wire glyph_bit = S_glyph[15 - px];

    wire dot_on   = (draw_char == 8'h2e) && (px >= 4'd12) && (px <= 4'd14) &&
                    (py >= 4'd12) && (py <= 4'd14);
    wire dash_on  = (draw_char == 8'h2d) && (py == 4'd8) && (px >= 4'd4) && (px <= 4'd11);
    wire plus_on  = (draw_char == 8'h2b) &&
                    (((py == 4'd8) && (px >= 4'd4) && (px <= 4'd11)) ||
                     ((px == 4'd8) && (py >= 4'd4) && (py <= 4'd11)));
    wire slash_on = (draw_char == 8'h2f) && (({1'b0, px} + {1'b0, py}) == 6'd19) &&
                    (px >= 4'd6) && (px <= 4'd13);
    wire gt_on    = (draw_char == 8'h3e) && (py >= 4'd4) && (py <= 4'd11) &&
                    (px >= 4'd5) && (px <= 4'd10) &&
                    ((px - 4'd5) == ((py > 4'd7) ? (4'd11 - py) : (py - 4'd4)));
    wire punct_on = dot_on || dash_on || plus_on || slash_on || gt_on;

    wire text_on = glyph_bit || punct_on;

    wire cursor_row = ((row == 4'd2 && snap_cursor_i == 2'd0) ||
                      (row == 4'd3 && snap_cursor_i == 2'd1) ||
                      (row == 4'd4 && snap_cursor_i == 2'd2) ||
                      (row == 4'd5 && snap_cursor_i == 2'd3 && snap_page_i == 3'd4));

    always @(*) begin
        hit_o   = 1'b0;
        color_o = 24'd0;
        if (de_i && visible) begin
            hit_o   = 1'b1;
            color_o = C_BG;
            if (text_on) begin
                if (!snap_show_i)
                    color_o = (snap_save_state == 3'd4) ? C_ERR : C_STATUS;
                else if (row == 4'd9)
                    color_o = (snap_save_state == 3'd4) ? C_ERR : C_STATUS;
                else if (cursor_row)
                    color_o = C_CURSOR;
                else
                    color_o = C_TEXT;
            end
        end
    end

endmodule
