`timescale 1ns/1ps
module tb_motion_horizontal_evidence;
 localparam integer BASE_Y=616;
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
 reg[31:0]shared_sequence=0;
 wire[31:0]shared_source=user?shared_sequence+1'b1:shared_sequence;
 always @(posedge clk or negedge rst_n)
 if(!rst_n)shared_sequence<=0;else if(user)shared_sequence<=shared_sequence+1'b1;
 motion_finish_trial #(.EXTERNAL_SOURCE_ID(1),.HORIZONTAL_ENABLE(1)) dut(.clk(clk),.rst_n(rst_n),.valid_i(valid),.user_i(user),.rgb_i(rgb),
  .config_i(config_bus),.hold_ack_i(ack),.hold_o(hold),.status_o(status),.source_i(shared_source));
 reg ddr=0;always #1.5 ddr=~ddr;
 wire store_write,store_busy,store_live,store_valid,store_fault;
 wire[24:0]store_addr;wire[127:0]store_data;
 wire[2:0]store_ev,store_slot,store_live_slot;wire[31:0]store_source,store_live_source;
 wire[6:0]store_pins;reg[1:0]view=0;
 wire[31:0]capture_source=shared_source;
 motion_video_store storage(.camera_clk(clk),.camera_rst_n(rst_n),.ddr_clk(ddr),.ddr_rst_n(rst_n),
 .user_i(user),.valid_i(valid),.rgb_i(rgb),.source_i(capture_source),.race_i(dut.race_serial),.geometry_i(dut.geometry_o),
 .track_i(dut.state_active),.enable_i(1'b1),.decision_i(dut.decision_o),
 .decision_source_i(dut.decision_source_o),.decision_race_i(dut.decision_race_o),
 .decision_mask_i(dut.decision_mask_o),.decision_good_i(dut.decision_good_o),
 .read_busy_i(1'b0),.read_protect_i(7'd0),.user_ready_i(1'b1),.controller_write_i(store_write),.view_lane_i(view),
 .write_busy_o(store_busy),.write_o(store_write),.address_o(store_addr),.data_o(store_data),
 .view_slot_o(store_slot),.view_source_o(store_source),.view_valid_o(store_valid),.evidence_valid_o(store_ev),
 .live_valid_o(store_live),.live_slot_o(store_live_slot),.live_source_o(store_live_source),.pinned_o(store_pins),
 .geometry_o(),.fault_o(store_fault));
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
  #40;rst_n=1;ack=1;
  frame(-1,-1,-1,0);prepare();
  frame(16,-1,-1,0);
  command=command+1'b1;frame(-1,-1,-1,0);frame(-1,-1,-1,0);
  repeat(10000)@(negedge clk);
  check(state==4 && storage.u_slots.tracked==0 || state==4 && (storage.u_slots.tracked & ~storage.u_slots.decided)==0,
        "busy stop releases analysis leases");
  prepare();
  for(n=16;n<=44;n=n+4)frame(n,n,n,0);
  frame(47,47,47,0);repeat(10000)@(negedge clk);
  check(arrived==7 && ranks==6'b010101,"same-frame algorithm tie committed");
  arrival_saved=status[31:0];
  frame(47,47,47,0);frame(47,47,47,0);repeat(10000)@(negedge clk);
  check(store_ev==7 && !store_fault,"three valid evidence references after exact source validation");
  view=0;#2;check(store_source==arrival_saved && store_valid,"lane one evidence uses algorithm source");
  view=1;#2;check(store_source==arrival_saved && store_valid,"lane two evidence uses same source");
  view=2;#2;check(store_source==arrival_saved && store_valid,"lane three evidence uses same source");
  check(store_pins!=0 && (store_pins & (store_pins-1'b1))==0,"triple tie pins exactly one slot");
  if(errors==0)$display("PASS: external common source-ID motion-to-DDR binding, late-ROI busy stop and same-source triple tie, frames=%0d",frame_number);
  else $display("FAIL: motion evidence errors=%0d fault=%b",errors,store_fault);
  $finish;
 end
 initial begin #500000000; $display("FAIL: timeout");$finish;end
endmodule
