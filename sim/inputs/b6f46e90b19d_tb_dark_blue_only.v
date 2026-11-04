`timescale 1ns/1ps
`include "color_params.vh"
module tb_dark_blue_only;
reg clk=0,rst_n=0,valid_i=0,user_i=0,last_i=0;
reg [23:0] rgb_i=0;
reg [23:0] pixels[0:921599];
wire [3:0] old_hit,new_hit;
wire old_b,new_b,old_r,new_r,old_g,new_g;
wire [11:0] old_xmax,new_xmax;
wire [31:0] old_ra,new_ra,old_ga,new_ga;
integer x,y,f,dark_hits=0,light_old_hits=0,light_new_hits=0,observations=0;
always #5 clk=~clk;
color_detect_box #(.RUNTIME_PARAM_EN(1),.EXTENDED_BLUE(1),.STAT_DECIM(4),.MIN_RUN(3),.MIN_ROW_CNT(6),.MIN_ROW_CNT_G(4)) old_dut(
 .clk(clk),.rst_n(rst_n),.valid_i(valid_i),.user_i(user_i),.last_i(last_i),.rgb_i(rgb_i),
 .I_param_version(32'd0),.I_param_bus(`COLOR_DEFAULT_BUS),.blue_allow_i(1'b1),
 .o_r_valid(old_r),.o_r_area(old_ra),.o_g_valid(old_g),.o_g_area(old_ga),
 .o_b_valid(old_b),.o_b_xmax(old_xmax),.O_pixel_hit(old_hit));
color_detect_box #(.RUNTIME_PARAM_EN(1),.EXTENDED_BLUE(0),.STAT_DECIM(4),.MIN_RUN(3),.MIN_ROW_CNT(6),.MIN_ROW_CNT_G(4)) new_dut(
 .clk(clk),.rst_n(rst_n),.valid_i(valid_i),.user_i(user_i),.last_i(last_i),.rgb_i(rgb_i),
 .I_param_version(32'd0),.I_param_bus(`COLOR_DEFAULT_BUS),.blue_allow_i(1'b1),
 .o_r_valid(new_r),.o_r_area(new_ra),.o_g_valid(new_g),.o_g_area(new_ga),
 .o_b_valid(new_b),.o_b_xmax(new_xmax),.O_pixel_hit(new_hit));
initial begin
 // Sample raster not bundled: supply sim/inputs/blue_samples/pixels.hex (921600 x 24-bit).
 $readmemh("sim/inputs/blue_samples/pixels.hex",pixels);
 repeat(5)@(negedge clk);rst_n=1;
 for(f=0;f<3;f=f+1)begin
  for(y=0;y<720;y=y+1)for(x=0;x<1281;x=x+1)begin
   @(negedge clk); valid_i=x<1280;user_i=valid_i&&x==0&&y==0;last_i=valid_i&&x==1279;
   rgb_i=valid_i?pixels[y*1280+x]:24'd0;
   #1;
   if(valid_i)begin
    observations=observations+1;
    if(old_hit[2:0]!==new_hit[2:0])$fatal(1,"FAIL: red/green/dark pixel criterion changed");
    if(new_hit[3]!==0)$fatal(1,"FAIL: disabled light-blue branch still active");
    if(x>=335&&x<735&&y>=405&&y<535&&new_hit[2])dark_hits=dark_hits+1;
    if(x>=765&&x<845&&y>=455&&y<545)begin
     if(old_hit[3:2]!=0)light_old_hits=light_old_hits+1;
     if(new_hit[3:2]!=0)light_new_hits=light_new_hits+1;
    end
   end
  end
  if(f>=1)begin
   if(!new_b||!old_b||new_xmax>=745||old_xmax<765)$fatal(1,"FAIL: screenshot blue box did not separate old=%0d new=%0d",old_xmax,new_xmax);
   if({new_r,new_ra,new_g,new_ga}!=={old_r,old_ra,old_g,old_ga})$fatal(1,"FAIL: red/green result changed");
  end
 end
 if(dark_hits<100000||light_old_hits!=21600||light_new_hits!=0||observations!=2764800)$fatal(1,"FAIL: sample coverage");
 $display("PASS: dark-blue screenshot samples preserved, cyan rejected %0d -> %0d; dark hits=%0d; red/green and dark pixel decisions unchanged across %0d pixels; blue xmax old=%0d new=%0d",light_old_hits,light_new_hits,dark_hits,observations,old_xmax,new_xmax);
 $finish;
end
initial begin #40000000;$fatal(1,"FAIL: timeout");end
endmodule
