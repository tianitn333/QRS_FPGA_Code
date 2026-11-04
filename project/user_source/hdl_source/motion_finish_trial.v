// Camera-source-frame experiment: one pixel per four-pixel AWB beat.
// Native vertical resolution; three 48x64 ROIs sampled to 12x64, step 56 pixels.
// This is a reduced experimental contract, not the full-resolution Python model.
// READY requires a complete source frame, AE hold ACK, settling and empty learning.
module motion_finish_trial #(
 parameter integer IMAGE_WIDTH=1280, IMAGE_HEIGHT=720,
 parameter integer SETTLE_FRAMES=2, LEARN_FRAMES=16, CHECK_FRAMES=4, EXTERNAL_SOURCE_ID=0, HORIZONTAL_ENABLE=0,
 parameter integer UNIQUE_RANK_ENABLE=0 // 本候选置1：同源帧以L1/L2/L3顺序产生唯一名次。
)(
 input wire clk,rst_n,
 input wire valid_i,user_i, input wire [95:0] rgb_i,
 input wire [63:0] config_i,
 input wire hold_ack_i,
 output wire hold_o,
 output wire [191:0] status_o,
 input wire [31:0] source_i,
 output wire [31:0] race_o,
 output wire active_o,
 output wire [26:0] geometry_o,
 output reg decision_o,
 output reg [31:0] decision_source_o,decision_race_o,
 output reg [2:0] decision_mask_o,
 output reg decision_good_o
);
 localparam integer WORDS=IMAGE_WIDTH/4, BEATS=WORDS*IMAGE_HEIGHT;
 localparam [2:0] IDLE=0,PREPARE=1,READY=2,RUNNING=3,RESULTS=4,INVALID=5;
 localparam [2:0] W_IDLE=0,W_READ=1,W_WAIT=2,W_CALC=3,W_NEXT=4,W_FINISH=5,W_COMMIT=6,W_VALIDATE=7;
 reg [2:0] state,worker;
 reg [3:0] fault;
 reg [8:0] word_x;
 reg [9:0] pixel_y;
 reg [18:0] beat_count;
 reg frame_seen,command_primed,capture_enable,capture_bank;
 reg analysis_started,complete_frame;
 reg [7:0] command_seen,prepare_count,hold_wait;
 reg [31:0] source_id,analysis_source,race_serial;
 reg [23:0] watchdog;
 reg [10:0] base_x;
 reg [9:0] base_y;
 reg [5:0] line_row;
 reg [7:0] motion_threshold,foreground_threshold;
 wire config_enable=config_i[63];
 wire [7:0] config_command=config_i[62:55];
 wire [10:0] config_x=config_i[54:44];
 wire [9:0] config_y=config_i[43:34];
 wire [5:0] config_line=config_i[33:28];
 wire [7:0] config_motion=config_i[27:20],config_foreground=config_i[19:12];
 wire command_new=config_command!=command_seen;
 wire state_active=state==PREPARE || state==READY || state==RUNNING;
 wire [8:0] current_x=user_i?9'd0:word_x;
 wire [9:0] current_y=user_i?10'd0:pixel_y;
 wire [8:0] relative_x=current_x-base_x[10:2];
 wire [9:0] relative_y=current_y-base_y;
 // Horizontal specialization preserves the existing 64 x 3 x 12 RAM scan.
 wire [9:0] upper_lane_y=base_y-10'd416;
 wire [9:0] middle_lane_y=base_y-10'd208;
 wire [9:0] relative_upper_y=current_y-upper_lane_y;
 wire [9:0] relative_middle_y=current_y-middle_lane_y;
 wire in_bottom_lane=relative_y<96;
 wire in_middle_lane=relative_middle_y<96;
 wire in_upper_lane=relative_upper_y<96;
 wire [1:0] capture_lane=in_bottom_lane?2'd0:(in_middle_lane?2'd1:2'd2);
 wire [9:0] capture_cross_y=in_bottom_lane?relative_y:(in_middle_lane?relative_middle_y:relative_upper_y);
 wire [5:0] capture_motion_bin=relative_x[6:1];
 wire [11:0] capture_motion_offset={1'b0,capture_motion_bin,5'b0}+{4'b0,capture_motion_bin,2'b0};
 wire [11:0] capture_lane_offset=capture_lane==0?12'd0:(capture_lane==1?12'd12:12'd24);
 wire [11:0] horizontal_address=capture_motion_offset+capture_lane_offset+{8'd0,capture_cross_y[6:3]};
 reg [11:0] address_first,address_second;
 reg [11:0] capture_count;
 wire [11:0] write_address=HORIZONTAL_ENABLE?address_second:capture_count;
 wire [9:0] guard_y=base_y-10'd464;
 wire horizontal_guard_row=current_y>=guard_y && current_y<guard_y+8;
 wire horizontal_sample=relative_x<128 && !relative_x[0] &&
                        (in_bottom_lane || in_middle_lane || in_upper_lane) && capture_cross_y[2:0]==0;
 wire in_row=HORIZONTAL_ENABLE?horizontal_sample:(relative_y<64);
 wire in_lane=HORIZONTAL_ENABLE?1'b1:((relative_x<12)||((relative_x>=14)&&(relative_x<26))||((relative_x>=28)&&(relative_x<40)));
 wire in_guard_left=(current_x>=base_x[10:2]-4)&&(current_x<base_x[10:2]-2)&&(HORIZONTAL_ENABLE?horizontal_guard_row:(relative_y<8));
 wire in_guard_right=HORIZONTAL_ENABLE?((relative_x>=130)&&(relative_x<132)&&horizontal_guard_row):((relative_x>=42)&&(relative_x<44)&&(relative_y<8));
 // Shift/add luma products are registered before summation. Tags share both stages.
 reg [15:0] product_r,product_g,product_b,gray_sum;
 reg [2:0] tag_first,tag_second;
 reg [11:0] guard_left_sum,guard_right_sum;
 reg [4:0] guard_left_count,guard_right_count;
 wire [7:0] captured_gray=gray_sum[15:8];
 wire capture_write=tag_second[0] && capture_enable && worker==W_IDLE && capture_count<2304;
 wire [12:0] guard_total={1'b0,guard_left_sum}+{1'b0,guard_right_sum}+13'd16;
 wire [7:0] guard_mean=guard_total[12:5];
 reg [7:0] previous_guard,background_guard;
 reg signed [9:0] motion_shift,foreground_shift;
 reg [11:0] scan_address;
 reg [3:0] scan_column;
 reg [1:0] scan_lane;
 reg [5:0] scan_row;
 reg [3:0] horizontal_run;
 reg row_supported;
 reg [1:0] good_rows [0:2];
 reg [5:0] fronts [0:2],previous_front [0:2];
 reg [2:0] front_valid,previous_valid,before_line,arrived;
 reg [1:0] approach_steps [0:2],ranks [0:2];
 reg [10:0] motion_area [0:2];
 reg [10:0] foreground_area [0:2];
 reg [31:0] arrival_frame [0:2];
 reg [2:0] arrival_mask;
 reg [7:0] back_write_data;
 wire [7:0] bank_zero_data,bank_one_data,back_data;
 wire [7:0] cur_data=capture_bank?bank_one_data:bank_zero_data;
 wire [7:0] prev_data=capture_bank?bank_zero_data:bank_one_data;
 wire back_write=worker==W_NEXT && state==PREPARE && prepare_count<SETTLE_FRAMES+LEARN_FRAMES;
 motion_gray_ram current_zero (.clk(clk),.we_i(capture_write&&!capture_bank),
  .wr_addr_i(write_address),.rd_addr_i(scan_address),.data_i(captured_gray),.data_o(bank_zero_data));
 motion_gray_ram current_one (.clk(clk),.we_i(capture_write&&capture_bank),
  .wr_addr_i(write_address),.rd_addr_i(scan_address),.data_i(captured_gray),.data_o(bank_one_data));
 motion_gray_ram empty_background (.clk(clk),.we_i(back_write),
  .wr_addr_i(scan_address),.rd_addr_i(scan_address),.data_i(back_write_data),.data_o(back_data));
 reg signed [10:0] motion_residual,foreground_residual;
 reg [10:0] motion_abs,foreground_abs;
 reg motion_pixel,foreground_pixel;
 reg signed [9:0] ema_difference;
 reg [8:0] ema_amount;
 reg [1:0] finished_rank;
 integer lane;
 always @* begin
  motion_residual=$signed({3'd0,cur_data})-$signed({3'd0,prev_data})-motion_shift;
  foreground_residual=$signed({3'd0,cur_data})-$signed({3'd0,back_data})-foreground_shift;
  motion_abs=motion_residual[10]?-motion_residual:motion_residual;
  foreground_abs=foreground_residual[10]?-foreground_residual:foreground_residual;
  motion_pixel=motion_abs>{3'd0,motion_threshold};
  foreground_pixel=foreground_abs>{3'd0,foreground_threshold};
  ema_difference=$signed({2'd0,cur_data})-$signed({2'd0,back_data});
  ema_amount=ema_difference[9]?((-ema_difference+10'd2)>>2):((ema_difference+10'd2)>>2);
  finished_rank={1'b0,arrived[0]}+{1'b0,arrived[1]}+{1'b0,arrived[2]}+2'd1;
 end
 assign race_o=race_serial;
 assign active_o=state_active;
 assign geometry_o={base_x,base_y,line_row};
 assign hold_o=state==PREPARE || state==READY || state==RUNNING || state==RESULTS;
 assign status_o={30'd0,state,fault,arrived,ranks[2],ranks[1],ranks[0],
                  fronts[2],fronts[1],fronts[0],source_id,
                  arrival_frame[2],arrival_frame[1],arrival_frame[0]};
 always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
   state<=IDLE;worker<=W_IDLE;fault<=0;word_x<=0;pixel_y<=0;beat_count<=0;
   race_serial<=0;decision_o<=0;decision_source_o<=0;decision_race_o<=0;decision_mask_o<=0;decision_good_o<=0;
   frame_seen<=0;command_primed<=0;capture_enable<=0;capture_bank<=0;command_seen<=0;
   analysis_started<=0;complete_frame<=0;
   prepare_count<=0;hold_wait<=0;source_id<=0;analysis_source<=0;watchdog<=0;
   base_x<=HORIZONTAL_ENABLE?160:664;base_y<=HORIZONTAL_ENABLE?512:186;line_row<=HORIZONTAL_ENABLE?40:47;motion_threshold<=20;foreground_threshold<=24;
   product_r<=0;product_g<=0;product_b<=0;gray_sum<=0;tag_first<=0;tag_second<=0;address_first<=0;address_second<=0;
   capture_count<=0;guard_left_sum<=0;guard_right_sum<=0;guard_left_count<=0;guard_right_count<=0;
   previous_guard<=0;background_guard<=0;motion_shift<=0;foreground_shift<=0;
   scan_address<=0;scan_column<=0;scan_lane<=0;scan_row<=0;horizontal_run<=0;row_supported<=0;
   front_valid<=0;previous_valid<=0;before_line<=0;arrived<=0;arrival_mask<=0;back_write_data<=0;
   for(lane=0;lane<3;lane=lane+1) begin
    good_rows[lane]<=0;fronts[lane]<=0;previous_front[lane]<=0;approach_steps[lane]<=0;
    ranks[lane]<=0;motion_area[lane]<=0;foreground_area[lane]<=0;arrival_frame[lane]<=0;
   end
  end else begin
   decision_o<=0;
   product_r<=rgb_i[23:16]*16'd77;
   product_g<=rgb_i[15:8]*16'd150;
   product_b<=rgb_i[7:0]*16'd29;
   gray_sum<=product_r+product_g+product_b+16'd128;
   tag_first<={valid_i&&in_guard_right,valid_i&&in_guard_left,valid_i&&in_row&&in_lane};
   tag_second<=tag_first;address_first<=horizontal_address;address_second<=address_first;
   if(capture_write) capture_count<=capture_count+1'b1;
   if(capture_enable && tag_second[1]) begin guard_left_sum<=guard_left_sum+captured_gray;guard_left_count<=guard_left_count+1'b1;end
   if(capture_enable && tag_second[2]) begin guard_right_sum<=guard_right_sum+captured_gray;guard_right_count<=guard_right_count+1'b1;end
   if(user_i) watchdog<=0;
   else if(state_active) begin
    if(&watchdog) begin state<=INVALID;fault<=4'd7;capture_enable<=0;end
    else watchdog<=watchdog+1'b1;
   end
   if(user_i) begin
    source_id<=EXTERNAL_SOURCE_ID?source_i:source_id+1'b1;frame_seen<=1;beat_count<=valid_i?1:0;
    word_x<=valid_i?1:0;pixel_y<=0;
    capture_count<=0;guard_left_sum<=0;guard_right_sum<=0;guard_left_count<=0;guard_right_count<=0;
    capture_enable<=state_active && (state!=PREPARE || hold_ack_i);
    analysis_started<=0;
    if(!command_primed) begin command_seen<=config_command;command_primed<=1;end
    if(!config_enable) begin state<=IDLE;fault<=0;capture_enable<=0;worker<=W_IDLE;command_seen<=config_command;end
    else if(command_primed && command_new) begin
     command_seen<=config_command;capture_enable<=0;worker<=W_IDLE;complete_frame<=0;
     if(state_active && worker!=W_IDLE)begin
      decision_o<=1;decision_source_o<=analysis_source;decision_race_o<=race_serial;
      decision_mask_o<=0;decision_good_o<=0;
     end
     if(state_active) state<=RESULTS;
     else if(config_x<16 || config_x>(HORIZONTAL_ENABLE?752:1096) || config_x[1:0]!=0 || config_y<(HORIZONTAL_ENABLE?472:8) || config_y>(HORIZONTAL_ENABLE?616:640) || config_line<8 || config_line>55) begin state<=INVALID;fault<=4'd6;end
     else begin
      state<=PREPARE;fault<=0;prepare_count<=0;hold_wait<=0;capture_bank<=0;race_serial<=race_serial+1'b1;
      base_x<=config_x;base_y<=config_y;line_row<=config_line;
      motion_threshold<=config_motion;foreground_threshold<=config_foreground;
      previous_valid<=0;before_line<=0;arrived<=0;front_valid<=0;arrival_mask<=0;
      for(lane=0;lane<3;lane=lane+1) begin
       approach_steps[lane]<=0;ranks[lane]<=0;arrival_frame[lane]<=0;
      end
     end
    end else if(state_active && frame_seen && beat_count!=BEATS) begin
     state<=INVALID;fault<=4'd1;capture_enable<=0;worker<=W_IDLE;
    end else if(state==PREPARE && !hold_ack_i) begin
     prepare_count<=0;capture_enable<=0;
     if(hold_wait==120) begin state<=INVALID;fault<=4'd3;end else hold_wait<=hold_wait+1'b1;
    end
   end else if(valid_i && frame_seen) begin
    if(word_x==WORDS-1) begin word_x<=0;pixel_y<=pixel_y+1'b1;end else word_x<=word_x+1'b1;
    if(beat_count<BEATS+1) beat_count<=beat_count+1'b1;
    if(beat_count==BEATS && state_active) begin state<=INVALID;fault<=4'd1;capture_enable<=0;end
    if(beat_count==BEATS-1 && (!analysis_started || fault!=0))begin
     decision_o<=1;decision_source_o<=source_id;decision_race_o<=race_serial;
     decision_mask_o<=0;decision_good_o<=fault==0;
    end
    if(beat_count==BEATS-1 && capture_enable) begin
     capture_enable<=0;
     if(capture_count!=2304 || guard_left_count!=16 || guard_right_count!=16) begin state<=INVALID;fault<=4'd1;worker<=W_IDLE;end
     else if(state==PREPARE && prepare_count<SETTLE_FRAMES) begin prepare_count<=prepare_count+1'b1;previous_guard<=guard_mean;end
     else complete_frame<=1;
    end
   end
   // Capture ends near the finish line, not at the end of the entire image.
   // No bank role is exchanged until the captured frame has been validated.
   if(!user_i && state_active && fault==0 && capture_enable && !analysis_started &&
      capture_count==2304 && worker==W_IDLE && !(state==PREPARE && prepare_count<SETTLE_FRAMES)) begin
    analysis_started<=1;complete_frame<=0;
    if(guard_left_count!=16 || guard_right_count!=16) begin state<=INVALID;fault<=4'd1;capture_enable<=0;end
    else if(state!=PREPARE && (($signed({2'd0,guard_mean})-$signed({2'd0,previous_guard})>18)||
       ($signed({2'd0,previous_guard})-$signed({2'd0,guard_mean})>18))) begin state<=INVALID;fault<=4'd4;capture_enable<=0;end
    else begin
     worker<=W_READ;scan_address<=0;scan_row<=0;scan_lane<=0;scan_column<=0;
     horizontal_run<=0;row_supported<=0;front_valid<=0;arrival_mask<=0;analysis_source<=source_id;
     motion_shift<=$signed({2'd0,guard_mean})-$signed({2'd0,previous_guard});
     foreground_shift<=$signed({2'd0,guard_mean})-$signed({2'd0,background_guard});
     previous_guard<=guard_mean;
     if(state==PREPARE && prepare_count<SETTLE_FRAMES+LEARN_FRAMES) background_guard<=guard_mean;
     for(lane=0;lane<3;lane=lane+1) begin good_rows[lane]<=0;motion_area[lane]<=0;foreground_area[lane]<=0;fronts[lane]<=0;end
    end
   end
   if((state==READY || state==RUNNING) && !hold_ack_i) begin state<=INVALID;fault<=4'd3;capture_enable<=0;worker<=W_IDLE;end
   // Start/stop/disable and invalid-source events cancel the old worker.
   // An ordinary next-frame user pulse may overlap the preceding analysis.
   if(state_active && fault==0 && !(user_i && (!config_enable || command_new ||
      (frame_seen && beat_count!=BEATS)))) begin
   case(worker)
    W_IDLE: begin end
    W_READ: worker<=W_WAIT;
    W_WAIT: worker<=W_CALC;
    W_CALC: begin
     if(state==PREPARE && prepare_count==SETTLE_FRAMES) back_write_data<=cur_data;
     else if(ema_difference[9]) back_write_data<=back_data-ema_amount[7:0];
     else back_write_data<=back_data+ema_amount[7:0];
     if(foreground_pixel) begin
      if(horizontal_run<12) horizontal_run<=horizontal_run+1'b1;
      if(horizontal_run>=1) row_supported<=1;
     end else horizontal_run<=0;
     if(motion_pixel && foreground_pixel && motion_area[scan_lane]!=2047) motion_area[scan_lane]<=motion_area[scan_lane]+1'b1;
     if(foreground_pixel && foreground_area[scan_lane]!=2047) foreground_area[scan_lane]<=foreground_area[scan_lane]+1'b1;
     worker<=W_NEXT;
    end
    W_NEXT: begin
     if(scan_column==11) begin
      if(row_supported) begin
       if(good_rows[scan_lane]<3) good_rows[scan_lane]<=good_rows[scan_lane]+1'b1;
       if(good_rows[scan_lane]>=2) begin
        front_valid[scan_lane]<=1;
        if(!HORIZONTAL_ENABLE)fronts[scan_lane]<=scan_row;
        else if(!front_valid[scan_lane])fronts[scan_lane]<=scan_row-6'd2;
       end
      end else good_rows[scan_lane]<=0;
      horizontal_run<=0;row_supported<=0;scan_column<=0;
      if(scan_lane==2) begin scan_lane<=0;scan_row<=scan_row+1'b1;end else scan_lane<=scan_lane+1'b1;
     end else scan_column<=scan_column+1'b1;
     if(scan_address==2303) worker<=W_VALIDATE;
     else begin scan_address<=scan_address+1'b1;worker<=W_READ;end
    end
    W_VALIDATE: if(complete_frame)worker<=W_FINISH;
    W_FINISH: begin
     if(state==PREPARE) begin
      prepare_count<=prepare_count+1'b1;
      if(prepare_count>=SETTLE_FRAMES+LEARN_FRAMES+CHECK_FRAMES-1) state<=READY;
      if(prepare_count>=SETTLE_FRAMES+LEARN_FRAMES &&
         (foreground_area[0]>76 || foreground_area[1]>76 || foreground_area[2]>76)) begin
       state<=INVALID;fault<=4'd8;
      end
     end else if(state==READY || state==RUNNING) begin
      for(lane=0;lane<3;lane=lane+1) begin
       if(!arrived[lane]) begin
        if(front_valid[lane]) begin
         if(HORIZONTAL_ENABLE)begin
          // The smallest supported X bin is the leading edge for right-to-left motion.
          if({fronts[lane],3'b0}>={3'd0,line_row}+9'd130)before_line[lane]<=1;
          previous_front[lane]<=fronts[lane];previous_valid[lane]<=1;
          if(previous_valid[lane] && fronts[lane]<previous_front[lane] && motion_area[lane]>=3)begin
           if(previous_front[lane]-fronts[lane]>16)begin state<=INVALID;fault<=4'd5;end
           else begin
            if(approach_steps[lane]<2)approach_steps[lane]<=approach_steps[lane]+1'b1;
            if(before_line[lane] && approach_steps[lane]>=1 && {fronts[lane],3'b0}<={3'd0,line_row}+9'd128)arrival_mask[lane]<=1;
            if(before_line[lane] && approach_steps[lane]>=1)state<=RUNNING;
           end
          end else if(previous_valid[lane] && fronts[lane]>previous_front[lane])approach_steps[lane]<=0;
          if(before_line[lane] && approach_steps[lane]>=2 && {fronts[lane],3'b0}<={3'd0,line_row}+9'd128)arrival_mask[lane]<=1;
         end else begin
         if(fronts[lane]+2<=line_row) before_line[lane]<=1;
         previous_front[lane]<=fronts[lane];previous_valid[lane]<=1;
         if(previous_valid[lane] && fronts[lane]>previous_front[lane] && motion_area[lane]>=3) begin
          if(fronts[lane]-previous_front[lane]>20) begin state<=INVALID;fault<=4'd5;end
          else begin
           if(approach_steps[lane]<2) approach_steps[lane]<=approach_steps[lane]+1'b1;
           if(before_line[lane] && approach_steps[lane]>=1 && fronts[lane]>=line_row) arrival_mask[lane]<=1;
           if(before_line[lane] && approach_steps[lane]>=1) state<=RUNNING;
          end
         end else if(previous_valid[lane] && fronts[lane]<previous_front[lane]) approach_steps[lane]<=0;
         // Once approach is established, foreground supports touch-and-stop.
         if(before_line[lane] && approach_steps[lane]>=2 && fronts[lane]>=line_row) arrival_mask[lane]<=1;
         end
        end else begin previous_valid[lane]<=0;before_line[lane]<=0;approach_steps[lane]<=0;end
       end
      end
     end
     worker<=W_COMMIT;
    end
    W_COMMIT: begin
     decision_o<=1;decision_source_o<=analysis_source;decision_race_o<=race_serial;
     decision_good_o<=state!=INVALID && fault==0;
     decision_mask_o<=(state!=INVALID && fault==0)?(arrival_mask & ~arrived):3'd0;
     if(fault!=0)state<=INVALID;
     if(state!=INVALID && fault==0) begin
      for(lane=0;lane<3;lane=lane+1) if(arrival_mask[lane] && !arrived[lane]) begin
       arrived[lane]<=1;arrival_frame[lane]<=analysis_source;
       if(UNIQUE_RANK_ENABLE)begin
        case(lane)
         0:ranks[lane]<=finished_rank;
         1:ranks[lane]<=finished_rank+{1'b0,(arrival_mask[0] && !arrived[0])};
         default:ranks[lane]<=finished_rank+{1'b0,(arrival_mask[0] && !arrived[0])}+{1'b0,(arrival_mask[1] && !arrived[1])};
        endcase
       end else ranks[lane]<=finished_rank;
      end
      if((arrived|arrival_mask)==3'b111) state<=RESULTS;
     end
     capture_bank<=~capture_bank;worker<=W_IDLE;complete_frame<=0;
    end
    default: begin worker<=W_IDLE;state<=INVALID;fault<=4'd2;end
   endcase
   end
   if(state==INVALID && worker!=W_IDLE)begin
    decision_o<=1;decision_source_o<=analysis_source;decision_race_o<=race_serial;
    decision_mask_o<=0;decision_good_o<=0;worker<=W_IDLE;
   end
   if(user_i && frame_seen && beat_count!=BEATS)begin
    decision_o<=1;decision_source_o<=source_id;decision_race_o<=race_serial;
    decision_mask_o<=0;decision_good_o<=0;
   end
   // ERROR2 now denotes a real attempted bank collision, not a short VBLANK.
   if(state_active && capture_enable && tag_second[0] && worker!=W_IDLE) begin
    state<=INVALID;fault<=4'd2;capture_enable<=0;worker<=W_IDLE;complete_frame<=0;
   end
  end
 end
endmodule
