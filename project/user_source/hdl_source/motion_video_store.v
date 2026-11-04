`timescale 1ns / 1ps
// Seven-slot camera writer and evidence store. Existing DDR user/physical paths remain.
// All source metadata is paired with payload SOF tags, not display raster counters.
module motion_video_store #(
    parameter integer IMAGE_WIDTH=1280, IMAGE_HEIGHT=720
)(
    input wire camera_clk, camera_rst_n, ddr_clk, ddr_rst_n,
    input wire user_i, valid_i,
    input wire [95:0] rgb_i,
    input wire [31:0] source_i, race_i,
    input wire [26:0] geometry_i,
    input wire track_i, enable_i,
    input wire decision_i,
    input wire [31:0] decision_source_i, decision_race_i,
    input wire [2:0] decision_mask_i,
    input wire decision_good_i,
    input wire read_busy_i,
    input wire [6:0] read_protect_i,
    input wire user_ready_i, controller_write_i,
    input wire [1:0] view_lane_i,
    output wire write_busy_o,
    output reg write_o,
    output reg [24:0] address_o,
    output reg [127:0] data_o,
    output wire [2:0] view_slot_o,
    output wire [31:0] view_source_o,
    output wire view_valid_o,
    output wire [2:0] evidence_valid_o,
    output wire live_valid_o,
    output wire [2:0] live_slot_o,
    output wire [31:0] live_source_o,
    output wire [6:0] pinned_o,
    output wire [26:0] geometry_o,
    output wire fault_o
);
    localparam integer WORDS=IMAGE_WIDTH*IMAGE_HEIGHT*3/16;
    localparam [3:0] IDLE=0,FETCH=1,DATA=2,HEADER=3,ALLOCATE=4,EMIT=5,GAP=6;
    reg [3:0] state;
    reg [8:0] remaining, burst_wait;
    reg [5:0] allocation_wait;
    reg owned, frame_active, frame_closed, writer_fault;
    reg [2:0] frame_slot;
    reg [18:0] frame_words;
    reg [24:0] frame_base;
    reg [127:0] held_data;
    reg [1:0] held_tag;
    reg [64:0] held_header;
    reg [31:0] issued, committed;
    reg queued_pulse, queued_good;
    reg [2:0] queued_slot;
    reg [31:0] queued_fence;
    wire [127:0] pixel_data;
    wire [1:0] pixel_tag;
    wire pixel_empty,start_empty,end_empty,camera_fault;
    wire [64:0] start_packet;
    wire [32:0] end_packet;
    wire pixel_read=state==FETCH && !pixel_empty;
    wire start_read=state==DATA && pixel_tag[0] && !start_empty;
    reg [1:0] end_state,decision_state;
    wire end_read=end_state==0 && !end_empty;
    wire decision_empty,decision_full;
    wire [67:0] decision_packet;
    wire decision_read=decision_state==0 && !decision_empty;
    wire validation_ready,decision_ready,allocation_ready;
    wire [2:0] allocation_slot;
    wire missing;
    wire [59:0] control_ddr;
    wire control_valid;
    (* async_reg="true" *) reg camera_fault_meta,camera_fault_sync,decision_fault_meta,decision_fault_sync;
    reg decision_fault;reg [31:0] decision_race_seen,writer_race_seen;
    assign write_busy_o=owned || write_o;
    assign fault_o=writer_fault || camera_fault_sync || decision_fault_sync || missing;
    assign geometry_o=control_ddr[58:32];
    function [24:0] base;
        input [2:0] slot;
        begin case(slot)
            0:base=0;1:base=3000000;2:base=6000000;3:base=9000000;
            4:base=12000000;5:base=15000000;default:base=18000000;
        endcase end
    endfunction
    motion_frame_capture #(.IMAGE_WIDTH(IMAGE_WIDTH),.IMAGE_HEIGHT(IMAGE_HEIGHT)) u_capture (
        .camera_clk(camera_clk),.camera_rst_n(camera_rst_n),.ddr_clk(ddr_clk),.ddr_rst_n(ddr_rst_n),
        .user_i(user_i),.valid_i(valid_i),.rgb_i(rgb_i),.source_i(source_i),.race_i(race_i),.track_i(track_i),
        .pixel_read_i(pixel_read),.pixel_data_o(pixel_data),.pixel_tag_o(pixel_tag),.pixel_empty_o(pixel_empty),
        .start_read_i(start_read),.start_data_o(start_packet),.start_empty_o(start_empty),
        .end_read_i(end_read),.end_data_o(end_packet),.end_empty_o(end_empty),.fault_o(camera_fault));
    motion_meta_fifo #(.WIDTH(68),.ADDR_WIDTH(2)) u_decisions (
        .wr_clk(camera_clk),.wr_rst_n(camera_rst_n),.wr_en_i(decision_i && !decision_full),
        .wr_data_i({decision_source_i,decision_race_i,decision_mask_i,decision_good_i}),.full_o(decision_full),
        .rd_clk(ddr_clk),.rd_rst_n(ddr_rst_n),.rd_en_i(decision_read),.rd_data_o(decision_packet),.empty_o(decision_empty));
    ae_mailbox #(.WIDTH(60)) u_control (
        .s_clk(camera_clk),.s_rst_n(camera_rst_n),.s_send(1'b1),.s_data({enable_i,geometry_i,race_i}),.s_ready(),
        .d_clk(ddr_clk),.d_rst_n(ddr_rst_n),.d_valid(control_valid),.d_data(control_ddr));
    motion_frame_store_ctrl u_slots (
        .clk(ddr_clk),.rst_n(ddr_rst_n),.race_i(control_ddr[31:0]),.clear_i(!control_ddr[59]),
        .cancel_analysis_i(1'b0),.read_protect_i(read_protect_i),
        .allocate_i(state==ALLOCATE && allocation_ready),.allocate_source_i(held_header[64:33]),
        .allocate_race_i(held_header[32:1]),.allocate_track_i(held_header[0]),
        .allocate_ready_o(allocation_ready),.allocate_slot_o(allocation_slot),
        .queued_i(queued_pulse),.queued_slot_i(queued_slot),.queued_good_i(queued_good),
        .queued_fence_i(queued_fence),.committed_i(committed),
        .validate_i(end_state==2),.validate_source_i(end_packet[32:1]),.validate_good_i(end_packet[0]),
        .validate_ready_o(validation_ready),.decision_i(decision_state==2),
        .decision_source_i(decision_packet[67:36]),.decision_race_i(decision_packet[35:4]),
        .decision_mask_i(decision_packet[3:1]),.decision_good_i(decision_packet[0]),.decision_ready_o(decision_ready),
        .view_lane_i(view_lane_i),.view_slot_o(view_slot_o),.view_source_o(view_source_o),.view_valid_o(view_valid_o),
        .evidence_valid_o(evidence_valid_o),.pinned_o(pinned_o),.live_valid_o(live_valid_o),
        .live_slot_o(live_slot_o),.live_source_o(live_source_o),.missing_o(missing));
    always @(posedge camera_clk or negedge camera_rst_n)
        if(!camera_rst_n)begin decision_fault<=0;decision_race_seen<=0;end
        else begin
            if(race_i!=decision_race_seen)begin decision_fault<=0;decision_race_seen<=race_i;end
            if(decision_i && decision_full)decision_fault<=1;
        end
    always @(posedge ddr_clk or negedge ddr_rst_n) begin
        if(!ddr_rst_n) begin
            camera_fault_meta<=0;camera_fault_sync<=0;decision_fault_meta<=0;decision_fault_sync<=0;
            end_state<=0;decision_state<=0;
        end else begin
            camera_fault_meta<=camera_fault;camera_fault_sync<=camera_fault_meta;
            decision_fault_meta<=decision_fault;decision_fault_sync<=decision_fault_meta;
            case(end_state)
                0:if(!end_empty)end_state<=1;
                1:end_state<=2;
                default:if(validation_ready)end_state<=0;
            endcase
            case(decision_state)
                0:if(!decision_empty)decision_state<=1;
                1:decision_state<=2;
                default:if(decision_ready)decision_state<=0;
            endcase
        end
    end
    // A deliberately bounded burst owner preserves the existing read/write arbitration.
    // GAP ensures the old continuous-write starvation failure cannot recur.
    always @(posedge ddr_clk or negedge ddr_rst_n) begin
        if(!ddr_rst_n) begin
            state<=IDLE;remaining<=0;burst_wait<=0;allocation_wait<=0;
            owned<=0;frame_active<=0;frame_closed<=0;writer_fault<=0;
            frame_slot<=0;frame_words<=0;frame_base<=0;held_data<=0;held_tag<=0;held_header<=0;
            issued<=0;committed<=0;writer_race_seen<=0;queued_pulse<=0;queued_slot<=0;queued_good<=0;queued_fence<=0;
            write_o<=0;address_o<=0;data_o<=0;
        end else begin
            write_o<=0;queued_pulse<=0;
            if(control_ddr[31:0]!=writer_race_seen)begin writer_race_seen<=control_ddr[31:0];writer_fault<=0;end
            if(write_o)issued<=issued+1'b1;
            if(controller_write_i)committed<=committed+1'b1;
            case(state)
                IDLE:begin
                    owned<=0;
                    if(!pixel_empty && !read_busy_i && user_ready_i) begin
                        owned<=1;remaining<=240;burst_wait<=0;state<=FETCH;
                    end
                end
                FETCH:begin
                    if(!pixel_empty) begin state<=DATA;remaining<=remaining-1'b1;burst_wait<=0;end
                    else if(burst_wait==31)begin owned<=0;state<=GAP;end
                    else burst_wait<=burst_wait+1'b1;
                end
                DATA:begin
                    held_data<=pixel_data;held_tag<=pixel_tag;
                    if(pixel_tag[0])begin
                        if(frame_active && !frame_closed)begin
                            queued_pulse<=1;queued_slot<=frame_slot;queued_good<=0;queued_fence<=issued;
                        end
                        frame_active<=0;frame_closed<=0;
                        if(!start_empty)state<=HEADER;
                        else begin writer_fault<=1;state<=remaining==0?GAP:FETCH;end
                    end else if(frame_active && !frame_closed && frame_words<WORDS)state<=EMIT;
                    else begin
                        if(frame_active && !frame_closed)writer_fault<=1;
                        state<=remaining==0?GAP:FETCH;
                    end
                end
                HEADER:begin held_header<=start_packet;allocation_wait<=0;state<=ALLOCATE;end
                ALLOCATE:begin
                    if(allocation_ready)begin
                        frame_slot<=allocation_slot;frame_base<=base(allocation_slot);frame_words<=0;
                        frame_active<=1;frame_closed<=0;state<=EMIT;
                    end else if(allocation_wait==63)begin
                        writer_fault<=1;frame_active<=0;state<=remaining==0?GAP:FETCH;
                    end else allocation_wait<=allocation_wait+1'b1;
                end
                EMIT:if(user_ready_i)begin
                    write_o<=1;address_o<=frame_base+{frame_words,3'b0};data_o<=held_data;
                    frame_words<=frame_words+1'b1;
                    if(frame_words==WORDS-1 || held_tag[1])begin
                        queued_pulse<=1;queued_slot<=frame_slot;
                        queued_good<=(frame_words==WORDS-1 && held_tag[1]);
                        queued_fence<=issued+1'b1;frame_closed<=1;
                        if(!(frame_words==WORDS-1 && held_tag[1]))writer_fault<=1;
                    end
                    if(remaining==0)begin owned<=0;state<=GAP;end else state<=FETCH;
                end
                GAP:begin owned<=0;state<=IDLE;end
                default:begin writer_fault<=1;owned<=0;state<=GAP;end
            endcase
        end
    end
endmodule
