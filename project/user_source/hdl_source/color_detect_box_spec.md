# color_detect_box 三色检测接口契约

## 端口

| 端口 | 方向/位宽 | 语义 |
|---|---|---|
| clk / rst_n | 输入1 / 输入1 | 像素时钟 / 异步低有效复位 |
| valid_i / user_i / last_i | 各输入1 | 像素有效 / 首像素帧首 / 末像素行末 |
| rgb_i | 输入24 | R[23:16] G[15:8] B[7:0] |
| o_r_valid / o_g_valid / o_b_valid | 各输出1 | 前一完整帧合格采样面积达标 |
| o_r_area / o_g_area / o_b_area | 各输出32 | 合格行累计的采样点数 |
| o_r_xmin/xmax/ymin/ymax | 各输出12 | 红色采样点边界（含端点） |
| o_g_xmin/xmax/ymin/ymax | 各输出12 | 绿色采样点边界（含端点） |
| o_b_xmin/xmax/ymin/ymax | 各输出12 | 蓝色采样点边界（含端点） |

## 参数与空间确认

保留原红绿模块默认值，工程实例通过hdmi_mixer覆盖绿色shift=3、diff=12、红/绿行门槛6/4及面积32。
新增 B_R_RATIO_Q2=6、B_G_RATIO_Q2=7（范围4..15）、MIN_DIFF_B=20、MIN_ROW_CNT_B=4、MIN_ROW_RUN_B=2。
蓝色条件为4B>6R、4B>7G、B-max(R,G)>=20，并通过共享亮度44和饱和度18门槛。
蓝色乘积12位、差值比较9位，无像素除法，无行缓存。
STAT_DECIM在工程中固定4，MIN_RUN只支持现有三点确认；绿色/蓝色行历史支持1..3行，工程选择2。
行末清除水平历史，帧首清除连续行历史；最后一行在封存时合并，不丢底边。
蓝色使用独立寄存器，和红绿共享坐标、降采样使能；首个达标帧之后立即发布。

## 时钟与结果时序

单像素RGB888、同一像素时钟域，异步低有效复位；不反压。
所有颜色的前景判据与坐标打一拍；帧首封存上一帧统计。
已发布的有效位、面积及边界在帧内稳定，下一帧无目标时有效位置零。
有效位为零时边界寄存器内容不代表目标；多个同色区域合并为同一框。

```json
{"signal":[{"name":"clk","wave":"p....."},{"name":"frame_start","wave":"010..."},{"name":"snapshot_rgb","wave":"x.=...","data":["frame N-1"]},{"name":"osd_center","wave":"x..=..","data":["frame N-1"]},{"name":"osd_chars","wave":"x...=.","data":["frame N-1"]}]}
```

原始WaveJSON给出时序契约；功能验证与物理实现验证分别记录。

## 验证边界

阈值测试、720p四边四相位、空场/干扰/消失重现、照片参考模型及三色OSD均独立自检。
不含连通域、跟踪、目标保留、自动曝光修复；典型蓝/暗蓝为目标，真实蓝色实拍验收待执行。

## Background and edge implementation contract (2026-10-17)

Added optional EXTENDED_BLUE light/cyanblue branch and USE_BLUE_GATE. Legacy defaults preserve old arithmetic. Engineering settings dark4B>6R,4B>5G,B-max(R,G)>=12; light4B>5R,4G>5R,min(B,G)-R>=20,abs(B-G)<=max(B,G)/4; common luma44 saturation18. Pixel gate applies only to blue before spatial qualification. Independent RGB global boxes, area and coordinates published together at SOF; no extra frame confirmation.

Verification: native ModelSim results and final TD implementation evidence are recorded separately. Missing board evidence is not a pass.

Timing scenario (illustrative register-stage contract; numerical tests are authoritative):
```json
{"signal":[{"name":"clk","wave":"p......"},{"name":"rst_n","wave":"01....."},{"name":"input_valid","wave":"0010000"},{"name":"output_valid","wave":"0000100"}]}
```
