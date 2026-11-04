# motion_video_out 模块规格

RTL位于同目录motion_video_out.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_video_out #(parameter integer IMAGE_WIDTH=1280,IMAGE_HEIGHT=720) (
    input wire        I_rst_n, // synchronized DDR-domain release
    input wire        I_pixel_rst_n, // synchronized display-domain release

    input wire        I_ddr_clk,
    output wire       O_video_out_rd_busy,  
    input wire        I_video_in_wr_busy,   
    input wire I_select_valid,
    input wire [2:0] I_select_slot,
    input wire [63:0] I_select_metadata,
    output wire [6:0] O_read_protect,
    output reg [63:0] O_applied_metadata,
    output wire       O_ddr_user_rd_en,
    output reg[24:0]  O_ddr_user_addr,
    input wire        I_ddr_user_ready,
    input wire        I_ddr_user_rd_valid,
    input wire[127:0] I_ddr_user_rd_data,

    input wire        I_dsi_clk,
    input wire        I_video_vsync,
    input wire        I_video_rd_en,  
    output reg[23:0]  O_vdieo_data
);
```

## 时钟与复位

DDR与显示双域；沿用原厂128位像素FIFO和RGB解包。

## 周期行为

显示帧边界抓取目标；停止旧请求、旧返回排空后提交目标/元数据并释放旧槽；每帧读数量封顶。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

延迟读返回、帧中翻页、完整720p逐像素比对、缺失证据、恢复实时。

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
