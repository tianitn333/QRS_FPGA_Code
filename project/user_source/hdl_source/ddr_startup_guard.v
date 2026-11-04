// Keep video DMA reset through training; release separately in each domain.
// The DDR IP reset itself remains driven by the system reset (no ready loop).
module ddr_startup_guard(
 input rst_n,calib_i,ddr_clk,cam_clk,pix_clk,
 output ddr_rst_n,cam_rst_n,pix_rst_n
);
 wire ready_async_n = rst_n && calib_i;
 (* async_reg="true" *) reg [3:0] ddr_release;
 (* async_reg="true" *) reg [1:0] cam_release,pix_release;
 always @(posedge ddr_clk or negedge ready_async_n)
  if(!ready_async_n)ddr_release<=0;else ddr_release<={ddr_release[2:0],1'b1};
 assign ddr_rst_n=ddr_release[3];
 always @(posedge cam_clk or negedge ddr_rst_n)
  if(!ddr_rst_n)cam_release<=0;else cam_release<={cam_release[0],1'b1};
 always @(posedge pix_clk or negedge ddr_rst_n)
  if(!ddr_rst_n)pix_release<=0;else pix_release<={pix_release[0],1'b1};
 assign cam_rst_n=cam_release[1];assign pix_rst_n=pix_release[1];
endmodule
