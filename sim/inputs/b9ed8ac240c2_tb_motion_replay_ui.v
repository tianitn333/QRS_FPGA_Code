`timescale 1ns/1ps
module tb_motion_replay_ui;
 reg clk=0;always #5 clk=~clk;
 reg rst=0,mode=1,short_key=0,long_key=0,prev=0,next=0;
 reg[2:0]state=0,ev=0;wire rep,cmd,missing;wire[1:0]lane;
 integer errors=0;
 motion_replay_ui dut(.clk(clk),.rst_n(rst),.mode_i(mode),.state_i(state),.evidence_i(ev),
 .short_key_i(short_key),.long_key_i(long_key),.previous_i(prev),.next_i(next),
 .replay_o(rep),.lane_o(lane),.race_key_o(cmd),.no_evidence_o(missing));
 task check;input c;input[255:0]msg;begin if(c!==1'b1)begin errors=errors+1;$display("FAIL: %s",msg);end end endtask
 initial begin repeat(3)@(negedge clk);rst=1;
 state=4;repeat(4)@(negedge clk);check(!rep,"results never auto replay");
 long_key=1;@(negedge clk);long_key=0;check(!rep&&missing&&!cmd,"no evidence does not enter");
 ev=6;long_key=1;@(negedge clk);long_key=0;check(rep&&lane==1&&!cmd,"manual entry first valid lane");
 next=1;@(negedge clk);next=0;check(lane==2,"next lane");
 @(negedge clk);next=1;@(negedge clk);next=0;check(lane==0,"cycle through missing lane");
 prev=1;@(negedge clk);prev=0;check(lane==2,"previous wraps");
 short_key=1;@(negedge clk);short_key=0;check(!rep&&!cmd&&ev==6,"exit does not start or clear race");
 @(negedge clk);short_key=1;@(negedge clk);short_key=0;check(cmd,"next short press starts race");
 state=3;long_key=1;@(negedge clk);long_key=0;check(!rep&&!cmd,"active race cannot enter replay");
 state=5;long_key=1;@(negedge clk);long_key=0;check(rep,"invalid result can view existing evidence");
 mode=0;@(negedge clk);check(!rep&&!cmd,"mode exit cancels replay");
 if(errors==0)$display("PASS: manual replay UI, no auto entry, paging, exit preservation and key isolation");
 else $display("FAIL: UI errors=%0d",errors);$finish;end
endmodule
