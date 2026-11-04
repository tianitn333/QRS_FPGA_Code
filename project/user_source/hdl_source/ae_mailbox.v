// Bundled-data mailbox. Source holds the entire packet until destination ACK.
// Both resets must assert together; release is local to each clock domain.
module ae_mailbox #(parameter WIDTH=32)(
 input s_clk,s_rst_n,s_send,input [WIDTH-1:0] s_data,output s_ready,
 input d_clk,d_rst_n,output reg d_valid,output reg [WIDTH-1:0] d_data
);
 reg req,ack; reg [WIDTH-1:0] held;
 (* async_reg="true" *) reg a1,a2,r1,r2;
 assign s_ready=(a2==req);
 always @(posedge s_clk or negedge s_rst_n)
 if(!s_rst_n) begin req<=0;held<=0;a1<=0;a2<=0;end
 else begin
  a1<=ack;a2<=a1;
  if(s_send && s_ready) begin held<=s_data;req<=~req;end
 end
 always @(posedge d_clk or negedge d_rst_n)
 if(!d_rst_n) begin r1<=0;r2<=0;ack<=0;d_valid<=0;d_data<=0;end
 else begin
  r1<=req;r2<=r1;d_valid<=0;
  if(r2!=ack) begin d_data<=held;d_valid<=1;ack<=r2;end
 end
endmodule
