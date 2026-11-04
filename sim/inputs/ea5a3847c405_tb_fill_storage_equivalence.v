`timescale 1ns/1ps
module tb_fill_storage_equivalence;
localparam W=1280,H=720,HT=1650;
reg clk=0,rst_n=0,valid_i=0,user_i=0,last_i=0,frame_tick_i=0,edge_i=0;
reg [11:0] x_i=0,y_i=0;
reg [11:0] rf=8,cg=0,bt=0,mw=24;
reg [3:0] gc=0;
wire old_available,new_available,old_overflow,new_overflow;
wire [23:0] old_pixel,new_pixel;
wire [31:0] old_frame,new_frame;
wire [20:0] old_cycles,new_cycles;
wire [12:0] old_runs,new_runs;
integer x,y,f,checked=0,filled=0,overflows=0,done_count=0,completed_pixels=0;
always #5 clk=~clk;
reference_fill_buffer #(.IMG_W(W),.IMG_H(H),.MAX_RUNS(6144),.MIN_BG_RUN(8),.ROW_STEP(2)) old_dut(
 .clk(clk),.rst_n(rst_n),.valid_i(valid_i),.user_i(user_i),.last_i(last_i),.frame_tick_i(frame_tick_i),.edge_i(edge_i),.x_i(x_i),.y_i(y_i),
 .available_o(old_available),.pixel_o(old_pixel),.display_frame_o(old_frame),.process_cycles_o(old_cycles),
 .cfg_valid_i(1'b1),.run_filter_threshold_i(rf),.closure_gap_tolerance_i(cg),.gap_count_tolerance_i(gc),.border_contact_tolerance_i(bt),.min_fill_width_i(mw),
 .run_count_o(old_runs),.run_overflow_o(old_overflow));
edge_fill_buffer #(.IMG_W(W),.IMG_H(H),.MAX_RUNS(6144),.MIN_BG_RUN(8),.ROW_STEP(2)) new_dut(
 .clk(clk),.rst_n(rst_n),.valid_i(valid_i),.user_i(user_i),.last_i(last_i),.frame_tick_i(frame_tick_i),.edge_i(edge_i),.x_i(x_i),.y_i(y_i),
 .available_o(new_available),.pixel_o(new_pixel),.display_frame_o(new_frame),.process_cycles_o(new_cycles),
 .cfg_valid_i(1'b1),.run_filter_threshold_i(rf),.closure_gap_tolerance_i(cg),.gap_count_tolerance_i(gc),.border_contact_tolerance_i(bt),.min_fill_width_i(mw),
 .run_count_o(new_runs),.run_overflow_o(new_overflow));
always @(posedge clk)begin
 #1;
 if(rst_n)begin
  checked=checked+1;
  if({new_available,new_frame,new_cycles,new_runs,new_overflow,new_dut.cc_done,new_dut.cc_failed} !==
     {old_available,old_frame,old_cycles,old_runs,old_overflow,old_dut.cc_done,old_dut.cc_failed})
   $fatal(1,"FAIL: cycle-level FILL status mismatch frame=%0d xy=%0d,%0d",f,x_i,y_i);
  if(new_available&&valid_i)begin
   completed_pixels=completed_pixels+1;
   if(new_pixel!==old_pixel)$fatal(1,"FAIL: FILL pixel mismatch frame=%0d xy=%0d,%0d",f,x_i,y_i);
   if(new_pixel==24'hff3030||new_pixel==24'h3080ff||new_pixel==24'h20c080)filled=filled+1;
  end
  if(new_dut.cc_done)done_count=done_count+1;
  if(valid_i&&last_i&&y_i==H-1&&new_overflow)overflows=overflows+1;
 end
end
initial begin
 repeat(5)@(negedge clk);rst_n=1;
 for(f=0;f<9;f=f+1)begin
  rf=f==4?1:8;cg=f==6?3:0;bt=f==6?2:0;gc=f==6?2:0;mw=f==6?0:24;
  for(y=0;y<H+30;y=y+1)for(x=0;x<HT;x=x+1)begin
   @(negedge clk);x_i=x<W?x:W;y_i=y<H?y:H;
   valid_i=x<W&&y<H;user_i=valid_i&&x==0&&y==0;last_i=valid_i&&x==W-1;frame_tick_i=y==H+5&&x==0;
   edge_i=valid_i&&(((x==320||x==960)&&y>=180&&y<=540)||((y==180||y==540)&&x>=320&&x<=960));
   if(f==2&&x==640&&y==540)edge_i=0;
   if(f==4)edge_i=valid_i&&x[0];
   if(f==6&&x==320&&(y==300||y==301))edge_i=0;
  end
 end
 @(negedge clk);valid_i=0;user_i=0;last_i=0;frame_tick_i=0;
 repeat(20)@(negedge clk);
 if(checked<11000000||filled<100000||overflows<1||done_count<6||completed_pixels<3000000)$fatal(1,"FAIL: insufficient coverage clocks=%0d filled=%0d overflow=%0d done=%0d pixels=%0d",checked,filled,overflows,done_count,completed_pixels);
 $display("PASS: ROW_STEP=2 720p storage equivalence: %0d clocks, %0d published pixels, %0d filled pixels, %0d overflows, %0d completed CCL tasks",checked,completed_pixels,filled,overflows,done_count);
 $finish;
end
initial begin #150000000;$fatal(1,"FAIL: timeout");end
endmodule
