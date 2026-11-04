`timescale 1ns/1ns
// The same two non-border roots are processed twice.  Root ids 0 and 1 must
// keep the red/blue mapping instead of changing with a frame seed.
module tb_edge_fill_color_stable;
  localparam integer H=2, CAP=8;
  reg clk=0, rst_n=0, start=0;
  always #5 clk=~clk;

  reg [25:0] runs[0:1];
  reg [12:0] rows[0:2];
  reg [25:0] run_rd=0;
  reg [12:0] row_rd=0;
  reg [25:0] out_mem[0:1];
  wire busy,done,failed;
  wire [20:0] cycles;
  wire [12:0] rd_addr,wr_addr;
  wire [25:0] wr_data;
  wire [9:0] row_addr;
  wire wr_en;
  integer pass_no;
  reg [25:0] first0,first1;

  function [25:0] rec;
    input [10:0] s,e;
    begin rec={2'd0,1'b0,1'b0,e,s}; end
  endfunction

  edge_fill_ccl #(.IMG_H(H),.MAX_RUNS(CAP),.CYCLE_BUDGET(10000)) dut(
    .clk(clk),.rst_n(rst_n),.start_i(start),.count_i(13'd2),
    .busy_o(busy),.done_o(done),.failed_o(failed),.cycles_o(cycles),
    .run_rd_addr_o(rd_addr),.run_data_i(run_rd),.run_we_o(wr_en),
    .run_wr_addr_o(wr_addr),.run_data_o(wr_data),.row_addr_o(row_addr),
    .row_data_i(row_rd),.closure_gap_i(12'd0),
    .gap_count_tolerance_i(4'd2),.border_contact_tolerance_i(12'd0));

  always @(posedge clk) begin
    run_rd <= runs[rd_addr];
    row_rd <= rows[row_addr];
    if(wr_en) out_mem[wr_addr] <= wr_data;
  end

  task start_pass;
    begin
      @(negedge clk); start=1'b1;
      @(negedge clk); start=1'b0;
      wait(done);
      if(failed) $fatal(1,"FAIL: color CCL failed");
      if(!out_mem[0][22] || !out_mem[1][22]) $fatal(1,"FAIL: roots not marked fillable");
      if(pass_no==0) begin first0=out_mem[0];first1=out_mem[1];end
      else begin
        if(out_mem[0][25:24]!==first0[25:24] || out_mem[1][25:24]!==first1[25:24])
          $fatal(1,"FAIL: root color changed between frames");
      end
      if(out_mem[0][25:24]!==2'd0 || out_mem[1][25:24]!==2'd1)
        $fatal(1,"FAIL: expected root-id colors red/blue got %b/%b",out_mem[0][25:24],out_mem[1][25:24]);
    end
  endtask

  initial begin
    runs[0]=rec(11'd10,11'd20);
    runs[1]=rec(11'd40,11'd50);
    rows[0]=13'd0; rows[1]=13'd1; rows[2]=13'd2;
    out_mem[0]=0;out_mem[1]=0;pass_no=0;
    repeat(4) @(negedge clk); rst_n=1;
    start_pass(); pass_no=1; start_pass();
    $display("PASS: fixed root-id colors are stable across frames; root0=red root1=blue cycles=%0d",cycles);
    $finish;
  end
  initial begin #1000000; $fatal(1,"FAIL timeout"); end
endmodule
