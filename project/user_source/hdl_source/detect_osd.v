// ============================================================================
// detect_osd —— M3 检测结果叠加（包围框线 + 文字标签 + 目标中心坐标）
//
// 依据：docs/source_map.md（坐标相位）、docs/interfaces.md（接口契约）、
//       工程规划 §6.2.3（位置取包围框中心）与 §6.3（OSD 显示坐标）。
//
// 坐标系：输入 x_i / y_i 必须与本拍输出像素严格同拍。
//         在 hdmi_mixer 中送 S_x_2d / S_y_2d（与既有 Logo / 文字 / 计数同相位，
//         见 source_map.md §3.2）。
//
// 叠加优先级（高 → 低）：
//   红框线 > 绿框线 > 蓝框线 > 三色标签 > 三色中心坐标
// 既有安路 Logo / 文字 / 计数（S_osd_hit）整体高于本模块，由 hdmi_mixer 的输出
// 逻辑保证。
//
// 布局（字符格 32x32，16x16 点阵 2 倍放大；列/行索引只用位选，无乘法器）：
//   y = IMG_H-112 .. IMG_H-80 : "RED" x<96  | "R<cx>x<cy>" x = 96..384
//   y = IMG_H-80 .. IMG_H-48 : "GRN" x<96  | "G<cx>x<cy>" x = 96..384
//   y = IMG_H-48 .. IMG_H-16 : "BLU" x<96 | "B<cx>x<cy>" x = 96..384
//   显示格式：标识 + x 4 位 + 'x' + y 3 位（前导零显示为空格，宽度固定不变）
//
// 中心坐标（工程规划 §6.2.3）：
//   cx = (xmin + xmax) >> 1,  cy = (ymin + ymax) >> 1
//   十进制拆分（/10 /100 /1000）**只出现在帧级锁存路径**，且分两级寄存器完成：
//     第 1 级：帧首脉冲 user_i 锁存中心值（cx/cy）；
//     第 2 级：user_i 打一拍后把中心值拆成字符码。
//   因此像素组合路径只做区域判定、字符码选择、字形查表与位选，
//   没有除法器 / 乘法器进入像素路径（与既有设计口径一致）。
//
// 字形数据取自官方 osd_char_lib.v（Lab3 OSD 例程）的 16x16 点阵，
// **仅复用数据、不实例化字库**：以程序化方式提取对应字符条目后内联（字符码用
// ASCII：'0'..'9' = 0x30..0x39、'x' = 0x58、'R' = 0x52、'E' = 0x45、
// 'D' = 0x44、'G' = 0x47、'N' = 0x4E），提取结果已与 osd_char_lib.v 逐行核对。
// ============================================================================

module detect_osd #(
    parameter integer IMG_W     = 1280,
    parameter integer IMG_H     = 720,
    parameter integer BOX_W     = 3,          // 框线宽（像素）
    parameter [23:0]  COLOR_RED = 24'hff0000, // 红色目标框
    parameter [23:0]  COLOR_GRN = 24'h00ff00, // 绿色目标框
    parameter [23:0]  COLOR_BLU = 24'h0080ff, // Blue outline
    parameter [23:0]  COLOR_LBL = 24'hffffff, // 标签文字（RED / GRN）
    parameter [23:0]  COLOR_CTR = 24'hffd000, // 中心坐标文字（琥珀色，与标签区分）
    parameter integer CX_BASE   = 96          // 中心坐标显示起点（必须为 32 的倍数）
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        user_i,        // 帧首脉冲（中心坐标十进制拆分用）
    input  wire        de_i,          // 与输出像素同拍的 DE（= S_video_de_2d）
    input  wire [11:0] x_i,           // 与输出像素同拍的坐标（= S_x_2d）
    input  wire [11:0] y_i,           // 与输出像素同拍的坐标（= S_y_2d）

    input  wire        r_valid_i,
    input  wire [31:0] r_area_i,
    input  wire [11:0] r_xmin_i,
    input  wire [11:0] r_xmax_i,
    input  wire [11:0] r_ymin_i,
    input  wire [11:0] r_ymax_i,

    input  wire        g_valid_i,
    input  wire [31:0] g_area_i,
    input  wire [11:0] g_xmin_i,
    input  wire [11:0] g_xmax_i,
    input  wire [11:0] g_ymin_i,
    input  wire [11:0] g_ymax_i,

    input wire          b_valid_i,
    input wire [31:0]   b_area_i,
    input wire [11:0]   b_xmin_i,
    input wire [11:0]   b_xmax_i,
    input wire [11:0]   b_ymin_i,
    input wire [11:0]   b_ymax_i,

    output reg         hit_o,
    output reg  [23:0] color_o
);

    // ------------------------------------------------------------------
    // 布局常量
    // ------------------------------------------------------------------
    localparam [11:0] LBL_XMAX = 12'd96;            // 标签占 3 字符 x 32 像素
    localparam [11:0] LBL_R_Y  = IMG_H - 112;        // 红标签/红坐标行起始
    localparam [11:0] LBL_G_Y  = IMG_H - 80;        // 绿标签/绿坐标行起始

    localparam [11:0] LBL_B_Y = IMG_H - 48; // Third row, bottom 16 pixels clear
    localparam [11:0] CX_X0    = CX_BASE[11:0];                    // 96
    localparam [11:0] CX_X1    = CX_BASE[11:0] + 12'd9 * 12'd32;   // 96 + 288 = 384

    // ------------------------------------------------------------------
    // 16x16 字形数据（取自官方 osd_char_lib.v，仅数据复用）
    //   c: '0'..'9' / 'x' / 'R' / 'E' / 'D' / 'G' / 'N'
    // ------------------------------------------------------------------
    function [15:0] F_glyph;
        input [7:0] c;
        input [3:0] r;
        begin
            case (c)
                8'h30: case (r)                       // '0'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h300c; 4'd4 : F_glyph = 16'h300c;
                    4'd5 : F_glyph = 16'h300c; 4'd8 : F_glyph = 16'h300c;
                    4'd9 : F_glyph = 16'h300c; 4'd10: F_glyph = 16'h300c;
                    4'd11: F_glyph = 16'h1ff8; 4'd12: F_glyph = 16'h1ff8;
                    default: F_glyph = 16'h0000;
                endcase
                8'h31: case (r)                       // '1'
                    4'd1 : F_glyph = 16'h000c; 4'd2 : F_glyph = 16'h000c;
                    4'd3 : F_glyph = 16'h000c; 4'd4 : F_glyph = 16'h000c;
                    4'd5 : F_glyph = 16'h000c; 4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c; 4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h000c; 4'd12: F_glyph = 16'h000c;
                    default: F_glyph = 16'h0000;
                endcase
                8'h32: case (r)                       // '2'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h000c; 4'd4 : F_glyph = 16'h000c;
                    4'd5 : F_glyph = 16'h000c; 4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8; 4'd8 : F_glyph = 16'h3000;
                    4'd9 : F_glyph = 16'h3000; 4'd10: F_glyph = 16'h3000;
                    4'd11: F_glyph = 16'h1ff8; 4'd12: F_glyph = 16'h1ff8;
                    default: F_glyph = 16'h0000;
                endcase
                8'h33: case (r)                       // '3'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h000c; 4'd4 : F_glyph = 16'h000c;
                    4'd5 : F_glyph = 16'h000c; 4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8; 4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c; 4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h1ff8; 4'd12: F_glyph = 16'h1ff8;
                    default: F_glyph = 16'h0000;
                endcase
                8'h34: case (r)                       // '4'
                    4'd1 : F_glyph = 16'h300c; 4'd2 : F_glyph = 16'h300c;
                    4'd3 : F_glyph = 16'h300c; 4'd4 : F_glyph = 16'h300c;
                    4'd5 : F_glyph = 16'h300c; 4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8; 4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c; 4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h000c; 4'd12: F_glyph = 16'h000c;
                    default: F_glyph = 16'h0000;
                endcase
                8'h35: case (r)                       // '5'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h3000; 4'd4 : F_glyph = 16'h3000;
                    4'd5 : F_glyph = 16'h3000; 4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8; 4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c; 4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h1ff8; 4'd12: F_glyph = 16'h1ff8;
                    default: F_glyph = 16'h0000;
                endcase
                8'h36: case (r)                       // '6'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h3000; 4'd4 : F_glyph = 16'h3000;
                    4'd5 : F_glyph = 16'h3000; 4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8; 4'd8 : F_glyph = 16'h300c;
                    4'd9 : F_glyph = 16'h300c; 4'd10: F_glyph = 16'h300c;
                    4'd11: F_glyph = 16'h1ff8; 4'd12: F_glyph = 16'h1ff8;
                    default: F_glyph = 16'h0000;
                endcase
                8'h37: case (r)                       // '7'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h000c; 4'd4 : F_glyph = 16'h000c;
                    4'd5 : F_glyph = 16'h000c; 4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c; 4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h000c; 4'd12: F_glyph = 16'h000c;
                    default: F_glyph = 16'h0000;
                endcase
                8'h38: case (r)                       // '8'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h300c; 4'd4 : F_glyph = 16'h300c;
                    4'd5 : F_glyph = 16'h300c; 4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8; 4'd8 : F_glyph = 16'h300c;
                    4'd9 : F_glyph = 16'h300c; 4'd10: F_glyph = 16'h300c;
                    4'd11: F_glyph = 16'h1ff8; 4'd12: F_glyph = 16'h1ff8;
                    default: F_glyph = 16'h0000;
                endcase
                8'h39: case (r)                       // '9'
                    4'd1 : F_glyph = 16'h1ff8; 4'd2 : F_glyph = 16'h1ff8;
                    4'd3 : F_glyph = 16'h300c; 4'd4 : F_glyph = 16'h300c;
                    4'd5 : F_glyph = 16'h300c; 4'd6 : F_glyph = 16'h1ff8;
                    4'd7 : F_glyph = 16'h1ff8; 4'd8 : F_glyph = 16'h000c;
                    4'd9 : F_glyph = 16'h000c; 4'd10: F_glyph = 16'h000c;
                    4'd11: F_glyph = 16'h1ff8; 4'd12: F_glyph = 16'h1ff8;
                    default: F_glyph = 16'h0000;
                endcase
                8'h58: case (r)                       // 'x'
                    4'd2 : F_glyph = 16'h3e00; 4'd3 : F_glyph = 16'h1c00;
                    4'd4 : F_glyph = 16'h1c00; 4'd5 : F_glyph = 16'h0800;
                    4'd6 : F_glyph = 16'h1c00; 4'd7 : F_glyph = 16'h1400;
                    4'd8 : F_glyph = 16'h3600; 4'd9 : F_glyph = 16'h3200;
                    default: F_glyph = 16'h0000;
                endcase
                8'h52: case (r)                       // 'R'
                    4'd2 : F_glyph = 16'h3e00; 4'd3 : F_glyph = 16'h3300;
                    4'd4 : F_glyph = 16'h3300; 4'd5 : F_glyph = 16'h3300;
                    4'd6 : F_glyph = 16'h3c00; 4'd7 : F_glyph = 16'h3600;
                    4'd8 : F_glyph = 16'h3600; 4'd9 : F_glyph = 16'h3200;
                    default: F_glyph = 16'h0000;
                endcase
                8'h45: case (r)                       // 'E'
                    4'd2 : F_glyph = 16'h3e00; 4'd3 : F_glyph = 16'h3000;
                    4'd4 : F_glyph = 16'h3000; 4'd5 : F_glyph = 16'h3e00;
                    4'd6 : F_glyph = 16'h3000; 4'd7 : F_glyph = 16'h3000;
                    4'd8 : F_glyph = 16'h3000; 4'd9 : F_glyph = 16'h3e00;
                    default: F_glyph = 16'h0000;
                endcase
                8'h44: case (r)                       // 'D'
                    4'd2 : F_glyph = 16'h3e00; 4'd3 : F_glyph = 16'h3300;
                    4'd4 : F_glyph = 16'h3300; 4'd5 : F_glyph = 16'h3300;
                    4'd6 : F_glyph = 16'h3300; 4'd7 : F_glyph = 16'h3300;
                    4'd8 : F_glyph = 16'h3600; 4'd9 : F_glyph = 16'h3c00;
                    default: F_glyph = 16'h0000;
                endcase
                8'h47: case (r)                       // 'G'
                    4'd2 : F_glyph = 16'h1c00; 4'd3 : F_glyph = 16'h3200;
                    4'd4 : F_glyph = 16'h6000; 4'd5 : F_glyph = 16'h6000;
                    4'd6 : F_glyph = 16'h6e00; 4'd7 : F_glyph = 16'h6600;
                    4'd8 : F_glyph = 16'h3600; 4'd9 : F_glyph = 16'h1e00;
                    default: F_glyph = 16'h0000;
                endcase
                8'h4e: case (r)                       // 'N'
                    4'd2 : F_glyph = 16'h300c; 4'd3 : F_glyph = 16'h380c;
                    4'd4 : F_glyph = 16'h3c0c; 4'd5 : F_glyph = 16'h360c;
                    4'd6 : F_glyph = 16'h330c; 4'd7 : F_glyph = 16'h318c;
                    4'd8 : F_glyph = 16'h30cc; 4'd9 : F_glyph = 16'h306c;
                    4'd10: F_glyph = 16'h303c; 4'd11: F_glyph = 16'h301c;
                    4'd12: F_glyph = 16'h300c;
                    default: F_glyph = 16'h0000;
                endcase
                8'h42: case (r) // 'B', official glyph data

                    4'd0: F_glyph = 16'h0000;
                    4'd1: F_glyph = 16'h0000;
                    4'd2: F_glyph = 16'h3e00;
                    4'd3: F_glyph = 16'h3300;
                    4'd4: F_glyph = 16'h3300;
                    4'd5: F_glyph = 16'h3e00;
                    4'd6: F_glyph = 16'h3300;
                    4'd7: F_glyph = 16'h3300;
                    4'd8: F_glyph = 16'h3300;
                    4'd9: F_glyph = 16'h3e00;
                    4'd10: F_glyph = 16'h0000;
                    4'd11: F_glyph = 16'h0000;
                    4'd12: F_glyph = 16'h0000;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                    default: F_glyph = 16'h0000;
                                endcase
                8'h4c: case (r) // 'L', official glyph data

                    4'd0: F_glyph = 16'h0000;
                    4'd1: F_glyph = 16'h0000;
                    4'd2: F_glyph = 16'h3000;
                    4'd3: F_glyph = 16'h3000;
                    4'd4: F_glyph = 16'h3000;
                    4'd5: F_glyph = 16'h3000;
                    4'd6: F_glyph = 16'h3000;
                    4'd7: F_glyph = 16'h3000;
                    4'd8: F_glyph = 16'h3000;
                    4'd9: F_glyph = 16'h3e00;
                    4'd10: F_glyph = 16'h0000;
                    4'd11: F_glyph = 16'h0000;
                    4'd12: F_glyph = 16'h0000;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                    default: F_glyph = 16'h0000;
                                endcase
                8'h55: case (r) // 'U', official glyph data

                    4'd0: F_glyph = 16'h0000;
                    4'd1: F_glyph = 16'h0000;
                    4'd2: F_glyph = 16'h3300;
                    4'd3: F_glyph = 16'h3300;
                    4'd4: F_glyph = 16'h3300;
                    4'd5: F_glyph = 16'h3300;
                    4'd6: F_glyph = 16'h3300;
                    4'd7: F_glyph = 16'h3300;
                    4'd8: F_glyph = 16'h3300;
                    4'd9: F_glyph = 16'h1e00;
                    4'd10: F_glyph = 16'h0000;
                    4'd11: F_glyph = 16'h0000;
                    4'd12: F_glyph = 16'h0000;
                    4'd13: F_glyph = 16'h0000;
                    4'd14: F_glyph = 16'h0000;
                    4'd15: F_glyph = 16'h0000;
                    default: F_glyph = 16'h0000;
                                endcase
                // 其余字符（含前导零抑制用的空格 0x20）不显示
                default: F_glyph = 16'h0000;
            endcase
        end
    endfunction

    // ------------------------------------------------------------------
    // 框线判定
    // ------------------------------------------------------------------
    wire [12:0] x13 = {1'b0, x_i};
    wire [12:0] y13 = {1'b0, y_i};

    wire [12:0] r_xmin13 = {1'b0, r_xmin_i};
    wire [12:0] r_xmax13 = {1'b0, r_xmax_i};
    wire [12:0] r_ymin13 = {1'b0, r_ymin_i};
    wire [12:0] r_ymax13 = {1'b0, r_ymax_i};

    wire [12:0] g_xmin13 = {1'b0, g_xmin_i};
    wire [12:0] g_xmax13 = {1'b0, g_xmax_i};
    wire [12:0] g_ymin13 = {1'b0, g_ymin_i};
    wire [12:0] g_ymax13 = {1'b0, g_ymax_i};

    wire r_in = (r_xmin13 <= x13) && (x13 <= r_xmax13) &&
                (r_ymin13 <= y13) && (y13 <= r_ymax13);
    wire g_in = (g_xmin13 <= x13) && (x13 <= g_xmax13) &&
                (g_ymin13 <= y13) && (y13 <= g_ymax13);

    // 在框内时各差值非负，可安全相减
    wire r_bd = r_in && ( ((x13 - r_xmin13) < BOX_W) ||
                          ((r_xmax13 - x13) < BOX_W) ||
                          ((y13 - r_ymin13) < BOX_W) ||
                          ((r_ymax13 - y13) < BOX_W) );

    wire g_bd = g_in && ( ((x13 - g_xmin13) < BOX_W) ||
                          ((g_xmax13 - x13) < BOX_W) ||
                          ((y13 - g_ymin13) < BOX_W) ||
                          ((g_ymax13 - y13) < BOX_W) );

    wire r_hit = de_i && r_valid_i && r_bd;
    wire g_hit = de_i && g_valid_i && g_bd;

    // ------------------------------------------------------------------
    // 标签判定与字形取点（"RED" / "GRN"，x < 96）
    // ------------------------------------------------------------------
    wire [2:0] lbl_ci  = x_i[6:5];        // 字符索引 0..2
    wire [3:0] lbl_col = x_i[4:1];        // 字符内列（2 倍放大）
    wire [3:0] lbl_row = y_i[4:1];        // 字符内行（两行共用，起始坐标均为 32 倍数）

    wire in_lbl_r = de_i && r_valid_i &&
                    (y_i >= LBL_R_Y) && (y_i < (LBL_R_Y + 12'd32)) && (x_i < LBL_XMAX);
    wire in_lbl_g = de_i && g_valid_i &&
                    (y_i >= LBL_G_Y) && (y_i < (LBL_G_Y + 12'd32)) && (x_i < LBL_XMAX);

    // "RED" = 'R','E','D'        "GRN" = 'G','R','N'
    reg [7:0] lbl_ch_r, lbl_ch_g;
    always @(*) begin
        case (lbl_ci)
            3'd0:    begin lbl_ch_r = 8'h52; lbl_ch_g = 8'h47; end   // R / G
            3'd1:    begin lbl_ch_r = 8'h45; lbl_ch_g = 8'h52; end   // E / R
            default: begin lbl_ch_r = 8'h44; lbl_ch_g = 8'h4e; end   // D / N
        endcase
    end

    wire [15:0] r_bits = F_glyph(lbl_ch_r, lbl_row);
    wire [15:0] g_bits = F_glyph(lbl_ch_g, lbl_row);

    wire r_lbl_px = in_lbl_r && r_bits[4'd15 - lbl_col];
    wire g_lbl_px = in_lbl_g && g_bits[4'd15 - lbl_col];

    // ------------------------------------------------------------------
    // 中心坐标：帧首锁存中心值（第 1 级）
    // ------------------------------------------------------------------
    wire [12:0] r_cxn = {1'b0, r_xmin_i} + {1'b0, r_xmax_i};
    wire [12:0] r_cyn = {1'b0, r_ymin_i} + {1'b0, r_ymax_i};
    wire [12:0] g_cxn = {1'b0, g_xmin_i} + {1'b0, g_xmax_i};
    wire [12:0] g_cyn = {1'b0, g_ymin_i} + {1'b0, g_ymax_i};

    reg        S_user_1d;
    reg [11:0] S_r_cx, S_r_cy, S_g_cx, S_g_cy;

    // 字符码（复位初值空格 0x20，避免上电瞬间显示"0"）
    reg [7:0] S_rxc3, S_rxc2, S_rxc1, S_rxc0, S_ryc2, S_ryc1, S_ryc0;
    reg [7:0] S_gxc3, S_gxc2, S_gxc1, S_gxc0, S_gyc2, S_gyc1, S_gyc0;

    // 十进制拆分：仅组合，输入为 S_r_cx 等已锁存寄存器，输出在下一拍寄存器收
    function [3:0] F_q3;                      // 千位
        input [11:0] v;
        begin F_q3 = (v / 12'd1000); end
    endfunction
    function [3:0] F_q2;                      // 百位
        input [11:0] v;
        begin F_q2 = (v / 12'd100) - F_q3(v) * 4'd10; end
    endfunction
    function [3:0] F_q1;                      // 十位
        input [11:0] v;
        begin F_q1 = (v / 12'd10) - (v / 12'd100) * 4'd10; end
    endfunction
    function [3:0] F_q0;                      // 个位
        input [11:0] v;
        begin F_q0 = v - (v / 12'd10) * 12'd10; end
    endfunction

    // 前导零抑制：高位为 0 → 空格（0x20），宽度保持不变
    function [7:0] F_dig;                     // 数字字符（取输入低 4 位）
        input [11:0] q;
        begin F_dig = 8'h30 + {4'd0, q[3:0]}; end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_user_1d <= 1'b0;
            S_r_cx <= 12'd0; S_r_cy <= 12'd0;
            S_g_cx <= 12'd0; S_g_cy <= 12'd0;
            S_rxc3 <= 8'h20; S_rxc2 <= 8'h20; S_rxc1 <= 8'h20; S_rxc0 <= 8'h20;
            S_ryc2 <= 8'h20; S_ryc1 <= 8'h20; S_ryc0 <= 8'h20;
            S_gxc3 <= 8'h20; S_gxc2 <= 8'h20; S_gxc1 <= 8'h20; S_gxc0 <= 8'h20;
            S_gyc2 <= 8'h20; S_gyc1 <= 8'h20; S_gyc0 <= 8'h20;
        end
        else begin
            S_user_1d <= user_i;

            // 第 1 级：帧首锁存中心坐标（cx = (xmin+xmax)>>1）
            if (user_i) begin
                S_r_cx <= r_cxn[12:1];
                S_r_cy <= r_cyn[12:1];
                S_g_cx <= g_cxn[12:1];
                S_g_cy <= g_cyn[12:1];
            end

            // 第 2 级：次拍拆分字符码（每帧一次的锁存路径，不在像素路径上）
            if (S_user_1d) begin
                S_rxc3 <= (S_r_cx >= 12'd1000) ? F_dig(F_q3(S_r_cx)) : 8'h20;
                S_rxc2 <= (S_r_cx >= 12'd100)  ? F_dig(F_q2(S_r_cx)) : 8'h20;
                S_rxc1 <= (S_r_cx >= 12'd10)   ? F_dig(F_q1(S_r_cx)) : 8'h20;
                S_rxc0 <= F_dig(F_q0(S_r_cx));

                S_ryc2 <= (S_r_cy >= 12'd100)  ? F_dig(F_q2(S_r_cy)) : 8'h20;
                S_ryc1 <= (S_r_cy >= 12'd10)   ? F_dig(F_q1(S_r_cy)) : 8'h20;
                S_ryc0 <= F_dig(F_q0(S_r_cy));

                S_gxc3 <= (S_g_cx >= 12'd1000) ? F_dig(F_q3(S_g_cx)) : 8'h20;
                S_gxc2 <= (S_g_cx >= 12'd100)  ? F_dig(F_q2(S_g_cx)) : 8'h20;
                S_gxc1 <= (S_g_cx >= 12'd10)   ? F_dig(F_q1(S_g_cx)) : 8'h20;
                S_gxc0 <= F_dig(F_q0(S_g_cx));

                S_gyc2 <= (S_g_cy >= 12'd100)  ? F_dig(F_q2(S_g_cy)) : 8'h20;
                S_gyc1 <= (S_g_cy >= 12'd10)   ? F_dig(F_q1(S_g_cy)) : 8'h20;
                S_gyc0 <= F_dig(F_q0(S_g_cy));
            end
        end
    end

    // ------------------------------------------------------------------
    // 中心坐标显示（x = 96..384，与标签同行）
    // ------------------------------------------------------------------
    wire [11:0] cx_lx  = x_i - CX_X0;              // 区域内局部 x
    wire [3:0]  cx_ci  = cx_lx[8:5];               // 字符索引 0..8
    wire [3:0]  cx_col = cx_lx[4:1];               // 字符内列
    wire [3:0]  cx_row = y_i[4:1];                 // 字符内行

    wire in_cx_r = de_i && r_valid_i &&
                   (x_i >= CX_X0) && (x_i < CX_X1) &&
                   (y_i >= LBL_R_Y) && (y_i < (LBL_R_Y + 12'd32));
    wire in_cx_g = de_i && g_valid_i &&
                   (x_i >= CX_X0) && (x_i < CX_X1) &&
                   (y_i >= LBL_G_Y) && (y_i < (LBL_G_Y + 12'd32));

    // 字符码选择（索引 0=标识, 1..4=x 的千/百/十/个, 5='x', 6..8=y 的百/十/个）
    reg [7:0] cx_ch_r, cx_ch_g;
    always @(*) begin
        case (cx_ci)
            4'd0:    begin cx_ch_r = 8'h52; cx_ch_g = 8'h47; end   // 'R' / 'G'
            4'd1:    begin cx_ch_r = S_rxc3; cx_ch_g = S_gxc3; end
            4'd2:    begin cx_ch_r = S_rxc2; cx_ch_g = S_gxc2; end
            4'd3:    begin cx_ch_r = S_rxc1; cx_ch_g = S_gxc1; end
            4'd4:    begin cx_ch_r = S_rxc0; cx_ch_g = S_gxc0; end
            4'd5:    begin cx_ch_r = 8'h58; cx_ch_g = 8'h58; end   // 'x'
            4'd6:    begin cx_ch_r = S_ryc2; cx_ch_g = S_gyc2; end
            4'd7:    begin cx_ch_r = S_ryc1; cx_ch_g = S_gyc1; end
            default: begin cx_ch_r = S_ryc0; cx_ch_g = S_gyc0; end
        endcase
    end

    wire [15:0] cx_bits_r = F_glyph(cx_ch_r, cx_row);
    wire [15:0] cx_bits_g = F_glyph(cx_ch_g, cx_row);

    wire cx_px_r = in_cx_r && cx_bits_r[4'd15 - cx_col];
    wire cx_px_g = in_cx_g && cx_bits_g[4'd15 - cx_col];

    // ------------------------------------------------------------------

    // Blue box and text consume the same sealed frame as the other colors.
    wire [12:0] b_xmin13 = {1'b0, b_xmin_i};
    wire [12:0] b_xmax13 = {1'b0, b_xmax_i};
    wire [12:0] b_ymin13 = {1'b0, b_ymin_i};
    wire [12:0] b_ymax13 = {1'b0, b_ymax_i};
    wire b_in = (b_xmin13 <= x13) && (x13 <= b_xmax13) &&
                (b_ymin13 <= y13) && (y13 <= b_ymax13);
    wire b_bd = b_in && (((x13-b_xmin13) < BOX_W) || ((b_xmax13-x13) < BOX_W) ||
                         ((y13-b_ymin13) < BOX_W) || ((b_ymax13-y13) < BOX_W));
    wire b_hit = de_i && b_valid_i && b_bd;
    wire in_lbl_b = de_i && b_valid_i && (x_i < LBL_XMAX) &&
                    (y_i >= LBL_B_Y) && (y_i < LBL_B_Y+12'd32);
    reg [7:0] lbl_ch_b;
    always @(*) begin
        case (lbl_ci)
            3'd0: lbl_ch_b = 8'h42;
            3'd1: lbl_ch_b = 8'h4c;
            default: lbl_ch_b = 8'h55;
        endcase
    end
    wire [15:0] b_bits = F_glyph(lbl_ch_b, lbl_row);
    wire b_lbl_px = in_lbl_b && b_bits[4'd15-lbl_col];
    wire [12:0] b_cxn = {1'b0,b_xmin_i}+{1'b0,b_xmax_i};
    wire [12:0] b_cyn = {1'b0,b_ymin_i}+{1'b0,b_ymax_i};
    reg [11:0] S_b_cx, S_b_cy;
    reg [7:0] S_bxc3, S_bxc2, S_bxc1, S_bxc0, S_byc2, S_byc1, S_byc0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_b_cx <= 12'd0; S_b_cy <= 12'd0;
            S_bxc3 <= 8'h20; S_bxc2 <= 8'h20; S_bxc1 <= 8'h20; S_bxc0 <= 8'h20;
            S_byc2 <= 8'h20; S_byc1 <= 8'h20; S_byc0 <= 8'h20;
        end else begin
            if (user_i) begin
                S_b_cx <= b_cxn[12:1]; S_b_cy <= b_cyn[12:1];
            end
            if (S_user_1d) begin
                S_bxc3 <= (S_b_cx >= 12'd1000) ? F_dig(F_q3(S_b_cx)) : 8'h20;
                S_bxc2 <= (S_b_cx >= 12'd100) ? F_dig(F_q2(S_b_cx)) : 8'h20;
                S_bxc1 <= (S_b_cx >= 12'd10) ? F_dig(F_q1(S_b_cx)) : 8'h20;
                S_bxc0 <= F_dig(F_q0(S_b_cx));
                S_byc2 <= (S_b_cy >= 12'd100) ? F_dig(F_q2(S_b_cy)) : 8'h20;
                S_byc1 <= (S_b_cy >= 12'd10) ? F_dig(F_q1(S_b_cy)) : 8'h20;
                S_byc0 <= F_dig(F_q0(S_b_cy));
            end
        end
    end
    wire in_cx_b = de_i && b_valid_i && (x_i >= CX_X0) && (x_i < CX_X1) &&
                   (y_i >= LBL_B_Y) && (y_i < LBL_B_Y+12'd32);
    reg [7:0] cx_ch_b;
    always @(*) begin
        case (cx_ci)
            4'd0: cx_ch_b = 8'h42;
            4'd1: cx_ch_b = S_bxc3;
            4'd2: cx_ch_b = S_bxc2;
            4'd3: cx_ch_b = S_bxc1;
            4'd4: cx_ch_b = S_bxc0;
            4'd5: cx_ch_b = 8'h58;
            4'd6: cx_ch_b = S_byc2;
            4'd7: cx_ch_b = S_byc1;
            default: cx_ch_b = S_byc0;
        endcase
    end
    wire [15:0] cx_bits_b = F_glyph(cx_ch_b, cx_row);
    wire cx_px_b = in_cx_b && cx_bits_b[4'd15-cx_col];

    // 输出（红框 > 绿框 > 红标签 > 绿标签 > 红坐标 > 绿坐标）
    // ------------------------------------------------------------------
    always @(*) begin
        hit_o   = 1'b0;
        color_o = 24'd0;

        if (r_hit) begin
            hit_o   = 1'b1;
            color_o = COLOR_RED;
        end
        else if (g_hit) begin
            hit_o   = 1'b1;
            color_o = COLOR_GRN;
        end
        else if (b_hit) begin
            hit_o = 1'b1; color_o = COLOR_BLU;
        end
        else if (r_lbl_px) begin
            hit_o   = 1'b1;
            color_o = COLOR_LBL;
        end
        else if (g_lbl_px) begin
            hit_o   = 1'b1;
            color_o = COLOR_LBL;
        end
        else if (b_lbl_px) begin
            hit_o = 1'b1; color_o = COLOR_LBL;
        end
        else if (cx_px_r) begin
            hit_o   = 1'b1;
            color_o = COLOR_CTR;
        end
        else if (cx_px_g) begin
            hit_o   = 1'b1;
            color_o = COLOR_CTR;
        end
        else if (cx_px_b) begin
            hit_o = 1'b1; color_o = COLOR_CTR;
        end
    end

endmodule
