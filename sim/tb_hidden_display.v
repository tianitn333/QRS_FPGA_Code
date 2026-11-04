`timescale 1ns/1ps
// Display contract: suppress only the probe window while retained registers
// continue capturing. Actual physical edit is separately verified against DB.
module tb_hidden_display;
    reg clk=0, rst_n=0, de=0, vs=1;
    reg [127:0] probe=128'h0080042a0c0c01460411010100b801d1;
    wire [2:0] hits;
    wire [23:0] visible_color,hidden_color,reference_color;
    integer x,y,frame,visible_pixels=0,green_pixels=0,compared=0;
    motion_trial_osd #(.HORIZONTAL_ENABLE(1),.CAN_PROBE_ENABLE(1)) visible(
        .clk(clk),.rst_n(rst_n),.de_i(de),.vs_i(vs),.enable_i(1'b1),.edit_i(2'd0),
        .base_x_i(11'd160),.base_y_i(10'd512),.line_i(6'd40),.status_i(192'd0),.motor_i(8'h30),
        .probe_valid_i(1'b1),.probe_i(probe),.hit_o(hits[0]),.color_o(visible_color));
    motion_trial_osd #(.HORIZONTAL_ENABLE(1),.CAN_PROBE_ENABLE(1)) hidden(
        .clk(clk),.rst_n(rst_n),.de_i(de),.vs_i(vs),.enable_i(1'b1),.edit_i(2'd0),
        .base_x_i(11'd160),.base_y_i(10'd512),.line_i(6'd40),.status_i(192'd0),.motor_i(8'h30),
        .probe_valid_i(1'b1),.probe_i(probe),.hit_o(hits[1]),.color_o(hidden_color));
    motion_trial_osd #(.HORIZONTAL_ENABLE(1),.CAN_PROBE_ENABLE(0)) reference_osd(
        .clk(clk),.rst_n(rst_n),.de_i(de),.vs_i(vs),.enable_i(1'b1),.edit_i(2'd0),
        .base_x_i(11'd160),.base_y_i(10'd512),.line_i(6'd40),.status_i(192'd0),.motor_i(8'h30),
        .probe_valid_i(1'b1),.probe_i(probe),.hit_o(hits[2]),.color_o(reference_color));
    always #5 clk=~clk;
    initial begin
        force hidden.probe_valid=1'b0;
        repeat(4) @(negedge clk);
        rst_n=1;vs=0;de=1;
        for(frame=0;frame<2;frame=frame+1) begin
            for(y=0;y<720;y=y+1) begin
                for(x=0;x<1280;x=x+1) begin
                    #1;
                    compared=compared+1;
                    if(hits[1]!==hits[2] || (hits[1] && hidden_color!==reference_color))
                        $fatal(1,"FAIL hidden display differs from no-probe OSD at %0d,%0d",x,y);
                    if(!(hidden.x>=832 && hidden.x<1216 && hidden.y>=64 && hidden.y<192)) begin
                        if(hits[0]!==hits[1] || (hits[1] && visible_color!==hidden_color))
                            $fatal(1,"FAIL non-probe pixels changed");
                    end
                    if(hits[0] && visible_color==24'hffb040)visible_pixels=visible_pixels+1;
                    if(hits[1] && hidden_color==24'hffb040)$fatal(1,"FAIL yellow probe remains");
                    if(hits[1] && hidden_color==24'h40ff70)green_pixels=green_pixels+1;
                    @(negedge clk);
                end
            end
            if(hidden.probe_snapshot!==probe)$fatal(1,"FAIL retained probe capture stopped");
            probe=128'h123456789abcdef00123456789abcdef;
        end
        if(visible_pixels==0 || green_pixels==0)$fatal(1,"FAIL probe/CAN coverage missing");
        $display("PASS %0d pixels; yellow removed, CAN green retained; probe registers still capture",compared);
        $finish;
    end
endmodule
