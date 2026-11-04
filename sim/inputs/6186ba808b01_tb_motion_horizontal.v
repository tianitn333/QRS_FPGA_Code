`timescale 1ns/1ps
module tb_motion_horizontal;
 localparam integer BASE_Y=512;
 reg clk=0,rst_n=0,valid=0,user=0,ack=0;
 reg [95:0] rgb=0;
 reg [7:0] command=0;
 wire [63:0] config_bus={1'b1,command,11'd160,BASE_Y[9:0],6'd40,8'd20,8'd24,12'd0};
 wire hold;wire [191:0] status;
 wire [2:0] state=status[161:159],arrived=status[154:152];
 wire [5:0] ranks=status[151:146];
 integer frame_number=0,errors=0;
 reg [31:0] arrival_saved;
 always #5 clk=~clk;
 motion_finish_trial #(.HORIZONTAL_ENABLE(1)) dut(.clk(clk),.rst_n(rst_n),.valid_i(valid),.user_i(user),.rgb_i(rgb),
  .config_i(config_bus),.hold_ack_i(ack),.hold_o(hold),.status_o(status),.source_i(32'd0),.race_o(),.active_o(),.geometry_o(),.decision_o(),.decision_source_o(),.decision_race_o(),.decision_mask_o(),.decision_good_o());
 task check;
  input condition;input [255:0] message;
  begin if(condition!==1'b1)begin $display("FAIL: %0s state=%0d arrived=%b fault=%0d",message,state,arrived,status[158:155]);errors=errors+1;end end
 endtask
 task frame;
  input integer front0,front1,front2,truncate;
  integer row,word_number,x,lane,front,value;
  begin
   @(negedge clk);user=1;valid=0;
   @(negedge clk);user=0;
   for(row=0;row<720;row=row+1)begin
    for(word_number=0;word_number<320;word_number=word_number+1)begin
     if(row*320+word_number<230400-truncate)begin
      x=word_number*4;value=100;
      if(x==328 && row>=BASE_Y-416 && row<BASE_Y+96)value=65;
      for(lane=0;lane<3;lane=lane+1)begin
       case(lane)0:front=front0;1:front=front1;default:front=front2;endcase
       if(front>=0 && x>=160+(68-front)*8 && x<=160+(81-front)*8 && row>=BASE_Y-lane*208+16 && row<BASE_Y-lane*208+80)value=35;
      end
      valid=1;rgb={12{value[7:0]}};
      @(negedge clk);
     end
    end
   end
   valid=0;rgb=0;
   repeat(0)@(negedge clk);
   frame_number=frame_number+1;
  end
 endtask
 task prepare;
  integer n;
  begin
   command=command+1'b1;
   frame(-1,-1,-1,0);
   for(n=0;n<23;n=n+1)frame(-1,-1,-1,0);
   repeat(10000)@(negedge clk);check(state==2,"READY after empty learning");
  end
 endtask
 always @(posedge clk) if(rst_n && dut.worker==5 && !dut.complete_frame)
  $fatal(1,"FAIL result before full source frame validation");
 integer n;
 initial begin
  #40;rst_n=1;
  frame(-1,-1,-1,0);
  command=1;frame(-1,-1,-1,0);frame(-1,-1,-1,0);
  repeat(10000)@(negedge clk);check(state==1 && hold,"hold requested before READY");
  ack=1;
  for(n=0;n<23;n=n+1)frame(-1,-1,-1,0);
  repeat(10000)@(negedge clk);check(state==2 && arrived==0,"first READY");
  for(n=16;n<=40;n=n+4)frame(n,-1,-1,0);
  frame(43,-1,-1,0);frame(43,-1,-1,0);
  repeat(10000)@(negedge clk);check(arrived==0,"stop before line");
  frame(47,-1,-1,0);
  repeat(10000)@(negedge clk);check(arrived==1 && ranks[1:0]==1,"first touch counted");
  arrival_saved=status[31:0];
  frame(47,-1,-1,0);frame(43,-1,-1,0);frame(47,-1,-1,0);
  repeat(10000)@(negedge clk);check(arrived==1 && status[31:0]==arrival_saved,"stop retreat and return no recount");
  command=command+1'b1;frame(-1,-1,-1,0);repeat(10000)@(negedge clk);check(state==4,"manual stop");
  prepare();
  for(n=16;n<=44;n=n+4)frame(n,n,n,0);
  frame(47,47,47,0);
  repeat(10000)@(negedge clk);check(arrived==7 && ranks==6'b010101 && state==4,"same source frame triple tie");
  prepare();
  frame(-1,-1,-1,10);
  frame(-1,-1,-1,0);
  repeat(10000)@(negedge clk);check(state==5 && status[158:155]==1,"incomplete camera frame invalidates race");
  prepare();
  repeat(10000)@(negedge clk);check(state==2 && status[158:155]==0,"K2 restarts from INVALID without stale error");
  if(errors==0)$display("PASS: motion trial full1280x720 frame transactions=%0d",frame_number);
  else $display("FAIL: errors=%0d",errors);
  $finish;
 end
 initial begin #500000000; $display("FAIL: timeout");$finish;end
endmodule
