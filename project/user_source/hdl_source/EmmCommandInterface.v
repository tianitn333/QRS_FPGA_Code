`timescale 1ns / 1ps
// Company: QRS / Engineer: project contributors
// Create Date: 2026-11-03 / Design: Emm classical CAN transactions
// Module: EmmCommandInterface / Description: two addressed motor transactions
// Simulation: tb_emm_command / References: X42S manual 1.0.5
// Dependencies: packet ready-valid interface / Version: 1.0
// Revision Date: 2026-11-03 / Revision History: isolated implementation
// 公司：QRS / 工程师：工程维护者
// 创建日期：2026-11-03 / 设计：Emm经典CAN事务
// 模块名称：EmmCommandInterface / 描述：两个地址的有界命令及应答
// 仿真工程：tb_emm_command / 参考：X42S用户手册1.0.5
// 依赖：报文握手接口 / 版本：1.0
// 修订日期：2026-11-03 / 修订记录：独立事务层实现
module EmmCommandInterface #(
    parameter C_COMMAND_GAP_CLOCKS = 1500000, // 75MHz下普通事务完成后至少20ms；停止/失能绕过。
    parameter C_RESPONSE_CLOCKS = 37500000, // 75MHz下500ms应用应答时限。
    parameter C_FRAGMENT_CLOCKS = 375000 // 两个位置分片间隔5ms，不循环发送。
) (
    input wire i_clk, // 与报文层同域75MHz。
    input wire i_rstn, // 低有效复位，本域同步释放。
    input wire i_request, // ready时脉冲，整个命令只执行一次。
    output wire o_ready, // 可接收下一独立事务。
    input wire i_axis, // 0为地址1，1为地址2。
    input wire [3:0] i_command, // 0闭环/1清零/2使能/3绝对位置/4状态/5角度/6停止/7失能。
    input wire signed [15:0] i_target, // 已确认零点的绝对脉冲，负数CCW。
    output wire o_done, // 成功或失败均给一拍结束，须同时读取ok。
    output wire o_ok, // 本事务收到匹配成功响应；不是所有命令都表示到位。
    output wire [3:0] o_error, // 1超时/2格式或条件/3报文层故障。
    output wire [7:0] o_motor_status, // 3A返回状态原样保持。
    output wire o_position_negative, // 36返回有符号累计位置方向。
    output wire [31:0] o_position_magnitude, // 36返回原始编码器幅值，不是命令脉冲。
    output wire o_tx_valid, // 保持报文直到报文层ready。
    input wire i_tx_ready, // 报文层握手。
    output wire [28:0] o_tx_identifier, // 地址左移8位加分片号。
    output wire [3:0] o_tx_length, // 不对不足8字节命令补长DLC。
    output wire [63:0] o_tx_payload, // 第一个字节在63:56。
    input wire i_tx_done, // 实际CAN发送完成，不代表驱动命令成功。
    input wire i_rx_valid, // 完整接收帧脉冲，无反压。
    input wire [28:0] i_rx_identifier, // 必须匹配本次单电机、分片0。
    input wire [3:0] i_rx_length, // 预期3字节ACK或7字节位置。
    input wire [63:0] i_rx_payload, // 左对齐字节串。
    output wire [2:0] o_probe_stage,
    output wire [15:0] o_probe_context,
    input wire i_transport_fault // 报文层锁存故障，不再给出成功。
);
    localparam ST_IDLE = 3'd0, ST_OFFER = 3'd1, ST_SENT = 3'd2;
    localparam ST_FRAGMENT = 3'd3, ST_ACK = 3'd4, ST_FINISH = 3'd5;
    reg [2:0] state_current, state_next;
    reg [3:0] reg_command; // 当前命令保持到事务结束。
    reg flag_axis, flag_fragment, flag_negative; // 地址、位置分片及方向。
    reg [15:0] reg_magnitude; // 目标脉冲的无符号幅值。
    reg [7:0] reg_function; // 用于应答匹配，拒绝其他命令的包。
    reg [25:0] cnt_response; // 完整请求送出后的有界等待。
    reg [18:0] cnt_fragment; // 分片间隔定时。
    reg flag_response; // 可比tx_done先来的应用应答也会锁存。
    reg flag_response_ok; // 匹配应答的成功标记。
    reg [3:0] reg_error_o; // 当前事务错误码。
    reg flag_done_o, flag_ok_o;
    reg [7:0] reg_motor_status_o;
    reg flag_position_negative_o;
    reg [31:0] reg_position_magnitude_o;
    reg [63:0] reg_tx_payload_o; // 组合选择短命令，握手前保持稳定。
    reg [3:0] reg_tx_length_o;
    reg [20:0] cnt_command_gap;
    wire flag_urgent_command = i_command == 6 || i_command == 7;
    wire flag_gap_ready = cnt_command_gap == 0 || flag_urgent_command;
    wire [28:0] dec_identifier = flag_axis ? 29'h200 : 29'h100;
    wire flag_last_fragment = reg_command != 3 || flag_fragment;
    wire flag_match_id = i_rx_identifier == dec_identifier;
    wire flag_match_function = i_rx_payload[63:56] == reg_function;
    wire flag_receive_window = state_current == ST_ACK || state_current == ST_SENT;
    wire flag_response_expired = cnt_response >= C_RESPONSE_CLOCKS-1;
    assign o_ready = state_current == ST_IDLE && flag_gap_ready;
    assign o_probe_stage = state_current;
    assign o_probe_context = {flag_axis ? 8'd2 : 8'd1,reg_function};
    assign o_done = flag_done_o;
    assign o_ok = flag_ok_o;
    assign o_error = reg_error_o;
    assign o_motor_status = reg_motor_status_o;
    assign o_position_negative = flag_position_negative_o;
    assign o_position_magnitude = reg_position_magnitude_o;
    assign o_tx_valid = state_current == ST_OFFER && !i_transport_fault && !flag_response_expired;
    assign o_tx_identifier = {dec_identifier[28:1],flag_fragment};
    assign o_tx_payload = reg_tx_payload_o;
    assign o_tx_length = reg_tx_length_o;

    // 固定协议字节，不发送广播动作，不省略第二分片功能字。
    always @(*) begin
        reg_tx_length_o = 3;
        reg_tx_payload_o = 64'h0a6d6b0000000000;
        case (reg_command)
            0: begin reg_tx_length_o=5; reg_tx_payload_o=64'h466900016b000000; end
            1: begin reg_tx_length_o=3; reg_tx_payload_o=64'h0a6d6b0000000000; end
            2: begin reg_tx_length_o=5; reg_tx_payload_o=64'hf3ab01006b000000; end
            3: begin
                if (flag_fragment) begin
                    reg_tx_length_o=5;
                    reg_tx_payload_o={8'hfd,reg_magnitude[7:0],8'h01,8'h00,8'h6b,24'd0};
                end else begin
                    reg_tx_length_o=8;
                    reg_tx_payload_o={8'hfd,7'd0,flag_negative,16'd50,8'd100,16'd0,reg_magnitude[15:8]};
                end
            end
            4: begin reg_tx_length_o=2; reg_tx_payload_o=64'h3a6b000000000000; end
            5: begin reg_tx_length_o=2; reg_tx_payload_o=64'h366b000000000000; end
            6: begin reg_tx_length_o=4; reg_tx_payload_o=64'hfe98006b00000000; end
            7: begin reg_tx_length_o=5; reg_tx_payload_o=64'hf3ab00006b000000; end
            8: begin reg_tx_length_o=3; reg_tx_payload_o=64'h50016b0000000000; end
            default: begin reg_tx_length_o=2; reg_tx_payload_o=64'h3a6b000000000000; end
        endcase
    end
    always @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) state_current <= ST_IDLE;
        else state_current <= state_next;
    end
    // 单事务不作应用层自动重发，避免超时后重复移动。
    always @(*) begin
        state_next = state_current;
        case (state_current)
            ST_IDLE: if (i_request && o_ready) state_next = ST_OFFER;
            ST_OFFER: begin
                if (i_transport_fault || flag_response_expired) state_next = ST_FINISH;
                else if (i_tx_ready) state_next = ST_SENT;
            end
            ST_SENT: begin
                if (i_transport_fault || flag_response_expired) state_next = ST_FINISH;
                else if (i_tx_done) begin
                    if (flag_last_fragment) state_next = ST_ACK;
                    else state_next = ST_FRAGMENT;
                end
            end
            ST_FRAGMENT: begin
                if (i_transport_fault) state_next = ST_FINISH;
                else if (cnt_fragment >= C_FRAGMENT_CLOCKS-1) state_next = ST_OFFER;
            end
            ST_ACK: begin
                if (flag_response || i_transport_fault || flag_response_expired) state_next = ST_FINISH;
            end
            ST_FINISH: state_next = ST_IDLE;
            default: state_next = ST_FINISH;
        endcase
    end
    // 捕获输入、定时与解码；应答可在发送完成轮询前到达。
    always @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            reg_command <= 0; flag_axis <= 0; flag_fragment <= 0; flag_negative <= 0;
            reg_magnitude <= 0; reg_function <= 0; cnt_response <= 0; cnt_fragment <= 0;
            flag_response <= 0; flag_response_ok <= 0; reg_error_o <= 0;
            flag_done_o <= 0; flag_ok_o <= 0; reg_motor_status_o <= 0;
            flag_position_negative_o <= 0; reg_position_magnitude_o <= 0;
            cnt_command_gap <= 0;
        end else begin
            flag_done_o <= 0;
            if (cnt_command_gap != 0) cnt_command_gap <= cnt_command_gap - 1'b1;
            if (state_current != ST_IDLE && !flag_response_expired) cnt_response <= cnt_response + 1'b1;
            if (state_current == ST_IDLE && i_request && o_ready) begin
                reg_command <= i_command; flag_axis <= i_axis; flag_fragment <= 0;
                flag_negative <= i_target[15];
                if (i_target[15]) reg_magnitude <= -i_target;
                else reg_magnitude <= i_target;
                cnt_response <= 0; cnt_fragment <= 0; flag_response <= 0;
                flag_response_ok <= 0; flag_ok_o <= 0; reg_error_o <= 0;
                case (i_command)
                    0: reg_function <= 8'h46;
                    1: reg_function <= 8'h0a;
                    2,7: reg_function <= 8'hf3;
                    3: reg_function <= 8'hfd;
                    4: reg_function <= 8'h3a;
                    5: reg_function <= 8'h36;
                    6: reg_function <= 8'hfe;
                    8: reg_function <= 8'h50;
                    default: reg_function <= 0;
                endcase
            end
            if (state_current == ST_SENT && i_tx_done && !flag_last_fragment) cnt_fragment <= 0;
            if (state_current == ST_FRAGMENT) begin
                cnt_fragment <= cnt_fragment+1'b1;
                if (cnt_fragment >= C_FRAGMENT_CLOCKS-1) flag_fragment <= 1;
            end
            if (i_rx_valid && !flag_response && flag_receive_window && flag_last_fragment && flag_match_id && flag_match_function) begin
                if (reg_command == 5) begin
                    if (i_rx_length == 7 && i_rx_payload[15:8] == 8'h6b && i_rx_payload[55:49] == 0) begin
                        flag_position_negative_o <= i_rx_payload[48];
                        reg_position_magnitude_o <= i_rx_payload[47:16];
                        flag_response <= 1; flag_response_ok <= 1;
                    end
                end else if (i_rx_length == 3 && i_rx_payload[47:40] == 8'h6b) begin
                    if (reg_command == 4) begin
                        reg_motor_status_o <= i_rx_payload[55:48];
                        flag_response <= 1; flag_response_ok <= 1;
                    end else if (i_rx_payload[55:48] == 8'h02) begin
                        flag_response <= 1; flag_response_ok <= 1;
                    end else if (i_rx_payload[55:48] == 8'he2 || i_rx_payload[55:48] == 8'hee) begin
                        flag_response <= 1; flag_response_ok <= 0;
                    end
                end
            end
            if (state_current == ST_FINISH) begin
                if (reg_command != 6 && reg_command != 7)
                    cnt_command_gap <= C_COMMAND_GAP_CLOCKS;
                flag_done_o <= 1;
                if (i_transport_fault) begin flag_ok_o <= 0; reg_error_o <= 3; end
                else if (flag_response) begin
                    flag_ok_o <= flag_response_ok;
                    if (!flag_response_ok) reg_error_o <= 2;
                end else begin flag_ok_o <= 0; reg_error_o <= 1; end
            end
        end
    end
endmodule
