`timescale 1ns/1ps
module tb_edge_fill_keys;
reg clk=0,rst=0;always #6.666 clk=~clk;
reg[3:0]keys=15;
reg sw=0;wire sw_stable;wire save_req;wire[31:0]edit_revision;
color_switch_ctrl #(.STABLE_CYCLES(80)) switch_ctrl(clk,rst,sw,sw_stable);
wire toggle;wire k1s,k1l,k2s,k2l,km,kp,restore,selected;
wire fill_edit; wire k1s_color=k1s&&!fill_edit; wire k2s_color=k2s&&!fill_edit;
wire[239:0]edit_bus,eff;wire[31:0]ver;wire committed;
wire[1:0]mode,cursor;wire[2:0]page;wire editing,panel,preview,status_show;
wire[2:0]save_state;
color_key_ctrl #(.MS_CYC(4)) key_ctrl(
 .clk(clk),.rst_n(rst),.I_restore_arm(selected),.I_key_n(keys),
 .O_k1_short(k1s),.O_k1_long(k1l),.O_k2_short(k2s),.O_k2_long(k2l),
 .O_k3_step(km),.O_k4_step(kp),.O_k4_long15(restore),.O_pressed());
color_ui_fsm #(.MS_CYC(4)) ui(
 .clk(clk),.rst_n(rst),.I_preview_select(sw_stable),.I_k1_short(k1s_color),.I_k1_long(k1l),.I_k2_short(k2s_color),.I_k2_long(k2l),
 .I_k3_step(km),.I_k4_step(kp),.I_k4_long15(restore),
 .I_eff(eff),
 
 
 .O_edit_bus(edit_bus),.O_commit_req(),.O_mode(mode),.O_edit(editing),.O_panel(panel),
 .O_page(page),.O_cursor(cursor),.O_edge_toggle(toggle),.O_status_show(status_show),
 .O_restore_sel(selected),.O_preview(preview));
reg user=0,vs=0;wire[9:0]view;wire[12:0]fill_run_count;wire fill_overflow;
hdmi_mixer #(.IMG_WIDTH(64),.IMG_HEIGHT(32),.H_TOTAL(96),.UI_ENABLE(1),.VIDEO_SRC(1),.EDGE_FILL_ENABLE(1),.EDGE_COMPARE_ENABLE(1)) dut(
 .I_clk(clk),.I_rst_n(rst),.I_video_vsync(vs),.I_video_hsync(1'b0),.I_video_de(user),.I_video_user(user),.I_video_last(1'b0),.I_video_rd_data(24'd0),
 .I_debug_status(4'd0),.I_ae_status(60'd0),.I_key_src_trig(1'b0),.I_key_det_trig(1'b0),.I_bg_calibrate(1'b0),
 .I_ui_mode(mode),.I_ui_view({panel,editing,page,cursor,preview}),.O_ui_view(view),.I_ui_edge_toggle(toggle),
 .I_fill_k1_short(k1s),.I_fill_k1_long(k1l),.I_fill_k3_step(km),.I_fill_k4_step(kp),
 .I_ui_edit_bus(edit_bus),.I_ui_commit_req(edit_bus!=eff),.O_param_eff(eff),.O_param_version(ver),.O_param_committed(committed),
 .O_fill_edit(fill_edit),.O_fill_run_count(fill_run_count),.O_fill_overflow(fill_overflow));
integer events=0;reg [1:0] held;
always @(posedge clk)if(rst&&toggle)events=events+1;
task press;input integer key_index,cycles;begin
 held={dut.S_fill_eff,dut.S_extract_eff};
 @(negedge clk);keys[key_index]=0;repeat(cycles)@(negedge clk);keys[key_index]=1;repeat(120)@(negedge clk);
 if({dut.S_fill_eff,dut.S_extract_eff}!==held)$fatal(1,"FAIL midframe key commit");
end endtask
task commit;input integer want_mode,want_extract,want_fill;begin
 repeat(3)begin @(negedge clk);vs=1;repeat(3)@(negedge clk);vs=0;repeat(3)@(negedge clk);user=1;@(negedge clk);user=0;repeat(8)@(negedge clk);end
 if(dut.S_src_eff!==want_mode || dut.S_extract_eff!==want_extract || dut.S_fill_eff!==want_fill)$fatal(1,"FAIL committed mode wanted=%0d/%0d/%0d actual=%0d/%0d/%0d",want_mode,want_extract,want_fill,dut.S_src_eff,dut.S_extract_eff,dut.S_fill_eff);
end endtask
initial begin
 repeat(8)@(negedge clk);rst=1;repeat(20)@(negedge clk);
 press(1,160);commit(0,0,0);if(events!=0)$fatal(1,"FAIL K2 outside EDGE");
 press(0,160);commit(1,0,0);press(0,160);commit(2,0,0);
 press(1,160);commit(2,1,0);press(1,160);commit(2,1,1);press(1,160);commit(2,0,0);
 press(1,160);commit(2,1,0);press(1,160);commit(2,1,1);
 press(0,4000);if(!fill_edit||dut.S_fill_param_sel!=0)$fatal(1,"FAIL FILL editor entry");
 press(0,160);if(dut.S_fill_param_sel!=1)$fatal(1,"FAIL FILL parameter next");
  press(3,160);if(dut.S_fill_gap_cfg!=1)$fatal(1,"FAIL FILL gap increment");
  press(0,160);press(0,160);press(0,160);if(dut.S_fill_param_sel!=4)$fatal(1,"FAIL FILL min-width field");
  press(3,160);if(dut.S_fill_minw_cfg!=25)$fatal(1,"FAIL FILL min-width increment");
  press(0,160);if(dut.S_fill_param_sel!=0)$fatal(1,"FAIL FILL field wrap");
 press(0,4000);if(fill_edit)$fatal(1,"FAIL FILL editor exit");
 press(1,160);commit(2,0,0);
 press(1,4000);commit(2,0,0);if(events!=6)$fatal(1,"FAIL long K2 repeated");
 press(0,160);commit(3,0,0);press(0,4000);if(!editing)$fatal(1,"FAIL COLOR editor");
 press(1,160);commit(3,0,0);if(cursor!=1||events!=6)$fatal(1,"FAIL COLOR navigation collided");
 if(edit_bus!=={16'd32,16'd18,16'd44,16'd40,16'd40,16'd20,16'd40,16'd48,16'd12,16'd48,16'd36,16'd12,16'd48,16'd48,16'd24})$fatal(1,"FAIL UI navigation changed parameter/save");
 @(negedge clk);rst=0;@(negedge clk);if(dut.S_fill_run||dut.S_fill_eff)$fatal(1,"FAIL reset");
 $display("PASS: physical K2 DETECT EXTRACT FILL cycle, no midframe change, long/bounce suppression, COLOR navigation independent, zero parameter writes");$finish;
end
initial begin #1000000;$fatal(1,"FAIL timeout");end
endmodule
