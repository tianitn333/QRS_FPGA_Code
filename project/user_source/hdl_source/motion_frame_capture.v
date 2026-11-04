`timescale 1ns / 1ps
// Camera-side RGB96 packing with FIFO-aligned frame tags and source descriptors.
// Payload FIFO is the existing vendor 128x512 IP; metadata uses small logic FIFOs.
module motion_frame_capture #(
    parameter integer IMAGE_WIDTH=1280, IMAGE_HEIGHT=720
)(
    input wire camera_clk, camera_rst_n, ddr_clk, ddr_rst_n,
    input wire user_i, valid_i,
    input wire [95:0] rgb_i,
    input wire [31:0] source_i, race_i,
    input wire track_i,
    input wire pixel_read_i,
    output wire [127:0] pixel_data_o,
    output wire [1:0] pixel_tag_o,
    output wire pixel_empty_o,
    input wire start_read_i,
    output wire [64:0] start_data_o,
    output wire start_empty_o,
    input wire end_read_i,
    output wire [32:0] end_data_o,
    output wire end_empty_o,
    output reg fault_o
);
    localparam integer RGB_BEATS=IMAGE_WIDTH*IMAGE_HEIGHT/4;
    localparam integer PAYLOAD_WORDS=IMAGE_WIDTH*IMAGE_HEIGHT*3/16;
    reg seen, dropping, started;
    reg [1:0] phase;
    reg [95:0] previous_rgb;
    reg [18:0] beats, packed_words, accepted_words;
    reg [31:0] frame_source, frame_race, race_seen;
    reg frame_track;
    reg packed_valid;
    reg [127:0] packed_data;
    reg [1:0] packed_tag;
    reg [64:0] packed_header;
    reg end_write;
    reg [32:0] end_packet;
    wire payload_full, payload_empty, tag_full, tag_empty, start_full, end_full;
    wire pair_push=packed_valid && !dropping && !payload_full && !tag_full &&
                   (!packed_tag[0] || !start_full);
    wire pair_pop=pixel_read_i && !payload_empty && !tag_empty;
    wire failed_push=packed_valid && !dropping && !pair_push;
    wire [19:0] final_words={1'b0,accepted_words}+pair_push;
    wire [1:0] current_phase=user_i ? 2'd0 : phase;
    assign pixel_empty_o=payload_empty || tag_empty;
    w128_d512_fifo u_payload (
        .rst(!camera_rst_n || !ddr_rst_n),.clkw(camera_clk),.clkr(ddr_clk),
        .we(pair_push),.di(packed_data),.re(pair_pop),.dout(pixel_data_o),
        .valid(),.full_flag(payload_full),.empty_flag(payload_empty),
        .afull(),.aempty(),.wrusedw(),.rdusedw());
    motion_meta_fifo #(.WIDTH(2),.ADDR_WIDTH(9)) u_tags (
        .wr_clk(camera_clk),.wr_rst_n(camera_rst_n),.wr_en_i(pair_push),.wr_data_i(packed_tag),.full_o(tag_full),
        .rd_clk(ddr_clk),.rd_rst_n(ddr_rst_n),.rd_en_i(pair_pop),.rd_data_o(pixel_tag_o),.empty_o(tag_empty));
    motion_meta_fifo #(.WIDTH(65),.ADDR_WIDTH(2)) u_starts (
        .wr_clk(camera_clk),.wr_rst_n(camera_rst_n),.wr_en_i(pair_push && packed_tag[0]),
        .wr_data_i(packed_header),.full_o(start_full),.rd_clk(ddr_clk),.rd_rst_n(ddr_rst_n),
        .rd_en_i(start_read_i),.rd_data_o(start_data_o),.empty_o(start_empty_o));
    motion_meta_fifo #(.WIDTH(33),.ADDR_WIDTH(2)) u_ends (
        .wr_clk(camera_clk),.wr_rst_n(camera_rst_n),.wr_en_i(end_write),.wr_data_i(end_packet),.full_o(end_full),
        .rd_clk(ddr_clk),.rd_rst_n(ddr_rst_n),.rd_en_i(end_read_i),.rd_data_o(end_data_o),.empty_o(end_empty_o));
    always @(posedge camera_clk or negedge camera_rst_n) begin
        if(!camera_rst_n) begin
            seen<=0;dropping<=0;started<=0;phase<=0;previous_rgb<=0;
            beats<=0;packed_words<=0;accepted_words<=0;frame_source<=0;frame_race<=0;frame_track<=0;
            packed_valid<=0;packed_data<=0;packed_tag<=0;packed_header<=0;
            end_write<=0;end_packet<=0;fault_o<=0;race_seen<=0;
        end else begin
            packed_valid<=0;end_write<=0;
            if(race_i!=race_seen)begin race_seen<=race_i;fault_o<=0;end
            if(pair_push) begin accepted_words<=accepted_words+1'b1;if(packed_tag[0])started<=1;end
            if(failed_push) begin dropping<=1;fault_o<=1;end
            if(end_write && end_full) fault_o<=1;
            if(user_i) begin
                if(seen && started) begin
                    if(!end_full) begin
                        end_write<=1;
                        end_packet<={frame_source,(beats==RGB_BEATS && final_words==PAYLOAD_WORDS &&
                                      phase==0 && !dropping && !failed_push)};
                    end else fault_o<=1;
                end
                if(seen && (beats!=RGB_BEATS || phase!=0))fault_o<=1;
                seen<=1;dropping<=0;started<=0;phase<=valid_i?1:0;
                previous_rgb<=rgb_i;beats<=valid_i?1:0;packed_words<=0;accepted_words<=0;
                frame_source<=source_i;frame_race<=race_i;frame_track<=track_i;
            end else if(valid_i && seen) begin
                previous_rgb<=rgb_i;phase<=phase+1'b1;
                if(beats<RGB_BEATS+1)beats<=beats+1'b1;
            end
            if(valid_i && (seen || user_i) && current_phase!=0 &&
               (user_i || beats<RGB_BEATS)) begin
                packed_valid<=1;
                case(current_phase)
                    1:packed_data<={previous_rgb,rgb_i[95:64]};
                    2:packed_data<={previous_rgb[63:0],rgb_i[95:32]};
                    default:packed_data<={previous_rgb[31:0],rgb_i};
                endcase
                packed_tag<={(packed_words==PAYLOAD_WORDS-1),(packed_words==0)};
                packed_header<={frame_source,frame_race,frame_track};
                packed_words<=packed_words+1'b1;
            end
        end
    end
endmodule
