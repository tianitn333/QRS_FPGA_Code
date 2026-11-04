`timescale 1ns/1ps
module tb_logo_mixer_phase;
    reg clk=0,rst_n=0;
    always #6.666 clk=~clk;
    reg vs=0,hs=0,de=0,user=0,last=0;
    reg [23:0] rgb=0;
    reg [1:0] mode=0;
    wire [24:0] expected_logo;
    wire od;wire [23:0] pixel;
    integer x,y,frame_index,checked=0,visible=0,active=0;
    hdmi_mixer #(.H_OFFSET(0),.V_OFFSET(0),.IMG_WIDTH(1280),.IMG_HEIGHT(720),
        .AE_DEBUG_ENABLE(1),.DDR_DIAG_ENABLE(1),.UI_ENABLE(1),.VIDEO_SRC(1),
        .EDGE_DENOISE_ENABLE(0),.BLUE_BACKGROUND_ENABLE(0),.DET_EXTENDED_BLUE(0)) dut (
        .I_clk(clk),.I_rst_n(rst_n),.I_video_vsync(vs),.I_video_hsync(hs),.I_video_de(de),
        .I_video_user(user),.I_video_last(last),.I_video_rd_data(rgb),
        .I_ae_status(60'h004000000000000),.I_ddr_status(16'hffff),.I_debug_status(4'd0),
        .I_key_src_trig(1'b0),.I_bg_calibrate(1'b0),.I_key_det_trig(1'b0),
        .I_fill_k1_short(1'b0),.I_fill_k1_long(1'b0),.I_fill_k3_step(1'b0),.I_fill_k4_step(1'b0),
        .I_ui_mode(mode),.I_ui_view(8'd0),.I_ui_edge_toggle(1'b0),.I_ui_edit_bus(240'd0),.I_ui_commit_req(1'b0),
        .O_hdmi_de(od),.O_hdmi_data(pixel));
    anlogic_logo_rom frozen(.I_addr(dut.S_logo_addr),.O_pixel(expected_logo));
    always @(posedge clk)begin
        #2;
        if(rst_n)begin
            if(dut.S_logo_pixel!==expected_logo)
                $fatal(1,"FAIL Logo phase x=%d y=%d de=%b actual=%h expected=%h",dut.S_x_2d,dut.S_y_2d,dut.S_video_de_2d,dut.S_logo_pixel,expected_logo);
            checked=checked+1;
            if(dut.S_video_de_2d&&expected_logo[24])begin
                visible=visible+1;
                if(!dut.S_osd_hit||dut.S_osd_color!==expected_logo[23:0])
                    $fatal(1,"FAIL Logo overlay priority/RGB");
            end
            if(od)begin
                active=active+1;
                if((^pixel)===1'bx)$fatal(1,"FAIL unknown active RGB");
            end
        end else if(dut.S_logo_pixel!==0)begin
            $fatal(1,"FAIL reset output mask");
        end
    end
    initial begin
        repeat(20)@(negedge clk);rst_n=1;
        for(frame_index=0;frame_index<4;frame_index=frame_index+1)begin
            mode=frame_index;vs=1;de=0;user=0;last=0;
            repeat(20)@(negedge clk);vs=0;
            repeat(20)@(negedge clk);
            for(y=0;y<720;y=y+1)begin
                for(x=0;x<1280;x=x+1)begin
                    @(negedge clk);de=1;user=(x==0&&y==0);last=(x==1279);rgb={x[7:0],y[7:0],x[7:0]^y[7:0]};
                end
                @(negedge clk);de=0;user=0;last=0;rgb=0;
                repeat(369)@(negedge clk);
            end
            repeat(1650*30)@(negedge clk);
        end
        // Reset while a visible Logo address is pending, then recover to a new frame.
        rst_n=0;#1;repeat(3)@(negedge clk);rst_n=1;
        repeat(20)@(negedge clk);
        if(visible!=4*6387)$fatal(1,"FAIL visible Logo count %d",visible);
        if(active!=4*1280*720)$fatal(1,"FAIL active pixel count %d",active);
        $display("PASS:4 full720p modes,all original Logo pixels/transparent/boundary/priority match,registered prefetch phase/reset,checks=%d",checked);
        $finish;
    end
endmodule
