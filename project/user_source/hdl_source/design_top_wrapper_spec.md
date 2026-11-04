# design_top_wrapper 模块规格

RTL位于同目录design_top_wrapper.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module design_top_wrapper (
    input wire        I_sys_clk,
    input wire        I_rst_n,
      
    output wire       O_cam_scl,
    inout  wire       IO_cam_sda,
    output wire       O_cam_24m,
    output wire       O_cam_rst,
      
    inout wire [1:0]  I_button,

    // 板载按键（低有效；官方例程/文档双重确认：key[0]=D5 与 key[1]=A9 都是板载按键，
    // 见 2_Example\8_key_sw\key_sw.adc 与 2_Example\32_cs500_mipi_hdmi\pin\pin.adc）
    //   I_key[0] = D5（丝印 KEY1）：四模式 / COLOR 长按编辑；编辑短按上一项、长按隐藏
    //   I_key[1] = A9（丝印 KEY2）：EDGE 检测/提取；编辑短按下一项、长按退出
    input wire [3:0]  I_key,
    input wire        I_switch_preview, // Physical SW1/A4: down=RGB, up=HIT in editor.

    output wire O_sd_clk,O_sd_cs_n,O_sd_mosi,
    input wire I_sd_miso,

    output wire       O_screen_pwm,
    output wire       O_tmds_ch0_p,
    output wire       O_tmds_ch1_p,
    output wire       O_tmds_ch2_p,
    output wire       O_tmds_clk_p,

    inout wire        IO_rx_clk_pad_n, 
    inout wire        IO_rx_clk_pad_p, 
    inout wire[3:0]   IO_rx_data_pad_n,
    inout wire[3:0]   IO_rx_data_pad_p,

    output wire[12:0] ddr_addr,
    output wire[ 1:0] ddr_ba,
    output wire[ 0:0] ddr_cke,
    output wire[ 0:0] ddr_odt,
    output wire[ 0:0] ddr_cs_n,
    output wire       ddr_ras_n,
    output wire       ddr_cas_n,
    output wire       ddr_we_n,
    output wire[ 0:0] ddr_ck_p,
    output wire[ 0:0] ddr_ck_n,
    inout wire[1:0]   ddr_dm,
    inout wire[15:0]  ddr_dq,
    inout wire[1:0]   ddr_dqs_p,
    inout wire[1:0]   ddr_dqs_n   
);
```

## 时钟与复位

保持原物理IP、时钟和引脚；连接相机/DDR/显示域回放模块。

## 周期行为

原4槽video_in/out替换为独立七槽分支；共同源ID；帧边界手动选择；FILL继续关闭。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

模块集成、原有算法与按键隔离、完整P&R、独立CDC与STA、实板槽自检。

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


## CAN双旗帜控制（2026-11-04）
新增I_motor_arm(SW2/B4)、I_motor_reference(SW3/E11)、I_can_receive(J2-28/P8)、O_can_transmit(J2-27/P9)，均3.3V。仅新增单75MHz域CAN/Emm/双轴控制，保留图像链路/FILL/DDR源帧及回放。既有状态mailbox扩为224位({race32,status192})，原显示状态字段不变；电机只消费RESULTS完整最终包并按raceID去重。SW2开后SW3新上升沿确认人工参考，归位校验后K2比赛请求才放行；SW2关仍可图像单用。所有参数/终点/采样/证据合同不变；UNIQUE_RANK_ENABLE=1使同源帧依L1/L2/L3排序为唯一名次。协议复位由OFF状态控制，RX两级同步、开关20ms消抖，新增输出按max5ns/min0预算计时，不改时钟/DDR/ISP。完整接口要求见三个新增模块的spec。
