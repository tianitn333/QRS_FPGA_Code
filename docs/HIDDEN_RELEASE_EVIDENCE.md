# 显示变体：差异与验证范围

发布的 `program/motion_can_hidden_20261104_5a5d32b2.bit` 是在一次完整源码构建得到的 Routed DB 上，只修改一个显示窗口选择 LUT 的显示变体：黄色 C0～C3 探针行不再显示，内部探针寄存器、CAN 与 ERR 显示、20ms 命令间隔、复位/时钟/引脚/时序约束、颜色易失编辑、FILL、比赛与回放逻辑均保持不变。

## 修改范围

- 实例：`u_hdmi_tx/I_video_in_data[22]_syn_1443`，物理位置 x19/y33/offset3。
- LUT5A 从 `01100000` 改为 `00000000`；LUT5B 原本为 0。
- 窗口选择恒 0，等效于关闭黄色探针显示区域。
- 不重新综合、布局或布线。生产 RTL、AL、SDC 原字节不改；这是已通过完整源码构建的物理设计上的显示变体，不是一次新的完整源码构建。

TD 原生命令：

```
set_inst_attr -model_name {design_top_wrapper} -inst {u_hdmi_tx/I_video_in_data[22]_syn_1443} -attr_key LUT5A -attr_value {=0}
```

该实例名只对应本包 `database/original.db` 这一冻结 DB，不能机械套用到重新构建的设计。直接用源码 AL 重新构建会恢复黄色显示。

## 验证范围

| 项目 | 结论 |
| --- | --- |
| 显示行为 | ModelSim 原生退出 0，两帧共 1843200 像素；黄字移除、CAN 绿字保留、探针捕获继续 |
| 网表等价 | 完整物理网表仅目标 LUT 公式/INIT 与导出时间变化，其余单元与连接逐字节相同 |
| 放置/连接 | 全量 CSV、nets、BID 前后相同 |
| 布线 | 49353 条物理网络的属性与详细路由完全相同，含 1796 条 CAN 核网络与 149 条探针网络 |
| 时序 | 独立 STA 92 组：Setup +0.106ns / Hold +0.020ns，TNS 与违例 0 |
| bit 配置 | 新旧正文同为 1789136 字节，仅 22 字节 / 88 位不同 |
| 实板 | 隐藏显示版 bit 尚未做自动烧录或实板验收 |

资源与原探针版相同：Slice 18665/21216、LUT6 18118、ERAM 103/108、DSP 23/40、PLB 2645/2652。由于完整探针保留，本变体不声称节省探针资源。

bit 文件虽有 ASCII 头，正文为二进制，必须按二进制处理。头部 Global CRC 变化、Transfer CRC 保持，正文包含 TD 生成的相关校验数据；未独立反向解析全部校验字段，因此不能表述为“整个 bit 只改变了两个 bit”。单 LUT 修改与布线保持的结论来自独立的全网表/放置/路由比较，不依赖校验字段布局。

## 原始日志

两份工具原生输出以压缩归档保留，未随包分发未压缩副本：

| 归档 | 内容 |
| --- | --- |
| `verification/routes/native.log.zip` | TD `report_nets -dr -mode final` 对原版与隐藏版 DB 的完整布线转储 |
| `verification/timing/baseline_summary.timing.zip` | `report_timing_summary` 基线 STA 报告 |

解压 `native.log` 后取 `ROUTE_DUMP_ORIGINAL_BEGIN..END` 与 `ROUTE_DUMP_HIDDEN_BEGIN..END` 之间的正文，把 CRLF 归一为 LF，两段各为 91582348 字节、2105161 行，SHA256 均为 `4419ef35f3d74fe45c5f0af75bf3439135007f99b344e06ed5c93872b62e240c`。归档中的用户名、主机名与工作目录已替换为中性值，报告正文未改动。

## 使用

按 `START_AND_KEYS.md` 及 `PROBE_FIELDS_REFERENCE.md` 操作。`motion_can_probe_20261104_a820495a.bit` 保留，用于恢复可见诊断行。当前版本没有新增按键切换，不改变 K2 的比赛/回放含义。
