// Frame-stable trial overlay after the existing video mixer.
// Names are always left-to-right ONE/TWO/THREE in Chinese; cards show arrival/rank.
module motion_trial_osd #(parameter integer HORIZONTAL_ENABLE=0, parameter integer CAN_PROBE_ENABLE=0) (
 input wire clk,rst_n,de_i,vs_i,
 input wire enable_i,input wire [1:0] edit_i,
 input wire [10:0] base_x_i,input wire [9:0] base_y_i,input wire [5:0] line_i,
 input wire [191:0] status_i,
 input wire probe_valid_i,
 input wire [127:0] probe_i,
 input wire [7:0] motor_i, // 高4位CAN流程状态、低4位错误码，按帧捕获。
 output wire hit_o,output wire [23:0] color_o
);
 reg [10:0] x;
 reg [9:0] y;
 reg vs_delayed,enabled;
 reg [1:0] edit;
 reg [10:0] base_x;
 reg [9:0] base_y;
 reg [5:0] line_row;
 reg [191:0] snapshot;
 reg [7:0] motor_snapshot;
 reg [127:0] probe_snapshot;
 reg probe_valid;
 reg [31:0] probe_word;
 reg [3:0] probe_nibble;
 wire [2:0] state=snapshot[161:159];
 wire [3:0] fault=snapshot[158:155];
 wire [2:0] arrived=snapshot[154:152];
 wire [5:0] ranks=snapshot[151:146];
 wire [9:0] status_y=HORIZONTAL_ENABLE?base_y-10'd304:10'd240;
 wire [9:0] edit_y=status_y+10'd40;
 reg hit;
 reg [23:0] color;
 reg [7:0] character;
 reg [3:0] font_row,font_col;
 wire [15:0] font_bits;
 reg text_region,name_region;
 reg [1:0] lane;
 reg [10:0] local_x,lane_x;
 reg [9:0] lane_y;
 reg [10:0] finish_x;
 reg [9:0] local_y;
 reg [4:0] column;
 reg [15:0] chinese_bits;
 reg [1:0] rank;
 integer index;
 osd_char_lib latin_font(.I_char(character),.I_row(font_row),.O_row_bits(font_bits));
 assign hit_o=enabled && de_i && hit;
 assign color_o=color;
 always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
   x<=0;y<=0;vs_delayed<=1;enabled<=0;edit<=0;base_x<=664;base_y<=186;line_row<=47;snapshot<=0;motor_snapshot<=0;probe_snapshot<=0;probe_valid<=0;
  end else begin
   vs_delayed<=vs_i;
   if(de_i && x==0 && y==0) begin
    enabled<=enable_i;edit<=edit_i;base_x<=base_x_i;base_y<=base_y_i;line_row<=line_i;snapshot<=status_i;motor_snapshot<=motor_i;
    if(CAN_PROBE_ENABLE)begin probe_snapshot<=probe_i;probe_valid<=probe_valid_i;end
   end
   if(vs_i) begin x<=0;y<=0;end
   else if(de_i) begin
    if(x==1279) begin x<=0;if(y==719)y<=0;else y<=y+1'b1;end
    else x<=x+1'b1;
   end
  end
 end
 always @* begin
  hit=0;color=24'h30ffff;character=8'h20;font_row=0;font_col=0;
  probe_word=0;probe_nibble=0;
  text_region=0;name_region=0;lane=0;local_x=0;local_y=0;column=0;lane_x=0;chinese_bits=0;rank=0;
  // Cyan ROI bounds; red finish edge. These are calibration geometry, not detected boxes.
  lane_y=0;finish_x=base_x+11'd128+{5'd0,line_row};
  for(index=0;index<3;index=index+1) begin
   if(HORIZONTAL_ENABLE)begin
    lane_x=base_x;lane_y=base_y-index*208;
    if(x>=lane_x && x<lane_x+512 && y>=lane_y && y<lane_y+96)begin
     if(x<lane_x+3 || x>=lane_x+509 || y<lane_y+3 || y>=lane_y+93)begin hit=1;color=24'h00d8ff;end
     if(x+1>=finish_x && x<=finish_x+1)begin hit=1;color=24'hff5030;end
     // A short arrow points to the decreasing-X race direction.
     if(y>=lane_y+46 && y<=lane_y+48 && x>=lane_x+210 && x<lane_x+290)begin hit=1;color=24'hffe060;end
     if(x>=lane_x+210 && x<lane_x+222 && y>=lane_y+40 && y<=lane_y+54)begin
      if((x-lane_x-210)>=((y>lane_y+47)?(y-lane_y-47):(lane_y+47-y)))begin hit=1;color=24'hffe060;end
     end
    end
   end else begin
    lane_x=base_x+index*56;
    if(x>=lane_x && x<lane_x+48 && y>=base_y && y<base_y+64)begin
     if(x==lane_x || x==lane_x+47 || y==base_y || y==base_y+63)begin hit=1;color=24'h00d8ff;end
     if(y==base_y+line_row)begin hit=1;color=24'hff6040;end
    end
   end
  end
  // Main state and adjustment field. Latin 16x16 cells, doubled in both axes.
  if(!(HORIZONTAL_ENABLE && snapshot[191]) && x>=32 && x<800 && y>=status_y && y<status_y+32) begin
   text_region=1;local_x=x-32;local_y=y-status_y;column=local_x[9:5];
   case(column)
    0:character="M";1:character="O";2:character="T";3:character="I";4:character="O";5:character="N";
    7:character="E";8:character="X";9:character="P";
    11:case(state) 0:character="I";1:character="P";2:character="R";3:character="R";4:character="D";default:character="E";endcase
    12:case(state) 0:character="D";1:character="R";2:character="E";3:character="U";4:character="O";default:character="R";endcase
    13:case(state) 0:character="L";1:character="E";2:character="A";3:character="N";4:character="N";default:character="R";endcase
    14:case(state) 0:character="E";1:character="P";2:character="D";3:character="N";4:character="E";default:character="O";endcase
    15:case(state) 1:character="A";2:character="Y";3:character="I";5:character="R";default:character=" ";endcase
    16:case(state) 1:character="R";3:character="N";5:character="0"+fault;default:character=" ";endcase
    17:case(state) 1:character="E";3:character="G";default:character=" ";endcase
    default:character=" ";
   endcase
   if(state==5)color=24'hff5050;else if(state==2)color=24'h30ff70;else color=24'hffe040;
  end else if(!snapshot[191] && x>=32 && x<992 && y>=edit_y && y<edit_y+32) begin
   text_region=1;local_x=x-32;local_y=y-edit_y;column=local_x[9:5];
   case(column)
    0:character="E";1:character="D";2:character="I";3:character="T";
    5:case(edit)0:character="X";1:character="Y";2:character="L";default:character="T";endcase
    6:case(edit)2:character="I";3:character="H";default:character=" ";endcase
    7:case(edit)2:character="N";3:character="R";default:character=" ";endcase
    8:if(edit==2)character="E";
    10:character="K";11:character="1";13:character="H";14:character="O";15:character="L";16:character="D";
    18:character="K";19:character="3";21:character="K";22:character="4";
    default:character=" ";
   endcase
   color=24'h40dfff;
  end
  // Bottom cards: fixed left/middle/right ordering, independent of screen scan order.
  if(y>=624 && y<704 && x>=64 && x<1184) begin
   if(x<416) begin lane=0;local_x=x-64;end
   else if(x>=448 && x<800) begin lane=1;local_x=x-448;end
   else if(x>=832) begin lane=2;local_x=x-832;end
   else local_x=1023;
   local_y=y-624;
   if(local_x<352) begin
    hit=1;color=24'h10202c;text_region=0;
    if(local_y<32 && local_x<64) begin name_region=1;font_row=local_y[4:1];font_col=local_x[4:1];end
    else if(local_y>=40 && local_y<72) begin
     text_region=1;column=local_x[8:5];local_y=local_y-40;
     rank=(lane==0)?ranks[1:0]:((lane==1)?ranks[3:2]:ranks[5:4]);
     case(column)
      0:character=arrived[lane]?"D":"W";
      1:character=arrived[lane]?"O":"A";
      2:character=arrived[lane]?"N":"I";
      3:character=arrived[lane]?"E":"T";
      5:character="R";6:character=arrived[lane]?("0"+rank):" ";
      default:character=" ";
     endcase
     color=24'h10202c;
    end
   end
  end
  if(HORIZONTAL_ENABLE)begin
   for(index=0;index<3;index=index+1)begin
    lane_y=base_y-index*208;
    if(x>=base_x+360 && x<base_x+424 && y>=lane_y+8 && y<lane_y+40)begin
     text_region=1;local_x=x-base_x-360;local_y=y-lane_y-8;
     character=local_x<32?"L":("1"+index);color=24'hffffff;
    end
   end
  end
  // 复用现有字体端口，不增加字体RAM；未知/未接端口不显示此行。
  if(motor_snapshot[7:4]<=6 && x>=832 && x<1216 && y>=32 && y<64)begin
   text_region=1;local_x=x-832;local_y=y-32;column=local_x[9:5];
   color=motor_snapshot[7:4]==6?24'hff5050:(motor_snapshot[7:4]==3?24'h40ff70:24'hffe060);
   case(column)
    0:character="C";1:character="A";2:character="N";3:character=" ";
    4:character="0"+motor_snapshot[7:4];5:character=" ";6:character=" ";
    7:character="E";8:character="R";9:character="R";10:character=" ";
    11:character="0"+motor_snapshot[3:0];default:character=" ";
   endcase
  end
  if(CAN_PROBE_ENABLE && probe_valid && x>=832 && x<1216 && y>=64 && y<192)begin
   text_region=1;local_x=x-832;local_y=y-64;column=local_x[9:5];color=24'hffb040;
   case(local_y[6:5])
    0:probe_word=probe_snapshot[127:96];1:probe_word=probe_snapshot[95:64];
    2:probe_word=probe_snapshot[63:32];default:probe_word=probe_snapshot[31:0];
   endcase
   case(column)
    3:probe_nibble=probe_word[31:28];4:probe_nibble=probe_word[27:24];
    5:probe_nibble=probe_word[23:20];6:probe_nibble=probe_word[19:16];
    7:probe_nibble=probe_word[15:12];8:probe_nibble=probe_word[11:8];
    9:probe_nibble=probe_word[7:4];default:probe_nibble=probe_word[3:0];
   endcase
   if(column==0)character="C";
   else if(column==1)character="0"+local_y[6:5];
   else if(column>=3 && column<=10)character=probe_nibble<10?"0"+probe_nibble:"A"+probe_nibble-10;
   else character=" ";
  end
  if(text_region) begin
   font_row=local_y[4:1];font_col=local_x[4:1];
   if(font_bits[15-font_col]) begin hit=1;
    if(y>=624)color=(state==5)?24'hff5050:(arrived[lane]?24'h40ff70:24'hffe060);
   end
  end
  if(name_region) begin
   if(local_x<32) begin
    if((font_row==7)||(lane>=1 && font_row==3)||(lane==2 && font_row==11)) chinese_bits=16'h7ffe;
   end else begin
    // Hand encoded 16x16 Chinese 道 bitmap; see the raster preview evidence.
    case(font_row)
     0:chinese_bits=16'h0000;
     1:chinese_bits=16'h0220;
     2:chinese_bits=16'h0140;
     3:chinese_bits=16'h07fc;
     4:chinese_bits=16'h0100;
     5:chinese_bits=16'h03f8;
     6:chinese_bits=16'h3228;
     7:chinese_bits=16'h13f8;
     8:chinese_bits=16'h0228;
     9:chinese_bits=16'h13f8;
     10:chinese_bits=16'h1228;
     11:chinese_bits=16'h13f8;
     12:chinese_bits=16'h1200;
     13:chinese_bits=16'h2c00;
     14:chinese_bits=16'h43fe;
     default:chinese_bits=16'h0000;
    endcase
   end
   if(chinese_bits[15-font_col]) begin hit=1;color=24'hffffff;end
  end
 end
endmodule
