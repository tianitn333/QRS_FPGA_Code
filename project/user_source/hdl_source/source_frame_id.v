// -----------------------------------------------------------------------------
// Module: source_frame_id
//
// 功能：为 DDR 帧缓冲的每一次"新存帧"生成唯一 32 位源帧号，并在显示帧边界提交。
//
// 接入边界（保守方案）：本模块不修改 video_in.v / video_out.v 的任何内部逻辑，
// 只在顶层旁路观察 video_in.O_video_out_rp，因此不触碰 MIPI→DDR 写通路。
//
// 为什么用读指针而不是另起计数器：
//   video_in 在每次成功存帧的相机帧首把 O_video_out_rp 置为 (wp+2)。
//   MIPI 出错时 wp 不前进，rp 因此保持原值 —— 也就是说
//   "rp 发生变化" 恰好等价于 "有一帧新图被成功写入并开始被显示"。
//   于是对 rp 的跳变计数即可得到唯一源帧号；同一缓冲被重复显示时 rp 不动，源帧号也不动。
//   显示光栅 ID（edge_extract.active_tag）是另一回事，不能替代本模块输出。
//
// 跨时钟域：I_rp 属 I_ddr_clk 域，使用方在 I_pix_clk 域。
//   采用 toggle 握手：ddr 域在 rp 跳变时翻转 toggle 并锁存计数与指针；
//   pix 域两级同步 toggle，检测到边沿时采样已稳定 ≥2 个 ddr 周期的数据。
//   前提：相机帧间隔（约 16.7 ms）远大于同步延迟，多帧在同步窗口内连续跳变的情况不成立。
//
// 提交时机：在 I_disp_frame_start（= I_video_user 帧首像素）处一次性切到新源帧号，
//   保证一个显示帧内源帧号恒定，符合"整组在帧边界提交"的工程约定。
// -----------------------------------------------------------------------------

module source_frame_id #(
    parameter integer DUP_WIDTH = 16          // 重复显示计数位宽，饱和不回绕
)(
    // ---- DDR 读指针域 ----
    input  wire                  I_ddr_clk,
    input  wire                  I_ddr_rst_n,
    input  wire [1:0]            I_rp,               // = video_in.O_video_out_rp

    // ---- 显示像素域 ----
    input  wire                  I_pix_clk,
    input  wire                  I_pix_rst_n,
    input  wire                  I_disp_frame_start,  // = I_video_user，帧首有效像素一拍

    // ---- 显示域输出（整个显示帧内恒定）----
    output reg  [31:0]           O_source_id,
    output reg                   O_source_valid,      // 仅当已出现至少一帧有效源图
    output reg  [1:0]            O_source_ptr,        // 提交时的读指针，调试用
    output reg                   O_source_new,        // 帧边界换帧脉冲，一拍
    output reg                   O_source_restart,    // 复位释放后一拍，供 tracker 重启
    output reg  [DUP_WIDTH-1:0]  O_dup_frames         // "源帧未变"的显示帧计数
);

    // =========================================================================
    // DDR 域：读指针跳变 → 源帧号自增
    // =========================================================================
    reg [1:0]  S_rp_q;
    reg        S_primed;
    reg [31:0] S_id_cnt;
    reg [1:0]  S_rp_lat;
    reg        S_tog;

    always @(posedge I_ddr_clk or negedge I_ddr_rst_n) begin
        if (!I_ddr_rst_n) begin
            S_rp_q   <= 2'd0;
            S_primed <= 1'b0;
            S_id_cnt <= 32'd0;
            S_rp_lat <= 2'd0;
            S_tog    <= 1'b0;
        end else if (!S_primed) begin
            // 复位后的第一拍只记录初值、不计数：
            // 这样即使复位时 rp 非 0，也不会凭空多出一个源帧号。
            S_rp_q   <= I_rp;
            S_primed <= 1'b1;
        end else begin
            S_rp_q <= I_rp;
            if (I_rp != S_rp_q) begin
                S_id_cnt <= S_id_cnt + 32'd1;
                S_rp_lat <= I_rp;
                S_tog    <= ~S_tog;
            end
        end
    end

    // =========================================================================
    // 跨域：toggle 两级同步 + 数据采样（数据在 toggle 边沿前已稳定）
    // =========================================================================
    reg        S_t1, S_t2, S_t3;
    reg [31:0] S_id_hold;
    reg [1:0]  S_ptr_hold;

    always @(posedge I_pix_clk or negedge I_pix_rst_n) begin
        if (!I_pix_rst_n) begin
            S_t1       <= 1'b0;
            S_t2       <= 1'b0;
            S_t3       <= 1'b0;
            S_id_hold  <= 32'd0;
            S_ptr_hold <= 2'd0;
        end else begin
            S_t1 <= S_tog;
            S_t2 <= S_t1;
            S_t3 <= S_t2;

            if (S_t2 != S_t3) begin
                // 此刻 S_id_cnt / S_rp_lat 已稳定多个 ddr 周期
                S_id_hold  <= S_id_cnt;
                S_ptr_hold <= S_rp_lat;
            end
        end
    end

    // =========================================================================
    // 显示帧边界提交
    // =========================================================================
    always @(posedge I_pix_clk or negedge I_pix_rst_n) begin
        if (!I_pix_rst_n) begin
            O_source_id    <= 32'd0;
            O_source_valid <= 1'b0;
            O_source_ptr   <= 2'd0;
            O_source_new   <= 1'b0;
            O_dup_frames   <= {DUP_WIDTH{1'b0}};
        end else begin
            O_source_new <= 1'b0;

            if (I_disp_frame_start) begin
                if (S_id_hold != O_source_id) begin
                    O_source_id    <= S_id_hold;
                    O_source_valid <= (S_id_hold != 32'd0);
                    O_source_ptr   <= S_ptr_hold;
                    O_source_new   <= 1'b1;
                end else if (O_source_valid &&
                             (O_dup_frames != {DUP_WIDTH{1'b1}})) begin
                    // 新的一帧显示，但源帧号没变 → 同一源帧被重复显示
                    O_dup_frames <= O_dup_frames + 1'b1;
                end
            end
        end
    end

    // =========================================================================
    // 复位释放脉冲：告知下游源序列重新开始
    // =========================================================================
    reg S_restart_d;

    always @(posedge I_pix_clk or negedge I_pix_rst_n) begin
        if (!I_pix_rst_n) begin
            S_restart_d      <= 1'b1;
            O_source_restart <= 1'b0;
        end else begin
            S_restart_d      <= 1'b0;
            O_source_restart <= S_restart_d;
        end
    end

endmodule
