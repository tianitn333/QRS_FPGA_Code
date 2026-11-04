// Delay all raster clocks, including blanking, without read/write collisions.
module video_stream_delay #(
    parameter integer WIDTH=29,
    parameter integer DELAY=3305
)(
    input wire clk,rst_n,
    input wire [WIDTH-1:0] data_i,
    output wire [WIDTH-1:0] data_o
);
    reg [13:0] pointer,count;
    reg filled;
    wire [13:0] next_pointer=pointer==DELAY ? 14'd0 : pointer+1'b1;
    wire [WIDTH-1:0] memory_data;
    image_eram #(.WIDTH(WIDTH),.DEPTH(DELAY+1)) memory (
        .clk(clk),.we_i(rst_n),.wr_addr_i(pointer),.data_i(data_i),
        .rd_addr_i(next_pointer),.data_o(memory_data));
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin pointer<=0;count<=0;filled<=0;end
        else begin
            pointer<=next_pointer;
            if(count<DELAY) count<=count+1'b1;
            filled<=count>=DELAY;
        end
    end
    assign data_o=filled ? memory_data : {WIDTH{1'b0}};
endmodule
