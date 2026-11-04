`timescale 1ns/1ps
// Exact motor subgraph extracted from the released full-system source.
// Video/config signals are held inactive; PLL/base reset is supplied at the boundary.
module main_can_harness(input wire clk,rst_n,I_motor_arm,I_motor_reference,I_can_receive,
    output wire O_can_transmit,output wire [3:0] state,error);
    wire S_hdmi_pixel_clk=clk,S_color_p_rst_n=rst_n;
    wire S_motion_mode=0,S_replay_race_key=0,S_motion_edit_allowed=0,S_motion_status_valid=0;
    wire [3:0] S_motion_state=0;
    wire [31:0] S_motion_display_race=0;
    wire [239:0] S_motion_display_status=0;
    wire S_motor_race_go;
    wire [3:0] S_motor_state,S_motor_error;
    wire [39:0] S_can_probe_registers;
    wire [7:0] S_can_probe_host,S_can_probe_status;
    wire [2:0] S_can_probe_stage;
    wire [15:0] S_can_probe_context;
    wire [127:0] S_can_probe_snapshot;
    wire S_can_probe_valid;
    wire S_motor_arm,S_motor_reference;
    reg S_motor_reference_previous;
    (* async_reg="true" *) reg S_can_receive_meta,S_can_receive_level;
    wire S_motor_bus_reset,S_can_ready,S_can_fault;
    wire S_motor_request,S_motor_command_ready,S_motor_command_done,S_motor_command_ok,S_motor_axis;
    wire [3:0] S_motor_command;
    wire signed [15:0] S_motor_target;
    wire [3:0] S_motor_command_error;
    wire [7:0] S_motor_status;
    wire S_motor_position_negative;
    wire [31:0] S_motor_position_magnitude;
    wire S_can_tx_valid,S_can_tx_ready,S_can_tx_done,S_can_rx_valid;
    wire [28:0] S_can_tx_identifier,S_can_rx_identifier;
    wire [3:0] S_can_tx_length,S_can_rx_length;
    wire [63:0] S_can_tx_payload,S_can_rx_payload;
    color_switch_ctrl #(.STABLE_CYCLES(1500000)) u_motor_arm_switch (
      .clk(S_hdmi_pixel_clk),.rst_n(S_color_p_rst_n),.I_switch(I_motor_arm),.O_level(S_motor_arm));
    color_switch_ctrl #(.STABLE_CYCLES(1500000)) u_motor_reference_switch (
      .clk(S_hdmi_pixel_clk),.rst_n(S_color_p_rst_n),.I_switch(I_motor_reference),.O_level(S_motor_reference));
    always @(posedge S_hdmi_pixel_clk or negedge S_color_p_rst_n)
      if(!S_color_p_rst_n)begin S_motor_reference_previous<=0;S_can_receive_meta<=1;S_can_receive_level<=1;end
      else begin S_motor_reference_previous<=S_motor_reference;S_can_receive_meta<=I_can_receive;S_can_receive_level<=S_can_receive_meta;end
    wire S_motor_protocol_rst_n=S_color_p_rst_n && !S_motor_bus_reset;
    RaceMotorControl u_motor_control (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_color_p_rst_n),.i_arm(S_motor_arm),
      .i_reference(S_motor_reference && !S_motor_reference_previous),
      .i_new_race(S_motion_mode && S_replay_race_key && S_motion_edit_allowed),.o_race_go(S_motor_race_go),
      .i_final_valid(S_motion_status_valid && S_motion_state==4),.i_final_race(S_motion_display_race),
      .i_final_ranks(S_motion_display_status[151:146]),.i_final_arrived(S_motion_display_status[154:152]),
      .i_final_fault(S_motion_display_status[158:155]),.i_bus_ready(S_can_ready),.o_bus_reset(S_motor_bus_reset),
      .o_request(S_motor_request),.i_command_ready(S_motor_command_ready),.i_command_done(S_motor_command_done),
      .i_command_ok(S_motor_command_ok),.i_command_error(S_motor_command_error),.i_motor_status(S_motor_status),
      .i_position_negative(S_motor_position_negative),.i_position_magnitude(S_motor_position_magnitude),
      .o_axis(S_motor_axis),.o_command(S_motor_command),.o_target(S_motor_target),.o_state(S_motor_state),.o_error(S_motor_error));
    CanFaultSnapshot u_can_probe (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_color_p_rst_n),.i_arm(S_motor_arm),
      .i_stage(S_can_probe_stage),.i_context(S_can_probe_context),.i_registers(S_can_probe_registers),
      .i_host(S_can_probe_host),.i_status(S_can_probe_status),.i_done(S_motor_command_done),.i_ok(S_motor_command_ok),
      .i_motor_state(S_motor_state),.i_tx_accept(S_can_tx_valid && S_can_tx_ready),.i_tx_done(S_can_tx_done),
      .i_can_ready(S_can_ready),.i_can_fault(S_can_fault),.i_protocol_rstn(S_motor_protocol_rst_n),
      .i_transmit(O_can_transmit),.i_receive(S_can_receive_level),
      .o_valid(S_can_probe_valid),.o_snapshot(S_can_probe_snapshot));
    EmmCommandInterface u_motor_commands (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_motor_protocol_rst_n),.i_request(S_motor_request),.o_ready(S_motor_command_ready),
      .i_axis(S_motor_axis),.i_command(S_motor_command),.i_target(S_motor_target),
      .o_done(S_motor_command_done),.o_ok(S_motor_command_ok),.o_error(S_motor_command_error),
      .o_motor_status(S_motor_status),.o_position_negative(S_motor_position_negative),.o_position_magnitude(S_motor_position_magnitude),
      .o_tx_valid(S_can_tx_valid),.i_tx_ready(S_can_tx_ready),.o_tx_identifier(S_can_tx_identifier),
      .o_tx_length(S_can_tx_length),.o_tx_payload(S_can_tx_payload),.i_tx_done(S_can_tx_done),
      .i_rx_valid(S_can_rx_valid),.i_rx_identifier(S_can_rx_identifier),.i_rx_length(S_can_rx_length),
      .i_rx_payload(S_can_rx_payload),.i_transport_fault(S_can_fault),
      .o_probe_stage(S_can_probe_stage),.o_probe_context(S_can_probe_context));
    CanPacketInterface u_motor_can (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_motor_protocol_rst_n),.i_receive(S_can_receive_level),.o_transmit(O_can_transmit),
      .i_tx_valid(S_can_tx_valid),.o_tx_ready(S_can_tx_ready),.i_tx_identifier(S_can_tx_identifier),
      .i_tx_length(S_can_tx_length),.i_tx_payload(S_can_tx_payload),.o_tx_done(S_can_tx_done),
      .o_rx_valid(S_can_rx_valid),.o_rx_identifier(S_can_rx_identifier),.o_rx_length(S_can_rx_length),
      .o_rx_payload(S_can_rx_payload),.o_ready(S_can_ready),.o_fault(S_can_fault),
      .o_probe_registers(S_can_probe_registers),.o_probe_host(S_can_probe_host),.o_probe_status(S_can_probe_status));


assign state=S_motor_state;assign error=S_motor_error;
endmodule
