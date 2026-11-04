# motion_meta_fifo 模块规格

RTL位于同目录motion_meta_fifo.v。此文不声明模块已通过测试。

## 完整接口

```verilog
module motion_meta_fifo #(
    parameter integer WIDTH = 2,
    parameter integer ADDR_WIDTH = 4
)(
    input wire wr_clk, wr_rst_n, wr_en_i,
    input wire [WIDTH-1:0] wr_data_i,
    output wire full_o,
    input wire rd_clk, rd_rst_n, rd_en_i,
    output reg [WIDTH-1:0] rd_data_o,
    output wire empty_o
);
```

## 时钟与复位

wr_clk/rd_clk；两域复位共同断言，本地同步释放。

## 周期行为

写入不满才接受；读取不空才接受，数据在接受读的时钟沿后有效。Gray指针两级同步，指针路由预算5ns。

显示源帧号与DDR槽号不同；清局不能提前释放正在读取的槽；禁止反压摄像头像素输入。预算须以整机综合和独立STA为准。

## 验证场景

满/空停顿、异步时钟、指针回绕和共同复位。

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
