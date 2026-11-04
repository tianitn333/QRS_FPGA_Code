// Unsigned restoring division, 32 cycles, configuration clock only.
module ae_divider(input clk,rst_n,start,input [31:0] numerator,denominator,
 output reg busy,done,output reg [31:0] quotient);
 reg [31:0] den,q; reg [32:0] remn;reg [5:0] left;
 wire [32:0] trial={remn[31:0],q[31]};
 always @(posedge clk or negedge rst_n)
 if(!rst_n) begin busy<=0;done<=0;quotient<=0;den<=0;q<=0;remn<=0;left<=0;end
 else begin
  done<=0;
  if(start && !busy) begin
   busy<=1;den<=(denominator==0)?32'd1:denominator;q<=numerator;remn<=0;left<=32;
  end else if(busy) begin
   if(trial>={1'b0,den}) begin remn<=trial-{1'b0,den};q<={q[30:0],1'b1};end
   else begin remn<=trial;q<={q[30:0],1'b0};end
   left<=left-1'b1;
   if(left==1) begin busy<=0;done<=1;quotient<={q[30:0],(trial>={1'b0,den})};end
  end
 end
endmodule
