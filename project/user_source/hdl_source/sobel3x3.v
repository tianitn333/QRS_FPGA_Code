// ============================================================================
// sobel3x3 —— 3×3 邻域 Sobel 边缘检测（灰度域，流式，单像素/拍）
//
// 依据：工程规划 §2 第 6 条（邻域窗口）与 §6.1（边缘检测与阈值）。
//
// 结构：
//   · 行缓存：3 个行缓存合并为一个 3*IMG_W 深的一维数组（同步写 + 同步读，
//     推断为 ERAM）。**不用分布式大寄存器**，也**不照搬 lab2 的 edge_detect_96.v**
//     （那是 96 位 4 像素/拍的流，与本工程 24 位单像素路径不匹配）。
//   · 行选择环：处理第 y 行时写 (y mod 3)，读 (y-1) mod 3 与 (y-2) mod 3。
//   · 水平窗口：三路数据各 3 级移位 → 3×3 窗口。
//   · 梯度：整数 Sobel 核，幅值取 |Gx| + |Gy|（只用加法/移位/比较，无乘法器、无除法器）。
//
// 窗口中心与延迟（明确口径，便于接入对齐与测试）：
//   · 输入拍 P 的像素 (x, y) 产生梯度在拍 P+3；
//   · 窗口中心列 = x-1、中心行 = y-1，即 x_o / y_o 输出的是**窗口中心**坐标
//     （水平滞后 1 像素、垂直滞后 1 行）。
//
// 补边：不存在的像素不参与有效输出——valid_o 仅在窗口三行三列都落在帧内时有效
//   （x_o ∈ [1, IMG_W-2]、y_o ∈ [1, IMG_H-1]，且要求参与窗口的 x-2 / y-2 存在）；
//   边缘列/行的输出为 0（黑边），输出流长度与输入流等长，不破坏 DE / 坐标时序。
//   窗口在边界处可能取到相邻行或上一帧的残留数据，但因 valid_o = 0 不会被使用。
// ============================================================================

module sobel3x3 #(
    parameter integer IMG_W   = 1280,
    parameter integer IMG_H   = 720,
    parameter integer TH      = 96,   // |Gx|+|Gy| 门限
    parameter integer OUT_BIN = 1,    // 1 = 二值边缘（0/255）；0 = 幅值（取低 8 位）
    parameter integer ADAPTIVE_TH = 0, // 默认保持固定阈值，工程实例显式启用自适应
    parameter integer TH_SCALE_Q2 = 4,
    parameter integer TH_MIN = 32     // 自适应阈值下限；要求 0 <= TH_MIN <= TH <= 4095
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_i,       // 与 gray_i 同拍
    input  wire        user_i,        // 帧首脉冲（与第一个有效像素同拍）
    input  wire        last_i,        // 行末脉冲（与最后一个有效像素同拍）
    input  wire [7:0]  gray_i,        // 灰度像素

    output reg         valid_o,
    output reg  [7:0]  edge_o,
    output reg  [11:0] x_o,           // 窗口中心坐标
    output reg  [11:0] y_o,
    // Dense gradient stream for contour preparation; existing outputs are unchanged.
    output reg raster_valid_o, raster_user_o, raster_last_o,
    output reg gradient_polarity_o,
    output reg [1:0] gradient_fine_o,
    output reg [12:0] gradient_o
);

    localparam integer DEPTH  = 3 * IMG_W;   // 仅用于说明：3 行 × IMG_W 像素

    // 列地址位宽：按 IMG_W 自适应（2^ADDR_X >= IMG_W）
    function integer clog2;
        input integer v;
        integer i;
        begin
            clog2 = 0;
            for (i = 1; i < v; i = i * 2) clog2 = clog2 + 1;
        end
    endfunction

    localparam integer ADDR_X = clog2(IMG_W);

    // ------------------------------------------------------------------
    // 1) 像素坐标（与 color_detect_box 同规则：S_px 指向"下一拍"，
    //    x_now 为本拍像素列；帧首拍对应 x=0，故 S_px 置 1）
    // ------------------------------------------------------------------
    reg [11:0] S_px, S_py;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_px <= 12'd0;
            S_py <= 12'd0;
        end
        else if (valid_i) begin
            if (user_i) begin
                S_px <= 12'd1;
                S_py <= 12'd0;
            end
            else if (last_i) begin
                S_px <= 12'd0;
                S_py <= S_py + 12'd1;
            end
            else begin
                S_px <= S_px + 12'd1;
            end
        end
    end

    wire [11:0] x_now = user_i ? 12'd0 : (last_i ? (IMG_W - 1) : S_px);
    wire [11:0] y_now = user_i ? 12'd0 : S_py;

    // ------------------------------------------------------------------
    // 2) 行选择环（每个行末前进一格）
    // ------------------------------------------------------------------
    reg [1:0] S_wr_sel;

    // 写选择指向"当前行"：处理第 y 行时写 (y mod 3)，读 (y-1) mod 3 与 (y-2) mod 3
    wire [1:0] sel1 = (S_wr_sel == 2'd0) ? 2'd2 : (S_wr_sel - 2'd1);  // y-1 行
    wire [1:0] sel2 = (S_wr_sel == 2'd2) ? 2'd0 : (S_wr_sel + 2'd1);  // y-2 行

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            S_wr_sel <= 2'd0;
        else if (valid_i && last_i)
            S_wr_sel <= (S_wr_sel == 2'd2) ? 2'd0 : (S_wr_sel + 2'd1);
    end

    // ------------------------------------------------------------------
    // 3) 行缓存：**3 个 ERAM 块**（每行一块；A 口写、B 口读 → 不会出现同地址读写冲突）
    //
    //    这里必须用 ERAM 原语，而不是行为级数组：后者 TD 会综合成分布式 RAM
    //    （实测 `#eram` 39→39 不增加、`DRAMHARDCON` 37→101、slices 因此 +1264、
    //    占用率升到 81.28%）。原语 = TD 的 ERAM 硬核 `PH1P_LOGIC_ERAM`，
    //    与官方 ISP/AWB 工程里 `blk_mem_gen_*` IP 的例化方式同源。
    //    仿真时由 `sim/tb/ph1p_eram_sim.v` 提供等价行为模型（ModelSim 无该原语模型）。
    // ------------------------------------------------------------------
    wire [ADDR_X-1:0] xa = x_now[ADDR_X-1:0];

    wire we0 = valid_i && (S_wr_sel == 2'd0);
    wire we1 = valid_i && (S_wr_sel == 2'd1);
    wire we2 = valid_i && (S_wr_sel == 2'd2);

    wire [7:0] dob0, dob1, dob2;

    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(8),        .DATA_WIDTH_B(8),
        .ADDR_WIDTH_A(ADDR_X),   .ADDR_WIDTH_B(ADDR_X),
        .DATA_DEPTH_A(IMG_W),    .DATA_DEPTH_B(IMG_W),
        .MODE("DP"),
        .REGMODE_A("NOREG"),     .REGMODE_B("NOREG"),
        .WRITEMODE_A("NORMAL"),  .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"),
        .ECC_ENCODE("DISABLE"),  .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"),
        .SSROVERCE("DISABLE"),
        .OREGSET_A("RESET"),     .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"),   .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("NONE"),      .FILL_ALL("NONE")
    ) u_line0 (
        .dia(gray_i), .addra(xa), .cea(1'b1), .clka(clk), .wea(we0), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(8'd0),   .addrb(xa), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(dob0),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(8),        .DATA_WIDTH_B(8),
        .ADDR_WIDTH_A(ADDR_X),   .ADDR_WIDTH_B(ADDR_X),
        .DATA_DEPTH_A(IMG_W),    .DATA_DEPTH_B(IMG_W),
        .MODE("DP"),
        .REGMODE_A("NOREG"),     .REGMODE_B("NOREG"),
        .WRITEMODE_A("NORMAL"),  .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"),
        .ECC_ENCODE("DISABLE"),  .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"),
        .SSROVERCE("DISABLE"),
        .OREGSET_A("RESET"),     .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"),   .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("NONE"),      .FILL_ALL("NONE")
    ) u_line1 (
        .dia(gray_i), .addra(xa), .cea(1'b1), .clka(clk), .wea(we1), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(8'd0),   .addrb(xa), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(dob1),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(8),        .DATA_WIDTH_B(8),
        .ADDR_WIDTH_A(ADDR_X),   .ADDR_WIDTH_B(ADDR_X),
        .DATA_DEPTH_A(IMG_W),    .DATA_DEPTH_B(IMG_W),
        .MODE("DP"),
        .REGMODE_A("NOREG"),     .REGMODE_B("NOREG"),
        .WRITEMODE_A("NORMAL"),  .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"),
        .ECC_ENCODE("DISABLE"),  .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"),
        .SSROVERCE("DISABLE"),
        .OREGSET_A("RESET"),     .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"),   .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("NONE"),      .FILL_ALL("NONE")
    ) u_line2 (
        .dia(gray_i), .addra(xa), .cea(1'b1), .clka(clk), .wea(we2), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(8'd0),   .addrb(xa), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(dob2),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    // ERAM 读数据比读地址晚 1 拍，因此行选择信号也要相应打一拍再用来选数据
    reg [1:0] S_sel1_d, S_sel2_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_sel1_d <= 2'd0;
            S_sel2_d <= 2'd0;
        end
        else begin
            S_sel1_d <= sel1;
            S_sel2_d <= sel2;
        end
    end

    wire [7:0] S_rd1 = (S_sel1_d == 2'd0) ? dob0 : (S_sel1_d == 2'd1) ? dob1 : dob2;  // y-1 行
    wire [7:0] S_rd2 = (S_sel2_d == 2'd0) ? dob0 : (S_sel2_d == 2'd1) ? dob1 : dob2;  // y-2 行

    // ------------------------------------------------------------------
    // 4) 级 1：把当前像素与坐标/控制信号对齐到"RAM 读数据有效"的那一拍
    // ------------------------------------------------------------------
    reg [7:0]  S_cur_d;
    reg [11:0] S_x1, S_y1;
    reg        S_v1, S_l1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_cur_d <= 8'd0;
            S_x1 <= 12'd0; S_y1 <= 12'd0;
            S_v1 <= 1'b0;  S_l1 <= 1'b0;
        end
        else begin
            S_cur_d <= gray_i;
            S_x1 <= x_now; S_y1 <= y_now;
            S_v1 <= valid_i; S_l1 <= last_i;
        end
    end

    // ------------------------------------------------------------------
    // 5) 级 2：3×3 水平窗口（三路各 3 级移位；只在有效拍推进）
    //       c = 当前行(y)，p = y-1 行，q = y-2 行；下标 0 为最右列(最新)
    // ------------------------------------------------------------------
    reg [7:0] S_c0, S_c1, S_c2;
    reg [7:0] S_p0, S_p1, S_p2;
    reg [7:0] S_q0, S_q1, S_q2;
    reg [11:0] S_x2, S_y2;
    reg        S_v2;

    // 新窗口中心的上下左右：当前行旧 c0、上一行新读数、旧 p1、上上行旧 q0。
    // 在窗口更新同拍锁存阈值，避免用前一窗口亮度判断当前梯度；不增加流水级。
    wire [9:0] S_local_sum = {2'b00, S_c0} + {2'b00, S_rd1} +
                            {2'b00, S_p1} + {2'b00, S_q0};
    wire [7:0] S_local_luma = S_local_sum[9:2];
    wire [11:0] S_scaled_luma = {4'd0,S_local_luma} * TH_SCALE_Q2;
    wire [11:0] S_local_level = S_scaled_luma >> 2;
    wire [11:0] S_threshold_next = (S_local_level < TH_MIN[11:0]) ? TH_MIN[11:0] :
                                  (S_local_level > TH[11:0]) ? TH[11:0] : S_local_level;
    reg [11:0] S_threshold;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_c0<=8'd0; S_c1<=8'd0; S_c2<=8'd0;
            S_p0<=8'd0; S_p1<=8'd0; S_p2<=8'd0;
            S_q0<=8'd0; S_q1<=8'd0; S_q2<=8'd0;
            S_x2<=12'd0; S_y2<=12'd0; S_v2<=1'b0;
            S_threshold <= TH[11:0];
        end
        else if (S_v1) begin
            S_c0 <= S_cur_d; S_c1 <= S_c0; S_c2 <= S_c1;
            S_p0 <= S_rd1;   S_p1 <= S_p0; S_p2 <= S_p1;
            S_q0 <= S_rd2;   S_q1 <= S_q0; S_q2 <= S_q1;
            S_x2 <= S_x1;    S_y2 <= S_y1;
            S_v2 <= S_v1;
            S_threshold <= S_threshold_next;
        end
        else begin
            S_v2 <= 1'b0;
        end
    end

    // ------------------------------------------------------------------
    // 6) 级 3：梯度计算（组合）与输出寄存
    //    窗口中心 = (S_x2-1, S_y2-1)
    // ------------------------------------------------------------------
    wire [9:0] sp = {2'b00, S_c0} + {1'b0, S_p0, 1'b0} + {2'b00, S_q0};  // 右列
    wire [9:0] sn = {2'b00, S_c2} + {1'b0, S_p2, 1'b0} + {2'b00, S_q2};  // 左列
    wire [9:0] tp = {2'b00, S_q0} + {1'b0, S_q1, 1'b0} + {2'b00, S_q2};  // 下行
    wire [9:0] tn = {2'b00, S_c0} + {1'b0, S_c1, 1'b0} + {2'b00, S_c2};  // 上行

    wire [10:0] gx  = (sp >= sn) ? ({1'b0, sp} - {1'b0, sn}) : ({1'b0, sn} - {1'b0, sp});
    wire [10:0] gy  = (tp >= tn) ? ({1'b0, tp} - {1'b0, tn}) : ({1'b0, tn} - {1'b0, tp});
    wire [11:0] mag = {1'b0, gx} + {1'b0, gy};

    // 窗口三行三列都要落在帧内（x-2 / y-2 存在）→ x_now >= 2 且 y_now >= 2
    wire in_area = (S_x2 >= 12'd2) && (S_y2 >= 12'd2);

    // ------------------------------------------------------------------
    // 7) 输出 + 「水平 2 点确认」降噪
    //    只有当前像素与它的左邻（同一行的上一拍）都超过阈值才输出边缘，
    //    用于抑制孤立噪点（与 color_detect_box 的 MIN_RUN 同思路，只多 1 个寄存器，无需额外行缓存）。
    //    行末（S_l2）把左邻标志清零，避免跨行误确认。
    // ------------------------------------------------------------------
    wire [11:0] S_effective_threshold = (ADAPTIVE_TH != 0) ? S_threshold : TH[11:0];
    wire       edge_now = (mag >= S_effective_threshold);
    // Direction is the gradient normal: horizontal, NW/SE, vertical, NE/SW.
    wire [11:0] twice_gx = {gx,1'b0};
    wire [11:0] twice_gy = {gy,1'b0};
    wire diagonal_same_sign = (sp >= sn) == (tn >= tp);
    wire [1:0] normal_direction = twice_gy <= {1'b0,gx} ? 2'd0 :
        (twice_gx <= {1'b0,gy} ? 2'd2 : (diagonal_same_sign ? 2'd1 : 2'd3));
    wire gradient_supported = S_x2 >= 4 && S_y2 >= 4;
    wire weak_gradient = gradient_supported && mag >= (S_effective_threshold >> 1);
    wire strong_gradient = gradient_supported && edge_now;
    reg        S_edge_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            raster_valid_o <= 1'b0; raster_user_o <= 1'b0; raster_last_o <= 1'b0; gradient_o <= 13'd0; gradient_fine_o <= 2'd0; gradient_polarity_o <= 1'b0;
            valid_o     <= 1'b0;
            edge_o      <= 8'd0;
            x_o         <= 12'd0;
            y_o         <= 12'd0;
            S_edge_prev <= 1'b0;
        end
        else begin
            raster_valid_o <= S_v2;
            raster_user_o <= S_v2 && S_x2 == 0 && S_y2 == 0;
            raster_last_o <= S_v2 && S_x2 == IMG_W-1;
            // Coarse gradient keeps the existing port contract; the two low bits
            // are supplied separately for full precision NMS ordering.
            // Both threshold flags above use the full precision magnitude.
            gradient_o <= {strong_gradient,weak_gradient,normal_direction,mag[10:2]};
            gradient_fine_o <= mag[1:0];
            // Negative normal component: Y for vertical normals, otherwise X.
            gradient_polarity_o <= normal_direction==2 ? (tn<tp) : (sp<sn);
            valid_o <= S_v2 && in_area;
            edge_o  <= (OUT_BIN == 1) ? ((edge_now && S_edge_prev) ? 8'hff : 8'h00)
                                      : mag[7:0];
            x_o     <= (S_x2 == 12'd0) ? 12'd0 : (S_x2 - 12'd1);
            y_o     <= (S_y2 == 12'd0) ? 12'd0 : (S_y2 - 12'd1);
            // 左邻标志：只在"窗口中心 >= 1"（S_x2 >= 2）时保留，因此 cx=1 时左邻无效 →
            // 该像素不输出，也就不会把上一行的末尾误当成左邻（无需额外行标志）
            S_edge_prev <= (S_v2 && (S_x2 >= 12'd2)) ? edge_now : 1'b0;
        end
    end

endmodule
