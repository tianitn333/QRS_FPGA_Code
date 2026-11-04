module pixel_gray_pipe (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_i,
    input  wire [23:0] rgb_i,
    output reg         valid_o,
    output reg  [7:0]  gray_o
);
    wire [7:0] red   = rgb_i[23:16];
    wire [7:0] green = rgb_i[15:8];
    wire [7:0] blue  = rgb_i[7:0];

    wire [15:0] red_term   = {8'd0, red}   * 16'd77;
    wire [15:0] green_term = {8'd0, green} * 16'd150;
    wire [15:0] blue_term  = {8'd0, blue}  * 16'd29;
    wire [17:0] weighted_sum = {2'b00, red_term} + {2'b00, green_term} + {2'b00, blue_term} + 18'd128;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_o <= 1'b0;
            gray_o  <= 8'd0;
        end else begin
            valid_o <= valid_i;
            gray_o  <= weighted_sum[15:8];
        end
    end
endmodule
