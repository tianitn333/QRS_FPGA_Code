`timescale 1ns/1ps
// Monitor one75MHz domain and retain the first fault through stop/disable.
// Observation only: no control, reset, Wishbone or CAN transmission outputs.
module CanFaultSnapshot(
    input wire i_clk,i_rstn,i_arm,
    input wire [2:0] i_stage,
    input wire [15:0] i_context,
    input wire [39:0] i_registers,
    input wire [7:0] i_host,i_status,
    input wire i_done,i_ok,
    input wire [3:0] i_motor_state,
    input wire i_tx_accept,i_tx_done,i_can_ready,i_can_fault,i_protocol_rstn,
    input wire i_transmit,i_receive,
    output wire o_valid,
    output wire [127:0] o_snapshot
);
    reg flag_arm_previous,flag_transmit_previous,flag_protocol_previous;
    reg flag_tx_low,flag_rx_low,flag_reset_seen,flag_fault_locked,flag_valid_o;
    reg [2:0] reg_wait_stage;
    reg [7:0] cnt_accept,cnt_done,cnt_edge;
    reg [127:0] reg_snapshot_o;
    wire flag_new_arm=i_arm && !flag_arm_previous;
    wire flag_first_fault=i_done && !i_ok && !flag_fault_locked;
    wire [7:0] dec_flags={i_can_ready,i_can_fault,i_protocol_rstn,i_transmit,i_receive,flag_tx_low,flag_rx_low,flag_reset_seen};
    wire [127:0] dec_snapshot={i_registers[39:8],i_registers[7:0],i_status,i_context,
        5'd0,reg_wait_stage,i_host,cnt_accept,cnt_done,cnt_edge,dec_flags,
        flag_first_fault?8'h01:(i_motor_state==3?8'h02:8'h00),8'hd1};
    assign o_valid=flag_valid_o;
    assign o_snapshot=reg_snapshot_o;
    always @(posedge i_clk or negedge i_rstn)begin
        if(!i_rstn)begin
            flag_arm_previous<=0;flag_transmit_previous<=1;flag_protocol_previous<=0;
            flag_tx_low<=0;flag_rx_low<=0;flag_reset_seen<=0;flag_fault_locked<=0;flag_valid_o<=0;
            reg_wait_stage<=0;cnt_accept<=0;cnt_done<=0;cnt_edge<=0;reg_snapshot_o<=0;
        end else begin
            flag_arm_previous<=i_arm;flag_transmit_previous<=i_transmit;
            flag_protocol_previous<=i_protocol_rstn;
            if(flag_new_arm)begin
                flag_tx_low<=0;flag_rx_low<=0;flag_reset_seen<=0;flag_fault_locked<=0;flag_valid_o<=0;
                reg_wait_stage<=0;cnt_accept<=0;cnt_done<=0;cnt_edge<=0;
            end else begin
                if(i_stage!=0 && i_stage!=5)reg_wait_stage<=i_stage;
                if(i_arm && i_tx_accept && cnt_accept!=255)cnt_accept<=cnt_accept+1'b1;
                if(i_arm && i_tx_done && cnt_done!=255)cnt_done<=cnt_done+1'b1;
                if(i_arm && i_protocol_rstn && i_transmit!=flag_transmit_previous && cnt_edge!=255)cnt_edge<=cnt_edge+1'b1;
                if(i_arm && i_protocol_rstn && !i_transmit)flag_tx_low<=1;
                if(i_arm && i_protocol_rstn && !i_receive)flag_rx_low<=1;
                if(i_arm && flag_protocol_previous && !i_protocol_rstn)flag_reset_seen<=1;
                if(!flag_fault_locked && (i_arm || flag_first_fault))begin
                    reg_snapshot_o<=dec_snapshot;flag_valid_o<=1;
                    if(flag_first_fault)flag_fault_locked<=1;
                end
            end
        end
    end
endmodule
