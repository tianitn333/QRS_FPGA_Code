// Edge-aware separable 3x3 chroma filter. Full raster input, no backpressure.
// Reversible YCoCg: Y is preserved; only Co/Cg are smoothed. Invalid neighbours
// (blanking/top/bottom/line ends) replicate the centre. Blanking flushes edges.
// Stream latency: H_TOTAL + 7 clock edges (verified by the raster scoreboard).
module color_chroma_denoise #(
 parameter integer H_TOTAL=1650,
 parameter integer Y_LIMIT=24, C_LIMIT=48
)(
 input wire clk,rst_n,
 input wire vs_i,hs_i,de_i,user_i,last_i,
 input wire [23:0] rgb_i,
 output wire vs_o,hs_o,de_o,user_o,last_o,
 output reg [23:0] rgb_o
);
 function [25:0] encode;
  input [23:0] rgb;
  reg signed [9:0] co,cg,t,y;
  begin
   co=$signed({1'b0,rgb[23:16]})-$signed({1'b0,rgb[7:0]});
   t=$signed({1'b0,rgb[7:0]})+(co>>>1);
   cg=$signed({1'b0,rgb[15:8]})-t;y=t+(cg>>>1);
   encode={y[7:0],co[8:0],cg[8:0]};
  end
 endfunction
 reg [30:0] enc,left1,left2;
 always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin enc<=0;left1<=0;left2<=0;end
  else begin enc<={vs_i,hs_i,de_i,user_i,last_i,encode(rgb_i)};left1<=enc;left2<=left1;end
 end
 wire [30:0] horizontal,centre,upper,filtered;
 color_chroma_axis #(.Y_LIMIT(Y_LIMIT),.C_LIMIT(C_LIMIT)) hfilter(
  .clk(clk),.rst_n(rst_n),.a(left2),.c(left1),.b(enc),.q(horizontal));
 video_stream_delay #(.WIDTH(31),.DELAY(H_TOTAL-1)) row1(
  .clk(clk),.rst_n(rst_n),.data_i(horizontal),.data_o(centre));
 video_stream_delay #(.WIDTH(31),.DELAY(H_TOTAL-1)) row2(
  .clk(clk),.rst_n(rst_n),.data_i(centre),.data_o(upper));
 color_chroma_axis #(.Y_LIMIT(Y_LIMIT),.C_LIMIT(C_LIMIT)) vfilter(
  .clk(clk),.rst_n(rst_n),.a(upper),.c(centre),.b(horizontal),.q(filtered));
 reg signed [10:0] t_d,g_d;
 reg signed [8:0] co_d;
 reg [4:0] ctrl_d,ctrl_o;
 wire signed [10:0] cg=$signed(filtered[8:0]);
 wire signed [10:0] co=$signed(filtered[17:9]);
 wire signed [10:0] ti=$signed({1'b0,filtered[25:18]})-(cg>>>1);
 wire signed [10:0] blue=t_d-($signed(co_d)>>>1);
 wire signed [10:0] red=blue+$signed(co_d);
 function [7:0] clip;
  input signed [10:0] v;
  begin clip=v<0?8'd0:(v>255?8'd255:v[7:0]);end
 endfunction
 always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin t_d<=0;g_d<=0;co_d<=0;ctrl_d<=0;ctrl_o<=0;rgb_o<=0;end
  else begin
   t_d<=ti;g_d<=cg+ti;co_d<=co;ctrl_d<=filtered[30:26];ctrl_o<=ctrl_d;
   rgb_o<=ctrl_d[2]?{clip(red),clip(g_d),clip(blue)}:24'd0;
  end
 end
 assign {vs_o,hs_o,de_o,user_o,last_o}=ctrl_o;
endmodule

module color_chroma_axis #(
 parameter integer Y_LIMIT=24,C_LIMIT=48
)(input wire clk,rst_n,input wire [30:0] a,c,b,output reg [30:0] q);
 function neighbour_ok;
  input [30:0] n,centre;
  reg signed [9:0] dy,dco,dcg;
  begin
   dy=$signed({1'b0,n[25:18]})-$signed({1'b0,centre[25:18]});
   dco=$signed(n[17:9])-$signed(centre[17:9]);
   dcg=$signed(n[8:0])-$signed(centre[8:0]);
   neighbour_ok=n[28] && centre[28] && dy<=Y_LIMIT && dy>=-Y_LIMIT &&
       dco<=C_LIMIT && dco>=-C_LIMIT && dcg<=C_LIMIT && dcg>=-C_LIMIT;
  end
 endfunction
 reg [30:0] c_d;
 reg signed [8:0] aco,acg,bco,bcg;
 wire signed [10:0] co_sum=$signed(aco)+$signed(bco)+($signed(c_d[17:9])*11'sd2)+11'sd2;
 wire signed [10:0] cg_sum=$signed(acg)+$signed(bcg)+($signed(c_d[8:0])*11'sd2)+11'sd2;
 always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin c_d<=0;aco<=0;acg<=0;bco<=0;bcg<=0;q<=0;end
  else begin
   c_d<=c;
   aco<=neighbour_ok(a,c)?a[17:9]:c[17:9];acg<=neighbour_ok(a,c)?a[8:0]:c[8:0];
   bco<=neighbour_ok(b,c)?b[17:9]:c[17:9];bcg<=neighbour_ok(b,c)?b[8:0]:c[8:0];
   q<={c_d[30:18],co_sum[10:2],cg_sum[10:2]};
  end
 end
endmodule
