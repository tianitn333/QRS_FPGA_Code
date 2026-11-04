

module design_top_wrapper (
    input wire        I_sys_clk,
    input wire        I_rst_n,
      
    output wire       O_cam_scl,
    inout  wire       IO_cam_sda,
    output wire       O_cam_24m,
    output wire       O_cam_rst,
      
    inout wire [1:0]  I_button,

    // 板载按键（低有效；官方例程/文档双重确认：key[0]=D5 与 key[1]=A9 都是板载按键，
    // 见 2_Example\8_key_sw\key_sw.adc 与 2_Example\32_cs500_mipi_hdmi\pin\pin.adc）
    //   I_key[0] = D5（丝印 KEY1）：四模式 / COLOR 长按编辑；编辑短按上一项、长按隐藏
    //   I_key[1] = A9（丝印 KEY2）：EDGE 检测/提取；编辑短按下一项、长按退出
    input wire [3:0]  I_key,
    input wire        I_switch_preview, // Physical SW1/A4: down=RGB, up=HIT in editor.
    input wire        I_motor_arm, // SW2/B4：CAN双轴授权；关闭后停止并失效参考。
    input wire        I_motor_reference, // SW3/E11：授权后新上升沿确认机械初始位置。
    input wire        I_can_receive, // J2-28/P8：3.3V CAN收发器RXD。
    output wire       O_can_transmit, // J2-27/P9：接收发器TXD，空闲为1。

    output wire O_sd_clk,O_sd_cs_n,O_sd_mosi,
    input wire I_sd_miso,

    output wire       O_screen_pwm,
    output wire       O_tmds_ch0_p,
    output wire       O_tmds_ch1_p,
    output wire       O_tmds_ch2_p,
    output wire       O_tmds_clk_p,

    inout wire        IO_rx_clk_pad_n, 
    inout wire        IO_rx_clk_pad_p, 
    inout wire[3:0]   IO_rx_data_pad_n,
    inout wire[3:0]   IO_rx_data_pad_p,

    output wire[12:0] ddr_addr,
    output wire[ 1:0] ddr_ba,
    output wire[ 0:0] ddr_cke,
    output wire[ 0:0] ddr_odt,
    output wire[ 0:0] ddr_cs_n,
    output wire       ddr_ras_n,
    output wire       ddr_cas_n,
    output wire       ddr_we_n,
    output wire[ 0:0] ddr_ck_p,
    output wire[ 0:0] ddr_ck_n,
    inout wire[1:0]   ddr_dm,
    inout wire[15:0]  ddr_dq,
    inout wire[1:0]   ddr_dqs_p,
    inout wire[1:0]   ddr_dqs_n   
);


    wire        	S_100m_clk;
    wire        	S_24m_clk;
    wire        	S_aux_50m_clk;
	wire        	S_10m_clk;
		
	wire        	S_pll_lock;
    wire        	S_rst_n;
	
	wire [15:0] 	S_ae;
    wire [15:0] 	S_ag;
    wire 			S_cam_cfg_done;
    wire 			S_ae_cfg_done;
    wire 			S_ae_req; 
	
	wire        	S_csi_rx_clk;  
    wire        	S_hs_rx_valid;  
    wire[15:0]  	S_hs_rx_data;   
	wire[1:0]   	S_lane_error;
	
	wire        	S_csi_frame_start;       
	wire        	S_csi_frame_end;         
	wire        	S_csi_valid;             
	wire[31:0]  	S_csi_data;  
		
	wire        	S_raw10_frame_start; 
	wire        	S_raw10_frame_end;   
	wire        	S_raw10_valid;       
	wire [39:0] 	S_raw10_data;
		
	wire 			S_axis_tlast;  
	wire 			S_axis_tuser;  
	wire [39:0]		S_axis_tdata;  
	wire 			S_axis_tvalid; 
	
	wire [39:0]		S_raw_tdata ;
	wire			S_raw_tlast ;
	wire 			S_raw_tvalid;
	wire 			S_raw_tuser ;
	
	wire			S_ISP_O_tready;
	wire [127:0]	S_ISP_O_tdata ;
	wire 			S_ISP_O_tlast ;
	wire 			S_ISP_O_tuser ;
	wire 			S_ISP_O_tvalid; 
	

    wire        S_ddr_clk;
    wire        S_hdmi_pixel_clk;
    wire        S_hdmi_serial_clk;
    wire        S_hdmi_rst_n;
    wire        S_video_out_rst_n;


    wire        S_vi_128b_frame_start;
    wire        S_vi_128b_valid;      
    wire[127:0] S_vi_128b_data;    
    
    wire        S_video_out_rd_busy;
    wire        S_video_in_wr_busy; 
    wire[1:0]   S_video_out_rp;     

    wire        S_ddr_user_wr_en;       
    wire        S_ddr_user_rd_en;       
    wire[24:0]  S_ddr_user_addr;        
    wire[127:0] S_ddr_user_wr_data;     
    wire        S_ddr_user_ready;       
    wire        S_ddr_user_rd_valid;    
    wire[127:0] S_ddr_user_rd_data;     

    wire        S_vi_ddr_wr_en;   
    wire[24:0]  S_vi_ddr_wr_addr; 
    wire[127:0] S_vi_ddr_wr_data;
    wire        S_vi_ddr_wr_ready;

    wire        S_vo_ddr_rd_en;   
    wire[24:0]  S_vo_ddr_rd_addr; 
    wire        S_vo_ddr_rd_ready;
    wire        S_vo_dbg_fifo_rst;
    wire        S_vo_dbg_ddr_rd_valid;
    wire        S_vo_dbg_fifo_rd_en;
    wire        S_vo_dbg_fifo_empty;

    wire        S_init_calib_complete; 
    wire[24:0]  S_mc_app_addr;          
    wire[2:0]   S_mc_app_cmd;           
    wire        S_mc_app_en;            
    wire[127:0] S_mc_app_wdf_data;      
    wire        S_mc_app_wdf_end;       
    wire[15:0]  S_mc_app_wdf_mask;      
    wire        S_mc_app_wdf_wren;      
    wire[127:0] S_mc_app_rd_data;       
    wire        S_mc_app_rd_data_end;   
    wire        S_mc_app_rd_data_valid; 
    wire        S_mc_app_rdy;           
    wire        S_mc_app_wdf_rdy;       
    wire        S_mc_dbg_fifo_afull;
    wire        S_mc_dbg_app_rdy;
    wire        S_mc_dbg_wdf_rdy;
    wire        S_mc_dbg_cmd_pop;

    wire        S_hdmi_vsync;
    wire        S_hdmi_hsync;
    wire        S_hdmi_de;
    wire        S_hdmi_user;
    wire        S_hdmi_last;
    wire        S_video_out_vsync;
    wire        S_hdmi_window_rd_en;
    wire        S_hdmi_out_vsync;
    wire        S_hdmi_out_hsync;
    wire        S_hdmi_out_de;
    wire[23:0]  S_hdmi_out_data;

    wire[23:0]  S_video_rd_data;
    reg         S_dbg_raw_seen;
    reg         S_dbg_isp_seen;
    reg         S_dbg_ddr_wr_seen;
    reg         S_dbg_ddr_rd_seen;
    reg         S_dbg_cam_cfg_seen;
    reg         S_dbg_hs_seen;
    reg         S_dbg_csi_seen;
    reg         S_dbg_raw10_seen;
    reg         S_dbg_isp_fs_seen;
    reg         S_dbg_isp_valid_seen;
    reg         S_dbg_ddr_req_seen;
    reg         S_dbg_ddr_ready_seen;
    reg [1:0]   S_dbg_raw_seen_sync;
    reg [1:0]   S_dbg_isp_seen_sync;
    reg [1:0]   S_dbg_ddr_wr_seen_sync;
    reg [1:0]   S_dbg_ddr_rd_seen_sync;
    reg [1:0]   S_dbg_cam_cfg_seen_sync;
    reg [1:0]   S_dbg_hs_seen_sync;
    reg [1:0]   S_dbg_csi_seen_sync;
    reg [1:0]   S_dbg_raw10_seen_sync;
    reg [1:0]   S_dbg_isp_fs_seen_sync;
    reg [1:0]   S_dbg_isp_valid_seen_sync;
    reg [1:0]   S_dbg_ddr_req_seen_sync;
    reg [1:0]   S_dbg_ddr_ready_seen_sync;
    reg         S_dbg_video_nonzero_seen;
    reg         S_dbg_rd_req_seen;
    reg         S_dbg_rd_valid_seen;
    reg         S_dbg_rd_nonzero_seen;
    reg [1:0]   S_dbg_rd_req_seen_sync;
    reg [1:0]   S_dbg_rd_valid_seen_sync;
    reg [1:0]   S_dbg_rd_nonzero_seen_sync;
    reg         S_dbg_mc_init_seen;
    reg         S_dbg_mc_app_rdy_seen;
    reg         S_dbg_mc_wdf_rdy_seen;
    reg         S_dbg_mc_cmd_pop_seen;
    reg [1:0]   S_dbg_mc_init_seen_sync;
    reg [1:0]   S_dbg_mc_app_rdy_seen_sync;
    reg [1:0]   S_dbg_mc_wdf_rdy_seen_sync;
    reg [1:0]   S_dbg_mc_cmd_pop_seen_sync;
    // 720p input-format diagnostics.  One RAW10 line from the factory
    // 1280-pixel mode contains 1600 bytes, i.e. 400 valid 32-bit CSI words.
    reg         S_dbg_hs_valid_d;
    reg [10:0]  S_dbg_csi_words;
    reg [10:0]  S_dbg_good_lines;
    reg         S_dbg_frame_seen_once;
    reg         S_dbg_frame_repeat_seen;
    reg         S_dbg_width_1280_seen;
    reg         S_dbg_height_720_seen;
    reg         S_dbg_isp_frame_seen_once;
    reg         S_dbg_isp_frame_repeat_seen;
    reg [1:0]   S_dbg_frame_repeat_sync;
    reg [1:0]   S_dbg_width_1280_sync;
    reg [1:0]   S_dbg_height_720_sync;
    reg [1:0]   S_dbg_isp_frame_repeat_sync;
    wire[3:0]   S_hdmi_debug_status;
    wire        S_lane_error_any;


    assign O_screen_pwm = 1'b1;
    assign S_video_out_vsync = ~S_hdmi_vsync;
	
	
    assign S_rst_n 		= S_pll_lock;
    assign S_hdmi_rst_n = S_pll_lock;

    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_raw_seen <= 1'b0;
        else if(S_raw10_frame_start | S_axis_tvalid)
            S_dbg_raw_seen <= 1'b1;
    end

    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_isp_seen <= 1'b0;
        else if(S_ISP_O_tuser | S_ISP_O_tvalid)
            S_dbg_isp_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_ddr_wr_seen <= 1'b0;
        else if(S_vi_ddr_wr_en)
            S_dbg_ddr_wr_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_ddr_rd_seen <= 1'b0;
        else if(S_ddr_user_rd_valid)
            S_dbg_ddr_rd_seen <= 1'b1;
    end

    always @(posedge S_24m_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_cam_cfg_seen <= 1'b0;
        else if(S_cam_cfg_done)
            S_dbg_cam_cfg_seen <= 1'b1;
    end

    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_hs_seen <= 1'b0;
        else if(S_hs_rx_valid)
            S_dbg_hs_seen <= 1'b1;
    end

    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_csi_seen <= 1'b0;
        else if(S_csi_frame_start | S_csi_valid)
            S_dbg_csi_seen <= 1'b1;
    end

    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_raw10_seen <= 1'b0;
        else if(S_raw10_frame_start | S_raw10_valid)
            S_dbg_raw10_seen <= 1'b1;
    end

    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_isp_fs_seen <= 1'b0;
        else if(S_ISP_O_tuser)
            S_dbg_isp_fs_seen <= 1'b1;
    end

    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_isp_valid_seen <= 1'b0;
        else if(S_ISP_O_tvalid)
            S_dbg_isp_valid_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_ddr_req_seen <= 1'b0;
        else if(S_vi_ddr_wr_en)
            S_dbg_ddr_req_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_ddr_ready_seen <= 1'b0;
        else if(S_ddr_user_ready)
            S_dbg_ddr_ready_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_video_out_rst_n) begin
        if(!S_video_out_rst_n)
            S_dbg_rd_req_seen <= 1'b0;
        else if(S_vo_ddr_rd_en)
            S_dbg_rd_req_seen <= 1'b1;
    end

    // Count CSI payload words between HS packet boundaries.  This avoids
    // probing an internal net of csi_unpacket_2lane (which ChipWatcher cannot
    // legally connect to) and verifies the received line length externally.
    always @(posedge S_csi_rx_clk or negedge S_rst_n) begin
        if(!S_rst_n) begin
            S_dbg_hs_valid_d          <= 1'b0;
            S_dbg_csi_words           <= 11'd0;
            S_dbg_good_lines          <= 11'd0;
            S_dbg_frame_seen_once     <= 1'b0;
            S_dbg_frame_repeat_seen   <= 1'b0;
            S_dbg_width_1280_seen     <= 1'b0;
            S_dbg_height_720_seen     <= 1'b0;
            S_dbg_isp_frame_seen_once <= 1'b0;
            S_dbg_isp_frame_repeat_seen <= 1'b0;
        end
        else begin
            S_dbg_hs_valid_d <= S_hs_rx_valid;

            if(!S_dbg_hs_valid_d && S_hs_rx_valid)
                S_dbg_csi_words <= 11'd0;
            else if(S_csi_valid)
                S_dbg_csi_words <= S_dbg_csi_words + 11'd1;

            // A packet with CSI payload is an image line.  Ignore short
            // frame-start/frame-end packets, whose payload count is zero.
            if(S_dbg_hs_valid_d && !S_hs_rx_valid && (S_dbg_csi_words != 0)) begin
                if(S_dbg_csi_words == 11'd400) begin
                    S_dbg_width_1280_seen <= 1'b1;
                    S_dbg_good_lines <= S_dbg_good_lines + 11'd1;
                end
            end

            if(S_csi_frame_start) begin
                if(S_dbg_frame_seen_once) begin
                    S_dbg_frame_repeat_seen <= 1'b1;
                    if(S_dbg_good_lines == 11'd720)
                        S_dbg_height_720_seen <= 1'b1;
                end
                else
                    S_dbg_frame_seen_once <= 1'b1;
                S_dbg_good_lines <= 11'd0;
            end

            if(S_ISP_O_tuser) begin
                if(S_dbg_isp_frame_seen_once)
                    S_dbg_isp_frame_repeat_seen <= 1'b1;
                else
                    S_dbg_isp_frame_seen_once <= 1'b1;
            end
        end
    end

    always @(posedge S_ddr_clk or negedge S_video_out_rst_n) begin
        if(!S_video_out_rst_n)
            S_dbg_rd_valid_seen <= 1'b0;
        else if(S_ddr_user_rd_valid)
            S_dbg_rd_valid_seen <= 1'b1;
    end

    always @(posedge S_hdmi_pixel_clk or negedge S_video_out_rst_n) begin
        if(!S_video_out_rst_n)
            S_dbg_rd_nonzero_seen <= 1'b0;
        else if(S_hdmi_window_rd_en && (S_video_rd_data != 24'd0))
            S_dbg_rd_nonzero_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_mc_init_seen <= 1'b0;
        else if(S_init_calib_complete)
            S_dbg_mc_init_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_mc_app_rdy_seen <= 1'b0;
        else if(S_mc_dbg_app_rdy)
            S_dbg_mc_app_rdy_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_mc_wdf_rdy_seen <= 1'b0;
        else if(S_mc_dbg_wdf_rdy)
            S_dbg_mc_wdf_rdy_seen <= 1'b1;
    end

    always @(posedge S_ddr_clk or negedge S_rst_n) begin
        if(!S_rst_n)
            S_dbg_mc_cmd_pop_seen <= 1'b0;
        else if(S_mc_dbg_cmd_pop)
            S_dbg_mc_cmd_pop_seen <= 1'b1;
    end

    always @(posedge S_hdmi_pixel_clk or negedge S_hdmi_rst_n) begin
        if(!S_hdmi_rst_n) begin
            S_dbg_cam_cfg_seen_sync <= 2'b00;
            S_dbg_hs_seen_sync      <= 2'b00;
            S_dbg_csi_seen_sync     <= 2'b00;
            S_dbg_raw10_seen_sync   <= 2'b00;
            S_dbg_raw_seen_sync    <= 2'b00;
            S_dbg_isp_seen_sync    <= 2'b00;
            S_dbg_ddr_wr_seen_sync <= 2'b00;
            S_dbg_ddr_rd_seen_sync <= 2'b00;
            S_dbg_isp_fs_seen_sync  <= 2'b00;
            S_dbg_isp_valid_seen_sync <= 2'b00;
            S_dbg_ddr_req_seen_sync <= 2'b00;
            S_dbg_ddr_ready_seen_sync <= 2'b00;
            S_dbg_video_nonzero_seen <= 1'b0;
            S_dbg_rd_req_seen_sync <= 2'b00;
            S_dbg_rd_valid_seen_sync <= 2'b00;
            S_dbg_rd_nonzero_seen_sync <= 2'b00;
            S_dbg_mc_init_seen_sync <= 2'b00;
            S_dbg_mc_app_rdy_seen_sync <= 2'b00;
            S_dbg_mc_wdf_rdy_seen_sync <= 2'b00;
            S_dbg_mc_cmd_pop_seen_sync <= 2'b00;
            S_dbg_frame_repeat_sync <= 2'b00;
            S_dbg_width_1280_sync <= 2'b00;
            S_dbg_height_720_sync <= 2'b00;
            S_dbg_isp_frame_repeat_sync <= 2'b00;
        end
        else begin
            S_dbg_cam_cfg_seen_sync <= {S_dbg_cam_cfg_seen_sync[0], S_dbg_cam_cfg_seen};
            S_dbg_hs_seen_sync      <= {S_dbg_hs_seen_sync[0],      S_dbg_hs_seen};
            S_dbg_csi_seen_sync     <= {S_dbg_csi_seen_sync[0],     S_dbg_csi_seen};
            S_dbg_raw10_seen_sync   <= {S_dbg_raw10_seen_sync[0],   S_dbg_raw10_seen};
            S_dbg_raw_seen_sync    <= {S_dbg_raw_seen_sync[0],    S_dbg_raw_seen};
            S_dbg_isp_seen_sync    <= {S_dbg_isp_seen_sync[0],    S_dbg_isp_seen};
            S_dbg_ddr_wr_seen_sync <= {S_dbg_ddr_wr_seen_sync[0], S_dbg_ddr_wr_seen};
            S_dbg_ddr_rd_seen_sync <= {S_dbg_ddr_rd_seen_sync[0], S_dbg_ddr_rd_seen};
            S_dbg_isp_fs_seen_sync  <= {S_dbg_isp_fs_seen_sync[0],  S_dbg_isp_fs_seen};
            S_dbg_isp_valid_seen_sync <= {S_dbg_isp_valid_seen_sync[0], S_dbg_isp_valid_seen};
            S_dbg_ddr_req_seen_sync <= {S_dbg_ddr_req_seen_sync[0], S_dbg_ddr_req_seen};
            S_dbg_ddr_ready_seen_sync <= {S_dbg_ddr_ready_seen_sync[0], S_dbg_ddr_ready_seen};
            S_dbg_rd_req_seen_sync <= {S_dbg_rd_req_seen_sync[0], S_dbg_rd_req_seen};
            S_dbg_rd_valid_seen_sync <= {S_dbg_rd_valid_seen_sync[0], S_dbg_rd_valid_seen};
            S_dbg_rd_nonzero_seen_sync <= {S_dbg_rd_nonzero_seen_sync[0], S_dbg_rd_nonzero_seen};
            S_dbg_mc_init_seen_sync <= {S_dbg_mc_init_seen_sync[0], S_dbg_mc_init_seen};
            S_dbg_mc_app_rdy_seen_sync <= {S_dbg_mc_app_rdy_seen_sync[0], S_dbg_mc_app_rdy_seen};
            S_dbg_mc_wdf_rdy_seen_sync <= {S_dbg_mc_wdf_rdy_seen_sync[0], S_dbg_mc_wdf_rdy_seen};
            S_dbg_mc_cmd_pop_seen_sync <= {S_dbg_mc_cmd_pop_seen_sync[0], S_dbg_mc_cmd_pop_seen};
            S_dbg_frame_repeat_sync <= {S_dbg_frame_repeat_sync[0], S_dbg_frame_repeat_seen};
            S_dbg_width_1280_sync <= {S_dbg_width_1280_sync[0], S_dbg_width_1280_seen};
            S_dbg_height_720_sync <= {S_dbg_height_720_sync[0], S_dbg_height_720_seen};
            S_dbg_isp_frame_repeat_sync <= {S_dbg_isp_frame_repeat_sync[0], S_dbg_isp_frame_repeat_seen};
            if(S_hdmi_window_rd_en && (S_video_rd_data != 24'd0))
                S_dbg_video_nonzero_seen <= 1'b1;
        end
    end

    assign S_lane_error_any = |S_lane_error;

    assign S_vo_dbg_fifo_rst = 1'b0;
    assign S_vo_dbg_ddr_rd_valid = 1'b0;
    assign S_vo_dbg_fifo_rd_en = 1'b0;
    assign S_vo_dbg_fifo_empty = 1'b0;
    assign S_mc_dbg_fifo_afull = 1'b0;
    assign S_mc_dbg_app_rdy = 1'b0;
    assign S_mc_dbg_wdf_rdy = 1'b0;
    assign S_mc_dbg_cmd_pop = 1'b0;

    // On-screen bring-up status, from left to right in DEBUG_MODE=3:
    // I2C configuration completed, MIPI HS activity seen, repeated CSI frames,
    // and a 1280-pixel RAW10 line (400 x 32-bit CSI payload words) seen.
    assign S_hdmi_debug_status = {
        S_dbg_width_1280_sync[1],
        S_dbg_frame_repeat_sync[1],
        S_dbg_hs_seen_sync[1],
        S_dbg_cam_cfg_seen_sync[1]
    };
	
	assign O_cam_rst = S_rst_n & S_cam_reset_n;
    assign O_cam_24m 	= S_24m_clk;
	
	
	
	
    PLL u_PLL(
        .refclk      ( I_sys_clk         ),
        .reset    	 ( ~I_rst_n          ),
        
        .clk0_out    ( S_100m_clk        ),
        .clk1_out    ( S_24m_clk         ),

        .clk4_out    ( S_hdmi_pixel_clk  ),
        .clk5_out    ( S_hdmi_serial_clk ),

        .lock        ( S_pll_lock        )

    );


	

  
  wire [15:0] S_dg;      // 数字增益 index（本工程新增，0..3 → 1x/2x/4x/8x）

  // 自动曝光/增益闭环（本工程自研，2026-10 M3 轮次）
  // 依据 SC500CS 手册 §2.2：sensor 本身没有 AEC/AGC，必须后端实现；
  // 策略 = 曝光优先 → 模拟增益 → 数字增益（变亮时反向，先关增益再降曝光）。
  // 替代原厂 ae_set（手动 1990/80 + 按键）；ae_set.v 保留未删，可随时切回。
  wire [95:0] S_ae_rgb;
  wire S_ae_valid,S_ae_user,S_ae_done,S_ae_error;
  wire [15:0] S_ae_luma;
  wire [3:0] S_ae_state;
  wire S_cam_reset_n,S_cam_retrying;
  wire [23:0] S_cam_diag;
  wire [1:0] S_cam_restart_count,S_cam_retry_count;
  wire S_ae_reset_async_n=S_rst_n & S_cam_cfg_done;
  (* async_reg="true" *) reg [1:0] S_ae_cfg_release,S_ae_pix_release;
  always @(posedge S_24m_clk or negedge S_ae_reset_async_n)
    if(!S_ae_reset_async_n)S_ae_cfg_release<=0;else S_ae_cfg_release<={S_ae_cfg_release[0],1'b1};
  always @(posedge S_csi_rx_clk or negedge S_ae_reset_async_n)
    if(!S_ae_reset_async_n)S_ae_pix_release<=0;else S_ae_pix_release<={S_ae_pix_release[0],1'b1};
  wire [59:0] S_ae_telemetry=(S_ae_error || S_cam_retrying)?
      {S_ae_error?4'd7:4'd6,S_cam_diag[23:16],S_cam_diag[15:0],
       14'd0,S_cam_restart_count,14'd0,S_cam_retry_count}:
      {S_ae_state,S_ae_luma[7:0],S_ae,S_ag,S_dg};
  wire [59:0] S_ae_display;
  wire S_ae_display_valid;
  wire S_motion_hold_camera,S_motion_hold_cfg_ack;
  (* async_reg="true" *) reg [1:0] S_motion_hold_cfg_sync,S_motion_ack_cam_sync;
  always @(posedge S_24m_clk or negedge S_ae_cfg_release[1])
    if(!S_ae_cfg_release[1])S_motion_hold_cfg_sync<=0;
    else S_motion_hold_cfg_sync<={S_motion_hold_cfg_sync[0],S_motion_hold_camera};
  always @(posedge S_csi_rx_clk or negedge S_ae_pix_release[1])
    if(!S_ae_pix_release[1])S_motion_ack_cam_sync<=0;
    else S_motion_ack_cam_sync<={S_motion_ack_cam_sync[0],S_motion_hold_cfg_ack};
  auto_exposure #(.MOTION_HOLD_ENABLE(1)) u_auto_exposure (
      .pix_clk(S_csi_rx_clk),.pix_rst_n(S_ae_pix_release[1]),
      .valid_i(S_ae_valid),.user_i(S_ae_user),.rgb_i(S_ae_rgb),
      .cfg_clk(S_24m_clk),.cfg_rst_n(S_ae_cfg_release[1]),
      .cfg_ready(S_cam_cfg_done & S_ae_cfg_done),
      .cfg_done_i(S_ae_done),.cfg_error_i(S_ae_error),
      .ae_req_o(S_ae_req),.ae_o(S_ae),.ana_o(S_ag),.dig_o(S_dg),
      .luma_o(S_ae_luma),.state_o(S_ae_state),
      .hold_req_i(S_motion_hold_cfg_sync[1]),.hold_ack_o(S_motion_hold_cfg_ack)
  );
  ae_mailbox #(.WIDTH(60)) u_ae_display_mailbox (
      .s_clk(S_24m_clk),.s_rst_n(S_rst_n),.s_send(1'b1),
      .s_data(S_ae_telemetry),.s_ready(),
      .d_clk(S_hdmi_pixel_clk),.d_rst_n(S_rst_n),
      .d_valid(S_ae_display_valid),.d_data(S_ae_display)
  );

    uicfgcs500_720p #(
      .CLK_DIV(24000000 / 100000 - 1)
  ) u_uicfgcs500 (
      .I_clk(S_24m_clk),  //系统时钟输入
      .I_rst_n(S_rst_n),  //系统复位输入
      .I_ae_req(S_ae_req),
      .I_ae(S_ae),
      .I_ag(S_ag),
      .I_dg(S_dg),        // 数字增益 index（本工程新增）
      .O_cam_scl(O_cam_scl),  //I2C总线，SCL时钟
      .IO_cam_sda(IO_cam_sda),  //I2C总线，SDA数据
      .O_cfg_done(S_cam_cfg_done),  //摄像头寄存器初始化完成
      .O_ae_done(S_ae_done),.O_ae_error(S_ae_error),
      .O_cam_reset_n(S_cam_reset_n),.O_diag(S_cam_diag),
      .O_restart_count(S_cam_restart_count),.O_retry_count(S_cam_retry_count),.O_retrying(S_cam_retrying),
      .O_ae_cfg_done(S_ae_cfg_done)  //AE配置完成
  );
	
    mipi_dphy_rx_ph1p_mipiio_wrapper#(
        .DPHY_RX_LOCATION      ( "DPHY0" ),
        .HS_EQUALIZER          ( "0dB"   ),//"0dB","1.5dB","3dB","4.5dB","6dB","7.5dB","9dB","10.5dB"
        .HS_VGA_GAIN           ( "8dB" ),//"-3dB","-1.5dB","0dB","1.5dB","3dB","4.5dB","6dB","7.5dB"
        .LANE_NUM              ( 2       ),
        .BYTE_NUM              ( 1       )
    )u_mipi_dphy_rx_ph1p_mipiio_wrapper(
        .I_lp_clk              ( S_100m_clk       ),
        .I_rst                 ( ~S_rst_n         ),

        .I_clk_lane_in_delay   ( 6'd0             ),
        .I_data_lane0_in_delay ( 6'd0             ),
        .I_data_lane1_in_delay ( 6'd0             ),
        .I_data_lane2_in_delay ( 6'd0             ),
        .I_data_lane3_in_delay ( 6'd0             ),

        .I_lane_invert         ( 4'b0000          ),
     
        .O_hs_rx_clk           ( S_csi_rx_clk     ),
        .O_hs_rx_valid         ( S_hs_rx_valid    ),
        .O_hs_rx_data          ( S_hs_rx_data     ),
      
        .O_lp_rx_lane0_p       (  ),
        .O_lp_rx_lane0_n       (  ),
      
        .I_lp_tx_en            ( 1'b0             ),
        .I_lp_tx_lane0_p       ( 1'b1             ),
        .I_lp_tx_lane0_n       ( 1'b1             ),
      
        .O_lane_match_error    (                  ),
        .O_lane_error          ( S_lane_error     ),
      
        .IO_rx_clk_pad_n       ( IO_rx_clk_pad_n  ),
        .IO_rx_clk_pad_p       ( IO_rx_clk_pad_p  ),
        .IO_rx_data_pad_n      ( IO_rx_data_pad_n ),
        .IO_rx_data_pad_p      ( IO_rx_data_pad_p )
    );
	
	
 //  cwc cwc_inst
 //(
 //    .probe0(S_hs_rx_valid),
 //    .probe1(S_hs_rx_data),
 //    .probe2(S_lane_error),
 //    .clk(S_csi_rx_clk)
 //);

 //csi 解码为RAW数据
csi_unpacket_2lane u_csi_unpacket(
.I_clk                 ( S_csi_rx_clk       ),
.I_rst_n               ( S_rst_n        	),
.I_hs_valid            ( S_hs_rx_valid     ),
.I_hs_data             ( S_hs_rx_data      ),

.O_csi_frame_start     ( S_csi_frame_start ),
.O_csi_frame_end       ( S_csi_frame_end   ),
.O_csi_valid           ( S_csi_valid       ),
.O_csi_data            ( S_csi_data        )
);


//解码为RAW8
raw10_unpacket_2lane u_raw10_unpacket (
.I_clk  (S_csi_rx_clk),
.I_rst_n(S_rst_n),

.I_csi_frame_start(S_csi_frame_start),
.I_csi_frame_end  (S_csi_frame_end),
.I_csi_valid      (S_csi_valid),
.I_csi_data       (S_csi_data),

.O_raw10_frame_start(S_raw10_frame_start),
.O_raw10_frame_end  (S_raw10_frame_end),
.O_raw10_valid      (S_raw10_valid),
.O_raw10_data       (S_raw10_data)
  );


//将数据转为stream流
uial2axis #(
.IMG_WIDTH(1280),
.IMG_HEIGHT(720),
.INPUT_DATA_WIDTH(40)
) 
u_uial2axis (
.I_native_clk(S_csi_rx_clk),
.I_rst_n     (S_rst_n),
.I_data      (S_raw10_data       ),
.I_data_valid(S_raw10_valid      ),
.I_data_start(S_raw10_frame_start),
.I_data_end  (S_raw10_frame_end  ),
.axis_tvalid (S_axis_tvalid),
.axis_tdata  (S_axis_tdata ),
.axis_tuser  (S_axis_tuser ),
.axis_tlast  (S_axis_tlast )
);
	

// SC500 factory HD mode already outputs native 1280x720 RAW10.
assign S_raw_tdata  = S_axis_tdata;
assign S_raw_tvalid = S_axis_tvalid;
assign S_raw_tlast  = S_axis_tlast;
assign S_raw_tuser  = S_axis_tuser;


//cwc1 cwc1_Inst
//  (
//      .probe0(S_axis_tuser),
//      .probe1(S_axis_tvalid),
//      .probe2(S_axis_tlast),
//      .probe3(S_axis_tdata),
//      .probe4(S_ISP_O_tuser),
//      .probe5(S_ISP_O_tvalid),
//      .probe6(S_ISP_O_tlast),
//      .probe7(S_ISP_O_tdata),
//      .probe8 (S_raw_tdata ),
//      .probe9 (S_raw_tlast ),
//      .probe10(S_raw_tvalid),
//      .probe11(S_raw_tuser ),
//      .clk(S_csi_rx_clk)
//  );


//ISP算法顶层模块
isp_top u_isp_top (
.O_ae_rgb(S_ae_rgb),.O_ae_valid(S_ae_valid),.O_ae_user(S_ae_user),
.axi4s_video_aclk(S_csi_rx_clk),
.I_rst_n         (S_rst_n),
.I_tlast         (S_raw_tlast	),
.I_tuser         (S_raw_tuser	),
.I_tdata         (S_raw_tdata	),
.I_tvalid        (S_raw_tvalid	),
.I_tdest         (),
.O_tready        (S_ISP_O_tready),
.O_tdata         (S_ISP_O_tdata ),
.O_tlast         (S_ISP_O_tlast ),
.O_tuser         (S_ISP_O_tuser ),
.O_tvalid        (S_ISP_O_tvalid),
.I_tready        ()
  );


    wire S_ddr_path_rst_n,S_ddr_camera_rst_n,S_ddr_pixel_rst_n;
    wire [15:0] S_ddr_video_status;
    wire S_ddr_queue_pending;
    ddr_startup_guard u_ddr_startup_guard(
      .rst_n(S_rst_n),.calib_i(S_init_calib_complete),.ddr_clk(S_ddr_clk),
      .cam_clk(S_csi_rx_clk),.pix_clk(S_hdmi_pixel_clk),
      .ddr_rst_n(S_ddr_path_rst_n),.cam_rst_n(S_ddr_camera_rst_n),.pix_rst_n(S_ddr_pixel_rst_n));
    ddr_video_status u_ddr_video_status(
      .rst_n(S_rst_n),.cam_clk(S_csi_rx_clk),.ddr_clk(S_ddr_clk),.pix_clk(S_hdmi_pixel_clk),
      .source_frame_i(S_ae_user),.calib_i(S_init_calib_complete),.path_ready_i(S_ddr_path_rst_n),
      .packed_valid_i(S_ISP_O_tvalid),
      .user_write_i(S_ddr_user_wr_en),.user_read_i(S_ddr_user_rd_en),
      .queue_pending_i(S_ddr_queue_pending),.user_ready_i(S_ddr_user_ready),
      .app_ready_i(S_mc_app_rdy),.wdf_ready_i(S_mc_app_wdf_rdy),
      .write_i(S_mc_app_wdf_wren && S_mc_app_wdf_rdy),
      .read_i(S_mc_app_en && S_mc_app_cmd[0] && S_mc_app_rdy),
      .return_i(S_ddr_user_rd_valid),.return_nonzero_i(S_ddr_user_rd_valid && |S_ddr_user_rd_data),
      .pixel_nonzero_i(S_hdmi_window_rd_en && |S_video_rd_data),.status_o(S_ddr_video_status));

    wire [31:0] S_motion_race,S_motion_source_tag,S_decision_source,S_decision_race;
    wire [26:0] S_motion_geometry,S_replay_geometry;
    wire S_motion_active,S_decision_valid,S_decision_good;
    wire [2:0] S_decision_mask;
    reg [31:0] S_source_sequence;
    always @(posedge S_csi_rx_clk or negedge S_ddr_camera_rst_n)
      if(!S_ddr_camera_rst_n)S_source_sequence<=0;
      else if(S_ae_user)S_source_sequence<=S_source_sequence+1'b1;
    assign S_motion_source_tag=S_ae_user?S_source_sequence+1'b1:S_source_sequence;
    wire S_replay_enabled,S_replay_race_key,S_replay_empty_hint;
    wire [1:0] S_replay_lane;
    wire [2:0] S_replay_request_ddr;
    wire [67:0] S_replay_feedback;
    wire [63:0] S_replay_applied_ddr;
    wire [2:0] S_evidence_valid_ddr,S_evidence_view_slot,S_live_view_slot;
    wire [31:0] S_evidence_view_source,S_live_view_source;
    wire S_evidence_view_valid,S_live_view_valid,S_evidence_fault;
    wire [6:0] S_read_protect,S_evidence_pinned;
    ae_mailbox #(.WIDTH(3)) u_replay_request (
      .s_clk(S_hdmi_pixel_clk),.s_rst_n(S_ddr_pixel_rst_n),.s_send(1'b1),
      .s_data({S_replay_enabled,S_replay_lane}),.s_ready(),
      .d_clk(S_ddr_clk),.d_rst_n(S_ddr_path_rst_n),.d_valid(),.d_data(S_replay_request_ddr));
    wire S_selected_valid=S_replay_request_ddr[2]?S_evidence_view_valid:S_live_view_valid;
    wire [2:0] S_selected_slot=S_replay_request_ddr[2]?S_evidence_view_slot:S_live_view_slot;
    wire [31:0] S_selected_source=S_replay_request_ddr[2]?S_evidence_view_source:S_live_view_source;
    wire [63:0] S_selected_metadata={S_selected_valid,S_replay_request_ddr[2],
      S_replay_request_ddr[1:0],S_selected_source,S_replay_geometry,S_evidence_fault};
    motion_video_store u_video_store (
      .camera_clk(S_csi_rx_clk),.camera_rst_n(S_ddr_camera_rst_n),.ddr_clk(S_ddr_clk),.ddr_rst_n(S_ddr_path_rst_n),
      .user_i(S_ae_user),.valid_i(S_ae_valid),.rgb_i(S_ae_rgb),.source_i(S_motion_source_tag),.race_i(S_motion_race),
      .geometry_i(S_motion_geometry),.track_i(S_motion_active),.enable_i(S_motion_config_camera[63]),
      .decision_i(S_decision_valid),.decision_source_i(S_decision_source),.decision_race_i(S_decision_race),
      .decision_mask_i(S_decision_mask),.decision_good_i(S_decision_good),
      .read_busy_i(S_video_out_rd_busy),.read_protect_i(S_read_protect),.user_ready_i(S_ddr_user_ready),
      .controller_write_i(S_mc_app_en && S_mc_app_cmd==0 && S_mc_app_rdy && S_mc_app_wdf_wren && S_mc_app_wdf_rdy),
      .view_lane_i(S_replay_request_ddr[1:0]),.write_busy_o(S_video_in_wr_busy),.write_o(S_vi_ddr_wr_en),
      .address_o(S_vi_ddr_wr_addr),.data_o(S_vi_ddr_wr_data),
      .view_slot_o(S_evidence_view_slot),.view_source_o(S_evidence_view_source),.view_valid_o(S_evidence_view_valid),
      .evidence_valid_o(S_evidence_valid_ddr),.live_valid_o(S_live_view_valid),.live_slot_o(S_live_view_slot),
      .live_source_o(S_live_view_source),.pinned_o(S_evidence_pinned),.geometry_o(S_replay_geometry),.fault_o(S_evidence_fault));
    ae_mailbox #(.WIDTH(68)) u_replay_applied (
      .s_clk(S_ddr_clk),.s_rst_n(S_ddr_path_rst_n),.s_send(1'b1),
      .s_data({S_evidence_valid_ddr,S_evidence_fault,S_replay_applied_ddr}),.s_ready(),
      .d_clk(S_hdmi_pixel_clk),.d_rst_n(S_ddr_pixel_rst_n),.d_valid(),.d_data(S_replay_feedback));

    assign S_ddr_user_wr_en    = S_vi_ddr_wr_en;

    assign S_ddr_user_rd_en    = S_vo_ddr_rd_en;

    assign S_ddr_user_addr     = S_vi_ddr_wr_en ? S_vi_ddr_wr_addr :
                                 S_vo_ddr_rd_en ? S_vo_ddr_rd_addr : 'd0;

    assign S_ddr_user_wr_data  = S_vi_ddr_wr_data;


    assign S_video_out_rst_n = S_ddr_path_rst_n;

    motion_video_out u_video_out(
        .I_rst_n             ( S_video_out_rst_n    ),
        .I_pixel_rst_n       ( S_ddr_pixel_rst_n    ),
        .I_ddr_clk           ( S_ddr_clk            ),
 
        .O_video_out_rd_busy ( S_video_out_rd_busy  ),
        .I_video_in_wr_busy  ( S_video_in_wr_busy   ),
        .I_select_valid(S_selected_valid),.I_select_slot(S_selected_slot),.I_select_metadata(S_selected_metadata),
        .O_read_protect(S_read_protect),.O_applied_metadata(S_replay_applied_ddr),
 
        .O_ddr_user_rd_en    ( S_vo_ddr_rd_en       ),
        .O_ddr_user_addr     ( S_vo_ddr_rd_addr     ),
        .I_ddr_user_ready    ( S_ddr_user_ready     ),
        .I_ddr_user_rd_valid ( S_ddr_user_rd_valid  ),
        .I_ddr_user_rd_data  ( S_ddr_user_rd_data   ),

        .I_dsi_clk           ( S_hdmi_pixel_clk     ),
        .I_video_vsync       ( S_video_out_vsync    ),
        .I_video_rd_en       ( S_hdmi_window_rd_en  ),
        .O_vdieo_data        ( S_video_rd_data      )
    );



    mc_to_user_interface u_mc_to_user_interface(
        .I_clk                   ( S_ddr_clk               ),
        .I_rst_n                 ( S_ddr_path_rst_n         ),

        .I_ddr_user_wr_en        ( S_ddr_user_wr_en        ),
        .I_ddr_user_rd_en        ( S_ddr_user_rd_en        ),
        .I_ddr_user_addr         ( S_ddr_user_addr         ),
        .I_ddr_user_wr_data      ( S_ddr_user_wr_data      ),
        .O_ddr_user_ready        ( S_ddr_user_ready        ),
        .O_pending               ( S_ddr_queue_pending     ),
        .O_ddr_user_rd_valid     ( S_ddr_user_rd_valid     ),
        .O_ddr_user_rd_data      ( S_ddr_user_rd_data      ),
            
        .O_mc_app_en             ( S_mc_app_en             ),
        .O_mc_app_addr           ( S_mc_app_addr           ),
        .O_mc_app_cmd            ( S_mc_app_cmd            ),
        .I_mc_app_rdy            ( S_mc_app_rdy            ),
        .O_mc_app_wdf_wren       ( S_mc_app_wdf_wren       ),
        .O_mc_app_wdf_data       ( S_mc_app_wdf_data       ),
        .O_mc_app_wdf_end        ( S_mc_app_wdf_end        ),
        .O_mc_app_wdf_mask       ( S_mc_app_wdf_mask       ),
        .I_mc_app_wdf_rdy        ( S_mc_app_wdf_rdy        ),
        .I_mc_app_rd_data        ( S_mc_app_rd_data        ),
        .I_mc_app_rd_data_end    ( S_mc_app_rd_data_end    ),
        .I_mc_app_rd_data_valid  ( S_mc_app_rd_data_valid  )
    );



    ph1p35_324_ddr_wrapper u_ph1p35_324_ddr_wrapper(
        .I_sys_clk              ( I_sys_clk              ),
        .I_sys_rst_n            ( S_rst_n                ),

        .O_ddr_clk              ( S_ddr_clk              ),
        .O_init_calib_complete  ( S_init_calib_complete  ),
        .I_mc_app_addr          ( S_mc_app_addr          ),
        .I_mc_app_cmd           ( S_mc_app_cmd           ),
        .I_mc_app_en            ( S_mc_app_en            ),
        .I_mc_app_wdf_data      ( S_mc_app_wdf_data      ),
        .I_mc_app_wdf_end       ( S_mc_app_wdf_end       ),
        .I_mc_app_wdf_mask      ( S_mc_app_wdf_mask      ),
        .I_mc_app_wdf_wren      ( S_mc_app_wdf_wren      ),
        .O_mc_app_rd_data       ( S_mc_app_rd_data       ),
        .O_mc_app_rd_data_end   ( S_mc_app_rd_data_end   ),
        .O_mc_app_rd_data_valid ( S_mc_app_rd_data_valid ),
        .O_mc_app_rdy           ( S_mc_app_rdy           ),
        .O_mc_app_wdf_rdy       ( S_mc_app_wdf_rdy       ),

        .ddr_addr               ( ddr_addr               ),
        .ddr_ba                 ( ddr_ba                 ),
        .ddr_cke                ( ddr_cke                ),
        .ddr_odt                ( ddr_odt                ),
        .ddr_cs_n               ( ddr_cs_n               ),
        .ddr_ras_n              ( ddr_ras_n              ),
        .ddr_cas_n              ( ddr_cas_n              ),
        .ddr_we_n               ( ddr_we_n               ),
        .ddr_ck_p               ( ddr_ck_p               ),
        .ddr_ck_n               ( ddr_ck_n               ),
        .ddr_dm                 ( ddr_dm                 ),
        .ddr_dq                 ( ddr_dq                 ),
        .ddr_dqs_p              ( ddr_dqs_p              ),
        .ddr_dqs_n              ( ddr_dqs_n              )
    );



    uivtc #(
        .H_ActiveSize ( 1280 ),
        .H_FrameSize  ( 1650 ),
        .H_SyncStart  ( 1390 ),
        .H_SyncEnd    ( 1430 ),
        .V_ActiveSize ( 720  ),
        .V_FrameSize  ( 750  ),
        .V_SyncStart  ( 725  ),
        .V_SyncEnd    ( 730  )
    )u_hdmi_vtc(
        .I_vtc_rstn    ( S_hdmi_rst_n    ),
        .I_vtc_clk     ( S_hdmi_pixel_clk ),
        .O_vtc_vs      ( S_hdmi_vsync     ),
        .O_vtc_hs      ( S_hdmi_hsync     ),
        .O_vtc_de_valid( S_hdmi_de        ),
        .O_vtc_user    ( S_hdmi_user      ),
        .O_vtc_last    ( S_hdmi_last      )
    );

    // ------------------------------------------------------------------
    // 四键输入 + 模式/编辑 FSM（2026-10 色块 UI 轮次）
    //   KEY1/D5、KEY2/A9、KEY3/B9、KEY4/C7，低有效
    //   统一两级同步 + 20ms 消抖；K1/K2 长按 800ms，K3/K4 首步 + 400ms 后 80ms 连发
    // ------------------------------------------------------------------
    wire S_color_common_rst_n=I_rst_n&&S_pll_lock;
    (* async_reg="true" *) reg[1:0]S_color_release_p;
    always @(posedge S_hdmi_pixel_clk or negedge S_color_common_rst_n)
      if(!S_color_common_rst_n)S_color_release_p<=0;else S_color_release_p<={S_color_release_p[0],1'b1};
    wire S_color_p_rst_n=S_color_release_p[1];
    wire[31:0]S_param_version;
    wire S_k1_short, S_k1_long, S_k2_short, S_k2_long;
    wire S_k3_step, S_k4_step, S_k4_long15;
    wire [3:0] S_key_pressed;
    wire S_switch_preview;
    wire S_fill_edit;
    reg S_motion_mode;
    wire [1:0] S_ui_mode;
    (* async_reg="true" *) reg [1:0] S_motion_camera_release;
    wire S_k1_short_color = S_k1_short && !S_fill_edit && !S_motion_mode;
    wire S_k2_short_color = S_k2_short && !S_fill_edit && !S_motion_mode;
    color_switch_ctrl #(.STABLE_CYCLES(1500000)) u_switch_preview (
        .clk(S_hdmi_pixel_clk),.rst_n(S_color_p_rst_n),
        .I_switch(I_switch_preview),.O_level(S_switch_preview)
    );

    color_key_ctrl #(
        .MS_CYC ( 75000 )
    ) u_key_ctrl (
        .clk         ( S_hdmi_pixel_clk ),
        .rst_n       ( S_color_p_rst_n     ),
        .I_key_n     ( I_key            ),
        .I_restore_arm(S_ui_restore_sel),
        .O_k1_short  ( S_k1_short       ),
        .O_k1_long   ( S_k1_long        ),
        .O_k2_short  ( S_k2_short       ),
        .O_k2_long   ( S_k2_long        ),
        .O_k3_step   ( S_k3_step        ),
        .O_k4_step   ( S_k4_step        ),
        .O_k4_long15 ( S_k4_long15      ),
        .O_pressed   ( S_key_pressed    )
    );

    // Motion trial controls: boot in trial; short K1 returns to original view.
    // In original view long K2 re-enters trial. K2 short starts/stops a race.
    // Idle/results: long K1 selects X/Y/LINE/THR, K3/K4 adjust that field.
    reg [1:0] S_motion_edit;
    reg [7:0] S_motion_command;
    reg [10:0] S_motion_x;
    reg [9:0] S_motion_y;
    reg [5:0] S_motion_line;
    reg [7:0] S_motion_threshold;
    wire [191:0] S_motion_camera_status,S_motion_display_status;
    wire [31:0] S_motion_display_race;
    wire S_motion_status_valid;
    wire S_motor_race_go;
    wire [3:0] S_motor_state,S_motor_error;
    wire [2:0] S_motion_state=S_motion_display_status[161:159];
    wire S_motion_edit_allowed=!S_replay_enabled && (S_motion_state==0 || S_motion_state==4 || S_motion_state==5);
    motion_replay_ui u_replay_ui (
      .clk(S_hdmi_pixel_clk),.rst_n(S_ddr_pixel_rst_n),.mode_i(S_motion_mode),.state_i(S_motion_state),
      .evidence_i(S_replay_feedback[67:65]),.short_key_i(S_k2_short),.long_key_i(S_k2_long),
      .previous_i(S_k3_step),.next_i(S_k4_step),.replay_o(S_replay_enabled),.lane_o(S_replay_lane),
      .race_key_o(S_replay_race_key),.no_evidence_o(S_replay_empty_hint));
    always @(posedge S_hdmi_pixel_clk or negedge S_color_p_rst_n) begin
      if(!S_color_p_rst_n) begin
        S_motion_mode<=1;S_motion_edit<=0;S_motion_command<=0;
        S_motion_x<=160;S_motion_y<=512;S_motion_line<=40;S_motion_threshold<=24;
      end else begin
        if(S_motion_mode && S_k1_short) S_motion_mode<=0;
        else if(!S_motion_mode && S_k2_long && S_ui_mode==0) S_motion_mode<=1;
        if(S_motor_race_go || (S_motion_mode && S_replay_race_key && !S_motion_edit_allowed))
          S_motion_command<=S_motion_command+1'b1;
        if(S_motion_mode && S_motion_edit_allowed) begin
          if(S_k1_long)S_motion_edit<=S_motion_edit+1'b1;
          if(S_k3_step ^ S_k4_step) case(S_motion_edit)
            0: if(S_k4_step && S_motion_x<752)S_motion_x<=S_motion_x+4;
               else if(S_k3_step && S_motion_x>16)S_motion_x<=S_motion_x-4;
            1: if(S_k4_step && S_motion_y<528)S_motion_y<=S_motion_y+2;
               else if(S_k3_step && S_motion_y>472)S_motion_y<=S_motion_y-2;
            2: if(S_k4_step && S_motion_line<55)S_motion_line<=S_motion_line+1'b1;
               else if(S_k3_step && S_motion_line>8)S_motion_line<=S_motion_line-1'b1;
            3: if(S_k4_step && S_motion_threshold<64)S_motion_threshold<=S_motion_threshold+1'b1;
               else if(S_k3_step && S_motion_threshold>8)S_motion_threshold<=S_motion_threshold-1'b1;
          endcase
        end
      end
    end
    wire [63:0] S_motion_config={S_motion_mode,S_motion_command,S_motion_x,S_motion_y,
                               S_motion_line,8'd20,S_motion_threshold,12'd0};
    wire [63:0] S_motion_config_camera;
    ae_mailbox #(.WIDTH(64)) u_motion_config_bridge (
      .s_clk(S_hdmi_pixel_clk),.s_rst_n(S_color_p_rst_n),.s_send(1'b1),.s_data(S_motion_config),.s_ready(),
      .d_clk(S_csi_rx_clk),.d_rst_n(S_motion_camera_release[1]),.d_valid(),.d_data(S_motion_config_camera));
    always @(posedge S_csi_rx_clk or negedge S_color_common_rst_n)
      if(!S_color_common_rst_n) S_motion_camera_release<=0;
      else S_motion_camera_release<={S_motion_camera_release[0],1'b1};
    motion_finish_trial #(.EXTERNAL_SOURCE_ID(1),.HORIZONTAL_ENABLE(1),.UNIQUE_RANK_ENABLE(1)) u_motion_finish_trial (
      .clk(S_csi_rx_clk),.rst_n(S_ddr_camera_rst_n),
      .valid_i(S_ae_valid),.user_i(S_ae_user),.rgb_i(S_ae_rgb),
      .config_i(S_motion_config_camera),.hold_ack_i(S_motion_ack_cam_sync[1]),
      .hold_o(S_motion_hold_camera),.status_o(S_motion_camera_status),
      .source_i(S_motion_source_tag),.race_o(S_motion_race),.active_o(S_motion_active),.geometry_o(S_motion_geometry),
      .decision_o(S_decision_valid),.decision_source_o(S_decision_source),.decision_race_o(S_decision_race),
      .decision_mask_o(S_decision_mask),.decision_good_o(S_decision_good));
    // 在既有原子状态mailbox中附带完整raceID，屏幕状态仍保持原192位格式。
    ae_mailbox #(.WIDTH(224)) u_motion_status_bridge (
      .s_clk(S_csi_rx_clk),.s_rst_n(S_motion_camera_release[1]),.s_send(1'b1),.s_data({S_motion_race,S_motion_camera_status}),.s_ready(),
      .d_clk(S_hdmi_pixel_clk),.d_rst_n(S_color_p_rst_n),.d_valid(S_motion_status_valid),.d_data({S_motion_display_race,S_motion_display_status}));

    wire [39:0] S_can_probe_registers;
    wire [7:0] S_can_probe_host,S_can_probe_status;
    wire [2:0] S_can_probe_stage;
    wire [15:0] S_can_probe_context;
    wire [127:0] S_can_probe_snapshot;
    wire S_can_probe_valid;
    wire S_motor_arm,S_motor_reference;
    reg S_motor_reference_previous;
    (* async_reg="true" *) reg S_can_receive_meta,S_can_receive_level;
    wire S_motor_bus_reset,S_can_ready,S_can_fault;
    wire S_motor_request,S_motor_command_ready,S_motor_command_done,S_motor_command_ok,S_motor_axis;
    wire [3:0] S_motor_command;
    wire signed [15:0] S_motor_target;
    wire [3:0] S_motor_command_error;
    wire [7:0] S_motor_status;
    wire S_motor_position_negative;
    wire [31:0] S_motor_position_magnitude;
    wire S_can_tx_valid,S_can_tx_ready,S_can_tx_done,S_can_rx_valid;
    wire [28:0] S_can_tx_identifier,S_can_rx_identifier;
    wire [3:0] S_can_tx_length,S_can_rx_length;
    wire [63:0] S_can_tx_payload,S_can_rx_payload;
    color_switch_ctrl #(.STABLE_CYCLES(1500000)) u_motor_arm_switch (
      .clk(S_hdmi_pixel_clk),.rst_n(S_color_p_rst_n),.I_switch(I_motor_arm),.O_level(S_motor_arm));
    color_switch_ctrl #(.STABLE_CYCLES(1500000)) u_motor_reference_switch (
      .clk(S_hdmi_pixel_clk),.rst_n(S_color_p_rst_n),.I_switch(I_motor_reference),.O_level(S_motor_reference));
    always @(posedge S_hdmi_pixel_clk or negedge S_color_p_rst_n)
      if(!S_color_p_rst_n)begin S_motor_reference_previous<=0;S_can_receive_meta<=1;S_can_receive_level<=1;end
      else begin S_motor_reference_previous<=S_motor_reference;S_can_receive_meta<=I_can_receive;S_can_receive_level<=S_can_receive_meta;end
    wire S_motor_protocol_rst_n=S_color_p_rst_n && !S_motor_bus_reset;
    RaceMotorControl u_motor_control (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_color_p_rst_n),.i_arm(S_motor_arm),
      .i_reference(S_motor_reference && !S_motor_reference_previous),
      .i_new_race(S_motion_mode && S_replay_race_key && S_motion_edit_allowed),.o_race_go(S_motor_race_go),
      .i_final_valid(S_motion_status_valid && S_motion_state==4),.i_final_race(S_motion_display_race),
      .i_final_ranks(S_motion_display_status[151:146]),.i_final_arrived(S_motion_display_status[154:152]),
      .i_final_fault(S_motion_display_status[158:155]),.i_bus_ready(S_can_ready),.o_bus_reset(S_motor_bus_reset),
      .o_request(S_motor_request),.i_command_ready(S_motor_command_ready),.i_command_done(S_motor_command_done),
      .i_command_ok(S_motor_command_ok),.i_command_error(S_motor_command_error),.i_motor_status(S_motor_status),
      .i_position_negative(S_motor_position_negative),.i_position_magnitude(S_motor_position_magnitude),
      .o_axis(S_motor_axis),.o_command(S_motor_command),.o_target(S_motor_target),.o_state(S_motor_state),.o_error(S_motor_error));
    CanFaultSnapshot u_can_probe (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_color_p_rst_n),.i_arm(S_motor_arm),
      .i_stage(S_can_probe_stage),.i_context(S_can_probe_context),.i_registers(S_can_probe_registers),
      .i_host(S_can_probe_host),.i_status(S_can_probe_status),.i_done(S_motor_command_done),.i_ok(S_motor_command_ok),
      .i_motor_state(S_motor_state),.i_tx_accept(S_can_tx_valid && S_can_tx_ready),.i_tx_done(S_can_tx_done),
      .i_can_ready(S_can_ready),.i_can_fault(S_can_fault),.i_protocol_rstn(S_motor_protocol_rst_n),
      .i_transmit(O_can_transmit),.i_receive(S_can_receive_level),
      .o_valid(S_can_probe_valid),.o_snapshot(S_can_probe_snapshot));
    EmmCommandInterface u_motor_commands (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_motor_protocol_rst_n),.i_request(S_motor_request),.o_ready(S_motor_command_ready),
      .i_axis(S_motor_axis),.i_command(S_motor_command),.i_target(S_motor_target),
      .o_done(S_motor_command_done),.o_ok(S_motor_command_ok),.o_error(S_motor_command_error),
      .o_motor_status(S_motor_status),.o_position_negative(S_motor_position_negative),.o_position_magnitude(S_motor_position_magnitude),
      .o_tx_valid(S_can_tx_valid),.i_tx_ready(S_can_tx_ready),.o_tx_identifier(S_can_tx_identifier),
      .o_tx_length(S_can_tx_length),.o_tx_payload(S_can_tx_payload),.i_tx_done(S_can_tx_done),
      .i_rx_valid(S_can_rx_valid),.i_rx_identifier(S_can_rx_identifier),.i_rx_length(S_can_rx_length),
      .i_rx_payload(S_can_rx_payload),.i_transport_fault(S_can_fault),
      .o_probe_stage(S_can_probe_stage),.o_probe_context(S_can_probe_context));
    CanPacketInterface u_motor_can (
      .i_clk(S_hdmi_pixel_clk),.i_rstn(S_motor_protocol_rst_n),.i_receive(S_can_receive_level),.o_transmit(O_can_transmit),
      .i_tx_valid(S_can_tx_valid),.o_tx_ready(S_can_tx_ready),.i_tx_identifier(S_can_tx_identifier),
      .i_tx_length(S_can_tx_length),.i_tx_payload(S_can_tx_payload),.o_tx_done(S_can_tx_done),
      .o_rx_valid(S_can_rx_valid),.o_rx_identifier(S_can_rx_identifier),.o_rx_length(S_can_rx_length),
      .o_rx_payload(S_can_rx_payload),.o_ready(S_can_ready),.o_fault(S_can_fault),
      .o_probe_registers(S_can_probe_registers),.o_probe_host(S_can_probe_host),.o_probe_status(S_can_probe_status));

    wire [239:0] S_ui_edit_bus;
    wire [239:0] S_param_eff;
    wire         S_ui_commit_req;
    wire         S_ui_preview;
    wire [9:0] S_ui_view_frame;
    wire         S_ui_edit, S_ui_panel, S_ui_edge_toggle, S_ui_status_show;
    wire [2:0]   S_ui_page;
    wire [1:0]   S_ui_cursor;
    wire S_ui_restore_sel, S_ui_committed;

    color_ui_fsm #(
        .MS_CYC      ( 75000 ),
        .DEF_R_DIFF  ( 24 ), .DEF_R_RG_Q5 ( 48 ), .DEF_R_RB_Q5 ( 48 ),
        .DEF_G_DIFF  ( 12 ), .DEF_G_GR_Q5 ( 36 ), .DEF_G_GB_Q5 ( 48 ),
        .DEF_DB_DIFF ( 12 ), .DEF_DB_BR_Q5( 48 ), .DEF_DB_BG_Q5( 40 ),
        .DEF_LB_DIFF ( 20 ), .DEF_LB_BR_Q5( 40 ), .DEF_LB_GR_Q5( 40 ),
        .DEF_MIN_LUMA( 44 ), .DEF_MIN_SAT ( 18 ), .DEF_MIN_AREA( 32 )
    ) u_color_ui (
        .clk             ( S_hdmi_pixel_clk  ),
        .rst_n           ( S_color_p_rst_n      ),
        .I_preview_select( S_switch_preview  ),
        .I_k1_short      ( S_k1_short_color  ),
        .I_k1_long       ( S_k1_long && !S_motion_mode ),
        .I_k2_short      ( S_k2_short_color  ),
        .I_k2_long       ( S_k2_long && !S_motion_mode ),
        .I_k3_step       ( S_k3_step         ),
        .I_k4_step       ( S_k4_step         ),
        .I_k4_long15     ( S_k4_long15       ),
        .I_eff           ( S_param_eff       ),
        .O_edit_bus      ( S_ui_edit_bus     ),
        .O_commit_req    ( S_ui_commit_req   ),
        .O_mode          ( S_ui_mode         ),
        .O_edit          ( S_ui_edit         ),
        .O_panel         ( S_ui_panel        ),
        .O_preview       ( S_ui_preview      ),
        .O_page          ( S_ui_page         ),
        .O_cursor        ( S_ui_cursor       ),
        .O_edge_toggle   ( S_ui_edge_toggle  ),
        .O_status_show   ( S_ui_status_show  ),
        .O_restore_sel   ( S_ui_restore_sel  )
    );

    // SD persistence is absent. Preserve pad locations with inactive SPI levels.
    assign O_sd_clk=1'b0;
    assign O_sd_mosi=1'b1;
    assign O_sd_cs_n=1'b1;

    // DDR reads retain the original raster cadence; only downstream pixels/control delay.
    wire S_clean_vs,S_clean_hs,S_clean_de,S_clean_user,S_clean_last;
    wire [23:0] S_clean_rgb;
    assign S_hdmi_window_rd_en = S_hdmi_de;
    color_chroma_denoise #(.H_TOTAL(1650)) u_color_chroma_denoise (
        .clk(S_hdmi_pixel_clk),.rst_n(S_hdmi_rst_n),
        .vs_i(S_hdmi_vsync),.hs_i(S_hdmi_hsync),.de_i(S_hdmi_de),
        .user_i(S_hdmi_user),.last_i(S_hdmi_last),.rgb_i(S_video_rd_data),
        .vs_o(S_clean_vs),.hs_o(S_clean_hs),.de_o(S_clean_de),
        .user_o(S_clean_user),.last_o(S_clean_last),.rgb_o(S_clean_rgb));

    hdmi_mixer #(
        .AE_DEBUG_ENABLE(1),
        .DDR_DIAG_ENABLE(1),
        .H_OFFSET   ( 0    ),
        .V_OFFSET   ( 0    ),
        .IMG_WIDTH  ( 1280 ),
        .IMG_HEIGHT ( 720  ),
        .BLUE_BACKGROUND_ENABLE(0),
        .EDGE_DENOISE_ENABLE(1),
        .EDGE_COHERENCE_ENABLE(1),
    .EDGE_OPT_ENABLE(1),
    .EDGE_FILL_ENABLE(1),
        .EDGE_FILL_MIN_BG_RUN(8),
        .EDGE_FILL_ROW_STEP(2),          // 隔行 OR 捕获，RUN 预算约翻倍
        .BG_NOISE_CAL_ENABLE(0),
        .EDGE_COMPARE_ENABLE(1),
        .DET_MIN_DIFF_R(24),
        .DET_RATIO_SHIFT(1),
        .DET_EXTENDED_BLUE(0),
        .DET_B_G_RATIO_Q2(5),
        .DET_MIN_DIFF_B(12),
        .DEBUG_MODE ( 0    ), // Normal SC500 1280x720 camera image
        .VIDEO_SRC  ( 1    ), // 上电默认档：1 = 原图直通（彩色）；0 = 灰度
        .UI_ENABLE  ( 1    )  // 1 = 四键 UI + 运行时颜色参数
    )u_hdmi_mixer(
        .I_clk           ( S_hdmi_pixel_clk   ),
        .I_rst_n         ( S_hdmi_rst_n       ),
        .I_video_vsync   ( S_clean_vs       ),
        .I_video_hsync   ( S_clean_hs       ),
        .I_video_de      ( S_clean_de          ),
        .I_video_user    ( S_clean_user        ),
        .I_video_last    ( S_clean_last        ),
        .I_ae_status(S_ae_display),
        .I_ddr_status(S_ddr_video_status),
        .I_debug_status  ( S_hdmi_debug_status),
        .I_key_src_trig  ( 1'b0               ),
        .I_key_det_trig  ( 1'b0               ),
        .I_fill_k1_short ( S_k1_short         ),
        .I_fill_k1_long  ( S_k1_long          ),
        .I_fill_k3_step  ( S_k3_step          ),
        .I_fill_k4_step  ( S_k4_step          ),
        .I_ui_mode       ( S_ui_mode          ),
        .I_ui_view       ({S_ui_panel,S_ui_edit,S_ui_page,S_ui_cursor,S_ui_preview}),
        .O_ui_view       ( S_ui_view_frame    ),
        .I_ui_edge_toggle( S_ui_edge_toggle   ),
        .I_ui_edit_bus   ( S_ui_edit_bus      ),
        .I_ui_commit_req ( S_ui_commit_req    ),
        .O_param_eff     ( S_param_eff        ),
        .O_param_version ( S_param_version ),
        .O_param_committed(S_ui_committed     ),
        .O_fill_edit     ( S_fill_edit        ),
        .O_fill_run_count(                    ),
        .O_fill_overflow (                    ),
        .I_bg_calibrate  ( 1'b0               ),
        .O_video_rd_en   ( ),
        .I_video_rd_data ( S_clean_rgb    ),
        .O_hdmi_vsync    ( S_hdmi_out_vsync   ),
        .O_hdmi_hsync    ( S_hdmi_out_hsync   ),
        .O_hdmi_de       ( S_hdmi_out_de      ),
        .O_hdmi_data     ( S_hdmi_out_data    )
    );

    // ------------------------------------------------------------------
    // 菜单叠加：在 mixer 输出的最终像素流上再叠一层（坐标由模块内部按 de 重建，
    // 与输出严格同拍）；只在 COLOR 档且编辑态/状态提示时可见。
    // ------------------------------------------------------------------
    wire        S_menu_hit;
    wire [23:0] S_menu_color;
    wire        S_menu_show   = (S_ui_view_frame[9:8] == 2'd3) && S_ui_view_frame[6] && S_ui_view_frame[7];
    wire        S_menu_status = (S_ui_view_frame[9:8] == 2'd3) && S_ui_status_show;

    color_menu_osd u_color_menu (
        .clk         ( S_hdmi_pixel_clk ),
        .rst_n       ( S_hdmi_rst_n     ),
        .de_i        ( S_hdmi_out_de    ),
        .vsync_i     ( S_hdmi_out_vsync ),
        .show_i      ( S_menu_show      ),
        .status_i    ( S_menu_status    ),
        .page_i      ( S_ui_view_frame[5:3] ),
        .cursor_i    ( S_ui_view_frame[2:1] ),
        .value_bus   ( S_param_eff    ),
        .pending_i(S_ui_commit_req),.loading_i(1'b0),
        .save_state  ( 3'd0             ),
        .hit_o       ( S_menu_hit       ),
        .color_o     ( S_menu_color     )
    );

    wire S_motion_osd_hit,S_replay_osd_hit;
    wire [23:0] S_replay_osd_color;
    wire S_replay_displayed=S_replay_feedback[62];
    wire [26:0] S_replay_display_geometry=S_replay_feedback[27:1];
    motion_replay_osd #(.HORIZONTAL_ENABLE(1)) u_replay_osd (
      .clk(S_hdmi_pixel_clk),.rst_n(S_hdmi_rst_n),.de_i(S_hdmi_out_de),.vs_i(S_hdmi_out_vsync),
      .mode_i(S_motion_mode),.no_evidence_i(S_replay_empty_hint),.fault_i(S_replay_feedback[64]),.applied_i(S_replay_feedback[63:0]),
      .hit_o(S_replay_osd_hit),.color_o(S_replay_osd_color));
    wire [23:0] S_motion_osd_color;
    motion_trial_osd #(.HORIZONTAL_ENABLE(1),.CAN_PROBE_ENABLE(1)) u_motion_trial_osd (
      .clk(S_hdmi_pixel_clk),.rst_n(S_hdmi_rst_n),.de_i(S_hdmi_out_de),.vs_i(S_hdmi_out_vsync),
      .enable_i(S_motion_mode),.edit_i(S_motion_edit),.motor_i({S_motor_state,S_motor_error}),
      .probe_valid_i(S_can_probe_valid),.probe_i(S_can_probe_snapshot),
      .base_x_i(S_replay_displayed?S_replay_display_geometry[26:16]:S_motion_x),
      .base_y_i(S_replay_displayed?S_replay_display_geometry[15:6]:S_motion_y),
      .line_i(S_replay_displayed?S_replay_display_geometry[5:0]:S_motion_line),.status_i({S_replay_displayed,S_motion_display_status[190:0]}),.hit_o(S_motion_osd_hit),.color_o(S_motion_osd_color));
    wire [23:0] S_hdmi_final_data = S_replay_osd_hit ? S_replay_osd_color : S_motion_osd_hit ? S_motion_osd_color : (S_menu_hit ? S_menu_color : S_hdmi_out_data);

    hdmi_tx u_hdmi_tx(
        .I_pixel_clk        ( S_hdmi_pixel_clk  ),
        .I_serial_clk       ( S_hdmi_serial_clk ),
        .I_rst              ( ~S_hdmi_rst_n     ),
        .I_key_in           ( 1'b0              ),
        .I_edid_read_trig   ( 1'b0              ),
        .O_edid_read_valid  (                   ),
        .O_edid_read_data   (                   ),
        .I_video_rgb_enable ( 1'b1              ),
        .I_video_in_vs      ( S_hdmi_out_vsync  ),
        .I_video_in_de      ( S_hdmi_out_de     ),
        .I_video_in_user    ( 1'b0              ),
        .I_video_in_valid   ( 1'b0              ),
        .I_video_in_last    ( 1'b0              ),
        .O_video_in_ready   (                   ),
        .I_video_in_data    ( S_hdmi_final_data ),
        .I_audio_valid      ( 1'b0              ),
        .I_audio_left_data  ( 24'd0             ),
        .I_audio_right_data ( 24'd0             ),
        .I_i2s_BCLK         ( 1'b0              ),
        .I_i2s_LRCK         ( 1'b0              ),
        .I_i2s_DOUT         ( 1'b0              ),
        .O_ddc_scl          (                   ),
        .O_hdmi_clk_p       (                   ),
        .O_hdmi_tx_p        (                   ),
        .O_tmds_ch0_p       ( O_tmds_ch0_p      ),
        .O_tmds_ch1_p       ( O_tmds_ch1_p      ),
        .O_tmds_ch2_p       ( O_tmds_ch2_p      ),
        .O_tmds_clk_p       ( O_tmds_clk_p      )
    );


    
endmodule
