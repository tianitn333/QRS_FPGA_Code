


module motion_video_out #(parameter integer IMAGE_WIDTH=1280,IMAGE_HEIGHT=720) (
    input wire        I_rst_n, // synchronized DDR-domain release
    input wire        I_pixel_rst_n, // synchronized display-domain release

    input wire        I_ddr_clk,
    output wire       O_video_out_rd_busy,  
    input wire        I_video_in_wr_busy,   
    input wire I_select_valid,
    input wire [2:0] I_select_slot,
    input wire [63:0] I_select_metadata,
    output wire [6:0] O_read_protect,
    output reg [63:0] O_applied_metadata,
    output wire       O_ddr_user_rd_en,
    output reg[24:0]  O_ddr_user_addr,
    input wire        I_ddr_user_ready,
    input wire        I_ddr_user_rd_valid,
    input wire[127:0] I_ddr_user_rd_data,

    input wire        I_dsi_clk,
    input wire        I_video_vsync,
    input wire        I_video_rd_en,  
    output reg[23:0]  O_vdieo_data
);

    reg         S_fifo_rst;
    reg         S_frame_flush;
    reg [10:0]  S_outstanding;     
    reg[7:0]    S_fifo_rst_cnt;
    wire[8:0]   S_fifo_wr_num;       
    wire        S_fifo_rd_en;        
    wire[127:0] S_fifo_rd_data;      
    reg         S_video_vsync_1d;
    reg         S_video_vsync_2d;
    reg         S_video_vsync_3d;
    wire        S_video_frame_start;   
    wire        S_ddr_rd_trig;       
    reg         S_ddr_rd_valid;      
    reg[9:0]    S_ddr_rd_cnt;        
    reg[3:0]    S_fifo_rd_cnt;       
    reg         S_video_rd_en_1d;
    reg[3:0]    S_fifo_rd_cnt_1d;     
    reg[127:0]  S_fifo_rd_data_1d;    
	wire        S_fifo_emtpy;     



    localparam integer FRAME_WORDS=IMAGE_WIDTH*IMAGE_HEIGHT*3/16;
    reg pending_valid,current_valid,read_enabled;
    reg [2:0] pending_slot,current_slot;
    reg [63:0] pending_metadata;
    reg [18:0] reads_issued;
    (* async_reg="true" *)reg valid_pixel_meta,valid_pixel_sync;
    function [24:0] slot_base;
      input [2:0] slot;
      begin case(slot)
        0:slot_base=0;1:slot_base=3000000;2:slot_base=6000000;3:slot_base=9000000;
        4:slot_base=12000000;5:slot_base=15000000;default:slot_base=18000000;
      endcase end
    endfunction
    assign O_read_protect=(current_valid?(7'b1<<current_slot):7'd0) |
                          (pending_valid?(7'b1<<pending_slot):7'd0);
    always @(posedge I_dsi_clk or negedge I_pixel_rst_n)
      if(!I_pixel_rst_n)begin valid_pixel_meta<=0;valid_pixel_sync<=0;end
      else begin valid_pixel_meta<=read_enabled;valid_pixel_sync<=valid_pixel_meta;end

    always @(posedge I_ddr_clk or negedge I_rst_n) begin
        if(!I_rst_n) begin S_video_vsync_1d<=0;S_video_vsync_2d<=0;S_video_vsync_3d<=0;end
        else begin
            S_video_vsync_1d <= I_video_vsync;
            S_video_vsync_2d <= S_video_vsync_1d;
            S_video_vsync_3d <= S_video_vsync_2d;
        end
    end

    assign S_video_frame_start = ~S_video_vsync_3d & S_video_vsync_2d;


    // Queued reads may return well after a frame boundary. Stop issuing,
    // discard those returns, and drain them before releasing the new FIFO.
    // Counting requests at the user queue includes bridge/controller latency.
    always @(posedge I_ddr_clk or negedge I_rst_n) begin
        if(!I_rst_n) begin
            S_frame_flush<=1;S_fifo_rst<=1;S_fifo_rst_cnt<=0;
            pending_valid<=0;current_valid<=0;read_enabled<=0;pending_slot<=0;current_slot<=0;
            pending_metadata<=0;O_applied_metadata<=0;
        end
        else if(S_video_frame_start) begin S_frame_flush<=1;S_fifo_rst<=1;S_fifo_rst_cnt<=0;read_enabled<=0;
            pending_valid<=I_select_valid;pending_slot<=I_select_slot;pending_metadata<=I_select_metadata;
        end
        else if(S_frame_flush) begin
            S_fifo_rst<=1;S_fifo_rst_cnt<=0;
            if(S_outstanding==0)begin
                S_frame_flush<=0;current_slot<=pending_slot;current_valid<=pending_valid;
                read_enabled<=pending_valid;O_applied_metadata<=pending_metadata;
                pending_valid<=0;
            end
        end else if(S_fifo_rst) begin
            if(S_fifo_rst_cnt==10) S_fifo_rst<=0;
            else S_fifo_rst_cnt<=S_fifo_rst_cnt+1'b1;
        end
    end
    always @(posedge I_ddr_clk or negedge I_rst_n) begin
        if(!I_rst_n) S_outstanding<=0;
        else case({O_ddr_user_rd_en,I_ddr_user_rd_valid})
            2'b10:S_outstanding<=S_outstanding+1'b1;
            2'b01:if(S_outstanding!=0)S_outstanding<=S_outstanding-1'b1;
            default:S_outstanding<=S_outstanding;
        endcase
    end

    /*
        这里需要注意fifo的剩余空间一定要大于将要写入的长度，因为ddr读出的时候会有至少40个时钟周期的延时，
        例如每次从ddr读出240个长度的数据，那么fifo的剩余空间最少要设为280，否则会引起fifo写满丢失数据。
    */
    assign S_ddr_rd_trig = ((11'd511 - {2'b0,S_fifo_wr_num}) >= (11'd300 + S_outstanding)) && (!I_video_in_wr_busy) && (!S_ddr_rd_valid) && (!S_fifo_rst) && (!S_frame_flush) && (!S_video_frame_start) && I_rst_n && read_enabled && reads_issued<FRAME_WORDS ? 1'b1 : 1'b0;

    /*
        fifo的深度是512，实际的深度是510，因此需要注意每次读出的长度避免为256，否则连续两次写入会引起fifo写满，丢失数据
    */
    always @(posedge I_ddr_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_ddr_rd_valid <= 1'b0;
        else if(S_frame_flush || S_video_frame_start) S_ddr_rd_valid<=0;
        else
			if(O_ddr_user_rd_en && (S_ddr_rd_cnt == 'd239 || reads_issued==FRAME_WORDS-1))
                S_ddr_rd_valid <= 1'b0;
            else if(S_ddr_rd_trig)
                S_ddr_rd_valid <= 1'b1;
            else
                S_ddr_rd_valid <= S_ddr_rd_valid;
    end

    assign O_ddr_user_rd_en = S_ddr_rd_valid && I_ddr_user_ready && !S_frame_flush && !S_video_frame_start && read_enabled && reads_issued<FRAME_WORDS;

    always @(posedge I_ddr_clk or negedge I_rst_n) begin
        if(!I_rst_n) S_ddr_rd_cnt<=0;
        else if(S_ddr_rd_valid)
            begin
                if(O_ddr_user_rd_en)
                    S_ddr_rd_cnt <= S_ddr_rd_cnt + 'd1;
                else
                    S_ddr_rd_cnt <= S_ddr_rd_cnt;
            end
        else    
            S_ddr_rd_cnt <= 'd0;
    end


    always @(posedge I_ddr_clk or negedge I_rst_n)begin
      if(!I_rst_n)begin O_ddr_user_addr<=0;reads_issued<=0;end
      else if(S_frame_flush && S_outstanding==0 && !S_video_frame_start)begin
        O_ddr_user_addr<=slot_base(pending_slot);reads_issued<=0;
      end else if(O_ddr_user_rd_en)begin
        O_ddr_user_addr<=O_ddr_user_addr+25'd8;reads_issued<=reads_issued+1'b1;
      end
    end

    assign O_video_out_rd_busy = S_ddr_rd_trig | S_ddr_rd_valid;


    w128_d512_fifo U_w128_d512_fifo(
        .rst        ( S_fifo_rst || !I_rst_n || !I_pixel_rst_n ),   

        .clkw       ( I_ddr_clk           ),     
        .we         ( I_ddr_user_rd_valid && I_rst_n && !S_fifo_rst && !S_frame_flush && !S_video_frame_start ),
        .di         ( I_ddr_user_rd_data  ),
        .wrusedw    ( S_fifo_wr_num       ),
        .afull      (),
        .full_flag  (),
 
        .clkr       ( I_dsi_clk           ),
        .re         ( S_fifo_rd_en        ), 
        .dout       ( S_fifo_rd_data      ),  
        .rdusedw    (), 
        .valid      (),  
        .empty_flag ( S_fifo_emtpy        ),
        .aempty     ()
    );


   always @(posedge I_dsi_clk or negedge I_pixel_rst_n) begin
       if(!I_pixel_rst_n) S_fifo_rd_cnt<=0;
       else if(I_video_rd_en)
           S_fifo_rd_cnt <= S_fifo_rd_cnt + 'd1;
       else
           S_fifo_rd_cnt <= 'd0;
   end

   assign S_fifo_rd_en = I_pixel_rst_n && valid_pixel_sync && I_video_rd_en && (S_fifo_rd_cnt == 'd0)  ? 1'b1 :
                         I_pixel_rst_n && valid_pixel_sync && I_video_rd_en && (S_fifo_rd_cnt == 'd5)  ? 1'b1 :
                         I_pixel_rst_n && valid_pixel_sync && I_video_rd_en && (S_fifo_rd_cnt == 'd10) ? 1'b1 : 1'b0;

   always @(posedge I_dsi_clk or negedge I_pixel_rst_n) begin
       if(!I_pixel_rst_n) begin S_video_rd_en_1d<=0;S_fifo_rd_cnt_1d<=0;S_fifo_rd_data_1d<=0;end
       else begin
           S_video_rd_en_1d <= I_video_rd_en;
           S_fifo_rd_cnt_1d <= S_fifo_rd_cnt;
           S_fifo_rd_data_1d <= S_fifo_rd_data;
       end
   end

   always @(posedge I_dsi_clk or negedge I_pixel_rst_n) begin
       if(!I_pixel_rst_n) O_vdieo_data<=0;
       else if(S_video_rd_en_1d && valid_pixel_sync)
           begin
               case(S_fifo_rd_cnt_1d)
                   'd0: O_vdieo_data  <= S_fifo_rd_data[127:104];
                   'd1: O_vdieo_data  <= S_fifo_rd_data[103:80];
                   'd2: O_vdieo_data  <= S_fifo_rd_data[79:56];
                   'd3: O_vdieo_data  <= S_fifo_rd_data[55:32];
                   'd4: O_vdieo_data  <= S_fifo_rd_data[31:8];
                   'd5: O_vdieo_data  <= {S_fifo_rd_data_1d[7:0],S_fifo_rd_data[127:112]};
                   'd6: O_vdieo_data  <= S_fifo_rd_data[111:88];
                   'd7: O_vdieo_data  <= S_fifo_rd_data[87:64];
                   'd8: O_vdieo_data  <= S_fifo_rd_data[63:40];
                   'd9: O_vdieo_data  <= S_fifo_rd_data[39:16];
                   'd10: O_vdieo_data <= {S_fifo_rd_data_1d[15:0],S_fifo_rd_data[127:120]};
                   'd11: O_vdieo_data <= S_fifo_rd_data[119:96];
                   'd12: O_vdieo_data <= S_fifo_rd_data[95:72];
                   'd13: O_vdieo_data <= S_fifo_rd_data[71:48];
                   'd14: O_vdieo_data <= S_fifo_rd_data[47:24];
                   'd15: O_vdieo_data <= S_fifo_rd_data[23:0];
               endcase
           end
       else
           O_vdieo_data <= 'd0;
   end

    
endmodule
