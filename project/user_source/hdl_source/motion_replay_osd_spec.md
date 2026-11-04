# motion_replay_osd 模块规格

RTL位于同目录motion_replay_osd.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_replay_osd (
    input wire clk,rst_n,de_i,vs_i,
    input wire mode_i,no_evidence_i,fault_i,
    input wire [63:0] applied_i,
    output wire hit_o,
    output wire [23:0] color_o
);
```

## 时钟与复位

显示像素时钟，异步低有效复位。

## 周期行为

首个有效像素锁存已应用的DDR源帧元数据；显示REPLAY、道次、十六进制源帧号和操作提示。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

帧中元数据变化不得改变当前帧标签；无证据可见提示。

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
