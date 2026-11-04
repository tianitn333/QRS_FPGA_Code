// Independent activity flags, not a multi-bit counter crossing domains.
// Bits 0..7 retain the original VH meaning: IP init done, DMA released, source
// frame, W accepted, AR accepted, read returned, nonzero return, display data.
// Bit 8: recent DDR heartbeat. Bit 9: packed ISP valid in a recent source
// frame. Bits 10..15: user write, user read, queue pending, user ready,
// controller command ready, controller write-data ready.
// Activity/ready/pending flags mean "seen during the observation window",
// not instantaneous state. DDR flags age to zero after heartbeat loss;
// packed-valid ages to zero after source-frame loss. IP init and DMA release
// remain synchronized live levels, so they can stay high after DDR stops.
module ddr_video_status #(parameter LOCAL_BITS=20,WINDOW_BITS=25)(
 input rst_n,cam_clk,ddr_clk,pix_clk,source_frame_i,
 input calib_i,path_ready_i,write_i,read_i,return_i,return_nonzero_i,pixel_nonzero_i,
 input packed_valid_i,user_write_i,user_read_i,queue_pending_i,
 input user_ready_i,app_ready_i,wdf_ready_i,
 output reg [15:0] status_o
);
 reg source_toggle,packed_seen,packed_flag;
 always @(posedge cam_clk or negedge rst_n)
  if(!rst_n)begin source_toggle<=0;packed_seen<=0;packed_flag<=0;end
  else if(source_frame_i)begin
   source_toggle<=~source_toggle;
   packed_flag<=packed_seen|packed_valid_i;
   packed_seen<=packed_valid_i;
  end else packed_seen<=packed_seen|packed_valid_i;
 reg [LOCAL_BITS-1:0] local_count;
 reg [9:0] local_seen,local_flags;reg heartbeat;
 wire [9:0] events={wdf_ready_i,app_ready_i,user_ready_i,queue_pending_i,
   user_read_i,user_write_i,return_nonzero_i,return_i,read_i,write_i};
 always @(posedge ddr_clk or negedge rst_n)
  if(!rst_n)begin local_count<=0;local_seen<=0;local_flags<=0;heartbeat<=0;end
  else begin
   local_count<=local_count+1'b1;
   if(&local_count)begin local_flags<=local_seen|events;local_seen<=0;heartbeat<=~heartbeat;end
   else local_seen<=local_seen|events;
  end
 (* async_reg="true" *) reg [14:0] meta,level;
 wire [14:0] flags={source_toggle,packed_flag,heartbeat,local_flags,path_ready_i,calib_i};
 reg [WINDOW_BITS-1:0] window_count;reg [9:0] ddr_seen;
 reg source_old,beat_old,source_seen,beat_seen,pixel_seen,packed_window_seen;
 wire source_recent=source_seen|(source_old!=level[14]);
 wire ddr_recent=beat_seen|(beat_old!=level[12]);
 wire [9:0] recent_events=ddr_seen|level[11:2];
 always @(posedge pix_clk or negedge rst_n)
  if(!rst_n)begin meta<=0;level<=0;window_count<=0;ddr_seen<=0;
   source_old<=0;beat_old<=0;source_seen<=0;beat_seen<=0;pixel_seen<=0;packed_window_seen<=0;status_o<=0;end
  else begin
   meta<=flags;level<=meta;source_old<=level[14];beat_old<=level[12];
   window_count<=window_count+1'b1;
   if(&window_count)begin
    status_o<={ddr_recent?recent_events[9:4]:6'b0,
      source_recent&&(packed_window_seen|level[13]),ddr_recent,
      pixel_seen|pixel_nonzero_i,ddr_recent?recent_events[3:0]:4'b0,
      source_recent,level[1:0]};
    source_seen<=0;beat_seen<=0;pixel_seen<=0;ddr_seen<=0;packed_window_seen<=0;
   end else begin
    source_seen<=source_recent;beat_seen<=ddr_recent;
    pixel_seen<=pixel_seen|pixel_nonzero_i;ddr_seen<=recent_events;
    packed_window_seen<=packed_window_seen|level[13];
   end
  end
endmodule
