// Three-stage 3x3 Gaussian stream. Entire input raster is forwarded, including
// zero-valued unsupported top/left positions. This keeps downstream row counts.
module gray_gaussian3x3 #(
    parameter integer IMG_W=1280, IMG_H=720
)(
    input wire clk,rst_n,valid_i,user_i,last_i,
    input wire [7:0] gray_i,
    output reg valid_o,user_o,last_o,
    output reg [7:0] gray_o
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
        else if (valid_i && user_i)
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

    wire we0 = valid_i && (user_i || (S_wr_sel == 2'd0));
    wire we1 = valid_i && !user_i && (S_wr_sel == 2'd1);
    wire we2 = valid_i && !user_i && (S_wr_sel == 2'd2);

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
    reg        S_v1, S_l1, S_u1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_cur_d <= 8'd0;
            S_x1 <= 12'd0; S_y1 <= 12'd0;
            S_v1 <= 1'b0;  S_l1 <= 1'b0; S_u1 <= 1'b0;
        end
        else begin
            S_cur_d <= gray_i;
            S_x1 <= x_now; S_y1 <= y_now;
            S_v1 <= valid_i; S_l1 <= last_i; S_u1 <= user_i;
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

    reg S_l2,S_u2;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            S_c0<=0;S_c1<=0;S_c2<=0;S_p0<=0;S_p1<=0;S_p2<=0;S_q0<=0;S_q1<=0;S_q2<=0;
            S_x2<=0;S_y2<=0;S_v2<=0;S_l2<=0;S_u2<=0;
        end else begin
            S_v2<=S_v1;S_l2<=S_l1;S_u2<=S_u1;
            if(S_v1) begin
                S_c0<=S_cur_d;S_c1<=S_c0;S_c2<=S_c1;
                S_p0<=S_rd1;S_p1<=S_p0;S_p2<=S_p1;
                S_q0<=S_rd2;S_q1<=S_q0;S_q2<=S_q1;
                S_x2<=S_x1;S_y2<=S_y1;
            end
        end
    end
    wire [9:0] top_sum={2'd0,S_q0}+{1'd0,S_q1,1'd0}+{2'd0,S_q2};
    wire [9:0] middle_sum={2'd0,S_p0}+{1'd0,S_p1,1'd0}+{2'd0,S_p2};
    wire [9:0] bottom_sum={2'd0,S_c0}+{1'd0,S_c1,1'd0}+{2'd0,S_c2};
    wire [11:0] weighted_sum={2'd0,top_sum}+{1'd0,middle_sum,1'd0}+{2'd0,bottom_sum};
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin valid_o<=0;user_o<=0;last_o<=0;gray_o<=0;end
        else begin
            valid_o<=S_v2;user_o<=S_u2;last_o<=S_l2;
            gray_o<=(S_v2 && S_x2>=2 && S_y2>=2) ? weighted_sum[11:4] : 8'd0;
        end
    end
endmodule
