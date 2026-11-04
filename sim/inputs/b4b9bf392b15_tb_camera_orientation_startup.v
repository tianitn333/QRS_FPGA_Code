`timescale 1ns/1ps
// Sensor ACK generation observes external bus and reset only.
module recovery_sensor #(parameter MODE=0,READY_NS=4000)(input scl,input reset_n,inout sda,
 output integer starts=0,committed=0,rejected=0,resets=0,output reg stream_on=0);
 reg pull_low=0,active=0,ack_phase=0,selected=0,transaction_ok=0,ack_this=0,ever_high=0;
 integer bit_count=0,byte_index=0;reg [7:0] shift=0,rxbyte=0,data_byte=0;reg [15:0] address=0;
 time released=0,stream_written=0;reg mirror_seen=0;
 wire stuck=(MODE==5 && resets<2 && reset_n);
 assign sda=(pull_low || stuck)?1'b0:1'bz;
 always @(posedge reset_n) begin released=$time;ever_high=1;end
 always @(negedge reset_n) begin
  if(ever_high)resets=resets+1;
  active=0;pull_low=0;stream_on=0;ack_phase=0;mirror_seen=0;stream_written=0;
 end
 always @(negedge sda) if(scl===1'b1 && reset_n) begin
  active=1;bit_count=0;byte_index=0;ack_phase=0;selected=0;transaction_ok=1;starts=starts+1;
 end
 always @(posedge sda) if(scl===1'b1 && active)begin active=0;pull_low=0;end
 always @(posedge scl) if(active && reset_n) begin
  if(bit_count<8)begin
   shift={shift[6:0],sda};bit_count=bit_count+1;
   if(bit_count==8)begin
    rxbyte=shift;
    case(byte_index)0:selected=(rxbyte==8'h6c);1:address[15:8]=rxbyte;2:address[7:0]=rxbyte;3:data_byte=rxbyte;endcase
   end
  end else begin
   if(!ack_this)transaction_ok=0;
   if(byte_index==3)begin
    if(transaction_ok && selected)begin
     committed=committed+1;
     if(address==16'h3221)begin
      if(data_byte!=8'h66 || stream_on)$fatal(1,"FAIL orientation must be applied before stream-on");
      mirror_seen=1;
     end
     if(address==16'h0100)begin
      stream_on=data_byte[0];
      if(data_byte[0])begin
       if(!mirror_seen)$fatal(1,"FAIL stream enabled without mirror and flip");
       stream_written=$time;
      end
     end
     if(address==16'h302d && data_byte==0)begin
      if(!stream_on || $time-stream_written<10080000)$fatal(1,"FAIL post-stream 10ms delay lost after table insertion");
     end
     if(address==16'h0103 && data_byte[0])stream_on=0;
    end else rejected=rejected+1;
   end
   byte_index=byte_index+1;bit_count=0;
  end
 end
 always @(negedge scl) if(active && reset_n)begin
  if(ack_phase)begin pull_low=0;ack_phase=0;end
  else if(bit_count==8)begin
   ack_this=selected && (($time-released)>=READY_NS);
   if(MODE==1 && starts==1 && byte_index==0)ack_this=0;
   if(MODE==2 && resets<2)ack_this=0;
   if(MODE==3)ack_this=0;
   if((MODE==4 || MODE==9) && stream_on && address==16'h3e08 && byte_index>=2 && (MODE==9 || resets<2))ack_this=0;
   if(MODE==8 && address==16'h302d && byte_index==3 && rejected==0)ack_this=0;
   pull_low=ack_this;ack_phase=1;
  end
 end
endmodule
module tb_camera_orientation_startup;
 parameter integer MODE=0;
 localparam CW=(MODE==0)?240000:32,RL=(MODE==0)?48000:16,SW=(MODE==0)?480000:160;
 localparam RW=(MODE==0)?240000:240,HW=(MODE==0)?2400000:480,TO=16000;
 reg clk=0,rst=0;always #21 clk=~clk;
 wire cam_reset_raw,cam_reset;assign cam_reset=rst & cam_reset_raw;
 reg pix=0;always #13 if(cam_reset)pix=~pix;else pix=0;
 tri1 sda;wire scl,init_done,ready,done,fault,retrying;
 wire [23:0]diag;wire[1:0]restarts,retries;wire req;wire[15:0]ae,ag,dg,luma;wire[3:0]aestate;
 wire common_reset=rst & init_done;
 reg [1:0] cfg_release=0,pix_release=0;
 always @(posedge clk or negedge common_reset)if(!common_reset)cfg_release<=0;else cfg_release<={cfg_release[0],1'b1};
 always @(posedge pix or negedge common_reset)if(!common_reset)pix_release<=0;else pix_release<={pix_release[0],1'b1};
 reg valid=0,user=0;integer pcount=0;
 always @(negedge pix or negedge common_reset)begin
  if(!common_reset)begin pcount<=0;valid<=0;user<=0;end
  else begin
   pcount<=(pcount==99)?0:pcount+1;
   valid<=sensor.stream_on && pcount<4;user<=sensor.stream_on && pcount==0;
  end
 end
 auto_exposure #(.IMG_WIDTH(8),.IMG_HEIGHT(2),.STAT_DECIM(1)) ae_control(
 .pix_clk(pix),.pix_rst_n(pix_release[1]),.valid_i(valid),.user_i(user),.rgb_i({4{24'h606060}}),
 .cfg_clk(clk),.cfg_rst_n(cfg_release[1]),.cfg_ready(init_done & ready),.cfg_done_i(done),.cfg_error_i(fault),
 .ae_req_o(req),.ae_o(ae),.ana_o(ag),.dig_o(dg),.luma_o(luma),.state_o(aestate));
 uicfgcs500_720p #(.CLK_DIV(239),.POST_STREAM_DELAY(240000),.TX_TIMEOUT(TO),
 .CLOCK_STABLE_CYCLES(CW),.RESET_LOW_CYCLES(RL),.STARTUP_WAIT_CYCLES(SW),.RETRY_WAIT_CYCLES(RW),.RECOVERY_WAIT_CYCLES(HW)) dut(
 .I_clk(clk),.I_rst_n(rst),.I_ae_req(req),.I_ae(ae),.I_ag(ag),.I_dg(dg),.O_cam_scl(scl),.IO_cam_sda(sda),
 .O_cfg_done(init_done),.O_ae_cfg_done(ready),.O_ae_done(done),.O_ae_error(fault),.O_cam_reset_n(cam_reset_raw),
 .O_diag(diag),.O_restart_count(restarts),.O_retry_count(retries),.O_retrying(retrying));
 wire[31:0] starts,committed,rejected,resets;wire stream_on;
 recovery_sensor #(.MODE(MODE),.READY_NS((MODE==0)?4000000:4000)) sensor(scl,cam_reset,sda,starts,committed,rejected,resets,stream_on);
 integer ae_done_count=0,init_count=0,request_count=0;reg old_req=0;
 time low_start=0,last_release=0,last_bus_reset=0;integer seen_release=0;
 always @(posedge init_done)init_count=init_count+1;
 always @(posedge done)ae_done_count=ae_done_count+1;
 always @(negedge cam_reset)if(rst)low_start=$time;
 always @(posedge cam_reset)begin
  if(low_start!=0 && ($time-low_start)<RL*42)$fatal(1,"FAIL reset low pulse too short");
  last_release=$time;seen_release=seen_release+1;
 end
 always @(negedge dut.bus_reset_n)last_bus_reset=$time;
 always @(negedge clk)begin
  if(MODE==6 && resets<2 && (dut.state==2 || dut.state==3))force dut.iic_busy=1;else release dut.iic_busy;
  if(dut.iic_req && !old_req)begin
   request_count=request_count+1;
   if(!cam_reset || ($time-last_release)<SW*42)$fatal(1,"FAIL write during reset/startup wait");
   if(dut.retries!=0 && ($time-last_bus_reset)<RW*42)$fatal(1,"FAIL retry lacks backoff");
  end
  old_req=dut.iic_req;
  if(!common_reset && (cfg_release!=0 || pix_release!=0))$fatal(1,"FAIL AE domain reset not asserted");
 end
 initial begin
  $timeformat(-9,0," ns",0);
  repeat(8)@(negedge clk);rst=1;
  if(MODE==7)begin
   wait(request_count>=30);repeat(40)@(negedge clk);rst=0;
   repeat(8)@(negedge clk);low_start=0;rst=1;
  end
  if(MODE==3 || MODE==9)begin
   wait(fault);repeat(1000)@(negedge clk);
   if(restarts!=2 || retries!=2 || ready || dut.iic_req)$fatal(1,"FAIL fatal recovery budget/status");
   if(MODE==3 && (init_done || stream_on || diag[23:16]!=8'h09 || diag[15:0]!=16'h0103))$fatal(1,"FAIL init diagnosis %h",diag);
   if(MODE==9 && (diag[21]!=1 || diag[15:0]!=16'h3e08 || init_count!=3))$fatal(1,"FAIL repeated AE outage diagnosis %h init=%d",diag,init_count);
  end else begin
   wait(ae_done_count>=1);repeat(1000)@(negedge clk);
   if(fault || !init_done || !stream_on || !ready)$fatal(1,"FAIL did not recover fully");
   if(MODE==0 && (restarts!=0 || rejected!=0 || resets!=1))$fatal(1,"FAIL nominal boot");
   if(MODE==1 && (diag!=24'h090103 || rejected!=1 || restarts!=0))$fatal(1,"FAIL first address NACK %h",diag);
   if((MODE==2 || MODE==4 || MODE==5 || MODE==6) && restarts!=1)$fatal(1,"FAIL expected one hardware recovery");
   if(MODE==4 && (diag[21]!=1 || diag[15:0]!=16'h3e08 || init_count!=2 || aestate==5))$fatal(1,"FAIL AE stale ERROR/statistics %h",diag);
   if(MODE==5 && diag[20:19]!=3)$fatal(1,"FAIL stuck SDA diagnosis %h",diag);
   if(MODE==6 && diag[20:19]!=2)$fatal(1,"FAIL transaction timeout diagnosis %h",diag);
   if(MODE==7 && (resets<3 || restarts!=0))$fatal(1,"FAIL hot reprogram reset");
   if(MODE==8 && (diag!=24'h0c302d || rejected!=1 || restarts!=0))$fatal(1,"FAIL last data NACK %h",diag);
  end
  $display("PASS: orientation startup and recovery mode=%0d requests=%0d accepted=%0d rejected=%0d hardware_pulses=%0d restarts=%0d init_completions=%0d AE_done=%0d diag=%h at=%t",MODE,request_count,committed,rejected,resets,restarts,init_count,ae_done_count,diag,$time);
  $finish;
 end
 initial begin #300000000;$fatal(1,"FAIL recovery test timeout mode=%0d state=%0d diag=%h",MODE,dut.state,diag);end
endmodule
