# motion_finish_trial 模块规格

RTL位于同目录motion_finish_trial.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_finish_trial #(
 parameter integer IMAGE_WIDTH=1280, IMAGE_HEIGHT=720,
 parameter integer SETTLE_FRAMES=2, LEARN_FRAMES=16, CHECK_FRAMES=4, EXTERNAL_SOURCE_ID=0
)(
 input wire clk,rst_n,
 input wire valid_i,user_i, input wire [95:0] rgb_i,
 input wire [63:0] config_i,
 input wire hold_ack_i,
 output wire hold_o,
 output wire [191:0] status_o,
 input wire [31:0] source_i,
 output wire [31:0] race_o,
 output wire active_o,
 output wire [26:0] geometry_o,
 output reg decision_o,
 output reg [31:0] decision_source_o,decision_race_o,
 output reg [2:0] decision_mask_o,
 output reg decision_good_o
);
```

## 时钟与复位

相机时钟；支持外部共同源帧身份，旧测试默认内部计数。

## 周期行为

保留2bae判定；新增逐帧decision输出、race序号和本局几何；主动停止忙时必须释放未完成分析。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

原5组641完整帧回归、同帧并列、触线停车、短间隔、底部ROI跨SOF、忙时停止。

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


## 可选唯一排名（2026-11-04）
新增UNIQUE_RANK_ENABLE，默认0保持本文件历史同帧并列。本版本顶层显式设1：W_COMMIT对同一已验证源帧的首次到达按L1/L2/L3顺序分配不同名次；已到达车道不参与本次增量。只改变名次，不改变arrival_frame/sourceID、mask、完整帧提交、首次触线或几何方向。新增全分辨率tb_motion_unique回归覆盖三道同帧1/2/3。
