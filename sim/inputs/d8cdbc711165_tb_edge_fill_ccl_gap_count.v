`timescale 1ns/1ns
// Direct CCL contract test for the 2026-10-28 semantics: a one-pixel opening is
// bridged only when CG > distance, the bridge is counted once, and a pair at
// exactly CG is simply not connected (no join, no penalty).
module tb_edge_fill_ccl_gap_count;
  localparam integer H=2, CAP=16;
  reg clk=0, rst_n=0, start=0;
  always #5 clk=~clk;

  reg [25:0] runs[0:1];
  reg [12:0] rows[0:2];
  reg [25:0] run_rd0=0, run_rd1=0, run_rd2=0;
  reg [12:0] row_rd0=0, row_rd1=0, row_rd2=0;
  reg [25:0] out0[0:1], out1[0:1], out2[0:1];
  wire busy0,done0,fail0,busy1,done1,fail1,busy2,done2,fail2;
  wire [20:0] cyc0,cyc1,cyc2;
  wire [12:0] ra0,ra1,ra2,wa0,wa1,wa2;
  wire [25:0] wd0,wd1,wd2;
  wire we0,we1,we2;
  wire [9:0] ma0,ma1,ma2;
  wire [11:0] gap0=12'd2,gap1=12'd2,gap2=12'd1;
  reg seen0=0,seen1=0,seen2=0;

  function [25:0] rec;
    input [10:0] s,e;
    begin rec={2'd0,1'b0,1'b0,e,s}; end
  endfunction

  edge_fill_ccl #(.IMG_H(H),.MAX_RUNS(CAP),.CYCLE_BUDGET(10000)) ccl0(
    .clk(clk),.rst_n(rst_n),.start_i(start),.count_i(13'd2),.busy_o(busy0),.done_o(done0),.failed_o(fail0),.cycles_o(cyc0),
    .run_rd_addr_o(ra0),.run_data_i(run_rd0),.run_we_o(we0),.run_wr_addr_o(wa0),.run_data_o(wd0),.row_addr_o(ma0),.row_data_i(row_rd0),
    .closure_gap_i(gap0),.gap_count_tolerance_i(4'd0),.border_contact_tolerance_i(12'd0));
  edge_fill_ccl #(.IMG_H(H),.MAX_RUNS(CAP),.CYCLE_BUDGET(10000)) ccl1(
    .clk(clk),.rst_n(rst_n),.start_i(start),.count_i(13'd2),.busy_o(busy1),.done_o(done1),.failed_o(fail1),.cycles_o(cyc1),
    .run_rd_addr_o(ra1),.run_data_i(run_rd1),.run_we_o(we1),.run_wr_addr_o(wa1),.run_data_o(wd1),.row_addr_o(ma1),.row_data_i(row_rd1),
    .closure_gap_i(gap1),.gap_count_tolerance_i(4'd1),.border_contact_tolerance_i(12'd0));
  edge_fill_ccl #(.IMG_H(H),.MAX_RUNS(CAP),.CYCLE_BUDGET(10000)) ccl2(
    .clk(clk),.rst_n(rst_n),.start_i(start),.count_i(13'd2),.busy_o(busy2),.done_o(done2),.failed_o(fail2),.cycles_o(cyc2),
    .run_rd_addr_o(ra2),.run_data_i(run_rd2),.run_we_o(we2),.run_wr_addr_o(wa2),.run_data_o(wd2),.row_addr_o(ma2),.row_data_i(row_rd2),
    .closure_gap_i(gap2),.gap_count_tolerance_i(4'd1),.border_contact_tolerance_i(12'd0));

  always @(posedge clk) begin
    run_rd0 <= runs[ra0]; run_rd1 <= runs[ra1]; run_rd2 <= runs[ra2];
    row_rd0 <= rows[ma0]; row_rd1 <= rows[ma1]; row_rd2 <= rows[ma2];
    if(we0) out0[wa0] <= wd0;
    if(we1) out1[wa1] <= wd1;
    if(we2) out2[wa2] <= wd2;
    if(done0) seen0<=1'b1;
    if(done1) seen1<=1'b1;
    if(done2) seen2<=1'b1;
  end

  initial begin
    runs[0]=rec(11'd0,11'd5);
    runs[1]=rec(11'd7,11'd12);
    rows[0]=13'd0; rows[1]=13'd1; rows[2]=13'd2;
    out0[0]=0;out0[1]=0;out1[0]=0;out1[1]=0;out2[0]=0;out2[1]=0;
    repeat(4) @(negedge clk); rst_n=1;
    @(negedge clk); start=1;
    @(negedge clk); start=0;
    wait(seen0 && seen1 && seen2);
    if(fail0 || fail1 || fail2) $fatal(1,"FAIL CCL unexpectedly failed");
    if(out0[0][22] || out0[1][22]) $fatal(1,"FAIL gap count 0 accepted a one-pixel bridge");
    if(!out1[0][22] || !out1[1][22]) $fatal(1,"FAIL gap count 1 rejected a one-pixel bridge");
    // A separation equal to CG is not joined: the two runs stay independent
    // closed components, so they take different root colours and still fill.
    if(out2[0][25:24] == out2[1][25:24]) $fatal(1,"FAIL separation equal to CG still joined the runs");
    if(!out2[0][22] || !out2[1][22]) $fatal(1,"FAIL untouched closed runs must stay fillable");
    $display("PASS: bridge counting 0/1 and CG equality (no join, no penalty); cycles=%0d/%0d/%0d",cyc0,cyc1,cyc2);
    $finish;
  end
  initial begin #1000000; $fatal(1,"FAIL timeout"); end
endmodule
