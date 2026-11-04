// Four-connected background components over raster-ordered intervals.
// Interval openings narrower than the configured tolerance may still join a
// component (so a slightly broken outline can be replayed); the number of such
// joins is carried per root and bounds how many openings a region may have.
// A pair that is farther apart than the tolerance is simply "not connected":
// it neither joins anything nor disqualifies a component.
// Record: {fill_color[1:0], touches_image_border, filled_interior, end_x[10:0], start_x[10:0]}.
// Row table contains start indices for rows 0..IMG_H, including an end sentinel.
module reference_fill_ccl #(
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
 // gap_mem = {gap_bad, gap_count[3:0]}; it is kept outside the ERAM parent
 // table so adding the configurable count does not add ERAM lanes.
 reg [4:0] gap_a,gap_b,gap_child_word,gap_parent_word,gap_data;
 reg [12:0] gap_raddr,gap_waddr;
 reg gap_we;
 reg [3:0] gap_count_tolerance;
 reg [1:0] gap_edge;
 reg [1:0] root_color;
 reg [4:0] gap_sum;
 reg parent_we;reg [12:0] parent_waddr,parent_raddr;reg [17:0] parent_wdata;
 wire [17:0] parent_data;
 reg [11:0] closure_gap,border_contact_tolerance;
 reg [4:0] gap_mem[0:MAX_RUNS-1]; // synthesis ram_style=dram
 assign busy_o=state!=IDLE;
 image_eram #(.WIDTH(18),.DEPTH(MAX_RUNS),.ADDR_WIDTH(13)) parents(
  .clk(clk),.we_i(parent_we),.wr_addr_i(parent_waddr),.data_i(parent_wdata),
  .rd_addr_i(parent_raddr),.data_o(parent_data));
 always @(*)begin
  run_rd_addr_o=idx;run_wr_addr_o=idx;run_we_o=0;run_data_o=fill_record;
  row_addr_o=0;parent_raddr=find_ptr;parent_we=0;parent_waddr=0;parent_wdata=0;
  gap_raddr=find_ptr;gap_waddr=0;gap_we=0;gap_child_word=0;gap_parent_word=0;
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
    gap_we=1;gap_waddr=idx;gap_child_word=0;
   end
   M0,M0W:row_addr_o=row-1'b1;
   M1,M1W:row_addr_o=row;
   M2,M2W:row_addr_o=row+1'b1;
   AR,AW:run_rd_addr_o=ptr_a;
   BR,BW:run_rd_addr_o=ptr_b;
   UC:begin parent_we=1;parent_waddr=child_addr;parent_wdata=child_word;gap_we=1;gap_waddr=child_addr;end
   UR:begin parent_we=1;parent_waddr=parent_addr;parent_wdata=parent_word;gap_we=1;gap_waddr=parent_addr;end
   ROOTW:if(parent_data[12:0]==find_ptr)begin
    run_we_o=1;run_data_o={root_color,fill_record[23],
      ((!parent_data[17] || (!fill_record[23] && (gap_data[3:0]!=0))) &&
       (gap_data[3:0]<=gap_count_tolerance)),fill_record[21:0]};
   end
   default:begin end
  endcase
  if(cycles_o>=CYCLE_BUDGET)begin parent_we=0;run_we_o=0;end
 end
 always @(posedge clk)begin
  if(gap_we)gap_mem[gap_waddr]<=gap_child_word;
  gap_data<=gap_mem[gap_raddr];
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

// Three-bank, full-resolution background-run capture / CCL / replay.
// Results contain both the edge and interior of the SAME captured raster frame.
// Capacity/time failures discard the whole result and silently bypass to live
// extraction at a vertical-blank commit. No DDR access, no pixel backpressure.
//
// ROW_STEP=2 halves the stored row count: edges of rows (2k,2k+1) are OR-ed and
// captured as row k. A one-pixel horizontal contour therefore survives, while
// the run budget roughly doubles. Replay maps capture row k onto display rows
// 2k and 2k+1, so fills show a two-pixel vertical step.
module reference_fill_buffer #(
 parameter integer IMG_W=1280,IMG_H=720,MAX_RUNS=6144,CYCLE_BUDGET=1100000,
 parameter integer MIN_BG_RUN=1,ROW_STEP=1
)(
 input wire clk,rst_n,valid_i,user_i,last_i,frame_tick_i,edge_i,
 input wire [11:0] x_i,y_i,
 output wire available_o,output reg [23:0] pixel_o,
 output reg [31:0] display_frame_o,
 output wire [20:0] process_cycles_o,
 input wire cfg_valid_i,
 input wire [11:0] run_filter_threshold_i,
 input wire [11:0] closure_gap_tolerance_i,
 input wire [3:0] gap_count_tolerance_i,
 input wire [11:0] border_contact_tolerance_i,
 input wire [11:0] min_fill_width_i,
 output reg [12:0] run_count_o,
 output reg run_overflow_o
);
 localparam integer SHIFT=(ROW_STEP>=2)?1:0;
 localparam integer CAP_H=(IMG_H+(1<<SHIFT)-1)>>SHIFT;
 localparam FREE=0,CAPTURE=1,PENDING=2,PROCESS=3,READY=4,DISPLAY=5;
 reg [2:0] bank_state[0:2];reg [12:0] bank_count[0:2];reg [31:0] bank_seq[0:2];
 reg [31:0] frame_seq,bad_seq;reg bad_seen,fault_pending;
 reg [1:0] cap_bank,proc_bank,display_bank;reg cap_active,display_valid;
 reg [12:0] cap_count;reg in_run,cap_overflow;reg [10:0] run_start;
 reg [11:0] run_filter_threshold_eff,closure_gap_tolerance_eff,border_contact_tolerance_eff,min_fill_width_eff;
 reg [3:0] gap_count_tolerance_eff;
 reg free_found,pending_found,ready_found;reg [1:0] free_pick,proc_pick,ready_pick;
 integer k;
 function newer;input [31:0] a,b;begin newer=$signed(a-b)>0;end endfunction
 wire cc_busy,cc_done,cc_failed;
 wire proc_start=pending_found && !cc_busy && !cc_done;
 wire [12:0] cc_raddr,cc_waddr;wire [9:0] cc_maddr;wire cc_we;wire [25:0] cc_wdata;
 wire [25:0] run_data[0:2];wire [12:0] row_data[0:2];
 always @(*)begin
  free_found=0;pending_found=0;ready_found=0;free_pick=0;proc_pick=0;ready_pick=0;
  for(k=0;k<3;k=k+1)begin
   if(bank_state[k]==FREE && !free_found)begin free_found=1;free_pick=k;end
   if(bank_state[k]==PENDING && !pending_found)begin pending_found=1;proc_pick=k;end
   if((bank_state[k]==READY || (cc_done&&!cc_failed&&proc_bank==k)) &&
      (!bad_seen || newer(bank_seq[k],bad_seq)))begin
    if(!ready_found || newer(bank_seq[k],bank_seq[ready_pick]))begin ready_found=1;ready_pick=k;end
   end
  end
 end
 // ---- capture side -------------------------------------------------------
 // Only rows selected by ROW_STEP are stored. For ROW_STEP=2 the odd row is
 // captured together with the even row above it (OR), so the pair can only be
 // taken as a whole.
 reg row_buf[0:IMG_W-1]; // synthesis ram_style=distributed
 wire [11:0] cap_row_y=y_i>>SHIFT;
 wire cap_row_sel=valid_i && (SHIFT==0 || y_i[0]);
 wire prev_edge=(SHIFT==0 || !y_i[0]) ? 1'b0 : row_buf[x_i[10:0]];
 wire edge_eff=edge_i|prev_edge;
 wire capture_now=valid_i && (user_i ? free_found : cap_active) && (SHIFT==0 || y_i[0]);
 wire [1:0] capture_bank=user_i ? free_pick : cap_bank;
 wire [12:0] capture_count=user_i ? 13'd0 : cap_count;
 wire run_was_open=in_run;
 wire [10:0] capture_start=run_was_open ? run_start : x_i[10:0];
 wire emit_run=capture_now && ((edge_eff&&run_was_open)||(!edge_eff&&last_i));
 wire [10:0] capture_end=edge_eff ? x_i[10:0]-11'd1 : x_i[10:0];
 wire [11:0] capture_length={1'b0,capture_end}-{1'b0,capture_start}+12'd1;
 // Ignore very short background runs. They are usually isolated edge noise or
 // one-pixel contour gaps; dropping them reduces run pressure and closes small
 // leaks for the connected-component fill without changing live EXTRACT.
 wire store_run=emit_run && capture_count<MAX_RUNS && capture_length>=run_filter_threshold_eff;
 wire [12:0] next_count=capture_count+(store_run ? 13'd1:13'd0);
 wire capture_bad=(user_i ? 1'b0:cap_overflow)||
                  (emit_run&&capture_count>=MAX_RUNS&&capture_length>=run_filter_threshold_eff);
 wire capture_end_frame=capture_now && last_i && y_i==IMG_H-1;
 wire border_contact=cap_row_y==0 || cap_row_y==CAP_H-1 || capture_start==0 || capture_end==IMG_W-1;
 wire touches_border=border_contact && capture_length>border_contact_tolerance_eff;
 wire [25:0] capture_word={2'd0,touches_border,1'b0,capture_end,capture_start};
 always @(posedge clk) begin
  if(valid_i && SHIFT!=0 && !y_i[0]) row_buf[x_i[10:0]]<=edge_i;
 end
 always @(posedge clk or negedge rst_n)begin
  if(!rst_n)begin
   cap_active<=0;cap_bank<=0;cap_count<=0;in_run<=0;run_start<=0;cap_overflow<=0;
   run_filter_threshold_eff<=MIN_BG_RUN;closure_gap_tolerance_eff<=0;gap_count_tolerance_eff<=0;border_contact_tolerance_eff<=0;
   min_fill_width_eff<=0;
  end
  else begin
   if(valid_i&&user_i)begin
    if(cfg_valid_i)begin
     run_filter_threshold_eff<=run_filter_threshold_i;
     closure_gap_tolerance_eff<=closure_gap_tolerance_i;
     gap_count_tolerance_eff<=gap_count_tolerance_i;
     border_contact_tolerance_eff<=border_contact_tolerance_i;
     min_fill_width_eff<=min_fill_width_i;
    end else begin
     run_filter_threshold_eff<=MIN_BG_RUN;
     closure_gap_tolerance_eff<=0;
     gap_count_tolerance_eff<=0;
     border_contact_tolerance_eff<=0;
     min_fill_width_eff<=0;
    end
   end
   if(valid_i&&user_i)begin
    cap_active<=free_found;cap_bank<=free_pick;cap_count<=next_count;cap_overflow<=capture_bad;
    in_run<=!edge_eff&&!last_i;run_start<=x_i[10:0];
   end else if(capture_now)begin
    cap_count<=next_count;cap_overflow<=capture_bad;
    if(!edge_eff&&!run_was_open)run_start<=x_i[10:0];
    in_run<=!edge_eff&&!last_i;
   end else if(SHIFT!=0) begin
    in_run<=1'b0;
   end
   if(capture_end_frame)cap_active<=0;
  end
 end
 always @(posedge clk or negedge rst_n)begin
  if(!rst_n)begin
   for(k=0;k<3;k=k+1)begin bank_state[k]<=FREE;bank_count[k]<=0;bank_seq[k]<=0;end
   proc_bank<=0;display_bank<=0;display_valid<=0;display_frame_o<=0;
   run_count_o<=0;run_overflow_o<=0;
   frame_seq<=0;bad_seq<=0;bad_seen<=0;fault_pending<=0;
  end else begin
   // Stale results from before a discarded frame must never reappear.
   for(k=0;k<3;k=k+1)if(bank_state[k]==READY&&bad_seen&&!newer(bank_seq[k],bad_seq))bank_state[k]<=FREE;
   if(valid_i&&user_i)begin
    frame_seq<=frame_seq+1'b1;
    if(cap_active)bank_state[cap_bank]<=FREE; // interrupted capture, never publish partial data
    if(free_found)begin bank_state[free_pick]<=CAPTURE;bank_seq[free_pick]<=frame_seq+1'b1;end
    else begin bad_seen<=1;bad_seq<=frame_seq+1'b1;fault_pending<=1;end
   end
   if(capture_end_frame)begin
    bank_count[capture_bank]<=next_count;
    bank_state[capture_bank]<=capture_bad ? FREE:PENDING;
    run_count_o<=next_count;
    run_overflow_o<=capture_bad;
    if(capture_bad)begin bad_seen<=1;bad_seq<=bank_seq[capture_bank];fault_pending<=1;end
   end
   if(proc_start)begin proc_bank<=proc_pick;bank_state[proc_pick]<=PROCESS;end
   if(cc_done)begin
    bank_state[proc_bank]<=cc_failed ? FREE:READY;
    if(cc_failed)begin
     fault_pending<=1;
     if(!bad_seen||newer(bank_seq[proc_bank],bad_seq))begin bad_seen<=1;bad_seq<=bank_seq[proc_bank];end
    end
   end
   if(frame_tick_i)begin
    if(ready_found)begin
     if(display_valid)bank_state[display_bank]<=FREE;
     for(k=0;k<3;k=k+1)if(bank_state[k]==READY)bank_state[k]<=FREE;
     bank_state[ready_pick]<=DISPLAY;display_bank<=ready_pick;display_valid<=1;
     display_frame_o<=bank_seq[ready_pick];fault_pending<=0;
    end else if(fault_pending || (cc_done&&cc_failed))begin
     if(display_valid)bank_state[display_bank]<=FREE;
     display_valid<=0;fault_pending<=0;
    end
   end
  end
 end
 reference_fill_ccl #(.IMG_H(CAP_H),.MAX_RUNS(MAX_RUNS),.CYCLE_BUDGET(CYCLE_BUDGET)) ccl(
  .clk(clk),.rst_n(rst_n),.start_i(proc_start),.count_i(bank_count[proc_pick]),
  .busy_o(cc_busy),.done_o(cc_done),.failed_o(cc_failed),.cycles_o(process_cycles_o),
  .run_rd_addr_o(cc_raddr),.run_data_i(run_data[proc_bank]),.run_we_o(cc_we),
  .run_wr_addr_o(cc_waddr),.run_data_o(cc_wdata),.row_addr_o(cc_maddr),.row_data_i(row_data[proc_bank]),
  .closure_gap_i(closure_gap_tolerance_eff),.gap_count_tolerance_i(gap_count_tolerance_eff),
  .border_contact_tolerance_i(border_contact_tolerance_eff));
 // The production raster has 370 blank clocks per row. Six metadata clocks
 // plus a four-entry run prefetch queue fit well before the next active row.
 localparam D_HOLD=0,D_ROW0=1,D_ROW0W=2,D_ROW1=3,D_ROW1W=4,D_RUN=5;
 reg [2:0] display_state;reg [9:0] display_row;
 reg [12:0] fetch_ptr,row_end;
 reg [25:0] queue[0:3];reg [1:0] q_read,q_write;reg [2:0] q_count;reg read_pending;
 wire [9:0] raster_row=y_i>>SHIFT;
 wire request_run=display_state==D_RUN && display_valid && fetch_ptr<row_end &&
                  ({1'b0,q_count}+{3'd0,read_pending}<4);
 wire push_run=display_state==D_RUN && read_pending;
 wire pop_run=display_state==D_RUN && valid_i && raster_row==display_row && q_count!=0 &&
              x_i==queue[q_read][21:11];
 wire [9:0] display_maddr=(display_state==D_ROW1||display_state==D_ROW1W) ? display_row+1'b1:display_row;
 always @(posedge clk or negedge rst_n)begin
  if(!rst_n)begin
   display_state<=D_HOLD;display_row<=0;fetch_ptr<=0;row_end<=0;
   q_read<=0;q_write<=0;q_count<=0;read_pending<=0;
  end else if(frame_tick_i)begin
   display_row<=0;display_state<=D_ROW0;q_read<=0;q_write<=0;q_count<=0;read_pending<=0;
  end else if(valid_i&&last_i)begin
   display_row<=(y_i[9:0]+10'd1)>>SHIFT;
   display_state<=y_i==IMG_H-1 ? D_HOLD:D_ROW0;
   q_read<=0;q_write<=0;q_count<=0;read_pending<=0;
  end else begin
   read_pending<=request_run;
   case(display_state)
    D_ROW0:display_state<=D_ROW0W;
    D_ROW0W:begin fetch_ptr<=row_data[display_bank];display_state<=D_ROW1;end
    D_ROW1:display_state<=D_ROW1W;
    D_ROW1W:begin row_end<=row_data[display_bank];display_state<=D_RUN;end
    D_RUN:begin
     if(request_run)fetch_ptr<=fetch_ptr+1'b1;
     if(push_run)begin queue[q_write]<=run_data[display_bank];q_write<=q_write+1'b1;end
     if(pop_run)q_read<=q_read+1'b1;
     case({push_run,pop_run})
      2'b10:q_count<=q_count+1'b1;
      2'b01:q_count<=q_count-1'b1;
      default:begin end
     endcase
    end
    default:begin end
   endcase
  end
 end
 assign available_o=display_valid && display_state==D_RUN && raster_row==display_row;
 always @(*)begin
  pixel_o=24'hffffff;
  if(q_count!=0 && x_i>=queue[q_read][10:0] && x_i<=queue[q_read][21:11])
   if(queue[q_read][22] && (queue[q_read][21:11]-queue[q_read][10:0]+11'd1)>=min_fill_width_eff)begin
    case(queue[q_read][25:24])
     2'd0:pixel_o=24'hff3030;
     2'd1:pixel_o=24'h3080ff;
     default:pixel_o=24'h20c080;
    endcase
   end else pixel_o=24'd0;
 end
 genvar g;
 generate for(g=0;g<3;g=g+1)begin: g_store
  wire capturing=capture_now&&capture_bank==g;
  wire processing=(cc_busy||cc_done)&&proc_bank==g;
  wire [12:0] read_addr=processing ? cc_raddr:fetch_ptr;
  wire write_run=(capturing&&store_run)||(processing&&cc_we);
  wire [12:0] write_addr=capturing ? capture_count:cc_waddr;
  wire [25:0] write_data=capturing ? capture_word:cc_wdata;
  edge_fill_ram24 #(.DEPTH(MAX_RUNS)) records(.clk(clk),.we_i(write_run),.wr_addr_i(write_addr),
   .rd_addr_i(read_addr),.data_i(write_data),.data_o(run_data[g]));
  wire write_meta=((valid_i&&user_i&&free_found)||(capture_now&&last_i)) && (capture_bank==g);
  wire [9:0] write_row=(valid_i&&user_i) ? 10'd0:(cap_row_y+10'd1);
  wire [12:0] write_index=(valid_i&&user_i) ? 13'd0:next_count;
  // Row start/end metadata is only 13x361 bits per bank. Keep the same
  // synchronous one-clock read contract, but let TD map this small table to
  // distributed RAM instead of consuming one 20K ERAM per bank.
  reg [12:0] row_mem[0:CAP_H]; // synthesis ram_style=dram
  reg [12:0] row_data_reg;
  always @(posedge clk) begin
   if(write_meta) row_mem[write_row]<=write_index;
   row_data_reg<=row_mem[processing ? cc_maddr:display_maddr];
  end
  assign row_data[g]=row_data_reg;
 end endgenerate
endmodule
