`timescale 1ns/1ps
module tb_can_probe_osd;
    reg clk=0,rst=0,de=0,vs=1,probe_valid=1;
    always #5 clk=~clk;
    reg [127:0] probe=128'h0080042a0c0c01460419010100b801d1;
    wire hit;wire [23:0] color;
    integer xpos,ypos,checks=0;
    motion_trial_osd #(.HORIZONTAL_ENABLE(1),.CAN_PROBE_ENABLE(1)) dut(
        .clk(clk),.rst_n(rst),.de_i(de),.vs_i(vs),.enable_i(1'b1),.edit_i(2'd0),
        .base_x_i(11'd160),.base_y_i(10'd512),.line_i(6'd40),.status_i(192'd0),.motor_i(8'h61),
        .probe_valid_i(probe_valid),.probe_i(probe),.hit_o(hit),.color_o(color));
    task check_character;
        input integer xvalue,yvalue;
        input [7:0] expected;
        begin
            @(negedge clk);force dut.x=xvalue;force dut.y=yvalue;#1;
            if(dut.character!==expected || !dut.text_region)$fatal(1,"FAIL probe glyph x=%d y=%d got=%h expected=%h",xvalue,yvalue,dut.character,expected);
            checks=checks+1;
        end
    endtask
    initial begin
        repeat(4)@(negedge clk);rst=1;vs=0;de=1;
        repeat(3)@(negedge clk);
        check_character(832,64,"C");check_character(864,64,"0");
        check_character(832+5*32,64,"8");check_character(832+10*32,64,"A");
        check_character(864,96,"1");check_character(832+10*32,96,"6");
        check_character(864,128,"2");check_character(832+10*32,128,"1");
        check_character(864,160,"3");check_character(832+7*32,160,"0");check_character(832+9*32,160,"D");
        probe=0;#1;
        if(dut.probe_snapshot!==128'h0080042a0c0c01460419010100b801d1)$fatal(1,"FAIL mid-frame probe changed");
        release dut.x;release dut.y;
        @(negedge clk);vs=1;de=0;
        @(negedge clk);vs=0;de=1;
        repeat(2)@(negedge clk);
        if(dut.probe_snapshot!==0)$fatal(1,"FAIL next-frame probe not captured");
        $display("PASS four probe rows, hex glyph positions, frame-atomic snapshot checks=%d",checks);$finish;
    end
    initial begin #100000;$fatal(1,"FAIL probe OSD watchdog");end
endmodule
