`timescale 1ns/1ps
module tb_motor_status_osd;
    reg clock=0;
    always #5 clock=~clock;
    reg reset_n=0,de=0,vs=1;
    reg [7:0] motor=8'h30;
    wire hit;
    wire [23:0] color;
    integer row,column,pixels=0;
    motion_trial_osd #(.HORIZONTAL_ENABLE(1)) dut(
        .clk(clock),.rst_n(reset_n),.de_i(de),.vs_i(vs),.enable_i(1'b1),.edit_i(2'd0),
        .base_x_i(11'd160),.base_y_i(10'd512),.line_i(6'd40),.status_i(192'd0),
        .motor_i(motor),.hit_o(hit),.color_o(color));
    initial begin
        repeat(4)@(negedge clock);reset_n=1;
        repeat(4)@(negedge clock);vs=0;
        for(row=0;row<720;row=row+1)begin
            for(column=0;column<1280;column=column+1)begin
                de=1;@(negedge clock);
                if(row==200 && column==0)motor=8'h64;
                if(dut.motor_snapshot!==8'h30)$fatal(1,"FAIL motor status changed within frame");
                if(dut.x>=832 && dut.x<1216 && dut.y>=32 && dut.y<64 && hit)begin
                    pixels=pixels+1;
                    if(color!==24'h40ff70)$fatal(1,"FAIL ready status color");
                end
            end
            de=0;repeat(12)@(negedge clock);
        end
        vs=1;repeat(4)@(negedge clock);vs=0;de=1;@(negedge clock);de=0;
        if(dut.motor_snapshot!==8'h64 || pixels<100)$fatal(1,"FAIL motor status frame latch or glyph pixels=%0d",pixels);
        $display("PASS motor status OSD pixels=%0d frame stable",pixels);$finish;
    end
endmodule
