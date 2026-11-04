`timescale 1ns / 1ps
/*******************************MILIANKE*******************************
*Company : MiLianKe Electronic Technology Co., Ltd.
*Copyright: Copyright (c) MiLianKe
*All rights reserved.
*********************************************************************/
/*  由本工程扩展（2026-10，M3 自动曝光）：
    - 新增 16'h3e03 = 8'h0b：SC500CS 数据手册 §2.2.3 明确要求
      "将寄存器 16'h3e03 的 Bit[3:0] 设置为 4'hb" 才启用 AGC。
      原文件只写 3e08/3e09，未写 3e03，模拟增益可能并未真正生效；此处补齐（幂等）。
    - 新增数字增益 16'h3e06 / 16'h3e07（原始工程完全未使用），
      依据手册表 2-5：DIG GAIN/DIG FINE GAIN，0x0080=1.0x .. 0x0FFC=31.5x。
      REG_SIZE 由 5 增至 8。
*/

module uics500regAE
(  
input      [8 :0]  REG_INDEX,
output reg [31:0]  REG_DATA,
output     [8 :0]  REG_SIZE,
input      [15:0]  I_AE,
input      [15:0]  I_AG,
input      [15:0]  I_DG
);

assign	REG_SIZE = 9'd8;
//-----------------------------------------------------------------
/////////////////////	Config Data REG	  //////////////////////////	
always@(*)
   case(REG_INDEX)
		0:	REG_DATA = {16'h3e00, 4'h0, I_AE[15:12]}; 
		1:	REG_DATA = {16'h3e01, I_AE[11: 4]}; 
		2:	REG_DATA = {16'h3e02, I_AE[3:0], 4'h0};
		3:	REG_DATA = {16'h3e08, I_AG[15:8]};
		4:	REG_DATA = {16'h3e09, I_AG[7 :0]};
		5:	REG_DATA = {16'h3e03, 8'h0b};            // AGC 使能（手册要求）
		6:	REG_DATA = {16'h3e06, I_DG[15:8]};       // 数字增益
		7:	REG_DATA = {16'h3e07, I_DG[7 :0]};       // 数字精调增益
		default:REG_DATA    =   {16'h0000, 8'h00};
   endcase

endmodule
