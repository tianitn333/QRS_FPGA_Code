# motion_frame_store_ctrl 模块规格

RTL位于同目录motion_frame_store_ctrl.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_frame_store_ctrl (
    input wire clk,
    input wire rst_n,
    input wire [31:0] race_i,
    input wire clear_i,
    input wire cancel_analysis_i,
    input wire [6:0] read_protect_i,
    input wire allocate_i,
    input wire [31:0] allocate_source_i,
    input wire [31:0] allocate_race_i,
    input wire allocate_track_i,
    output wire allocate_ready_o,
    output wire [2:0] allocate_slot_o,
    input wire queued_i,
    input wire [2:0] queued_slot_i,
    input wire queued_good_i,
    input wire [31:0] queued_fence_i,
    input wire [31:0] committed_i,
    input wire validate_i,
    input wire [31:0] validate_source_i,
    input wire validate_good_i,
    output wire validate_ready_o,
    input wire decision_i,
    input wire [31:0] decision_source_i,
    input wire [31:0] decision_race_i,
    input wire [2:0] decision_mask_i,
    input wire decision_good_i,
    output wire decision_ready_o,
    input wire [1:0] view_lane_i,
    output wire [2:0] view_slot_o,
    output wire [31:0] view_source_o,
    output wire view_valid_o,
    output wire [2:0] evidence_valid_o,
    output wire [6:0] pinned_o,
    output wire live_valid_o,
    output wire [2:0] live_slot_o,
    output wire [31:0] live_source_o,
    output wire missing_o
);
```

## 时钟与复位

DDR用户时钟，异步低有效复位。

## 周期行为

分配排除写、读、待确认、待判定与证据引用；源完整验证与控制器接受栅栏满足后发布，再按道首次引用。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

同帧三道共享、连续三帧、先事件后写完、先写完后事件、槽耗尽、清局仍读保护。

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
