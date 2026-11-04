`timescale 1ns/1ns
module tb_edge_fill_stream #(
 parameter W=128,H=64,HT=160,FRAMES=12,CAP=512,
 parameter IN_FILE="sim/inputs/1e1fa89a31b4_input.hex",
 parameter EXP_FILE="sim/inputs/335924f8c104_expected.hex",
 parameter CNT_FILE="sim/inputs/1cb398534b42_counts.hex"
);
 localparam N=W*H;
 reg clk=0,rst_n=0,valid=0,user=0,last=0,tick=0,edge_bit=0;
 reg [11:0] x=0,y=0;wire available;wire [23:0] pixel;wire [31:0] tag;wire [20:0] cycles;
 reg samples[0:FRAMES*N-1];reg [23:0] expected[0:FRAMES*N-1];reg [31:0] run_counts[0:FRAMES-1];
 integer f,ix,iy,index,total_filled=0,checked=0,overflows=0,max_cycles=0,frames_displayed=0;
 integer seen[0:FRAMES-1];reg [31:0] active_tag;
 always #5 clk=~clk;
 edge_fill_buffer #(.IMG_W(W),.IMG_H(H),.MAX_RUNS(CAP)) dut(
  .clk(clk),.rst_n(rst_n),.valid_i(valid),.user_i(user),.last_i(last),.frame_tick_i(tick),
  .edge_i(edge_bit),.x_i(x),.y_i(y),.available_o(available),.pixel_o(pixel),
  .display_frame_o(tag),.process_cycles_o(cycles),.cfg_valid_i(1'b0),
  .run_filter_threshold_i(12'd0),.closure_gap_tolerance_i(12'd0),
  .gap_count_tolerance_i(4'd0),.border_contact_tolerance_i(12'd0),.min_fill_width_i(12'd0),
  .run_count_o(),.run_overflow_o());
 always @(posedge clk)if(rst_n)begin
  if(dut.cc_done&&!dut.cc_failed&&cycles>max_cycles)max_cycles=cycles;
  if(dut.capture_end_frame&&dut.capture_bad)overflows=overflows+1;
  if(valid)begin
   if(user)active_tag=tag;
   if(tag!==active_tag)$fatal(1,"FAIL: display frame switched during active raster");
   if(available)begin
    if(tag==0||tag>FRAMES||run_counts[tag-1]>CAP)$fatal(1,"FAIL: published incomplete frame tag=%0d",tag);
    if(expected[(tag-1)*N+y*W+x]==24'h20c080) begin
     if(pixel!==24'hff3030 && pixel!==24'h3080ff && pixel!==24'h20c080)$fatal(1,"FAIL: tag=%0d input=%0d xy=%0d,%0d got=%h expected fill color q=%0d state=%0d",tag,f,x,y,pixel,dut.q_count,dut.display_state);
    end else if(pixel!==expected[(tag-1)*N+y*W+x])$fatal(1,"FAIL: tag=%0d input=%0d xy=%0d,%0d got=%h expected=%h q=%0d state=%0d",tag,f,x,y,pixel,expected[(tag-1)*N+y*W+x],dut.q_count,dut.display_state);
    checked=checked+1;seen[tag-1]=seen[tag-1]+1;
   if(pixel==24'hff3030 || pixel==24'h3080ff || pixel==24'h20c080)total_filled=total_filled+1;
   end
  end
  if(dut.cc_busy&&dut.cap_active&&dut.proc_bank==dut.cap_bank)$fatal(1,"FAIL: processing/capture collision");
  if(dut.cc_busy&&dut.display_valid&&dut.proc_bank==dut.display_bank)$fatal(1,"FAIL: processing/display collision");
  if(dut.cap_active&&dut.display_valid&&dut.cap_bank==dut.display_bank)$fatal(1,"FAIL: capture/display collision");
 end
 initial begin
  $readmemh(IN_FILE,samples);$readmemh(EXP_FILE,expected);$readmemh(CNT_FILE,run_counts);
  for(f=0;f<FRAMES;f=f+1)seen[f]=0;
  repeat(5)@(negedge clk);rst_n=1;
  for(f=0;f<FRAMES;f=f+1)begin
   for(iy=0;iy<H+30;iy=iy+1)for(ix=0;ix<HT;ix=ix+1)begin
    @(negedge clk);x=ix<W?ix:W;y=iy<H?iy:H;
    valid=ix<W&&iy<H;user=valid&&ix==0&&iy==0;last=valid&&ix==W-1;
    tick=iy==H+5&&ix==0;index=f*N+iy*W+ix;edge_bit=valid?samples[index]:0;
   end
  end
  @(negedge clk);valid=0;user=0;last=0;tick=0;
  repeat(20)@(negedge clk);
  for(f=0;f<FRAMES;f=f+1)begin
   if(seen[f]%N!=0)$fatal(1,"FAIL: partial published raster frame %0d pixels=%0d",f,seen[f]);
   if(seen[f]!=0)frames_displayed=frames_displayed+1;
  end
  if(checked<3*N||total_filled==0||overflows==0)$fatal(1,"FAIL: inadequate coverage checked=%0d filled=%0d overflow=%0d",checked,total_filled,overflows);
  if(max_cycles>=1100000)$fatal(1,"FAIL: processing exceeds production frame budget");
  @(negedge clk);rst_n=0;@(negedge clk);
  if(available||dut.cap_active||dut.cc_busy)$fatal(1,"FAIL: reset state");
  $display("PASS: exact background flood fill, same-frame replay, %0d checked pixels, %0d green pixels, %0d source frames, %0d overflow frames, max %0d processing clocks",checked,total_filled,frames_displayed,overflows,max_cycles);$finish;
 end
 initial begin #300000000;$fatal(1,"FAIL: timeout");end
endmodule
module tb_edge_fill_full720;
 tb_edge_fill_stream #(.W(1280),.H(720),.HT(1650),.FRAMES(8),.CAP(6144),
 .IN_FILE("sim/inputs/77041a8b7eae_input.hex"),
 .EXP_FILE("sim/inputs/2a9c1e01c2ee_expected.hex"),
 .CNT_FILE("sim/inputs/eac17b0046de_counts.hex")) check_full();
endmodule
