`timescale 1ns/1ps
// Independent scalar reference checks exact comparisons and random RGB samples.
module tb_color_red_volatile;
    reg clk=0,rst_n=0,valid=0;
    always #5 clk=~clk;
    reg [23:0] rgb=0;
    reg [239:0] params={16'd32,16'd18,16'd44,16'd40,16'd40,16'd20,
        16'd40,16'd48,16'd12,16'd48,16'd36,16'd12,16'd48,16'd48,16'd24};
    wire [3:0] hits;
    integer r,g,b,mx,mn,count,seed,random_rgb;
    reg red,green,blue;
    color_detect_box #(.IMG_W(16),.IMG_H(4),.RUNTIME_PARAM_EN(1),.EXTENDED_BLUE(0)) detector(
        .clk(clk),.rst_n(rst_n),.valid_i(valid),.user_i(1'b0),.last_i(1'b0),
        .rgb_i(rgb),.I_param_bus(params),.I_param_version(32'd0),.blue_allow_i(1'b1),.O_pixel_hit(hits));
    task check_pixel;
        input [23:0] sample;
        begin
            @(negedge clk);rgb=sample;valid=1;#1;
            r=sample[23:16];g=sample[15:8];b=sample[7:0];
            mx=r>g?r:g;if(b>mx)mx=b;mn=r<g?r:g;if(b<mn)mn=b;
            red=mx>=44&&mx-mn>=18&&r*32>g*params[31:16]&&r*32>b*params[47:32]&&r-g>=params[15:0]&&r-b>=params[15:0];
            green=mx>=44&&mx-mn>=18&&g*32>r*36&&g*32>b*48&&g-r>=12&&g-b>=12;
            blue=mx>=44&&mx-mn>=18&&b*32>r*48&&b*32>g*40&&b-r>=12&&b-g>=12;
            if(hits!=={1'b0,blue,green,red})$fatal(1,"FAIL RGB=%h expected=%b got=%b",sample,{1'b0,blue,green,red},hits);
        end
    endtask
    initial begin
        repeat(3)@(negedge clk);rst_n=1;
        check_pixel({8'd72,8'd48,8'd48});if(hits[0])$fatal(1,"FAIL ratio equality accepted");
        check_pixel({8'd73,8'd48,8'd48});if(!hits[0])$fatal(1,"FAIL new red default not effective");
        check_pixel({8'd63,8'd40,8'd40});if(hits[0])$fatal(1,"FAIL diff below 24 accepted");
        check_pixel({8'd64,8'd40,8'd40});if(!hits[0])$fatal(1,"FAIL diff equality 24 rejected");
        check_pixel({8'd64,8'd40,8'd50});
        seed=14351;
        for(count=0;count<20000;count=count+1)begin random_rgb=$random(seed);check_pixel(random_rgb[23:0]);end
        params[15:0]=48;params[31:16]=64;params[47:32]=64;
        check_pixel({8'd73,8'd48,8'd48});if(hits[0])$fatal(1,"FAIL runtime edit ignored");
        for(count=0;count<2000;count=count+1)begin random_rgb=$random(seed);check_pixel(random_rgb[23:0]);end
        @(negedge clk);valid=0;#1;if(hits!==0)$fatal(1,"FAIL blanking hits");
        $display("PASS red 24/1.5/1.5 exact boundaries, 22000 random RGB checks, green/blue unchanged, runtime edits");
        $finish;
    end
endmodule
