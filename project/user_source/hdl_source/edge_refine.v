// Streaming contour preparation: four-direction nonmaximum suppression,
// bounded local hysteresis, and orientation-independent neighborhood support.
// Full eleven-bit magnitude ordering; coarse compatibility mode remains available.
module edge_refine #(
    parameter integer IMG_W=1280, IMG_H=720, FULL_PRECISION=1,
    parameter integer COHERENCE_ENABLE=0,
    parameter integer TANGENT_SUPPORT_ENABLE=0
)(
    input wire clk,rst_n,valid_i,user_i,last_i,
    input wire [12:0] gradient_i,
    input wire [1:0] fine_i,
    input wire polarity_i,
    output reg valid_o,
    output reg edge_o,
    output reg detection_o, // Center high-threshold Sobel result, aligned with edge_o.
    output reg [11:0] x_o,y_o
);
    function integer clog2;
        input integer value;
        integer bit_count;
        begin clog2=0;for(bit_count=1;bit_count<value;bit_count=bit_count*2)clog2=clog2+1;end
    endfunction
    localparam integer ADDR_X=clog2(IMG_W);
    reg [11:0] column,row;
    reg [1:0] write_bank;
    wire [11:0] input_x=user_i ? 12'd0 : column;
    wire [11:0] input_y=user_i ? 12'd0 : row;
    wire [1:0] current_bank=user_i ? 2'd0 : write_bank;
    wire [1:0] previous_bank=current_bank==0 ? 2'd2 : current_bank-1'b1;
    wire [1:0] oldest_bank=current_bank==2 ? 2'd0 : current_bank+1'b1;
    wire [ADDR_X-1:0] column_address=input_x[ADDR_X-1:0];
    wire [15:0] bank_read [0:2];
    genvar bank;
    generate for(bank=0;bank<3;bank=bank+1)begin: g_lines
        wire write_enable=valid_i && current_bank==bank;
        wire [8:0] magnitude_read;
        // Keep the original one-clock metadata read, using one 9x2048 ERAM
        // plane per 1280-pixel row instead of distributed RAM. Only previous/
        // oldest banks feed the window; the current write bank uses current_word.
        // Therefore same-address cross-port read/write data is never consumed.
        wire [8:0] metadata_read;
        PH1P_LOGIC_ERAM #(
            .DATA_WIDTH_A(9), .DATA_WIDTH_B(9),
            .ADDR_WIDTH_A(ADDR_X), .ADDR_WIDTH_B(ADDR_X),
            .DATA_DEPTH_A(IMG_W), .DATA_DEPTH_B(IMG_W),
            .MODE("DP"), .REGMODE_A("NOREG"), .REGMODE_B("NOREG"),
            .WRITEMODE_A("NORMAL"), .WRITEMODE_B("NORMAL"),
            .IMPLEMENT("20K(FAST)"), .ECC_ENCODE("DISABLE"), .ECC_DECODE("DISABLE"),
            .CLKMODE("ASYNC"), .SSROVERCE("DISABLE"),
            .OREGSET_A("RESET"), .OREGSET_B("RESET"),
            .RESETMODE_A("ASYNC"), .RESETMODE_B("ASYNC"),
            .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
            .INIT_FILE("NONE"), .FILL_ALL("NONE")
        ) metadata_memory (
            .dia({2'b00,(COHERENCE_ENABLE!=0 ? polarity_i : 1'b0),gradient_i[12:9],(FULL_PRECISION!=0 ? fine_i : 2'b00)}),
            .addra(column_address), .cea(1'b1), .clka(clk), .wea(write_enable),
            .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
            .dib(9'd0), .addrb(column_address), .ceb(1'b1), .clkb(clk), .web(1'b0),
            .beb(1'b0), .rstb(1'b0), .oceb(1'b0), .doa(), .dob(metadata_read),
            .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
        );
        assign bank_read[bank]={metadata_read[6:2],magnitude_read,metadata_read[1:0]};
    PH1P_LOGIC_ERAM #(
        .DATA_WIDTH_A(9),        .DATA_WIDTH_B(9),
        .ADDR_WIDTH_A(ADDR_X),   .ADDR_WIDTH_B(ADDR_X),
        .DATA_DEPTH_A(IMG_W),    .DATA_DEPTH_B(IMG_W),
        .MODE("DP"),
        .REGMODE_A("NOREG"),     .REGMODE_B("NOREG"),
        .WRITEMODE_A("NORMAL"),  .WRITEMODE_B("NORMAL"),
        .IMPLEMENT("20K(FAST)"),
        .ECC_ENCODE("DISABLE"),  .ECC_DECODE("DISABLE"),
        .CLKMODE("ASYNC"),
        .SSROVERCE("DISABLE"),
        .OREGSET_A("RESET"),     .OREGSET_B("RESET"),
        .RESETMODE_A("ASYNC"),   .RESETMODE_B("ASYNC"),
        .ASYNC_RESET_RELEASE_A("ASYNC"), .ASYNC_RESET_RELEASE_B("ASYNC"),
        .INIT_FILE("NONE"),      .FILL_ALL("NONE")
    ) magnitude_memory (
        .dia(gradient_i[8:0]), .addra(column_address), .cea(1'b1), .clka(clk), .wea(write_enable), .bea(1'b0), .rsta(1'b0), .ocea(1'b0),
        .dib(9'd0),   .addrb(column_address), .ceb(1'b1), .clkb(clk), .web(1'b0), .beb(1'b0), .rstb(1'b0), .oceb(1'b0),
        .doa(), .dob(magnitude_read),
        .ecc_sbiterr(), .ecc_dbiterr(), .ecc_sbiterrinj(1'b0), .ecc_dbiterrinj(1'b0)
    );

    end endgenerate
    reg [1:0] previous_select,oldest_select;
    reg [15:0] current_word;
    reg [11:0] read_x,read_y,window_x,window_y;
    reg read_valid,window_valid;
    reg [15:0] lower_right,lower_center,lower_left;
    reg [15:0] middle_right,middle_center,middle_left;
    reg [15:0] upper_right,upper_center,upper_left;
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            column<=0;row<=0;write_bank<=0;
            previous_select<=0;oldest_select<=0;current_word<=0;
            read_x<=0;read_y<=0;read_valid<=0;
        end else begin
            if(valid_i)begin
                if(user_i)begin column<=1;row<=0;write_bank<=0;end
                else if(last_i)begin column<=0;row<=row+1'b1;write_bank<=current_bank==2 ? 0 : current_bank+1'b1;end
                else column<=column+1'b1;
            end
            previous_select<=previous_bank;oldest_select<=oldest_bank;
            current_word<={(COHERENCE_ENABLE!=0 ? polarity_i : 1'b0),gradient_i,(FULL_PRECISION!=0 ? fine_i : 2'b00)};read_x<=input_x;read_y<=input_y;read_valid<=valid_i;
        end
    end
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            lower_right<=0;lower_center<=0;lower_left<=0;
            middle_right<=0;middle_center<=0;middle_left<=0;
            upper_right<=0;upper_center<=0;upper_left<=0;
            window_x<=0;window_y<=0;window_valid<=0;
        end else begin
            window_valid<=read_valid;
            if(read_valid)begin
                lower_right<=current_word;lower_center<=lower_right;lower_left<=lower_center;
                middle_right<=bank_read[previous_select];middle_center<=middle_right;middle_left<=middle_center;
                upper_right<=bank_read[oldest_select];upper_center<=upper_right;upper_left<=upper_center;
                window_x<=read_x;window_y<=read_y;
            end
        end
    end
    reg [10:0] negative_neighbor,positive_neighbor;
    always @(*)begin
        case(middle_center[12:11])
            2'd0:begin negative_neighbor=middle_left[10:0];positive_neighbor=middle_right[10:0];end
            2'd1:begin negative_neighbor=upper_left[10:0];positive_neighbor=lower_right[10:0];end
            2'd2:begin negative_neighbor=upper_center[10:0];positive_neighbor=lower_center[10:0];end
            default:begin negative_neighbor=upper_right[10:0];positive_neighbor=lower_left[10:0];end
        endcase
    end
    // At least four strong neighbors are required even for a weak center.
    // This rejects isolated and tiny gradient clusters without a directional bias.
    wire [1:0] support_upper={1'b0,upper_left[14]}+{1'b0,upper_center[14]};
    wire [1:0] support_lower={1'b0,lower_left[14]}+{1'b0,lower_center[14]};
    wire [1:0] support_side={1'b0,middle_left[14]}+{1'b0,middle_right[14]};
    wire [1:0] support_right={1'b0,upper_right[14]}+{1'b0,lower_right[14]};
    wire [2:0] support_half={1'b0,support_upper}+{1'b0,support_lower};
    wire [2:0] support_other={1'b0,support_side}+{1'b0,support_right};
    wire [3:0] support_count={1'b0,support_half}+{1'b0,support_other};
    // Strict comparison on one side resolves a two-pixel plateau deterministically.
    wire peak=middle_center[10:0]>negative_neighbor && middle_center[10:0]>=positive_neighbor;
    wire accepted=peak && middle_center[13] && support_count>=4;
    generate if(COHERENCE_ENABLE==0)begin: g_legacy_support
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin valid_o<=0;edge_o<=0;detection_o<=0;x_o<=0;y_o<=0;end
        else begin
            valid_o<=window_valid && window_x>=6 && window_y>=6;
            edge_o<=window_valid && window_x>=6 && window_y>=6 && accepted;
            detection_o<=window_valid && window_x>=6 && window_y>=6 && middle_center[14];
            x_o<=window_x>=3 ? window_x-12'd3 : 12'd0;
            y_o<=window_y>=3 ? window_y-12'd3 : 12'd0;
        end
    end
    end else begin: g_coherent_support
        // One sign bit distinguishes opposite normals; modulo-eight distance
        // accepts only the same octant or either adjacent octant.
        function [2:0] octant;
            input [15:0] word;
            begin
                octant=word[12:11]==3 ? (word[15] ? 3'd3 : 3'd7) : {word[15],word[12:11]};
            end
        endfunction
        wire [15:0] neighbor [0:7];
        assign neighbor[0]=upper_left;assign neighbor[1]=upper_center;
        assign neighbor[2]=upper_right;assign neighbor[3]=middle_left;
        assign neighbor[4]=middle_right;assign neighbor[5]=lower_left;
        assign neighbor[6]=lower_center;assign neighbor[7]=lower_right;
        wire [2:0] center_octant=octant(middle_center);
        wire [7:0] strong_match,weak_match;
        genvar n;
        for(n=0;n<8;n=n+1)begin: g_match
            wire [2:0] distance=center_octant-octant(neighbor[n]);
            wire aligned=distance==0 || distance==1 || distance==7;
            assign strong_match[n]=aligned && neighbor[n][14];
            assign weak_match[n]=aligned && neighbor[n][13];
        end
        reg [7:0] strong_flags,weak_flags;
        reg peak_first,valid_first,peak_second,valid_second;
        reg detection_first,detection_second;
        reg [11:0] x_first,y_first,x_second,y_second;
        reg [2:0] strong_left,strong_right,weak_left,weak_right;
        wire [3:0] strong_total={1'b0,strong_left}+{1'b0,strong_right};
        wire [3:0] weak_total={1'b0,weak_left}+{1'b0,weak_right};
        // Require strong evidence on both sides of the contour tangent. A weak
        // NMS center may bridge them locally; no recursive/global hysteresis.
        // Direction/sign matching above remains mandatory. No extra line/store
        // or latency: this replaces the count decision in the existing pipeline.
        reg [1:0] direction_first;
        reg tangent_second;
        reg tangent_a,tangent_b;
        always @(*)begin
            case(direction_first)
                2'd0:begin tangent_a=|strong_flags[2:0];tangent_b=|strong_flags[7:5];end
                2'd1:begin tangent_a=strong_flags[1]|strong_flags[2]|strong_flags[4];tangent_b=strong_flags[3]|strong_flags[5]|strong_flags[6];end
                2'd2:begin tangent_a=strong_flags[0]|strong_flags[3]|strong_flags[5];tangent_b=strong_flags[2]|strong_flags[4]|strong_flags[7];end
                default:begin tangent_a=strong_flags[0]|strong_flags[1]|strong_flags[3];tangent_b=strong_flags[4]|strong_flags[6]|strong_flags[7];end
            endcase
        end
        wire supported=TANGENT_SUPPORT_ENABLE!=0 ? (tangent_second && weak_total>=4) :
            (strong_total>=5 || (strong_total>=4 && weak_total>=6));
        always @(posedge clk or negedge rst_n)begin
            if(!rst_n)begin
                direction_first<=0;tangent_second<=0;
                strong_flags<=0;weak_flags<=0;peak_first<=0;valid_first<=0;
                detection_first<=0;detection_second<=0;
                x_first<=0;y_first<=0;peak_second<=0;valid_second<=0;x_second<=0;y_second<=0;
                strong_left<=0;strong_right<=0;weak_left<=0;weak_right<=0;
                valid_o<=0;edge_o<=0;detection_o<=0;x_o<=0;y_o<=0;
            end else begin
                direction_first<=middle_center[12:11];tangent_second<=tangent_a && tangent_b;
                strong_flags<=strong_match;weak_flags<=weak_match;
                peak_first<=peak && middle_center[13];
                detection_first<=middle_center[14];
                detection_second<=detection_first;
                detection_o<=valid_second && detection_second;
                valid_first<=window_valid && window_x>=6 && window_y>=6;
                x_first<=window_x>=3 ? window_x-12'd3 : 12'd0;
                y_first<=window_y>=3 ? window_y-12'd3 : 12'd0;
                strong_left<={2'd0,strong_flags[0]}+{2'd0,strong_flags[1]}+{2'd0,strong_flags[2]}+{2'd0,strong_flags[3]};
                strong_right<={2'd0,strong_flags[4]}+{2'd0,strong_flags[5]}+{2'd0,strong_flags[6]}+{2'd0,strong_flags[7]};
                weak_left<={2'd0,weak_flags[0]}+{2'd0,weak_flags[1]}+{2'd0,weak_flags[2]}+{2'd0,weak_flags[3]};
                weak_right<={2'd0,weak_flags[4]}+{2'd0,weak_flags[5]}+{2'd0,weak_flags[6]}+{2'd0,weak_flags[7]};
                peak_second<=peak_first;valid_second<=valid_first;x_second<=x_first;y_second<=y_first;
                valid_o<=valid_second;edge_o<=valid_second && peak_second && supported;
                x_o<=x_second;y_o<=y_second;
            end
        end
    end endgenerate
endmodule
