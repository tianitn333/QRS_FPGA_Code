# motion_replay_ui 模块规格

RTL位于同目录motion_replay_ui.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_replay_ui (
    input wire clk, rst_n, mode_i,
    input wire [2:0] state_i, evidence_i,
    input wire short_key_i, long_key_i, previous_i, next_i,
    output reg replay_o,
    output reg [1:0] lane_o,
    output reg race_key_o,
    output reg no_evidence_o
);
```

## 时钟与复位

显示像素时钟，异步低有效复位。

## 周期行为

仅RESULTS/INVALID且有证据时长K2进入；回放短K2只退出，K3/K4循环道次；不发新局命令。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

无自动进入、无证据、活动局禁止进入、按键隔离、退出保留。

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
