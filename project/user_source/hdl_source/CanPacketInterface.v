`timescale 1ns / 1ps
// Company: QRS / Engineer: project contributors
// Create Date: 2026-11-03 / Design: classical CAN packet host
// Module: CanPacketInterface / Description: bounded PeliCAN Wishbone host
// Simulation: tb_can_packet / References: fixed OpenCores CAN register map
// Dependencies: can_top / Version: 1.0 / Revision Date: 2026-11-03
// Revision History: initial isolated packet interface
// 公司：QRS / 工程师：工程维护者
// 创建日期：2026-11-03 / 设计：经典CAN报文主机
// 模块名称：CanPacketInterface / 描述：有界Wishbone访问与完整报文接收
// 仿真工程：tb_can_packet / 参考：固定OpenCores寄存器实现
// 依赖：can_top / 版本：1.0 / 修订日期：2026-11-03
// 修订记录：独立报文接口初次实现
module CanPacketInterface #(
    parameter C_TX_TIMEOUT = 750000 // 75MHz下10ms，无ACK时中止本次发送。
) (
    input wire i_clk, // 与CAN协议核及Wishbone相同的75MHz时钟。
    input wire i_rstn, // 低有效复位，外部按本域同步释放。
    input wire i_receive, // 收发器RXD经过外部双级同步后的电平。
    output wire o_transmit, // 空闲为1，接收发器TXD。
    input wire i_tx_valid, // 主机保持完整报文至ready握手。
    output wire o_tx_ready, // 空闲缓冲区且无待处理接收帧时接收。
    input wire [28:0] i_tx_identifier, // 完整29位扩展标识符。
    input wire [3:0] i_tx_length, // 允许0..8字节经典数据帧。
    input wire [63:0] i_tx_payload, // 第一个线上字节放在63:56，其余右侧补0。
    output wire o_tx_done, // 仅真实CAN发送完成后脉冲，不代表电机到位。
    output wire o_rx_valid, // 接收缓存释放后输出一拍完整帧。
    output wire [28:0] o_rx_identifier, // 收到的29位标识符。
    output wire [3:0] o_rx_length, // 实际接收长度。
    output wire [63:0] o_rx_payload, // 字节从高到低，长度外补0。
    output wire o_ready, // 寄存器初始化已完成。
    output wire [39:0] o_probe_registers,
    output wire [7:0] o_probe_host,
    output wire [7:0] o_probe_status,
    output wire o_fault // WB超时、bus-off或发送超时锁存，复位清除。
);
    localparam ST_SELECT = 3'd0, ST_ACCESS = 3'd1, ST_GAP = 3'd2;
    localparam ST_DISPATCH = 3'd3, ST_FAULT = 3'd4;
    localparam PH_INIT = 3'd0, PH_POLL = 3'd1, PH_TX_LOAD = 3'd2;
    localparam PH_TX_COMMAND = 3'd3, PH_RX_HEADER = 3'd4;
    localparam PH_RX_DATA = 3'd5, PH_RX_RELEASE = 3'd6, PH_ABORT = 3'd7;
    reg [2:0] state_current, state_next; // WB事务控制状态。
    reg [2:0] reg_phase; // 上层寄存器操作阶段。
    reg [4:0] cnt_index; // 初始化或帧内字节序号。
    reg [3:0] cnt_gap; // 满足核心请求同步清除所需间隙。
    reg [7:0] cnt_access; // WB访问看门狗。
    reg [19:0] cnt_transmit; // 活跃发送时累计，不因轮询清零。
    reg [7:0] reg_address, reg_write_data, reg_read_data;
    reg [7:0] reg_probe_status;
    reg flag_write; // SELECT阶段提交的读写方向。
    reg [28:0] reg_tx_identifier; // 握手后的发送ID保持。
    reg [63:0] reg_tx_shift; // 发送字节串行移出，避免大动态选择器。
    reg [3:0] reg_tx_length; // 发送DLC保持。
    reg [4:0] reg_tx_last; // 最后一个发送缓冲区寄存器序号。
    reg flag_pending; // 已请求发送，等待TCS或故障。
    reg flag_rx_accept; // 只上报扩展数据帧，非法帧仍释放缓存。
    reg [28:0] reg_rx_identifier_o; // 完整接收ID，报文间保持。
    reg [63:0] reg_rx_payload_o; // 接收数据累积寄存器。
    reg [3:0] reg_rx_length_o; // 接收头中的DLC。
    reg flag_tx_done_o, flag_rx_valid_o, flag_ready_o, flag_fault_o;
    wire [7:0] dec_read_data;
    wire flag_ack, flag_bus_available;
    wire flag_access_active = state_current == ST_ACCESS;
    wire flag_tx_expired = flag_pending && cnt_transmit >= C_TX_TIMEOUT-1;
    wire flag_tx_offer = i_tx_valid && i_tx_length <= 8;
    assign o_tx_ready = state_current == ST_DISPATCH && reg_phase == PH_POLL &&
                        !reg_read_data[0] && reg_read_data[2] && !reg_read_data[7] &&
                        !flag_pending && !flag_tx_expired;
    assign o_tx_done = flag_tx_done_o;
    assign o_rx_valid = flag_rx_valid_o;
    assign o_rx_identifier = reg_rx_identifier_o;
    assign o_rx_length = reg_rx_length_o;
    assign o_rx_payload = reg_rx_payload_o;
    assign o_probe_host = {flag_pending,flag_fault_o,state_current,reg_phase};
    assign o_probe_status = reg_probe_status;
    assign o_ready = flag_ready_o;
    assign o_fault = flag_fault_o;

    can_top CanCore_Inst (
        .wb_clk_i(i_clk), .wb_rst_i(!i_rstn), .clk_i(i_clk),
        .wb_dat_i(reg_write_data), .wb_dat_o(dec_read_data),
        .wb_cyc_i(flag_access_active), .wb_stb_i(flag_access_active),
        .wb_we_i(flag_write), .wb_adr_i(reg_address), .wb_ack_o(flag_ack),
        .o_probe_registers(o_probe_registers),
        .rx_i(i_receive), .tx_o(o_transmit), .bus_off_on(flag_bus_available),
        .irq_on(), .clkout_o()
    );

    // 状态寄存器与全部数据使用同一时钟，不产生派生时钟。
    always @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) state_current <= ST_SELECT;
        else state_current <= state_next;
    end
    // 单个WB事务等待ACK，事务之间至少11拍撤销cyc/stb。
    always @(*) begin
        state_next = state_current;
        case (state_current)
            ST_SELECT: state_next = ST_ACCESS;
            ST_ACCESS: begin
                if (flag_ack) state_next = ST_GAP;
                else if (cnt_access == 8'hff) state_next = ST_FAULT;
            end
            ST_GAP: if (cnt_gap == 10) state_next = ST_DISPATCH;
            ST_DISPATCH: begin
                if (reg_phase == PH_ABORT) state_next = ST_FAULT;
                else state_next = ST_SELECT;
            end
            ST_FAULT: state_next = ST_FAULT;
            default: state_next = ST_FAULT;
        endcase
    end

    // 地址/载荷先寄存后发起访问；ACK读数只在单拍结束边沿捕获。
    always @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            reg_probe_status <= 0;
            reg_phase <= PH_INIT; cnt_index <= 0; cnt_gap <= 0; cnt_access <= 0;
            cnt_transmit <= 0; reg_address <= 0; reg_write_data <= 0; reg_read_data <= 0;
            flag_write <= 0; reg_tx_identifier <= 0; reg_tx_shift <= 0;
            reg_tx_length <= 0; reg_tx_last <= 0; flag_pending <= 0;
            flag_rx_accept <= 0; reg_rx_identifier_o <= 0; reg_rx_payload_o <= 0;
            reg_rx_length_o <= 0; flag_tx_done_o <= 0; flag_rx_valid_o <= 0;
            flag_ready_o <= 0; flag_fault_o <= 0;
        end else begin
            flag_tx_done_o <= 0; flag_rx_valid_o <= 0;
            if (flag_pending && !flag_tx_expired) cnt_transmit <= cnt_transmit + 1'b1;
            if (state_current == ST_FAULT) begin
                flag_fault_o <= 1; flag_ready_o <= 0;
            end
            case (state_current)
                ST_SELECT: begin
                    cnt_access <= 0; cnt_gap <= 0;
                    flag_write <= 0; reg_address <= 2; reg_write_data <= 0;
                    case (reg_phase)
                        PH_INIT: begin
                            flag_write <= 1;
                            case (cnt_index)
                                0: begin reg_address <= 0; reg_write_data <= 1; end
                                1: begin reg_address <= 31; reg_write_data <= 8'h80; end
                                2: begin reg_address <= 6; reg_write_data <= 8'h04; end
                                3: begin reg_address <= 7; reg_write_data <= 8'h2a; end
                                4,5,6,7: begin reg_address <= 12+cnt_index; reg_write_data <= 0; end
                                8,9,10,11: begin reg_address <= 12+cnt_index; reg_write_data <= 8'hff; end
                                default: begin reg_address <= 0; reg_write_data <= 0; end
                            endcase
                        end
                        PH_TX_LOAD: begin
                            flag_write <= 1; reg_address <= 16+cnt_index;
                            case (cnt_index)
                                0: reg_write_data <= {4'h8,reg_tx_length};
                                1: reg_write_data <= reg_tx_identifier[28:21];
                                2: reg_write_data <= reg_tx_identifier[20:13];
                                3: reg_write_data <= reg_tx_identifier[12:5];
                                4: reg_write_data <= {reg_tx_identifier[4:0],3'd0};
                                default: reg_write_data <= reg_tx_shift[63:56];
                            endcase
                        end
                        PH_TX_COMMAND: begin flag_write <= 1; reg_address <= 1; reg_write_data <= 1; end
                        PH_RX_HEADER: reg_address <= 16+cnt_index;
                        PH_RX_DATA: reg_address <= 21+cnt_index;
                        PH_RX_RELEASE: begin flag_write <= 1; reg_address <= 1; reg_write_data <= 4; end
                        PH_ABORT: begin flag_write <= 1; reg_address <= 1; reg_write_data <= 2; end
                        default: begin flag_write <= 0; reg_address <= 2; end
                    endcase
                end
                ST_ACCESS: begin
                    cnt_access <= cnt_access + 1'b1;
                    if (flag_ack) reg_read_data <= dec_read_data;
                    if (flag_ack && !flag_write && reg_address==2) reg_probe_status <= dec_read_data;
                end
                ST_GAP: cnt_gap <= cnt_gap + 1'b1;
                ST_DISPATCH: begin
                    case (reg_phase)
                        PH_INIT: begin
                            if (cnt_index == 12) begin reg_phase <= PH_POLL; flag_ready_o <= 1; end
                            else cnt_index <= cnt_index + 1'b1;
                        end
                        PH_POLL: begin
                            if (reg_read_data[7] || !flag_bus_available || flag_tx_expired) begin
                                reg_phase <= PH_ABORT; flag_fault_o <= 1;
                            end else if (reg_read_data[0]) begin
                                reg_phase <= PH_RX_HEADER; cnt_index <= 0;
                                reg_rx_identifier_o <= 0; reg_rx_payload_o <= 0; flag_rx_accept <= 0;
                            end else if (flag_pending) begin
                                if (reg_read_data[2] && reg_read_data[3]) begin
                                    flag_pending <= 0; flag_tx_done_o <= 1;
                                end
                            end else if (o_tx_ready && flag_tx_offer) begin
                                reg_tx_identifier <= i_tx_identifier; reg_tx_shift <= i_tx_payload;
                                reg_tx_length <= i_tx_length; reg_tx_last <= 4+i_tx_length;
                                reg_phase <= PH_TX_LOAD; cnt_index <= 0;
                            end
                        end
                        PH_TX_LOAD: begin
                            if (cnt_index >= 5) reg_tx_shift <= {reg_tx_shift[55:0],8'd0};
                            if (cnt_index == reg_tx_last) reg_phase <= PH_TX_COMMAND;
                            else cnt_index <= cnt_index + 1'b1;
                        end
                        PH_TX_COMMAND: begin reg_phase <= PH_POLL; flag_pending <= 1; cnt_transmit <= 0; end
                        PH_RX_HEADER: begin
                            case (cnt_index)
                                0: begin
                                    reg_rx_length_o <= reg_read_data[3:0];
                                    flag_rx_accept <= reg_read_data[7:4] == 4'h8 && reg_read_data[3:0] <= 8;
                                end
                                1: reg_rx_identifier_o[28:21] <= reg_read_data;
                                2: reg_rx_identifier_o[20:13] <= reg_read_data;
                                3: reg_rx_identifier_o[12:5] <= reg_read_data;
                                4: reg_rx_identifier_o[4:0] <= reg_read_data[7:3];
                                default: flag_rx_accept <= 0;
                            endcase
                            if (cnt_index == 4) begin reg_phase <= PH_RX_DATA; cnt_index <= 0; end
                            else cnt_index <= cnt_index + 1'b1;
                        end
                        PH_RX_DATA: begin
                            if (cnt_index < reg_rx_length_o) reg_rx_payload_o <= {reg_rx_payload_o[55:0],reg_read_data};
                            else reg_rx_payload_o <= {reg_rx_payload_o[55:0],8'd0};
                            if (cnt_index == 7) reg_phase <= PH_RX_RELEASE;
                            else cnt_index <= cnt_index + 1'b1;
                        end
                        PH_RX_RELEASE: begin reg_phase <= PH_POLL; flag_rx_valid_o <= flag_rx_accept; end
                        default: flag_fault_o <= 1;
                    endcase
                end
                default: begin end
            endcase
        end
    end
endmodule
