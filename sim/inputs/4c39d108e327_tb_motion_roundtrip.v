`timescale 1ns/1ps
module tb_motion_roundtrip;
 parameter WIDTH=1280,HEIGHT=720,H_GAP=4,JOINT_SOF=0;
 parameter real DDR_HALF=2.5,CAM_HALF=8.0;
 localparam WORDS=WIDTH*HEIGHT*3/16;
wire busy,wr,ready,view_valid,live_valid,fault;wire[24:0]addr;wire[127:0]data;
wire[2:0]view_slot,ev,live_slot;wire[31:0]view_source,live_source;wire[6:0]pins;
 reg cam=0,ddr=0;always #(CAM_HALF) cam=~cam;always #(DDR_HALF) ddr=~ddr;
 reg reset=0,u=0,v=0,track=1,enable=1;reg[95:0]rgb=0;
 reg[31:0]source_id=0,race=1,decision_source=0;reg decision=0;reg[2:0]mask=0;
 wire read_busy;wire[6:0]protect;reg[1:0]view=0;
 reg pix=0;always #6.667 pix=~pix;
 reg replay=0;
 wire hs,vs,de,du,dl,rd;wire[23:0]display;
 wire[24:0]read_addr;wire[63:0]applied;
 reg[127:0]return_data[0:39];reg[39:0]return_valid=0;
 wire selected_valid;
 wire[2:0]selected_slot=replay?view_slot:live_slot;
 wire[31:0]selected_source=replay?view_source:live_source;
 wire[63:0]selected_metadata={selected_valid,replay,view,selected_source,27'd0,1'b0};
 integer pipe_index,read_slot,read_index,checked=0,screen_frames=0,px=0,py=0;
 reg[23:0]expected_now=0,expected_delayed=0;
 reg valid_now=0,valid_delayed=0;
 motion_video_out #(.IMAGE_WIDTH(WIDTH),.IMAGE_HEIGHT(HEIGHT))reader(
 .I_rst_n(reset),.I_pixel_rst_n(reset),.I_ddr_clk(ddr),.O_video_out_rd_busy(read_busy),.I_video_in_wr_busy(busy),
 .I_select_valid(selected_valid),.I_select_slot(selected_slot),.I_select_metadata(selected_metadata),
 .O_read_protect(protect),.O_applied_metadata(applied),.O_ddr_user_rd_en(rd),.O_ddr_user_addr(read_addr),
 .I_ddr_user_ready(ready),.I_ddr_user_rd_valid(return_valid[39]),.I_ddr_user_rd_data(return_data[39]),
 .I_dsi_clk(pix),.I_video_vsync(~vs),.I_video_rd_en(de),.O_vdieo_data(display));
 uivtc #(.H_ActiveSize(WIDTH),.H_FrameSize(1650),.H_SyncStart(1390),.H_SyncEnd(1430),
 .V_ActiveSize(HEIGHT),.V_FrameSize(750),.V_SyncStart(725),.V_SyncEnd(730))vtc(
 .I_vtc_rstn(reset),.I_vtc_clk(pix),.O_vtc_vs(vs),.O_vtc_hs(hs),.O_vtc_de_valid(de),.O_vtc_user(du),.O_vtc_last(dl));
 
 
assign selected_valid=replay?view_valid:live_valid;
 wire app_en,app_wren,app_end;wire[24:0]app_addr;wire[2:0]app_cmd;
 wire[127:0]app_data;wire[31:0]app_mask;
 reg[31:0]random=32'h712ac98d;wire ardy=random[0]|random[1]|random[2];wire wready=random[3]|random[4];
 wire accept=app_en&&app_cmd==0&&ardy&&app_wren&&wready;
 reg[127:0]memory[0:7*WORDS-1];
 integer errors=0,writes=0,k,j,slot,index,frame_id;
 reg[2:0]saved_slot[0:2];reg[31:0]saved_source[0:2];
 motion_video_store #(.IMAGE_WIDTH(WIDTH),.IMAGE_HEIGHT(HEIGHT))dut(
 .camera_clk(cam),.camera_rst_n(reset),.ddr_clk(ddr),.ddr_rst_n(reset),.user_i(u),.valid_i(v),.rgb_i(rgb),
 .source_i(source_id),.race_i(race),.geometry_i(27'd0),.track_i(track),.enable_i(enable),
 .decision_i(decision),.decision_source_i(decision_source),.decision_race_i(race),.decision_mask_i(mask),.decision_good_i(1'b1),
 .read_busy_i(read_busy),.read_protect_i(protect),.user_ready_i(ready),.controller_write_i(accept),.view_lane_i(view),
 .write_busy_o(busy),.write_o(wr),.address_o(addr),.data_o(data),.view_slot_o(view_slot),.view_source_o(view_source),
 .view_valid_o(view_valid),.evidence_valid_o(ev),.live_valid_o(live_valid),.live_slot_o(live_slot),.live_source_o(live_source),
 .pinned_o(pins),.fault_o(fault));
 mc_to_user_interface bridge(.I_clk(ddr),.I_rst_n(reset),.I_ddr_user_wr_en(wr),.I_ddr_user_rd_en(rd),
 .I_ddr_user_addr(wr?addr:read_addr),.I_ddr_user_wr_data(data),.O_ddr_user_ready(ready),.O_pending(),
 .O_ddr_user_rd_valid(),.O_ddr_user_rd_data(),.O_mc_app_en(app_en),.O_mc_app_addr(app_addr),.O_mc_app_cmd(app_cmd),
 .I_mc_app_rdy(ardy),.O_mc_app_wdf_wren(app_wren),.O_mc_app_wdf_data(app_data),.O_mc_app_wdf_end(app_end),
 .O_mc_app_wdf_mask(app_mask),.I_mc_app_wdf_rdy(wready),.I_mc_app_rd_data(return_data[39]),
 .I_mc_app_rd_data_end(1'b0),.I_mc_app_rd_data_valid(return_valid[39]));
 function[7:0]byte_value;input integer frame,position;begin byte_value=(frame*17+position*7+(position>>8))&255;end endfunction
 function[95:0]word_rgb;input integer frame,word_index;integer b;begin
 word_rgb=0;for(b=0;b<12;b=b+1)word_rgb={word_rgb[87:0],byte_value(frame,word_index*12+b)};end endfunction
 function[127:0]word_payload;input integer frame,word_index;integer b;begin
 word_payload=0;for(b=0;b<16;b=b+1)word_payload={word_payload[119:0],byte_value(frame,word_index*16+b)};end endfunction
 task check;input c;input[255:0]message;begin if(c!==1'b1)begin
 errors=errors+1;if(errors<10)$display("FAIL: %s at %0t",message,$time);end end endtask
 always @(posedge ddr)begin
 if(!reset)random<=32'h712ac98d;
 else begin
 random<={random[30:0],random[31]^random[21]^random[1]^random[0]};
 if(app_wren)check(app_en&&ardy&&wready&&app_end&&app_mask==0,"pAXI paired write acceptance");
 check(!(wr&&rd),"user read and write ownership never overlap");
 for(pipe_index=39;pipe_index>0;pipe_index=pipe_index-1)begin
 return_data[pipe_index]<=return_data[pipe_index-1];return_valid[pipe_index]<=return_valid[pipe_index-1];end
 return_valid[0]<=app_en&&app_cmd==1&&ardy;
 if(app_en&&app_cmd==1&&ardy)begin
 read_slot=app_addr/3000000;read_index=(app_addr%3000000)/8;
 check(read_slot<7&&read_index<WORDS,"read stays within frame bounds");
 check(protect[read_slot],"read slot lease remains held");
 return_data[0]<=memory[read_slot*WORDS+read_index];
 end
 if(accept)begin
 slot=app_addr/3000000;index=(app_addr%3000000)/8;
 check(slot<7&&index<WORDS&&app_addr%8==0,"write stays within slot/frame bounds");
 if(slot<7&&index<WORDS)begin
 frame_id=dut.u_slots.source[slot];
 check(app_data===word_payload(frame_id,index),"packed image and source identity match");
 check(!pins[slot]&&!protect[slot],"accepted write cannot overwrite pinned or displayed evidence");
 memory[slot*WORDS+index]=app_data;
 end
 writes=writes+1;
 end
 end
 end
 always @(posedge pix)begin
 if(!reset)begin px=0;py=0;valid_now<=0;valid_delayed<=0;end
 else begin
 valid_delayed<=valid_now;expected_delayed<=expected_now;valid_now<=0;
 if(du)begin px=0;py=0;screen_frames=screen_frames+1;end
 if(de)begin
 valid_now<=applied[63];
 expected_now<={byte_value(applied[59:28],(py*WIDTH+px)*3),
 byte_value(applied[59:28],(py*WIDTH+px)*3+1),byte_value(applied[59:28],(py*WIDTH+px)*3+2)};
 if(dl)begin px=0;py=py+1;end else px=px+1;
 end
 end
 end
 always @(negedge pix)if(reset&&valid_delayed)begin
 checked=checked+1;check(display===expected_delayed,"displayed RGB pixel equals applied source frame");end
 task display_page;input[1:0]lane;input[31:0]id;integer before_frame;begin
 @(negedge ddr);replay=1;view=lane;
 wait(applied[62]&&applied[61:60]==lane&&applied[59:28]==id);
 before_frame=screen_frames;wait(screen_frames>=before_frame+2);
 end endtask
 task send_frame;input integer id;input[2:0]arrivals;integer row,col;begin
 @(negedge cam);u=1;v=JOINT_SOF;source_id=id;rgb=word_rgb(id,0);@(negedge cam);u=0;
 for(row=0;row<HEIGHT;row=row+1)begin
 for(col=0;col<WIDTH/4;col=col+1)begin
 if(!(JOINT_SOF && row==0 && col==0))begin v=1;rgb=word_rgb(id,row*(WIDTH/4)+col);@(negedge cam);end end
 v=0;repeat(H_GAP)@(negedge cam);
 end
 v=0;repeat(20)@(negedge cam);decision_source=id;mask=arrivals;decision=1;
 @(negedge cam);decision=0;repeat(10)@(negedge cam);
 end endtask
 initial begin
 repeat(10)@(negedge cam);reset=1;repeat(100)@(negedge cam);
 for(k=1;k<=12;k=k+1)begin
 send_frame(k,k==1?1:(k==3?2:(k==5?4:0)));
 end
 // The next source SOF validates the exact previous frame length.
 @(negedge cam);u=1;source_id=13;@(negedge cam);u=0;
 repeat(3000)@(negedge ddr);
 check(writes==12*WORDS,"all complete frame words reached controller");
 check(ev==7&&live_valid&&!fault,"three evidence frames and live path valid");
 for(k=0;k<3;k=k+1)begin
 view=k;#2;check(view_valid&&view_source==1+2*k,"per-lane frame index exact");
 saved_slot[k]=view_slot;saved_source[k]=view_source;
 for(j=0;j<WORDS;j=j+1)check(memory[view_slot*WORDS+j]===word_payload(1+2*k,j),"saved full-frame data remains intact");
 end
 check(saved_slot[0]!=saved_slot[1]&&saved_slot[1]!=saved_slot[2]&&saved_slot[0]!=saved_slot[2],"three distinct pins");
 // Read back all evidence pages, retaining camera storage ownership.
 display_page(0,1);display_page(1,3);display_page(2,5);display_page(0,1);
 check(checked>3*WIDTH*HEIGHT,"full-resolution replay pixel checks executed");
 // Mode exit clears evidence without disabling continuous camera acquisition.
 @(negedge cam);enable=0;track=0;race=2;repeat(100)@(negedge cam);
 for(k=14;k<=17;k=k+1)send_frame(k,0);
 @(negedge cam);u=1;source_id=18;@(negedge cam);u=0;repeat(3000)@(negedge ddr);
 replay=0;repeat(2700000)@(negedge ddr);
 check(ev==0&&live_valid&&live_source>=14,"original view continues after evidence clear");
 if(errors==0)$display("PASS: DDR roundtrip %0dx%0d, %0d accepted writes, replay paging and per-pixel source matching",WIDTH,HEIGHT,writes);
 else $display("FAIL: roundtrip errors=%0d writes=%0d fault=%b",errors,writes,fault);
 $finish;
 end
 initial begin #2000000000;$display("FAIL: store timeout");$finish;end
endmodule
