# motion_trial_osd 模块规格

RTL位于同目录motion_trial_osd.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_trial_osd (
 input wire clk,rst_n,de_i,vs_i,
 input wire enable_i,input wire [1:0] edit_i,
 input wire [10:0] base_x_i,input wire [9:0] base_y_i,input wire [5:0] line_i,
 input wire [191:0] status_i,
 output wire hit_o,output wire [23:0] color_o
);
```

## 时钟与复位

显示像素时钟。

## 周期行为

原三道卡片不变，首个有效像素锁存几何和状态以等待回放读切换元数据。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

原图/运动/回放坐标与帧边界稳定。

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


## CAN状态显示（2026-11-04）
新增motor_i[7:0]={state,error}，每帧首像素捕获。右上x832..1215/y32..63显示CAN状态及ERR数字，复用已有字体，无新ERAM、无额外视频拍延迟；不覆盖Logo或ROI。state0关/1待人工参考/2初始化/3可比赛/4展示/5归位或停止/6故障；error0无/1应答超时/2拒绝/3CAN故障/4电机状态/5初始位置未清零/6运动到位超时。状态未知的未连接旧测试不显示新行。新增tb_motor_status_osd验证绿色READY及帧稳定。
