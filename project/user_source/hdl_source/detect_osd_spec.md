# detect_osd 三色框线与中心坐标

## 完整接口

输入clk、rst_n、user_i、de_i各1位；x_i/y_i各12位。
每种颜色前缀r_/g_/b_均有valid_i(1)、area_i(32)、xmin_i/xmax_i/ymin_i/ymax_i(12)输入。
输出hit_o(1)、color_o(24)。area_i保留为接口统计值，画框由有效位及边界决定。
IMG_W=1280、IMG_H=720、BOX_W=3、CX_BASE=96；COLOR_RED=ff0000、COLOR_GRN=00ff00、COLOR_BLU=0080ff、COLOR_LBL=ffffff、COLOR_CTR=ffd000。

## 显示与流水

三行起点为IMG_H-112、IMG_H-80、IMG_H-48，各高32像素；当前720p保证字符行32对齐。
标签x<96，三字符RED/GRN/BLU；坐标x=96..383，格式R/G/B + 四位X + x + 三位Y，前导零为空格。
中心为边界和右移一位；user_i锁存中心，次拍转换为字符。混合器user_i延迟原始帧首一拍以读取新快照。
边界运算扩展13位，框宽向内；de_i或对应valid_i为零时隐藏该色框和文字。
优先级：红框>绿框>蓝框>三色标签>三色中心。外层Logo/系统文字优先级由混合器保持。
B/L/U点阵直接复用官方osd_char_lib.v的数据，官方字库源文件未改。

## 时钟与结果时序

单像素RGB888、同一像素时钟域，异步低有效复位；不反压。
所有颜色的前景判据与坐标打一拍；帧首封存上一帧统计。
已发布的有效位、面积及边界在帧内稳定，下一帧无目标时有效位置零。
有效位为零时边界寄存器内容不代表目标；多个同色区域合并为同一框。

```json
{"signal":[{"name":"clk","wave":"p....."},{"name":"frame_start","wave":"010..."},{"name":"snapshot_rgb","wave":"x.=...","data":["frame N-1"]},{"name":"osd_center","wave":"x..=..","data":["frame N-1"]},{"name":"osd_chars","wave":"x...=.","data":["frame N-1"]}]}
```

原始WaveJSON给出时序契约；功能验证与物理实现验证分别记录。

## 验证

旧OSD测试更新布局坐标；蓝OSD测试覆盖边框、DE、三色重叠、标签、1139/39中心逐像素参考和失效隐藏。
