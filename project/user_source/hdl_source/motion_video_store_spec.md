# motion_video_store 模块规格

RTL位于同目录motion_video_store.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_video_store #(
    parameter integer IMAGE_WIDTH=1280, IMAGE_HEIGHT=720
)(
    input wire camera_clk, camera_rst_n, ddr_clk, ddr_rst_n,
    input wire user_i, valid_i,
    input wire [95:0] rgb_i,
    input wire [31:0] source_i, race_i,
    input wire [26:0] geometry_i,
    input wire track_i, enable_i,
    input wire decision_i,
    input wire [31:0] decision_source_i, decision_race_i,
    input wire [2:0] decision_mask_i,
    input wire decision_good_i,
    input wire read_busy_i,
    input wire [6:0] read_protect_i,
    input wire user_ready_i, controller_write_i,
    input wire [1:0] view_lane_i,
    output wire write_busy_o,
    output reg write_o,
    output reg [24:0] address_o,
    output reg [127:0] data_o,
    output wire [2:0] view_slot_o,
    output wire [31:0] view_source_o,
    output wire view_valid_o,
    output wire [2:0] evidence_valid_o,
    output wire live_valid_o,
    output wire [2:0] live_slot_o,
    output wire [31:0] live_source_o,
    output wire [6:0] pinned_o,
    output wire [26:0] geometry_o,
    output wire fault_o
);
```

## 时钟与复位

相机/DDR双域；复位共同断言。

## 周期行为

有限240字写所有权，强制让出仲裁；全局发出/控制器接受计数作为帧尾栅栏；分别接收完整性和判定。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

随机pAXI停顿、720p全帧哈希/逐字检查、钉满后连续输入、模式关闭仍实时。

## 时序说明

下图为概念性时序示意，各模块具体周期以上文为准；不是实测波形。

```json
{
  "signal": [
    {
      "name": "clk",
      "wave": "p......."
    },
    {
      "name": "source_frame",
      "wave": "x3...4..",
      "data": [
        "N",
        "N+1"
      ]
    },
    {
      "name": "request",
      "wave": "010....."
    },
    {
      "name": "complete",
      "wave": "0...10.."
    },
    {
      "name": "evidence_valid",
      "wave": "0....1.."
    }
  ]
}
```
