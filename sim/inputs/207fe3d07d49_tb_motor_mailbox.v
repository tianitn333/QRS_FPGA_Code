`timescale 1ns/1ps
module tb_motor_mailbox;
    reg source_clock=0,destination_clock=0,reset_n=0,send=0;
    always #8.3 source_clock=~source_clock;
    always #6.666667 destination_clock=~destination_clock;
    reg [31:0] serial=1;
    wire ready,valid;
    wire [223:0] packet;
    integer received=0,index;
    ae_mailbox #(.WIDTH(224)) dut(
        .s_clk(source_clock),.s_rst_n(reset_n),.s_send(send),.s_data({7{serial}}),.s_ready(ready),
        .d_clk(destination_clock),.d_rst_n(reset_n),.d_valid(valid),.d_data(packet));
    always @(posedge source_clock)if(reset_n && send && ready)serial<=serial+1;
    always @(posedge destination_clock)if(valid)begin
        for(index=0;index<7;index=index+1)
            if(packet[index*32+:32]!==packet[31:0])$fatal(1,"FAIL race/status not atomic");
        received=received+1;
    end
    initial begin
        #100;reset_n=1;send=1;
        wait(received==30);@(negedge source_clock);send=0;
        repeat(20)@(negedge destination_clock);
        if(received<30)$fatal(1,"FAIL mailbox missing packets");
        $display("PASS 224-bit race/status atomic mailbox received=%0d",received);$finish;
    end
    initial begin #100000;$fatal(1,"FAIL mailbox timeout");end
endmodule
