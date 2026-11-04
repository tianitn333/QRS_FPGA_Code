`timescale 1ns/1ps
module tb_motion_slots_overlap;
 reg clk=0; always #5 clk=~clk;
 reg rst_n=0;
 reg [31:0] race=0, source=0, alloc_race=0, fence=0, committed=0;
 reg clear=0,cancel=0,allocate=0,track=1,queued=0,qgood=1;
 reg [6:0] read_protect=0;
 reg [2:0] qslot=0;
 wire grant; wire[2:0] alloc_slot;
 reg validate=0,vgood=1;reg[31:0] vsource=0;
 reg decision=0,dgood=1;reg[31:0] dsource=0,drace=0;reg[2:0] dmask=0;
 wire vr,dr;reg[1:0] view=0;
 wire[2:0] view_slot,evalid,live_slot;
 wire[31:0] view_source,live_source;
 wire view_valid,live_valid,missing;
 wire[6:0] pinned;
 integer errors=0,frames=0,k,n;
 reg[2:0] saved_slot[0:2];reg[2:0] slot_temp;
 motion_frame_store_ctrl dut(.clk(clk),.rst_n(rst_n),.race_i(race),.clear_i(clear),
 .cancel_analysis_i(cancel),.read_protect_i(read_protect),.allocate_i(allocate),
 .allocate_source_i(source),.allocate_race_i(alloc_race),.allocate_track_i(track),
 .allocate_ready_o(grant),.allocate_slot_o(alloc_slot),.queued_i(queued),.queued_slot_i(qslot),
 .queued_good_i(qgood),.queued_fence_i(fence),.committed_i(committed),
 .validate_i(validate),.validate_source_i(vsource),.validate_good_i(vgood),.validate_ready_o(vr),
 .decision_i(decision),.decision_source_i(dsource),.decision_race_i(drace),
 .decision_mask_i(dmask),.decision_good_i(dgood),.decision_ready_o(dr),
 .view_lane_i(view),.view_slot_o(view_slot),.view_source_o(view_source),.view_valid_o(view_valid),
 .evidence_valid_o(evalid),.pinned_o(pinned),.live_valid_o(live_valid),.live_slot_o(live_slot),
 .live_source_o(live_source),.missing_o(missing));
 task check;input condition;input[255:0]message;begin
 if(condition!==1'b1)begin $display("FAIL: %s t=%0t",message,$time);errors=errors+1;end end endtask
 task reset;begin @(negedge clk);rst_n=0;repeat(3)@(negedge clk);rst_n=1;
 repeat(3)@(negedge clk);race=1;alloc_race=1;drace=1;repeat(3)@(negedge clk);end endtask
 task alloc;input[31:0] id;output[2:0]slot;begin
 @(negedge clk);source=id;#1;check(grant,"allocation ready");slot=alloc_slot;
 check(!pinned[slot]&&!read_protect[slot],"never allocate pinned/read slot");
 allocate=1;@(negedge clk);allocate=0;frames=frames+1;end endtask
 task enqueue;input[2:0]slot;input[31:0]tail;begin
 @(negedge clk);qslot=slot;fence=tail;queued=1;@(negedge clk);queued=0;end endtask
 task seal;input[31:0]id;input valid_frame;begin
 @(negedge clk);vsource=id;vgood=valid_frame;validate=1;#1;check(vr,"validation matched");
 @(negedge clk);validate=0;end endtask
 task decide;input[31:0]id;input[2:0]mask;begin
 @(negedge clk);dsource=id;dmask=mask;decision=1;#1;check(dr,"decision matched");
 @(negedge clk);decision=0;end endtask
 task frame;input[31:0]id;input[2:0]mask;begin
 alloc(id,slot_temp);enqueue(slot_temp,id+1000);seal(id,1);
 if(id[0])decide(id,mask);
 committed=id+1000;repeat(4)@(negedge clk);
 if(!id[0])decide(id,mask);
 repeat(20)@(negedge clk);end endtask
 initial begin
 reset;
 // Arrival before physical-controller acceptance must not expose evidence.
 alloc(1,slot_temp);saved_slot[0]=slot_temp;
 decide(1,7);enqueue(slot_temp,10);seal(1,1);
 repeat(6)@(negedge clk);check(evalid==0,"acceptance fence blocks early pin");
 committed=9;repeat(4)@(negedge clk);check(evalid==0,"fence minus one still blocked");
 committed=10;repeat(20)@(negedge clk);check(evalid==7,"all lanes committed together within bounded service");
 check(pinned==(7'b1<<saved_slot[0]),"same frame uses one slot");
 for(k=2;k<100;k=k+1)frame(k,0);
 check(evalid==7&&pinned==(7'b1<<saved_slot[0]),"shared pin survives continuous capture");
 // Clearing evidence must retain external read ownership.
 read_protect=pinned;@(negedge clk);race=2;alloc_race=2;drace=2;
 repeat(4)@(negedge clk);check(evalid==0,"new race clears evidence");
 for(k=100;k<110;k=k+1)frame(k,0);
 read_protect=0;
 for(k=0;k<3;k=k+1)begin frame(110+k,1<<k);view=k;#1;
 check(view_valid&&view_source==110+k,"lane maps its own source");saved_slot[k]=view_slot;end
 check(saved_slot[0]!=saved_slot[1]&&saved_slot[1]!=saved_slot[2]&&saved_slot[0]!=saved_slot[2],"three frames occupy distinct slots");
 for(k=113;k<300;k=k+1)frame(k,0);
 for(k=0;k<3;k=k+1)begin view=k;#1;check(view_valid&&view_source==110+k&&view_slot==saved_slot[k],"three pins preserved");end
 // Duplicate later events do not replace the lane's first evidence.
 frame(300,7);view=0;#1;check(view_source==110,"duplicate does not repin");
 // Failed source validation cannot produce a usable evidence frame.
 @(negedge clk);race=3;alloc_race=3;drace=3;repeat(4)@(negedge clk);
 alloc(301,slot_temp);decide(301,1);enqueue(slot_temp,2000);seal(301,0);
 committed=2000;repeat(8)@(negedge clk);check(evalid==0,"bad frame rejected");
 // Every outstanding provisional frame blocks reuse; no-slot is explicit.
 // Two completed live-history slots remain protected across race changes.
 for(k=302;k<307;k=k+1)alloc(k,slot_temp);
 #1;check(!grant,"all outstanding slots block allocation");
 @(negedge clk);cancel=1;@(negedge clk);cancel=0;
 // Cancel must not release incomplete DDR writes.
 #1;check(!grant,"cancel cannot release unfinished writes");
 // Old frame headers arriving after a new race must not recreate analysis leases.
 reset();alloc_race=0;drace=0;
 alloc(500,slot_temp);#1;
 check(dut.decided[slot_temp] && !dut.tracked[slot_temp],"late old-race header has no new lease");
 enqueue(slot_temp,1450);seal(500,1);committed=1450;decide(500,7);
 repeat(30)@(negedge clk);
 check(evalid==0 && (dut.tracked & ~dut.decided)==0,"late old-race decision cannot pin or leak lease");
 alloc_race=1;drace=1;frame(501,1);
 check(evalid==1,"current race can pin after late old packet");
 drace=0;decide(500,7);repeat(30)@(negedge clk);
 check(evalid==1,"old event cannot revive other lanes");
 // An invalid old frame leaves a reusable slot. Deliver its old decision
 // exactly while that same slot is allocated to a new, still-unanalysed frame.
 reset();committed=0;alloc_race=1;drace=1;
 alloc(600,slot_temp);enqueue(slot_temp,1000);seal(600,0);committed=1000;
 repeat(20)@(negedge clk);
 read_protect=7'b1111111 & ~(7'b1<<slot_temp);
 @(negedge clk);source=601;allocate=1;dsource=600;dmask=7;decision=1;#1;
 check(grant&&alloc_slot==slot_temp,"force reuse of invalid old slot");
 @(negedge clk);allocate=0;#1;
 check(dut.source[slot_temp]==601 && !dut.decided[slot_temp] && dut.arrivals[slot_temp]==0,
       "same-edge old decision cannot populate new source");
 // READY/VALID consumer retains its old packet across the allocation bubble.
 while(!dr)@(negedge clk);
 @(negedge clk);decision=0;read_protect=0;
 enqueue(slot_temp,1100);seal(601,1);committed=1100;decide(601,0);
 repeat(30)@(negedge clk);check(evalid==0,"new no-event frame cannot inherit old arrival");
 // Repeat with a late source-validity rejection on the allocation edge.
 reset();committed=0;alloc_race=1;drace=1;
 alloc(602,slot_temp);enqueue(slot_temp,1200);seal(602,0);committed=1200;
 repeat(20)@(negedge clk);read_protect=7'b1111111 & ~(7'b1<<slot_temp);
 @(negedge clk);source=603;allocate=1;vsource=602;vgood=0;validate=1;#1;
 check(grant&&alloc_slot==slot_temp,"force validity/reuse overlap");
 @(negedge clk);allocate=0;#1;
 check(dut.good[slot_temp] && !dut.decided[slot_temp],"old invalidity cannot poison new source");
 while(!vr)@(negedge clk);
 @(negedge clk);validate=0;read_protect=0;
 enqueue(slot_temp,1300);seal(603,1);committed=1300;decide(603,1);
 repeat(30)@(negedge clk);view=0;#1;
 check(evalid==1&&view_source==603,"new valid source still creates correct evidence");
 // Common reset releases stale leases, pins and history.
 @(negedge clk);rst_n=0;repeat(3)@(negedge clk);rst_n=1;repeat(4)@(negedge clk);
 race=0;repeat(3)@(negedge clk);check(grant&&evalid==0&&!live_valid,"reset restores safe empty store");
 if(errors==0)$display("PASS: seven-slot concurrent-transaction ownership %0d frames, fences, same-frame ties, three pins, clear and exhaustion",frames);
 else $display("FAIL: %0d errors",errors);
 $finish;
 end
 initial begin #20000000;$display("FAIL: timeout");$finish;end
endmodule
