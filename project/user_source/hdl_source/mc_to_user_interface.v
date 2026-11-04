

module mc_to_user_interface (
    input wire          I_clk,
    input wire          I_rst_n,

    /*
        ddr user interface
        当I_ddr_user_ready拉低时，还能写入8个长度数据
    */
    input wire          I_ddr_user_wr_en,
    input wire          I_ddr_user_rd_en,  //synthesis keep
    input wire[24:0]    I_ddr_user_addr,
    input wire[127:0]   I_ddr_user_wr_data,
    output wire         O_ddr_user_ready,
    output wire         O_pending, // diagnostic only: current queue head is active
    output wire         O_ddr_user_rd_valid,
    output wire[127:0]  O_ddr_user_rd_data,

    /*
        ddr memory controller interface
    */
    output  wire        O_mc_app_en,
    output  wire [24:0] O_mc_app_addr,
    output  wire [2:0]  O_mc_app_cmd,
    input  wire         I_mc_app_rdy,
    output wire         O_mc_app_wdf_wren,
    output wire [127:0] O_mc_app_wdf_data,
    output wire         O_mc_app_wdf_end,
    output wire [31:0]  O_mc_app_wdf_mask,
    input wire          I_mc_app_wdf_rdy,
    input wire [127:0]  I_mc_app_rd_data,
    input wire          I_mc_app_rd_data_end,
    input wire          I_mc_app_rd_data_valid
);

    wire        S_fifo_wr_en;    
    wire[154:0] S_fifo_wr_data;
    wire        S_fifio_pro_full;
    wire        S_fifo_rd_en;    
    wire[154:0] S_fifo_rd_data;
    wire        S_fifo_rd_valid;
    wire        S_fifo_empty;   

    // This IP uses pAXI: write data must accompany the accepted address
    // (the vendor permits at most two clocks of delay). Do not retire AW
    // separately or send W ahead of a blocked address. Both ready outputs
    // are available before VALID in this configured controller.
    reg [2:0] S_release;
    wire S_active = S_release[2] && !S_fifo_empty;
    assign O_pending = S_active;
    wire S_is_write = S_fifo_rd_data[154];
    wire S_write_fire = S_active && S_is_write && I_mc_app_rdy && I_mc_app_wdf_rdy;
    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n) S_release <= 0;
        else S_release <= {S_release[1:0],1'b1};
    end
    assign S_fifo_wr_en = S_release[2] && (I_ddr_user_wr_en | I_ddr_user_rd_en);
    assign S_fifo_wr_data = {I_ddr_user_wr_en,I_ddr_user_rd_en,I_ddr_user_addr,I_ddr_user_wr_data};
    assign S_fifo_rd_en = S_is_write ? S_write_fire : (S_active && I_mc_app_rdy);
    assign O_ddr_user_ready = S_release[2] && !S_fifio_pro_full;
    assign O_mc_app_en = S_is_write ? S_write_fire : S_active;
    assign O_mc_app_addr = S_fifo_rd_data[152:128];
    assign O_mc_app_cmd = S_fifo_rd_data[153] ? 3'd1 : 3'd0;
    assign O_mc_app_wdf_wren = S_write_fire;
    assign O_mc_app_wdf_end = O_mc_app_wdf_wren;
    assign O_mc_app_wdf_mask = 'd0;
    assign O_mc_app_wdf_data = S_fifo_rd_data[127:0];
    assign O_ddr_user_rd_valid = I_rst_n && I_mc_app_rd_data_valid;
    assign O_ddr_user_rd_data = I_mc_app_rd_data;

    w155_d512_fifo U_w155_d512_fifo(
        .clk        ( I_clk            ),     
        .rst        ( ~I_rst_n         ),     

        .we         ( S_fifo_wr_en     ),
        .di         ( S_fifo_wr_data   ),
        .afull      ( S_fifio_pro_full ),
        .full_flag  (),
        .wrusedw    (),
 
        .re         ( S_fifo_rd_en     ), 
        .valid      ( S_fifo_rd_valid  ), 
        .dout       ( S_fifo_rd_data   ),  
        .empty_flag ( S_fifo_empty     ),
        .aempty     (),
        .rdusedw    ()
    );
    
endmodule
