`timescale 1ns / 1ps
// Frame-latched replay header. The frame number comes from the applied DDR read.
module motion_replay_osd #(parameter integer HORIZONTAL_ENABLE=0) (
    input wire clk,rst_n,de_i,vs_i,
    input wire mode_i,no_evidence_i,fault_i,
    input wire [63:0] applied_i,
    output wire hit_o,
    output wire [23:0] color_o
);
    reg [10:0] x;
    reg [9:0] y;
    reg [63:0] snapshot;
    reg mode,empty_hint,fault_hint;
    reg [7:0] character;
    reg region;
    reg [23:0] color;
    reg [4:0] column;
    wire [15:0] font_bits;
    wire replay=snapshot[62];
    wire [1:0] lane=snapshot[61:60];
    wire [31:0] frame=snapshot[59:28];
    wire [9:0] header_y=HORIZONTAL_ENABLE?((snapshot[63] && replay)?snapshot[16:7]-10'd304:10'd208):10'd64;
    wire [9:0] header_relative_y=y-header_y;
    wire [3:0] font_row=header_relative_y[4:1],font_col=x[4:1];
    function[7:0] hex_char;
        input [3:0] value;
        begin hex_char=value<10?8'h30+value:8'h41+value-10;end
    endfunction
    osd_char_lib font(.I_char(character),.I_row(font_row),.O_row_bits(font_bits));
    assign hit_o=mode && de_i && region && font_bits[15-font_col];
    assign color_o=color;
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin x<=0;y<=0;snapshot<=0;mode<=0;empty_hint<=0;fault_hint<=0;end
        else begin
            if(vs_i)begin x<=0;y<=0;end
            else if(de_i)begin
                if(x==0 && y==0)begin snapshot<=applied_i;mode<=mode_i;empty_hint<=no_evidence_i;fault_hint<=fault_i;end
                if(x==1279)begin x<=0;if(y==719)y<=0;else y<=y+1'b1;end
                else x<=x+1'b1;
            end
        end
    end
    always @*begin
        region=0;character=" ";color=24'h40ffff;column=x[9:5];
        if(x>=256 && x<1184 && y>=header_y && y<header_y+32 && (replay || empty_hint || fault_hint))begin
            region=1;column=(x-256)>>5;
            if(replay && snapshot[63])begin
                if(fault_hint)color=24'hff5050;
                case(column)
                    0:character="R";1:character="E";2:character="P";3:character="L";4:character="A";5:character="Y";
                    7:character="L";8:character="1"+lane;
                    10:character="F";11:character="R";12:character="A";13:character="M";14:character="E";
                    16:character=hex_char(frame[31:28]);17:character=hex_char(frame[27:24]);
                    18:character=hex_char(frame[23:20]);19:character=hex_char(frame[19:16]);
                    20:character=hex_char(frame[15:12]);21:character=hex_char(frame[11:8]);
                    22:character=hex_char(frame[7:4]);23:character=hex_char(frame[3:0]);
                    default:character=" ";
                endcase
            end else begin
                color=24'hff5050;
                if(fault_hint && !replay)begin
                  case(column)
                    0:character="E";1:character="V";2:character="I";3:character="D";
                    5:character="E";6:character="R";7:character="R";8:character="O";9:character="R";
                    default:character=" ";
                  endcase
                end else case(column)
                    0:character="N";1:character="O";3:character="E";4:character="V";5:character="I";
                    6:character="D";7:character="E";8:character="N";9:character="C";10:character="E";
                    default:character=" ";
                endcase
            end
        end else if(replay && x>=256 && x<1184 && y>=header_y+32 && y<header_y+64)begin
            region=1;column=(x-256)>>5;
            case(column)
                0:character="K";1:character="3";3:character="P";4:character="R";5:character="E";6:character="V";
                8:character="K";9:character="4";11:character="N";12:character="E";13:character="X";14:character="T";
                16:character="K";17:character="2";19:character="E";20:character="X";21:character="I";22:character="T";
                default:character=" ";
            endcase
        end
    end
endmodule
