`timescale 1ns/1ps
module tb_edge_fill_real_vtc;
reg clk=0,rst=0;always #6.666 clk=~clk;
reg[3:0]keys=15;
reg sw=0;wire sw_stable;wire save_req;wire[31:0]edit_revision;
color_switch_ctrl #(.STABLE_CYCLES(80)) switch_ctrl(clk,rst,sw,sw_stable);
wire k1s,k1l,k2s,k2l,km,kp,restore,selected;
wire[239:0]edit_bus,eff;wire[31:0]ver;wire committed;
wire[1:0]mode,cursor;wire[2:0]page;wire editing,panel,preview,status_show;
wire[2:0]save_state;
color_key_ctrl #(.MS_CYC(4)) key_ctrl(
 .clk(clk),.rst_n(rst),.I_restore_arm(selected),.I_key_n(keys),
 .O_k1_short(k1s),.O_k1_long(k1l),.O_k2_short(k2s),.O_k2_long(k2l),
 .O_k3_step(km),.O_k4_step(kp),.O_k4_long15(restore),.O_pressed());
color_ui_fsm #(.MS_CYC(4)) ui(
 .clk(clk),.rst_n(rst),.I_preview_select(sw_stable),.I_k1_short(k1s),.I_k1_long(k1l),.I_k2_short(k2s),.I_k2_long(k2l),
 .I_k3_step(km),.I_k4_step(kp),.I_k4_long15(restore),
 .I_eff(eff),
 
 
 .O_edit_bus(edit_bus),.O_commit_req(),.O_mode(mode),.O_edit(editing),.O_panel(panel),
 .O_page(page),.O_cursor(cursor),.O_edge_toggle(),.O_status_show(status_show),
 .O_restore_sel(selected),.O_preview(preview));
wire vs,hs,de,usr,last;
uivtc #(.H_ActiveSize(1280),.H_FrameSize(1650),.H_SyncStart(1390),.H_SyncEnd(1430),
 .V_ActiveSize(720),.V_FrameSize(750),.V_SyncStart(725),.V_SyncEnd(730)) real_timing(
 .I_vtc_rstn(rst),.I_vtc_clk(clk),.O_vtc_vs(vs),.O_vtc_hs(hs),.O_vtc_de_valid(de),.O_vtc_user(usr),.O_vtc_last(last));
wire cvs,chs,cde,cusr,clast;wire[23:0]crgb;
color_chroma_denoise clean(.clk(clk),.rst_n(rst),.vs_i(vs),.hs_i(hs),.de_i(de),.user_i(usr),.last_i(last),.rgb_i(24'hc02020),
 .vs_o(cvs),.hs_o(chs),.de_o(cde),.user_o(cusr),.last_o(clast),.rgb_o(crgb));
wire[9:0]view_frame;wire ov,od;wire[23:0]pixel;
hdmi_mixer #(.H_OFFSET(0),.V_OFFSET(0),.IMG_WIDTH(1280),.IMG_HEIGHT(720),
 .AE_DEBUG_ENABLE(1),.BLUE_BACKGROUND_ENABLE(0),.EDGE_DENOISE_ENABLE(1),.EDGE_COHERENCE_ENABLE(1),.EDGE_OPT_ENABLE(1),.EDGE_FILL_ENABLE(1),.EDGE_FILL_ROW_STEP(2),.EDGE_FILL_MIN_BG_RUN(8),
 .BG_NOISE_CAL_ENABLE(0),.EDGE_COMPARE_ENABLE(1),.DET_EXTENDED_BLUE(1),.DET_B_G_RATIO_Q2(5),
 .DET_MIN_DIFF_B(12),.DEBUG_MODE(0),.VIDEO_SRC(1),.UI_ENABLE(1)) mixer(
 .I_clk(clk),.I_rst_n(rst),.I_video_vsync(cvs),.I_video_hsync(chs),.I_video_de(cde),
 .I_video_user(cusr),.I_video_last(clast),.I_video_rd_data(crgb),
 .I_ae_status({4'd3,8'd72,16'd500,16'd0,16'd0}),.I_debug_status(4'd0),
 .I_key_src_trig(1'b0),.I_key_det_trig(1'b0),.I_bg_calibrate(1'b0),
 .I_ui_mode(mode),.I_ui_view({panel,editing,page,cursor,preview}),.O_ui_view(view_frame),
 .I_ui_edge_toggle(1'b0),.I_ui_edit_bus(edit_bus),.I_ui_commit_req(edit_bus!=eff),
 .O_param_eff(eff),.O_param_version(ver),.O_param_committed(committed),
 .O_hdmi_vsync(ov),.O_hdmi_hsync(),.O_hdmi_de(od),.O_hdmi_data(pixel));
wire show=(view_frame[9:8]==3)&&view_frame[7]&&view_frame[6];
wire stat=(view_frame[9:8]==3)&&status_show;
wire old_hit,new_hit;wire[23:0]old_rgb,new_rgb;
color_menu_osd candidate_menu(clk,rst,od,ov,show,stat,view_frame[5:3],view_frame[2:1],
 eff,save_state,edit_bus!=eff,1'b0,new_hit,new_rgb);

integer total=0,old_pixels=0,new_pixels=0,yellow_pixels=0,nonzero_old_xy=0,x,y,frames=0;
reg measuring=0,expected_panel;
reg[9:0]expected_view;
reg[23:0]expected_background;
integer inspected=0;
always @(posedge clk)begin
 if(measuring&&od)begin
  x=total%1280;y=total/1280;
  if(ov!==0)$fatal(1,"FAIL actual VTC VS not low in active image");
  if(view_frame!==expected_view)$fatal(1,"FAIL view changed within frame");
  if(candidate_menu.snap_page_i!==expected_view[5:3]||candidate_menu.snap_cursor_i!==expected_view[2:1])
   $fatal(1,"FAIL menu and preview snapshots disagree");
  if(x==500&&y==300)begin
   if(pixel!==expected_background)$fatal(1,"FAIL preview background actual=%h expected=%h",pixel,expected_background);
   inspected=inspected+1;
  end
  if(new_hit)begin
   new_pixels=new_pixels+1;
   if(new_rgb==24'hffd000)yellow_pixels=yellow_pixels+1;
   if(x<992||x>=1280||y<256||y>=(expected_panel?480:272))
    $fatal(1,"FAIL candidate geometry x=%0d y=%0d",x,y);
  end
  total=total+1;
 end
end
task press;input integer key_index,cycles;begin
 @(negedge clk);keys[key_index]=0;repeat(cycles)@(negedge clk);
 keys[key_index]=1;repeat(120)@(negedge clk);
end endtask
task check_frame;input[255:0]label;input want_panel;begin
 @(negedge ov);#1;
 total=0;old_pixels=0;new_pixels=0;yellow_pixels=0;nonzero_old_xy=0;
 expected_panel=want_panel;expected_view={mode,panel,editing,page,cursor,preview};
 if(view_frame!==expected_view)$fatal(1,"FAIL frame did not accept requested view");
 expected_background=preview?(page==0||page==4?24'hffffff:24'h000000):24'hc02020;
 inspected=0;measuring=1;
 @(posedge ov);#1;measuring=0;
 if(total!=921600||old_pixels!=0||nonzero_old_xy!=0)
  $fatal(1,"FAIL reproduce total=%0d old=%0d xy_nonzero=%0d",total,old_pixels,nonzero_old_xy);
 if(new_pixels!=(want_panel?64512:4608)||(want_panel&&yellow_pixels==0))
  $fatal(1,"FAIL candidate pixels=%0d yellow=%0d",new_pixels,yellow_pixels);
 if(candidate_menu.snap_page_i!=expected_view[5:3]||candidate_menu.snap_cursor_i!=expected_view[2:1]||inspected!=1)
  $fatal(1,"FAIL candidate stale page/cursor");
 frames=frames+1;
 $display("EVIDENCE %0s edit=%0d panel=%0d preview=%0d page=%0d active=%0d original_hits=%0d original_xy_nonzero=%0d candidate_hits=%0d yellow=%0d",
  label,editing,panel,preview,page,total,old_pixels,nonzero_old_xy,new_pixels,yellow_pixels);
end endtask
initial begin
 repeat(8)@(negedge clk);rst=1;repeat(20)@(negedge clk);
 repeat(3)press(0,160);
 if(mode!=3)$fatal(1,"FAIL enter COLOR");
 press(0,4000);
 if(!editing||!panel||preview)$fatal(1,"FAIL actual key editor entry");
 check_frame("entered_RGB",1);
 @(negedge clk);sw=1;repeat(100)@(negedge clk);
 if(!preview)$fatal(1,"FAIL SW1 preview");
 repeat(3)press(1,160);
 if(page!=1||cursor!=0)$fatal(1,"FAIL auto page");
 // During this frame navigate back to RED and switch down. Both image and menu
 // must retain the complete old GREEN/HIT view until the following frame.
 fork
  check_frame("preview_GREEN_midframe_change",1);
  begin
   wait(measuring);wait(total>100000);
   @(negedge clk);sw=0;press(0,160);
   if(page!=0||cursor!=2||preview)$fatal(1,"FAIL midframe previous/switch request");
  end
 join
 check_frame("previous_RED_RGB_next_frame",1);
 // Reverse across the first item to GLOBAL/DEFAULT while selecting HIT.
 repeat(3)press(0,160);sw=1;repeat(100)@(negedge clk);
 if(page!=4||cursor!=3||!preview)$fatal(1,"FAIL reverse across RED to GLOBAL");
 check_frame("previous_GLOBAL_HIT",1);
 press(0,4000);if(panel)$fatal(1,"FAIL hide");
 check_frame("hidden",0);
 press(0,4000);if(!panel)$fatal(1,"FAIL show");
 check_frame("shown_again",1);
 if(edit_revision!=0||save_req)$fatal(1,"FAIL switch/navigation caused parameter revision or save");
 $display("PASS: %0d full real-uivtc/chroma/mixer frames, exact 288x224 panel, bidirectional physical keys, SW1 RGB/HIT, midframe atomic preview/menu update, hidden/show, zero parameter revision/write",frames);
 $finish;
end
initial begin #240000000;$fatal(1,"FAIL watchdog");end
endmodule