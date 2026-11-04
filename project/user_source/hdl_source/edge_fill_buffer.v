// Three-bank, full-resolution background-run capture / CCL / replay.
// Results contain both the edge and interior of the SAME captured raster frame.
// Capacity/time failures discard the whole result and silently bypass to live
// extraction at a vertical-blank commit. No DDR access, no pixel backpressure.
//
// ROW_STEP=2 halves the stored row count: edges of rows (2k,2k+1) are OR-ed and
// captured as row k. A one-pixel horizontal contour therefore survives, while
// the run budget roughly doubles. Replay maps capture row k onto display rows
// 2k and 2k+1, so fills show a two-pixel vertical step.
module edge_fill_buffer #(
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
 // Prefetch the next x from synchronous ERAM. At the consuming clock,
 // previous_row_edge already holds the current x; blank clocks preserve the
 // prefetched address. last_i prefetches x=0 for the next raster row.
 wire previous_row_edge;
 generate if(SHIFT!=0)begin: g_previous_row
  reg [10:0] held_read_address;
  wire [10:0] read_address=valid_i ? (last_i ? 11'd0:x_i[10:0]+11'd1):held_read_address;
  always @(posedge clk or negedge rst_n)begin
   if(!rst_n)held_read_address<=0;
   else if(valid_i)held_read_address<=read_address;
  end
  // One 9x2048 ERAM holds the 1280 one-bit samples. The lookahead and
  // blank-clock address hold are unchanged; only bit zero is meaningful.
  wire [8:0] previous_row_word;
  assign previous_row_edge=previous_row_word[0];
  PH1P_LOGIC_ERAM #(.DATA_WIDTH_A(9),.DATA_WIDTH_B(9),.ADDR_WIDTH_A(11),.ADDR_WIDTH_B(11),
   .DATA_DEPTH_A(2048),.DATA_DEPTH_B(2048),.MODE("DP"),.REGMODE_A("NOREG"),.REGMODE_B("NOREG"),
   .WRITEMODE_A("NORMAL"),.WRITEMODE_B("NORMAL"),.IMPLEMENT("20K(FAST)"),
   .ECC_ENCODE("DISABLE"),.ECC_DECODE("DISABLE"),.CLKMODE("ASYNC"),.SSROVERCE("DISABLE"),
   .OREGSET_A("RESET"),.OREGSET_B("RESET"),.RESETMODE_A("ASYNC"),.RESETMODE_B("ASYNC"),
   .ASYNC_RESET_RELEASE_A("ASYNC"),.ASYNC_RESET_RELEASE_B("ASYNC"),.INIT_FILE("NONE"),.FILL_ALL("NONE")) edge_row(
   .dia({8'd0,edge_i}),.addra(x_i[10:0]),.cea(1'b1),.clka(clk),
   .wea(rst_n&&valid_i&&!y_i[0]),.bea(1'b0),.rsta(1'b0),.ocea(1'b0),.doa(),
   .dib(9'd0),.addrb(read_address),.ceb(1'b1),.clkb(clk),.web(1'b0),.beb(1'b0),
   .rstb(1'b0),.oceb(1'b0),.dob(previous_row_word),
   .ecc_sbiterr(),.ecc_dbiterr(),.ecc_sbiterrinj(1'b0),.ecc_dbiterrinj(1'b0));
 end else begin: g_no_previous_row
  assign previous_row_edge=1'b0;
 end endgenerate
 wire [11:0] cap_row_y=y_i>>SHIFT;
 wire cap_row_sel=valid_i && (SHIFT==0 || y_i[0]);
 wire prev_edge=(SHIFT==0 || !y_i[0]) ? 1'b0 : previous_row_edge;
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
 edge_fill_ccl #(.IMG_H(CAP_H),.MAX_RUNS(MAX_RUNS),.CYCLE_BUDGET(CYCLE_BUDGET)) ccl(
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
  // Use one ERAM for each row-index table. The read remains synchronous
  // with exactly one clock of latency, preserving capture/CCL/replay timing.
  image_eram #(.WIDTH(13),.DEPTH(CAP_H+1),.ADDR_WIDTH(10)) row_indices(
   .clk(clk),.we_i(write_meta),.wr_addr_i(write_row),.data_i(write_index),
   .rd_addr_i(processing ? cc_maddr:display_maddr),.data_o(row_data[g]));
 end endgenerate
endmodule
