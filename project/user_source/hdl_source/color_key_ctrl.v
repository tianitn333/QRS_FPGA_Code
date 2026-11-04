// ============================================================================
// color_key_ctrl —— 四键输入：两级同步、20ms 消抖、短按/长按/连发
//
// 依据：docs/handoff_color_ui_20261021/EXECUTION_CONSTRAINTS.md §4
//
// 行为（低有效按键，板载 KEY1..KEY4 = D5/A9/B9/C7）：
//   · 统一两级同步 + 20ms 稳定消抖；
//   · K1/K2：长按门限 800ms；短按在**释放**时确认；长按触发后吞掉该次释放的
//     短按，因此长按不会额外产生一次短按；
//   · K3/K4：按下即产生一拍（首步）pulse，持续 400ms 后每 80ms 再产生一拍；
//     两键同时按下时都不产生步进；
//   · K4：另有 1.5s 长按事件，专供 GLOBAL 页 RESTORE DEFAULT 确认，不参与连发。
//
// 时间基准：1ms 节拍（MS_CYC 个时钟），测试可把 MS_CYC 缩小以加快仿真；
// 硬件默认 MS_CYC = 75000（75MHz 像素时钟）。
// ============================================================================

module color_key_ctrl #(
    parameter integer MS_CYC      = 75000,  // 1ms
    parameter integer DEB_MS      = 20,
    parameter integer LONG_MS     = 800,
    parameter integer REP_DLY_MS  = 400,
    parameter integer REP_PER_MS  = 80,
    parameter integer LONG15_MS   = 1500
)(
    input  wire       clk,
    input  wire       rst_n,
    input wire I_restore_arm,
    input  wire [3:0] I_key_n,        // {K4,K3,K2,K1}，低有效

    output reg        O_k1_short,
    output reg        O_k1_long,
    output reg        O_k2_short,
    output reg        O_k2_long,
    output reg        O_k3_step,
    output reg        O_k4_step,
    output reg        O_k4_long15,
    output reg  [3:0] O_pressed        // 消抖后的按下状态（1=按下）
);

    // ------------------------------------------------------------------
    // 1ms 节拍
    // ------------------------------------------------------------------
    reg [16:0] S_ms_cnt;
    reg        S_tick;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_ms_cnt <= 17'd0;
            S_tick   <= 1'b0;
        end
        else if (S_ms_cnt == (MS_CYC - 1)) begin
            S_ms_cnt <= 17'd0;
            S_tick   <= 1'b1;
        end
        else begin
            S_ms_cnt <= S_ms_cnt + 17'd1;
            S_tick   <= 1'b0;
        end
    end

    // ------------------------------------------------------------------
    // 两级同步 + 20ms 消抖
    // ------------------------------------------------------------------
    (* async_reg="true" *) reg [1:0] S_sync [3:0];
    reg [3:0] S_stable;
    reg [4:0] S_db_cnt [3:0];
    reg [3:0] S_stable_d;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_stable   <= 4'b0000;
            S_stable_d <= 4'b0000;
            for (i = 0; i < 4; i = i + 1) begin
                S_sync[i]   <= 2'b00;
                S_db_cnt[i] <= 5'd0;
            end
        end
        else begin
            for (i = 0; i < 4; i = i + 1)
                S_sync[i] <= {S_sync[i][0], ~I_key_n[i]};

            S_stable_d <= S_stable;

            if (S_tick) begin
                for (i = 0; i < 4; i = i + 1) begin
                    if (S_sync[i][1] != S_stable[i]) begin
                        if (S_db_cnt[i] >= (DEB_MS - 1)) begin
                            S_stable[i]   <= S_sync[i][1];
                            S_db_cnt[i]   <= 5'd0;
                        end
                        else
                            S_db_cnt[i] <= S_db_cnt[i] + 5'd1;
                    end
                    else
                        S_db_cnt[i] <= 5'd0;
                end
            end
        end
    end

    wire [3:0] S_press   = S_stable & ~S_stable_d;   // 消抖后按下沿（1 拍）
    wire [3:0] S_release = ~S_stable & S_stable_d;   // 消抖后释放沿（1 拍）

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) O_pressed <= 4'b0000;
        else        O_pressed <= S_stable;
    end

    // ------------------------------------------------------------------
    // K1 / K2：长按 800ms，释放时确认短按（长按后吞掉短按）
    // ------------------------------------------------------------------
    reg [10:0] S_hold1, S_hold2;
    reg        S_long1_done, S_long2_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_hold1 <= 11'd0; S_hold2 <= 11'd0;
            S_long1_done <= 1'b0; S_long2_done <= 1'b0;
            O_k1_short <= 1'b0; O_k1_long <= 1'b0;
            O_k2_short <= 1'b0; O_k2_long <= 1'b0;
        end
        else begin
            O_k1_short <= 1'b0; O_k1_long <= 1'b0;
            O_k2_short <= 1'b0; O_k2_long <= 1'b0;

            if (S_press[0]) begin
                S_hold1 <= 11'd0;
                S_long1_done <= 1'b0;
            end
            else if (S_tick && S_stable[0]) begin
                if (!S_long1_done) begin
                    if (S_hold1 >= (LONG_MS - 1)) begin
                        O_k1_long    <= 1'b1;
                        S_long1_done <= 1'b1;
                    end
                    else
                        S_hold1 <= S_hold1 + 11'd1;
                end
            end
            if (S_release[0]) begin
                if (!S_long1_done) O_k1_short <= 1'b1;
                S_long1_done <= 1'b0;
                S_hold1 <= 11'd0;
            end

            if (S_press[1]) begin
                S_hold2 <= 11'd0;
                S_long2_done <= 1'b0;
            end
            else if (S_tick && S_stable[1]) begin
                if (!S_long2_done) begin
                    if (S_hold2 >= (LONG_MS - 1)) begin
                        O_k2_long    <= 1'b1;
                        S_long2_done <= 1'b1;
                    end
                    else
                        S_hold2 <= S_hold2 + 11'd1;
                end
            end
            if (S_release[1]) begin
                if (!S_long2_done) O_k2_short <= 1'b1;
                S_long2_done <= 1'b0;
                S_hold2 <= 11'd0;
            end
        end
    end

    // ------------------------------------------------------------------
    // K3 / K4：首步 + 400ms 后每 80ms 连发；两键同按不动作
    // ------------------------------------------------------------------
    // 连发计数：hold 从 0 开始每 ms +1；达到 400ms 时立刻出一拍，之后由
    // 独立的 80ms 计数器给出重复拍（不用取模，避免综合出除法器）。
    reg [11:0] S_hold3, S_hold4;
    reg [6:0]  S_rep3_cnt, S_rep4_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_hold3 <= 12'd0;
            S_hold4 <= 12'd0;
            S_rep3_cnt <= 7'd0;
            S_rep4_cnt <= 7'd0;
        end
        else begin
            if (S_press[2]) S_hold3 <= 12'd0;
            else if (S_tick && S_stable[2] && S_hold3!=12'hfff) S_hold3 <= S_hold3 + 12'd1;

            if (S_press[3]) S_hold4 <= 12'd0;
            else if (S_tick && S_stable[3] && S_hold4!=12'hfff) S_hold4 <= S_hold4 + 12'd1;

            if (S_press[2] || !S_stable[2])
                S_rep3_cnt <= 7'd0;
            else if (S_tick && (S_hold3 > REP_DLY_MS))
                S_rep3_cnt <= (S_rep3_cnt == (REP_PER_MS - 1)) ? 7'd0 : (S_rep3_cnt + 7'd1);

            if (S_press[3] || !S_stable[3])
                S_rep4_cnt <= 7'd0;
            else if (S_tick && (S_hold4 > REP_DLY_MS))
                S_rep4_cnt <= (S_rep4_cnt == (REP_PER_MS - 1)) ? 7'd0 : (S_rep4_cnt + 7'd1);
        end
    end

    // hold==REP_DLY_MS 的那一拍就是第一次连发；之后每 REP_PER_MS ms 一次
    wire S_rep3 = S_tick && S_stable[2] &&
                  ((S_hold3 == REP_DLY_MS) ||
                   ((S_hold3 > REP_DLY_MS) && (S_rep3_cnt == (REP_PER_MS - 1))));
    wire S_rep4 = S_tick && S_stable[3] &&
                  ((S_hold4 == REP_DLY_MS) ||
                   ((S_hold4 > REP_DLY_MS) && (S_rep4_cnt == (REP_PER_MS - 1))));

    // 双键同时按下：两者都不产生步进（含首步）
    wire S_both = S_stable[2] && S_stable[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            O_k3_step   <= 1'b0;
            O_k4_step   <= 1'b0;

        end
        else begin
            O_k3_step   <= (S_press[2] | S_rep3) & ~S_both;
            O_k4_step   <= (S_press[3] | S_rep4) & ~S_both;

        end
    end

// DEFAULT confirmation is cancelled by K4 with any other debounced key.
// Keep the K3/K4 step suppression above independent of this confirmation rule.
wire S_restore_conflict=S_stable[3]&&(|S_stable[2:0]);
reg restore_allowed,restore_done;reg[11:0]restore_count;
    always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin restore_allowed<=0;restore_done<=0;restore_count<=0;O_k4_long15<=0;end
      else begin
        O_k4_long15<=0;
        if(!I_restore_arm||S_restore_conflict)begin restore_allowed<=0;restore_count<=0;restore_done<=0;end
        else if(!S_stable[3])begin restore_allowed<=1;restore_count<=0;restore_done<=0;end
        else if(restore_allowed&&S_tick&&!restore_done)begin
          if(restore_count==LONG15_MS-1)begin O_k4_long15<=1;restore_done<=1;end
          else restore_count<=restore_count+1'b1;
        end
      end
    end
endmodule
