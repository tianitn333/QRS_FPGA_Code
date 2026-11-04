// 26-bit run records, packed as three 9x2048 ERAM lanes per address bank.
// Single clock, one-clock synchronous read. No consumed read/write collision.
module edge_fill_ram24 #(parameter integer DEPTH=6144)(
 input wire clk,we_i,input wire [12:0] wr_addr_i,rd_addr_i,
 input wire [25:0] data_i,output wire [25:0] data_o
);
 localparam integer BANKS=(DEPTH+2047)/2048;
 wire [26:0] bank_data[0:BANKS-1];wire [26:0] padded={1'd0,data_i};
 reg [1:0] read_bank;
 always @(posedge clk)read_bank<=rd_addr_i[12:11];
 genvar b,l;
 generate for(b=0;b<BANKS;b=b+1)begin: g_bank
  for(l=0;l<3;l=l+1)begin: g_lane
   PH1P_LOGIC_ERAM #(.DATA_WIDTH_A(9),.DATA_WIDTH_B(9),.ADDR_WIDTH_A(11),.ADDR_WIDTH_B(11),
    .DATA_DEPTH_A(2048),.DATA_DEPTH_B(2048),.MODE("DP"),.REGMODE_A("NOREG"),.REGMODE_B("NOREG"),
    .WRITEMODE_A("NORMAL"),.WRITEMODE_B("NORMAL"),.IMPLEMENT("20K(FAST)"),
    .ECC_ENCODE("DISABLE"),.ECC_DECODE("DISABLE"),.CLKMODE("ASYNC"),.SSROVERCE("DISABLE"),
    .OREGSET_A("RESET"),.OREGSET_B("RESET"),.RESETMODE_A("ASYNC"),.RESETMODE_B("ASYNC"),
    .ASYNC_RESET_RELEASE_A("ASYNC"),.ASYNC_RESET_RELEASE_B("ASYNC"),.INIT_FILE("NONE"),.FILL_ALL("NONE")) ram(
    .dia(padded[l*9+:9]),.addra(wr_addr_i[10:0]),.cea(1'b1),.clka(clk),
    .wea(we_i&&wr_addr_i[12:11]==b),.bea(1'b0),.rsta(1'b0),.ocea(1'b0),.doa(),
    .dib(9'd0),.addrb(rd_addr_i[10:0]),.ceb(1'b1),.clkb(clk),.web(1'b0),.beb(1'b0),
    .rstb(1'b0),.oceb(1'b0),.dob(bank_data[b][l*9+:9]),
    .ecc_sbiterr(),.ecc_dbiterr(),.ecc_sbiterrinj(1'b0),.ecc_dbiterrinj(1'b0));
  end
 end endgenerate
 assign data_o=bank_data[read_bank][25:0];
endmodule
