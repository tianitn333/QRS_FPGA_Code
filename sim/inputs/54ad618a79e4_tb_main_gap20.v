`timescale 1ns / 1ps
module tb_main_gap20;
    reg clk=0,rst=0,request=0,axis=0,tx_ready=0,tx_done=0,rx_valid=0;
    always #6.666667 clk=~clk;
    reg [3:0] command=0,rx_length=3;
    reg [28:0] rx_id=29'h100;
    reg [63:0] rx_data=0;
    wire ready,done,ok,tx_valid;
    wire [3:0] error,reason;
    wire [2:0] state;
    wire [7:0] function_code;
    wire [28:0] tx_id;
    wire [3:0] tx_length;
    wire [63:0] tx_data;
    integer cycles=0,finished_at=0,accepted_at=0;
    always @(posedge clk)cycles=cycles+1;
    EmmCommandInterface #(.C_RESPONSE_CLOCKS(1000)) dut(.i_clk(clk),.i_rstn(rst),
        .i_request(request),.o_ready(ready),.i_axis(axis),.i_command(command),.i_target(16'sd0),
        .o_done(done),.o_ok(ok),.o_error(error),.o_motor_status(),.o_position_negative(),.o_position_magnitude(),
        .o_tx_valid(tx_valid),.i_tx_ready(tx_ready),.o_tx_identifier(tx_id),.o_tx_length(tx_length),
        .o_tx_payload(tx_data),.i_tx_done(tx_done),.i_rx_valid(rx_valid),.i_rx_identifier(rx_id),
        .i_rx_length(rx_length),.i_rx_payload(rx_data),.i_transport_fault(1'b0));
    task start;
        input [3:0] cmd;
        begin
            @(negedge clk);command=cmd;
            while(!ready)@(negedge clk);
            request=1;@(negedge clk);request=0;
            wait(tx_valid);@(negedge clk);tx_ready=1;
            @(negedge clk);tx_ready=0;tx_done=1;
            @(negedge clk);tx_done=0;
        end
    endtask
    task respond;
        input [63:0] payload;
        begin
            @(negedge clk);rx_data=payload;rx_valid=1;#1;
            @(negedge clk);rx_valid=0;
            wait(done);@(negedge clk);if(!ok||error)$fatal(1,"FAIL command completion");
        end
    endtask
    initial begin
        repeat(4)@(negedge clk);rst=1;
        start(0);respond(64'h46026b0000000000);finished_at=cycles;
        command=1;
        repeat(1499998)begin @(negedge clk);if(ready)$fatal(1,"FAIL cooldown shorter than 20ms");end
        while(!ready)@(negedge clk);
        accepted_at=cycles;
        if(accepted_at-finished_at<1499998)$fatal(1,"FAIL 20ms not enforced");
        start(1);respond(64'h0a026b0000000000);
        // STOP bypasses a newly loaded cooldown; it must not wait 20ms.
        finished_at=cycles;command=6;#1;
        if(!ready)$fatal(1,"FAIL STOP blocked by ordinary cooldown");
        start(6);respond(64'hfe026b0000000000);
        if(cycles-finished_at>100)$fatal(1,"FAIL STOP delayed");
        command=7;start(7);respond(64'hf3026b0000000000);
        command=4;start(4);
        @(negedge clk);rx_id=29'h200;rx_data=64'h3a836b0000000000;rx_valid=1;#1;
        @(negedge clk);rx_id=29'h100;rx_data=64'h36026b0000000000;#1;
        @(negedge clk);rx_data=64'h3a836b0000000000;rx_length=2;#1;
        @(negedge clk);rx_length=3;rx_data=64'h3a83000000000000;#1;
        @(negedge clk);rx_valid=0;
        wait(done);@(negedge clk);
        if(ok||error!=1)$fatal(1,"FAIL missing correct reply must remain ERR1");
        $display("PASS real 1500000-cycle 20ms cooldown, urgent STOP/DISABLE bypass, match rejection reasons, timeout");
        $finish;
    end
    initial begin #100000000;$fatal(1,"FAIL timeout");end
endmodule

