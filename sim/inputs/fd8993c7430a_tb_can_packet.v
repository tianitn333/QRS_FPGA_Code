`timescale 1ns / 1ps
// 两个真实协议核验证报文接口；对端为测试主机，不模拟机械运动。
module tb_can_packet;
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
    reg tx_valid = 0;
    reg [28:0] tx_identifier = 0;
    reg [3:0] tx_length = 0;
    reg [63:0] tx_payload = 0;
    wire tx_ready, tx_done, rx_valid, ready, fault;
    wire [28:0] rx_identifier;
    wire [3:0] rx_length;
    wire [63:0] rx_payload;
    integer packets = 0, observations = 0;
    reg [28:0] observed_id;
    reg [3:0] observed_length;
    reg [63:0] observed_payload;
    integer rx_count = 0;
    reg [7:0] temporary;

    CanPacketInterface #(.C_TX_TIMEOUT(75000)) dut (
        .i_clk(clock), .i_rstn(reset_n), .i_receive(can_bus), .o_transmit(transmit),
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
    task automatic send_packet;
        input [28:0] identifier;
        input [3:0] length;
        input [63:0] payload;
        integer timeout;
        begin
            @(negedge clock); tx_identifier=identifier; tx_length=length; tx_payload=payload; tx_valid=1;
            timeout=0;
            while (!tx_ready && timeout<10000) begin @(negedge clock); timeout=timeout+1; end
            if (timeout==10000) $fatal(1,"FAIL TX ready timeout");
            @(negedge clock); tx_valid=0;
            timeout=0;
            while (!tx_done && !fault && timeout<100000) begin @(negedge clock); timeout=timeout+1; end
            if (!tx_done || fault) $fatal(1,"FAIL TX completion timeout/fault");
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
            while (!value[0] && timeout<10000) begin read_register(2,value); timeout=timeout+1; end
            if (timeout==10000) $fatal(1,"FAIL peer receive timeout");
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
            while (rx_count==baseline && timeout<100000) begin @(negedge clock); timeout=timeout+1; end
            if (timeout==100000) $fatal(1,"FAIL host receive timeout");
            if (observed_id !== identifier || observed_length !== length || observed_payload !== payload)
                $fatal(1,"FAIL RX id=%h len=%d payload=%h",observed_id,observed_length,observed_payload);
            packets=packets+1;
        end
    endtask
    initial begin
        repeat(20) @(negedge clock); reset_n=1;
        configure_peer(); $display("PEER configured time=%t state=%d phase=%d idx=%d ack=%b ready=%b fault=%b",$time,dut.state_current,dut.reg_phase,dut.cnt_index,dut.flag_ack,ready,fault);
        wait(ready); repeat(4000) @(negedge clock);
        $display("PACKET tests start time=%t",$time);
        send_packet(29'h100,8,64'hfd01000a64000006); receive_peer(29'h100,8,64'hfd01000a64000006);
        send_packet(29'h101,5,64'hfdbf01006b000000); receive_peer(29'h101,5,64'hfdbf01006b000000);
        send_packet(29'h200,3,64'h366b000000000000); receive_peer(29'h200,3,64'h366b000000000000);
        send_packet(29'h201,0,64'd0); receive_peer(29'h201,0,64'd0);
        send_packet(29'h1abcde31,8,64'h0123456789abcdef); receive_peer(29'h1abcde31,8,64'h0123456789abcdef);
        send_peer(29'h100,3,64'hfd026b0000000000);
        send_peer(29'h200,7,64'h3601000143956b00);
        send_peer(29'h201,8,64'h0123456789abcdef);
        send_peer(29'h1abcde31,0,64'd0);
        // 缺ACK时不能给出成功，超时必须锁存并撤销发送请求。
        disconnect_peer=1;
        @(negedge clock); tx_valid=1; tx_identifier=29'h100; tx_length=2; tx_payload=64'h366b000000000000;
        while (!tx_ready) @(negedge clock);
        @(negedge clock); tx_valid=0;
        wait(fault); repeat(500) @(negedge clock);
        if (tx_done || ready || !fault || dut.flag_pending === 1'bx) $fatal(1,"FAIL timeout fault contract");
        if (!dut.CanCore_Inst.abort_tx) $display("INFO abort command was pulsed before locked fault");
        $display("PASS CAN packet interface packets=%0d byte_checks=%0d rx=%0d",packets,observations,rx_count);
        $finish;
    end
    initial begin #20000000;
        $display("DEBUG state=%d phase=%d idx=%d access=%d read=%h addr=%h ack=%b ready=%b fault=%b pending=%b rx=%d tx=%b",dut.state_current,dut.reg_phase,dut.cnt_index,dut.cnt_access,dut.reg_read_data,dut.reg_address,dut.flag_ack,ready,fault,dut.flag_pending,rx_count,transmit);
        $fatal(1,"FAIL global timeout"); end
endmodule
