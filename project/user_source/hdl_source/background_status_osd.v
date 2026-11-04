// Frame-stable calibration hint, independent of detection overlay enable.
module background_status_osd (
 input wire clk,rst_n,user_i,de_i,ready_i,busy_i,
 input wire [11:0] x_i,y_i,
 output reg hit_o
);
 reg [1:0] state;
 reg [34:0] glyph;
 reg [7:0] letter;
 integer character_index,col,row;
 always @(posedge clk or negedge rst_n)
   if(!rst_n) state<=0;
   else if(user_i) state<=busy_i ? 2'd1 : ready_i ? 2'd2 : 2'd0;
 always @* begin
   character_index=0;col=0;row=0;letter=32;glyph=0;hit_o=0;
   if(de_i && x_i>=416 && x_i<512 && y_i>=680 && y_i<694) begin
     character_index=(x_i-416)/16; col=((x_i-416)%16)/2; row=(y_i-680)/2;
     case(character_index)
       0:letter="B"; 1:letter="G";
       3:letter=state==1 ? "C" : state==2 ? "O" : "S";
       4:letter=state==1 ? "A" : state==2 ? "K" : "E";
       5:letter=state==1 ? "L" : state==2 ? " " : "T";
       default:letter=" ";
     endcase
     case(letter)
       "B":glyph=35'b11110_10001_10001_11110_10001_10001_11110;
       "G":glyph=35'b01110_10001_10000_10111_10001_10001_01110;
       "S":glyph=35'b01111_10000_10000_01110_00001_00001_11110;
       "E":glyph=35'b11111_10000_10000_11110_10000_10000_11111;
       "T":glyph=35'b11111_00100_00100_00100_00100_00100_00100;
       "C":glyph=35'b01111_10000_10000_10000_10000_10000_01111;
       "A":glyph=35'b01110_10001_10001_11111_10001_10001_10001;
       "L":glyph=35'b10000_10000_10000_10000_10000_10000_11111;
       "O":glyph=35'b01110_10001_10001_10001_10001_10001_01110;
       "K":glyph=35'b10001_10010_10100_11000_10100_10010_10001;
       default:glyph=0;
     endcase
     if(col<5) hit_o=glyph[34-row*5-col];
   end
 end
endmodule
