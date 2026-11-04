// Independent SD engine and atomic request/response crossing, 75 <-> 50 MHz.
module color_sd_bridge #(
 parameter integer POWER_CYCLES=500000,HOST_TIMEOUT=100000000,
 parameter integer INIT_DIV=123,SPEED_DIV=23,SESSION_TIMEOUT=150000000
)(input wire p_clk,p_rst_n,s_clk,s_rst_n,
 input wire save_req,input wire[239:0]save_data,input wire[31:0]save_revision,
 output wire busy,output reg ack,ok,loaded,boot_done,
 output reg[7:0]boot_error,output reg[239:0]load_data,output reg[31:0]ack_revision,
 output wire sd_clk,sd_mosi,sd_cs_n,input wire sd_miso);
 `include "color_param_codec.vh"
 wire req_ready,req_valid;wire[149:0]request_data;
 wire[239:0]request_params=request_data[149]?color_unpack(request_data[116:0]):240'd0;
 reg sent;wire request_send=save_req&&!sent&&req_ready&&boot_done;
 assign busy=!boot_done||sent||!req_ready;
 ae_mailbox #(.WIDTH(150)) u_request(
   .s_clk(p_clk),.s_rst_n(p_rst_n),.s_send(request_send),.s_data({color_valid(save_data),save_revision,color_pack(save_data)}),.s_ready(req_ready),
   .d_clk(s_clk),.d_rst_n(s_rst_n),.d_valid(req_valid),.d_data(request_data));
 reg pending;wire store_ready;wire event_valid,event_ready;wire[282:0]event_data;
 always @(posedge s_clk or negedge s_rst_n)begin
   if(!s_rst_n)pending<=0;
   else begin if(req_valid)pending<=1;else if(pending&&store_ready)pending<=0;end
 end
 color_sd_store #(.POWER_CYCLES(POWER_CYCLES),.HOST_TIMEOUT(HOST_TIMEOUT),
   .INIT_DIV(INIT_DIV),.SPEED_DIV(SPEED_DIV),.SESSION_TIMEOUT(SESSION_TIMEOUT)) store(
   .clk(s_clk),.rst_n(s_rst_n),.save_valid(pending),.save_ready(store_ready),
   .save_data(request_params),.save_revision(request_data[148:117]),
   .result_valid(event_valid),.result_ready(event_ready),.result_data(event_data),
   .sd_clk(sd_clk),.sd_mosi(sd_mosi),.sd_cs_n(sd_cs_n),.sd_miso(sd_miso));
 wire response_valid;wire[159:0]response_data;
 ae_mailbox #(.WIDTH(160)) u_response(
   .s_clk(s_clk),.s_rst_n(s_rst_n),.s_send(event_valid&&event_ready),.s_data({event_data[282:240],color_pack(event_data[239:0])}),.s_ready(event_ready),
   .d_clk(p_clk),.d_rst_n(p_rst_n),.d_valid(response_valid),.d_data(response_data));
 always @(posedge p_clk or negedge p_rst_n)begin
   if(!p_rst_n)begin sent<=0;ack<=0;ok<=0;loaded<=0;boot_done<=0;boot_error<=0;load_data<=0;ack_revision<=0;end
   else begin
     ack<=0;loaded<=0;
     if(!save_req)sent<=0;else if(request_send)sent<=1;
     if(response_valid)begin
       if(response_data[159])begin
         boot_done<=1;boot_error<=response_data[157:150];
         if(response_data[149])begin loaded<=1;load_data<=color_unpack(response_data[116:0]);end
       end else begin ack<=1;ok<=response_data[158];ack_revision<=response_data[148:117];end
     end
   end
 end
endmodule
