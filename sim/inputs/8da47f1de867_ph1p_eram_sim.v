// ============================================================================
// PH1P_LOGIC_ERAM —— 行为级仿真模型（**仅用于 ModelSim 仿真，不参与综合**）
//
// 为什么需要它：TD 综合时用的是同名 ERAM 硬核原语（见 TD 的 ERAM 库，官方 ISP/AWB
// 的 IP 也是这样例化的），而 ModelSim 没有该原语的仿真模型，因此仿真时用本文件
// 提供等价行为。
//
// 语义（与 `sobel3x3.v` 的用法一致）：
//   · A / B 口各自「同步写 + 同步读」，读数据比读地址晚 1 拍 —— 对应 REGMODE_x = "NOREG"；
//   · 同一次读操作返回的是该地址的**当前存储值**（本模型不做 read-during-write 特别处理，
//     因为 sobel3x3 里写口与读口访问的是不同行缓存，不存在同地址读写）。
//   · ECC 恒无错（未使能）。
//
// 本文件与 RTL 的对应关系由 `tb_sobel3x3` 逐像素比对保证（若语义不一致，该测试台会失配）。
// ============================================================================

module PH1P_LOGIC_ERAM #(
    parameter DATA_WIDTH_A = 8,
    parameter DATA_WIDTH_B = 8,
    parameter ADDR_WIDTH_A = 11,
    parameter ADDR_WIDTH_B = 11,
    parameter DATA_DEPTH_A = 1280,
    parameter DATA_DEPTH_B = 1280,
    parameter MODE = "DP",
    parameter REGMODE_A = "NOREG",
    parameter REGMODE_B = "NOREG",
    parameter WRITEMODE_A = "NORMAL",
    parameter WRITEMODE_B = "NORMAL",
    parameter IMPLEMENT = "20K(FAST)",
    parameter ECC_ENCODE = "DISABLE",
    parameter ECC_DECODE = "DISABLE",
    parameter CLKMODE = "ASYNC",
    parameter SSROVERCE = "DISABLE",
    parameter OREGSET_A = "RESET",
    parameter OREGSET_B = "RESET",
    parameter RESETMODE_A = "ASYNC",
    parameter RESETMODE_B = "ASYNC",
    parameter ASYNC_RESET_RELEASE_A = "ASYNC",
    parameter ASYNC_RESET_RELEASE_B = "ASYNC",
    parameter INIT_FILE = "NONE",
    parameter FILL_ALL = "NONE"
)(
    input  wire [DATA_WIDTH_A-1:0] dia,
    input  wire [DATA_WIDTH_B-1:0] dib,
    input  wire [ADDR_WIDTH_A-1:0] addra,
    input  wire [ADDR_WIDTH_B-1:0] addrb,
    input  wire cea,
    input  wire ceb,
    input  wire ocea,
    input  wire oceb,
    input  wire clka,
    input  wire clkb,
    input  wire wea,
    input  wire web,
    input  wire bea,
    input  wire beb,
    input  wire rsta,
    input  wire rstb,
    output wire [DATA_WIDTH_A-1:0] doa,
    output wire [DATA_WIDTH_B-1:0] dob,
    output wire ecc_sbiterr,
    output wire ecc_dbiterr,
    input  wire ecc_sbiterrinj,
    input  wire ecc_dbiterrinj
);

    reg [DATA_WIDTH_A-1:0] mem [0:DATA_DEPTH_A-1];
    reg [DATA_WIDTH_A-1:0] doa_r;
    reg [DATA_WIDTH_B-1:0] dob_r;

    // A 口：同步写 + 同步读（读延迟 1 拍）
    always @(posedge clka) begin
        if (cea && wea)
            mem[addra] <= dia;
        if (cea)
            doa_r <= mem[addra];
    end

    // B 口：同步写 + 同步读（读延迟 1 拍）
    always @(posedge clkb) begin
        if (ceb && web)
            mem[addrb] <= dib;
        if (ceb)
            dob_r <= mem[addrb];
    end

    assign doa = doa_r;
    assign dob = dob_r;

    assign ecc_sbiterr = 1'b0;
    assign ecc_dbiterr = 1'b0;

endmodule
