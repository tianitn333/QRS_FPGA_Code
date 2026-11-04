// 4096-address grayscale store: two 9x2048 ERAMs, eight payload bits per word.
// Both ports share clk. Read address to data is one clock; collisions are forbidden.
module motion_gray_ram (
 input wire clk, input wire we_i,
 input wire [11:0] wr_addr_i,rd_addr_i,
 input wire [7:0] data_i, output wire [7:0] data_o
);
 wire [8:0] bank_data [0:1];
 reg read_bank;
 always @(posedge clk) read_bank <= rd_addr_i[11];
 genvar bank;
 generate for(bank=0;bank<2;bank=bank+1) begin: g_bank
  PH1P_LOGIC_ERAM #(.DATA_WIDTH_A(9),.DATA_WIDTH_B(9),.ADDR_WIDTH_A(11),.ADDR_WIDTH_B(11),
   .DATA_DEPTH_A(2048),.DATA_DEPTH_B(2048),.MODE("DP"),.REGMODE_A("NOREG"),.REGMODE_B("NOREG"),
   .WRITEMODE_A("NORMAL"),.WRITEMODE_B("NORMAL"),.IMPLEMENT("20K(FAST)"),
   .ECC_ENCODE("DISABLE"),.ECC_DECODE("DISABLE"),.CLKMODE("ASYNC"),.SSROVERCE("DISABLE"),
   .OREGSET_A("RESET"),.OREGSET_B("RESET"),.RESETMODE_A("ASYNC"),.RESETMODE_B("ASYNC"),
   .ASYNC_RESET_RELEASE_A("ASYNC"),.ASYNC_RESET_RELEASE_B("ASYNC"),.INIT_FILE("NONE"),.FILL_ALL("NONE")) ram (
   .dia({1'b0,data_i}),.addra(wr_addr_i[10:0]),.cea(1'b1),.clka(clk),
   .wea(we_i && wr_addr_i[11]==bank),.bea(1'b0),.rsta(1'b0),.ocea(1'b0),.doa(),
   .dib(9'd0),.addrb(rd_addr_i[10:0]),.ceb(1'b1),.clkb(clk),.web(1'b0),.beb(1'b0),
   .rstb(1'b0),.oceb(1'b0),.dob(bank_data[bank]),
   .ecc_sbiterr(),.ecc_dbiterr(),.ecc_sbiterrinj(1'b0),.ecc_dbiterrinj(1'b0));
 end endgenerate
 assign data_o = bank_data[read_bank][7:0];
endmodule
