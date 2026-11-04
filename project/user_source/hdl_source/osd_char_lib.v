// Uniform 10x14 Latin glyphs centered in 16x16 cells, combinational interface.
// Original AN/LU bitmaps retained. Other punctuation remains caller-drawn.
module osd_char_lib (
    input wire [7:0] I_char,
    input wire [3:0] I_row,
    output reg [15:0] O_row_bits
);
    localparam CHAR_AN=8'h80, CHAR_LU=8'h81;
    reg [34:0] latin_bits;
    reg [4:0] latin_row;
    always @* begin
        case (I_char)
            8'h41: latin_bits = 35'b01110_10001_10001_11111_10001_10001_10001; // A
            8'h42: latin_bits = 35'b11110_10001_10001_11110_10001_10001_11110; // B
            8'h43: latin_bits = 35'b01110_10001_10000_10000_10000_10001_01110; // C
            8'h44: latin_bits = 35'b11110_10001_10001_10001_10001_10001_11110; // D
            8'h45: latin_bits = 35'b11111_10000_10000_11110_10000_10000_11111; // E
            8'h46: latin_bits = 35'b11111_10000_10000_11110_10000_10000_10000; // F
            8'h47: latin_bits = 35'b01110_10001_10000_10111_10001_10001_01111; // G
            8'h48: latin_bits = 35'b10001_10001_10001_11111_10001_10001_10001; // H
            8'h49: latin_bits = 35'b01110_00100_00100_00100_00100_00100_01110; // I
            8'h4a: latin_bits = 35'b00111_00010_00010_00010_10010_10010_01100; // J
            8'h4b: latin_bits = 35'b10001_10010_10100_11000_10100_10010_10001; // K
            8'h4c: latin_bits = 35'b10000_10000_10000_10000_10000_10000_11111; // L
            8'h4d: latin_bits = 35'b10001_11011_10101_10101_10001_10001_10001; // M
            8'h4e: latin_bits = 35'b10001_11001_10101_10011_10001_10001_10001; // N
            8'h4f: latin_bits = 35'b01110_10001_10001_10001_10001_10001_01110; // O
            8'h50: latin_bits = 35'b11110_10001_10001_11110_10000_10000_10000; // P
            8'h51: latin_bits = 35'b01110_10001_10001_10001_10101_10010_01101; // Q
            8'h52: latin_bits = 35'b11110_10001_10001_11110_10100_10010_10001; // R
            8'h53: latin_bits = 35'b01111_10000_10000_01110_00001_00001_11110; // S
            8'h54: latin_bits = 35'b11111_00100_00100_00100_00100_00100_00100; // T
            8'h55: latin_bits = 35'b10001_10001_10001_10001_10001_10001_01110; // U
            8'h56: latin_bits = 35'b10001_10001_10001_10001_10001_01010_00100; // V
            8'h57: latin_bits = 35'b10001_10001_10001_10101_10101_10101_01010; // W
            8'h58: latin_bits = 35'b10001_10001_01010_00100_01010_10001_10001; // X
            8'h59: latin_bits = 35'b10001_10001_01010_00100_00100_00100_00100; // Y
            8'h5a: latin_bits = 35'b11111_00001_00010_00100_01000_10000_11111; // Z
            8'h30: latin_bits = 35'b01110_10001_10011_10101_11001_10001_01110; // 0
            8'h31: latin_bits = 35'b00100_01100_00100_00100_00100_00100_01110; // 1
            8'h32: latin_bits = 35'b01110_10001_00001_00010_00100_01000_11111; // 2
            8'h33: latin_bits = 35'b11110_00001_00001_01110_00001_00001_11110; // 3
            8'h34: latin_bits = 35'b00010_00110_01010_10010_11111_00010_00010; // 4
            8'h35: latin_bits = 35'b11111_10000_10000_11110_00001_00001_11110; // 5
            8'h36: latin_bits = 35'b01110_10000_10000_11110_10001_10001_01110; // 6
            8'h37: latin_bits = 35'b11111_00001_00010_00100_01000_01000_01000; // 7
            8'h38: latin_bits = 35'b01110_10001_10001_01110_10001_10001_01110; // 8
            8'h39: latin_bits = 35'b01110_10001_10001_01111_00001_00001_01110; // 9
            8'h3a: latin_bits = 35'b00000_00100_00100_00000_00100_00100_00000; // :
            default: latin_bits = 35'd0;
        endcase
        // One blank row above/below; each source row is doubled vertically.
        case (I_row)
            4'd1,4'd2:   latin_row=latin_bits[34:30];
            4'd3,4'd4:   latin_row=latin_bits[29:25];
            4'd5,4'd6:   latin_row=latin_bits[24:20];
            4'd7,4'd8:   latin_row=latin_bits[19:15];
            4'd9,4'd10:  latin_row=latin_bits[14:10];
            4'd11,4'd12: latin_row=latin_bits[9:5];
            4'd13,4'd14: latin_row=latin_bits[4:0];
            default: latin_row=5'd0;
        endcase
        O_row_bits={3'b000,{2{latin_row[4]}},{2{latin_row[3]}},
                    {2{latin_row[2]}},{2{latin_row[1]}},{2{latin_row[0]}},3'b000};
        case (I_char)
            CHAR_AN: begin
                case(I_row)
                    4'd0: O_row_bits = 16'h0200;
                    4'd1: O_row_bits = 16'h7ff0;
                    4'd2: O_row_bits = 16'h4410;
                    4'd3: O_row_bits = 16'h0400;
                    4'd4: O_row_bits = 16'h7ff0;
                    4'd5: O_row_bits = 16'h0840;
                    4'd6: O_row_bits = 16'h1040;
                    4'd7: O_row_bits = 16'h1c80;
                    4'd8: O_row_bits = 16'h0300;
                    4'd9: O_row_bits = 16'h0cc0;
                    4'd10: O_row_bits = 16'h7020;
                    4'd11: O_row_bits = 16'h0000;
                    4'd12: O_row_bits = 16'h0000;
                    4'd13: O_row_bits = 16'h0000;
                    4'd14: O_row_bits = 16'h0000;
                    4'd15: O_row_bits = 16'h0000;
                    default: O_row_bits = 16'h0000;
                endcase
            end
            CHAR_LU: begin
                case(I_row)
                    4'd0: O_row_bits = 16'h79e0;
                    4'd1: O_row_bits = 16'h4a20;
                    4'd2: O_row_bits = 16'h4d40;
                    4'd3: O_row_bits = 16'h7880;
                    4'd4: O_row_bits = 16'h1140;
                    4'd5: O_row_bits = 16'h1630;
                    4'd6: O_row_bits = 16'h5be0;
                    4'd7: O_row_bits = 16'h5220;
                    4'd8: O_row_bits = 16'h5220;
                    4'd9: O_row_bits = 16'h5be0;
                    4'd10: O_row_bits = 16'h6220;
                    4'd11: O_row_bits = 16'h0000;
                    4'd12: O_row_bits = 16'h0000;
                    4'd13: O_row_bits = 16'h0000;
                    4'd14: O_row_bits = 16'h0000;
                    4'd15: O_row_bits = 16'h0000;
                    default: O_row_bits = 16'h0000;
                endcase
            end
            default: begin end
        endcase
    end
endmodule
