# 2026-10-20 当前接口（覆盖以下历史说明）

新增detection_o输出：与valid_o/x_o/y_o/edge_o同拍的窗口中心高阈值Sobel标志。开启方向一致性时跟随原有两级流水；旧模式一拍输出。共同三像素无效边界，不改变edge_o或行存储。

# edge_refine 模块规格（2026-10-18）

## 接口

75MHz单像素/拍、低有效异步控制复位、无反压。输入valid/user/last、gradient_i[12:0]、fine_i[1:0]、新增polarity_i；输出valid_o、edge_o、x_o/y_o[11:0]。gradient打包strong、weak、direction[1:0]、magnitude[10:2]，fine为幅值低2位。

FULL_PRECISION默认1，0兼容原量化排序。COHERENCE_ENABLE默认0兼容四强邻点模式；工程为1。关闭方向筛选时忽略未接polarity_i；启用时必须连接Sobel同拍的gradient_polarity_o。

## 算法

三行缓存的幅值为9bit ERAM；metadata/fine/polarity共7bit分布式RAM。窗口word为{polarity,strong,weak,direction2,magnitude11}。

四方向NMS严格大于负向邻点、且大于等于正向邻点。中心须达到低阈值。方向结合极性转换八分区：0°/45°/90°/135°/180°/225°/270°/315°。邻点仅在模8差为0、1、7时一致；强点同时属于弱点。

八邻点支持条件：一致强点>=5，或一致强点>=4且一致弱点>=6。这是局部筛选，不是递归滞后连接，不是完整连通域长度剔除。单像素逐行线段仍由下游保留。

## 延迟与边界

启用方向筛选相对原细化增加2拍：先登记一致性标志和中心NMS结果，再登记分组计数，最后比较输出；坐标/valid同步延迟。window_x/y>=6时有效，中心输出window_x/y-3；最终mixer将不完整三像素边界补黑。模式在帧首切换，RGB/灰度及所有HDMI标志补偿同样两拍。

## 验证

448个方向/极性/邻域支持组合；32帧独立精确空间oracle，4帧720p；四档弱光/亮光阶跃各四方向、平坦±2噪声；点/段/帧ID和统计与逐像素结果对照。完整原生回归、TD最终时序、通用风格和实板画质分开记录。

## 时序说明

以下为寄存级示意；逐拍自检与原生时序报告分别验证功能和物理实现。
```json
{"signal":[{"name":"clk","wave":"p......."},{"name":"input_valid","wave":"010....."},{"name":"stage1","wave":"0010...."},{"name":"stage2","wave":"00010..."},{"name":"stage3","wave":"000010.."}]}
```


当前切换示意（不含视频长延迟；逐拍日志为数值依据）：
```json
{"signal": [{"name": "clk", "wave": "p......."}, {"name": "key_event", "wave": "010....."}, {"name": "frame_start", "wave": "0..10..."}, {"name": "requested_extract", "wave": "0.1....."}, {"name": "effective_extract", "wave": "0...1..."}]}
```
