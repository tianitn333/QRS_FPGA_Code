`timescale 1ns/1ps
// Known BGGR window contract; this is not a model of the physical sensor flip.
module tb_bayer_phase_color;
    reg clock = 0; // 本地插值器测试时钟。
    reg reset_n = 0; // 初始拉低以清空插值流水线。
    reg valid = 0; // 已知窗口输入的有效标志。
    reg parity = 0; // 窗口中心行的Bayer奇偶相位。
    reg [95:0] previous_line = 0; // 三行窗口的上一行采样。
    reg [95:0] current_line = 0; // 三行窗口的中心行采样。
    reg [95:0] next_line = 0; // 三行窗口的下一行采样。
    reg [8:0] rom_index = 0; // 定位相机初始化表末尾的命令。
    wire [31:0] rom_data; // 被检查的相机地址和数据字。
    wire [8:0] rom_size; // 初始化表有效命令数。
    wire [127:0] restored_rgb; // BGGR解释得到的四像素输出。
    wire [127:0] mismatched_rgb; // RGGB反事实解释得到的四像素输出。
    wire restored_valid; // 正确解释分支的输出有效标志。
    wire mismatched_valid; // 错配解释分支的输出有效标志。
    integer color_case, cycle, pixel, checks = 0; // 遍历颜色、流水周期和像素并统计检查数。
    integer red_level, green_level, blue_level; // 已知输入窗口的真实颜色幅值。

    always #5 clock = ~clock; // 生成周期为10ns的仿真时钟。

    // 绑定真实相机ROM，检查翻转与开流命令仍然保留。
    uics500reg_720p60 camera_table ( // 检查实际初始化ROM的方向控制命令。
        .REG_INDEX(rom_index), .REG_DATA(rom_data), .REG_SIZE(rom_size)
    );
    // 正确分支按已知BGGR窗口恢复RGB值。
    bilinear_interpolation #(.BAYER_MODE("BGGR")) restored ( // 用正确BGGR相位解释已知窗口。
        .I_clk(clock), .I_rst_n(reset_n), .I_tlast(1'b0), .I_tuser(1'b0),
        .I_tvalid(valid), .I_tready(), .bayer_ypos(parity),
        .matrix_last_line(previous_line), .matrix_cur_line(current_line),
        .matrix_next_line(next_line), .O_tlast(), .O_tuser(),
        .O_tdata(restored_rgb), .O_tvalid(restored_valid), .O_tready(1'b1)
    );
    // 反事实分支将同一窗口解释为RGGB，用于检查红蓝互换特征。
    bilinear_interpolation #(.BAYER_MODE("RGGB")) mismatched ( // 对同一窗口计算错误RGGB解释的结果。
        .I_clk(clock), .I_rst_n(reset_n), .I_tlast(1'b0), .I_tuser(1'b0),
        .I_tvalid(valid), .I_tready(), .bayer_ypos(parity),
        .matrix_last_line(previous_line), .matrix_cur_line(current_line),
        .matrix_next_line(next_line), .O_tlast(), .O_tuser(),
        .O_tdata(mismatched_rgb), .O_tvalid(mismatched_valid), .O_tready(1'b1)
    );

    // 任务：生成指定中心行相位的恒定颜色BGGR窗口。
    task fill_bggr_window; // 将颜色幅值写入指定行相位的六个采样位置。
        input integer row_parity; // 当前填充行的奇偶相位。
        output reg [95:0] line_data; // 按库矩阵位序打包的六个有效采样。
        integer column, level; // 遍历列并选择该采样的物理颜色幅值。
        begin
            line_data = 0;
            // Library matrix columns 3..8; bayer_ypos is its window-center phase.
            for (column = 0; column < 6; column = column + 1) begin
                if (row_parity == 0)
                    level = ((column + 3) % 2 == 0) ? blue_level : green_level;
                else
                    level = ((column + 3) % 2 == 0) ? green_level : red_level;
                line_data[71-column*8-:8] = level;
            end
        end
    endtask

    // 先验证ROM，再遍历颜色与相位；任何数据不符立即终止。
    initial begin
        #1;
        if (rom_size !== 117) $fatal(1, "FAIL: orientation table length changed");
        rom_index = 114; #1;
        if (rom_data[23:0] !== 24'h322166) $fatal(1, "FAIL: native H/V flip lost");
        rom_index = 115; #1;
        if (rom_data[23:0] !== 24'h010001) $fatal(1, "FAIL: stream-on order changed");
        rom_index = 116; #1;
        if (rom_data[23:0] !== 24'h302d00) $fatal(1, "FAIL: final startup command lost");
        repeat (3) @(negedge clock);
        reset_n = 1;
        for (color_case = 0; color_case < 12; color_case = color_case + 1) begin
            case (color_case / 2)
                0: begin red_level = 220; green_level = 24; blue_level = 16; end
                1: begin red_level = 16; green_level = 220; blue_level = 24; end
                2: begin red_level = 24; green_level = 16; blue_level = 220; end
                3: begin red_level = 96; green_level = 96; blue_level = 96; end
                4: begin red_level = 28; green_level = 76; blue_level = 140; end
                default: begin red_level = 144; green_level = 52; blue_level = 24; end
            endcase
            parity = color_case % 2;
            fill_bggr_window(parity, current_line);
            fill_bggr_window(1-parity, previous_line);
            fill_bggr_window(1-parity, next_line);
            valid = 1;
            for (cycle = 0; cycle < 14; cycle = cycle + 1) begin
                @(negedge clock);
                if (cycle >= 8) begin
                    for (pixel = 0; pixel < 4; pixel = pixel + 1) begin
                        if (!restored_valid || restored_rgb[pixel*32+:32] !==
                            {8'd0, red_level[7:0], green_level[7:0], blue_level[7:0]})
                            $fatal(1, "FAIL: BGGR color case=%0d pixel=%0d got=%h", color_case, pixel, restored_rgb[pixel*32+:32]);
                        if (!mismatched_valid || mismatched_rgb[pixel*32+:32] !==
                            {8'd0, blue_level[7:0], green_level[7:0], red_level[7:0]})
                            $fatal(1, "FAIL: counterfactual R/B signature case=%0d pixel=%0d got=%h", color_case, pixel, mismatched_rgb[pixel*32+:32]);
                        checks = checks + 1;
                    end
                end
            end
        end
        $display("PASS: known BGGR windows restored, R/B mismatch signature reproduced, checks=%0d, H/V ROM retained", checks);
        $finish;
    end
endmodule
