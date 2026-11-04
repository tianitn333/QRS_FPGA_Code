`timescale 1ns/1ps
// Reference uses separate parent/gap tables. The candidate packs all 23 bits.
// Force watchdog expiry in write states, then restart without resetting RAM.
module tb_ccl_packed_abort;
 reg clk=0,rst_n=0,start=0;reg [12:0] count=3;
 reg [25:0] dut_words[0:15],ref_words[0:15];reg [12:0] row_heads[0:3];
 reg [25:0] dut_rdata=0,ref_rdata=0;reg [12:0] dut_mdata=0,ref_mdata=0;
 wire dut_busy,dut_done,dut_failed,dut_we,ref_busy,ref_done,ref_failed,ref_we;
 wire [20:0] dut_cycles,ref_cycles;
 wire [12:0] dut_ra,dut_wa,ref_ra,ref_wa;wire [9:0] dut_ma,ref_ma;
 wire [25:0] dut_wdata,ref_wdata;
 integer i,case_no,guard,seen,located,target,skip,writes=0,checks=0,aborts=0,bridged_aborts=0;
 always #5 clk=~clk;
 edge_fill_ccl #(.IMG_H(3),.MAX_RUNS(16),.CYCLE_BUDGET(1000)) dut(
  .clk(clk),.rst_n(rst_n),.start_i(start),.count_i(count),.busy_o(dut_busy),.done_o(dut_done),
  .failed_o(dut_failed),.cycles_o(dut_cycles),.run_rd_addr_o(dut_ra),.run_data_i(dut_rdata),
  .run_we_o(dut_we),.run_wr_addr_o(dut_wa),.run_data_o(dut_wdata),.row_addr_o(dut_ma),.row_data_i(dut_mdata),
  .closure_gap_i(12'd3),.gap_count_tolerance_i(4'd3),.border_contact_tolerance_i(12'd0));
 reference_ccl_abort #(.IMG_H(3),.MAX_RUNS(16),.CYCLE_BUDGET(1000)) reference_dut(
  .clk(clk),.rst_n(rst_n),.start_i(start),.count_i(count),.busy_o(ref_busy),.done_o(ref_done),
  .failed_o(ref_failed),.cycles_o(ref_cycles),.run_rd_addr_o(ref_ra),.run_data_i(ref_rdata),
  .run_we_o(ref_we),.run_wr_addr_o(ref_wa),.run_data_o(ref_wdata),.row_addr_o(ref_ma),.row_data_i(ref_mdata),
  .closure_gap_i(12'd3),.gap_count_tolerance_i(4'd3),.border_contact_tolerance_i(12'd0));
 always @(posedge clk)begin
  if(!rst_n)begin dut_rdata<=0;ref_rdata<=0;dut_mdata<=0;ref_mdata<=0;end
  else begin
   dut_rdata<=dut_words[dut_ra];ref_rdata<=ref_words[ref_ra];
   dut_mdata<=row_heads[dut_ma];ref_mdata<=row_heads[ref_ma];
   if(dut_we)dut_words[dut_wa]<=dut_wdata;
   if(ref_we)ref_words[ref_wa]<=ref_wdata;
   if(dut_we!==ref_we)$fatal(1,"FAIL: write enable");
   if(ref_we)begin
    if(dut_wa!==ref_wa||dut_wdata!==ref_wdata)$fatal(1,"FAIL: committed run word");
    writes=writes+1;
   end
   if(ref_cycles<1000)begin
    if(reference_dut.parent_we!==reference_dut.gap_we||reference_dut.parent_raddr!==reference_dut.gap_raddr)
     $fatal(1,"FAIL: normal shared-port precondition");
    if(reference_dut.parent_we&&reference_dut.parent_waddr!==reference_dut.gap_waddr)
     $fatal(1,"FAIL: normal shared write address");
   end
  end
  #1;
  if(rst_n)begin
   if({dut_busy,dut_done,dut_failed,dut_cycles,dut_ra,dut_ma}!=={ref_busy,ref_done,ref_failed,ref_cycles,ref_ra,ref_ma})
    $fatal(1,"FAIL: public cycle/status/address mismatch");
   checks=checks+1;
  end
 end
 function [25:0] record_word;
  input [10:0] lo,hi;input border;
  begin record_word={2'b00,border,1'b0,hi,lo};end
 endfunction
 task prepare_three;
  begin
   for(i=0;i<16;i=i+1)begin dut_words[i]=0;ref_words[i]=0;end
   dut_words[0]=record_word(4,8,case_no[0]);dut_words[1]=record_word(12,16,0);dut_words[2]=record_word(7,11,0);
   ref_words[0]=dut_words[0];ref_words[1]=dut_words[1];ref_words[2]=dut_words[2];
   row_heads[0]=0;row_heads[1]=2;row_heads[2]=3;row_heads[3]=3;count=3;
  end
 endtask
 task launch;
  begin @(negedge clk);start=1;@(negedge clk);start=0;end
 endtask
 task await_success;
  begin
   guard=0;while(!ref_done&&guard<1500)begin @(negedge clk);guard=guard+1;end
   if(!ref_done||ref_failed||dut_failed)$fatal(1,"FAIL: restart did not complete");
   if(writes<1)$fatal(1,"FAIL: no committed output coverage");
   repeat(2)@(negedge clk);
  end
 endtask
 initial begin
  for(case_no=0;case_no<6;case_no=case_no+1)begin
   rst_n=0;start=0;repeat(3)@(negedge clk);prepare_three;rst_n=1;writes=0;
   if(case_no<2)begin target=2;skip=case_no;end
   else if(case_no<4)begin target=20;skip=case_no-2;end
   else begin target=21;skip=case_no-4;end
   launch;seen=0;located=0;
   for(guard=0;guard<1000&&!located;guard=guard+1)begin
    @(negedge clk);
    if(reference_dut.state==target)begin
     if(seen==skip)located=1;else seen=seen+1;
    end
   end
   if(!located)$fatal(1,"FAIL: target write state not reached case=%0d",case_no);
   if(target!=2&&skip==1)begin
    if(reference_dut.gap_child_word[3:0]==0)$fatal(1,"FAIL: bridged gap coverage missing");
    bridged_aborts=bridged_aborts+1;
   end
   force dut.cycles_o=21'd1000;force reference_dut.cycles_o=21'd1000;
   @(negedge clk);
   if(!dut_done||!dut_failed||!ref_done||!ref_failed)$fatal(1,"FAIL: abort status");
   release dut.cycles_o;release reference_dut.cycles_o;
   aborts=aborts+1;repeat(2)@(negedge clk);
   // No RAM reset: the shorter new task must not consume abandoned entries.
   count=1;dut_words[0]=record_word(4,8,case_no[0]);ref_words[0]=dut_words[0];
   row_heads[0]=0;row_heads[1]=1;row_heads[2]=1;row_heads[3]=1;writes=0;
   launch;await_success;
   prepare_three;writes=0;launch;await_success;
  end
  if(aborts!=6||bridged_aborts!=2)$fatal(1,"FAIL: abort coverage");
  $display("PASS: packed parent/gap table %0d cycles, %0d IW/UC/UR aborts, %0d nonzero-gap aborts and RAM-preserving restarts",checks,aborts,bridged_aborts);
  $finish;
 end
 initial begin #1000000;$fatal(1,"FAIL: watchdog");end
endmodule
