`include "color_params.vh"
// ============================================================================
// color_param_bank —— 15 项颜色检测参数的"编辑 / 生效"双副本与帧尾原子提交
//
// 依据：docs/handoff_color_ui_20261021/EXECUTION_CONSTRAINTS.md §5、§6
//
// 分工：
//   · 编辑值（edit）由 color_ui_fsm 持有，按键随时可改，不影响本帧检测；
//   · 生效值（eff）只在本帧最后一个像素之后（valid_i & last_i & y==IMG_H-1）
//     从编辑值整组拷贝。下一帧第一个像素（user_i）拿到的已经是新值，因此
//     "帧首原子生效"成立，且不会出现首像素仍用旧门限的错位。
//
// 参数打包格式（240 bit，每项 16 bit）：
//   [15:0]    R_DIFF     红 通道差下限        0..255   step 1
//   [31:16]   R_RG_Q5    红 R/G 比例 Q5       32..120  step 1
//   [47:32]   R_RB_Q5    红 R/B 比例 Q5       32..120  step 1
//   [63:48]   G_DIFF     绿 通道差下限        0..255   step 1
//   [79:64]   G_GR_Q5    绿 G/R 比例 Q5       32..120  step 1
//   [95:80]   G_GB_Q5    绿 G/B 比例 Q5       32..120  step 1
//   [111:96]  DB_DIFF    深蓝 通道差下限      0..255   step 1
//   [127:112] DB_BR_Q5   深蓝 B/R 比例 Q5     32..120  step 1
//   [143:128] DB_BG_Q5   深蓝 B/G 比例 Q5     32..120  step 1
//   [159:144] LB_DIFF    浅蓝 min(B,G)-R 差   0..255   step 1
//   [175:160] LB_BR_Q5   浅蓝 B/R 比例 Q5     32..120  step 1
//   [191:176] LB_GR_Q5   浅蓝 G/R 比例 Q5     32..120  step 1
//   [207:192] MIN_LUMA   最低亮度             0..255   step 1
//   [223:208] MIN_SAT    最低通道跨度         0..255   step 1
//   [239:224] MIN_AREA   最小采样面积         1..4096  step 1
//
// Q5 比例：显示值 = 数值/32，32 = 1.000、64 = 2.000。工厂默认由
// thresholds_before.json 的 23 项实际生效参数换算：
//   红  2.000 / 2.000 → 64 / 64
//   绿  1.125 / 1.500 → 36 / 48  （1.125 正是旧 RATIO_SHIFT_G=3 的精确 Q5）
//   深蓝1.500 / 1.250 → 48 / 40  （旧 Q2 6/5 × 8）
//   浅蓝1.250 / 1.250 → 40 / 40
// 旧实现的移位式比例（1 + 2^-s）与 Q2/4 式比例在 Q5 下逐像素等价。
// ============================================================================

module color_param_bank #(
    parameter integer IMG_H = 720,

    // ---- 工厂默认（必须与 thresholds_before.json 一致）----
    parameter integer DEF_R_DIFF   = `COLOR_DEF_R_DIFF,
    parameter integer DEF_R_RG_Q5  = `COLOR_DEF_R_RG_Q5,
    parameter integer DEF_R_RB_Q5  = `COLOR_DEF_R_RB_Q5,
    parameter integer DEF_G_DIFF   = `COLOR_DEF_G_DIFF,
    parameter integer DEF_G_GR_Q5  = `COLOR_DEF_G_GR_Q5,
    parameter integer DEF_G_GB_Q5  = `COLOR_DEF_G_GB_Q5,
    parameter integer DEF_DB_DIFF  = `COLOR_DEF_DB_DIFF,
    parameter integer DEF_DB_BR_Q5 = `COLOR_DEF_DB_BR_Q5,
    parameter integer DEF_DB_BG_Q5 = `COLOR_DEF_DB_BG_Q5,
    parameter integer DEF_LB_DIFF  = `COLOR_DEF_LB_DIFF,
    parameter integer DEF_LB_BR_Q5 = `COLOR_DEF_LB_BR_Q5,
    parameter integer DEF_LB_GR_Q5 = `COLOR_DEF_LB_GR_Q5,
    parameter integer DEF_MIN_LUMA = `COLOR_DEF_MIN_LUMA,
    parameter integer DEF_MIN_SAT  = `COLOR_DEF_MIN_SAT,
    parameter integer DEF_MIN_AREA = `COLOR_DEF_MIN_AREA
)(
    input  wire          clk,
    input  wire          rst_n,

    // 像素流标记（与 hdmi_mixer 的 I_video_* 同相）
    input  wire          valid_i,
    input  wire          last_i,
    input  wire [11:0]   y_i,

    // 编辑值（来自 color_ui_fsm，可随时变化）
    input  wire [239:0]  I_edit,
    input  wire          I_commit_req,   // 存在待生效修改（电平）

    // 生效值（检测器只读这一份）
    output reg  [239:0]  O_eff,
    output reg  [31:0]   O_version,      // 每提交一次 +1
    output reg           O_committed     // 提交单拍脉冲
);

    localparam [239:0] DEF_BUS = {
        DEF_MIN_AREA[15:0], DEF_MIN_SAT[15:0],  DEF_MIN_LUMA[15:0],
        DEF_LB_GR_Q5[15:0], DEF_LB_BR_Q5[15:0], DEF_LB_DIFF[15:0],
        DEF_DB_BG_Q5[15:0], DEF_DB_BR_Q5[15:0], DEF_DB_DIFF[15:0],
        DEF_G_GB_Q5[15:0],  DEF_G_GR_Q5[15:0],  DEF_G_DIFF[15:0],
        DEF_R_RB_Q5[15:0],  DEF_R_RG_Q5[15:0],  DEF_R_DIFF[15:0]
    };

    // 帧尾：最后一行的最后一个像素。本拍之后即进入下一帧 user_i。
    wire frame_end = valid_i && last_i && (y_i == (IMG_H - 1));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            O_eff       <= DEF_BUS;
            O_version   <= 32'd0;
            O_committed <= 1'b0;
        end
        else begin
            O_committed <= 1'b0;
            if (frame_end && I_commit_req && I_edit != O_eff) begin
                O_eff       <= I_edit;
                O_version   <= O_version + 32'd1;
                O_committed <= 1'b1;
            end
        end
    end

endmodule
