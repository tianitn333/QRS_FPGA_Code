# 2026-10-20 当前接口（覆盖以下历史说明）

新增EDGE_COMPARE_ENABLE=0参数。顶层设1；I_key_det_trig成为K2切换事件，检测叠加保持打开。K2从原图/灰度进入DETECT，在边缘两子模式间切换；K1继续原图/灰度/边缘。两事件同时到达时K2优先。运行值在I_video_user锁存，帧首同拍按键影响后一帧。DETECT使用detection_o，EXTRACT使用原refined_bit；均以相同4960拍光栅对齐。附加模式位31随光栅延迟，字样DETECT/EXTRACT位于x176..287,y72..87；EXTRACT另显示P/S。稠密/点/段输出始终来自EXTRACT，不受显示子模式影响。

# 2026-10-18 当前增量合同

新增EDGE_COHERENCE_ENABLE=0、BG_NOISE_CAL_ENABLE=0、BG_NOISE_MARGIN=8参数，顶层显式启用前两者。细化开启时EDGE_RASTER_DELAY=3*H_TOTAL+8+2*EDGE_COHERENCE_ENABLE，实际工程4960拍（75MHz约66.133微秒）；纯边缘稠密流的x/y/valid及原图/灰度/HDMI保持统一光栅。事件提取仍相对稠密数据晚一拍。BG模型内部学习流水不改变RGB/allow三寄存级。三色快照和中心坐标的发布规则不变。

本节覆盖下方历史接口中相应参数/端口描述；当前源码与逐拍测试为完整接口依据。

# hdmi_mixer

## Interface

```verilog
module hdmi_mixer #(
    parameter H_OFFSET = 128,
    parameter V_OFFSET = 60,
    parameter IMG_WIDTH = 1280,
    parameter IMG_HEIGHT = 720,
    parameter integer DEBUG_MODE = 0,
    // 上电默认显示源（本工程扩展，2026-10 M3 自动曝光轮次）：
    //   1 = 原图直通（彩色），0 = 灰度（V0.1 原行为）
    // 运行期可用板载按键（D5）在「原图 → 灰度 → 边缘」之间循环切换；
    // 该参数只决定**上电时的默认档**，不再固定整机行为。
    parameter integer VIDEO_SRC = 1,
    // ---- 检测判据参数（透传给 color_detect_box；见该模块内注释与参数扫描依据）----
    parameter integer DET_RATIO_SHIFT    = 0,  // 红判据比例：0 → 2.0 倍（1.5 倍会把皮肤/手算成红，皮肤 R/G≈1.3~1.6）
    parameter integer DET_RATIO_SHIFT_G  = 3,  // 绿判据对 R：1.125 倍，保留偏黄弱绿区域
    parameter integer DET_RATIO_SHIFT_GB = 1,  // 绿判据(对 B)比例：1 → 1.5 倍
    parameter integer DET_MIN_SAT     = 18,   // 饱和度门限（配合亮度门槛提升暗角下的检出率）
    parameter integer DET_MIN_LUMA    = 44,   // 最小亮度门限（48 → 40：避免两侧暗角下丢框）
    parameter integer DET_MIN_ROW_CNT = 6,    // 红色每行至少 6 个采样点，允许部分入画
    parameter integer DET_MIN_DIFF_R  = 48,   // 红判据绝对差下限 R-max(G,B)（48 可消除框抖动）
    parameter integer DET_MIN_DIFF_G  = 12,   // 绿判据绝对差下限 G-max(R,B)
    parameter integer DET_MIN_ROW_CNT_G = 4,  // 绿色每行至少 4 个采样点
    parameter integer DET_MIN_ROW_RUN_G = 2,  // 保留绿色连续两行确认
    parameter integer DET_B_R_RATIO_Q2 = 6,
    parameter integer DET_B_G_RATIO_Q2 = 7,
    parameter integer BLUE_BACKGROUND_ENABLE = 0,
    parameter integer EDGE_DENOISE_ENABLE = 0,
    parameter integer EDGE_REFINE_ENABLE = 1,
    parameter integer EDGE_PRECISE_ENABLE = 1,
    parameter integer EDGE_COHERENCE_ENABLE = 0,
    parameter integer EDGE_COMPARE_ENABLE = 0,
    parameter integer BG_NOISE_CAL_ENABLE = 0,
    parameter integer BG_NOISE_MARGIN = 8,
    parameter integer EDGE_EXTRACT_ENABLE = 1,
    parameter integer EDGE_STATS_ENABLE = 1,
    parameter integer H_TOTAL = 1650,
    parameter integer BG_SETTLE_CYCLES = 37500000,
    parameter integer DET_EXTENDED_BLUE = 0,
    parameter integer DET_LIGHT_B_R_Q2 = 5,
    parameter integer DET_LIGHT_G_R_Q2 = 5,
    parameter integer DET_LIGHT_MIN_DIFF = 20,
    parameter integer DET_LIGHT_BALANCE_SHIFT = 2,
    parameter integer DET_MIN_DIFF_B = 20,
    parameter integer DET_MIN_ROW_CNT_B = 4,
    parameter integer DET_MIN_ROW_RUN_B = 2,
    parameter integer DET_MIN_AREA = 32      // 合格行累计的采样点数，不是原图像素面积
)(
    input wire        I_clk,
    input wire        I_rst_n,

    input wire        I_video_vsync,
    input wire        I_video_hsync,
    input wire        I_video_de,
    input wire        I_video_user,
    input wire        I_video_last,

    input wire[3:0]   I_debug_status,

    // 板载按键事件（已去抖、单拍脉冲、与 I_clk 同域；来源见 design_top_wrapper.v）
    input wire        I_key_src_trig,     // KEY1/D5：循环切换显示源
    input wire        I_bg_calibrate,
    input wire        I_key_det_trig,     // KEY2/A9：对比模式切换；EDGE_COMPARE_ENABLE=0时保持旧叠加开关

    output wire       O_video_rd_en,
    input wire[23:0]  I_video_rd_data,

    output reg        O_hdmi_vsync,
    output reg        O_hdmi_hsync,
    output reg        O_hdmi_de,
    output reg[23:0]  O_hdmi_data,
    // Dense, overlay-free edge stream; active when EDGE_DENOISE_ENABLE is set.
    output wire O_edge_valid, O_edge_user, O_edge_last, O_edge_bit,
    output wire [11:0] O_edge_x, O_edge_y,
    output wire O_edge_point_valid,
    output wire [11:0] O_edge_point_x,O_edge_point_y,
    output wire [15:0] O_edge_point_frame,
    output wire O_edge_run_valid,
    output wire [11:0] O_edge_run_start,O_edge_run_end,O_edge_run_y,
    output wire [12:0] O_edge_run_length,
    output wire [15:0] O_edge_run_frame,
    output wire O_edge_frame_done,
    output wire [15:0] O_edge_frame_id,
    output wire [23:0] O_edge_frame_points,O_edge_frame_runs,
    output wire O_edge_bbox_valid,
    output wire [11:0] O_edge_xmin,O_edge_xmax,O_edge_ymin,O_edge_ymax
);
```

## Clock, reset and behavior

75MHz single pixel/clock, active-low asynchronous control reset. EDGE_PRECISE_ENABLE=1, EDGE_EXTRACT_ENABLE=1 and EDGE_STATS_ENABLE=1 default on when denoising/refinement is active. Old dense O_edge interface stays one clock before registered HDMI. New point/run/snapshot outputs have one clock latency from dense interface and align with the HDMI pixel stage. Counter text only affects the displayed edge mode; existing overlays have priority. No new physical pins or ready/backpressure. Unconnected event endpoints can be removed by synthesis; later consumers require renewed timing/resource validation.

## Constraints and verification

No backpressure. Input valid markers and x/y form a complete dense raster. First marker follows reset; RAM contents are not reset and unsupported borders are masked. Native tests cover original behavior, full-precision spatial oracle, sparse point and offline row-run oracle, counts, empty/full/one-pixel/last-pixel cases, invalid gaps, abort/restart, reset, ID wrap, full720p, decimal conversion, glyph pixels and display isolation. ADC/SDC remain unchanged; actual native timing and bitstream evidence must be checked independently.

## Timing illustration

```json
{
  "signal": [
    {
      "name": "clk",
      "wave": "p......."
    },
    {
      "name": "rst_n",
      "wave": "01......"
    },
    {
      "name": "dense_valid",
      "wave": "00111100"
    },
    {
      "name": "event_valid",
      "wave": "00011110"
    }
  ]
}
```

WaveJSON is illustrative; exact latencies are stated above and asserted in native tests. No rendered SVG is provided.


当前切换示意（不含视频长延迟；逐拍日志为数值依据）：
```json
{"signal": [{"name": "clk", "wave": "p......."}, {"name": "key_event", "wave": "010....."}, {"name": "frame_start", "wave": "0..10..."}, {"name": "requested_extract", "wave": "0.1....."}, {"name": "effective_extract", "wave": "0...1..."}]}
```
