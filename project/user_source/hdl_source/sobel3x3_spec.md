# 2026-10-18 当前增量合同

新增gradient_polarity_o，与gradient_o/fine同拍；垂直法向用Gy符号，其他方向用Gx符号，0为正、1为负。四方向与极性合成八个有向法向。现有高斯、自适应高阈值clamp(3L/4,32,96)、低阈值高阈值的一半和完整11bit幅值不变。此端口不增加原Sobel延迟。

本节覆盖下方历史接口中相应参数/端口描述；当前源码与逐拍测试为完整接口依据。

# sobel3x3

## Interface

```verilog
module sobel3x3 #(
    parameter integer IMG_W   = 1280,
    parameter integer IMG_H   = 720,
    parameter integer TH      = 96,   // |Gx|+|Gy| 门限
    parameter integer OUT_BIN = 1,    // 1 = 二值边缘（0/255）；0 = 幅值（取低 8 位）
    parameter integer ADAPTIVE_TH = 0, // 默认保持固定阈值，工程实例显式启用自适应
    parameter integer TH_SCALE_Q2 = 4,
    parameter integer TH_MIN = 32     // 自适应阈值下限；要求 0 <= TH_MIN <= TH <= 4095
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_i,       // 与 gray_i 同拍
    input  wire        user_i,        // 帧首脉冲（与第一个有效像素同拍）
    input  wire        last_i,        // 行末脉冲（与最后一个有效像素同拍）
    input  wire [7:0]  gray_i,        // 灰度像素

    output reg         valid_o,
    output reg  [7:0]  edge_o,
    output reg  [11:0] x_o,           // 窗口中心坐标
    output reg  [11:0] y_o,
    // Dense gradient stream for contour preparation; existing outputs are unchanged.
    output reg raster_valid_o, raster_user_o, raster_last_o,
    output reg [1:0] gradient_fine_o,
    output reg [12:0] gradient_o
);
```

## Clock, reset and behavior

75MHz single pixel/clock, active-low asynchronous control reset. All existing outputs retain their behavior. gradient_o[12:0] is unchanged. New gradient_fine_o[1:0] carries the two magnitude low bits with the same clock and raster_valid/user/last. Adaptive threshold and all gradient flags retain full precision. Never combine fine bits from a different cycle.

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
