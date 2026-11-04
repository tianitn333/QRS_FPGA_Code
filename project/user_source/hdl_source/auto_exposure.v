// Four-pixel camera-domain adaptive AEC. Total exposure is half-line * gain_Q5 * 2**DG.
module auto_exposure #(
 parameter integer MOTION_HOLD_ENABLE=0,
 parameter integer IMG_WIDTH=1280,IMG_HEIGHT=720,STAT_DECIM=16,
 parameter integer TGT_LUMA=72,HYST=5,AE_MIN=4,AE_MAX=1990,
 parameter integer AE_INIT=1990,ANA_INIT=64,DIG_INIT=0,
 parameter integer ANA_MAX=127,DIG_MAX=3,SETTLE_FRAMES=2
)(
 input pix_clk,pix_rst_n,valid_i,user_i,input [95:0] rgb_i,
 input cfg_clk,cfg_rst_n,cfg_ready,cfg_done_i,cfg_error_i,
 output reg ae_req_o,output reg [15:0] ae_o,ana_o,dig_o,luma_o,
 input wire hold_req_i, output wire hold_ack_o,
 output reg [3:0] state_o
);
 localparam FRAME_BEATS=IMG_WIDTH*IMG_HEIGHT/4;
 localparam INIT=0,IDLE=1,MEAN=2,RATIO=3,TARGET=4,ALLOC=5,SCAN=6,COMMIT=7,WRITE=8,ERROR=9;
 function [9:0] gain_q5;
 input [6:0] i;
 begin gain_q5=(10'd32+{5'd0,i[4:0]}) << i[6:5];end
 endfunction
 function [7:0] lum;
 input [23:0] p;reg [9:0] sum;
 begin sum={2'b0,p[23:16]}+{2'b0,p[15:8]}+{2'b0,p[7:0]};lum=sum[9:2];end
 endfunction
 localparam [31:0] E_MIN=AE_MIN*32,E_MAX=AE_MAX*((32+(ANA_MAX%32))<<(ANA_MAX/32))*(1<<DIG_MAX);
 wire [7:0] y0=lum(rgb_i[23:0]),y1=lum(rgb_i[47:24]),y2=lum(rgb_i[71:48]),y3=lum(rgb_i[95:72]);
 wire [9:0] beat_sum={2'b0,y0}+{2'b0,y1}+{2'b0,y2}+{2'b0,y3};
 wire [2:0] beat_dark={2'b0,(y0<=8)}+{2'b0,(y1<=8)}+{2'b0,(y2<=8)}+{2'b0,(y3<=8)};
 wire [2:0] beat_bright={2'b0,(y0>=180)}+{2'b0,(y1>=180)}+{2'b0,(y2>=180)}+{2'b0,(y3>=180)};
 reg arm;
 (* async_reg="true" *) reg arm1,arm2;
 reg epoch,active;reg [7:0] settle;
 reg [31:0] beats,decim,acc,cnt,dark,bright;
 reg stat_send;reg [128:0] stat_packet;wire stat_ready,stat_valid;wire [128:0] stats;
 always @(posedge pix_clk or negedge pix_rst_n)
 if(!pix_rst_n) begin
  arm1<=0;arm2<=0;epoch<=0;active<=0;settle<=SETTLE_FRAMES;
  beats<=0;decim<=0;acc<=0;cnt<=0;dark<=0;bright<=0;stat_send<=0;stat_packet<=0;
 end else begin
  arm1<=arm;arm2<=arm1;stat_send<=0;
  if(arm2!=epoch) begin
   epoch<=arm2;active<=0;settle<=SETTLE_FRAMES;
   beats<=0;decim<=0;acc<=0;cnt<=0;dark<=0;bright<=0;
  end else if(user_i) begin
   if(active && beats==FRAME_BEATS && cnt!=0) begin
    if(settle!=0) settle<=settle-1'b1;
    else if(stat_ready) begin stat_packet<={epoch,acc,cnt,dark,bright};stat_send<=1;end
   end
   active<=1;beats<=valid_i?1:0;decim<=valid_i?((STAT_DECIM==1)?0:1):0;
   acc<=valid_i?{22'd0,beat_sum}:0;cnt<=valid_i?4:0;
   dark<=valid_i?{29'd0,beat_dark}:0;bright<=valid_i?{29'd0,beat_bright}:0;
  end else if(valid_i && active) begin
   if(beats<=FRAME_BEATS) beats<=beats+1'b1;
   if(decim==0) begin acc<=acc+beat_sum;cnt<=cnt+4;dark<=dark+beat_dark;bright<=bright+beat_bright;end
   decim<=(decim==STAT_DECIM-1)?0:decim+1'b1;
  end
 end
 ae_mailbox #(.WIDTH(129)) u_stats_mailbox(
  .s_clk(pix_clk),.s_rst_n(pix_rst_n),.s_send(stat_send),.s_data(stat_packet),.s_ready(stat_ready),
  .d_clk(cfg_clk),.d_rst_n(cfg_rst_n),.d_valid(stat_valid),.d_data(stats));
 reg [3:0] phase;
 wire hold_requested=(MOTION_HOLD_ENABLE!=0) && hold_req_i;
 assign hold_ack_o=hold_requested && phase==IDLE && cfg_ready && !cfg_error_i;
 reg div_start;reg [31:0] div_num,div_den;wire div_busy,div_done;wire [31:0] div_q;
 ae_divider u_div(.clk(cfg_clk),.rst_n(cfg_rst_n),.start(div_start),.numerator(div_num),
  .denominator(div_den),.busy(div_busy),.done(div_done),.quotient(div_q));
 reg [31:0] total,target,ratio,scnt,sdark,sbright;
 reg [15:0] cand_t,best_i;reg [1:0] cand_d;reg [6:0] scan_i;
 reg [31:0] best_err;reg write_seen;
 wire [31:0] scan_total=(cand_t*gain_q5(scan_i)) << cand_d;
 wire [31:0] scan_err=(scan_total>target)?scan_total-target:target-scan_total;
 wire [34:0] product=total[23:0]*ratio[10:0];
 wire [31:0] raw_target=(product>>8)>E_MAX?E_MAX:((product>>8)<E_MIN?E_MIN:(product>>8));
 wire severe=(luma_o<36 || luma_o>108);
 wire medium_error=(luma_o+12<TGT_LUMA || luma_o>TGT_LUMA+12);
 wire [31:0] smooth_target=severe?raw_target:
   ((raw_target>=total)?total+((raw_target-total)>>(medium_error?1:2)):total-((total-raw_target)>>(medium_error?1:2)));
 wire [31:0] unity_time=(target+(16<<cand_d))>>(5+cand_d);
 always @(posedge cfg_clk or negedge cfg_rst_n)
 if(!cfg_rst_n) begin
  phase<=INIT;arm<=0;ae_req_o<=0;ae_o<=AE_INIT;ana_o<=ANA_INIT;dig_o<=DIG_INIT;luma_o<=0;state_o<=0;
  total<=AE_INIT*((32+(ANA_INIT%32))<<(ANA_INIT/32))*(1<<DIG_INIT);
  target<=0;ratio<=256;scnt<=0;sdark<=0;sbright<=0;div_start<=0;div_num<=0;div_den<=1;
  cand_t<=0;cand_d<=0;best_i<=0;scan_i<=0;best_err<=32'hffffffff;write_seen<=0;
 end else begin
  ae_req_o<=0;div_start<=0;
  if(cfg_error_i) begin phase<=ERROR;state_o<=5;end
  else case(phase)
   INIT: if(cfg_ready) begin
    ae_req_o<=1;phase<=WRITE;write_seen<=0;state_o<=1;
   end
   IDLE: if(!hold_requested && stat_valid && stats[128]==arm && stats[95:64]!=0 && cfg_ready) begin
    scnt<=stats[95:64];sdark<=stats[63:32];sbright<=stats[31:0];
    div_num<=stats[127:96]+(stats[95:64]>>1);div_den<=stats[95:64];div_start<=1;phase<=MEAN;
   end
   MEAN: if(div_done) begin
    luma_o<=div_q[15:0];
    if(div_q>=TGT_LUMA-HYST && div_q<=TGT_LUMA+HYST) begin state_o<=3;phase<=IDLE;end
    else begin
     div_num<=TGT_LUMA*256;div_den<=(div_q==0)?1:div_q;div_start<=1;phase<=RATIO;state_o<=2;
    end
   end
   RATIO: if(div_done) begin
    if(luma_o>TGT_LUMA+HYST && sbright>=(scnt>>2) && div_q>192) ratio<=192;
    else if(luma_o<TGT_LUMA-HYST && sdark>=(scnt>>1) && div_q<384) ratio<=384;
    else ratio<=(div_q<64)?64:((div_q>1024)?1024:div_q);
    phase<=TARGET;
   end
   TARGET: begin target<=smooth_target;cand_d<=0;phase<=ALLOC;end
   ALLOC: begin
    if(cand_d<DIG_MAX && target>((AE_MAX*gain_q5(ANA_MAX))<<cand_d)) cand_d<=cand_d+1'b1;
    else begin
     cand_t<=(unity_time>AE_MAX)?AE_MAX:((unity_time<AE_MIN)?AE_MIN:unity_time[15:0]);
     scan_i<=0;best_i<=0;best_err<=32'hffffffff;phase<=SCAN;
    end
   end
   SCAN: begin
    if(scan_err<best_err) begin best_err<=scan_err;best_i<={9'd0,scan_i};end
    if(scan_i==ANA_MAX) phase<=COMMIT;else scan_i<=scan_i+1'b1;
   end
   COMMIT: begin
    if(hold_requested) begin phase<=IDLE;end
    else if(cand_t==ae_o && best_i==ana_o && {14'd0,cand_d}==dig_o) begin
     state_o<=4;phase<=IDLE; // physical/quantization limit, not false convergence
    end else begin
     ae_o<=cand_t;ana_o<=best_i;dig_o<={14'd0,cand_d};ae_req_o<=1;write_seen<=0;phase<=WRITE;
    end
   end
   WRITE: begin
    if(!cfg_ready) write_seen<=1;
    if(cfg_done_i && write_seen) begin
     total<=(ae_o*gain_q5(ana_o[6:0]))<<dig_o[1:0];arm<=~arm;phase<=IDLE;state_o<=1;
    end
   end
   ERROR: begin state_o<=5;end
   default: phase<=INIT;
  endcase
 end
endmodule

