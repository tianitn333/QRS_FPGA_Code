`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: SC500GainTbl
//
// 模拟增益映射表：index I (0..127) -> 寄存器值 {16'h3e08, 16'h3e09}
//
// 取值依据 SC500CS 数据手册 V1.8 表 2-4（模拟 gain 值控制寄存器）：
//     3e08 = {0x03, 0x07, 0x0F, 0x1F}  -> coarse 1x / 2x / 4x / 8x
//     3e09 = 0x20 + n (n=0..31)        -> fine = 1 + n/32
//   增益 = coarse * (1 + n/32)，覆盖 1.000x ~ 15.750x（共 128 档）
//
// 说明：原工程版本只列到 I=73（约 5.125x），本版按手册公式补齐到 I=127
//       （15.750x）。统一使用直接索引 I = I_ag（0..127），禁止额外偏移；
//       I=64 仍对应 0x0F20（4x），与原配置完全一致，向后兼容。
//////////////////////////////////////////////////////////////////////////////////
module SC500GainTbl(
	input 			I_clk,
	input 			I_rstn,
	input 	[6:0] 	I,
	output reg	[15:0] 	O
);

	// coarse 段选择：I[6:5] -> 3e08
	reg [7:0] S_ana;
	always @(*) begin
		case (I[6:5])
			2'd0:    S_ana = 8'h03;   // 1x
			2'd1:    S_ana = 8'h07;   // 2x
			2'd2:    S_ana = 8'h0f;   // 4x
			default: S_ana = 8'h1f;   // 8x
		endcase
	end

	wire [7:0] S_fine = 8'h20 + {3'd0, I[4:0]};   // 0x20..0x3F

	always @(posedge I_clk) begin
		if (!I_rstn)
			O <= 16'h0320;                        // 1.000x（上电安全值）
		else
			O <= {S_ana, S_fine};
	end

endmodule
