// ============================================================================
// color_detect_box —— M3 颜色阈值目标检测（像素域判据 + 帧内统计 + 帧末封存）
//
// 依据：docs/source_map.md（接入点与坐标相位）、docs/interfaces.md（接口契约）
// 算法：RGB 通道差阈值分割 + ROI 全局包围框；红 / 绿 / 蓝三路并行；单目标假设。
//       红绿判据使用加法/比较；蓝色含两路常量比例乘法，当前 TD 映射为 2 个 DSP。
//       检测统计不使用 BRAM，无像素除法器。
//
// 挂载：hdmi_mixer 内，与 pixel_gray_pipe 并列，输入 I_video_rd_data（原始 RGB888）。
//       每拍至多 1 像素，不反压、不停顿。
//
// 相位（见 docs/source_map.md §3.2，已由仿真确认）：
//   S_px / S_py 与 hdmi_mixer 的 S_x / S_y 同规则，其值就是本拍像素坐标；
//   判据与坐标同时打 1 拍后进入统计级 → 统计级输入全为寄存器输出。
//
// ---------------------------------------------------------------------------
// 抗散布噪声（2026-10 上板实测后新增，核心修复）
//
// 实测现象：画面变亮（AE 生效）后，前景像素只占 0.2~1.3%，但包围框却被拉到
//           几乎全屏（~1800x820）。用 24 帧统计确认：**不是阈值太松**
//           （TH 从 40 提到 120 框宽几乎不变），而是**背景材质的色偏**在阈值下
//           成片成立、且**每行只有零星几个像素**，把 min/max 撑开了。
//
// 三级对策（本次全部启用）：
//   1) 最小亮度门限 MIN_LUMA：max(R,G,B) 必须达标（暗处通道差容易偶然成立）；
//   2) 水平 MIN_RUN 点连续确认：滤掉孤立点/两点噪声（零行缓存）；
//   3) **行内前景计数门限 MIN_ROW_CNT**：只有某一行前景采样点数达标，该行才
//      允许贡献边界与面积。实测背景色偏每行仅几~几十个采样点，真实目标每行
//      有几十上百个 → 干净分离。帧末 pending 行也会被组合合并，不丢行。
//
// 统计口径：面积 = 合格行的"采样点数"之和（STAT_DECIM 降采样，默认每 4 拍 1 点）。
//           运行值在帧首封存到输出并清零 → 结果帧龄 1 帧。
// ============================================================================

module color_detect_ae_reference #(
    parameter integer IMG_W      = 1280,
    parameter integer IMG_H      = 720,
    // ---- 颜色判据（2026-10-03 改版：**比例 + 绝对差下限** 双条件，依据实拍样本参数扫描）----
    // 只改比例不行：暗部背景（衣服褶皱的暗红/暗绿）也能满足"R 比 G 大 50%"，空场误检面积达 11433。
    // 加上绝对差下限后：空场误检 → 13 像素（远低于 MIN_AREA），而红/绿目标仍稳稳检出：
    //   红方块 41334 px、绿方块 16281 px（旧判据绿目标只有 1866，几乎检不到）
    // 只用加法/移位/比较实现，无乘法器/除法器。
    parameter integer RATIO_SHIFT  = 0,  // **红**判据比例：0 → 2.0 倍（1.5 倍会把皮肤/手算成红）
    parameter integer RATIO_SHIFT_G= 1,  // **绿判据对 R** 的比例：1 → 1.5 倍（相机对绿响应弱，绿目标 G/R 常只有 1.5~1.6，2 倍会检不到；靠 diff 挡背景）
    parameter integer RATIO_SHIFT_GB=1, // **绿判据对 B** 的比例：1 → 1.5 倍（绿目标的 B 通道常偏高，对 B 用 2 倍会检不到）
    parameter integer MIN_DIFF_R = 48,   // 红判据绝对差下限（实测：<48 时画面左侧阴影会间歇过检，框右边界抖动达 420 像素；48 → 极差 0）
    parameter integer MIN_DIFF_G = 20,   // 绿判据绝对差下限（16 → 20：这是区分弱绿瓶子与真绿目标的关键维度）
    parameter integer MIN_SAT    = 18,   // 饱和度门限（14 → 18：压掉棕色瓶底的弱绿暗部）
    parameter integer MIN_LUMA   = 44,   // 最小亮度门限（48 → 44：兼顾两侧暗角与瓶底干净度）
    parameter integer MIN_AREA   = 64,   // 采样点面积门限（合格行累加）
    parameter integer STAT_DECIM = 4,    // 统计降采样：每 N 拍取 1 点；1 = 不降采样
    parameter integer MIN_RUN    = 3,    // 水平连续确认点数（当前 + 前 MIN_RUN-1 拍）
    parameter integer MIN_ROW_CNT= 12,   // **红**行内合格前景采样点数门限（原 8；实测背景误检行仅 1~4 点）
    parameter integer MIN_ROW_RUN_G= 2,  // **绿**连续达标行数（取 3 会因主体行本身断续而丢框 25/40；取 2 保住 40/40）
    parameter integer B_R_RATIO_Q2 = 6, // Blue/R ratio in quarters, supported 4..15
    parameter integer B_G_RATIO_Q2 = 7, // Blue/G ratio in quarters, supported 4..15
    parameter integer MIN_DIFF_B = 20,
    parameter integer EXTENDED_BLUE = 0,
    parameter integer USE_BLUE_GATE = 0,
    parameter integer LIGHT_B_R_Q2 = 5,
    parameter integer LIGHT_G_R_Q2 = 5,
    parameter integer LIGHT_MIN_DIFF = 20,
    parameter integer LIGHT_BALANCE_SHIFT = 2,
    parameter integer MIN_ROW_CNT_B = 4,
    parameter integer MIN_ROW_RUN_B = 2,
    parameter integer MIN_ROW_CNT_G= 6   // **绿**行门限（板上实测绿主体行仅 6~7 点，取 8 会整块丢失；抖动改由 MIN_ROW_RUN_G 压）
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_i,   // 当前像素有效（= I_video_de）
    input  wire        user_i,    // 帧首脉冲（与第一个有效像素同拍，= I_video_user）
    input  wire        last_i,    // 行末脉冲（与最后一个有效像素同拍，= I_video_last）
    input  wire [23:0] rgb_i,     // RGB888： [23:16]=R, [15:8]=G, [7:0]=B

    output reg         o_r_valid,
    output reg  [31:0] o_r_area,
    output reg  [11:0] o_r_xmin,
    output reg  [11:0] o_r_xmax,
    output reg  [11:0] o_r_ymin,
    output reg  [11:0] o_r_ymax,

    output reg         o_g_valid,
    output reg  [31:0] o_g_area,
    output reg  [11:0] o_g_xmin,
    output reg  [11:0] o_g_xmax,
    output reg  [11:0] o_g_ymin,
    output reg  [11:0] o_g_ymax,
    input wire         blue_allow_i,
    output reg         o_b_valid,
    output reg  [31:0] o_b_area,
    output reg  [11:0] o_b_xmin, o_b_xmax, o_b_ymin, o_b_ymax
);

    localparam [11:0] SENT_X = 12'hfff;
    localparam [11:0] SENT_Y = 12'hfff;
    localparam [11:0] X_LAST = IMG_W - 1;

    localparam [2:0]  DEC_LAST   = STAT_DECIM[2:0] - 3'd1;
    localparam [7:0]  LUMA_MIN   = MIN_LUMA[7:0];
    localparam [7:0]  SAT_MIN    = MIN_SAT[7:0];
    localparam [8:0]  DIFF_R    = MIN_DIFF_R[8:0];
    localparam [8:0]  DIFF_G    = MIN_DIFF_G[8:0];
    localparam [11:0] ROW_CNT_MIN= MIN_ROW_CNT[11:0];
localparam [11:0] ROW_CNT_G_MIN= MIN_ROW_CNT_G[11:0];

    // ------------------------------------------------------------------
    // 1) 像素坐标（与 hdmi_mixer 的 S_x/S_y 同规则）
    // ------------------------------------------------------------------
    reg [11:0] S_px;
    reg [11:0] S_py;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_px <= 12'd0;
            S_py <= 12'd0;
        end
        else if (valid_i) begin
            if (user_i) begin
                // 帧首拍对应像素 x=0（x_now 由 user_i 分支直接取 0），故 S_px 应指向
                // "下一拍"即 x=1。若此处写 0，帧首行的 x 会整体滞后 1 拍：判据来自像素
                // x=n，而随判据打拍锁存的坐标是 n-1（实测症状：帧首行贴左边目标的
                // xmin 少 1，例如 x[0..15] 的块报 xmin=1 而不是 2）。
                S_px <= 12'd1;
                S_py <= 12'd0;
            end
            else if (last_i) begin
                S_px <= 12'd0;
                S_py <= S_py + 12'd1;
            end
            else begin
                S_px <= S_px + 12'd1;
            end
        end
    end

    wire [11:0] x_now = user_i ? 12'd0 : (last_i ? X_LAST : S_px);
    wire [11:0] y_now = user_i ? 12'd0 : S_py;

    // ------------------------------------------------------------------
    // 2) 颜色阈值判据 + 最小亮度门限（组合，纯比较）
    // ------------------------------------------------------------------
    wire [7:0] p_r = rgb_i[23:16];
    wire [7:0] p_g = rgb_i[15:8];
    wire [7:0] p_b = rgb_i[7:0];

    wire [8:0] r9 = {1'b0, p_r};
    wire [8:0] g9 = {1'b0, p_g};
    wire [8:0] b9 = {1'b0, p_b};

    wire [7:0] rg_max = (p_r >= p_g) ? p_r : p_g;
    wire [7:0] p_max  = (rg_max >= p_b) ? rg_max : p_b;
    wire [7:0] rg_min = (p_r <= p_g) ? p_r : p_g;
    wire [7:0] p_min  = (rg_min <= p_b) ? rg_min : p_b;
    wire [7:0] p_sat  = p_max - p_min;
    wire       lum_ok = (p_max >= LUMA_MIN);
    wire       sat_ok = (p_sat >= SAT_MIN);

    // 绝对差下限（抑制暗部背景）：R - max(G,B) >= MIN_DIFF_R；G - max(R,B) >= MIN_DIFF_G
    wire [7:0] gb_max = (p_g >= p_b) ? p_g : p_b;
    wire [7:0] rb_max = (p_r >= p_b) ? p_r : p_b;
    wire       rdiff_ok = (r9 >= ({1'b0, gb_max} + DIFF_R));
    wire       gdiff_ok = (g9 >= ({1'b0, rb_max} + DIFF_G));

    // 红判据比较用的比例阈值（RATIO_SHIFT = 1 → 1.5 倍）
    wire [8:0] g_r_sc = g9 + (g9 >> RATIO_SHIFT);
    wire [8:0] b_r_sc = b9 + (b9 >> RATIO_SHIFT);
    // 绿判据比较用的比例阈值（RATIO_SHIFT_G = 0 → 2.0 倍；实测 1.5 倍时布料会被算成绿）
    wire [8:0] r_g_sc = r9 + (r9 >> RATIO_SHIFT_G);
    wire [8:0] b_g_sc = b9 + (b9 >> RATIO_SHIFT_GB);

    wire red_fg = lum_ok && sat_ok && (r9 > g_r_sc) && (r9 > b_r_sc) && rdiff_ok;
    wire grn_fg = lum_ok && sat_ok && (g9 > r_g_sc) && (g9 > b_g_sc) && gdiff_ok;

    // ------------------------------------------------------------------
    // 3) 统计降采样相位
    // ------------------------------------------------------------------
    reg [2:0] S_dec;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            S_dec <= 3'd0;
        else if (valid_i)
            S_dec <= (S_dec == DEC_LAST) ? 3'd0 : (S_dec + 3'd1);
    end

    wire dec_hit = (S_dec == 3'd0);

    // ------------------------------------------------------------------
    // 4) 水平 MIN_RUN 点连续确认（滤孤立/短噪声；零行缓存）
    // ------------------------------------------------------------------
    reg [1:0] S_rfg_hist;
    reg [1:0] S_gfg_hist;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_rfg_hist <= 2'b00;
            S_gfg_hist <= 2'b00;
        end
        else if (valid_i) begin
            if (last_i) begin
                S_rfg_hist <= 2'b00;      // 行末清零，避免跨行串扰
                S_gfg_hist <= 2'b00;
            end
            else begin
                S_rfg_hist <= {S_rfg_hist[0], red_fg};
                S_gfg_hist <= {S_gfg_hist[0], grn_fg};
            end
        end
    end

    wire red_ok = red_fg && (S_rfg_hist == 2'b11);
    wire grn_ok = grn_fg && (S_gfg_hist == 2'b11);

    // ------------------------------------------------------------------
    // 5) 判据 + 坐标打 1 拍（统计级输入全为寄存器输出）
    // ------------------------------------------------------------------
    reg        S_en;
    reg        S_fg_r;
    reg        S_fg_g;
    reg [11:0] S_xd;
    reg [11:0] S_yd;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_en   <= 1'b0;
            S_fg_r <= 1'b0;
            S_fg_g <= 1'b0;
            S_xd   <= 12'd0;
            S_yd   <= 12'd0;
        end
        else begin
            S_en   <= valid_i & dec_hit;
            S_fg_r <= red_ok;
            S_fg_g <= grn_ok;
            S_xd   <= x_now;
            S_yd   <= y_now;
        end
    end

    // ------------------------------------------------------------------
    // 6) 行内累加（红/绿）+ 行切换检测
    // ------------------------------------------------------------------
    reg [11:0] S_rcnt_row, S_rmin_row, S_rmax_row;
    reg [11:0] S_gcnt_row, S_gmin_row, S_gmax_row;
    reg [11:0] S_yd_d;
    wire row_chg = (S_yd != S_yd_d);       // 本拍进入新的一行（采样意义上）

    // 上一行的 y：行号连续，故为 S_yd-1（帧首时 S_yd 已变成"末行+1"，减 1 正好是最后一行）
    wire [11:0] y_prev = (S_yd == 12'd0) ? 12'd0 : (S_yd - 12'd1);

    // ------------------------------------------------------------------
    // 7) 帧内统计（行末提交）+ 帧首封存
    // ------------------------------------------------------------------
    reg [31:0] S_rarea;
    reg [11:0] S_rxmin, S_rxmax, S_rymin, S_rymax;
    reg [31:0] S_garea;
    reg [11:0] S_gxmin, S_gxmax, S_gymin, S_gymax;
    reg [1:0]  S_grow_ok_h;  // 前 1、2 行是否达到绿行门限（配合 MIN_ROW_RUN_G）

    // 帧首封存时把"尚未提交的最后一行"组合合并进来（不丢行）
    wire        r_pend_ok = (S_rcnt_row >= ROW_CNT_MIN) && (S_rcnt_row != 12'd0);
    wire [11:0] r_xmin_f  = (r_pend_ok && (S_rmin_row < S_rxmin)) ? S_rmin_row : S_rxmin;
    wire [11:0] r_xmax_f  = (r_pend_ok && (S_rmax_row > S_rxmax)) ? S_rmax_row : S_rxmax;
    wire [11:0] r_ymin_f  = (r_pend_ok && (y_prev      < S_rymin)) ? y_prev    : S_rymin;
    wire [11:0] r_ymax_f  = (r_pend_ok && (y_prev      > S_rymax)) ? y_prev    : S_rymax;
    wire [31:0] r_area_f  = r_pend_ok ? (S_rarea + {20'd0, S_rcnt_row}) : S_rarea;

    // 绿：本行达标的原始条件；还要**前面 MIN_ROW_RUN_G-1 行也达标**（连续 N 行），
    // 这样绿方块上边缘那种"偶尔凑够点数"的孤立过渡行会被滤掉，绿框上边不再抖动。
    wire        g_row_ok  = (S_gcnt_row >= ROW_CNT_G_MIN) && (S_gcnt_row != 12'd0);
    wire        g_run_ok  = (MIN_ROW_RUN_G <= 1) ? 1'b1 :
                             (MIN_ROW_RUN_G == 2) ? S_grow_ok_h[0] :
                                                    (S_grow_ok_h == 2'b11);   // >=3：本行 + 前两行
    wire        g_pend_ok = g_row_ok && g_run_ok;
    wire [11:0] g_xmin_f  = (g_pend_ok && (S_gmin_row < S_gxmin)) ? S_gmin_row : S_gxmin;
    wire [11:0] g_xmax_f  = (g_pend_ok && (S_gmax_row > S_gxmax)) ? S_gmax_row : S_gxmax;
    wire [11:0] g_ymin_f  = (g_pend_ok && (y_prev      < S_gymin)) ? y_prev    : S_gymin;
    wire [11:0] g_ymax_f  = (g_pend_ok && (y_prev      > S_gymax)) ? y_prev    : S_gymax;
    wire [31:0] g_area_f  = g_pend_ok ? (S_garea + {20'd0, S_gcnt_row}) : S_garea;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_rarea <= 32'd0; S_rxmin <= SENT_X; S_rxmax <= 12'd0; S_rymin <= SENT_Y; S_rymax <= 12'd0;
            S_garea <= 32'd0; S_gxmin <= SENT_X; S_gxmax <= 12'd0; S_gymin <= SENT_Y; S_gymax <= 12'd0;
            S_rcnt_row <= 12'd0; S_rmin_row <= SENT_X; S_rmax_row <= 12'd0;
            S_gcnt_row <= 12'd0; S_gmin_row <= SENT_X; S_gmax_row <= 12'd0;
            S_grow_ok_h <= 2'b00;
            S_yd_d <= 12'd0;

            o_r_valid <= 1'b0; o_r_area <= 32'd0;
            o_r_xmin <= 12'd0; o_r_xmax <= 12'd0; o_r_ymin <= 12'd0; o_r_ymax <= 12'd0;
            o_g_valid <= 1'b0; o_g_area <= 32'd0;
            o_g_xmin <= 12'd0; o_g_xmax <= 12'd0; o_g_ymin <= 12'd0; o_g_ymax <= 12'd0;
        end
        else if (user_i) begin
            // ---- 帧首：封存（含 pending 行）并清零 ----
            o_r_valid <= (r_area_f >= MIN_AREA[31:0]);
            o_r_area  <= r_area_f;
            o_r_xmin  <= r_xmin_f;
            o_r_xmax  <= r_xmax_f;
            o_r_ymin  <= r_ymin_f;
            o_r_ymax  <= r_ymax_f;
            o_g_valid <= (g_area_f >= MIN_AREA[31:0]);
            o_g_area  <= g_area_f;
            o_g_xmin  <= g_xmin_f;
            o_g_xmax  <= g_xmax_f;
            o_g_ymin  <= g_ymin_f;
            o_g_ymax  <= g_ymax_f;

            S_rarea <= 32'd0; S_rxmin <= SENT_X; S_rxmax <= 12'd0; S_rymin <= SENT_Y; S_rymax <= 12'd0;
            S_garea <= 32'd0; S_gxmin <= SENT_X; S_gxmax <= 12'd0; S_gymin <= SENT_Y; S_gymax <= 12'd0;
            S_rcnt_row <= 12'd0; S_rmin_row <= SENT_X; S_rmax_row <= 12'd0;
            S_gcnt_row <= 12'd0; S_gmin_row <= SENT_X; S_gmax_row <= 12'd0;
            S_grow_ok_h <= 2'b00;
            S_yd_d <= S_yd;
        end
        else if (S_en) begin
            if (row_chg) begin
                // ---- 换行：提交上一行（仅当该行前景采样点够多）----
                if (S_rcnt_row >= ROW_CNT_MIN) begin
                    if (S_rmin_row < S_rxmin) S_rxmin <= S_rmin_row;
                    if (S_rmax_row > S_rxmax) S_rxmax <= S_rmax_row;
                    if (y_prev     < S_rymin) S_rymin <= y_prev;
                    if (y_prev     > S_rymax) S_rymax <= y_prev;
                    S_rarea <= S_rarea + {20'd0, S_rcnt_row};
                end
                if (g_row_ok && g_run_ok) begin
                    if (S_gmin_row < S_gxmin) S_gxmin <= S_gmin_row;
                    if (S_gmax_row > S_gxmax) S_gxmax <= S_gmax_row;
                    if (y_prev     < S_gymin) S_gymin <= y_prev;
                    if (y_prev     > S_gymax) S_gymax <= y_prev;
                    S_garea <= S_garea + {20'd0, S_gcnt_row};
                end

                // ---- 新行：把当前像素计入 ----
                S_rcnt_row <= S_fg_r ? 12'd1 : 12'd0;
                S_rmin_row <= S_fg_r ? S_xd : SENT_X;
                S_rmax_row <= S_fg_r ? S_xd : 12'd0;
                S_gcnt_row <= S_fg_g ? 12'd1 : 12'd0;
                S_gmin_row <= S_fg_g ? S_xd : SENT_X;
                S_gmax_row <= S_fg_g ? S_xd : 12'd0;
                S_grow_ok_h <= {S_grow_ok_h[0], g_row_ok};   // 记录本行是否达标，供下一行连续判定
            end
            else begin
                // ---- 同一行内：累加 ----
                if (S_fg_r) begin
                    S_rcnt_row <= S_rcnt_row + 12'd1;
                    if (S_xd < S_rmin_row) S_rmin_row <= S_xd;
                    if (S_xd > S_rmax_row) S_rmax_row <= S_xd;
                end
                if (S_fg_g) begin
                    S_gcnt_row <= S_gcnt_row + 12'd1;
                    if (S_xd < S_gmin_row) S_gmin_row <= S_xd;
                    if (S_xd > S_gmax_row) S_gmax_row <= S_xd;
                end
            end
            S_yd_d <= S_yd;
        end
        // 注意：S_yd_d 只在采样拍（S_en）更新。
        // 若每拍都更新，行切换若发生在两个采样点之间的非采样拍，row_chg 会在下一个
        // 采样拍到来之前就被"吃掉"，导致该行永远不被提交（实测症状：只有最后一行的
        // y 被算进包围框）。
    end

    // Blue uses the same pixel coordinates and decimation phase as red/green.
    // 12-bit unsigned products cover 255 * 15 without overflow; Q2 means /4.
    localparam [3:0] BLUE_R_SCALE = B_R_RATIO_Q2;
    localparam [3:0] BLUE_G_SCALE = B_G_RATIO_Q2;
    localparam [8:0] DIFF_B = MIN_DIFF_B;
    localparam [11:0] ROW_CNT_B_MIN = MIN_ROW_CNT_B;
    wire [11:0] blue_four = {2'b00, p_b, 2'b00};
    wire [11:0] blue_red_limit = {4'b0000, p_r} * BLUE_R_SCALE;
    wire [11:0] blue_green_limit = {4'b0000, p_g} * BLUE_G_SCALE;
    wire blue_diff_ok = b9 >= ({1'b0, rg_max} + DIFF_B);
    wire dark_blue_fg = blue_diff_ok && (blue_four > blue_red_limit) && (blue_four > blue_green_limit);
    wire [7:0] blue_green_min = p_b<p_g ? p_b : p_g;
    wire [7:0] blue_green_max = p_b>p_g ? p_b : p_g;
    wire [7:0] blue_green_delta = p_b>p_g ? p_b-p_g : p_g-p_b;
    wire [11:0] light_blue_red_limit = {4'd0,p_r} * LIGHT_B_R_Q2;
    wire [11:0] light_green_red_limit = {4'd0,p_r} * LIGHT_G_R_Q2;
    wire light_blue_fg = (blue_four>light_blue_red_limit) &&
                         ({2'd0,p_g,2'd0}>light_green_red_limit) &&
                         ({1'b0,blue_green_min}>={1'b0,p_r}+LIGHT_MIN_DIFF) &&
                         (blue_green_delta<=(blue_green_max>>LIGHT_BALANCE_SHIFT));
    wire blu_fg = lum_ok && sat_ok && (dark_blue_fg || ((EXTENDED_BLUE!=0) && light_blue_fg)) &&
                  ((USE_BLUE_GATE==0) || blue_allow_i);
    reg [1:0] S_bfg_hist;
    reg S_fg_b;
    wire blu_ok = blu_fg && (S_bfg_hist == 2'b11) && !user_i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_bfg_hist <= 2'b00;
            S_fg_b <= 1'b0;
        end else begin
            S_fg_b <= blu_ok;
            if (valid_i) begin
                if (last_i) S_bfg_hist <= 2'b00;
                else if (user_i) S_bfg_hist <= {1'b0, blu_fg};
                else S_bfg_hist <= {S_bfg_hist[0], blu_fg};
            end
        end
    end
    reg [11:0] S_bcnt_row, S_bmin_row, S_bmax_row;
    reg [31:0] S_barea;
    reg [11:0] S_bxmin, S_bxmax, S_bymin, S_bymax;
    reg [1:0] S_brow_ok_h;
    wire        b_row_ok  = (S_bcnt_row >= ROW_CNT_B_MIN) && (S_bcnt_row != 12'd0);
    wire        b_run_ok  = (MIN_ROW_RUN_B <= 1) ? 1'b1 :
                             (MIN_ROW_RUN_B == 2) ? S_brow_ok_h[0] :
                                                    (S_brow_ok_h == 2'b11);   // >=3：本行 + 前两行
    wire        b_pend_ok = b_row_ok && b_run_ok;
    wire [11:0] b_xmin_f  = (b_pend_ok && (S_bmin_row < S_bxmin)) ? S_bmin_row : S_bxmin;
    wire [11:0] b_xmax_f  = (b_pend_ok && (S_bmax_row > S_bxmax)) ? S_bmax_row : S_bxmax;
    wire [11:0] b_ymin_f  = (b_pend_ok && (y_prev      < S_bymin)) ? y_prev    : S_bymin;
    wire [11:0] b_ymax_f  = (b_pend_ok && (y_prev      > S_bymax)) ? y_prev    : S_bymax;
    wire [31:0] b_area_f  = b_pend_ok ? (S_barea + {20'd0, S_bcnt_row}) : S_barea;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            S_barea <= 32'd0; S_bxmin <= SENT_X; S_bxmax <= 12'd0; S_bymin <= SENT_Y; S_bymax <= 12'd0;
            S_bcnt_row <= 12'd0; S_bmin_row <= SENT_X; S_bmax_row <= 12'd0;
            S_brow_ok_h <= 2'b00;

            o_b_valid <= 1'b0; o_b_area <= 32'd0;
            o_b_xmin <= 12'd0; o_b_xmax <= 12'd0; o_b_ymin <= 12'd0; o_b_ymax <= 12'd0;
        end
        else if (user_i) begin
            // ---- 帧首：封存（含 pending 行）并清零 ----
            o_b_valid <= (b_area_f >= MIN_AREA[31:0]);
            o_b_area  <= b_area_f;
            o_b_xmin  <= b_xmin_f;
            o_b_xmax  <= b_xmax_f;
            o_b_ymin  <= b_ymin_f;
            o_b_ymax  <= b_ymax_f;

            S_barea <= 32'd0; S_bxmin <= SENT_X; S_bxmax <= 12'd0; S_bymin <= SENT_Y; S_bymax <= 12'd0;
            S_bcnt_row <= 12'd0; S_bmin_row <= SENT_X; S_bmax_row <= 12'd0;
            S_brow_ok_h <= 2'b00;
        end
        else if (S_en) begin
            if (row_chg) begin
                // ---- 换行：提交上一行（仅当该行前景采样点够多）----
                if (b_row_ok && b_run_ok) begin
                    if (S_bmin_row < S_bxmin) S_bxmin <= S_bmin_row;
                    if (S_bmax_row > S_bxmax) S_bxmax <= S_bmax_row;
                    if (y_prev     < S_bymin) S_bymin <= y_prev;
                    if (y_prev     > S_bymax) S_bymax <= y_prev;
                    S_barea <= S_barea + {20'd0, S_bcnt_row};
                end

                // ---- 新行：把当前像素计入 ----
                S_bcnt_row <= S_fg_b ? 12'd1 : 12'd0;
                S_bmin_row <= S_fg_b ? S_xd : SENT_X;
                S_bmax_row <= S_fg_b ? S_xd : 12'd0;
                S_brow_ok_h <= {S_brow_ok_h[0], b_row_ok};   // 记录本行是否达标，供下一行连续判定
            end
            else begin
                // ---- 同一行内：累加 ----
                if (S_fg_b) begin
                    S_bcnt_row <= S_bcnt_row + 12'd1;
                    if (S_xd < S_bmin_row) S_bmin_row <= S_xd;
                    if (S_xd > S_bmax_row) S_bmax_row <= S_xd;
                end
            end
        end
    end

endmodule
