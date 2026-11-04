# motion_frame_capture 模块规格

RTL位于同目录motion_frame_capture.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_frame_capture #(
    parameter integer IMAGE_WIDTH=1280, IMAGE_HEIGHT=720
)(
    input wire camera_clk, camera_rst_n, ddr_clk, ddr_rst_n,
    input wire user_i, valid_i,
    input wire [95:0] rgb_i,
    input wire [31:0] source_i, race_i,
    input wire track_i,
    input wire pixel_read_i,
    output wire [127:0] pixel_data_o,
    output wire [1:0] pixel_tag_o,
    output wire pixel_empty_o,
    input wire start_read_i,
    output wire [64:0] start_data_o,
    output wire start_empty_o,
    input wire end_read_i,
    output wire [32:0] end_data_o,
    output wire end_empty_o,
    output reg fault_o
);
```

## 时钟与复位

相机/DDR双域；复位共同断言。

## 周期行为

同源RGB96打包为RGB128；原厂像素FIFO与2位标签FIFO共同读写；SOF描述符配对；下一SOF验证上一帧精确长度。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

SOF首像素同拍、行间空闲、FIFO满、缺像素、多像素、尾包标签。

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
