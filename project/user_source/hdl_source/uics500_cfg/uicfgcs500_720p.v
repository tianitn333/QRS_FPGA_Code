`timescale 1ns / 1ns
// SC500CS configuration with bounded recovery. All delays use the 24 MHz input.
// Board L2/PWDNB is connected to the sensor's active-low XSHUTDN.
module uicfgcs500_720p #(
 parameter CLK_DIV=239,POST_STREAM_DELAY=240000,TX_TIMEOUT=480000,
 parameter CLOCK_STABLE_CYCLES=240000,RESET_LOW_CYCLES=48000,
 parameter STARTUP_WAIT_CYCLES=480000,RETRY_WAIT_CYCLES=240000,
 parameter RECOVERY_WAIT_CYCLES=2400000,MAX_RESTARTS=2
)(
 input I_clk,I_rst_n,I_ae_req,input [15:0] I_ae,I_ag,I_dg,
 output O_cam_scl,inout IO_cam_sda,
 output reg O_cfg_done,O_ae_cfg_done,output reg O_ae_done,O_ae_error,
 output reg O_cam_reset_n,
 output reg [23:0] O_diag, // {00, AE_phase, reason[1:0], byte[2:0], register[15:0]}
 output reg [1:0] O_restart_count,
 output [1:0] O_retry_count,output O_retrying
);
 localparam IDLE=0,START=1,WAIT_BUSY=2,WAIT_DONE=3,RETRY_WAIT=4,
            CLOCK_WAIT=5,RESET_LOW=6,STARTUP_WAIT=7,RECOVERY_WAIT=8,FATAL=9;
 reg [7:0] rst_cnt=0;
 reg iic_req,bus_reset_n;wire iic_busy,iic_error;wire [2:0] iic_byte;
 reg [31:0] wr_data;reg [3:0] state;reg [8:0] reg_index;
 reg [31:0] delay_cnt,timeout_count;reg [1:0] retries;
 reg failed,ae_active;reg [15:0] snap_ae,snap_ag,snap_dg;
 (* async_reg="true" *) reg [1:0] sda_sync;
 assign O_retry_count=retries;
 assign O_retrying=(retries!=0) || (!O_cfg_done && O_restart_count!=0);
 wire [31:0] init_data;wire [8:0] init_size;
 wire [15:0] gain_value;
 reg [15:0] dig_reg;reg [23:0] ae_data;
 always @* begin
  case(snap_dg[1:0])
   0:dig_reg=16'h0080;1:dig_reg=16'h0180;2:dig_reg=16'h0380;default:dig_reg=16'h0780;
  endcase
  case(reg_index)
   0:ae_data={16'h3817,8'h20};1:ae_data={16'h3800,8'h00};
   2:ae_data={16'h3e00,4'h0,snap_ae[15:12]};
   3:ae_data={16'h3e01,snap_ae[11:4]};4:ae_data={16'h3e02,snap_ae[3:0],4'h0};
   5:ae_data={16'h3e08,gain_value[15:8]};6:ae_data={16'h3e09,gain_value[7:0]};
   7:ae_data={16'h3e03,8'h0b};8:ae_data={16'h3e06,dig_reg[15:8]};9:ae_data={16'h3e07,dig_reg[7:0]};
   10:ae_data={16'h3800,8'h10};11:ae_data={16'h3800,8'h40};default:ae_data=0;
  endcase
 end

 wire tx_timeout=(state==WAIT_BUSY || state==WAIT_DONE) && timeout_count>=TX_TIMEOUT;
 wire idle_timeout=(state==START) && timeout_count>=TX_TIMEOUT;
 wire nack_done=(state==WAIT_DONE) && !iic_busy && (failed || iic_error);
 always @(posedge I_clk or negedge I_rst_n)
 if(!I_rst_n) begin rst_cnt<=0;sda_sync<=2'b11;end
 else begin
  if(!rst_cnt[7]) rst_cnt<=rst_cnt+1'b1;
  sda_sync<={sda_sync[0],IO_cam_sda};
 end
 always @(posedge I_clk) begin
  if(!rst_cnt[7]) begin
   reg_index<=0;iic_req<=0;wr_data<=0;state<=CLOCK_WAIT;delay_cnt<=0;timeout_count<=0;
   O_cfg_done<=0;O_ae_cfg_done<=0;O_ae_done<=0;O_ae_error<=0;
   retries<=0;failed<=0;ae_active<=0;snap_ae<=1990;snap_ag<=64;snap_dg<=0;bus_reset_n<=0;
   O_cam_reset_n<=1;O_diag<=0;O_restart_count<=0;
  end else begin
   O_ae_done<=0;
   if(state==START || state==WAIT_BUSY || state==WAIT_DONE) timeout_count<=timeout_count+1'b1;
   if((state==WAIT_BUSY || state==WAIT_DONE) && iic_error) begin
    failed<=1;
    // The byte counter is stable throughout ACK; preserve the first failing byte.
    if(!failed) O_diag<={2'b00,O_cfg_done,2'd1,iic_byte,wr_data[15:8],wr_data[23:16]};
   end
   case(state)
    CLOCK_WAIT: begin
     if(delay_cnt>=CLOCK_STABLE_CYCLES-1) begin delay_cnt<=0;O_cam_reset_n<=0;state<=RESET_LOW;end
     else delay_cnt<=delay_cnt+1'b1;
    end
    RESET_LOW: begin
     if(delay_cnt>=RESET_LOW_CYCLES-1) begin delay_cnt<=0;O_cam_reset_n<=1;state<=STARTUP_WAIT;end
     else delay_cnt<=delay_cnt+1'b1;
    end
    STARTUP_WAIT: begin
     if(delay_cnt>=STARTUP_WAIT_CYCLES-1) begin delay_cnt<=0;bus_reset_n<=1;state<=IDLE;end
     else delay_cnt<=delay_cnt+1'b1;
    end
    IDLE: begin
     iic_req<=0;timeout_count<=0;
     if(!O_cfg_done && reg_index==init_size-1 && delay_cnt<POST_STREAM_DELAY) delay_cnt<=delay_cnt+1'b1;
     else if(!O_cfg_done && reg_index==init_size) begin
      O_cfg_done<=1;O_ae_cfg_done<=1;reg_index<=0;
     end else if(!O_cfg_done) state<=START;
     else if(ae_active && reg_index==12) begin
      O_ae_cfg_done<=1;O_ae_done<=1;ae_active<=0;retries<=0;
     end else if(ae_active) state<=START;
     else if(I_ae_req) begin
      snap_ae<=I_ae;snap_ag<=I_ag;snap_dg<=I_dg;
      O_ae_cfg_done<=0;ae_active<=1;reg_index<=0;retries<=0;state<=START;
     end
    end
    START: if(!iic_busy && sda_sync[1]) begin
     wr_data<=O_cfg_done?{ae_data[7:0],ae_data[15:8],ae_data[23:16],8'h6c}:
                               {init_data[7:0],init_data[15:8],init_data[23:16],8'h6c};
     failed<=0;timeout_count<=0;iic_req<=1;state<=WAIT_BUSY;
    end
    WAIT_BUSY: if(iic_busy) begin iic_req<=0;state<=WAIT_DONE;end
    WAIT_DONE: if(!iic_busy && !failed && !iic_error) begin
     reg_index<=reg_index+1'b1;if(!O_cfg_done)retries<=0;state<=IDLE;
    end
    RETRY_WAIT: begin
     if(delay_cnt>=RETRY_WAIT_CYCLES-1) begin delay_cnt<=0;timeout_count<=0;bus_reset_n<=1;state<=START;end
     else delay_cnt<=delay_cnt+1'b1;
    end
    RECOVERY_WAIT: begin
     if(delay_cnt>=RECOVERY_WAIT_CYCLES-1) begin delay_cnt<=0;O_cam_reset_n<=0;state<=RESET_LOW;end
     else delay_cnt<=delay_cnt+1'b1;
    end
    FATAL: begin iic_req<=0;bus_reset_n<=0;end
    default: begin O_ae_error<=1;O_ae_cfg_done<=0;state<=FATAL;end
   endcase
   if(nack_done || tx_timeout || idle_timeout) begin
    iic_req<=0;bus_reset_n<=0;delay_cnt<=0;timeout_count<=0;
    if(tx_timeout) O_diag<={2'b00,O_cfg_done,2'd2,3'd0,wr_data[15:8],wr_data[23:16]};
    if(idle_timeout) O_diag<={2'b00,O_cfg_done,2'd3,3'd0,(O_cfg_done?ae_data[23:8]:init_data[23:8])};
    if(retries<2) begin
     retries<=retries+1'b1;if(O_cfg_done)reg_index<=0;state<=RETRY_WAIT;
    end else if(O_restart_count<MAX_RESTARTS) begin
     O_restart_count<=O_restart_count+1'b1;
     O_cfg_done<=0;O_ae_cfg_done<=0;ae_active<=0;reg_index<=0;retries<=0;
     snap_ae<=1990;snap_ag<=64;snap_dg<=0;failed<=0;state<=RECOVERY_WAIT;
    end else begin O_ae_error<=1;O_ae_cfg_done<=0;ae_active<=0;state<=FATAL;end
   end
  end
 end
 uii2c #(.WMEN_LEN(4),.RMEN_LEN(1),.CLK_DIV(CLK_DIV)) u_i2c(
  .I_clk(I_clk),.I_rstn(rst_cnt[7]&bus_reset_n),.O_iic_scl(O_cam_scl),.IO_iic_sda(IO_cam_sda),
  .I_wr_data(wr_data),.I_wr_cnt(8'd4),.O_rd_data(),.I_rd_cnt(8'd0),.I_iic_mode(1'b0),
  .I_iic_req(iic_req),.O_iic_busy(iic_busy),.O_iic_bus_error(iic_error),.O_iic_byte(iic_byte),.IO_iic_sda_dg());
 uics500reg_720p60 u_init_table(.REG_INDEX(reg_index),.REG_DATA(init_data),.REG_SIZE(init_size));
 SC500GainTbl u_gain_table(.I_clk(I_clk),.I_rstn(rst_cnt[7]),.I(snap_ag[6:0]),.O(gain_value));
endmodule
