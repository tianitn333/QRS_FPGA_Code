`timescale 1ns/1ps
module tb_can_fault_snapshot;
    reg clk=0,rst=0,arm=0,done=0,ok=1,accept=0,txdone=0,ready=1,fault=0,protocol=0,tx=1,rx=1;
    always #5 clk=~clk;
    reg [2:0] stage=0;
    reg [15:0] context=16'h0146;
    reg [39:0] registers=40'h0080042a0c;
    reg [7:0] host=8'h19,status=8'h0c;
    reg [3:0] motor=1;
    wire valid;wire [127:0] snapshot;
    reg [127:0] frozen;
    CanFaultSnapshot dut(.i_clk(clk),.i_rstn(rst),.i_arm(arm),.i_stage(stage),.i_context(context),
        .i_registers(registers),.i_host(host),.i_status(status),.i_done(done),.i_ok(ok),.i_motor_state(motor),
        .i_tx_accept(accept),.i_tx_done(txdone),.i_can_ready(ready),.i_can_fault(fault),.i_protocol_rstn(protocol),
        .i_transmit(tx),.i_receive(rx),.o_valid(valid),.o_snapshot(snapshot));
    initial begin
        repeat(4)@(negedge clk);rst=1;arm=1;protocol=1;
        repeat(3)@(negedge clk);stage=1;accept=1;
        @(negedge clk);accept=0;stage=2;txdone=1;
        @(negedge clk);txdone=0;stage=4;
        repeat(3)@(negedge clk);stage=5;
        @(negedge clk);stage=0;done=1;ok=0;
        @(negedge clk);done=0;
        if(!valid || snapshot!==128'h0080042a0c0c01460419010100b801d1)
            $fatal(1,"FAIL first fault snapshot %h",snapshot);
        frozen=snapshot;
        context=16'h02fe;registers=40'h0180042a00;stage=1;accept=1;tx=0;rx=0;fault=1;
        repeat(20)@(negedge clk);arm=0;protocol=0;
        repeat(20)@(negedge clk);
        if(snapshot!==frozen || !valid)$fatal(1,"FAIL stop/disarm overwrote fault");
        accept=0;tx=1;rx=1;fault=0;ok=1;stage=0;registers=40'h0080042a0c;context=16'h0146;arm=1;protocol=1;
        repeat(3)@(negedge clk);
        if(!valid || snapshot[7:0]!=8'hd1 || snapshot[15:8]!=0 || snapshot[47:32]!=0)
            $fatal(1,"FAIL rearm did not clear locked/counters");
        motor=3;repeat(3)@(negedge clk);
        if(snapshot[15:8]!=2)$fatal(1,"FAIL ready event");
        motor=2;accept=1;txdone=1;
        repeat(270)begin @(negedge clk);tx=~tx;end
        accept=0;txdone=0;repeat(3)@(negedge clk);
        if(snapshot[47:32]!=16'hffff || snapshot[31:24]!=8'hff)$fatal(1,"FAIL counter saturation");
        protocol=0;repeat(3)@(negedge clk);protocol=1;repeat(3)@(negedge clk);
        if(!snapshot[16])$fatal(1,"FAIL protocol-reset observation missing");
        $display("PASS probe first-fault exact fields, pre-finish stage, stop/disarm retention, rearm, live/ready and counter saturation");$finish;
    end
    initial begin #100000;$fatal(1,"FAIL snapshot watchdog");end
endmodule
