`timescale 1ns/1ns
// Exact 720p oracle for both displayed modes and the unchanged extraction stream.
module tb_edge_fill_compare;
    localparam W=1280,H=720,HT=1650,FRAMES=6,N=W*H;
    reg clk=0,rst_n=0,de=0,user=0,last=0,k1=0,k2=0,hs=0,vs=0;
    reg [23:0] rgb=0;
    reg [7:0] samples[0:N-1];
    reg detection[0:N-1],extraction[0:N-1];
    wire ev,eu,el,eb,hd,pv;
    wire [11:0] ex,ey,px,py;
    wire [23:0] hp;
    wire hh,hv;
    integer x,y,f,idx,count=0,compared=0,label_pixels=0,mode_changes=0;
    integer previous_index=0,output_frame,output_x,output_y;
    reg prior_valid=0,prior_edge=0;
    reg prior_hs=0,prior_vs=0;
    integer expected_mode;
    reg [23:0] filled[0:N-1];
    reg [23:0] expected_pixel;
    reg [7:0] letter;
    reg [3:0] glyph_y;
    wire [15:0] glyph;
    osd_char_lib reference_font(.I_char(letter),.I_row(glyph_y),.O_row_bits(glyph));
    always #5 clk=~clk;
    hdmi_mixer #(.IMG_WIDTH(W),.IMG_HEIGHT(H),.H_TOTAL(HT),.EDGE_DENOISE_ENABLE(1),
        .EDGE_COHERENCE_ENABLE(1),.EDGE_OPT_ENABLE(1),.EDGE_FILL_ENABLE(1),.EDGE_COMPARE_ENABLE(1),.BLUE_BACKGROUND_ENABLE(0),
        .DET_EXTENDED_BLUE(1),.DET_B_G_RATIO_Q2(5),.DET_MIN_DIFF_B(12)) dut (
        .I_clk(clk),.I_rst_n(rst_n),.I_video_vsync(vs),.I_video_hsync(hs),
        .I_video_de(de),.I_video_user(user),.I_video_last(last),.I_video_rd_data(rgb),
        .I_debug_status(4'd0),.I_key_src_trig(k1),.I_key_det_trig(k2),.I_bg_calibrate(1'b0),
        .O_hdmi_data(hp),.O_hdmi_de(hd),.O_hdmi_hsync(hh),.O_hdmi_vsync(hv),
        .O_edge_valid(ev),.O_edge_user(eu),.O_edge_last(el),.O_edge_bit(eb),.O_edge_x(ex),.O_edge_y(ey),
        .O_edge_point_valid(pv),.O_edge_point_x(px),.O_edge_point_y(py));
    always @(posedge clk)begin
        #1;
        if(rst_n)begin
            if(hd!==prior_valid || hh!==prior_hs || hv!==prior_vs)$fatal(1,"FAIL: HDMI control phase");
            if(pv!==(prior_valid && prior_edge))$fatal(1,"FAIL: point stream changed by mode");
            if(hd)begin
                output_frame=previous_index/N;output_x=previous_index%W;output_y=(previous_index/W)%H;
                expected_mode=output_frame%3;
                if(pv && (px!==output_x || py!==output_y))$fatal(1,"FAIL: point coordinate");
                // Compare every non-OSD pixel, including all four black borders.
                if(!(output_x<160 && output_y<160) &&
                   !(output_x>=375 && output_x<575 && output_y>=120 && output_y<144) &&
                   !(output_x>=992 && output_y<240) && output_y<608 &&
                   !(output_x>=176 && output_x<288 && output_y>=72 && output_y<88))begin
                    expected_pixel=expected_mode==2 ? filled[previous_index%N] : ((expected_mode==1 ? extraction[previous_index%N] : detection[previous_index%N]) ? 24'hffffff : 0);
                    if(expected_mode==2) begin
                        if(hp!==24'h000000 && hp!==24'hffffff && hp!==24'hff3030 && hp!==24'h3080ff && hp!==24'h20c080)
                            $fatal(1,"FAIL: HDMI f=%0d xy=%0d,%0d got=%h outside FILL palette",output_frame,output_x,output_y,hp);
                    end else if(hp!==expected_pixel)$fatal(1,"FAIL: HDMI f=%0d xy=%0d,%0d got=%h want=%h",output_frame,output_x,output_y,hp,expected_pixel);
                    compared=compared+1;
                end
                if(output_x>=176 && output_x<288 && output_y>=72 && output_y<88)begin
                    letter=" ";glyph_y=output_y-72;
                    if(expected_mode==2)begin
                        case((output_x-176)/16)
                            0:letter="F";1:letter="I";2:letter="L";3:letter="L";default:letter=" ";
                        endcase
                    end else begin
                        case((output_x-176)/16)
                            0:letter=expected_mode==1 ? "E":"D";
                            1:letter=expected_mode==1 ? "X":"E";
                            2:letter="T";3:letter=expected_mode==1 ? "R":"E";
                            4:letter=expected_mode==1 ? "A":"C";
                            5:letter=expected_mode==1 ? "C":"T";
                            6:letter=expected_mode==1 ? "T":" ";
                        endcase
                    end
                    #1;
                    expected_pixel=glyph[15-((output_x-176)%16)] ? (expected_mode==2 ? 24'h20c080 : (expected_mode==1 ? 24'h00e6ff:24'hfff200)) :
                        (expected_mode==2 ? filled[previous_index%N] : ((expected_mode==1 ? extraction[previous_index%N]:detection[previous_index%N]) ? 24'hffffff:0));
                    if(expected_mode==2 && !glyph[15-((output_x-176)%16)] && expected_pixel==24'h20c080) begin
                        if(hp!==24'hff3030 && hp!==24'h3080ff && hp!==24'h20c080)
                            $fatal(1,"FAIL: mode label fill color");
                    end else if(hp!==expected_pixel)$fatal(1,"FAIL: mode label");
                    label_pixels=label_pixels+1;
                end
            end
            if(ev)begin
                if(count>=FRAMES*N)$fatal(1,"FAIL: excess active pixels");
                if(ex!==count%W || ey!==(count/W)%H || eu!==(count%N==0) || el!==(count%W==W-1))$fatal(1,"FAIL: raster coordinates");
                if(eb!==extraction[count%N])$fatal(1,"FAIL: extraction changed at %0d",count);
                if(dut.refined_valid && dut.detected_bit!==detection[count%N])$fatal(1,"FAIL: aligned detection at %0d",count);
                if(dut.delayed_raster[31]!==((count/N)%3!=0) || dut.delayed_raster[32]!==((count/N)%3==2))$fatal(1,"FAIL: torn mode in output frame");
                if(eu)mode_changes=mode_changes+1;
                previous_index=count;count=count+1;
            end
            prior_valid=ev;prior_edge=eb;prior_hs=dut.delayed_raster[27];prior_vs=dut.delayed_raster[28];
        end else begin prior_valid=0;prior_edge=0;prior_hs=0;prior_vs=0;end
    end
    initial begin
        $readmemh("sim/inputs/f77e4622d9c3_gray.hex",samples);
        $readmemh("sim/inputs/4043e9b5a8d0_detect.hex",detection);
        $readmemh("sim/inputs/016e5427329c_extract.hex",extraction);
        $readmemh("sim/inputs/510d63dbc5cc_fill.hex",filled);
        repeat(5)@(negedge clk);rst_n=1;
        @(negedge clk);k2=1;@(negedge clk);k2=0;
        for(f=0;f<FRAMES;f=f+1)begin
            for(y=0;y<H+8;y=y+1)for(x=0;x<HT;x=x+1)begin
                @(negedge clk);de=x<W&&y<H;user=de&&x==0&&y==0;last=de&&x==W-1;
                k2=x==500&&y==100;k1=0;hs=x>=W+10;vs=y>=H+2;
                idx=y*W+x;rgb=de ? {samples[idx],samples[idx],samples[idx]}:0;
            end
        end
        @(negedge clk);de=0;user=0;last=0;k2=0;
        repeat(3*HT+40)@(negedge clk);
        if(count!=FRAMES*N || compared<2700000 || label_pixels!=FRAMES*112*16 || mode_changes!=FRAMES)$fatal(1,"FAIL: incomplete comparison");
        @(negedge clk);rst_n=0;#1;
        if(hd||ev||pv||dut.S_extract_run||dut.S_extract_eff||dut.S_fill_run||dut.S_fill_eff)$fatal(1,"FAIL: reset");
        $display("PASS: six 720p DETECT/EXTRACT/FILL frames %0d dense pixels, %0d displayed pixels, %0d exact label pixels; frame-boundary K2, detection/extraction alignment, point events, sync and reset",count,compared,label_pixels);$finish;
    end
    initial begin #150000000;$fatal(1,"FAIL: timeout");end
endmodule
