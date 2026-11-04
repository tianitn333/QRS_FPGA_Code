`timescale 1ns / 1ps
// Gray-pointer asynchronous metadata FIFO. Both resets must assert together.
// Read data is registered one read-clock after an accepted read. ADDR_WIDTH >= 2.
module motion_meta_fifo #(
    parameter integer WIDTH = 2,
    parameter integer ADDR_WIDTH = 4
)(
    input wire wr_clk, wr_rst_n, wr_en_i,
    input wire [WIDTH-1:0] wr_data_i,
    output wire full_o,
    input wire rd_clk, rd_rst_n, rd_en_i,
    output reg [WIDTH-1:0] rd_data_o,
    output wire empty_o
);
    reg [WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1]; // synthesis ram_style=dram
    reg [ADDR_WIDTH:0] write_binary, write_gray, read_binary, read_gray;
    (* async_reg="true" *) reg [ADDR_WIDTH:0] read_meta, read_sync, write_meta, write_sync;
    reg full, empty;
    wire [ADDR_WIDTH:0] write_next = write_binary + (wr_en_i && !full);
    wire [ADDR_WIDTH:0] read_next = read_binary + (rd_en_i && !empty);
    wire [ADDR_WIDTH:0] write_gray_next = (write_next >> 1) ^ write_next;
    wire [ADDR_WIDTH:0] read_gray_next = (read_next >> 1) ^ read_next;
    assign full_o = full;
    assign empty_o = empty;
    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            write_binary <= 0; write_gray <= 0; read_meta <= 0; read_sync <= 0; full <= 0;
        end else begin
            read_meta <= read_gray; read_sync <= read_meta;
            if (wr_en_i && !full) memory[write_binary[ADDR_WIDTH-1:0]] <= wr_data_i;
            write_binary <= write_next; write_gray <= write_gray_next;
            full <= write_gray_next == {~read_sync[ADDR_WIDTH:ADDR_WIDTH-1],read_sync[ADDR_WIDTH-2:0]};
        end
    end
    always @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            read_binary <= 0; read_gray <= 0; write_meta <= 0; write_sync <= 0; empty <= 1; rd_data_o <= 0;
        end else begin
            write_meta <= write_gray; write_sync <= write_meta;
            if (rd_en_i && !empty) rd_data_o <= memory[read_binary[ADDR_WIDTH-1:0]];
            read_binary <= read_next; read_gray <= read_gray_next;
            empty <= read_gray_next == write_sync;
        end
    end
endmodule
