# target_line_tracker 独立模块合同

## 用途和接入边界

受控场景下，一个选定颜色只对应一个目标。输入来自完整检测快照的中心坐标和**唯一源帧号**；不能直接接显示光栅计数或两位DDR循环指针。本模块先独立仿真，不加入当前发布的TD工程。跟踪不对同色多个目标进行身份分离。

## 接口

75MHz单时钟，I_rst_n低有效异步复位，无ready；最多每拍接收一个完整观测。I_sample_valid与I_source_id_valid/I_source_id[31:0]/I_target_valid/I_x[11:0]/I_y[11:0]同拍。输出accepted/duplicate/rejected为一拍事件，状态、坐标、轨迹ID及双向计数在该接受沿后更新。

I_enable=0清除关联和过线历史、保留计数；关闭期间仍消费合法源帧号。I_clear同步清计数、跟踪及源帧历史；I_source_restart清跟踪和源帧历史但保留计数。二者优先于观测。摄像头源序列重新开始必须产生source_restart；原样重复或旧序号不推进跟踪、丢失计数或过线计数。

输出O_track_state：0未检测、1候选、2稳定跟踪、3暂时丢失。O_track_valid只在状态2有效；坐标是最近真实检测位置，没有预测。轨迹ID默认16位，确认新目标时递增并自然回绕。双向计数默认24位、达到全1饱和，不回绕；即使饱和，合法跨线事件仍输出。

## 默认决策

计数线为x=640，滞回半宽12，正向为坐标增大；AXIS_Y=1时使用y，可配LINE_POSITION=360。都是构建参数，不在帧中变化。DETECTION_CONFIRM=2、SIDE_CONFIRM=2、MAX_MISSED=3、MAX_SOURCE_GAP=4、MAX_STEP=96。

首次检测后需两个连续新源帧、中心每轴移动不超过MAX_STEP才确认轨迹。合法新源帧使用32位模差，0为重复，差值最高位1为旧/超半周期序号，拒收；首次合法源帧直接接受。帧间跳号不超过4时可保留匹配；运动窗口为MAX_STEP乘以min(4,缺失源帧数+本次序号差)。跳号超过4或位置跳变超窗，放弃旧身份，从新候选开始。

缺失目标按源序号差累计，最多保持3个缺失源帧；第4个缺失时释放轨迹。目标出现时用`missed + delta - 1`计算两次真实检测之间的缺失源帧数，超过MAX_MISSED必须重新建立候选，不能因为最近两次观测的delta较小而沿用旧身份。短暂丢失重捕获保留轨迹ID，但重新建立过线基准；不能根据遮挡或跳帧两端推断穿越。

区域划分：coordinate < line−halfwidth为负侧，coordinate > line+halfwidth为正侧，边界和中间为中性区。需要连续两个观测在同一外侧才建立/切换稳定侧；稳定侧切换产生一次对应方向事件。中性区清除正在确认的侧历史，但保留已确认稳定侧。重新捕获、间隔不为1、候选变更均清除稳定侧，避免把不可见的运动算成穿越。

## 自检

独立Python语义模型先于RTL建立。定向轨迹覆盖双向跨线、滞回边界、短暂丢失、释放重捕获、跳变、重复/旧/无效源帧、跳号、32位回绕、重启、关闭/清零及计数饱和；定种子随机序列逐事件比较全部输出。水平/垂直轴分别验证。原生ModelSim、单模块综合和质量检查分别记录；未接入整机、未上板不能标记完成。

## 完整端口合同

| 端口 | 位宽/方向 | 语义 |
|---|---|---|
| I_clk / I_rst_n | 1/输入 | 75MHz；低有效异步复位，上游保证同步释放 |
| I_sample_valid | 1/输入 | 一拍原子观测，可以连续每拍输入 |
| I_source_id_valid / I_source_id | 1、32/输入 | 源身份有效位及摄像头唯一源帧序号 |
| I_target_valid / I_x / I_y | 1、12、12/输入 | 已完成帧的目标有效和真实中心坐标 |
| I_enable | 1/输入 | 同时钟域；关闭清关联，保留坐标、轨迹编号和累计计数 |
| I_clear / I_source_restart | 1、1/输入 | 同步清零/源序列重启；clear优先于restart，均优先于观测 |
| O_sample_accepted / O_duplicate / O_rejected | 各1/输出 | 接受/重复/拒收一拍事件，三者互斥 |
| O_track_state / O_track_valid | 2、1/输出 | IDLE=0、CANDIDATE=1、TRACKED=2、LOST=3；valid仅在TRACKED为1 |
| O_track_id | TRACK_ID_WIDTH/输出 | 确认新身份递增，自然回绕；只有TRACKED/LOST时解释为有效身份 |
| O_x / O_y | 各12/输出 | 最近真实观测位置；IDLE/LOST时不可作为当前有效目标 |
| O_cross_forward / O_cross_reverse | 各1/输出 | 正侧/负侧稳定转换事件；默认分别为左向右/右向左 |
| O_count_forward / O_count_reverse | 各COUNT_WIDTH/输出 | 两个独立饱和计数，不回绕 |

异步复位清零全部寄存器；clear同样清零，restart保留轨迹序列号与累计计数但清坐标和源历史。采样无效时保持状态和数据，一拍事件归零；enable为0可在无观测时清关联。没有新源帧时不按75MHz时钟计缺失，源停流需上游监测并产生restart。

## 参数、位宽与实现

AXIS_Y为0/1；0≤HALF_WIDTH≤LINE_POSITION且LINE_POSITION+HALF_WIDTH≤4095。DETECTION_CONFIRM/SIDE_CONFIRM为2..255，MAX_MISSED为0..255，MAX_SOURCE_GAP为1..255，MAX_STEP为1..4095，COUNT_WIDTH/TRACK_ID_WIDTH为1..32。模块内仿真参数检查拒收非法组合；综合时由构建配置保证合法。

源序号差保留32位模运算，累计间隔采用33位；运动范围为9位受限间隔乘12位步长、21位无符号结果；坐标绝对差用13位。确认计数最多255，侧确认计数饱和。三进程状态机；寄存器输出与状态在同一沿更新。当前模块不使用RAM、DSP、像素缓存、CDC或运动预测。

默认独立综合约束：周期13.333ns，观测输入/输出分别2ns预算，异步复位路径排除。这是模块估算，未复用或修改正式工程SDC，不代表整机最终时序。

2026-10-18验证：17项参考断言；四配置共447242拍ModelSim全输出精确匹配；独立TD综合成功。通用严格风格检查未通过。

## 时序图

以下示意每个高电平为一个完整观测，输出是对应接受沿后的寄存结果。

```json
{"signal":[{"name":"clk","wave":"p......."},{"name":"sample_valid","wave":"01.0.1.0"},{"name":"source_id","wave":"x==..=.x","data":["10","10 repeated","11"]},{"name":"accepted","wave":"010..10."},{"name":"duplicate","wave":"0010...."}]}
```
