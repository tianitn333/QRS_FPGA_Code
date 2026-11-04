// Raster-to-event extraction. Runs are maximal horizontal white intervals;
// endpoints are inclusive. No FIFO, frame buffer, backpressure or gap joining.
module edge_extract #(
    parameter integer IMG_H = 720
)(
    input wire clk,
    input wire rst_n,
    input wire valid_i,
    input wire user_i,
    input wire last_i,
    input wire edge_i,
    input wire [11:0] x_i,
    input wire [11:0] y_i,
    output reg point_valid_o,
    output reg [11:0] point_x_o,
    output reg [11:0] point_y_o,
    output reg [15:0] point_frame_o,
    output reg run_valid_o,
    output reg [11:0] run_start_o,
    output reg [11:0] run_end_o,
    output reg [11:0] run_y_o,
    output reg [12:0] run_length_o,
    output reg [15:0] run_frame_o,
    output reg frame_done_o,
    output reg [15:0] frame_id_o,
    output reg [23:0] frame_points_o,
    output reg [23:0] frame_runs_o,
    output reg bbox_valid_o,
    output reg [11:0] xmin_o,
    output reg [11:0] xmax_o,
    output reg [11:0] ymin_o,
    output reg [11:0] ymax_o
);
    reg frame_active;
    reg run_active;
    reg [15:0] frame_tag;
    reg [11:0] run_start;
    reg [11:0] previous_x;
    reg [23:0] point_count;
    reg [23:0] run_count;
    reg [11:0] xmin,xmax,ymin,ymax;

    wire consume = valid_i && (user_i || frame_active);
    wire pending_run = run_active && !user_i;
    wire close_run = consume && ((edge_i && last_i) || (!edge_i && pending_run));
    wire [11:0] first_x = pending_run ? run_start : x_i;
    wire [11:0] final_x = edge_i ? x_i : previous_x;
    wire [12:0] final_length = {1'b0,final_x}-{1'b0,first_x}+13'd1;
    wire [15:0] active_tag = user_i ? frame_tag+16'd1 : frame_tag;
    wire [23:0] point_base = user_i ? 24'd0 : point_count;
    wire [23:0] run_base = user_i ? 24'd0 : run_count;
    wire [23:0] next_points = point_base+{{23{1'b0}},edge_i};
    wire [23:0] next_runs = run_base+{{23{1'b0}},close_run};
    wire first_point = point_base==0;
    wire [11:0] next_xmin = edge_i ? ((first_point || x_i<xmin) ? x_i : xmin) : (user_i ? 12'd0 : xmin);
    wire [11:0] next_xmax = edge_i ? ((first_point || x_i>xmax) ? x_i : xmax) : (user_i ? 12'd0 : xmax);
    wire [11:0] next_ymin = edge_i ? ((first_point || y_i<ymin) ? y_i : ymin) : (user_i ? 12'd0 : ymin);
    wire [11:0] next_ymax = edge_i ? ((first_point || y_i>ymax) ? y_i : ymax) : (user_i ? 12'd0 : ymax);

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            frame_active<=0;run_active<=0;frame_tag<=0;
            run_start<=0;previous_x<=0;point_count<=0;run_count<=0;
            xmin<=0;xmax<=0;ymin<=0;ymax<=0;
            point_valid_o<=0;point_x_o<=0;point_y_o<=0;point_frame_o<=0;
            run_valid_o<=0;run_start_o<=0;run_end_o<=0;run_y_o<=0;run_length_o<=0;run_frame_o<=0;
            frame_done_o<=0;frame_id_o<=0;frame_points_o<=0;frame_runs_o<=0;
            bbox_valid_o<=0;xmin_o<=0;xmax_o<=0;ymin_o<=0;ymax_o<=0;
        end else begin
            point_valid_o<=0;run_valid_o<=0;frame_done_o<=0;
            if(consume)begin
                if(user_i)begin frame_tag<=active_tag;frame_active<=1;end
                point_count<=next_points;run_count<=next_runs;
                xmin<=next_xmin;xmax<=next_xmax;ymin<=next_ymin;ymax<=next_ymax;
                if(edge_i)begin
                    point_valid_o<=1;point_x_o<=x_i;point_y_o<=y_i;point_frame_o<=active_tag;
                    if(!pending_run)run_start<=x_i;
                    previous_x<=x_i;
                    run_active<=!last_i;
                end else run_active<=0;
                if(close_run)begin
                    run_valid_o<=1;run_start_o<=first_x;run_end_o<=final_x;run_y_o<=y_i;
                    run_length_o<=final_length;run_frame_o<=active_tag;
                end
                // EOF can coincide with the final white pixel and its run.
                if(last_i && y_i==IMG_H-1)begin
                    frame_active<=0;run_active<=0;frame_done_o<=1;frame_id_o<=active_tag;
                    frame_points_o<=next_points;frame_runs_o<=next_runs;
                    bbox_valid_o<=next_points!=0;
                    xmin_o<=next_xmin;xmax_o<=next_xmax;ymin_o<=next_ymin;ymax_o<=next_ymax;
                end
            end
        end
    end
endmodule
