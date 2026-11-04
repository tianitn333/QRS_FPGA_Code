`timescale 1ns/1ns
module tb_edge_fill_min_bg_run;
  localparam W=32,H=16,HT=48,CAP=256,N=W*H;
  reg clk=0,rst_n=0,valid=0,user=0,last=0,tick=0,edge_bit=0;
  reg [11:0] x=0,y=0;
  reg edge_map[0:N-1];
  wire av_raw,av_filt; wire [23:0] px_raw,px_filt; wire [31:0] tag_raw,tag_filt;
  wire [20:0] cyc_raw,cyc_filt;
  reg seen_raw=0,seen_filt=0; reg [23:0] sample_raw=0,sample_filt=0;
  integer ix,iy,frame,i;
  always #5 clk=~clk;
  edge_fill_buffer #(.IMG_W(W),.IMG_H(H),.MAX_RUNS(CAP),.MIN_BG_RUN(1)) raw_dut(
    .clk(clk),.rst_n(rst_n),.valid_i(valid),.user_i(user),.last_i(last),.frame_tick_i(tick),.edge_i(edge_bit),.x_i(x),.y_i(y),
    .available_o(av_raw),.pixel_o(px_raw),.display_frame_o(tag_raw),.process_cycles_o(cyc_raw),
    .cfg_valid_i(1'b0),.run_filter_threshold_i(12'd0),.closure_gap_tolerance_i(12'd0),
    .gap_count_tolerance_i(4'd0),.border_contact_tolerance_i(12'd0),.min_fill_width_i(12'd0),.run_count_o(),.run_overflow_o());
  edge_fill_buffer #(.IMG_W(W),.IMG_H(H),.MAX_RUNS(CAP),.MIN_BG_RUN(8)) filt_dut(
    .clk(clk),.rst_n(rst_n),.valid_i(valid),.user_i(user),.last_i(last),.frame_tick_i(tick),.edge_i(edge_bit),.x_i(x),.y_i(y),
    .available_o(av_filt),.pixel_o(px_filt),.display_frame_o(tag_filt),.process_cycles_o(cyc_filt),
    .cfg_valid_i(1'b0),.run_filter_threshold_i(12'd0),.closure_gap_tolerance_i(12'd0),
    .gap_count_tolerance_i(4'd0),.border_contact_tolerance_i(12'd0),.min_fill_width_i(12'd0),.run_count_o(),.run_overflow_o());
  always @(posedge clk) begin
    if(rst_n && valid && x==16 && y==8) begin
      if(av_raw) begin seen_raw<=1; sample_raw<=px_raw; end
      if(av_filt) begin seen_filt<=1; sample_filt<=px_filt; end
    end
  end
  initial begin
    for(i=0;i<N;i=i+1) edge_map[i]=0;
    // Closed rectangle with a one-pixel gap in the top edge at x=15.
    for(i=8;i<=22;i=i+1) begin edge_map[4*W+i]=1; edge_map[11*W+i]=1; end
    for(i=4;i<=11;i=i+1) begin edge_map[i*W+8]=1; edge_map[i*W+22]=1; end
    edge_map[4*W+15]=0;
    repeat(5) @(negedge clk); rst_n=1;
    for(frame=0;frame<4;frame=frame+1) begin
      for(iy=0;iy<H+200;iy=iy+1) begin
        for(ix=0;ix<HT;ix=ix+1) begin
          @(negedge clk);
          x=ix<W?ix:W; y=iy<H?iy:H;
          valid=(ix<W)&&(iy<H); user=valid&&(ix==0)&&(iy==0); last=valid&&(ix==W-1);
          tick=(iy==H+5)&&(ix==0);
          edge_bit=valid?edge_map[iy*W+ix]:0;
        end
      end
    end
    @(negedge clk); valid=0;user=0;last=0;tick=0;edge_bit=0;
    repeat(30) @(negedge clk);
    if(!seen_raw || !seen_filt) $fatal(1,"FAIL: samples unavailable raw=%0d filt=%0d",seen_raw,seen_filt);
    if(sample_raw==24'h20c080) $fatal(1,"FAIL: unfiltered one-pixel gap unexpectedly filled raw=%h",sample_raw);
    if(sample_filt!==24'hff3030 && sample_filt!==24'h3080ff && sample_filt!==24'h20c080) $fatal(1,"FAIL: filtered gap did not fill got=%h",sample_filt);
    $display("PASS: MIN_BG_RUN bridges one-pixel contour gap raw=%h filtered=%h raw_cycles=%0d filt_cycles=%0d",sample_raw,sample_filt,cyc_raw,cyc_filt);
    $finish;
  end
  initial begin #30000000; $fatal(1,"FAIL: timeout"); end
endmodule
