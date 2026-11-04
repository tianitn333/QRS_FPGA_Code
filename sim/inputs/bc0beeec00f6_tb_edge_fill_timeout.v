`timescale 1ns/1ns
module tb_edge_fill_timeout;
reg clk=0,rst=0,de=0,user=0,last=0,tick=0,edge_bit=0;reg[11:0]x=0,y=0;
wire available;wire[23:0]pixel;wire[31:0]tag;wire[20:0]cycles;
integer xx,yy,failures=0,successes=0;
always #5 clk=~clk;
edge_fill_buffer #(.IMG_W(32),.IMG_H(12),.MAX_RUNS(128),.CYCLE_BUDGET(80)) dut(
.clk(clk),.rst_n(rst),.valid_i(de),.user_i(user),.last_i(last),.frame_tick_i(tick),.edge_i(edge_bit),.x_i(x),.y_i(y),
.available_o(available),.pixel_o(pixel),.display_frame_o(tag),.process_cycles_o(cycles));
always @(posedge clk)if(rst&&dut.cc_done)begin
 if(dut.cc_failed)begin failures=failures+1;if(cycles>81)$fatal(1,"FAIL timeout exceeded bound");end
 else successes=successes+1;
end
task send;input white;begin
 for(yy=0;yy<12;yy=yy+1)for(xx=0;xx<48;xx=xx+1)begin
 @(negedge clk);de=xx<32;user=de&&xx==0&&yy==0;last=de&&xx==31;x=xx;y=yy;edge_bit=white;
 end
 @(negedge clk);de=0;user=0;last=0;repeat(200)@(negedge clk);
 tick=1;@(negedge clk);tick=0;y=0;x=0;repeat(20)@(negedge clk);
end endtask
initial begin
 repeat(5)@(negedge clk);rst=1;
 send(0);if(available||failures!=1)$fatal(1,"FAIL timeout result was displayed");
 send(1);if(!available||pixel!==24'hffffff||tag!=2||successes!=1)$fatal(1,"FAIL recovery after timeout");
 send(0);if(available||failures!=2)$fatal(1,"FAIL stale display survives failed newer frame");
 // Interrupt capture with reset, then prove no partial or old frame leaks.
 @(negedge clk);de=1;user=1;x=0;y=0;edge_bit=0;@(negedge clk);user=0;x=1;
 @(negedge clk);rst=0;de=0;repeat(4)@(negedge clk);rst=1;
 if(available||dut.cap_active||dut.cc_busy)$fatal(1,"FAIL reset did not invalidate banks");
 send(1);if(!available||tag!=1||pixel!==24'hffffff)$fatal(1,"FAIL reset recovery");
 $display("PASS: bounded processing timeout, silent invalidation, recovery, partial capture reset and no stale publication");$finish;
end
initial begin #100000;$fatal(1,"FAIL watchdog");end
endmodule
