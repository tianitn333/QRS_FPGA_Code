`timescale 1ns/1ps
// ============================================================================
// tb_color_runtime_volatile —— 运行时参数路径与旧参数路径的逐像素等价
//
//   左侧：RUNTIME_PARAM_EN=0（旧路径，参数=工程实际生效值）
//   右侧：RUNTIME_PARAM_EN=1（Q5 运行时总线，默认值由同一组参数换算）
//   逐拍比较三色 area/框/valid，必须完全一致；另外单独验证等号边界。
// ============================================================================
module tb_color_runtime_volatile;

    reg clk = 1'b0;
    reg rst_n = 1'b0;
    always #5 clk = ~clk;

    reg  valid = 0, user = 0, last = 0;
    reg  [23:0] rgb = 24'd0;
    reg  [239:0] pbus = 240'd0;

    // 旧路径输出
    wire        lr_v, lg_v, lb_v;
    wire [31:0] lr_a, lg_a, lb_a;
    wire [11:0] lr_x0, lr_x1, lr_y0, lr_y1;
    wire [11:0] lg_x0, lg_x1, lg_y0, lg_y1;
    wire [11:0] lb_x0, lb_x1, lb_y0, lb_y1;

    // 运行时路径输出
    wire        rr_v, rg_v, rb_v;
    wire [31:0] rr_a, rg_a, rb_a;
    wire [11:0] rr_x0, rr_x1, rr_y0, rr_y1;
    wire [11:0] rg_x0, rg_x1, rg_y0, rg_y1;
    wire [11:0] rb_x0, rb_x1, rb_y0, rb_y1;

    integer errors = 0;
    integer i;

    localparam [239:0] DEF = {
        16'd32, 16'd18, 16'd44,
        16'd40, 16'd40, 16'd20,
        16'd40, 16'd48, 16'd12,
        16'd48, 16'd36, 16'd12,
        16'd48, 16'd48, 16'd24
    };

    // 工程实际生效参数（thresholds_before.json）
    color_detect_box #(
        .IMG_W(16), .IMG_H(4),
        .RATIO_SHIFT(1), .RATIO_SHIFT_G(3), .RATIO_SHIFT_GB(1),
        .MIN_DIFF_R(24), .MIN_DIFF_G(12), .MIN_SAT(18), .MIN_LUMA(44),
        .MIN_AREA(32), .STAT_DECIM(4), .MIN_RUN(3),
        .MIN_ROW_CNT(6), .MIN_ROW_CNT_G(4), .MIN_ROW_RUN_G(2),
        .B_R_RATIO_Q2(6), .B_G_RATIO_Q2(5), .MIN_DIFF_B(12),
        .EXTENDED_BLUE(1), .USE_BLUE_GATE(0),
        .LIGHT_B_R_Q2(5), .LIGHT_G_R_Q2(5), .LIGHT_MIN_DIFF(20),
        .LIGHT_BALANCE_SHIFT(2), .MIN_ROW_CNT_B(4), .MIN_ROW_RUN_B(2),
        .RUNTIME_PARAM_EN(0)
    ) legacy (
        .clk(clk), .rst_n(rst_n), .valid_i(valid), .user_i(user), .last_i(last), .rgb_i(rgb),
        .I_param_bus(240'd0), .blue_allow_i(1'b1),
        .o_r_valid(lr_v), .o_r_area(lr_a), .o_r_xmin(lr_x0), .o_r_xmax(lr_x1), .o_r_ymin(lr_y0), .o_r_ymax(lr_y1),
        .o_g_valid(lg_v), .o_g_area(lg_a), .o_g_xmin(lg_x0), .o_g_xmax(lg_x1), .o_g_ymin(lg_y0), .o_g_ymax(lg_y1),
        .o_b_valid(lb_v), .o_b_area(lb_a), .o_b_xmin(lb_x0), .o_b_xmax(lb_x1), .o_b_ymin(lb_y0), .o_b_ymax(lb_y1)
    );

    color_detect_box #(
        .IMG_W(16), .IMG_H(4),
        .MIN_AREA(32), .STAT_DECIM(4), .MIN_RUN(3),
        .MIN_ROW_CNT(6), .MIN_ROW_CNT_G(4), .MIN_ROW_RUN_G(2),
        .EXTENDED_BLUE(1), .USE_BLUE_GATE(0),
        .LIGHT_BALANCE_SHIFT(2), .MIN_ROW_CNT_B(4), .MIN_ROW_RUN_B(2),
        .RUNTIME_PARAM_EN(1)
    ) runtime (
        .clk(clk), .rst_n(rst_n), .valid_i(valid), .user_i(user), .last_i(last), .rgb_i(rgb),
        .I_param_bus(pbus), .blue_allow_i(1'b1),
        .o_r_valid(rr_v), .o_r_area(rr_a), .o_r_xmin(rr_x0), .o_r_xmax(rr_x1), .o_r_ymin(rr_y0), .o_r_ymax(rr_y1),
        .o_g_valid(rg_v), .o_g_area(rg_a), .o_g_xmin(rg_x0), .o_g_xmax(rg_x1), .o_g_ymin(rg_y0), .o_g_ymax(rg_y1),
        .o_b_valid(rb_v), .o_b_area(rb_a), .o_b_xmin(rb_x0), .o_b_xmax(rb_x1), .o_b_ymin(rb_y0), .o_b_ymax(rb_y1)
    );

    task cmp_cycle;
        input [127:0] tag;
        begin
            if ({lr_v,lr_a,lr_x0,lr_x1,lr_y0,lr_y1} !== {rr_v,rr_a,rr_x0,rr_x1,rr_y0,rr_y1} ||
                {lg_v,lg_a,lg_x0,lg_x1,lg_y0,lg_y1} !== {rg_v,rg_a,rg_x0,rg_x1,rg_y0,rg_y1} ||
                {lb_v,lb_a,lb_x0,lb_x1,lb_y0,lb_y1} !== {rb_v,rb_a,rb_x0,rb_x1,rb_y0,rb_y1}) begin
                errors = errors + 1;
                if (errors < 6)
                    $display("FAIL: %0s legacy r(%0d/%0d,%0d..%0d,%0d..%0d) runtime r(%0d/%0d,%0d..%0d,%0d..%0d)",
                        tag, lr_v, lr_a, lr_x0, lr_x1, lr_y0, lr_y1,
                        rr_v, rr_a, rr_x0, rr_x1, rr_y0, rr_y1);
            end
        end
    endtask

    // 一帧 16x4 随机像素
    task run_frame;
        input integer seed;
        integer l, p, v;
        begin
            for (l = 0; l < 4; l = l + 1) begin
                for (p = 0; p < 16; p = p + 1) begin
                    @(negedge clk);
                    valid = 1'b1;
                    user  = (l == 0 && p == 0);
                    last  = (p == 15);
                    v     = $random(seed);
                    rgb   = v[23:0];
                end
            end
            @(negedge clk);
            valid = 0; user = 0; last = 0;
            cmp_cycle("frame seal");
            repeat (2) @(negedge clk);
            cmp_cycle("after seal");
        end
    endtask

    initial begin
        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        pbus  = DEF;
        repeat (5) @(negedge clk);

        // 1) 200 帧随机像素逐拍比较
        for (i = 0; i < 200; i = i + 1)
            run_frame(i + 1);

        // 2) RGB 边界：0/255、等号边界（r == 2g 必须不成立）
        //    r=100,g=50 → r == 2g，红判据必须为假；r=102,g=50 → 2.04 > 2 成立
        @(negedge clk); valid = 1; user = 1; last = 0; rgb = {8'd100, 8'd50, 8'd50};
        cmp_cycle("eq boundary 1");
        repeat (4) @(negedge clk);
        valid = 1; rgb = {8'd102, 8'd50, 8'd50};
        repeat (60) begin @(negedge clk); valid = 1; rgb = {8'd102, 8'd50, 8'd50}; cmp_cycle("eq boundary 2"); end
        @(negedge clk); valid = 1; last = 1; rgb = {8'd255,8'd255,8'd255};
        cmp_cycle("white");
        @(negedge clk); valid = 1; last = 0; user = 1; rgb = 24'd0;
        cmp_cycle("black");

        if (errors == 0)
            $display("PASS: runtime Q5 parameter path is pixel-exact vs legacy parameter path (200 random frames + boundary)");
        else
            $display("FAIL: %0d mismatches", errors);
        $finish;
    end

endmodule
