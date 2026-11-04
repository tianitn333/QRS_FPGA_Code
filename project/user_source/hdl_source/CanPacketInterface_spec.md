# CanPacketInterface

75MHz单域、低有效复位；接口输入的RXD已同步。完整OpenCores CAN经典扩展帧核，500kbit/s（BRP4/BTR1=2A）。payload从63:56开始，DLC外补0。tx_valid保持到tx_ready，握手后payload/ID不再依赖上游。

状态寄存器/组合下一状态/数据处理三过程。Wishbone访问最多256拍，ACK后撤销11拍；初始化后轮询RX优先、TX空闲时接帧。tx_done要求实际TCS，不能解释成电机到位。发送超时或bus-off先请求abort再锁存fault，WB超时锁存fault；均需外部复位解除，不静默重试应用层动作。RX头、ID、8字节依次捕获，DLC外忽略，释放FIFO后上报。标准帧/远程帧/非法DLC消费但不上报。

边界：o_rx_valid是单拍且上游须随时接收；经典帧不超过8字节，不使用CAN FD。上电逻辑空闲TX为1。总线故障中止不保证外部机械停机，协议/物理/机械验收分开。

验证：双真实CAN核进行ID100/101/200/201、高位ID、DLC0/3/5/8、反向接收、连续报文、无ACK超时；输入源哈希检查。另有上层协议测试，不把理想wired-AND模型当电气互通。

WaveJSON：`{"signal":[{"name":"clk","wave":"p........."},{"name":"tx_valid","wave":"01..0....."},{"name":"tx_ready","wave":"0..10....."},{"name":"tx_done","wave":"0.......10"},{"name":"rx_valid","wave":"0........."}]}`。握手到完成取决于总线仲裁，图仅示意。
