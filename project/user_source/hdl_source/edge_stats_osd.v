// Previous completed raster's edge points P and horizontal runs S, six decimal
// digits each. Glyph data comes from the unchanged official osd_char_lib.
module edge_stats_osd #(
    parameter integer IMG_H=720
)(
    input wire clk,
    input wire rst_n,
    input wire frame_done_i,
    input wire [23:0] points_i,
    input wire [23:0] runs_i,
    input wire frame_start_i,
    input wire enable_i,
    input wire de_i,
    input wire [11:0] x_i,
    input wire [11:0] y_i,
    output wire hit_o
);
    reg [19:0] point_shift,run_shift;
    reg [23:0] point_work,run_work;
    reg [23:0] point_result,run_result;
    reg [23:0] display_points_bcd,display_runs_bcd;
    reg [4:0] remaining;
    reg busy;
    reg [23:0] point_adjusted,run_adjusted;
    integer digit;
    // Decimal conversion uses twenty clocks, entirely outside the pixel path.
    always @(*)begin
        point_adjusted=point_work;run_adjusted=run_work;
        for(digit=0;digit<6;digit=digit+1)begin
            if(point_work[digit*4 +: 4]>=5)point_adjusted[digit*4 +: 4]=point_work[digit*4 +: 4]+4'd3;
            if(run_work[digit*4 +: 4]>=5)run_adjusted[digit*4 +: 4]=run_work[digit*4 +: 4]+4'd3;
        end
    end
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            point_shift<=0;run_shift<=0;point_work<=0;run_work<=0;
            point_result<=0;run_result<=0;display_points_bcd<=0;display_runs_bcd<=0;
            remaining<=0;busy<=0;
        end else begin
            if(frame_done_i)begin
                point_shift<=points_i[19:0];run_shift<=runs_i[19:0];
                point_work<=0;run_work<=0;remaining<=20;busy<=1;
            end else if(busy)begin
                point_work<={point_adjusted[22:0],point_shift[19]};
                run_work<={run_adjusted[22:0],run_shift[19]};
                point_shift<={point_shift[18:0],1'b0};run_shift<={run_shift[18:0],1'b0};
                remaining<=remaining-1'b1;
                if(remaining==1)begin
                    point_result<={point_adjusted[22:0],point_shift[19]};
                    run_result<={run_adjusted[22:0],run_shift[19]};busy<=0;
                end
            end
            if(frame_start_i)begin display_points_bcd<=point_result;display_runs_bcd<=run_result;end
        end
    end
    localparam integer BASE_Y=IMG_H-20;
    wire inside=IMG_H>=32 && de_i && x_i>=16 && x_i<256 && y_i>=BASE_Y && y_i<BASE_Y+16;
    wire [11:0] local_x=x_i-12'd16;
    wire [11:0] local_y=y_i-BASE_Y;
    reg [7:0] character;
    always @(*)begin
        case(local_x[7:4])
            0:character=8'h50;
            1:character=8'h30+display_points_bcd[23:20];
            2:character=8'h30+display_points_bcd[19:16];
            3:character=8'h30+display_points_bcd[15:12];
            4:character=8'h30+display_points_bcd[11:8];
            5:character=8'h30+display_points_bcd[7:4];
            6:character=8'h30+display_points_bcd[3:0];
            8:character=8'h53;
            9:character=8'h30+display_runs_bcd[23:20];
            10:character=8'h30+display_runs_bcd[19:16];
            11:character=8'h30+display_runs_bcd[15:12];
            12:character=8'h30+display_runs_bcd[11:8];
            13:character=8'h30+display_runs_bcd[7:4];
            14:character=8'h30+display_runs_bcd[3:0];
            default:character=8'h20;
        endcase
    end
    wire [15:0] row_bits;
    osd_char_lib glyph(.I_char(character),.I_row(local_y[3:0]),.O_row_bits(row_bits));
    assign hit_o=enable_i && inside && row_bits[15-local_x[3:0]];
endmodule
