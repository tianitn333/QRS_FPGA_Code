// ============================================================================
// spi_flash_probe —— 只读 Flash 识别（JEDEC ID / 状态寄存器 / 空片采样）
//
// 依据：docs/handoff_color_ui_20261021/EXECUTION_CONSTRAINTS.md §9.2
//
// 本模块**结构上没有写路径**：全部指令只有三条只读命令
//   0x9F  JEDEC ID（3 字节）
//   0x05  Read Status Register（1 字节）
//   0x03  Read Data（4 字节地址 + 1 字节数据，采样 16 个点）
// 不存在 WREN(0x06)/PP(0x02)/SE(0x20)/BE(0xD8)/CE(0xC7) 任何分支，
// 因此即使状态机跑飞也不会发出写使能或擦除。
//
// 空片采样：16 个点按 16MB 均分（每点间隔 1MB），每点读 1 字节。
//   blank_map[i]=1 表示该点为 0xFF（空），=0 表示读到程序数据。
//   该图只作为"哪段可能有内容"的初判，不能替代分区表。
//
// 时序：24MHz 时钟域 + 分频产生 SCLK（默认 1MHz，模式 0）：
//   CS 拉低后发命令；MOSI 在 SCLK 下降沿更新，MISO 在上升沿采样。
//   WP#/HOLD# 全程驱动为高（只读也不需要保护动作）。
// ============================================================================

module spi_flash_probe #(
    parameter integer CLK_HZ  = 24000000,
    parameter integer SCLK_HZ = 1000000
)(
    input  wire        clk,          // 24MHz
    input  wire        rst_n,

    input  wire        start,        // 单拍启动一次探测
    input  wire        miso,

    output reg         cs_n,
    output reg         sclk,
    output reg         mosi,
    output reg         wp_n,
    output reg         hold_n,

    output reg  [23:0] id_o,         // JEDEC ID
    output reg  [7:0]  sr_o,         // 状态寄存器
    output reg  [15:0] blank_map,    // 16 点空片图（1=0xFF）
    output reg  [4:0]  step_o,       // 当前步骤（调试）
    output reg         busy_o,
    output reg         done_o        // 单拍完成脉冲
);

    // 半周期 = CLK_HZ/(SCLK_HZ*2)
    localparam integer HALF = (CLK_HZ / (SCLK_HZ * 2));

    localparam [4:0] ST_IDLE  = 5'd0;
    localparam [4:0] ST_CMD   = 5'd1;   // 发 1 字节命令
    localparam [4:0] ST_ADDR  = 5'd2;   // 发 3 字节地址（仅 0x03）
    localparam [4:0] ST_READ  = 5'd3;   // 收 N 字节
    localparam [4:0] ST_GAP   = 5'd4;   // CS 建立间隔
    localparam [4:0] ST_GAP2  = 5'd5;   // 本步结束：CS 拉高
    localparam [4:0] ST_CSHI  = 5'd6;   // 步间保持 CS 高，让从机复位状态机

    // 步骤表：0=ID, 1=SR, 2..17=采样点
    localparam [4:0] STEP_ID   = 5'd0;
    localparam [4:0] STEP_SR   = 5'd1;
    localparam [4:0] STEP_LAST = 5'd17;

    reg [4:0]  S_step;
    reg [4:0]  S_state;
    reg [11:0] S_half;       // 半周期计数
    reg [2:0]  S_bit;        // 位计数 0..7
    reg [1:0]  S_byte;       // 当前字节序号
    reg [7:0]  S_shout;      // 发送移位
    reg [7:0]  S_shin;       // 接收移位
    reg [23:0] S_addr;       // 采样地址
    reg [1:0]  S_rdleft;     // 还需接收的字节

    wire [7:0] S_cmd  = (S_step == STEP_ID) ? 8'h9f :
                        (S_step == STEP_SR) ? 8'h05 : 8'h03;

    wire [1:0] S_dst = (S_step == STEP_ID) ? 2'd0 :
                       (S_step == STEP_SR) ? 2'd1 : 2'd2;

    // 采样地址 = (step-2) * 1MB（最多 15MB，落在 24 位内）
    wire [23:0] S_scan_addr = (S_step - 5'd2) * 24'd1048576;

    // 一个 SCLK 半周期的节拍
    wire S_tick = (S_half == (HALF - 1));

    // MOSI 送出的当前位
    wire S_bit_out = S_shout[7];

    // 接收：在 SCLK 上升沿采样
    wire S_bit_in  = miso;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cs_n      <= 1'b1;
            sclk      <= 1'b0;
            mosi      <= 1'b0;
            wp_n      <= 1'b1;
            hold_n    <= 1'b1;
            id_o      <= 24'd0;
            sr_o      <= 8'd0;
            blank_map <= 16'd0;
            S_step    <= 5'd0;
            S_state   <= ST_IDLE;
            S_half    <= 12'd0;
            S_bit     <= 3'd0;
            S_byte    <= 2'd0;
            S_shout   <= 8'd0;
            S_shin    <= 8'd0;
            S_addr    <= 24'd0;
            S_rdleft  <= 2'd0;
            step_o    <= 5'd0;
            busy_o    <= 1'b0;
            done_o    <= 1'b0;
        end
        else begin
            done_o <= 1'b0;

            case (S_state)
                ST_IDLE: begin
                    cs_n    <= 1'b1;
                    sclk    <= 1'b0;
                    mosi    <= 1'b0;
                    busy_o  <= 1'b0;
                    if (start) begin
                        S_step  <= 5'd0;
                        step_o  <= 5'd0;
                        S_half  <= 12'd0;
                        S_bit   <= 3'd0;
                        S_byte  <= 2'd0;
                        S_shin  <= 8'd0;
                        S_shout <= S_cmd;
                        S_addr  <= 24'd0;
                        S_rdleft<= 2'd0;
                        cs_n    <= 1'b0;
                        busy_o  <= 1'b1;
                        S_state <= ST_GAP;   // 先等 CS 建立
                    end
                end

                ST_GAP: begin
                    // CS 建立/保持间隔：1 个半周期
                    if (S_tick) begin
                        S_half  <= 12'd0;
                        S_bit   <= 3'd0;
                        S_shout <= S_cmd;
                        mosi    <= S_cmd[7];
                        if (S_step == STEP_ID || S_step == STEP_SR) begin
                            S_state <= ST_CMD;
                            S_rdleft <= (S_step == STEP_ID) ? 2'd3 : 2'd1;
                        end
                        else begin
                            S_state <= ST_CMD;
                            S_addr  <= S_scan_addr;
                            S_rdleft <= 2'd1;
                        end
                    end
                    else
                        S_half <= S_half + 12'd1;
                end

                ST_CMD: begin
                    if (S_tick) begin
                        S_half <= 12'd0;
                        sclk   <= ~sclk;
                        if (sclk == 1'b0) begin
                            // 上升沿：采样（命令阶段忽略）
                        end
                        else begin
                            // 下降沿：推一位
                            S_shout <= {S_shout[6:0], 1'b0};
                            mosi    <= S_shout[6];
                            if (S_bit == 3'd7) begin
                                // 命令字节发完
                                if (S_step == STEP_ID || S_step == STEP_SR) begin
                                    S_bit   <= 3'd0;
                                    S_byte  <= 2'd0;
                                    S_state <= ST_READ;
                                end
                                else begin
                                    S_bit   <= 3'd0;
                                    S_byte  <= 2'd0;
                                    S_shout <= S_addr[23:16];
                                    mosi    <= S_addr[23];
                                    S_state <= ST_ADDR;
                                end
                            end
                            else
                                S_bit <= S_bit + 3'd1;
                        end
                    end
                    else
                        S_half <= S_half + 12'd1;
                end

                ST_ADDR: begin
                    if (S_tick) begin
                        S_half <= 12'd0;
                        sclk   <= ~sclk;
                        if (sclk == 1'b0) begin
                            // 上升沿：采样（地址阶段忽略）
                        end
                        else begin
                            S_shout <= {S_shout[6:0], 1'b0};
                            mosi    <= S_shout[6];
                            if (S_bit == 3'd7) begin
                                S_bit  <= 3'd0;
                                if (S_byte == 2'd2) begin
                                    S_byte  <= 2'd0;
                                    S_state <= ST_READ;
                                end
                                else begin
                                    S_byte <= S_byte + 2'd1;
                                    case (S_byte)
                                        2'd0: begin S_shout <= S_addr[15:8];  mosi <= S_addr[15]; end
                                        2'd1: begin S_shout <= S_addr[7:0];   mosi <= S_addr[7];  end
                                        default: ;
                                    endcase
                                end
                            end
                            else
                                S_bit <= S_bit + 3'd1;
                        end
                    end
                    else
                        S_half <= S_half + 12'd1;
                end

                ST_READ: begin
                    if (S_tick) begin
                        S_half <= 12'd0;
                        sclk   <= ~sclk;
                        if (sclk == 1'b0) begin
                            // 上升沿：采样一位
                            S_shin <= {S_shin[6:0], S_bit_in};
                            if (S_bit == 3'd7) begin
                                S_bit <= 3'd0;
                                // 本字节收完：{S_shin[6:0], S_bit_in}
                                case (S_dst)
                                    2'd0: begin
                                        case (S_byte)
                                            2'd0: id_o[23:16] <= {S_shin[6:0], S_bit_in};
                                            2'd1: id_o[15:8]  <= {S_shin[6:0], S_bit_in};
                                            default: id_o[7:0] <= {S_shin[6:0], S_bit_in};
                                        endcase
                                    end
                                    2'd1: sr_o <= {S_shin[6:0], S_bit_in};
                                    default: blank_map[S_step - 5'd2] <= ({S_shin[6:0], S_bit_in} == 8'hff);
                                endcase
                                if (S_byte == (S_rdleft - 2'd1)) begin
                                    S_byte  <= 2'd0;
                                    S_state <= ST_GAP2;
                                end
                                else
                                    S_byte <= S_byte + 2'd1;
                            end
                            else
                                S_bit <= S_bit + 3'd1;
                        end
                        else begin
                            S_shout <= {S_shout[6:0], 1'b0};
                            mosi    <= S_shout[6];
                        end
                    end
                    else
                        S_half <= S_half + 12'd1;
                end

                ST_GAP2: begin
                    // 本步结束：拉高 CS，决定下一步
                    if (S_tick) begin
                        S_half <= 12'd0;
                        cs_n   <= 1'b1;
                        sclk   <= 1'b0;
                        mosi   <= 1'b0;
                        if (S_step == STEP_LAST) begin
                            busy_o  <= 1'b0;
                            done_o  <= 1'b1;
                            S_state <= ST_IDLE;
                        end
                        else begin
                            S_step <= S_step + 5'd1;
                            step_o <= S_step + 5'd1;
                            S_state <= ST_CSHI;
                        end
                    end
                    else
                        S_half <= S_half + 12'd1;
                end

                ST_CSHI: begin
                    // 步间 CS 保持高 1 个半周期，确保从机把上一次事务结束掉
                    if (S_tick) begin
                        S_half <= 12'd0;
                        S_bit  <= 3'd0;
                        S_byte <= 2'd0;
                        S_shin <= 8'd0;
                        cs_n   <= 1'b0;
                        S_state <= ST_GAP;
                    end
                    else
                        S_half <= S_half + 12'd1;
                end
                default: S_state <= ST_IDLE;
            endcase
        end
    end

endmodule
