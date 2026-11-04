// Four-connected background components over raster-ordered intervals.
// Interval openings narrower than the configured tolerance may still join a
// component (so a slightly broken outline can be replayed); the number of such
// joins is carried per root and bounds how many openings a region may have.
// A pair that is farther apart than the tolerance is simply "not connected":
// it neither joins anything nor disqualifies a component.
// Record: {fill_color[1:0], touches_image_border, filled_interior, end_x[10:0], start_x[10:0]}.
// Row table contains start indices for rows 0..IMG_H, including an end sentinel.
module edge_fill_ccl #(
 parameter integer IMG_H=720,MAX_RUNS=6144,CYCLE_BUDGET=1100000
)(
 input wire clk,rst_n,start_i,input wire [12:0] count_i,
 output wire busy_o,output reg done_o,failed_o,output reg [20:0] cycles_o,
 output reg [12:0] run_rd_addr_o,input wire [25:0] run_data_i,
 output reg run_we_o,output reg [12:0] run_wr_addr_o,output reg [25:0] run_data_o,
 output reg [9:0] row_addr_o,input wire [12:0] row_data_i,
 input wire [11:0] closure_gap_i,
 input wire [3:0] gap_count_tolerance_i,
 input wire [11:0] border_contact_tolerance_i
);
 localparam IDLE=0,IR=1,IW=2,M0=3,M0W=4,M1=5,M1W=6,M2=7,M2W=8,CHECK=9,
  AR=10,AW=11,BR=12,BW=13,COMPARE=14,FAR=15,FAW=16,FBR=17,FBW=18,
  UNION_PREP=19,UC=20,UR=21,ADVANCE=22,FR=23,FW=24,ROOTR=25,ROOTW=26;
 reg [4:0] state;
 reg [12:0] total,idx,prev_start,cur_start,end_a,end_b,ptr_a,ptr_b;
 reg [9:0] row;
 reg [25:0] rec_a,rec_b,fill_record;
 reg [12:0] find_ptr,root_a,root_b,child_addr,parent_addr;
 reg [17:0] word_a,word_b,child_word,parent_word;
 // Parent (18 bits including union rank) and gap (5 bits) share read
 // addresses and normal write transactions. Store all 23 payload bits in
 // the existing 26-bit, 9x2048-lane RAM, with the same one-clock read.
 // A watchdog abort discards the task; a subsequent task initializes every
 // consumed entry. No aborted gap-only write needs to be retained.
 reg [4:0] gap_a,gap_b,gap_child_word,gap_parent_word;
 wire [4:0] gap_data;
 reg [3:0] gap_count_tolerance;
 reg [1:0] gap_edge;
 reg [1:0] root_color;
 reg [4:0] gap_sum;
 reg parent_we;reg [12:0] parent_waddr,parent_raddr;reg [17:0] parent_wdata;
 wire [17:0] parent_data;
 reg [11:0] closure_gap,border_contact_tolerance;
 assign busy_o=state!=IDLE;
 wire [25:0] packed_parent_gap_data;
 assign parent_data=packed_parent_gap_data[22:5];
 assign gap_data=packed_parent_gap_data[4:0];
 edge_fill_ram24 #(.DEPTH(MAX_RUNS)) metadata_words(
  .clk(clk),.we_i(parent_we),.wr_addr_i(parent_waddr),
  .data_i({3'd0,parent_wdata,gap_child_word}),
  .rd_addr_i(parent_raddr),.data_o(packed_parent_gap_data));
 always @(*)begin
  run_rd_addr_o=idx;run_wr_addr_o=idx;run_we_o=0;run_data_o=fill_record;
  row_addr_o=0;parent_raddr=find_ptr;parent_we=0;parent_waddr=0;parent_wdata=0;
  gap_child_word=0;gap_parent_word=0;
  // Gap word is {1'b0, count[3:0]}. Only joins caused by a tolerance bridge
  // are counted, and the counter saturates instead of poisoning the root.
  gap_sum={1'b0,gap_a[3:0]}+{1'b0,gap_b[3:0]}+{4'd0,(gap_edge==2'd1)};
  gap_child_word={1'b0,gap_sum[4] ? 4'hf : gap_sum[3:0]};
  gap_parent_word={1'b0,gap_sum[4] ? 4'hf : gap_sum[3:0]};
  // Fixed root-id mapping: 0=red, 1=blue, 2=green, then repeat.
  root_color=find_ptr % 13'd3;
  case(state)
   IW:begin
    parent_we=1;parent_waddr=idx;parent_wdata={run_data_i[23],4'd0,idx};
    gap_child_word=0;
   end
   M0,M0W:row_addr_o=row-1'b1;
   M1,M1W:row_addr_o=row;
   M2,M2W:row_addr_o=row+1'b1;
   AR,AW:run_rd_addr_o=ptr_a;
   BR,BW:run_rd_addr_o=ptr_b;
   UC:begin parent_we=1;parent_waddr=child_addr;parent_wdata=child_word;end
   UR:begin parent_we=1;parent_waddr=parent_addr;parent_wdata=parent_word;end
   ROOTW:if(parent_data[12:0]==find_ptr)begin
    run_we_o=1;run_data_o={root_color,fill_record[23],
      ((!parent_data[17] || (!fill_record[23] && (gap_data[3:0]!=0))) &&
       (gap_data[3:0]<=gap_count_tolerance)),fill_record[21:0]};
   end
   default:begin end
  endcase
  if(cycles_o>=CYCLE_BUDGET)begin parent_we=0;run_we_o=0;end
 end
 always @(posedge clk or negedge rst_n)begin
  if(!rst_n)begin
   state<=IDLE;done_o<=0;failed_o<=0;cycles_o<=0;total<=0;idx<=0;row<=0;
   prev_start<=0;cur_start<=0;end_a<=0;end_b<=0;ptr_a<=0;ptr_b<=0;
   rec_a<=0;rec_b<=0;fill_record<=0;find_ptr<=0;root_a<=0;root_b<=0;closure_gap<=0;
   gap_a<=0;gap_b<=0;gap_edge<=0;gap_count_tolerance<=0;border_contact_tolerance<=0;
   word_a<=0;word_b<=0;child_addr<=0;parent_addr<=0;child_word<=0;parent_word<=0;
  end else begin
   done_o<=0;failed_o<=0;
   if(state!=IDLE)cycles_o<=cycles_o+1'b1;
   if(state!=IDLE && cycles_o>=CYCLE_BUDGET)begin state<=IDLE;done_o<=1;failed_o<=1;end
   else case(state)
    IDLE:if(start_i)begin
     cycles_o<=0;total<=count_i;idx<=0;closure_gap<=closure_gap_i;
     border_contact_tolerance<=border_contact_tolerance_i;
     gap_count_tolerance<=gap_count_tolerance_i;
     if(count_i>MAX_RUNS)begin done_o<=1;failed_o<=1;end
     else if(count_i==0)done_o<=1;
     else state<=IR;
    end
    IR:state<=IW;
    IW:if(idx+1'b1==total)begin row<=1;state<=M0;end else begin idx<=idx+1'b1;state<=IR;end
    M0:state<=M0W;
    M0W:begin prev_start<=row_data_i;state<=M1;end
    M1:state<=M1W;
    M1W:begin cur_start<=row_data_i;end_a<=row_data_i;state<=M2;end
    M2:state<=M2W;
    M2W:begin ptr_a<=prev_start;ptr_b<=cur_start;end_b<=row_data_i;state<=CHECK;end
    CHECK:if(ptr_a>=end_a || ptr_b>=end_b)begin
     if(row==IMG_H-1)begin idx<=0;state<=FR;end
     else begin row<=row+1'b1;state<=M0;end
    end else state<=AR;
    AR:state<=AW;
    AW:begin rec_a<=run_data_i;state<=BR;end
    BR:state<=BW;
    BW:begin rec_b<=run_data_i;state<=COMPARE;end
    COMPARE:begin
     // A true overlap is ordinary CCL connectivity.  A separated pair is
     // accepted as a bounded opening only when its empty-pixel distance is
     // strictly below CG (internal) or BT (if either run touches a border).
     if(rec_a[21:11] < rec_b[10:0]) begin
      if(({2'd0,rec_b[10:0]}-{2'd0,rec_a[21:11]}-13'd1) <
         ((rec_a[23]||rec_b[23]) ? {1'b0,border_contact_tolerance} : {1'b0,closure_gap})) begin
       find_ptr<=ptr_a;gap_edge<=1;state<=FAR;
      end else begin find_ptr<=ptr_a;gap_edge<=2;state<=FAR;end
     end else if(rec_b[21:11] < rec_a[10:0]) begin
      if(({2'd0,rec_a[10:0]}-{2'd0,rec_b[21:11]}-13'd1) <
         ((rec_a[23]||rec_b[23]) ? {1'b0,border_contact_tolerance} : {1'b0,closure_gap})) begin
       find_ptr<=ptr_a;gap_edge<=1;state<=FAR;
      end else begin find_ptr<=ptr_a;gap_edge<=2;state<=FAR;end
     end else begin
      find_ptr<=ptr_a;gap_edge<=0;state<=FAR;
     end
    end
    FAR:state<=FAW;
    FAW:if(parent_data[12:0]==find_ptr)begin
     root_a<=find_ptr;word_a<=parent_data;gap_a<=gap_data;find_ptr<=ptr_b;state<=FBR;
    end else begin find_ptr<=parent_data[12:0];state<=FAR;end
    FBR:state<=FBW;
    FBW:if(parent_data[12:0]==find_ptr)begin
     root_b<=find_ptr;word_b<=parent_data;gap_b<=gap_data;
     // A separated pair is just "not connected": it neither joins the two
     // runs nor disqualifies either root.
     if(gap_edge==2'd2)state<=ADVANCE;
     else if(find_ptr==root_a)state<=ADVANCE;
     else state<=UNION_PREP;
    end else begin find_ptr<=parent_data[12:0];state<=FBR;end
    UNION_PREP:begin
     if(word_a[16:13]>=word_b[16:13])begin
      child_addr<=root_b;parent_addr<=root_a;child_word<={word_b[17:13],root_a};
      parent_word<={word_a[17]|word_b[17],word_a[16:13]+(word_a[16:13]==word_b[16:13]?4'd1:4'd0),root_a};
     end else begin
      child_addr<=root_a;parent_addr<=root_b;child_word<={word_a[17:13],root_b};
      parent_word<={word_a[17]|word_b[17],word_b[16:13],root_b};
     end
     state<=UC;
    end
    UC:state<=UR;
    UR:state<=ADVANCE;
    ADVANCE:begin
     if(rec_a[21:11]<=rec_b[21:11])ptr_a<=ptr_a+1'b1;
     if(rec_b[21:11]<=rec_a[21:11])ptr_b<=ptr_b+1'b1;
     state<=CHECK;
    end
    FR:state<=FW;
    FW:begin fill_record<=run_data_i;find_ptr<=idx;state<=ROOTR;end
    ROOTR:state<=ROOTW;
    ROOTW:if(parent_data[12:0]==find_ptr)begin
     if(idx+1'b1==total)begin done_o<=1;state<=IDLE;end
     else begin idx<=idx+1'b1;state<=FR;end
    end else begin find_ptr<=parent_data[12:0];state<=ROOTR;end
    default:state<=IDLE;
   endcase
  end
 end
endmodule
