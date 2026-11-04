`timescale 1ns/1ps
module tb_motion_horizontal_osd_y472;
 reg clk=0;always #5 clk=~clk;
 reg reset=0,de=0,vs=1,missing=0,fault=0;
 reg[63:0]metadata=0;reg[191:0]status=0;
 wire replay_hit,ordinary_hit;wire[23:0]replay_color,ordinary_color;
 integer file,row,column,pixels=0,errors=0,red_pixels=0,cyan_pixels=0;reg[23:0]color;
 motion_replay_osd #(.HORIZONTAL_ENABLE(1)) replay(.clk(clk),.rst_n(reset),.de_i(de),.vs_i(vs),.mode_i(1'b1),
 .no_evidence_i(missing),.fault_i(fault),.applied_i(metadata),.hit_o(replay_hit),.color_o(replay_color));
 motion_trial_osd #(.HORIZONTAL_ENABLE(1)) ordinary(.clk(clk),.rst_n(reset),.de_i(de),.vs_i(vs),.enable_i(1'b1),.edit_i(2'd0),
 .base_x_i(11'd160),.base_y_i(10'd472),.line_i(6'd40),.status_i(status),.hit_o(ordinary_hit),.color_o(ordinary_color));
 initial begin
 repeat(4)@(negedge clk);reset=1;
 metadata={1'b1,1'b1,2'd0,32'h1234,11'd160,10'd472,6'd40,1'b0};
 status[191]=1;status[161:159]=4;status[154:152]=7;status[151:146]=6'b010101;
 file=$fopen("replay_overlay.ppm","wb");$fwrite(file,"P6\n1280 720\n255\n");
 repeat(4)@(negedge clk);vs=0;
 for(row=0;row<720;row=row+1)begin
 for(column=0;column<1280;column=column+1)begin
 de=1;@(negedge clk);
 if(row==300&&column==0)metadata[59:28]=32'h5678;
 if(replay.snapshot[59:28]!==32'h1234)begin errors=errors+1;$display("FAIL: mid-frame replay label changed");end
 color=replay_hit?replay_color:(ordinary_hit?ordinary_color:24'h303438);
 if(replay_hit)pixels=pixels+1;
 if(ordinary_hit && ordinary_color==24'hff5030)red_pixels=red_pixels+1;
 if(ordinary_hit && ordinary_color==24'h00d8ff)cyan_pixels=cyan_pixels+1;
 if(ordinary.x==328 && (ordinary.y==116 || ordinary.y==324 || ordinary.y==532))begin
  if(!ordinary_hit || ordinary_color!=24'hff5030)begin errors=errors+1;$display("FAIL: visible per-lane finish pixel");end
 end
 $fwrite(file,"%c%c%c",color[23:16],color[15:8],color[7:0]);
 end
 de=0;repeat(12)@(negedge clk);
 end
 $fclose(file);
 vs=1;repeat(4)@(negedge clk);vs=0;de=1;@(negedge clk);de=0;
 if(replay.snapshot[59:28]!==32'h5678)begin errors=errors+1;$display("FAIL: next-frame label not updated");end
 vs=1;metadata[63:62]=0;fault=1;repeat(4)@(negedge clk);vs=0;de=1;@(negedge clk);de=0;
 if(!replay.fault_hint)begin errors=errors+1;$display("FAIL: evidence fault not frame-latched");end
 if(errors==0&&pixels>1000&&red_pixels==864&&cyan_pixels>9000)$display("PASS: replay header and three Chinese lane cards rendered, source label frame-stable, visible fault latch");
 else $display("FAIL: OSD errors=%0d colored=%0d red=%0d cyan=%0d",errors,pixels,red_pixels,cyan_pixels);
 $finish;
 end
endmodule
