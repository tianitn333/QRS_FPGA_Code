`timescale 1ns / 1ps
// 两个真实协议核验证报文接口；对端为测试主机，不模拟机械运动。
module tb_emm_can_marker;
    reg clock = 0;
    always #6.666667 clock = ~clock;
    reg reset_n = 0;
    reg [7:0] address = 0, write_data = 0;
    wire [7:0] read_data;
    reg cycle = 0, strobe = 0, write_enable = 0;
    wire acknowledge, transmit, peer_transmit;
    reg disconnect_peer = 0;
    wire can_bus = transmit & peer_transmit;
    wire peer_receive = disconnect_peer ? 1'b1 : can_bus;
    wire tx_valid;
    wire [28:0] tx_identifier;
    wire [3:0] tx_length;
    wire [63:0] tx_payload;
    wire tx_ready, tx_done, rx_valid, ready, fault;
    wire [28:0] rx_identifier;
    wire [3:0] rx_length;
    wire [63:0] rx_payload;
    reg motor_request=0,motor_axis=0;
    reg [3:0] motor_command=0;
    reg signed [15:0] motor_target=0;
    wire motor_ready,motor_done,motor_ok,motor_negative;
    wire [3:0] motor_error;
    wire [7:0] motor_status;
    wire [31:0] motor_magnitude;
    reg receive_meta=1,receive_level=1;
    always @(posedge clock)begin
        if(!reset_n)begin receive_meta<=1;receive_level<=1;end
        else begin receive_meta<=can_bus;receive_level<=receive_meta;end
    end
    EmmCommandInterface #(.C_COMMAND_GAP_CLOCKS(8)) motor(
        .i_clk(clock),.i_rstn(reset_n),.i_request(motor_request),.o_ready(motor_ready),
        .i_axis(motor_axis),.i_command(motor_command),.i_target(motor_target),
        .o_done(motor_done),.o_ok(motor_ok),.o_error(motor_error),
        .o_motor_status(motor_status),.o_position_negative(motor_negative),.o_position_magnitude(motor_magnitude),
        .o_tx_valid(tx_valid),.i_tx_ready(tx_ready),.o_tx_identifier(tx_identifier),
        .o_tx_length(tx_length),.o_tx_payload(tx_payload),.i_tx_done(tx_done),
        .i_rx_valid(rx_valid),.i_rx_identifier(rx_identifier),.i_rx_length(rx_length),
        .i_rx_payload(rx_payload),.i_transport_fault(fault));
    integer packets = 0, observations = 0;
    reg [28:0] observed_id;
    reg [3:0] observed_length;
    reg [63:0] observed_payload;
    integer rx_count = 0;
    reg [7:0] temporary;

    CanPacketInterface #(.C_TX_TIMEOUT(75000)) dut (
        .i_clk(clock), .i_rstn(reset_n), .i_receive(receive_level), .o_transmit(transmit),
        .i_tx_valid(tx_valid), .o_tx_ready(tx_ready), .i_tx_identifier(tx_identifier),
        .i_tx_length(tx_length), .i_tx_payload(tx_payload), .o_tx_done(tx_done),
        .o_rx_valid(rx_valid), .o_rx_identifier(rx_identifier), .o_rx_length(rx_length),
        .o_rx_payload(rx_payload), .o_ready(ready), .o_fault(fault)
    );
    can_top peer (
        .wb_clk_i(clock), .wb_rst_i(!reset_n), .clk_i(clock),
        .wb_dat_i(write_data), .wb_dat_o(read_data), .wb_cyc_i(cycle), .wb_stb_i(strobe),
        .wb_we_i(write_enable), .wb_adr_i(address), .wb_ack_o(acknowledge),
        .rx_i(peer_receive), .tx_o(peer_transmit), .bus_off_on(), .irq_on(), .clkout_o()
    );
    always @(posedge clock) begin
        if (rx_valid) begin
            observed_id <= rx_identifier;
            observed_length <= rx_length;
            observed_payload <= rx_payload;
            rx_count <= rx_count+1;
        end
    end
    task automatic write_register;
        input [7:0] register_address, value;
        integer timeout;
        begin
            @(negedge clock);
            address=register_address; write_data=value; write_enable=1; cycle=1; strobe=1;
            timeout=0;
            while (acknowledge !== 1'b1 && timeout<100) begin @(negedge clock); timeout=timeout+1; end
            if (timeout==100) $fatal(1,"FAIL peer WB write timeout");
            cycle=0; strobe=0; write_enable=0;
            repeat (10) @(negedge clock);
        end
    endtask
    task automatic read_register;
        input [7:0] register_address;
        output [7:0] value;
        integer timeout;
        begin
            @(negedge clock);
            address=register_address; write_enable=0; cycle=1; strobe=1; timeout=0;
            while (acknowledge !== 1'b1 && timeout<100) begin @(negedge clock); timeout=timeout+1; end
            if (timeout==100) $fatal(1,"FAIL peer WB read timeout");
            value=read_data; cycle=0; strobe=0;
            repeat (10) @(negedge clock);
        end
    endtask
    task automatic check_byte;
        input [7:0] actual, expected;
        begin
            observations=observations+1;
            if (actual !== expected) $fatal(1,"FAIL byte actual=%02x expected=%02x",actual,expected);
        end
    endtask
    task automatic configure_peer;
        integer index;
        begin
            write_register(0,1); write_register(31,8'h80);
            write_register(6,4); write_register(7,8'h2a);
            for (index=0;index<4;index=index+1) begin
                write_register(16+index,0); write_register(20+index,8'hff);
            end
            write_register(0,0);
        end
    endtask
    task automatic receive_peer;
        input [28:0] identifier;
        input [3:0] length;
        input [63:0] payload;
        integer index, timeout;
        reg [7:0] value;
        reg [63:0] shifted;
        begin
            timeout=0; value=0;
            while (!value[0] && timeout<100000) begin read_register(2,value); timeout=timeout+1; end
            if (timeout==100000) $fatal(1,"FAIL peer receive timeout");
            read_register(16,value); check_byte(value,{4'h8,length});
            read_register(17,value); check_byte(value,identifier[28:21]);
            read_register(18,value); check_byte(value,identifier[20:13]);
            read_register(19,value); check_byte(value,identifier[12:5]);
            read_register(20,value); check_byte(value,{identifier[4:0],3'd0});
            shifted=payload;
            for(index=0;index<length;index=index+1) begin
                read_register(21+index,value); check_byte(value,shifted[63:56]); shifted=shifted<<8;
            end
            write_register(1,4); packets=packets+1;
        end
    endtask
    task automatic send_peer;
        input [28:0] identifier;
        input [3:0] length;
        input [63:0] payload;
        integer index, baseline, timeout;
        reg [63:0] shifted;
        begin
            baseline=rx_count;
            write_register(16,{4'h8,length}); write_register(17,identifier[28:21]);
            write_register(18,identifier[20:13]); write_register(19,identifier[12:5]);
            write_register(20,{identifier[4:0],3'd0}); shifted=payload;
            for(index=0;index<length;index=index+1) begin write_register(21+index,shifted[63:56]); shifted=shifted<<8; end
            write_register(1,1); timeout=0;
            while (rx_count==baseline && timeout<1000000) begin @(negedge clock); timeout=timeout+1; end
            if (timeout==1000000) $fatal(1,"FAIL host receive timeout");
            if (observed_id !== identifier || observed_length !== length || observed_payload !== payload)
                $fatal(1,"FAIL RX id=%h len=%d payload=%h",observed_id,observed_length,observed_payload);
            packets=packets+1;
        end
    endtask
    task automatic start_motor;
        input selected_axis;
        input [3:0] selected_command;
        input signed [15:0] selected_target;
        begin
            while(!motor_ready)@(negedge clock);
            @(negedge clock);motor_axis=selected_axis;motor_command=selected_command;motor_target=selected_target;motor_request=1;
            @(negedge clock);motor_request=0;
        end
    endtask
    task automatic finish_motor;
        input expected_ok;
        integer timeout;
        begin
            timeout=0;
            while(!motor_done && timeout<100000)begin @(negedge clock);timeout=timeout+1;end
            if(!motor_done || motor_ok!==expected_ok)$fatal(1,"FAIL real-link result ok=%b error=%d",motor_ok,motor_error);
            @(negedge clock);
        end
    endtask
    initial begin
        repeat(20)@(negedge clock);reset_n=1;
        configure_peer();wait(ready);repeat(4000)@(negedge clock);
        start_motor(0,0,0);receive_peer(29'h100,5,64'h466900016b000000);
        send_peer(29'h100,3,64'h46026b0000000000);finish_motor(1);
        start_motor(1,1,0);receive_peer(29'h200,3,64'h0a6d6b0000000000);
        send_peer(29'h200,3,64'h0a026b0000000000);finish_motor(1);
        start_motor(1,2,0);receive_peer(29'h200,5,64'hf3ab01006b000000);
        send_peer(29'h200,3,64'hf3026b0000000000);finish_motor(1);
        start_motor(0,8,0);receive_peer(29'h100,3,64'h50016b0000000000);
        send_peer(29'h100,3,64'h50026b0000000000);finish_motor(1);
        start_motor(1,8,0);receive_peer(29'h200,3,64'h50016b0000000000);
        send_peer(29'h200,3,64'h50026b0000000000);finish_motor(1);
        start_motor(0,3,-4047);receive_peer(29'h100,8,64'hfd0100326400000f);
        receive_peer(29'h101,5,64'hfdcf01006b000000);
        send_peer(29'h100,3,64'hfd026b0000000000);finish_motor(1);
        start_motor(1,3,-2817);receive_peer(29'h200,8,64'hfd0100326400000b);
        receive_peer(29'h201,5,64'hfd0101006b000000);
        send_peer(29'h200,3,64'hfd026b0000000000);finish_motor(1);
        start_motor(1,4,0);receive_peer(29'h200,2,64'h3a6b000000000000);
        send_peer(29'h200,3,64'h3a036b0000000000);finish_motor(1);
        if(motor_status!==3)$fatal(1,"FAIL real-link motor status");
        start_motor(1,5,0);receive_peer(29'h200,2,64'h366b000000000000);
        send_peer(29'h200,7,64'h3601000143956b00);finish_motor(1);
        if(!motor_negative || motor_magnitude!==82837)$fatal(1,"FAIL real-link encoder decode");
        $display("PASS Emm CAN link packets=%0d byte_checks=%0d",packets,observations);$finish;
    end
    initial begin #40000000;$fatal(1,"FAIL real-link timeout");end
endmodule
