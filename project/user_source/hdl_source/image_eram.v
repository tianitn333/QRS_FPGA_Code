// Synchronous one-clock read, single-clock dual-port storage in PH1P ERAM.
// Unwritten contents are intentionally unspecified; consumers carry validity.
module image_eram #(
    parameter integer WIDTH = 24,
    parameter integer DEPTH = 14400,
    parameter integer ADDR_WIDTH = 14
)(
    input wire clk,
    input wire we_i,
    input wire [ADDR_WIDTH-1:0] wr_addr_i,
    input wire [WIDTH-1:0] data_i,
    input wire [ADDR_WIDTH-1:0] rd_addr_i,
    output wire [WIDTH-1:0] data_o
);
    localparam integer WORD_BANKS = (DEPTH+1023)/1024;
    localparam integer DATA_BANKS = (WIDTH+17)/18;
    localparam integer PAD_WIDTH = DATA_BANKS*18;
    wire [PAD_WIDTH-1:0] padded = {{(PAD_WIDTH-WIDTH){1'b0}},data_i};
    wire [13:0] wr_addr = {{(14-ADDR_WIDTH){1'b0}},wr_addr_i};
    wire [13:0] rd_addr = {{(14-ADDR_WIDTH){1'b0}},rd_addr_i};
    wire [PAD_WIDTH-1:0] bank_data [0:WORD_BANKS-1];
    reg [3:0] read_bank;
    always @(posedge clk) read_bank <= rd_addr[13:10];
    genvar bank, lane;
    generate for (bank=0; bank<WORD_BANKS; bank=bank+1) begin: g_word
        for (lane=0; lane<DATA_BANKS; lane=lane+1) begin: g_data
            PH1P_LOGIC_ERAM #(
                .DATA_WIDTH_A(18), .DATA_WIDTH_B(18),
                .ADDR_WIDTH_A(10), .ADDR_WIDTH_B(10),
                .DATA_DEPTH_A(1024), .DATA_DEPTH_B(1024),
                .MODE("DP"), .REGMODE_A("NOREG"), .REGMODE_B("NOREG"),
                .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
                .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
                .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"), .OREGSET_A("RESET"),
                .OREGSET_B("RESET"), .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
                .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
                .INIT_FILE("NONE"), .FILL_ALL("NONE")
            ) memory (
                .dia(padded[lane*18 +: 18]), .addra(wr_addr[9:0]), .cea(1'b1),
                .clka(clk), .wea(we_i && wr_addr[13:10]==bank), .bea(1'b0),
                .rsta(1'b0), .ocea(1'b0), .dib(18'd0), .addrb(rd_addr[9:0]),
                .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
                .doa(), .dob(bank_data[bank][lane*18 +: 18]),
                .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
            );
        end
    end endgenerate
    assign data_o = bank_data[read_bank][WIDTH-1:0];
endmodule
