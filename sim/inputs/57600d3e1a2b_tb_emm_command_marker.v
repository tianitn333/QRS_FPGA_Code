`timescale 1ns/1ps
// Emm协议字段与应答窗口的确定性模型，不代替真实CAN核或驱动器。
module tb_emm_command_marker;
    reg clock=0;
    always #5 clock=~clock;
    reg reset_n=0, request=0, axis=0;
    reg [3:0] command=0;
    reg signed [15:0] target=0;
    wire ready,done,ok,negative,tx_valid;
    wire [3:0] error,tx_length;
    wire [7:0] status;
    wire [31:0] magnitude;
    wire [28:0] tx_identifier;
    wire [63:0] tx_payload;
    reg tx_ready=0,tx_done=0,rx_valid=0,transport_fault=0;
    reg [28:0] rx_identifier=0;
    reg [3:0] rx_length=0;
    reg [63:0] rx_payload=0;
    integer observations=0;
    EmmCommandInterface #(.C_COMMAND_GAP_CLOCKS(8),.C_RESPONSE_CLOCKS(100),.C_FRAGMENT_CLOCKS(8)) dut(
        .i_clk(clock),.i_rstn(reset_n),.i_request(request),.o_ready(ready),.i_axis(axis),
        .i_command(command),.i_target(target),.o_done(done),.o_ok(ok),.o_error(error),
        .o_motor_status(status),.o_position_negative(negative),.o_position_magnitude(magnitude),
        .o_tx_valid(tx_valid),.i_tx_ready(tx_ready),.o_tx_identifier(tx_identifier),
        .o_tx_length(tx_length),.o_tx_payload(tx_payload),.i_tx_done(tx_done),
        .i_rx_valid(rx_valid),.i_rx_identifier(rx_identifier),.i_rx_length(rx_length),
        .i_rx_payload(rx_payload),.i_transport_fault(transport_fault));
    task automatic start;
        input selected_axis;
        input [3:0] selected_command;
        input signed [15:0] selected_target;
        begin
            while(!ready) @(negedge clock);
            @(negedge clock);axis=selected_axis;command=selected_command;target=selected_target;request=1;
            @(negedge clock);request=0;
        end
    endtask
    task automatic accept_frame;
        input [28:0] identifier;
        input [3:0] length;
        input [63:0] payload;
        begin
            while(!tx_valid) @(negedge clock);
            repeat(3) @(negedge clock);
            if(tx_identifier !== identifier || tx_length !== length || tx_payload !== payload)
                $fatal(1,"FAIL frame id=%h len=%d data=%h expected=%h",tx_identifier,tx_length,tx_payload,payload);
            observations=observations+1;
            tx_ready=1;@(negedge clock);tx_ready=0;
        end
    endtask
    task automatic sent;
        begin repeat(3) @(negedge clock);tx_done=1;@(negedge clock);tx_done=0;end
    endtask
    task automatic response;
        input [28:0] identifier;
        input [3:0] length;
        input [63:0] payload;
        begin
            @(negedge clock);rx_identifier=identifier;rx_length=length;rx_payload=payload;rx_valid=1;
            @(negedge clock);rx_valid=0;
        end
    endtask
    task automatic finish;
        input expected_ok;
        input [3:0] expected_error;
        integer timeout;
        begin
            timeout=0;
            while(!done && timeout<150) begin @(negedge clock);timeout=timeout+1;end
            if(!done || ok !== expected_ok || error !== expected_error)
                $fatal(1,"FAIL result done=%b ok=%b error=%d",done,ok,error);
            observations=observations+1;
            @(negedge clock);
        end
    endtask
    initial begin
        repeat(4) @(negedge clock);reset_n=1;
        start(0,0,0);accept_frame(29'h100,5,64'h466900016b000000);sent();response(29'h100,3,64'h46026b0000000000);finish(1,0);
        start(1,1,0);accept_frame(29'h200,3,64'h0a6d6b0000000000);sent();response(29'h200,3,64'h0a026b0000000000);finish(1,0);
        start(1,2,0);accept_frame(29'h200,5,64'hf3ab01006b000000);response(29'h200,3,64'hf3026b0000000000);sent();finish(1,0);
        start(0,8,0);accept_frame(29'h100,3,64'h50016b0000000000);sent();response(29'h100,3,64'h50026b0000000000);finish(1,0);
        start(1,8,0);accept_frame(29'h200,3,64'h50016b0000000000);response(29'h200,3,64'h50026b0000000000);sent();finish(1,0);
        // 50RPM、绝对负向L1，接收ACK不等于FD9F到位提示。
        start(0,3,-1727);accept_frame(29'h100,8,64'hfd01003264000006);sent();
        accept_frame(29'h101,5,64'hfdbf01006b000000);sent();
        response(29'h200,3,64'hfd026b0000000000);
        response(29'h100,3,64'hfd9f6b0000000000);
        if(done) $fatal(1,"FAIL wrong address or arrival was accepted as command ACK");
        response(29'h100,3,64'hfd026b0000000000);finish(1,0);
        start(1,3,-2817);accept_frame(29'h200,8,64'hfd0100326400000b);sent();
        accept_frame(29'h201,5,64'hfd0101006b000000);sent();response(29'h200,3,64'hfd026b0000000000);finish(1,0);
        start(1,3,-4047);accept_frame(29'h200,8,64'hfd0100326400000f);sent();
        accept_frame(29'h201,5,64'hfdcf01006b000000);sent();response(29'h200,3,64'hfd026b0000000000);finish(1,0);
        start(0,4,0);accept_frame(29'h100,2,64'h3a6b000000000000);sent();response(29'h100,3,64'h3a036b0000000000);finish(1,0);
        if(status !== 3) $fatal(1,"FAIL motor status");
        start(1,5,0);accept_frame(29'h200,2,64'h366b000000000000);sent();response(29'h200,7,64'h3601000143956b00);finish(1,0);
        if(!negative || magnitude !== 82837) $fatal(1,"FAIL signed multi-turn encoder");
        start(0,5,0);accept_frame(29'h100,2,64'h366b000000000000);sent();response(29'h100,7,64'h3600000000336b00);finish(1,0);
        if(negative || magnitude !== 51) $fatal(1,"FAIL positive encoder");
        start(0,6,0);accept_frame(29'h100,4,64'hfe98006b00000000);sent();response(29'h100,3,64'hfe026b0000000000);finish(1,0);
        start(1,7,0);accept_frame(29'h200,5,64'hf3ab00006b000000);sent();response(29'h200,3,64'hf3026b0000000000);finish(1,0);
        start(0,2,0);accept_frame(29'h100,5,64'hf3ab01006b000000);sent();response(29'h100,3,64'hf3e26b0000000000);finish(0,2);
        start(1,4,0);accept_frame(29'h200,2,64'h3a6b000000000000);sent();response(29'h100,3,64'h3a036b0000000000);finish(0,1);
        // 报文层恰在事务截止后ready，也不能再接受迟发命令。
        start(1,4,0);tx_ready=0;
        while(!dut.flag_response_expired)@(negedge clock);
        tx_ready=1;
        if(tx_valid)$fatal(1,"FAIL expired transaction offered a late CAN frame");
        finish(0,1);tx_ready=0;
        start(0,4,0);transport_fault=1;finish(0,3);transport_fault=0;
        start(1,3,-4047);accept_frame(29'h200,8,64'hfd0100326400000f);
        reset_n=0;repeat(4) @(negedge clock);reset_n=1;repeat(20) @(negedge clock);
        if(!ready || tx_valid || done) $fatal(1,"FAIL reset restarted transaction");
        $display("PASS Emm command observations=%0d",observations);$finish;
    end
    initial begin #100000; $fatal(1,"FAIL global timeout");end
endmodule
