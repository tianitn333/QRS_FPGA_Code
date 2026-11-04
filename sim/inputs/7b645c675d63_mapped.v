// Verilog netlist created by Tang Dynasty v6.2.168116
// Tue Nov  3 15:45:58 2026

`timescale 1ns / 1ps
module anlogic_logo_palette  // ../../../user_source/hdl_source/anlogic_logo_palette.v(4)
  (
  I_addr,
  clk,
  rst_n,
  O_pixel
  );

  input [14:0] I_addr;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  input clk;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(5)
  input rst_n;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(6)
  output [24:0] O_pixel;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)

  wire [1:0] \displacement[0]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[0]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[0]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[1]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[1]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[1]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[2]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[2]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[2]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[3]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[3]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[3]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[4]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[4]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[4]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[5]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[5]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [1:0] \displacement[5]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(10)
  wire [11:0] memory_address;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[10]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[10]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[10]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[11]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[11]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[11]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[6]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[6]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[6]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[7]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[7]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[7]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[8]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[8]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[8]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[9]_syn_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[9]_syn_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [1:0] \memory_address[9]_syn_5 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  wire [143:0] memory_data;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(12)
  wire [3:0] mux0_syn_294;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_304;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_314;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_324;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_334;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_344;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_354;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_364;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_374;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_384;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_394;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_404;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_414;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_424;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_434;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_444;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_454;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_464;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_474;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_484;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_494;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_504;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_514;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [3:0] mux0_syn_524;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire [14:0] read_address;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire [1:0] read_bank;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(14)
  wire eq3113_syn_38;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire eq3113_syn_39;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire eq3113_syn_40;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire eq3113_syn_41;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire eq3113_syn_42;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire eq3113_syn_43;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire eq3113_syn_44;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire eq3113_syn_46;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(677)
  wire mux0_syn_298;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_308;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_318;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_328;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_338;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_348;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_358;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_368;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_378;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_388;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_398;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_408;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_418;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_428;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_438;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_448;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_458;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_468;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_478;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_488;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_498;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_508;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_518;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux0_syn_528;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  wire mux2_syn_27;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(680)
  wire \I_addr[14]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[13]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[12]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[11]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[10]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[9]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[8]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[7]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[6]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[5]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[4]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[3]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[2]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[1]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \I_addr[0]_dup_3 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  wire \O_pixel[24]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[23]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[23]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[22]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[22]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[21]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[21]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[20]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[20]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[20]_syn_6 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[19]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[19]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_6 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_8 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_10 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_12 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_14 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_16 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_18 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_20 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_22 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_24 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_26 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_28 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_30 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_32 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_34 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_36 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_38 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_40 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_42 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_44 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_46 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_48 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_50 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_52 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_54 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_56 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_58 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_60 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_62 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_64 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_66 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_68 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_70 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_72 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_74 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_76 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_78 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_80 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_82 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_84 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_86 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_88 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_90 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_92 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_94 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_96 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_98 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_100 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_102 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_104 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_106 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_108 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_110 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_112 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_114 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_116 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_118 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_120 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_122 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_124 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_126 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_128 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_130 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_132 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_134 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_136 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_138 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_140 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_142 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_144 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_146 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_148 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_150 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_152 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_154 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_156 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_158 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_160 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_162 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_164 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_166 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_168 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_170 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_172 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_174 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_176 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_178 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_180 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_182 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_184 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_186 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_188 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_190 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_192 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_194 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_196 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_199 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_201 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_203 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_205 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_207 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_209 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_211 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_213 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_215 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_217 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_219 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_221 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_223 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_225 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_227 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_229 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_231 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_233 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_235 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_237 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_239 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_242 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_244 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_246 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_248 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_250 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_252 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_254 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_256 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_258 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_260 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_262 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_265 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_267 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_269 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_271 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_273 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_275 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_277 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_279 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_281 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_283 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_285 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_287 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_289 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_291 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_293 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_295 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_297 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_299 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_301 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_303 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_305 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_308 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_310 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_312 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_314 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_316 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_318 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_320 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_322 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_324 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_326 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_328 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_330 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_332 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_334 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_336 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_338 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_340 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_342 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_344 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_346 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_348 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_350 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_352 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_354 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_356 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_358 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_360 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_362 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_364 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_366 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_368 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_370 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_372 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_374 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_376 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_378 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_380 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_382 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_384 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_386 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_388 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_390 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_392 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_394 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_396 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_398 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_400 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_402 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_404 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_406 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_408 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_410 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_412 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_414 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_416 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_418 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_420 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_422 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_424 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_426 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_428 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_430 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_432 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_434 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_436 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_438 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_440 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_442 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_444 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_446 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_448 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_450 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_452 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_454 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_456 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_458 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_460 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_462 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_464 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_466 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_468 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_470 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_472 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_474 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_476 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_478 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_480 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_482 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_484 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_486 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_488 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_490 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_492 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_494 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_496 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_498 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_500 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_502 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_504 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_506 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_508 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_510 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_512 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_514 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_516 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_519 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_521 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_523 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_525 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_527 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_529 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_531 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_533 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_535 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_537 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_539 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_541 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_543 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_545 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_547 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_549 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_551 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_553 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_555 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_557 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_559 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_561 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_563 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_565 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_567 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_569 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_571 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_573 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_575 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_577 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_579 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_581 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_583 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_585 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_587 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_589 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_591 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_593 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_595 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_597 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_599 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_601 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_603 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_605 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_607 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_609 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_611 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_613 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_615 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_617 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_619 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_621 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_623 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_625 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_627 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_629 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_631 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_633 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_635 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_637 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_639 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_641 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_643 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_645 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_647 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_649 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_651 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_653 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_655 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_657 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_659 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_661 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_663 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_665 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_667 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_669 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_671 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_673 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_675 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_677 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_679 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_681 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_683 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_685 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_687 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_689 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_691 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_693 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_695 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_697 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_699 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_701 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_703 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_705 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_707 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_709 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_711 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_713 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_715 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_717 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_719 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_721 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_723 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_725 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_727 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_729 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_731 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_733 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_735 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_737 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_739 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_741 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_743 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_745 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_747 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_749 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_751 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_753 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_755 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_757 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_759 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_761 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_763 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_765 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_767 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_769 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_771 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_773 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_775 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_777 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_779 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_781 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_783 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_785 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_787 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_789 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_791 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_793 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_795 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_797 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_799 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_801 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_803 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_805 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_807 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_809 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_811 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_813 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_815 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_817 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_819 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_821 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_823 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_825 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_827 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_829 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_831 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_833 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_835 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_837 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_839 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_841 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_843 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_845 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_847 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_849 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_851 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_853 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_855 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_857 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_859 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_861 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_863 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_865 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_867 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_869 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_871 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_873 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_875 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_877 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_879 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_881 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_883 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_885 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_887 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_889 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_891 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_893 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_895 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_897 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_899 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_901 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_903 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_905 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_908 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_910 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_912 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_914 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_916 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_918 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_920 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_923 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_925 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_927 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_929 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_931 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_934 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_936 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_938 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_940 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_942 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_944 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_946 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_948 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_950 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_952 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_954 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_956 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_958 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_960 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_962 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_964 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_966 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_968 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_970 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_972 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_974 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_976 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_978 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_980 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_982 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_984 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_986 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_988 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_990 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_992 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_994 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_996 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_998 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1000 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1002 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1004 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1006 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1008 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1010 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1012 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1014 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1016 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1018 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1020 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1022 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1024 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1026 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1028 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1030 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1032 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1035 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1041 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1044 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1048 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1050 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1052 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1054 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1056 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1058 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1060 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1062 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1064 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1066 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1068 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1070 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1072 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1074 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1076 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1078 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1080 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1082 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1084 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1086 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1088 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1090 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1092 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1094 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1096 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1098 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1100 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1102 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1104 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1106 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1108 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1110 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1112 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1114 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1116 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1118 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1120 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1122 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1124 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1126 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1128 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1131 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[18]_syn_1133 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[17]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[16]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[16]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[15]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[14]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[13]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[13]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[12]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[12]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[11]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[11]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[10]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[10]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[9]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[8]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[8]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[7]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[6]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[6]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[5]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[5]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[4]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[3]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[3]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[2]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[2]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[1]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[1]_syn_4 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire \O_pixel[0]_dup_1 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  wire clk_dup_1;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(5)
  wire \read_address[14]_syn_3090 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire \read_address[14]_syn_3410 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire \read_address[14]_syn_3898 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire \read_address[14]_syn_3982 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire \read_address[14]_syn_7070 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire \read_address[14]_syn_7138 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire \read_address[14]_syn_8266 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire \read_address[14]_syn_9262 ;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(15)
  wire read_valid;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(16)
  wire rst_n_dup_1;  // ../../../user_source/hdl_source/anlogic_logo_palette.v(6)

  PH1P_PHY_HD_PAD #(
    //.LOCATION("N1"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[0]_syn_4  (
    .ipad(I_addr[0]),
    .di(\I_addr[0]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("K1"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[10]_syn_4  (
    .ipad(I_addr[10]),
    .di(\I_addr[10]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("J1"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[11]_syn_4  (
    .ipad(I_addr[11]),
    .di(\I_addr[11]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("H1"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[12]_syn_4  (
    .ipad(I_addr[12]),
    .di(\I_addr[12]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("P3"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[13]_syn_4  (
    .ipad(I_addr[13]),
    .di(\I_addr[13]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("R3"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[14]_syn_4  (
    .ipad(I_addr[14]),
    .di(\I_addr[14]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("M2"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[1]_syn_4  (
    .ipad(I_addr[1]),
    .di(\I_addr[1]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("M1"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[2]_syn_4  (
    .ipad(I_addr[2]),
    .di(\I_addr[2]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("N4"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[3]_syn_4  (
    .ipad(I_addr[3]),
    .di(\I_addr[3]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("M4"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[4]_syn_4  (
    .ipad(I_addr[4]),
    .di(\I_addr[4]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("K3"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[5]_syn_4  (
    .ipad(I_addr[5]),
    .di(\I_addr[5]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("J3"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[6]_syn_4  (
    .ipad(I_addr[6]),
    .di(\I_addr[6]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("L3"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[7]_syn_4  (
    .ipad(I_addr[7]),
    .di(\I_addr[7]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("L2"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[8]_syn_4  (
    .ipad(I_addr[8]),
    .di(\I_addr[8]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HD_PAD #(
    //.LOCATION("K2"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("BYPASS"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .ODLYEN("DISABLE"),
    .TSMUX("1"))
    \I_addr[9]_syn_4  (
    .ipad(I_addr[9]),
    .di(\I_addr[9]_dup_3 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(7)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("D18"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[0]_syn_2  (
    .doq({open_n364,open_n365,open_n366,open_n367,open_n368,open_n369,open_n370,open_n371,open_n372,\O_pixel[0]_dup_1 }),
    .opad(O_pixel[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[0]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[0]),
    .c(memory_data[36]),
    .d(memory_data[72]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[0]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("U2"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[10]_syn_2  (
    .doq({open_n429,\O_pixel[10]_dup_1 }),
    .opad(O_pixel[10]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[10]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[10]),
    .c(memory_data[46]),
    .d(memory_data[82]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[10]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*A)"),
    .INIT(4'hd))
    \O_pixel[10]_syn_5  (
    .a(\O_pixel[18]_syn_1131 ),
    .b(\O_pixel[10]_syn_4 ),
    .o(\O_pixel[10]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("T2"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[11]_syn_2  (
    .doq({open_n453,\O_pixel[11]_dup_1 }),
    .opad(O_pixel[11]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[11]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[11]),
    .c(memory_data[47]),
    .d(memory_data[83]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[11]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*A)"),
    .INIT(4'hd))
    \O_pixel[11]_syn_5  (
    .a(\O_pixel[18]_syn_1131 ),
    .b(\O_pixel[11]_syn_4 ),
    .o(\O_pixel[11]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("L4"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[12]_syn_2  (
    .doq({open_n477,\O_pixel[12]_dup_1 }),
    .opad(O_pixel[12]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[12]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[12]),
    .c(memory_data[48]),
    .d(memory_data[84]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[12]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \O_pixel[12]_syn_5  (
    .a(\O_pixel[18]_syn_1128 ),
    .b(\O_pixel[12]_syn_4 ),
    .o(\O_pixel[12]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("M5"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[13]_syn_2  (
    .doq({open_n501,\O_pixel[13]_dup_1 }),
    .opad(O_pixel[13]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(~(B)*~(C)*~(D)*~(E)*~(F)+~(B)*C*~(D)*~(E)*~(F)+~(B)*~(C)*D*~(E)*~(F)+~(B)*C*D*~(E)*~(F)+~(B)*~(C)*~(D)*E*~(F)+B*~(C)*~(D)*E*~(F)+~(B)*~(C)*D*E*~(F)+B*~(C)*D*E*~(F)+~(B)*~(C)*~(D)*~(E)*F+B*~(C)*~(D)*~(E)*F+~(B)*C*~(D)*~(E)*F+B*C*~(D)*~(E)*F+~(B)*~(C)*~(D)*E*F+B*~(C)*~(D)*E*F+~(B)*C*~(D)*E*F+B*C*~(D)*E*F+~(B)*~(C)*D*E*F+B*~(C)*D*E*F+~(B)*C*D*E*F+B*C*D*E*F))"),
    .INIT(64'haaaa00aa0a0a2222))
    \O_pixel[13]_syn_3  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(memory_data[13]),
    .c(memory_data[49]),
    .d(memory_data[85]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[13]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[13]_syn_5  (
    .a(\O_pixel[20]_syn_4 ),
    .b(\O_pixel[13]_syn_4 ),
    .o(\O_pixel[13]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("P6"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[14]_syn_2  (
    .doq({open_n525,\O_pixel[14]_dup_1 }),
    .opad(O_pixel[14]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[14]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[14]),
    .c(memory_data[50]),
    .d(memory_data[86]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[14]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("R5"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[15]_syn_2  (
    .doq({open_n549,\O_pixel[15]_dup_1 }),
    .opad(O_pixel[15]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[15]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[15]),
    .c(memory_data[51]),
    .d(memory_data[87]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[15]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("T3"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[16]_syn_2  (
    .doq({open_n573,\O_pixel[16]_dup_1 }),
    .opad(O_pixel[16]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[16]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[16]),
    .c(memory_data[52]),
    .d(memory_data[88]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[16]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \O_pixel[16]_syn_5  (
    .a(\O_pixel[18]_syn_1128 ),
    .b(\O_pixel[16]_syn_4 ),
    .o(\O_pixel[16]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("T4"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[17]_syn_2  (
    .doq({open_n597,\O_pixel[17]_dup_1 }),
    .opad(O_pixel[17]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[17]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[17]),
    .c(memory_data[53]),
    .d(memory_data[89]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[17]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_1001  (
    .a(\O_pixel[18]_syn_186 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_160 ),
    .o(\O_pixel[18]_syn_1002 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(~E*D*C*B))"),
    .INIT(32'h55551555))
    \O_pixel[18]_syn_1003  (
    .a(\O_pixel[18]_syn_1002 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_132 ),
    .e(\O_pixel[18]_syn_521 ),
    .o(\O_pixel[18]_syn_1004 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_1005  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_132 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_1006 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_1007  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_242 ),
    .o(\O_pixel[18]_syn_1008 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*B*(D*~(C)*~(A)+D*C*~(A)+~(D)*C*A+D*C*A))"),
    .INIT(32'hc4800000))
    \O_pixel[18]_syn_1009  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_30 ),
    .e(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_1010 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(A*~(~C*~B))"),
    .INIT(8'ha8))
    \O_pixel[18]_syn_101  (
    .a(\O_pixel[18]_syn_72 ),
    .b(\O_pixel[18]_syn_6 ),
    .c(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_102 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(C*A))"),
    .INIT(16'h135f))
    \O_pixel[18]_syn_1011  (
    .a(\O_pixel[18]_syn_242 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_30 ),
    .d(\O_pixel[18]_syn_74 ),
    .o(\O_pixel[18]_syn_1012 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~E*~C*~(~F*B)*~(D*A))"),
    .INIT(64'h0000050f00000103))
    \O_pixel[18]_syn_1013  (
    .a(\O_pixel[18]_syn_54 ),
    .b(\O_pixel[18]_syn_134 ),
    .c(\O_pixel[18]_syn_1006 ),
    .d(\O_pixel[18]_syn_1008 ),
    .e(\O_pixel[18]_syn_1010 ),
    .f(\O_pixel[18]_syn_1012 ),
    .o(\O_pixel[18]_syn_1014 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_1015  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_186 ),
    .o(\O_pixel[18]_syn_1016 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D*C*B*A*(F@E))"),
    .INIT(64'h0000800080000000))
    \O_pixel[18]_syn_1017  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_70 ),
    .c(\O_pixel[18]_syn_78 ),
    .d(\O_pixel[18]_syn_244 ),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_1018 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_1019  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_192 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_1020 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("~(~(~C*~B)*~((E*D))*~(A)+~(~C*~B)*(E*D)*~(A)+~(~(~C*~B))*(E*D)*A+~(~C*~B)*(E*D)*A)"),
    .INIT(32'h01ababab))
    \O_pixel[18]_syn_1021  (
    .a(\O_pixel[18]_syn_1016 ),
    .b(\O_pixel[18]_syn_1018 ),
    .c(\O_pixel[18]_syn_1020 ),
    .d(\O_pixel[18]_syn_182 ),
    .e(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_1022 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \O_pixel[18]_syn_1023  (
    .a(\O_pixel[18]_syn_188 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_1024 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_1025  (
    .a(\O_pixel[18]_syn_488 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_90 ),
    .d(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_1026 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*D*C*B*~A)"),
    .INIT(64'h0000000000004000))
    \O_pixel[18]_syn_1027  (
    .a(\O_pixel[18]_syn_1000 ),
    .b(\O_pixel[18]_syn_1004 ),
    .c(\O_pixel[18]_syn_1014 ),
    .d(\O_pixel[18]_syn_1022 ),
    .e(\O_pixel[18]_syn_1024 ),
    .f(\O_pixel[18]_syn_1026 ),
    .o(\O_pixel[18]_syn_1028 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \O_pixel[18]_syn_1029  (
    .a(\O_pixel[18]_syn_875 ),
    .b(\O_pixel[18]_syn_905 ),
    .c(\O_pixel[18]_syn_942 ),
    .d(\O_pixel[18]_syn_998 ),
    .e(\O_pixel[18]_syn_1028 ),
    .o(\O_pixel[18]_syn_1030 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \O_pixel[18]_syn_103  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_104 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hff0f3355))
    \O_pixel[18]_syn_1031  (
    .a(memory_data[31]),
    .b(memory_data[67]),
    .c(memory_data[103]),
    .d(read_bank[0]),
    .e(read_bank[1]),
    .o(\O_pixel[18]_syn_1032 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1033  (
    .a(memory_data[26]),
    .b(memory_data[62]),
    .c(memory_data[98]),
    .d(read_address[2]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_40));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~B*(C@A))"),
    .INIT(8'h12))
    \O_pixel[18]_syn_1034  (
    .a(\O_pixel[18]_syn_1032 ),
    .b(eq3113_syn_40),
    .c(read_address[7]),
    .o(\O_pixel[18]_syn_1035 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1036  (
    .a(memory_data[27]),
    .b(memory_data[63]),
    .c(memory_data[99]),
    .d(read_address[3]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_41));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1037  (
    .a(memory_data[29]),
    .b(memory_data[65]),
    .c(memory_data[101]),
    .d(read_address[5]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_43));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1038  (
    .a(memory_data[30]),
    .b(memory_data[66]),
    .c(memory_data[102]),
    .d(read_address[6]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_44));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1039  (
    .a(memory_data[32]),
    .b(memory_data[68]),
    .c(memory_data[104]),
    .d(read_address[8]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_46));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_1040  (
    .a(eq3113_syn_41),
    .b(eq3113_syn_43),
    .c(eq3113_syn_44),
    .d(eq3113_syn_46),
    .o(\O_pixel[18]_syn_1041 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1042  (
    .a(memory_data[24]),
    .b(memory_data[60]),
    .c(memory_data[96]),
    .d(read_address[0]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_38));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000550050504444))
    \O_pixel[18]_syn_1043  (
    .a(eq3113_syn_38),
    .b(memory_data[33]),
    .c(memory_data[69]),
    .d(memory_data[105]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[18]_syn_1044 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1045  (
    .a(memory_data[25]),
    .b(memory_data[61]),
    .c(memory_data[97]),
    .d(read_address[1]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_39));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D@(A*~(B)*~(C)*~(E)*~(F)+A*B*~(C)*~(E)*~(F)+A*~(B)*C*~(E)*~(F)+A*B*C*~(E)*~(F)+~(A)*B*~(C)*E*~(F)+A*B*~(C)*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+~(A)*~(B)*C*~(E)*F+A*~(B)*C*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F))"),
    .INIT(64'hff000ff033cc55aa))
    \O_pixel[18]_syn_1046  (
    .a(memory_data[28]),
    .b(memory_data[64]),
    .c(memory_data[100]),
    .d(read_address[4]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(eq3113_syn_42));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*C*B*A)"),
    .INIT(32'h00000080))
    \O_pixel[18]_syn_1047  (
    .a(\O_pixel[18]_syn_1035 ),
    .b(\O_pixel[18]_syn_1041 ),
    .c(\O_pixel[18]_syn_1044 ),
    .d(eq3113_syn_39),
    .e(eq3113_syn_42),
    .o(\O_pixel[18]_syn_1048 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_1049  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(read_valid),
    .o(\O_pixel[18]_syn_1050 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_105  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_4 ),
    .o(\O_pixel[18]_syn_106 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_1051  (
    .a(\O_pixel[18]_syn_20 ),
    .b(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_1052 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(C*~(~D*B*A))"),
    .INIT(16'hf070))
    \O_pixel[18]_syn_1053  (
    .a(\O_pixel[18]_syn_956 ),
    .b(\O_pixel[18]_syn_1052 ),
    .c(\O_pixel[18]_syn_1016 ),
    .d(\O_pixel[18]_syn_338 ),
    .o(\O_pixel[18]_syn_1054 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*~A)"),
    .INIT(8'h10))
    \O_pixel[18]_syn_1055  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(\O_pixel[18]_syn_160 ),
    .o(\O_pixel[18]_syn_1056 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(C*~(~D*~B)))"),
    .INIT(16'h0515))
    \O_pixel[18]_syn_1057  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_66 ),
    .d(\O_pixel[18]_syn_6 ),
    .o(\O_pixel[18]_syn_1058 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~(~B*~A))"),
    .INIT(8'he0))
    \O_pixel[18]_syn_1059  (
    .a(\O_pixel[18]_syn_931 ),
    .b(\O_pixel[18]_syn_40 ),
    .c(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_1060 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(~D*~C*B))"),
    .INIT(16'h5551))
    \O_pixel[18]_syn_1061  (
    .a(\O_pixel[18]_syn_4 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_1062 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(E*~D*C*~B))"),
    .INIT(32'haa8aaaaa))
    \O_pixel[18]_syn_1063  (
    .a(\O_pixel[18]_syn_334 ),
    .b(\O_pixel[18]_syn_1056 ),
    .c(\O_pixel[18]_syn_1058 ),
    .d(\O_pixel[18]_syn_1060 ),
    .e(\O_pixel[18]_syn_1062 ),
    .o(\O_pixel[18]_syn_1064 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*~A))"),
    .INIT(8'h0b))
    \O_pixel[18]_syn_1065  (
    .a(\O_pixel[18]_syn_328 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_1066 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \O_pixel[18]_syn_1067  (
    .a(\O_pixel[18]_syn_1066 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(\O_pixel[18]_syn_78 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_1068 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~B*~A*~(E*D*~C))"),
    .INIT(32'h10111111))
    \O_pixel[18]_syn_1069  (
    .a(\O_pixel[18]_syn_1054 ),
    .b(\O_pixel[18]_syn_1064 ),
    .c(\O_pixel[18]_syn_1068 ),
    .d(\O_pixel[18]_syn_203 ),
    .e(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_1070 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~B*A)"),
    .INIT(16'h0020))
    \O_pixel[18]_syn_107  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_108 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_1071  (
    .a(\O_pixel[18]_syn_66 ),
    .b(\O_pixel[18]_syn_6 ),
    .c(\O_pixel[18]_syn_46 ),
    .o(\O_pixel[18]_syn_1072 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(C*~(A)*~(B)+C*A*~(B)+~(C)*A*B+C*A*B)"),
    .INIT(8'h47))
    \O_pixel[18]_syn_1073  (
    .a(\O_pixel[18]_syn_14 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_158 ),
    .o(\O_pixel[18]_syn_1074 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*~(D*C*B))"),
    .INIT(16'h2aaa))
    \O_pixel[18]_syn_1075  (
    .a(\O_pixel[18]_syn_430 ),
    .b(\O_pixel[18]_syn_112 ),
    .c(\O_pixel[18]_syn_1072 ),
    .d(\O_pixel[18]_syn_1074 ),
    .o(\O_pixel[18]_syn_1076 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \O_pixel[18]_syn_1077  (
    .a(\O_pixel[18]_syn_1016 ),
    .b(\O_pixel[18]_syn_328 ),
    .c(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_1078 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(B*~(~C*A))"),
    .INIT(8'hc4))
    \O_pixel[18]_syn_1079  (
    .a(\O_pixel[18]_syn_70 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_1080 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*~A)"),
    .INIT(16'h1000))
    \O_pixel[18]_syn_1081  (
    .a(\O_pixel[18]_syn_328 ),
    .b(\O_pixel[18]_syn_66 ),
    .c(\O_pixel[18]_syn_265 ),
    .d(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_1082 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~((F*E))+A*~(B)*~(C)*~(D)*~((F*E))+~(A)*B*~(C)*~(D)*~((F*E))+~(A)*~(B)*C*~(D)*~((F*E))+A*~(B)*C*~(D)*~((F*E))+~(A)*B*C*~(D)*~((F*E))+~(A)*~(B)*~(C)*D*~((F*E))+A*~(B)*~(C)*D*~((F*E))+~(A)*~(B)*C*D*~((F*E))+A*~(B)*C*D*~((F*E))+~(A)*~(B)*~(C)*~(D)*(F*E)+A*~(B)*~(C)*~(D)*(F*E)+~(A)*B*~(C)*~(D)*(F*E))"),
    .INIT(64'h0007337733773377))
    \O_pixel[18]_syn_1083  (
    .a(\O_pixel[18]_syn_1080 ),
    .b(\O_pixel[18]_syn_1082 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(\O_pixel[18]_syn_46 ),
    .e(\O_pixel[18]_syn_34 ),
    .f(\O_pixel[18]_syn_221 ),
    .o(\O_pixel[18]_syn_1084 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~C*~(D*~(B)*~(A)+D*B*~(A)+~(D)*B*A+D*B*A))"),
    .INIT(16'h0207))
    \O_pixel[18]_syn_1085  (
    .a(\O_pixel[18]_syn_66 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(\O_pixel[18]_syn_78 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_1086 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A))"),
    .INIT(16'h0027))
    \O_pixel[18]_syn_1087  (
    .a(\O_pixel[18]_syn_199 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_1088 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*B))"),
    .INIT(8'h2a))
    \O_pixel[18]_syn_1089  (
    .a(\O_pixel[18]_syn_446 ),
    .b(\O_pixel[18]_syn_1086 ),
    .c(\O_pixel[18]_syn_1088 ),
    .o(\O_pixel[18]_syn_1090 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(D*C*~(~E*~B*~A))"),
    .INIT(32'hf000e000))
    \O_pixel[18]_syn_109  (
    .a(\O_pixel[18]_syn_102 ),
    .b(\O_pixel[18]_syn_106 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_108 ),
    .e(\O_pixel[18]_syn_10 ),
    .o(\O_pixel[18]_syn_110 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~(C*~(D)*~((~B*~A))+C*D*~((~B*~A))+~(C)*D*(~B*~A)+C*D*(~B*~A))"),
    .INIT(16'h0e1f))
    \O_pixel[18]_syn_1091  (
    .a(\O_pixel[18]_syn_188 ),
    .b(\O_pixel[18]_syn_271 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_1092 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~((~B*~A))*~(C)*~(D)+(~B*~A)*~(C)*~(D)+(~B*~A)*C*~(D)+~((~B*~A))*~(C)*D+(~B*~A)*C*D)"),
    .INIT(16'h1e1f))
    \O_pixel[18]_syn_1093  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_30 ),
    .c(\O_pixel[18]_syn_470 ),
    .d(\O_pixel[18]_syn_436 ),
    .o(\O_pixel[18]_syn_1094 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*~(F*E*D*~C*B))"),
    .INIT(64'ha2aaaaaaaaaaaaaa))
    \O_pixel[18]_syn_1095  (
    .a(\O_pixel[18]_syn_420 ),
    .b(\O_pixel[18]_syn_305 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_787 ),
    .e(\O_pixel[18]_syn_1092 ),
    .f(\O_pixel[18]_syn_1094 ),
    .o(\O_pixel[18]_syn_1096 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_1097  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_291 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_170 ),
    .o(\O_pixel[18]_syn_1098 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*~D*C*~B*~A)"),
    .INIT(64'h0000000000000010))
    \O_pixel[18]_syn_1099  (
    .a(\O_pixel[18]_syn_1076 ),
    .b(\O_pixel[18]_syn_1078 ),
    .c(\O_pixel[18]_syn_1084 ),
    .d(\O_pixel[18]_syn_1090 ),
    .e(\O_pixel[18]_syn_1096 ),
    .f(\O_pixel[18]_syn_1098 ),
    .o(\O_pixel[18]_syn_1100 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~(~D*~(C)*~((~B*~A))+~D*C*~((~B*~A))+~(~D)*C*(~B*~A)+~D*C*(~B*~A))"),
    .INIT(16'hef01))
    \O_pixel[18]_syn_11  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(read_address[2]),
    .o(\O_pixel[18]_syn_12 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_1101  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_170 ),
    .o(\O_pixel[18]_syn_1102 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((~C*~B)*~(D)*~(A)+(~C*~B)*D*~(A)+~((~C*~B))*D*A+(~C*~B)*D*A)"),
    .INIT(16'h54fe))
    \O_pixel[18]_syn_1103  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_16 ),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_1104 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(B*(A*~(C)*~(D)*~(E)+A*C*~(D)*~(E)+~(A)*C*D*~(E)+A*C*D*~(E)+A*~(C)*~(D)*E+~(A)*C*~(D)*E+A*C*~(D)*E+~(A)*C*D*E+A*C*D*E))"),
    .INIT(32'hc0c8c088))
    \O_pixel[18]_syn_1105  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_182 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(read_address[0]),
    .e(read_address[1]),
    .o(\O_pixel[18]_syn_1106 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(~E*~D*C*~B))"),
    .INIT(32'haaaaaa8a))
    \O_pixel[18]_syn_1107  (
    .a(\O_pixel[18]_syn_1102 ),
    .b(\O_pixel[18]_syn_1104 ),
    .c(\O_pixel[18]_syn_613 ),
    .d(\O_pixel[18]_syn_1106 ),
    .e(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_1108 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*(A*~(B)*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E))"),
    .INIT(64'h0000000003fffa00))
    \O_pixel[18]_syn_1109  (
    .a(\O_pixel[18]_syn_188 ),
    .b(\O_pixel[18]_syn_72 ),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_1110 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~B*~(C*~A))"),
    .INIT(8'h23))
    \O_pixel[18]_syn_111  (
    .a(\O_pixel[18]_syn_14 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_6 ),
    .o(\O_pixel[18]_syn_112 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~A*~(D*C)*~(F*E*B))"),
    .INIT(64'h0111055505550555))
    \O_pixel[18]_syn_1111  (
    .a(\O_pixel[18]_syn_1108 ),
    .b(\O_pixel[18]_syn_1110 ),
    .c(\O_pixel[18]_syn_303 ),
    .d(\O_pixel[18]_syn_456 ),
    .e(\O_pixel[18]_syn_50 ),
    .f(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_1112 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*A))"),
    .INIT(8'h07))
    \O_pixel[18]_syn_1113  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_64 ),
    .o(\O_pixel[18]_syn_1114 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D*C*~(~F*~E*B*A))"),
    .INIT(64'hf000f000f0007000))
    \O_pixel[18]_syn_1115  (
    .a(\O_pixel[18]_syn_765 ),
    .b(\O_pixel[18]_syn_1114 ),
    .c(\O_pixel[18]_syn_203 ),
    .d(\O_pixel[18]_syn_90 ),
    .e(\O_pixel[18]_syn_20 ),
    .f(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_1116 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*A*~(C*B))"),
    .INIT(16'h002a))
    \O_pixel[18]_syn_1117  (
    .a(\O_pixel[18]_syn_6 ),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_1118 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \O_pixel[18]_syn_1119  (
    .a(\O_pixel[18]_syn_1086 ),
    .b(\O_pixel[18]_syn_849 ),
    .c(\O_pixel[18]_syn_1118 ),
    .d(\O_pixel[18]_syn_669 ),
    .o(\O_pixel[18]_syn_1120 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(B*~((~E*~(D*C)))*~(A)+B*(~E*~(D*C))*~(A)+~(B)*(~E*~(D*C))*A+B*(~E*~(D*C))*A)"),
    .INIT(32'h44444eee))
    \O_pixel[18]_syn_1121  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(read_address[1]),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_1122 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_1123  (
    .a(\O_pixel[18]_syn_1122 ),
    .b(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_1124 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(E*D*~(C*B)))"),
    .INIT(32'h40555555))
    \O_pixel[18]_syn_1125  (
    .a(\O_pixel[18]_syn_1116 ),
    .b(\O_pixel[18]_syn_1120 ),
    .c(\O_pixel[18]_syn_1124 ),
    .d(\O_pixel[18]_syn_203 ),
    .e(\O_pixel[18]_syn_265 ),
    .o(\O_pixel[18]_syn_1126 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(E*D*C*B))"),
    .INIT(32'h2aaaaaaa))
    \O_pixel[18]_syn_1127  (
    .a(\O_pixel[18]_syn_1050 ),
    .b(\O_pixel[18]_syn_1070 ),
    .c(\O_pixel[18]_syn_1100 ),
    .d(\O_pixel[18]_syn_1112 ),
    .e(\O_pixel[18]_syn_1126 ),
    .o(\O_pixel[18]_syn_1128 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_1129  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(read_valid),
    .o(mux2_syn_27));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_113  (
    .a(\O_pixel[18]_syn_90 ),
    .b(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_114 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~A*~(F*~(E*D*C*B)))"),
    .INIT(64'h4000000055555555))
    \O_pixel[18]_syn_1130  (
    .a(\O_pixel[18]_syn_1128 ),
    .b(\O_pixel[18]_syn_402 ),
    .c(\O_pixel[18]_syn_645 ),
    .d(\O_pixel[18]_syn_847 ),
    .e(\O_pixel[18]_syn_1030 ),
    .f(\O_pixel[18]_syn_1050 ),
    .o(\O_pixel[18]_syn_1131 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[18]_syn_1132  (
    .a(mux2_syn_27),
    .b(memory_data[18]),
    .c(memory_data[54]),
    .d(memory_data[90]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[18]_syn_1133 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*A)"),
    .INIT(4'hd))
    \O_pixel[18]_syn_1134  (
    .a(\O_pixel[18]_syn_1131 ),
    .b(\O_pixel[18]_syn_1133 ),
    .o(\O_pixel[18]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B*A))"),
    .INIT(8'h70))
    \O_pixel[18]_syn_115  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_116 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_117  (
    .a(\O_pixel[18]_syn_116 ),
    .b(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_118 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*A)"),
    .INIT(16'h0200))
    \O_pixel[18]_syn_119  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_120 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \O_pixel[18]_syn_121  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_122 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((D*B)*~(C)*~(A)+(D*B)*C*~(A)+~((D*B))*C*A+(D*B)*C*A)"),
    .INIT(16'h1b5f))
    \O_pixel[18]_syn_123  (
    .a(\O_pixel[18]_syn_98 ),
    .b(\O_pixel[18]_syn_120 ),
    .c(\O_pixel[18]_syn_122 ),
    .d(\O_pixel[18]_syn_60 ),
    .o(\O_pixel[18]_syn_124 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(B*~((C*~(E*~D)))*~(A)+B*(C*~(E*~D))*~(A)+~(B)*(C*~(E*~D))*A+B*(C*~(E*~D))*A)"),
    .INIT(32'he444e4e4))
    \O_pixel[18]_syn_125  (
    .a(\O_pixel[18]_syn_112 ),
    .b(\O_pixel[18]_syn_114 ),
    .c(\O_pixel[18]_syn_92 ),
    .d(\O_pixel[18]_syn_118 ),
    .e(\O_pixel[18]_syn_124 ),
    .o(\O_pixel[18]_syn_126 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \O_pixel[18]_syn_127  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_128 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_129  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_130 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~(C*~(~B*~A)))"),
    .INIT(16'h001f))
    \O_pixel[18]_syn_13  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_14 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*~A)"),
    .INIT(16'h0004))
    \O_pixel[18]_syn_131  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_132 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_133  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_132 ),
    .o(\O_pixel[18]_syn_134 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_135  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .o(\O_pixel[18]_syn_136 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("~((C*B)*~((~E*~D))*~(A)+(C*B)*(~E*~D)*~(A)+~((C*B))*(~E*~D)*A+(C*B)*(~E*~D)*A)"),
    .INIT(32'hbfbfbf15))
    \O_pixel[18]_syn_137  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(\O_pixel[18]_syn_136 ),
    .d(read_address[1]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_138 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_139  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_140 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hefefbb11))
    \O_pixel[18]_syn_141  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_20 ),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_142 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*B*~(C)*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+A*B*C*~(D)*E)"),
    .INIT(32'h00aeccc4))
    \O_pixel[18]_syn_143  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_120 ),
    .c(read_address[1]),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_144 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_145  (
    .a(read_address[2]),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_146 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hfe07))
    \O_pixel[18]_syn_147  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_148 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((~D*B)*~(C)*~(A)+(~D*B)*C*~(A)+~((~D*B))*C*A+(~D*B)*C*A)"),
    .INIT(16'h5f1b))
    \O_pixel[18]_syn_149  (
    .a(\O_pixel[18]_syn_146 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(\O_pixel[18]_syn_148 ),
    .o(\O_pixel[18]_syn_150 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*~A)"),
    .INIT(16'h0400))
    \O_pixel[18]_syn_15  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_16 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(~(F*~E)*B)*~(~(D*C)*A))"),
    .INIT(64'h3111f55531113111))
    \O_pixel[18]_syn_151  (
    .a(\O_pixel[18]_syn_130 ),
    .b(\O_pixel[18]_syn_134 ),
    .c(\O_pixel[18]_syn_138 ),
    .d(\O_pixel[18]_syn_142 ),
    .e(\O_pixel[18]_syn_144 ),
    .f(\O_pixel[18]_syn_150 ),
    .o(\O_pixel[18]_syn_152 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*~D*~C*~B*A)"),
    .INIT(32'h00020000))
    \O_pixel[18]_syn_153  (
    .a(\O_pixel[18]_syn_88 ),
    .b(\O_pixel[18]_syn_100 ),
    .c(\O_pixel[18]_syn_110 ),
    .d(\O_pixel[18]_syn_126 ),
    .e(\O_pixel[18]_syn_152 ),
    .o(\O_pixel[18]_syn_154 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_155  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_156 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \O_pixel[18]_syn_157  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_158 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*D*(A*B*~(C)+~(A)*~(B)*C+A*~(B)*C))"),
    .INIT(64'h0000000000003800))
    \O_pixel[18]_syn_159  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_160 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \O_pixel[18]_syn_161  (
    .a(\O_pixel[18]_syn_28 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(\O_pixel[18]_syn_160 ),
    .o(\O_pixel[18]_syn_162 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*(A*B*~(C)+~(A)*~(B)*C+A*~(B)*C))"),
    .INIT(16'h3800))
    \O_pixel[18]_syn_163  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_164 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \O_pixel[18]_syn_165  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_166 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(F*E*~B)*~(D*C*A))"),
    .INIT(64'h4ccc5fff5fff5fff))
    \O_pixel[18]_syn_167  (
    .a(\O_pixel[18]_syn_156 ),
    .b(\O_pixel[18]_syn_162 ),
    .c(\O_pixel[18]_syn_164 ),
    .d(\O_pixel[18]_syn_140 ),
    .e(\O_pixel[18]_syn_84 ),
    .f(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_168 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~B*~A)"),
    .INIT(16'h0010))
    \O_pixel[18]_syn_169  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_170 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*(~D*~(B)*~(C)+~D*B*~(C)+~(~D)*B*C+~D*B*C))"),
    .INIT(16'h808a))
    \O_pixel[18]_syn_17  (
    .a(\O_pixel[18]_syn_8 ),
    .b(\O_pixel[18]_syn_12 ),
    .c(\O_pixel[18]_syn_14 ),
    .d(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_18 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_171  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_170 ),
    .o(\O_pixel[18]_syn_172 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_173  (
    .a(read_address[0]),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_174 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_175  (
    .a(\O_pixel[18]_syn_174 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_4 ),
    .d(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_176 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(D*C*A))"),
    .INIT(16'h1333))
    \O_pixel[18]_syn_177  (
    .a(\O_pixel[18]_syn_172 ),
    .b(\O_pixel[18]_syn_176 ),
    .c(\O_pixel[18]_syn_64 ),
    .d(\O_pixel[18]_syn_122 ),
    .o(\O_pixel[18]_syn_178 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_179  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_180 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_181  (
    .a(read_address[2]),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_182 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \O_pixel[18]_syn_183  (
    .a(\O_pixel[18]_syn_182 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .o(\O_pixel[18]_syn_184 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*A)"),
    .INIT(16'h2000))
    \O_pixel[18]_syn_185  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_186 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~(~B*~A))"),
    .INIT(8'he0))
    \O_pixel[18]_syn_187  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_188 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(F*E*D*C)*~(B*A))"),
    .INIT(64'h0777777777777777))
    \O_pixel[18]_syn_189  (
    .a(\O_pixel[18]_syn_180 ),
    .b(\O_pixel[18]_syn_184 ),
    .c(\O_pixel[18]_syn_186 ),
    .d(\O_pixel[18]_syn_188 ),
    .e(\O_pixel[18]_syn_34 ),
    .f(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_190 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \O_pixel[18]_syn_19  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_20 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~(~B*~A))"),
    .INIT(16'h000e))
    \O_pixel[18]_syn_191  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_192 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~B*~A)"),
    .INIT(16'h0010))
    \O_pixel[18]_syn_193  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_194 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(D*C*B*~(~E*~A))"),
    .INIT(32'hc0008000))
    \O_pixel[18]_syn_195  (
    .a(\O_pixel[18]_syn_192 ),
    .b(\O_pixel[18]_syn_90 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(\O_pixel[18]_syn_84 ),
    .e(\O_pixel[18]_syn_194 ),
    .o(\O_pixel[18]_syn_196 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_197  (
    .a(\O_pixel[18]_syn_66 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_46 ),
    .d(\O_pixel[18]_syn_36 ),
    .o(\read_address[14]_syn_3410 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*A))"),
    .INIT(8'h07))
    \O_pixel[18]_syn_198  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_199 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("P5"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[18]_syn_2  (
    .doq({open_n621,\O_pixel[18]_dup_1 }),
    .opad(O_pixel[18]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*B*(~(A)*C*~(D)+A*~(C)*D+~(A)*C*D))"),
    .INIT(32'h48400000))
    \O_pixel[18]_syn_200  (
    .a(\O_pixel[18]_syn_199 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_78 ),
    .d(\O_pixel[18]_syn_98 ),
    .e(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_201 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \O_pixel[18]_syn_202  (
    .a(read_address[12]),
    .b(read_address[13]),
    .c(read_address[14]),
    .o(\O_pixel[18]_syn_203 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_204  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_205 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~C*~B*~A*~(~E*D))"),
    .INIT(32'h01010001))
    \O_pixel[18]_syn_206  (
    .a(\O_pixel[18]_syn_196 ),
    .b(\read_address[14]_syn_3410 ),
    .c(\O_pixel[18]_syn_201 ),
    .d(\O_pixel[18]_syn_205 ),
    .e(\O_pixel[18]_syn_148 ),
    .o(\O_pixel[18]_syn_207 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[18]_syn_208  (
    .a(read_address[2]),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_209 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*~A)"),
    .INIT(16'h0040))
    \O_pixel[18]_syn_21  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_22 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \O_pixel[18]_syn_210  (
    .a(\O_pixel[18]_syn_209 ),
    .b(\O_pixel[18]_syn_6 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_128 ),
    .e(read_address[0]),
    .o(\O_pixel[18]_syn_211 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \O_pixel[18]_syn_212  (
    .a(\O_pixel[18]_syn_146 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_132 ),
    .d(\O_pixel[18]_syn_98 ),
    .e(read_address[0]),
    .o(\O_pixel[18]_syn_213 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*D*C*B*A)"),
    .INIT(64'h0000000000008000))
    \O_pixel[18]_syn_214  (
    .a(\O_pixel[18]_syn_168 ),
    .b(\O_pixel[18]_syn_178 ),
    .c(\O_pixel[18]_syn_190 ),
    .d(\O_pixel[18]_syn_207 ),
    .e(\O_pixel[18]_syn_211 ),
    .f(\O_pixel[18]_syn_213 ),
    .o(\O_pixel[18]_syn_215 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*A)"),
    .INIT(16'h2000))
    \O_pixel[18]_syn_216  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_217 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+~(A)*B*~(C)+A*~(B)*C+~(A)*B*C+A*B*C)"),
    .INIT(8'he7))
    \O_pixel[18]_syn_218  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_219 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \O_pixel[18]_syn_220  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_221 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*A)"),
    .INIT(16'h2000))
    \O_pixel[18]_syn_222  (
    .a(\O_pixel[18]_syn_217 ),
    .b(\O_pixel[18]_syn_219 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_221 ),
    .o(\O_pixel[18]_syn_223 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_224  (
    .a(read_address[2]),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_225 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_226  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_225 ),
    .c(\O_pixel[18]_syn_90 ),
    .d(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_227 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \O_pixel[18]_syn_228  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_229 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+A*~(B)*~(C)*D*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+A*~(B)*~(C)*~(D)*~(E)*F+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+A*~(B)*C*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+A*~(B)*~(C)*D*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+A*~(B)*C*D*~(E)*F+A*B*C*D*~(E)*F)"),
    .INIT(64'h0000aeeeeeceeecc))
    \O_pixel[18]_syn_23  (
    .a(\O_pixel[18]_syn_20 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_24 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_230  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_231 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \O_pixel[18]_syn_232  (
    .a(\O_pixel[18]_syn_186 ),
    .b(\O_pixel[18]_syn_209 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_4 ),
    .e(read_address[0]),
    .o(\O_pixel[18]_syn_233 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_234  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_221 ),
    .o(\O_pixel[18]_syn_235 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*~B*~A)"),
    .INIT(32'h00000001))
    \O_pixel[18]_syn_236  (
    .a(\O_pixel[18]_syn_223 ),
    .b(\O_pixel[18]_syn_227 ),
    .c(\O_pixel[18]_syn_231 ),
    .d(\O_pixel[18]_syn_233 ),
    .e(\O_pixel[18]_syn_235 ),
    .o(\O_pixel[18]_syn_237 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_238  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_239 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_240  (
    .a(\O_pixel[18]_syn_239 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_221 ),
    .o(\read_address[14]_syn_3898 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~(~B*~A))"),
    .INIT(16'h00e0))
    \O_pixel[18]_syn_241  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_242 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*~A)"),
    .INIT(16'h0400))
    \O_pixel[18]_syn_243  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_244 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_245  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_242 ),
    .c(\O_pixel[18]_syn_78 ),
    .d(\O_pixel[18]_syn_244 ),
    .o(\O_pixel[18]_syn_246 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hfe7f))
    \O_pixel[18]_syn_247  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_248 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~B*~A*~(F*E*D*~C))"),
    .INIT(64'h1011111111111111))
    \O_pixel[18]_syn_249  (
    .a(\read_address[14]_syn_3898 ),
    .b(\O_pixel[18]_syn_246 ),
    .c(\O_pixel[18]_syn_248 ),
    .d(\O_pixel[18]_syn_50 ),
    .e(\O_pixel[18]_syn_98 ),
    .f(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_250 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_25  (
    .a(\O_pixel[18]_syn_20 ),
    .b(read_address[2]),
    .o(\O_pixel[18]_syn_26 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_251  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_252 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_253  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_254 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_255  (
    .a(\O_pixel[18]_syn_186 ),
    .b(\O_pixel[18]_syn_60 ),
    .c(\O_pixel[18]_syn_140 ),
    .d(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_256 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_257  (
    .a(\O_pixel[18]_syn_254 ),
    .b(\O_pixel[18]_syn_256 ),
    .o(\O_pixel[18]_syn_258 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_259  (
    .a(\O_pixel[18]_syn_116 ),
    .b(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_260 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_261  (
    .a(\O_pixel[18]_syn_90 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_262 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_263  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_66 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_221 ),
    .o(\read_address[14]_syn_7070 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*A)"),
    .INIT(16'h0080))
    \O_pixel[18]_syn_264  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_265 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \O_pixel[18]_syn_266  (
    .a(\O_pixel[18]_syn_146 ),
    .b(\O_pixel[18]_syn_6 ),
    .c(\O_pixel[18]_syn_265 ),
    .d(\O_pixel[18]_syn_34 ),
    .e(read_address[0]),
    .o(\O_pixel[18]_syn_267 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~D*~C*~B*~(F*E*A))"),
    .INIT(64'h0001000300030003))
    \O_pixel[18]_syn_268  (
    .a(\O_pixel[18]_syn_260 ),
    .b(\O_pixel[18]_syn_262 ),
    .c(\read_address[14]_syn_7070 ),
    .d(\O_pixel[18]_syn_267 ),
    .e(\O_pixel[18]_syn_30 ),
    .f(\O_pixel[18]_syn_132 ),
    .o(\O_pixel[18]_syn_269 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~B*~A)"),
    .INIT(16'h0010))
    \O_pixel[18]_syn_27  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_28 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~(~B*~A))"),
    .INIT(16'h0e00))
    \O_pixel[18]_syn_270  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_271 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_272  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_271 ),
    .c(\O_pixel[18]_syn_217 ),
    .d(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_273 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(D*C*B))"),
    .INIT(16'h1555))
    \O_pixel[18]_syn_274  (
    .a(\O_pixel[18]_syn_273 ),
    .b(\O_pixel[18]_syn_132 ),
    .c(\O_pixel[18]_syn_120 ),
    .d(\O_pixel[18]_syn_50 ),
    .o(\O_pixel[18]_syn_275 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \O_pixel[18]_syn_276  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_277 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_278  (
    .a(\O_pixel[18]_syn_277 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_279 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*E*D*C*B*A)"),
    .INIT(64'h0000000080000000))
    \O_pixel[18]_syn_280  (
    .a(\O_pixel[18]_syn_237 ),
    .b(\O_pixel[18]_syn_250 ),
    .c(\O_pixel[18]_syn_258 ),
    .d(\O_pixel[18]_syn_269 ),
    .e(\O_pixel[18]_syn_275 ),
    .f(\O_pixel[18]_syn_279 ),
    .o(\O_pixel[18]_syn_281 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*~C*~(~B*~A))"),
    .INIT(32'h0e000000))
    \O_pixel[18]_syn_282  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[5]),
    .d(read_address[6]),
    .e(read_address[7]),
    .o(\O_pixel[18]_syn_283 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D))"),
    .INIT(16'h0511))
    \O_pixel[18]_syn_284  (
    .a(\O_pixel[18]_syn_283 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_285 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*A))"),
    .INIT(8'h07))
    \O_pixel[18]_syn_286  (
    .a(\O_pixel[18]_syn_20 ),
    .b(\O_pixel[18]_syn_40 ),
    .c(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_287 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(B*A))"),
    .INIT(16'h7000))
    \O_pixel[18]_syn_288  (
    .a(\O_pixel[18]_syn_285 ),
    .b(\O_pixel[18]_syn_287 ),
    .c(\O_pixel[18]_syn_186 ),
    .d(\O_pixel[18]_syn_50 ),
    .o(\O_pixel[18]_syn_289 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~B*A)"),
    .INIT(16'h0020))
    \O_pixel[18]_syn_29  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_30 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*(B@A))"),
    .INIT(16'h0600))
    \O_pixel[18]_syn_290  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_291 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(C*A))"),
    .INIT(16'h135f))
    \O_pixel[18]_syn_292  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_291 ),
    .c(\O_pixel[18]_syn_140 ),
    .d(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_293 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_294  (
    .a(\O_pixel[18]_syn_72 ),
    .b(\O_pixel[18]_syn_20 ),
    .o(\O_pixel[18]_syn_295 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~(~B*~A))"),
    .INIT(8'he0))
    \O_pixel[18]_syn_296  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_297 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[18]_syn_298  (
    .a(\O_pixel[18]_syn_217 ),
    .b(\O_pixel[18]_syn_297 ),
    .o(\O_pixel[18]_syn_299 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*~A)"),
    .INIT(16'h0004))
    \O_pixel[18]_syn_3  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*~(~D*~C*B))"),
    .INIT(16'haaa2))
    \O_pixel[18]_syn_300  (
    .a(\O_pixel[18]_syn_114 ),
    .b(\O_pixel[18]_syn_293 ),
    .c(\O_pixel[18]_syn_295 ),
    .d(\O_pixel[18]_syn_299 ),
    .o(\O_pixel[18]_syn_301 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_302  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_132 ),
    .o(\O_pixel[18]_syn_303 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_304  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_305 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_306  (
    .a(\O_pixel[18]_syn_239 ),
    .b(\O_pixel[18]_syn_6 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_170 ),
    .o(\read_address[14]_syn_7138 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \O_pixel[18]_syn_307  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .e(read_address[5]),
    .o(\O_pixel[18]_syn_308 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B*A))"),
    .INIT(8'h70))
    \O_pixel[18]_syn_309  (
    .a(read_address[1]),
    .b(read_address[4]),
    .c(read_address[7]),
    .o(\O_pixel[18]_syn_310 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*B*~(C)*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+A*~(B)*~(C)*D*~(E)+A*B*~(C)*D*~(E)+A*~(B)*C*D*~(E)+A*B*C*D*~(E)+~(A)*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'heee4aae4))
    \O_pixel[18]_syn_31  (
    .a(\O_pixel[18]_syn_28 ),
    .b(\O_pixel[18]_syn_30 ),
    .c(read_address[1]),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_32 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*~(~(B*A)*~(C)*~(D)+~(B*A)*C*~(D)+~(~(B*A))*C*D+~(B*A)*C*D))"),
    .INIT(32'h0f880000))
    \O_pixel[18]_syn_311  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .o(\O_pixel[18]_syn_312 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*~D*~C*B*A)"),
    .INIT(32'h00080000))
    \O_pixel[18]_syn_313  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_108 ),
    .c(\O_pixel[18]_syn_308 ),
    .d(\O_pixel[18]_syn_310 ),
    .e(\O_pixel[18]_syn_312 ),
    .o(\O_pixel[18]_syn_314 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_315  (
    .a(read_address[1]),
    .b(read_address[2]),
    .o(\O_pixel[18]_syn_316 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~D*~(~(E*~B)*~(C)*~(A)+~(E*~B)*C*~(A)+~(~(E*~B))*C*A+~(E*~B)*C*A))"),
    .INIT(32'h001b000a))
    \O_pixel[18]_syn_317  (
    .a(\O_pixel[18]_syn_316 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_158 ),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_318 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \O_pixel[18]_syn_319  (
    .a(\O_pixel[18]_syn_188 ),
    .b(\O_pixel[18]_syn_104 ),
    .c(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_320 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~D*~C*~(A*~(B*~(~F*~E))))"),
    .INIT(64'h000d000d000d0005))
    \O_pixel[18]_syn_321  (
    .a(\O_pixel[18]_syn_303 ),
    .b(\O_pixel[18]_syn_305 ),
    .c(\read_address[14]_syn_7138 ),
    .d(\O_pixel[18]_syn_314 ),
    .e(\O_pixel[18]_syn_318 ),
    .f(\O_pixel[18]_syn_320 ),
    .o(\O_pixel[18]_syn_322 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*~A)"),
    .INIT(16'h1000))
    \O_pixel[18]_syn_323  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_324 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*~B*A)"),
    .INIT(32'h00000002))
    \O_pixel[18]_syn_325  (
    .a(\O_pixel[18]_syn_324 ),
    .b(read_address[4]),
    .c(read_address[5]),
    .d(read_address[6]),
    .e(read_address[7]),
    .o(\O_pixel[18]_syn_326 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_327  (
    .a(read_address[2]),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_328 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*~D*C*~B*A)"),
    .INIT(32'h00200000))
    \O_pixel[18]_syn_329  (
    .a(read_address[1]),
    .b(read_address[4]),
    .c(read_address[5]),
    .d(read_address[6]),
    .e(read_address[7]),
    .o(\O_pixel[18]_syn_330 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*B*A)"),
    .INIT(8'h08))
    \O_pixel[18]_syn_33  (
    .a(read_address[12]),
    .b(read_address[13]),
    .c(read_address[14]),
    .o(\O_pixel[18]_syn_34 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(C*B*~(~A*~(E*D)))"),
    .INIT(32'hc0808080))
    \O_pixel[18]_syn_331  (
    .a(\O_pixel[18]_syn_326 ),
    .b(\O_pixel[18]_syn_328 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_265 ),
    .e(\O_pixel[18]_syn_330 ),
    .o(\O_pixel[18]_syn_332 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_333  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_36 ),
    .o(\O_pixel[18]_syn_334 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_335  (
    .a(\O_pixel[18]_syn_265 ),
    .b(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_336 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_337  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_239 ),
    .o(\O_pixel[18]_syn_338 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(C*B)*~(D*A))"),
    .INIT(16'h153f))
    \O_pixel[18]_syn_339  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_239 ),
    .c(\O_pixel[18]_syn_4 ),
    .d(\O_pixel[18]_syn_6 ),
    .o(\O_pixel[18]_syn_340 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+~(A)*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+~(A)*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h414541ef))
    \O_pixel[18]_syn_341  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_116 ),
    .c(\O_pixel[18]_syn_10 ),
    .d(\O_pixel[18]_syn_46 ),
    .e(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_342 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(~(D*~C)*B)*~(~E*A))"),
    .INIT(32'h3f331511))
    \O_pixel[18]_syn_343  (
    .a(\O_pixel[18]_syn_334 ),
    .b(\O_pixel[18]_syn_336 ),
    .c(\O_pixel[18]_syn_338 ),
    .d(\O_pixel[18]_syn_340 ),
    .e(\O_pixel[18]_syn_342 ),
    .o(\O_pixel[18]_syn_344 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*~D*C*~B*~A)"),
    .INIT(32'h00100000))
    \O_pixel[18]_syn_345  (
    .a(\O_pixel[18]_syn_289 ),
    .b(\O_pixel[18]_syn_301 ),
    .c(\O_pixel[18]_syn_322 ),
    .d(\O_pixel[18]_syn_332 ),
    .e(\O_pixel[18]_syn_344 ),
    .o(\O_pixel[18]_syn_346 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*B))"),
    .INIT(8'h2a))
    \O_pixel[18]_syn_347  (
    .a(\O_pixel[18]_syn_120 ),
    .b(read_address[1]),
    .c(read_address[2]),
    .o(\O_pixel[18]_syn_348 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_349  (
    .a(\O_pixel[18]_syn_348 ),
    .b(\O_pixel[18]_syn_10 ),
    .o(\O_pixel[18]_syn_350 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_35  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_36 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~((~D*~C))+A*~(B)*~((~D*~C))+A*B*~((~D*~C))+~(A)*~(B)*(~D*~C)+~(A)*B*(~D*~C))"),
    .INIT(16'hbbb5))
    \O_pixel[18]_syn_351  (
    .a(\O_pixel[18]_syn_6 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_352 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((~C*A)*~(B)*~(D)+(~C*A)*B*~(D)+~((~C*A))*B*D+(~C*A)*B*D)"),
    .INIT(16'h33f5))
    \O_pixel[18]_syn_353  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_354 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_355  (
    .a(\O_pixel[18]_syn_174 ),
    .b(\O_pixel[18]_syn_78 ),
    .o(\O_pixel[18]_syn_356 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*~(~C*B*A))"),
    .INIT(32'hf7000000))
    \O_pixel[18]_syn_357  (
    .a(\O_pixel[18]_syn_352 ),
    .b(\O_pixel[18]_syn_354 ),
    .c(\O_pixel[18]_syn_356 ),
    .d(\O_pixel[18]_syn_34 ),
    .e(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_358 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_359  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_265 ),
    .o(\O_pixel[18]_syn_360 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_361  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_52 ),
    .o(\O_pixel[18]_syn_362 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_363  (
    .a(read_address[1]),
    .b(read_address[2]),
    .o(\O_pixel[18]_syn_364 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*E*D*(~(A)*B*~(C)+A*B*~(C)+~(A)*~(B)*C))"),
    .INIT(64'h000000001c000000))
    \O_pixel[18]_syn_365  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_366 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*E*(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D))"),
    .INIT(64'h000000007e0c0000))
    \O_pixel[18]_syn_367  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_368 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~D*~(C*B)*~(E*A))"),
    .INIT(32'h0015003f))
    \O_pixel[18]_syn_369  (
    .a(\O_pixel[18]_syn_209 ),
    .b(\O_pixel[18]_syn_364 ),
    .c(\O_pixel[18]_syn_217 ),
    .d(\O_pixel[18]_syn_366 ),
    .e(\O_pixel[18]_syn_368 ),
    .o(\O_pixel[18]_syn_370 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_37  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_36 ),
    .o(\O_pixel[18]_syn_38 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*A*~(~C*~B))"),
    .INIT(16'ha800))
    \O_pixel[18]_syn_371  (
    .a(\O_pixel[18]_syn_98 ),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_372 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(C*~(A)*~(B)+C*A*~(B)+~(C)*A*B+C*A*B)"),
    .INIT(8'h47))
    \O_pixel[18]_syn_373  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_374 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(~C*B)*~((E*~D))*~(A)+~(~C*B)*(E*~D)*~(A)+~(~(~C*B))*(E*~D)*A+~(~C*B)*(E*~D)*A)"),
    .INIT(32'h51fb5151))
    \O_pixel[18]_syn_375  (
    .a(\O_pixel[18]_syn_360 ),
    .b(\O_pixel[18]_syn_362 ),
    .c(\O_pixel[18]_syn_370 ),
    .d(\O_pixel[18]_syn_372 ),
    .e(\O_pixel[18]_syn_374 ),
    .o(\O_pixel[18]_syn_376 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_377  (
    .a(\O_pixel[18]_syn_186 ),
    .b(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_378 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(C*~(A)*~(B)+C*A*~(B)+~(C)*A*B+C*A*B)"),
    .INIT(8'h47))
    \O_pixel[18]_syn_379  (
    .a(\O_pixel[18]_syn_239 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_6 ),
    .o(\O_pixel[18]_syn_380 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \O_pixel[18]_syn_381  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_382 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((C*B)*~(D)*~(A)+(C*B)*D*~(A)+~((C*B))*D*A+(C*B)*D*A)"),
    .INIT(16'h15bf))
    \O_pixel[18]_syn_383  (
    .a(\O_pixel[18]_syn_382 ),
    .b(\O_pixel[18]_syn_104 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_384 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \O_pixel[18]_syn_385  (
    .a(read_address[2]),
    .b(read_address[6]),
    .c(read_address[7]),
    .o(\O_pixel[18]_syn_386 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(B*~(C)*~(D)*~(E)*~((~F*A))+~(B)*C*~(D)*~(E)*~((~F*A))+B*C*~(D)*~(E)*~((~F*A))+B*~(C)*D*~(E)*~((~F*A))+~(B)*C*D*~(E)*~((~F*A))+B*C*D*~(E)*~((~F*A))+B*~(C)*~(D)*E*~((~F*A))+~(B)*C*~(D)*E*~((~F*A))+B*C*~(D)*E*~((~F*A))+~(B)*~(C)*D*E*~((~F*A))+B*~(C)*D*E*~((~F*A))+~(B)*C*D*E*~((~F*A))+B*C*D*E*~((~F*A))+~(B)*C*~(D)*~(E)*(~F*A)+~(B)*C*D*~(E)*(~F*A)+B*~(C)*~(D)*E*(~F*A)+~(B)*C*~(D)*E*(~F*A)+B*C*~(D)*E*(~F*A)+~(B)*~(C)*D*E*(~F*A)+B*~(C)*D*E*(~F*A)+~(B)*C*D*E*(~F*A)+B*C*D*E*(~F*A))"),
    .INIT(64'hfffcfcfcfffc7474))
    \O_pixel[18]_syn_387  (
    .a(\O_pixel[18]_syn_316 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(\O_pixel[18]_syn_120 ),
    .d(\O_pixel[18]_syn_386 ),
    .e(read_address[3]),
    .f(read_address[0]),
    .o(\O_pixel[18]_syn_388 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_389  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_390 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~(B*A))"),
    .INIT(16'h0007))
    \O_pixel[18]_syn_39  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_40 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(E*~D*C*B))"),
    .INIT(32'haa2aaaaa))
    \O_pixel[18]_syn_391  (
    .a(\O_pixel[18]_syn_378 ),
    .b(\O_pixel[18]_syn_380 ),
    .c(\O_pixel[18]_syn_384 ),
    .d(\O_pixel[18]_syn_388 ),
    .e(\O_pixel[18]_syn_390 ),
    .o(\O_pixel[18]_syn_392 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_393  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_244 ),
    .o(\O_pixel[18]_syn_394 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_395  (
    .a(read_address[1]),
    .b(read_address[2]),
    .o(\O_pixel[18]_syn_396 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~((E*D))+A*~(B)*~(C)*~((E*D))+~(A)*B*~(C)*~((E*D))+A*B*~(C)*~((E*D))+~(A)*B*C*~((E*D))+A*B*C*~((E*D))+~(A)*~(B)*~(C)*(E*D)+A*~(B)*~(C)*(E*D)+~(A)*B*~(C)*(E*D)+~(A)*~(B)*C*(E*D)+A*~(B)*C*(E*D)+~(A)*B*C*(E*D))"),
    .INIT(32'h77cfcfcf))
    \O_pixel[18]_syn_397  (
    .a(\O_pixel[18]_syn_396 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_120 ),
    .d(read_address[0]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_398 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~D*C*~B*~(E*~(F*A)))"),
    .INIT(64'h0020003000000030))
    \O_pixel[18]_syn_399  (
    .a(\O_pixel[18]_syn_350 ),
    .b(\O_pixel[18]_syn_358 ),
    .c(\O_pixel[18]_syn_376 ),
    .d(\O_pixel[18]_syn_392 ),
    .e(\O_pixel[18]_syn_394 ),
    .f(\O_pixel[18]_syn_398 ),
    .o(\O_pixel[18]_syn_400 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*E*D*C*B*A)"),
    .INIT(64'h8000000000000000))
    \O_pixel[18]_syn_401  (
    .a(\O_pixel[18]_syn_58 ),
    .b(\O_pixel[18]_syn_154 ),
    .c(\O_pixel[18]_syn_215 ),
    .d(\O_pixel[18]_syn_281 ),
    .e(\O_pixel[18]_syn_346 ),
    .f(\O_pixel[18]_syn_400 ),
    .o(\O_pixel[18]_syn_402 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(C*~(D*~B*~A))"),
    .INIT(16'he0f0))
    \O_pixel[18]_syn_403  (
    .a(\O_pixel[18]_syn_271 ),
    .b(\O_pixel[18]_syn_40 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(\O_pixel[18]_syn_148 ),
    .o(\O_pixel[18]_syn_404 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(B*~((D*C))*~(E)+B*(D*C)*~(E)+~(B)*(D*C)*E+B*(D*C)*E))"),
    .INIT(32'h05551111))
    \O_pixel[18]_syn_405  (
    .a(\O_pixel[18]_syn_4 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(read_address[0]),
    .e(read_address[1]),
    .o(\O_pixel[18]_syn_406 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((~C*~B)*~(D)*~(A)+(~C*~B)*D*~(A)+~((~C*~B))*D*A+(~C*~B)*D*A)"),
    .INIT(16'h54fe))
    \O_pixel[18]_syn_407  (
    .a(\O_pixel[18]_syn_6 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_120 ),
    .d(read_address[2]),
    .o(\O_pixel[18]_syn_408 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*E*~(~C*~A*~(D*~B)))"),
    .INIT(64'hfbfa000000000000))
    \O_pixel[18]_syn_409  (
    .a(\O_pixel[18]_syn_404 ),
    .b(\O_pixel[18]_syn_406 ),
    .c(\O_pixel[18]_syn_408 ),
    .d(\O_pixel[18]_syn_146 ),
    .e(\O_pixel[18]_syn_84 ),
    .f(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_410 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+A*B*~(C)+~(A)*~(B)*C+A*B*C)"),
    .INIT(8'h9b))
    \O_pixel[18]_syn_41  (
    .a(\O_pixel[18]_syn_40 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_42 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(B*~(~C*A))"),
    .INIT(8'hc4))
    \O_pixel[18]_syn_411  (
    .a(\O_pixel[18]_syn_328 ),
    .b(\O_pixel[18]_syn_78 ),
    .c(read_address[1]),
    .o(\O_pixel[18]_syn_412 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~C*(~(A)*~(B)*D*E*~(F)+A*~(B)*D*E*~(F)+~(A)*~(B)*~(D)*~(E)*F+A*~(B)*~(D)*~(E)*F+~(A)*B*~(D)*~(E)*F))"),
    .INIT(64'h0000000703000000))
    \O_pixel[18]_syn_413  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_414 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_415  (
    .a(\O_pixel[18]_syn_328 ),
    .b(\O_pixel[18]_syn_414 ),
    .o(\O_pixel[18]_syn_416 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(D*C*~(~E*~B*~A))"),
    .INIT(32'hf000e000))
    \O_pixel[18]_syn_417  (
    .a(\O_pixel[18]_syn_412 ),
    .b(\O_pixel[18]_syn_416 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_166 ),
    .e(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_418 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_419  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_420 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_421  (
    .a(\O_pixel[18]_syn_72 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_422 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+~(A)*B*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'ha00cccccccccccc0))
    \O_pixel[18]_syn_423  (
    .a(\O_pixel[18]_syn_6 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_424 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~B*~(C*A))"),
    .INIT(8'h13))
    \O_pixel[18]_syn_425  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_158 ),
    .o(\O_pixel[18]_syn_426 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*~(D*~C*B))"),
    .INIT(16'ha2aa))
    \O_pixel[18]_syn_427  (
    .a(\O_pixel[18]_syn_420 ),
    .b(\O_pixel[18]_syn_422 ),
    .c(\O_pixel[18]_syn_424 ),
    .d(\O_pixel[18]_syn_426 ),
    .o(\O_pixel[18]_syn_428 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_429  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_324 ),
    .o(\O_pixel[18]_syn_430 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(D*~(E*~C*~B*~A))"),
    .INIT(32'hfe00ff00))
    \O_pixel[18]_syn_43  (
    .a(\O_pixel[18]_syn_24 ),
    .b(\O_pixel[18]_syn_26 ),
    .c(\O_pixel[18]_syn_32 ),
    .d(\O_pixel[18]_syn_38 ),
    .e(\O_pixel[18]_syn_42 ),
    .o(\O_pixel[18]_syn_44 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_431  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_432 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(D*~(A)*~(C)+D*A*~(C)+~(D)*A*C+D*A*C))"),
    .INIT(16'h1013))
    \O_pixel[18]_syn_433  (
    .a(\O_pixel[18]_syn_328 ),
    .b(\O_pixel[18]_syn_217 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_158 ),
    .o(\O_pixel[18]_syn_434 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*~C*B*A)"),
    .INIT(32'h08000000))
    \O_pixel[18]_syn_435  (
    .a(read_address[3]),
    .b(read_address[4]),
    .c(read_address[5]),
    .d(read_address[6]),
    .e(read_address[7]),
    .o(\O_pixel[18]_syn_436 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+~(A)*B*~(C)+A*~(B)*C+~(A)*B*C)"),
    .INIT(8'h67))
    \O_pixel[18]_syn_437  (
    .a(\O_pixel[18]_syn_14 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(\O_pixel[18]_syn_436 ),
    .o(\O_pixel[18]_syn_438 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_439  (
    .a(\O_pixel[18]_syn_64 ),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_440 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+A*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+A*~(B)*~(C)*~(D)*~(E)*F+~(A)*~(B)*C*~(D)*~(E)*F+A*~(B)*C*~(D)*~(E)*F+~(A)*~(B)*~(C)*D*~(E)*F+A*~(B)*~(C)*D*~(E)*F+~(A)*~(B)*C*D*~(E)*F+A*~(B)*C*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+A*~(B)*~(C)*~(D)*E*F+~(A)*B*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+~(A)*~(B)*C*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*B*C*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*B*~(C)*D*E*F+A*B*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F+~(A)*B*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'hffff3333311555ff))
    \O_pixel[18]_syn_441  (
    .a(\O_pixel[18]_syn_46 ),
    .b(\O_pixel[18]_syn_98 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_442 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(~(~E*D*C)*B)*~(~F*A))"),
    .INIT(64'h3333f33311115111))
    \O_pixel[18]_syn_443  (
    .a(\O_pixel[18]_syn_430 ),
    .b(\O_pixel[18]_syn_432 ),
    .c(\O_pixel[18]_syn_434 ),
    .d(\O_pixel[18]_syn_438 ),
    .e(\O_pixel[18]_syn_440 ),
    .f(\O_pixel[18]_syn_442 ),
    .o(\O_pixel[18]_syn_444 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_445  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_446 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_447  (
    .a(\O_pixel[18]_syn_324 ),
    .b(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_448 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~(C*B*A))"),
    .INIT(16'h007f))
    \O_pixel[18]_syn_449  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_450 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_45  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_46 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_451  (
    .a(\O_pixel[18]_syn_22 ),
    .b(\O_pixel[18]_syn_30 ),
    .c(\O_pixel[18]_syn_450 ),
    .o(\O_pixel[18]_syn_452 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~((D*C))*~(E)+A*~(B)*~((D*C))*~(E)+~(A)*B*~((D*C))*~(E)+A*B*~((D*C))*~(E)+~(A)*~(B)*(D*C)*~(E)+~(A)*B*(D*C)*~(E)+~(A)*~(B)*~((D*C))*E+~(A)*~(B)*(D*C)*E)"),
    .INIT(32'h11115fff))
    \O_pixel[18]_syn_453  (
    .a(\O_pixel[18]_syn_20 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(read_address[1]),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_454 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(D*((B*~A)*~(C)*~(E)+~((B*~A))*C*~(E)+(B*~A)*C*~(E)+(B*~A)*C*E))"),
    .INIT(32'h4000f400))
    \O_pixel[18]_syn_455  (
    .a(\O_pixel[18]_syn_328 ),
    .b(read_address[4]),
    .c(read_address[5]),
    .d(read_address[6]),
    .e(read_address[7]),
    .o(\O_pixel[18]_syn_456 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+A*B*C*~(D)*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h4eee0eae))
    \O_pixel[18]_syn_457  (
    .a(\O_pixel[18]_syn_446 ),
    .b(\O_pixel[18]_syn_448 ),
    .c(\O_pixel[18]_syn_452 ),
    .d(\O_pixel[18]_syn_454 ),
    .e(\O_pixel[18]_syn_456 ),
    .o(\O_pixel[18]_syn_458 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*D*~C*~B*~A)"),
    .INIT(32'h00000100))
    \O_pixel[18]_syn_459  (
    .a(\O_pixel[18]_syn_410 ),
    .b(\O_pixel[18]_syn_418 ),
    .c(\O_pixel[18]_syn_428 ),
    .d(\O_pixel[18]_syn_444 ),
    .e(\O_pixel[18]_syn_458 ),
    .o(\O_pixel[18]_syn_460 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*(B*C*~(D)+~(B)*~(C)*D+B*C*D))"),
    .INIT(16'h8280))
    \O_pixel[18]_syn_461  (
    .a(\O_pixel[18]_syn_378 ),
    .b(\O_pixel[18]_syn_64 ),
    .c(\O_pixel[18]_syn_239 ),
    .d(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_462 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+A*~(B)*C+~(A)*B*C+A*B*C)"),
    .INIT(8'he3))
    \O_pixel[18]_syn_463  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .o(\O_pixel[18]_syn_464 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*B*A)"),
    .INIT(8'h08))
    \O_pixel[18]_syn_465  (
    .a(\O_pixel[18]_syn_172 ),
    .b(\O_pixel[18]_syn_64 ),
    .c(\O_pixel[18]_syn_464 ),
    .o(\O_pixel[18]_syn_466 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(B)*~((C*~A))*~(D)+B*~((C*~A))*~(D)+B*(C*~A)*~(D)+~(B)*~((C*~A))*D+~(B)*(C*~A)*D)"),
    .INIT(16'h33ef))
    \O_pixel[18]_syn_467  (
    .a(\O_pixel[18]_syn_464 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_46 ),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_468 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_469  (
    .a(read_address[1]),
    .b(read_address[2]),
    .o(\O_pixel[18]_syn_470 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_47  (
    .a(\O_pixel[18]_syn_40 ),
    .b(\O_pixel[18]_syn_46 ),
    .o(\O_pixel[18]_syn_48 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_471  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(\O_pixel[18]_syn_470 ),
    .o(\O_pixel[18]_syn_472 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(C*~(~(E*~B)*~(D*~A)))"),
    .INIT(32'h70305000))
    \O_pixel[18]_syn_473  (
    .a(\O_pixel[18]_syn_468 ),
    .b(\O_pixel[18]_syn_472 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_221 ),
    .e(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_474 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_475  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_476 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*A*~(~(~D*C)*~(E*B)))"),
    .INIT(64'h88a800a000000000))
    \O_pixel[18]_syn_477  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_271 ),
    .c(\O_pixel[18]_syn_217 ),
    .d(\O_pixel[18]_syn_297 ),
    .e(\O_pixel[18]_syn_158 ),
    .f(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_478 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h66626762))
    \O_pixel[18]_syn_479  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_14 ),
    .c(\O_pixel[18]_syn_217 ),
    .d(\O_pixel[18]_syn_46 ),
    .e(\O_pixel[18]_syn_148 ),
    .o(\O_pixel[18]_syn_480 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("~(~(C*~(D)*~(B)+C*D*~(B)+~(C)*D*B+C*D*B)*~((~F*E))*~(A)+~(C*~(D)*~(B)+C*D*~(B)+~(C)*D*B+C*D*B)*(~F*E)*~(A)+~(~(C*~(D)*~(B)+C*D*~(B)+~(C)*D*B+C*D*B))*(~F*E)*A+~(C*~(D)*~(B)+C*D*~(B)+~(C)*D*B+C*D*B)*(~F*E)*A)"),
    .INIT(64'hfebafeba5410feba))
    \O_pixel[18]_syn_481  (
    .a(\O_pixel[18]_syn_448 ),
    .b(\O_pixel[18]_syn_476 ),
    .c(\O_pixel[18]_syn_478 ),
    .d(\O_pixel[18]_syn_480 ),
    .e(\O_pixel[18]_syn_374 ),
    .f(\O_pixel[18]_syn_295 ),
    .o(\O_pixel[18]_syn_482 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+A*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+~(A)*B*~(C)*~(D)*~(E)*F+~(A)*~(B)*C*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+~(A)*~(B)*~(C)*D*~(E)*F+~(A)*B*~(C)*D*~(E)*F+~(A)*~(B)*C*D*~(E)*F+~(A)*B*C*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+~(A)*B*~(C)*~(D)*E*F+~(A)*~(B)*C*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*B*C*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*B*~(C)*D*E*F+A*B*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F+~(A)*B*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'hfff55555513333ff))
    \O_pixel[18]_syn_483  (
    .a(\O_pixel[18]_syn_16 ),
    .b(\O_pixel[18]_syn_98 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_484 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~D*~C*~B*~A*~(~F*E))"),
    .INIT(64'h0001000100000001))
    \O_pixel[18]_syn_485  (
    .a(\O_pixel[18]_syn_462 ),
    .b(\O_pixel[18]_syn_466 ),
    .c(\O_pixel[18]_syn_474 ),
    .d(\O_pixel[18]_syn_482 ),
    .e(\O_pixel[18]_syn_334 ),
    .f(\O_pixel[18]_syn_484 ),
    .o(\O_pixel[18]_syn_486 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(~B*~A))"),
    .INIT(8'h0e))
    \O_pixel[18]_syn_487  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_488 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_489  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_186 ),
    .c(\O_pixel[18]_syn_488 ),
    .d(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_490 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*B*~A)"),
    .INIT(8'h04))
    \O_pixel[18]_syn_49  (
    .a(read_address[12]),
    .b(read_address[13]),
    .c(read_address[14]),
    .o(\O_pixel[18]_syn_50 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*~(~B*~A))"),
    .INIT(32'he0000000))
    \O_pixel[18]_syn_491  (
    .a(\O_pixel[18]_syn_182 ),
    .b(\O_pixel[18]_syn_242 ),
    .c(\O_pixel[18]_syn_10 ),
    .d(\O_pixel[18]_syn_84 ),
    .e(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_492 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_493  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_192 ),
    .c(\O_pixel[18]_syn_324 ),
    .d(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_494 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_495  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_4 ),
    .o(\O_pixel[18]_syn_496 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(~D*~C*~B)*~(E)*~(A)+~(~D*~C*~B)*E*~(A)+~(~(~D*~C*~B))*E*A+~(~D*~C*~B)*E*A)"),
    .INIT(32'hfffe5554))
    \O_pixel[18]_syn_497  (
    .a(\O_pixel[18]_syn_432 ),
    .b(\O_pixel[18]_syn_490 ),
    .c(\O_pixel[18]_syn_492 ),
    .d(\O_pixel[18]_syn_494 ),
    .e(\O_pixel[18]_syn_496 ),
    .o(\O_pixel[18]_syn_498 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_499  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_170 ),
    .o(\O_pixel[18]_syn_500 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \O_pixel[18]_syn_5  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_6 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_501  (
    .a(\O_pixel[18]_syn_217 ),
    .b(\O_pixel[18]_syn_84 ),
    .c(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_502 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_503  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_20 ),
    .o(\O_pixel[18]_syn_504 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_505  (
    .a(\O_pixel[18]_syn_271 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_506 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_507  (
    .a(\O_pixel[18]_syn_364 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_508 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~B*~(C*A))"),
    .INIT(32'h00000013))
    \O_pixel[18]_syn_509  (
    .a(\O_pixel[18]_syn_500 ),
    .b(\O_pixel[18]_syn_502 ),
    .c(\O_pixel[18]_syn_504 ),
    .d(\O_pixel[18]_syn_506 ),
    .e(\O_pixel[18]_syn_508 ),
    .o(\O_pixel[18]_syn_510 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_51  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_52 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(~(D*C)*~(E*B)))"),
    .INIT(32'ha888a000))
    \O_pixel[18]_syn_511  (
    .a(\O_pixel[18]_syn_70 ),
    .b(\O_pixel[18]_syn_146 ),
    .c(\O_pixel[18]_syn_328 ),
    .d(\O_pixel[18]_syn_46 ),
    .e(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_512 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*C)*~(B*A))"),
    .INIT(16'h0777))
    \O_pixel[18]_syn_513  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_66 ),
    .c(\O_pixel[18]_syn_30 ),
    .d(\O_pixel[18]_syn_194 ),
    .o(\O_pixel[18]_syn_514 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \O_pixel[18]_syn_515  (
    .a(\O_pixel[18]_syn_70 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_516 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_517  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_324 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_194 ),
    .o(\read_address[14]_syn_9262 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*~(~D*C)*~(B*A))"),
    .INIT(64'h0000000000007707))
    \O_pixel[18]_syn_518  (
    .a(\O_pixel[18]_syn_448 ),
    .b(\O_pixel[18]_syn_512 ),
    .c(\O_pixel[18]_syn_134 ),
    .d(\O_pixel[18]_syn_514 ),
    .e(\O_pixel[18]_syn_516 ),
    .f(\read_address[14]_syn_9262 ),
    .o(\O_pixel[18]_syn_519 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \O_pixel[18]_syn_520  (
    .a(read_address[2]),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_521 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \O_pixel[18]_syn_522  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(\O_pixel[18]_syn_521 ),
    .d(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_523 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*~A)"),
    .INIT(16'h0040))
    \O_pixel[18]_syn_524  (
    .a(\O_pixel[18]_syn_498 ),
    .b(\O_pixel[18]_syn_510 ),
    .c(\O_pixel[18]_syn_519 ),
    .d(\O_pixel[18]_syn_523 ),
    .o(\O_pixel[18]_syn_525 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(C*A*~(D@B))"),
    .INIT(16'h8020))
    \O_pixel[18]_syn_526  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_527 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*~E*D*C*B*A)"),
    .INIT(64'h0000800000000000))
    \O_pixel[18]_syn_528  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_209 ),
    .c(\O_pixel[18]_syn_265 ),
    .d(\O_pixel[18]_syn_527 ),
    .e(read_address[0]),
    .f(read_address[1]),
    .o(\O_pixel[18]_syn_529 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_53  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_52 ),
    .o(\O_pixel[18]_syn_54 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_530  (
    .a(\O_pixel[18]_syn_217 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_122 ),
    .o(\O_pixel[18]_syn_531 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \O_pixel[18]_syn_532  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_186 ),
    .c(\O_pixel[18]_syn_328 ),
    .d(\O_pixel[18]_syn_120 ),
    .e(read_address[0]),
    .o(\O_pixel[18]_syn_533 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~C*~A*~(E*D*~B))"),
    .INIT(32'h04050505))
    \O_pixel[18]_syn_534  (
    .a(\O_pixel[18]_syn_529 ),
    .b(\O_pixel[18]_syn_531 ),
    .c(\O_pixel[18]_syn_533 ),
    .d(\O_pixel[18]_syn_84 ),
    .e(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_535 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*A))"),
    .INIT(8'h07))
    \O_pixel[18]_syn_536  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_537 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*A)"),
    .INIT(16'h0080))
    \O_pixel[18]_syn_538  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_52 ),
    .d(\O_pixel[18]_syn_537 ),
    .o(\O_pixel[18]_syn_539 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*B*(C*~(D)*~(A)+C*D*~(A)+~(C)*D*A+C*D*A))"),
    .INIT(32'hc8400000))
    \O_pixel[18]_syn_540  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(\O_pixel[18]_syn_46 ),
    .e(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_541 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*B*(C*~(D)*~(A)+C*D*~(A)+~(C)*D*A+C*D*A))"),
    .INIT(32'hc8400000))
    \O_pixel[18]_syn_542  (
    .a(\O_pixel[18]_syn_199 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_22 ),
    .d(\O_pixel[18]_syn_78 ),
    .e(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_543 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*~(B*A))"),
    .INIT(32'h00000007))
    \O_pixel[18]_syn_544  (
    .a(\O_pixel[18]_syn_378 ),
    .b(\O_pixel[18]_syn_504 ),
    .c(\O_pixel[18]_syn_539 ),
    .d(\O_pixel[18]_syn_541 ),
    .e(\O_pixel[18]_syn_543 ),
    .o(\O_pixel[18]_syn_545 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_546  (
    .a(\O_pixel[18]_syn_192 ),
    .b(\O_pixel[18]_syn_4 ),
    .o(\O_pixel[18]_syn_547 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*A)"),
    .INIT(16'h0080))
    \O_pixel[18]_syn_548  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_78 ),
    .c(\O_pixel[18]_syn_52 ),
    .d(\O_pixel[18]_syn_60 ),
    .o(\O_pixel[18]_syn_549 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*(A*~(B)*~(C)*D*~(E)+A*B*~(C)*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+A*B*C*~(D)*E+A*~(B)*~(C)*D*E+A*B*~(C)*D*E+A*~(B)*C*D*E+A*B*C*D*E))"),
    .INIT(64'h00000000aaaeea00))
    \O_pixel[18]_syn_55  (
    .a(\O_pixel[18]_syn_4 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_56 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_550  (
    .a(\O_pixel[18]_syn_164 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_46 ),
    .d(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_551 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*(A*B*~(C)+~(A)*~(B)*C+A*~(B)*C))"),
    .INIT(16'h0038))
    \O_pixel[18]_syn_552  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_553 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_554  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_553 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_244 ),
    .o(\O_pixel[18]_syn_555 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*~(B*A))"),
    .INIT(32'h00000007))
    \O_pixel[18]_syn_556  (
    .a(\O_pixel[18]_syn_303 ),
    .b(\O_pixel[18]_syn_547 ),
    .c(\O_pixel[18]_syn_549 ),
    .d(\O_pixel[18]_syn_551 ),
    .e(\O_pixel[18]_syn_555 ),
    .o(\O_pixel[18]_syn_557 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*(A*B*~(C)+~(A)*~(B)*C))"),
    .INIT(16'h1800))
    \O_pixel[18]_syn_558  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_559 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_560  (
    .a(\O_pixel[18]_syn_559 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_90 ),
    .d(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_561 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(C*A))"),
    .INIT(16'h135f))
    \O_pixel[18]_syn_562  (
    .a(\O_pixel[18]_syn_40 ),
    .b(\O_pixel[18]_syn_174 ),
    .c(\O_pixel[18]_syn_46 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_563 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_564  (
    .a(\O_pixel[18]_syn_116 ),
    .b(\O_pixel[18]_syn_34 ),
    .c(\O_pixel[18]_syn_221 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_565 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*~A)"),
    .INIT(8'h10))
    \O_pixel[18]_syn_566  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_567 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_568  (
    .a(\O_pixel[18]_syn_186 ),
    .b(\O_pixel[18]_syn_567 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_569 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~B*~(D*~(~E*~C*A)))"),
    .INIT(32'h00330233))
    \O_pixel[18]_syn_57  (
    .a(\O_pixel[18]_syn_18 ),
    .b(\O_pixel[18]_syn_44 ),
    .c(\O_pixel[18]_syn_48 ),
    .d(\O_pixel[18]_syn_54 ),
    .e(\O_pixel[18]_syn_56 ),
    .o(\O_pixel[18]_syn_58 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~A*~(~C*B))"),
    .INIT(32'h00000051))
    \O_pixel[18]_syn_570  (
    .a(\O_pixel[18]_syn_561 ),
    .b(\O_pixel[18]_syn_360 ),
    .c(\O_pixel[18]_syn_563 ),
    .d(\O_pixel[18]_syn_565 ),
    .e(\O_pixel[18]_syn_569 ),
    .o(\O_pixel[18]_syn_571 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_572  (
    .a(\O_pixel[18]_syn_535 ),
    .b(\O_pixel[18]_syn_545 ),
    .c(\O_pixel[18]_syn_557 ),
    .d(\O_pixel[18]_syn_571 ),
    .o(\O_pixel[18]_syn_573 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+A*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+A*~(B)*~(C)*D*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+A*~(B)*~(C)*~(D)*~(E)*F+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+A*~(B)*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+A*~(B)*~(C)*~(D)*E*F+~(A)*~(B)*C*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F)"),
    .INIT(64'h33330a0fffff7777))
    \O_pixel[18]_syn_574  (
    .a(\O_pixel[18]_syn_70 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_4 ),
    .d(\O_pixel[18]_syn_16 ),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_575 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_576  (
    .a(\O_pixel[18]_syn_396 ),
    .b(\O_pixel[18]_syn_120 ),
    .c(read_address[0]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_577 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~A*(B*~(C)*~(D)+B*~(C)*D+~(B)*C*D))"),
    .INIT(16'h1404))
    \O_pixel[18]_syn_578  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_579 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*B))"),
    .INIT(8'h2a))
    \O_pixel[18]_syn_580  (
    .a(\O_pixel[18]_syn_579 ),
    .b(read_address[1]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_581 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(~E*~D*~C*B))"),
    .INIT(32'haaaaaaa2))
    \O_pixel[18]_syn_582  (
    .a(\O_pixel[18]_syn_172 ),
    .b(\O_pixel[18]_syn_575 ),
    .c(\O_pixel[18]_syn_577 ),
    .d(\O_pixel[18]_syn_102 ),
    .e(\O_pixel[18]_syn_581 ),
    .o(\O_pixel[18]_syn_583 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~B*~((E*D)*~(A)*~(C)+(E*D)*A*~(C)+~((E*D))*A*C+(E*D)*A*C))"),
    .INIT(32'h10131313))
    \O_pixel[18]_syn_584  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_46 ),
    .d(\O_pixel[18]_syn_158 ),
    .e(\O_pixel[18]_syn_74 ),
    .o(\O_pixel[18]_syn_585 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[18]_syn_586  (
    .a(\O_pixel[18]_syn_585 ),
    .b(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_587 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*B))"),
    .INIT(8'h15))
    \O_pixel[18]_syn_588  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_66 ),
    .c(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_589 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(~B*~A))"),
    .INIT(16'he000))
    \O_pixel[18]_syn_59  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_60 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~C*A*~(F*~((~E*B))*~(D)+F*(~E*B)*~(D)+~(F)*(~E*B)*D+F*(~E*B)*D))"),
    .INIT(64'h0a0002000a0a020a))
    \O_pixel[18]_syn_590  (
    .a(\O_pixel[18]_syn_589 ),
    .b(\O_pixel[18]_syn_104 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(\O_pixel[18]_syn_22 ),
    .e(read_address[0]),
    .f(\O_pixel[18]_syn_4 ),
    .o(\O_pixel[18]_syn_591 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_592  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_593 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_594  (
    .a(\O_pixel[18]_syn_16 ),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_595 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~A*~(D*~(~F*~E*C*B)))"),
    .INIT(64'h0055005500554055))
    \O_pixel[18]_syn_596  (
    .a(\O_pixel[18]_syn_583 ),
    .b(\O_pixel[18]_syn_587 ),
    .c(\O_pixel[18]_syn_591 ),
    .d(\O_pixel[18]_syn_593 ),
    .e(\O_pixel[18]_syn_404 ),
    .f(\O_pixel[18]_syn_595 ),
    .o(\O_pixel[18]_syn_597 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_598  (
    .a(\O_pixel[18]_syn_96 ),
    .b(\O_pixel[18]_syn_6 ),
    .o(\O_pixel[18]_syn_599 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_600  (
    .a(\O_pixel[18]_syn_324 ),
    .b(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_601 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("~(~(~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E)*~(B)*~(A)+~(~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E)*B*~(A)+~(~(~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E))*B*A+~(~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E)*B*A)"),
    .INIT(32'h72277727))
    \O_pixel[18]_syn_602  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_239 ),
    .c(\O_pixel[18]_syn_20 ),
    .d(\O_pixel[18]_syn_199 ),
    .e(\O_pixel[18]_syn_4 ),
    .o(\O_pixel[18]_syn_603 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(B*~(C*~A))"),
    .INIT(8'h8c))
    \O_pixel[18]_syn_604  (
    .a(\O_pixel[18]_syn_599 ),
    .b(\O_pixel[18]_syn_601 ),
    .c(\O_pixel[18]_syn_603 ),
    .o(\O_pixel[18]_syn_605 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[18]_syn_606  (
    .a(\O_pixel[18]_syn_22 ),
    .b(read_address[1]),
    .o(\O_pixel[18]_syn_607 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_608  (
    .a(read_address[0]),
    .b(read_address[1]),
    .o(\O_pixel[18]_syn_609 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_61  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_10 ),
    .o(\O_pixel[18]_syn_62 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*~(~B*~(F*~((E*C))*~(D)+F*(E*C)*~(D)+~(F)*(E*C)*D+F*(E*C)*D)))"),
    .INIT(64'ha8aa88aaa8888888))
    \O_pixel[18]_syn_610  (
    .a(\O_pixel[18]_syn_156 ),
    .b(\O_pixel[18]_syn_607 ),
    .c(\O_pixel[18]_syn_609 ),
    .d(\O_pixel[18]_syn_146 ),
    .e(\O_pixel[18]_syn_78 ),
    .f(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_611 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(C*A))"),
    .INIT(16'h135f))
    \O_pixel[18]_syn_612  (
    .a(\O_pixel[18]_syn_72 ),
    .b(\O_pixel[18]_syn_239 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_613 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+A*~(B)*~(C)*D*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+A*~(B)*~(C)*~(D)*~(E)*F+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+A*~(B)*C*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F)"),
    .INIT(64'h00000ceeeeeeeaaa))
    \O_pixel[18]_syn_614  (
    .a(\O_pixel[18]_syn_22 ),
    .b(\O_pixel[18]_syn_98 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_615 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(~B*A))"),
    .INIT(16'hd000))
    \O_pixel[18]_syn_616  (
    .a(\O_pixel[18]_syn_613 ),
    .b(\O_pixel[18]_syn_615 ),
    .c(\O_pixel[18]_syn_186 ),
    .d(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_617 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_618  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_221 ),
    .o(\O_pixel[18]_syn_619 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*E*~D*~C*B*A)"),
    .INIT(64'h0008000000000000))
    \O_pixel[18]_syn_620  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_621 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_622  (
    .a(\O_pixel[18]_syn_621 ),
    .b(\O_pixel[18]_syn_158 ),
    .o(\O_pixel[18]_syn_623 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*D*~C*~(~B*~A))"),
    .INIT(64'h0000000000000e00))
    \O_pixel[18]_syn_624  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_625 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*D*C*~(B*A))"),
    .INIT(64'h0000000000007000))
    \O_pixel[18]_syn_626  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_627 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~B*(~(A)*~(C)*~(D)*~(E)+A*~(C)*~(D)*~(E)+~(A)*C*~(D)*~(E)+~(A)*C*D*~(E)+~(A)*~(C)*~(D)*E+A*~(C)*~(D)*E+~(A)*~(C)*D*E+A*~(C)*D*E))"),
    .INIT(32'h03031013))
    \O_pixel[18]_syn_628  (
    .a(\O_pixel[18]_syn_136 ),
    .b(\O_pixel[18]_syn_625 ),
    .c(\O_pixel[18]_syn_120 ),
    .d(\O_pixel[18]_syn_627 ),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_629 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*~A)"),
    .INIT(16'h1000))
    \O_pixel[18]_syn_63  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_64 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(~C*B)*~(D)*~(A)+~(~C*B)*D*~(A)+~(~(~C*B))*D*A+~(~C*B)*D*A)"),
    .INIT(16'hfb51))
    \O_pixel[18]_syn_630  (
    .a(\O_pixel[18]_syn_476 ),
    .b(\O_pixel[18]_syn_619 ),
    .c(\O_pixel[18]_syn_623 ),
    .d(\O_pixel[18]_syn_629 ),
    .o(\O_pixel[18]_syn_631 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_632  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_633 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(~C*~B))"),
    .INIT(8'h54))
    \O_pixel[18]_syn_634  (
    .a(\O_pixel[18]_syn_609 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_635 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+A*B*~(C)+~(A)*~(B)*C+A*B*C)"),
    .INIT(8'h9b))
    \O_pixel[18]_syn_636  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_20 ),
    .o(\O_pixel[18]_syn_637 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(F*E*~(D*~C))*~(B*A))"),
    .INIT(64'h0700777777777777))
    \O_pixel[18]_syn_638  (
    .a(\O_pixel[18]_syn_448 ),
    .b(\O_pixel[18]_syn_633 ),
    .c(\O_pixel[18]_syn_635 ),
    .d(\O_pixel[18]_syn_637 ),
    .e(\O_pixel[18]_syn_50 ),
    .f(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_639 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_640  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_553 ),
    .d(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_641 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*E*D*~C*~B*~A)"),
    .INIT(64'h0000000001000000))
    \O_pixel[18]_syn_642  (
    .a(\O_pixel[18]_syn_605 ),
    .b(\O_pixel[18]_syn_611 ),
    .c(\O_pixel[18]_syn_617 ),
    .d(\O_pixel[18]_syn_631 ),
    .e(\O_pixel[18]_syn_639 ),
    .f(\O_pixel[18]_syn_641 ),
    .o(\O_pixel[18]_syn_643 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*E*D*C*B*A)"),
    .INIT(64'h8000000000000000))
    \O_pixel[18]_syn_644  (
    .a(\O_pixel[18]_syn_460 ),
    .b(\O_pixel[18]_syn_486 ),
    .c(\O_pixel[18]_syn_525 ),
    .d(\O_pixel[18]_syn_573 ),
    .e(\O_pixel[18]_syn_597 ),
    .f(\O_pixel[18]_syn_643 ),
    .o(\O_pixel[18]_syn_645 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(~C*B))"),
    .INIT(8'h51))
    \O_pixel[18]_syn_646  (
    .a(\O_pixel[18]_syn_22 ),
    .b(\O_pixel[18]_syn_98 ),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_647 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~C*~B*~A))"),
    .INIT(16'hfe00))
    \O_pixel[18]_syn_648  (
    .a(\O_pixel[18]_syn_382 ),
    .b(\O_pixel[18]_syn_146 ),
    .c(\O_pixel[18]_syn_104 ),
    .d(\O_pixel[18]_syn_78 ),
    .o(\O_pixel[18]_syn_649 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_65  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_66 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(~B*A))"),
    .INIT(16'hd000))
    \O_pixel[18]_syn_650  (
    .a(\O_pixel[18]_syn_647 ),
    .b(\O_pixel[18]_syn_649 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_221 ),
    .o(\O_pixel[18]_syn_651 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*A))"),
    .INIT(8'h07))
    \O_pixel[18]_syn_652  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .o(\O_pixel[18]_syn_653 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*C*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+A*~(B)*~(C)*D*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*~(B)*~(C)*D*~(E)*F+A*~(B)*~(C)*D*~(E)*F+~(A)*~(B)*C*D*~(E)*F+A*~(B)*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*B*~(C)*D*E*F+A*B*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F+~(A)*B*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'hffaa3300ffff3030))
    \O_pixel[18]_syn_654  (
    .a(\O_pixel[18]_syn_653 ),
    .b(\O_pixel[18]_syn_316 ),
    .c(\O_pixel[18]_syn_16 ),
    .d(\O_pixel[18]_syn_78 ),
    .e(\O_pixel[18]_syn_98 ),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_655 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_656  (
    .a(\O_pixel[18]_syn_655 ),
    .b(\O_pixel[18]_syn_34 ),
    .c(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_657 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_658  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_221 ),
    .o(\O_pixel[18]_syn_659 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_660  (
    .a(\O_pixel[18]_syn_64 ),
    .b(read_address[2]),
    .o(\O_pixel[18]_syn_661 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_662  (
    .a(\O_pixel[18]_syn_96 ),
    .b(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_663 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*~E*(~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D))"),
    .INIT(64'h000001c000000000))
    \O_pixel[18]_syn_664  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_665 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*~A))"),
    .INIT(8'h0b))
    \O_pixel[18]_syn_666  (
    .a(\O_pixel[18]_syn_219 ),
    .b(\O_pixel[18]_syn_158 ),
    .c(\O_pixel[18]_syn_665 ),
    .o(\O_pixel[18]_syn_667 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*A)"),
    .INIT(16'h0200))
    \O_pixel[18]_syn_668  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_669 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_67  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_66 ),
    .o(\O_pixel[18]_syn_68 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(F*D)*~(E*~B)*~(C*A))"),
    .INIT(64'h004c005f4c4c5f5f))
    \O_pixel[18]_syn_670  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_653 ),
    .c(\O_pixel[18]_syn_291 ),
    .d(\O_pixel[18]_syn_16 ),
    .e(\O_pixel[18]_syn_669 ),
    .f(\O_pixel[18]_syn_194 ),
    .o(\O_pixel[18]_syn_671 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(~(F*E)*B)*~(~(~D*~C)*A))"),
    .INIT(64'h555f111311131113))
    \O_pixel[18]_syn_672  (
    .a(\O_pixel[18]_syn_476 ),
    .b(\O_pixel[18]_syn_659 ),
    .c(\O_pixel[18]_syn_661 ),
    .d(\O_pixel[18]_syn_663 ),
    .e(\O_pixel[18]_syn_667 ),
    .f(\O_pixel[18]_syn_671 ),
    .o(\O_pixel[18]_syn_673 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_674  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_244 ),
    .o(\O_pixel[18]_syn_675 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'he07f))
    \O_pixel[18]_syn_676  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_677 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((D*~C)*~(B)*~(A)+(D*~C)*B*~(A)+~((D*~C))*B*A+(D*~C)*B*A)"),
    .INIT(16'h7277))
    \O_pixel[18]_syn_678  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_40 ),
    .c(\O_pixel[18]_syn_677 ),
    .d(\O_pixel[18]_syn_46 ),
    .o(\O_pixel[18]_syn_679 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_680  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_681 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*B))"),
    .INIT(8'h15))
    \O_pixel[18]_syn_682  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_277 ),
    .c(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_683 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_684  (
    .a(\O_pixel[18]_syn_464 ),
    .b(\O_pixel[18]_syn_436 ),
    .o(\O_pixel[18]_syn_685 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(~C*B)*~(~(~F*E*~D)*A))"),
    .INIT(64'h5151515151f35151))
    \O_pixel[18]_syn_686  (
    .a(\O_pixel[18]_syn_303 ),
    .b(\O_pixel[18]_syn_675 ),
    .c(\O_pixel[18]_syn_679 ),
    .d(\O_pixel[18]_syn_681 ),
    .e(\O_pixel[18]_syn_683 ),
    .f(\O_pixel[18]_syn_685 ),
    .o(\O_pixel[18]_syn_687 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_688  (
    .a(\O_pixel[18]_syn_14 ),
    .b(\O_pixel[18]_syn_78 ),
    .c(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_689 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_69  (
    .a(read_address[0]),
    .b(read_address[1]),
    .o(\O_pixel[18]_syn_70 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[18]_syn_690  (
    .a(\O_pixel[18]_syn_6 ),
    .b(read_address[3]),
    .o(\O_pixel[18]_syn_691 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(C*A))"),
    .INIT(16'h135f))
    \O_pixel[18]_syn_692  (
    .a(\O_pixel[18]_syn_104 ),
    .b(\O_pixel[18]_syn_66 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_158 ),
    .o(\O_pixel[18]_syn_693 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+A*B*C*D*E)"),
    .INIT(32'hbb1377ff))
    \O_pixel[18]_syn_694  (
    .a(\O_pixel[18]_syn_396 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(read_address[0]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_695 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(~(F*E)*B)*~(~(~D*C)*A))"),
    .INIT(64'h55f5113111311131))
    \O_pixel[18]_syn_696  (
    .a(\O_pixel[18]_syn_334 ),
    .b(\O_pixel[18]_syn_336 ),
    .c(\O_pixel[18]_syn_689 ),
    .d(\O_pixel[18]_syn_691 ),
    .e(\O_pixel[18]_syn_693 ),
    .f(\O_pixel[18]_syn_695 ),
    .o(\O_pixel[18]_syn_697 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*~B*~A)"),
    .INIT(32'h10000000))
    \O_pixel[18]_syn_698  (
    .a(\O_pixel[18]_syn_651 ),
    .b(\O_pixel[18]_syn_657 ),
    .c(\O_pixel[18]_syn_673 ),
    .d(\O_pixel[18]_syn_687 ),
    .e(\O_pixel[18]_syn_697 ),
    .o(\O_pixel[18]_syn_699 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(B)*~(C)*~(D)*~((~E*A))*~(F)+B*~(C)*~(D)*~((~E*A))*~(F)+~(B)*C*~(D)*~((~E*A))*~(F)+B*C*~(D)*~((~E*A))*~(F)+~(B)*~(C)*D*~((~E*A))*~(F)+B*~(C)*D*~((~E*A))*~(F)+~(B)*C*D*~((~E*A))*~(F)+~(B)*~(C)*~(D)*(~E*A)*~(F)+B*~(C)*~(D)*(~E*A)*~(F)+~(B)*~(C)*D*(~E*A)*~(F)+B*~(C)*D*(~E*A)*~(F)+~(B)*C*D*(~E*A)*~(F)+~(B)*~(C)*~(D)*~((~E*A))*F+~(B)*C*~(D)*~((~E*A))*F+~(B)*~(C)*D*~((~E*A))*F+~(B)*C*D*~((~E*A))*F+~(B)*~(C)*D*(~E*A)*F+~(B)*C*D*(~E*A)*F)"),
    .INIT(64'h333333113fff3f5f))
    \O_pixel[18]_syn_7  (
    .a(\O_pixel[18]_syn_4 ),
    .b(\O_pixel[18]_syn_6 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_8 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_700  (
    .a(\O_pixel[18]_syn_90 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_701 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_702  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_244 ),
    .o(\O_pixel[18]_syn_703 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_704  (
    .a(\O_pixel[18]_syn_90 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_705 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_706  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_707 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_708  (
    .a(\O_pixel[18]_syn_701 ),
    .b(\O_pixel[18]_syn_703 ),
    .c(\O_pixel[18]_syn_705 ),
    .d(\O_pixel[18]_syn_707 ),
    .o(\O_pixel[18]_syn_709 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~C*~(B*A)))"),
    .INIT(16'hf800))
    \O_pixel[18]_syn_71  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_72 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \O_pixel[18]_syn_710  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_217 ),
    .c(\O_pixel[18]_syn_248 ),
    .d(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_711 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*B))"),
    .INIT(8'h15))
    \O_pixel[18]_syn_712  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_382 ),
    .c(\O_pixel[18]_syn_16 ),
    .o(\O_pixel[18]_syn_713 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \O_pixel[18]_syn_714  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_715 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_716  (
    .a(\O_pixel[18]_syn_158 ),
    .b(\O_pixel[18]_syn_84 ),
    .c(\O_pixel[18]_syn_170 ),
    .d(\O_pixel[18]_syn_715 ),
    .o(\O_pixel[18]_syn_717 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~((~D*~B)*~(C)*~(A)+(~D*~B)*C*~(A)+~((~D*~B))*C*A+(~D*~B)*C*A)"),
    .INIT(16'h5f4e))
    \O_pixel[18]_syn_718  (
    .a(\O_pixel[18]_syn_420 ),
    .b(\O_pixel[18]_syn_711 ),
    .c(\O_pixel[18]_syn_713 ),
    .d(\O_pixel[18]_syn_717 ),
    .o(\O_pixel[18]_syn_719 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_720  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_70 ),
    .c(\O_pixel[18]_syn_217 ),
    .d(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_721 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_722  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_324 ),
    .c(\O_pixel[18]_syn_30 ),
    .d(\O_pixel[18]_syn_715 ),
    .o(\O_pixel[18]_syn_723 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*D*C*B*A)"),
    .INIT(32'h00008000))
    \O_pixel[18]_syn_724  (
    .a(\O_pixel[18]_syn_182 ),
    .b(\O_pixel[18]_syn_217 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_221 ),
    .e(read_address[0]),
    .o(\O_pixel[18]_syn_725 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \O_pixel[18]_syn_726  (
    .a(\O_pixel[18]_syn_721 ),
    .b(\O_pixel[18]_syn_723 ),
    .c(\O_pixel[18]_syn_725 ),
    .o(\O_pixel[18]_syn_727 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_728  (
    .a(\O_pixel[18]_syn_146 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_170 ),
    .d(\O_pixel[18]_syn_22 ),
    .o(\O_pixel[18]_syn_729 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(B*A))"),
    .INIT(16'h7000))
    \O_pixel[18]_syn_73  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_74 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_730  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_140 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_731 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_732  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_567 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_52 ),
    .o(\O_pixel[18]_syn_733 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_734  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_242 ),
    .c(\O_pixel[18]_syn_120 ),
    .d(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_735 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_736  (
    .a(\O_pixel[18]_syn_729 ),
    .b(\O_pixel[18]_syn_731 ),
    .c(\O_pixel[18]_syn_733 ),
    .d(\O_pixel[18]_syn_735 ),
    .o(\O_pixel[18]_syn_737 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_738  (
    .a(\O_pixel[18]_syn_20 ),
    .b(\O_pixel[18]_syn_225 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_244 ),
    .o(\O_pixel[18]_syn_739 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_740  (
    .a(\O_pixel[18]_syn_40 ),
    .b(\O_pixel[18]_syn_217 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_741 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_742  (
    .a(\O_pixel[18]_syn_739 ),
    .b(\O_pixel[18]_syn_741 ),
    .o(\O_pixel[18]_syn_743 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_744  (
    .a(\O_pixel[18]_syn_46 ),
    .b(\O_pixel[18]_syn_34 ),
    .c(\O_pixel[18]_syn_170 ),
    .o(\O_pixel[18]_syn_745 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*E*D*C*~B*A)"),
    .INIT(64'h0000000020000000))
    \O_pixel[18]_syn_746  (
    .a(\O_pixel[18]_syn_709 ),
    .b(\O_pixel[18]_syn_719 ),
    .c(\O_pixel[18]_syn_727 ),
    .d(\O_pixel[18]_syn_737 ),
    .e(\O_pixel[18]_syn_743 ),
    .f(\O_pixel[18]_syn_745 ),
    .o(\O_pixel[18]_syn_747 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~(C*B*~A))"),
    .INIT(16'h00bf))
    \O_pixel[18]_syn_748  (
    .a(\O_pixel[18]_syn_70 ),
    .b(\O_pixel[18]_syn_146 ),
    .c(\O_pixel[18]_syn_22 ),
    .d(\O_pixel[18]_syn_78 ),
    .o(\O_pixel[18]_syn_749 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(D*~C)*~(E*~B*A))"),
    .INIT(32'hd0ddf0ff))
    \O_pixel[18]_syn_75  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_70 ),
    .c(\O_pixel[18]_syn_72 ),
    .d(\O_pixel[18]_syn_6 ),
    .e(\O_pixel[18]_syn_74 ),
    .o(\O_pixel[18]_syn_76 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*~(~D*~C*B))"),
    .INIT(16'haaa2))
    \O_pixel[18]_syn_750  (
    .a(\O_pixel[18]_syn_394 ),
    .b(\O_pixel[18]_syn_749 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_751 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_752  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_34 ),
    .c(\O_pixel[18]_syn_36 ),
    .d(\O_pixel[18]_syn_148 ),
    .o(\O_pixel[18]_syn_753 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~C*A*~(D@B))"),
    .INIT(16'h0802))
    \O_pixel[18]_syn_754  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_755 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*D*A*~(~C*~B))"),
    .INIT(32'ha8000000))
    \O_pixel[18]_syn_756  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_209 ),
    .c(\O_pixel[18]_syn_567 ),
    .d(\O_pixel[18]_syn_229 ),
    .e(\O_pixel[18]_syn_755 ),
    .o(\O_pixel[18]_syn_757 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_758  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_170 ),
    .c(\O_pixel[18]_syn_436 ),
    .o(\O_pixel[18]_syn_759 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(A)*~(B)+~C*A*~(B)+~(~C)*A*B+~C*A*B)"),
    .INIT(8'h8b))
    \O_pixel[18]_syn_760  (
    .a(\O_pixel[18]_syn_188 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_761 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~C*~B*~A*~(F*E*~D))"),
    .INIT(64'h0100010101010101))
    \O_pixel[18]_syn_762  (
    .a(\O_pixel[18]_syn_753 ),
    .b(\O_pixel[18]_syn_757 ),
    .c(\O_pixel[18]_syn_759 ),
    .d(\O_pixel[18]_syn_761 ),
    .e(\O_pixel[18]_syn_34 ),
    .f(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_763 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*B))"),
    .INIT(8'h15))
    \O_pixel[18]_syn_764  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(\O_pixel[18]_syn_66 ),
    .o(\O_pixel[18]_syn_765 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'h1b))
    \O_pixel[18]_syn_766  (
    .a(\O_pixel[18]_syn_297 ),
    .b(\O_pixel[18]_syn_6 ),
    .c(\O_pixel[18]_syn_46 ),
    .o(\O_pixel[18]_syn_767 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*C*(~(A)*B*~(D)+A*~(B)*D+~(A)*B*D))"),
    .INIT(32'h60400000))
    \O_pixel[18]_syn_768  (
    .a(\O_pixel[18]_syn_96 ),
    .b(\O_pixel[18]_syn_16 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_120 ),
    .e(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_769 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*A)"),
    .INIT(16'h0080))
    \O_pixel[18]_syn_77  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_78 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("((~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E)*~(A)*~(B)+(~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E)*A*~(B)+~((~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E))*A*B+(~(C)*~(D)*~(E)+~(C)*D*~(E)+C*D*~(E)+~(C)*~(D)*E+C*D*E)*A*B)"),
    .INIT(32'hb88bbb8b))
    \O_pixel[18]_syn_770  (
    .a(\O_pixel[18]_syn_765 ),
    .b(\O_pixel[18]_syn_448 ),
    .c(\O_pixel[18]_syn_675 ),
    .d(\O_pixel[18]_syn_767 ),
    .e(\O_pixel[18]_syn_769 ),
    .o(\O_pixel[18]_syn_771 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_772  (
    .a(\O_pixel[18]_syn_242 ),
    .b(\O_pixel[18]_syn_20 ),
    .o(\O_pixel[18]_syn_773 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \O_pixel[18]_syn_774  (
    .a(\O_pixel[18]_syn_96 ),
    .b(\O_pixel[18]_syn_90 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_775 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(E*D*C)*~(F*B*A))"),
    .INIT(64'h077777770fffffff))
    \O_pixel[18]_syn_776  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(\O_pixel[18]_syn_34 ),
    .e(\O_pixel[18]_syn_244 ),
    .f(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_777 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*(B@A))"),
    .INIT(8'h60))
    \O_pixel[18]_syn_778  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_779 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~C*~(E*~D)*~(B*A))"),
    .INIT(32'h07000707))
    \O_pixel[18]_syn_780  (
    .a(\O_pixel[18]_syn_362 ),
    .b(\O_pixel[18]_syn_773 ),
    .c(\O_pixel[18]_syn_775 ),
    .d(\O_pixel[18]_syn_777 ),
    .e(\O_pixel[18]_syn_779 ),
    .o(\O_pixel[18]_syn_781 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*C)*~(B*A))"),
    .INIT(16'h0777))
    \O_pixel[18]_syn_782  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_14 ),
    .c(\O_pixel[18]_syn_10 ),
    .d(\O_pixel[18]_syn_66 ),
    .o(\O_pixel[18]_syn_783 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D*C*B*~A*~(F*~E))"),
    .INIT(64'h4000000040004000))
    \O_pixel[18]_syn_784  (
    .a(\O_pixel[18]_syn_751 ),
    .b(\O_pixel[18]_syn_763 ),
    .c(\O_pixel[18]_syn_771 ),
    .d(\O_pixel[18]_syn_781 ),
    .e(\O_pixel[18]_syn_783 ),
    .f(\O_pixel[18]_syn_54 ),
    .o(\O_pixel[18]_syn_785 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+~(A)*B*~(C)+~(A)*~(B)*C+A*~(B)*C+A*B*C)"),
    .INIT(8'hb5))
    \O_pixel[18]_syn_786  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_787 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \O_pixel[18]_syn_788  (
    .a(\O_pixel[18]_syn_305 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_787 ),
    .o(\O_pixel[18]_syn_789 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*A)"),
    .INIT(16'h0200))
    \O_pixel[18]_syn_79  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_80 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(E*D*C*B))"),
    .INIT(32'h15555555))
    \O_pixel[18]_syn_790  (
    .a(\O_pixel[18]_syn_217 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(read_address[0]),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_791 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_792  (
    .a(\O_pixel[18]_syn_136 ),
    .b(\O_pixel[18]_syn_78 ),
    .o(\O_pixel[18]_syn_793 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*E*D*~C*B*A)"),
    .INIT(64'h0000000008000000))
    \O_pixel[18]_syn_794  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_795 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(C*B)*~(~D*A))"),
    .INIT(16'h3f15))
    \O_pixel[18]_syn_796  (
    .a(\O_pixel[18]_syn_78 ),
    .b(\O_pixel[18]_syn_795 ),
    .c(read_address[1]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_797 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+~(A)*B*~(C)+A*~(B)*C+~(A)*B*C)"),
    .INIT(8'h67))
    \O_pixel[18]_syn_798  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_252 ),
    .c(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_799 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*A)"),
    .INIT(16'h2000))
    \O_pixel[18]_syn_800  (
    .a(\O_pixel[18]_syn_791 ),
    .b(\O_pixel[18]_syn_793 ),
    .c(\O_pixel[18]_syn_797 ),
    .d(\O_pixel[18]_syn_799 ),
    .o(\O_pixel[18]_syn_801 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(B*A))"),
    .INIT(16'h7000))
    \O_pixel[18]_syn_802  (
    .a(\O_pixel[18]_syn_789 ),
    .b(\O_pixel[18]_syn_801 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_803 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("((~B*~(D*C))*~(E)*~(A)+(~B*~(D*C))*E*~(A)+~((~B*~(D*C)))*E*A+(~B*~(D*C))*E*A)"),
    .INIT(32'habbb0111))
    \O_pixel[18]_syn_804  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(\O_pixel[18]_syn_217 ),
    .d(\O_pixel[18]_syn_66 ),
    .e(\O_pixel[18]_syn_146 ),
    .o(\O_pixel[18]_syn_805 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+A*B*~(C)*D*E+A*~(B)*C*D*E+A*B*C*D*E)"),
    .INIT(32'habef11ff))
    \O_pixel[18]_syn_806  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_217 ),
    .d(\O_pixel[18]_syn_74 ),
    .e(\O_pixel[18]_syn_122 ),
    .o(\O_pixel[18]_syn_807 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(B*~(~E*D*C*A))"),
    .INIT(32'hcccc4ccc))
    \O_pixel[18]_syn_808  (
    .a(\O_pixel[18]_syn_783 ),
    .b(\O_pixel[18]_syn_336 ),
    .c(\O_pixel[18]_syn_805 ),
    .d(\O_pixel[18]_syn_807 ),
    .e(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_809 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(D*A*(C*~(B)*~(E)+C*B*~(E)+~(C)*B*E+C*B*E))"),
    .INIT(32'h8800a000))
    \O_pixel[18]_syn_81  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(\O_pixel[18]_syn_78 ),
    .d(\O_pixel[18]_syn_80 ),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_82 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E)"),
    .INIT(32'h3ff55555))
    \O_pixel[18]_syn_810  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(read_address[1]),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_811 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(E*~C)*~(D*B))"),
    .INIT(32'h20a022aa))
    \O_pixel[18]_syn_812  (
    .a(\O_pixel[18]_syn_811 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_219 ),
    .d(\O_pixel[18]_syn_225 ),
    .e(\O_pixel[18]_syn_4 ),
    .o(\O_pixel[18]_syn_813 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \O_pixel[18]_syn_814  (
    .a(\O_pixel[18]_syn_4 ),
    .b(read_address[0]),
    .c(read_address[2]),
    .o(\O_pixel[18]_syn_815 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~B*A*~(F*E)*~(D*C))"),
    .INIT(64'h0000022202220222))
    \O_pixel[18]_syn_816  (
    .a(\O_pixel[18]_syn_42 ),
    .b(\O_pixel[18]_syn_815 ),
    .c(\O_pixel[18]_syn_164 ),
    .d(\O_pixel[18]_syn_10 ),
    .e(\O_pixel[18]_syn_20 ),
    .f(\O_pixel[18]_syn_553 ),
    .o(\O_pixel[18]_syn_817 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_818  (
    .a(\O_pixel[18]_syn_28 ),
    .b(\O_pixel[18]_syn_715 ),
    .o(\O_pixel[18]_syn_819 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*A*(B*C*~(D)+~(B)*~(C)*D))"),
    .INIT(32'h00000280))
    \O_pixel[18]_syn_820  (
    .a(\O_pixel[18]_syn_30 ),
    .b(read_address[0]),
    .c(read_address[1]),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_821 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~A*~(E*~(~F*~D*C*B)))"),
    .INIT(64'h0000555500405555))
    \O_pixel[18]_syn_822  (
    .a(\O_pixel[18]_syn_809 ),
    .b(\O_pixel[18]_syn_813 ),
    .c(\O_pixel[18]_syn_817 ),
    .d(\O_pixel[18]_syn_819 ),
    .e(\O_pixel[18]_syn_601 ),
    .f(\O_pixel[18]_syn_821 ),
    .o(\O_pixel[18]_syn_823 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_824  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_825 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*B*(C*~(D)*~(A)+C*D*~(A)+~(C)*D*A+C*D*A))"),
    .INIT(32'hc8400000))
    \O_pixel[18]_syn_826  (
    .a(\O_pixel[18]_syn_14 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_78 ),
    .d(\O_pixel[18]_syn_98 ),
    .e(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_827 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_828  (
    .a(\O_pixel[18]_syn_146 ),
    .b(\O_pixel[18]_syn_34 ),
    .c(\O_pixel[18]_syn_30 ),
    .d(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_829 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*~A)"),
    .INIT(8'h10))
    \O_pixel[18]_syn_83  (
    .a(read_address[12]),
    .b(read_address[13]),
    .c(read_address[14]),
    .o(\O_pixel[18]_syn_84 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_830  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_84 ),
    .c(\O_pixel[18]_syn_229 ),
    .o(\O_pixel[18]_syn_831 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_832  (
    .a(\O_pixel[18]_syn_825 ),
    .b(\O_pixel[18]_syn_827 ),
    .c(\O_pixel[18]_syn_829 ),
    .d(\O_pixel[18]_syn_831 ),
    .o(\O_pixel[18]_syn_833 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_834  (
    .a(\O_pixel[18]_syn_50 ),
    .b(\O_pixel[18]_syn_170 ),
    .c(\O_pixel[18]_syn_78 ),
    .o(\O_pixel[18]_syn_835 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hf31333ff))
    \O_pixel[18]_syn_836  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_20 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .o(\O_pixel[18]_syn_837 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(E*D*C*~B))"),
    .INIT(32'h45555555))
    \O_pixel[18]_syn_838  (
    .a(\O_pixel[18]_syn_835 ),
    .b(\O_pixel[18]_syn_837 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_108 ),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_839 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+A*~(B)*~(C)*D*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+A*~(B)*~(C)*~(D)*~(E)*F+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*~(B)*~(C)*D*~(E)*F+A*~(B)*~(C)*D*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+A*~(B)*~(C)*~(D)*E*F+~(A)*B*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+~(A)*~(B)*C*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*B*C*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F)"),
    .INIT(64'h33ff0f0fff555555))
    \O_pixel[18]_syn_840  (
    .a(\O_pixel[18]_syn_22 ),
    .b(\O_pixel[18]_syn_30 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_841 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_842  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_104 ),
    .c(\O_pixel[18]_syn_50 ),
    .d(\O_pixel[18]_syn_108 ),
    .o(\O_pixel[18]_syn_843 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(B*A*(~E*~(D)*~(C)+~E*D*~(C)+~(~E)*D*C+~E*D*C))"),
    .INIT(32'h80008808))
    \O_pixel[18]_syn_844  (
    .a(\O_pixel[18]_syn_833 ),
    .b(\O_pixel[18]_syn_839 ),
    .c(\O_pixel[18]_syn_134 ),
    .d(\O_pixel[18]_syn_841 ),
    .e(\O_pixel[18]_syn_843 ),
    .o(\O_pixel[18]_syn_845 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*E*~D*C*B*A)"),
    .INIT(64'h0080000000000000))
    \O_pixel[18]_syn_846  (
    .a(\O_pixel[18]_syn_699 ),
    .b(\O_pixel[18]_syn_747 ),
    .c(\O_pixel[18]_syn_785 ),
    .d(\O_pixel[18]_syn_803 ),
    .e(\O_pixel[18]_syn_823 ),
    .f(\O_pixel[18]_syn_845 ),
    .o(\O_pixel[18]_syn_847 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("~(~B*~((~D*~C))*~(A)+~B*(~D*~C)*~(A)+~(~B)*(~D*~C)*A+~B*(~D*~C)*A)"),
    .INIT(16'heee4))
    \O_pixel[18]_syn_848  (
    .a(\O_pixel[18]_syn_66 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(\O_pixel[18]_syn_30 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_849 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*~A)"),
    .INIT(16'h0100))
    \O_pixel[18]_syn_85  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_86 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*B))"),
    .INIT(8'h2a))
    \O_pixel[18]_syn_850  (
    .a(\O_pixel[18]_syn_120 ),
    .b(read_address[2]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_851 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~C*~A*~(~D*B))"),
    .INIT(16'h0501))
    \O_pixel[18]_syn_852  (
    .a(\O_pixel[18]_syn_30 ),
    .b(\O_pixel[18]_syn_78 ),
    .c(\O_pixel[18]_syn_366 ),
    .d(\O_pixel[18]_syn_521 ),
    .o(\O_pixel[18]_syn_853 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[18]_syn_854  (
    .a(\O_pixel[18]_syn_120 ),
    .b(read_address[1]),
    .o(\O_pixel[18]_syn_855 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(C*A))"),
    .INIT(16'h135f))
    \O_pixel[18]_syn_856  (
    .a(\O_pixel[18]_syn_146 ),
    .b(\O_pixel[18]_syn_104 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(\O_pixel[18]_syn_120 ),
    .o(\O_pixel[18]_syn_857 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*E*~D*C*~B*~A)"),
    .INIT(64'h0010000000000000))
    \O_pixel[18]_syn_858  (
    .a(\O_pixel[18]_syn_849 ),
    .b(\O_pixel[18]_syn_851 ),
    .c(\O_pixel[18]_syn_853 ),
    .d(\O_pixel[18]_syn_855 ),
    .e(\O_pixel[18]_syn_765 ),
    .f(\O_pixel[18]_syn_857 ),
    .o(\O_pixel[18]_syn_859 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~B*~(~C*~A))"),
    .INIT(8'h32))
    \O_pixel[18]_syn_860  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_199 ),
    .c(\O_pixel[18]_syn_6 ),
    .o(\O_pixel[18]_syn_861 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*(~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E))"),
    .INIT(64'h000000000ceeccc0))
    \O_pixel[18]_syn_862  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_863 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(C*~B)*~(D*~A))"),
    .INIT(16'h8acf))
    \O_pixel[18]_syn_864  (
    .a(\O_pixel[18]_syn_96 ),
    .b(\O_pixel[18]_syn_199 ),
    .c(\O_pixel[18]_syn_28 ),
    .d(\O_pixel[18]_syn_30 ),
    .o(\O_pixel[18]_syn_865 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(E*D*~C*~B))"),
    .INIT(32'ha8aaaaaa))
    \O_pixel[18]_syn_866  (
    .a(\O_pixel[18]_syn_130 ),
    .b(\O_pixel[18]_syn_861 ),
    .c(\O_pixel[18]_syn_863 ),
    .d(\O_pixel[18]_syn_865 ),
    .e(\O_pixel[18]_syn_340 ),
    .o(\O_pixel[18]_syn_867 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+A*~(B)*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+A*~(B)*C*D*E*~(F)+A*B*C*D*E*~(F)+A*~(B)*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+A*~(B)*C*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+A*~(B)*~(C)*D*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+A*~(B)*C*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+~(A)*B*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*B*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaeeeeeaaaaaaeec))
    \O_pixel[18]_syn_868  (
    .a(\O_pixel[18]_syn_98 ),
    .b(\O_pixel[18]_syn_120 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_869 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~D*~(F*E*~(C*~B*~A)))"),
    .INIT(64'h001000ff00ff00ff))
    \O_pixel[18]_syn_87  (
    .a(\O_pixel[18]_syn_62 ),
    .b(\O_pixel[18]_syn_68 ),
    .c(\O_pixel[18]_syn_76 ),
    .d(\O_pixel[18]_syn_82 ),
    .e(\O_pixel[18]_syn_84 ),
    .f(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_88 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+A*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+A*~(B)*~(C)*D*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+~(A)*B*~(C)*~(D)*~(E)*F+~(A)*~(B)*C*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+~(A)*~(B)*~(C)*D*~(E)*F+~(A)*B*~(C)*D*~(E)*F+~(A)*~(B)*C*D*~(E)*F+~(A)*B*C*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+~(A)*B*~(C)*~(D)*E*F+~(A)*~(B)*C*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*B*C*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*B*~(C)*D*E*F+A*B*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F+~(A)*B*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'hfff555555f33333f))
    \O_pixel[18]_syn_870  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_120 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_871 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(E*~(~(D*~C)*~(F*~(~B*~A))))"),
    .INIT(64'hefee00000f000000))
    \O_pixel[18]_syn_872  (
    .a(\O_pixel[18]_syn_869 ),
    .b(\O_pixel[18]_syn_184 ),
    .c(\O_pixel[18]_syn_871 ),
    .d(\O_pixel[18]_syn_186 ),
    .e(\O_pixel[18]_syn_34 ),
    .f(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_873 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~C*~B*~(E*D*~A))"),
    .INIT(32'h02030303))
    \O_pixel[18]_syn_874  (
    .a(\O_pixel[18]_syn_859 ),
    .b(\O_pixel[18]_syn_867 ),
    .c(\O_pixel[18]_syn_873 ),
    .d(\O_pixel[18]_syn_265 ),
    .e(\O_pixel[18]_syn_84 ),
    .o(\O_pixel[18]_syn_875 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_876  (
    .a(\O_pixel[18]_syn_34 ),
    .b(\O_pixel[18]_syn_244 ),
    .o(\O_pixel[18]_syn_877 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*B*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaa000ccccccccc0))
    \O_pixel[18]_syn_878  (
    .a(\O_pixel[18]_syn_158 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_879 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*~(~B*~(D*~C)))"),
    .INIT(16'h8a88))
    \O_pixel[18]_syn_880  (
    .a(\O_pixel[18]_syn_877 ),
    .b(\O_pixel[18]_syn_879 ),
    .c(\O_pixel[18]_syn_146 ),
    .d(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_881 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(E*C*(A*B*D*~(F)+A*~(B)*~(D)*F+~(A)*B*~(D)*F+A*B*~(D)*F))"),
    .INIT(64'h00e0000080000000))
    \O_pixel[18]_syn_882  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_883 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*~A)"),
    .INIT(16'h0040))
    \O_pixel[18]_syn_884  (
    .a(read_address[0]),
    .b(read_address[4]),
    .c(read_address[5]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_885 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(B*A*(C*~((~E*D))*~(F)+C*(~E*D)*~(F)+~(C)*(~E*D)*F+C*(~E*D)*F))"),
    .INIT(64'h0000880080808080))
    \O_pixel[18]_syn_886  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_170 ),
    .c(\O_pixel[18]_syn_883 ),
    .d(\O_pixel[18]_syn_885 ),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_887 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_888  (
    .a(\O_pixel[18]_syn_242 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_36 ),
    .o(\O_pixel[18]_syn_889 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*~A)"),
    .INIT(16'h0040))
    \O_pixel[18]_syn_89  (
    .a(read_address[8]),
    .b(read_address[9]),
    .c(read_address[10]),
    .d(read_address[11]),
    .o(\O_pixel[18]_syn_90 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+~(A)*B*~(C)+A*~(B)*C+~(A)*B*C)"),
    .INIT(8'h67))
    \O_pixel[18]_syn_890  (
    .a(\O_pixel[18]_syn_199 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_158 ),
    .o(\O_pixel[18]_syn_891 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_892  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_84 ),
    .c(\O_pixel[18]_syn_80 ),
    .d(\O_pixel[18]_syn_779 ),
    .o(\O_pixel[18]_syn_893 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*~D*~A*~(C*~(E*B)))"),
    .INIT(64'h0000000000450005))
    \O_pixel[18]_syn_894  (
    .a(\O_pixel[18]_syn_887 ),
    .b(\O_pixel[18]_syn_438 ),
    .c(\O_pixel[18]_syn_362 ),
    .d(\O_pixel[18]_syn_889 ),
    .e(\O_pixel[18]_syn_891 ),
    .f(\O_pixel[18]_syn_893 ),
    .o(\O_pixel[18]_syn_895 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~A*~((~E*D)*~(C)*~(B)+(~E*D)*C*~(B)+~((~E*D))*C*B+(~E*D)*C*B))"),
    .INIT(32'h15150415))
    \O_pixel[18]_syn_896  (
    .a(\O_pixel[18]_syn_10 ),
    .b(\O_pixel[18]_syn_199 ),
    .c(\O_pixel[18]_syn_4 ),
    .d(\O_pixel[18]_syn_16 ),
    .e(\O_pixel[18]_syn_450 ),
    .o(\O_pixel[18]_syn_897 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \O_pixel[18]_syn_898  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_22 ),
    .o(\O_pixel[18]_syn_899 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \O_pixel[18]_syn_9  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_10 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(~(F*~E)*D)*~(A*~(~C*B)))"),
    .INIT(64'h005d5d5d005d005d))
    \O_pixel[18]_syn_900  (
    .a(\O_pixel[18]_syn_675 ),
    .b(\O_pixel[18]_syn_897 ),
    .c(\O_pixel[18]_syn_599 ),
    .d(\O_pixel[18]_syn_156 ),
    .e(\O_pixel[18]_syn_899 ),
    .f(\O_pixel[18]_syn_857 ),
    .o(\O_pixel[18]_syn_901 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+A*B*~(C)*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'hab45))
    \O_pixel[18]_syn_902  (
    .a(\O_pixel[18]_syn_16 ),
    .b(\O_pixel[18]_syn_98 ),
    .c(\O_pixel[18]_syn_120 ),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_903 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(C*B*~A*~(~E*D))"),
    .INIT(32'h40400040))
    \O_pixel[18]_syn_904  (
    .a(\O_pixel[18]_syn_881 ),
    .b(\O_pixel[18]_syn_895 ),
    .c(\O_pixel[18]_syn_901 ),
    .d(\O_pixel[18]_syn_430 ),
    .e(\O_pixel[18]_syn_903 ),
    .o(\O_pixel[18]_syn_905 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_906  (
    .a(\O_pixel[18]_syn_239 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_80 ),
    .o(\read_address[14]_syn_8266 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \O_pixel[18]_syn_907  (
    .a(\O_pixel[18]_syn_20 ),
    .b(read_address[0]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_908 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~C*(B@A))"),
    .INIT(8'h06))
    \O_pixel[18]_syn_909  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[3]),
    .o(\O_pixel[18]_syn_910 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_91  (
    .a(\O_pixel[18]_syn_90 ),
    .b(\O_pixel[18]_syn_34 ),
    .o(\O_pixel[18]_syn_92 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_911  (
    .a(\O_pixel[18]_syn_910 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_98 ),
    .d(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_912 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*A)"),
    .INIT(16'h0080))
    \O_pixel[18]_syn_913  (
    .a(\O_pixel[18]_syn_4 ),
    .b(\O_pixel[18]_syn_265 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_914 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~B*~(C*A))"),
    .INIT(32'h00000013))
    \O_pixel[18]_syn_915  (
    .a(\O_pixel[18]_syn_378 ),
    .b(\read_address[14]_syn_8266 ),
    .c(\O_pixel[18]_syn_908 ),
    .d(\O_pixel[18]_syn_912 ),
    .e(\O_pixel[18]_syn_914 ),
    .o(\O_pixel[18]_syn_916 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~(B*A))"),
    .INIT(16'h0070))
    \O_pixel[18]_syn_917  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_918 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~(C*B)*~(D*A))"),
    .INIT(16'h153f))
    \O_pixel[18]_syn_919  (
    .a(\O_pixel[18]_syn_242 ),
    .b(\O_pixel[18]_syn_217 ),
    .c(\O_pixel[18]_syn_918 ),
    .d(\O_pixel[18]_syn_158 ),
    .o(\O_pixel[18]_syn_920 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_921  (
    .a(\O_pixel[18]_syn_239 ),
    .b(\O_pixel[18]_syn_50 ),
    .c(\O_pixel[18]_syn_170 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\read_address[14]_syn_3982 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \O_pixel[18]_syn_922  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_90 ),
    .c(\O_pixel[18]_syn_50 ),
    .o(\O_pixel[18]_syn_923 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~C*~B*~(E*D*~A))"),
    .INIT(32'h02030303))
    \O_pixel[18]_syn_924  (
    .a(\O_pixel[18]_syn_920 ),
    .b(\read_address[14]_syn_3982 ),
    .c(\O_pixel[18]_syn_923 ),
    .d(\O_pixel[18]_syn_203 ),
    .e(\O_pixel[18]_syn_80 ),
    .o(\O_pixel[18]_syn_925 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_926  (
    .a(\O_pixel[18]_syn_20 ),
    .b(\O_pixel[18]_syn_84 ),
    .c(\O_pixel[18]_syn_170 ),
    .d(\O_pixel[18]_syn_715 ),
    .o(\O_pixel[18]_syn_927 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*A)"),
    .INIT(16'h2000))
    \O_pixel[18]_syn_928  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_248 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_128 ),
    .o(\O_pixel[18]_syn_929 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_93  (
    .a(\O_pixel[18]_syn_60 ),
    .b(\O_pixel[18]_syn_78 ),
    .o(\O_pixel[18]_syn_94 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \O_pixel[18]_syn_930  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_931 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_932  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_931 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(\O_pixel[18]_syn_229 ),
    .o(\read_address[14]_syn_3090 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \O_pixel[18]_syn_933  (
    .a(\O_pixel[18]_syn_217 ),
    .b(\O_pixel[18]_syn_918 ),
    .c(\O_pixel[18]_syn_34 ),
    .d(\O_pixel[18]_syn_166 ),
    .o(\O_pixel[18]_syn_934 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \O_pixel[18]_syn_935  (
    .a(\O_pixel[18]_syn_927 ),
    .b(\O_pixel[18]_syn_929 ),
    .c(\read_address[14]_syn_3090 ),
    .d(\O_pixel[18]_syn_934 ),
    .o(\O_pixel[18]_syn_936 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(E*C*A*~(D*~B))"),
    .INIT(32'h80a00000))
    \O_pixel[18]_syn_937  (
    .a(\O_pixel[18]_syn_203 ),
    .b(\O_pixel[18]_syn_291 ),
    .c(\O_pixel[18]_syn_140 ),
    .d(\O_pixel[18]_syn_248 ),
    .e(\O_pixel[18]_syn_324 ),
    .o(\O_pixel[18]_syn_938 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \O_pixel[18]_syn_939  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_217 ),
    .c(\O_pixel[18]_syn_84 ),
    .d(\O_pixel[18]_syn_86 ),
    .o(\O_pixel[18]_syn_940 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*C*B*A)"),
    .INIT(32'h00000080))
    \O_pixel[18]_syn_941  (
    .a(\O_pixel[18]_syn_916 ),
    .b(\O_pixel[18]_syn_925 ),
    .c(\O_pixel[18]_syn_936 ),
    .d(\O_pixel[18]_syn_938 ),
    .e(\O_pixel[18]_syn_940 ),
    .o(\O_pixel[18]_syn_942 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+A*B*~(C)+~(A)*~(B)*C+A*B*C)"),
    .INIT(8'h9b))
    \O_pixel[18]_syn_943  (
    .a(\O_pixel[18]_syn_40 ),
    .b(\O_pixel[18]_syn_78 ),
    .c(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_944 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_945  (
    .a(\O_pixel[18]_syn_14 ),
    .b(\O_pixel[18]_syn_10 ),
    .o(\O_pixel[18]_syn_946 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+A*B*C*~(D)*~(E)+A*~(B)*~(C)*D*~(E)+A*B*~(C)*D*~(E)+A*~(B)*C*D*~(E)+A*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+A*B*C*~(D)*E+~(A)*B*~(C)*D*E+~(A)*~(B)*C*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h54baaaaa))
    \O_pixel[18]_syn_947  (
    .a(\O_pixel[18]_syn_6 ),
    .b(\O_pixel[18]_syn_46 ),
    .c(\O_pixel[18]_syn_330 ),
    .d(read_address[2]),
    .e(read_address[3]),
    .o(\O_pixel[18]_syn_948 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(F*C)*~(D*B)*~(E*A))"),
    .INIT(64'h0105030f115533ff))
    \O_pixel[18]_syn_949  (
    .a(\O_pixel[18]_syn_931 ),
    .b(\O_pixel[18]_syn_910 ),
    .c(\O_pixel[18]_syn_16 ),
    .d(\O_pixel[18]_syn_78 ),
    .e(\O_pixel[18]_syn_98 ),
    .f(\O_pixel[18]_syn_74 ),
    .o(\O_pixel[18]_syn_950 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~C*~B*~A))"),
    .INIT(16'hfe00))
    \O_pixel[18]_syn_95  (
    .a(read_address[0]),
    .b(read_address[1]),
    .c(read_address[2]),
    .d(read_address[3]),
    .o(\O_pixel[18]_syn_96 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_951  (
    .a(\O_pixel[18]_syn_559 ),
    .b(\O_pixel[18]_syn_46 ),
    .o(\O_pixel[18]_syn_952 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*~(~F*E*~D*~C*B))"),
    .INIT(64'haaaaaaaaaaa2aaaa))
    \O_pixel[18]_syn_953  (
    .a(\O_pixel[18]_syn_180 ),
    .b(\O_pixel[18]_syn_944 ),
    .c(\O_pixel[18]_syn_946 ),
    .d(\O_pixel[18]_syn_948 ),
    .e(\O_pixel[18]_syn_950 ),
    .f(\O_pixel[18]_syn_952 ),
    .o(\O_pixel[18]_syn_954 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \O_pixel[18]_syn_955  (
    .a(\O_pixel[18]_syn_64 ),
    .b(\O_pixel[18]_syn_10 ),
    .o(\O_pixel[18]_syn_956 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~D*A*(C@B))"),
    .INIT(16'h0028))
    \O_pixel[18]_syn_957  (
    .a(\O_pixel[18]_syn_158 ),
    .b(read_address[0]),
    .c(read_address[1]),
    .d(read_address[2]),
    .o(\O_pixel[18]_syn_958 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+A*~(B)*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*~(B)*C*D*E)"),
    .INIT(32'h2727af0f))
    \O_pixel[18]_syn_959  (
    .a(\O_pixel[18]_syn_146 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_30 ),
    .d(read_address[0]),
    .e(read_address[1]),
    .o(\O_pixel[18]_syn_960 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_961  (
    .a(\O_pixel[18]_syn_164 ),
    .b(\O_pixel[18]_syn_28 ),
    .o(\O_pixel[18]_syn_962 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(B*~(~E*D*~C*A))"),
    .INIT(32'hccccc4cc))
    \O_pixel[18]_syn_963  (
    .a(\O_pixel[18]_syn_956 ),
    .b(\O_pixel[18]_syn_114 ),
    .c(\O_pixel[18]_syn_958 ),
    .d(\O_pixel[18]_syn_960 ),
    .e(\O_pixel[18]_syn_962 ),
    .o(\O_pixel[18]_syn_964 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(C*~(E@D)*~(~B*~A))"),
    .INIT(32'he00000e0))
    \O_pixel[18]_syn_965  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .d(read_address[5]),
    .e(read_address[7]),
    .o(\O_pixel[18]_syn_966 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(C*(B*~(D)*~(A)+B*D*~(A)+~(B)*D*A+B*D*A))"),
    .INIT(16'he040))
    \O_pixel[18]_syn_967  (
    .a(\O_pixel[18]_syn_40 ),
    .b(\O_pixel[18]_syn_966 ),
    .c(read_address[6]),
    .d(\O_pixel[18]_syn_22 ),
    .o(\O_pixel[18]_syn_968 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(D*(A*B*~(C)*~(E)*~(F)+~(A)*B*C*~(E)*~(F)+A*B*C*~(E)*~(F)+A*~(B)*~(C)*E*~(F)+A*B*~(C)*E*~(F)+A*~(B)*C*E*~(F)+~(A)*B*C*E*~(F)+A*B*C*E*~(F)+A*B*~(C)*~(E)*F+~(A)*B*C*~(E)*F+A*B*C*~(E)*F+~(A)*~(B)*~(C)*E*F+A*~(B)*~(C)*E*F+A*B*~(C)*E*F+~(A)*~(B)*C*E*F+A*~(B)*C*E*F+~(A)*B*C*E*F+A*B*C*E*F))"),
    .INIT(64'hfb00c800ea00c800))
    \O_pixel[18]_syn_969  (
    .a(\O_pixel[18]_syn_496 ),
    .b(\O_pixel[18]_syn_968 ),
    .c(\O_pixel[18]_syn_90 ),
    .d(\O_pixel[18]_syn_50 ),
    .e(\O_pixel[18]_syn_221 ),
    .f(\O_pixel[18]_syn_217 ),
    .o(\O_pixel[18]_syn_970 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*~A)"),
    .INIT(16'h0100))
    \O_pixel[18]_syn_97  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_98 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*E*(A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D))"),
    .INIT(64'h0380000000000000))
    \O_pixel[18]_syn_971  (
    .a(read_address[2]),
    .b(read_address[3]),
    .c(read_address[4]),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_972 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(C*(~(A)*B*~(D)+A*~(B)*D))"),
    .INIT(16'h2040))
    \O_pixel[18]_syn_973  (
    .a(read_address[4]),
    .b(read_address[5]),
    .c(read_address[6]),
    .d(read_address[7]),
    .o(\O_pixel[18]_syn_974 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~E*~C*~(D*B)*~(F*A))"),
    .INIT(64'h000001050000030f))
    \O_pixel[18]_syn_975  (
    .a(\O_pixel[18]_syn_277 ),
    .b(\O_pixel[18]_syn_40 ),
    .c(\O_pixel[18]_syn_972 ),
    .d(\O_pixel[18]_syn_78 ),
    .e(\O_pixel[18]_syn_795 ),
    .f(\O_pixel[18]_syn_974 ),
    .o(\O_pixel[18]_syn_976 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+A*~(B)*~(C)+~(A)*B*~(C)+A*~(B)*C+~(A)*B*C)"),
    .INIT(8'h67))
    \O_pixel[18]_syn_977  (
    .a(\O_pixel[18]_syn_188 ),
    .b(\O_pixel[18]_syn_22 ),
    .c(\O_pixel[18]_syn_78 ),
    .o(\O_pixel[18]_syn_978 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+A*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+A*~(B)*~(C)*~(D)*E*~(F)+A*B*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+A*B*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+A*~(B)*~(C)*~(D)*~(E)*F+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*~(B)*~(C)*D*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'h898bcdcf999bdddf))
    \O_pixel[18]_syn_979  (
    .a(\O_pixel[18]_syn_174 ),
    .b(\O_pixel[18]_syn_28 ),
    .c(\O_pixel[18]_syn_158 ),
    .d(\O_pixel[18]_syn_22 ),
    .e(\O_pixel[18]_syn_715 ),
    .f(read_address[2]),
    .o(\O_pixel[18]_syn_980 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(~C*B)*~(~(F*E*D)*A))"),
    .INIT(64'hf351515151515151))
    \O_pixel[18]_syn_981  (
    .a(\O_pixel[18]_syn_500 ),
    .b(\O_pixel[18]_syn_877 ),
    .c(\O_pixel[18]_syn_976 ),
    .d(\O_pixel[18]_syn_693 ),
    .e(\O_pixel[18]_syn_978 ),
    .f(\O_pixel[18]_syn_980 ),
    .o(\O_pixel[18]_syn_982 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+A*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+A*~(B)*~(C)*~(D)*~(E)*F+~(A)*~(B)*C*~(D)*~(E)*F+A*~(B)*C*~(D)*~(E)*F+~(A)*~(B)*~(C)*D*~(E)*F+A*~(B)*~(C)*D*~(E)*F+~(A)*~(B)*C*D*~(E)*F+A*~(B)*C*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+A*~(B)*~(C)*~(D)*E*F+~(A)*B*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+~(A)*~(B)*C*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*B*C*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*B*~(C)*D*E*F+A*B*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F+~(A)*B*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'hfffff333311155ff))
    \O_pixel[18]_syn_983  (
    .a(\O_pixel[18]_syn_140 ),
    .b(\O_pixel[18]_syn_30 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_984 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~((~B*~A))*C*~(D)+~((~B*~A))*~(C)*D+(~B*~A)*~(C)*D)"),
    .INIT(16'h0fe0))
    \O_pixel[18]_syn_985  (
    .a(read_address[1]),
    .b(read_address[2]),
    .c(read_address[3]),
    .d(read_address[4]),
    .o(\O_pixel[18]_syn_986 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(C*B*A*(D*~(E)*~(F)+~(D)*E*F))"),
    .INIT(64'h0080000000008000))
    \O_pixel[18]_syn_987  (
    .a(\O_pixel[18]_syn_84 ),
    .b(\O_pixel[18]_syn_221 ),
    .c(\O_pixel[18]_syn_986 ),
    .d(read_address[5]),
    .e(read_address[6]),
    .f(read_address[7]),
    .o(\O_pixel[18]_syn_988 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(D*C*~A))"),
    .INIT(16'h2333))
    \O_pixel[18]_syn_989  (
    .a(\O_pixel[18]_syn_984 ),
    .b(\O_pixel[18]_syn_988 ),
    .c(\O_pixel[18]_syn_203 ),
    .d(\O_pixel[18]_syn_324 ),
    .o(\O_pixel[18]_syn_990 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT4 #(
    .EQN("(A*~(~B*~(D*~C)))"),
    .INIT(16'h8a88))
    \O_pixel[18]_syn_99  (
    .a(\O_pixel[18]_syn_92 ),
    .b(\O_pixel[18]_syn_94 ),
    .c(\O_pixel[18]_syn_96 ),
    .d(\O_pixel[18]_syn_98 ),
    .o(\O_pixel[18]_syn_100 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~((E*D))+A*~(B)*~(C)*~((E*D))+A*B*~(C)*~((E*D))+A*~(B)*C*~((E*D))+A*B*C*~((E*D))+~(A)*~(B)*~(C)*(E*D)+A*~(B)*C*(E*D)+A*B*C*(E*D))"),
    .INIT(32'ha1ababab))
    \O_pixel[18]_syn_991  (
    .a(\O_pixel[18]_syn_252 ),
    .b(\O_pixel[18]_syn_10 ),
    .c(\O_pixel[18]_syn_6 ),
    .d(\O_pixel[18]_syn_16 ),
    .e(read_address[0]),
    .o(\O_pixel[18]_syn_992 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)*~(F)+A*~(B)*~(C)*~(D)*~(E)*~(F)+~(A)*B*~(C)*~(D)*~(E)*~(F)+A*B*~(C)*~(D)*~(E)*~(F)+~(A)*~(B)*C*~(D)*~(E)*~(F)+A*~(B)*C*~(D)*~(E)*~(F)+~(A)*B*C*~(D)*~(E)*~(F)+A*B*C*~(D)*~(E)*~(F)+~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+~(A)*~(B)*~(C)*~(D)*E*~(F)+~(A)*B*~(C)*~(D)*E*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+~(A)*~(B)*~(C)*D*E*~(F)+~(A)*~(B)*C*D*E*~(F)+~(A)*~(B)*~(C)*~(D)*~(E)*F+~(A)*~(B)*C*~(D)*~(E)*F+A*~(B)*C*~(D)*~(E)*F+~(A)*~(B)*~(C)*D*~(E)*F+A*~(B)*~(C)*D*~(E)*F+~(A)*~(B)*C*D*~(E)*F+A*~(B)*C*D*~(E)*F+~(A)*~(B)*~(C)*~(D)*E*F+A*~(B)*~(C)*~(D)*E*F+~(A)*B*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+~(A)*~(B)*C*~(D)*E*F+A*~(B)*C*~(D)*E*F+~(A)*B*C*~(D)*E*F+A*B*C*~(D)*E*F+~(A)*~(B)*~(C)*D*E*F+A*~(B)*~(C)*D*E*F+~(A)*B*~(C)*D*E*F+A*B*~(C)*D*E*F+~(A)*~(B)*C*D*E*F+A*~(B)*C*D*E*F+~(A)*B*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'hffff333111555fff))
    \O_pixel[18]_syn_993  (
    .a(\O_pixel[18]_syn_20 ),
    .b(\O_pixel[18]_syn_4 ),
    .c(read_address[0]),
    .d(read_address[1]),
    .e(read_address[2]),
    .f(read_address[3]),
    .o(\O_pixel[18]_syn_994 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT5 #(
    .EQN("(D*~(~(C*~B)*~(E*~A)))"),
    .INIT(32'h75003000))
    \O_pixel[18]_syn_995  (
    .a(\O_pixel[18]_syn_992 ),
    .b(\O_pixel[18]_syn_994 ),
    .c(\O_pixel[18]_syn_186 ),
    .d(\O_pixel[18]_syn_50 ),
    .e(\O_pixel[18]_syn_36 ),
    .o(\O_pixel[18]_syn_996 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(~F*E*D*~C*~B*~A)"),
    .INIT(64'h0000000001000000))
    \O_pixel[18]_syn_997  (
    .a(\O_pixel[18]_syn_954 ),
    .b(\O_pixel[18]_syn_964 ),
    .c(\O_pixel[18]_syn_970 ),
    .d(\O_pixel[18]_syn_982 ),
    .e(\O_pixel[18]_syn_990 ),
    .f(\O_pixel[18]_syn_996 ),
    .o(\O_pixel[18]_syn_998 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \O_pixel[18]_syn_999  (
    .a(\O_pixel[18]_syn_378 ),
    .b(\O_pixel[18]_syn_46 ),
    .o(\O_pixel[18]_syn_1000 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("P4"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[19]_syn_2  (
    .doq({open_n645,\O_pixel[19]_dup_1 }),
    .opad(O_pixel[19]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[19]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[19]),
    .c(memory_data[55]),
    .d(memory_data[91]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[19]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*A)"),
    .INIT(4'hd))
    \O_pixel[19]_syn_5  (
    .a(\O_pixel[18]_syn_1131 ),
    .b(\O_pixel[19]_syn_4 ),
    .o(\O_pixel[19]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("E18"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[1]_syn_2  (
    .doq({open_n665,open_n666,open_n667,open_n668,open_n669,open_n670,open_n671,open_n672,open_n673,\O_pixel[1]_dup_1 }),
    .opad(O_pixel[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(~(B)*~(C)*~(D)*~(E)*~(F)+~(B)*C*~(D)*~(E)*~(F)+~(B)*~(C)*D*~(E)*~(F)+~(B)*C*D*~(E)*~(F)+~(B)*~(C)*~(D)*E*~(F)+B*~(C)*~(D)*E*~(F)+~(B)*~(C)*D*E*~(F)+B*~(C)*D*E*~(F)+~(B)*~(C)*~(D)*~(E)*F+B*~(C)*~(D)*~(E)*F+~(B)*C*~(D)*~(E)*F+B*C*~(D)*~(E)*F+~(B)*~(C)*~(D)*E*F+B*~(C)*~(D)*E*F+~(B)*C*~(D)*E*F+B*C*~(D)*E*F+~(B)*~(C)*D*E*F+B*~(C)*D*E*F+~(B)*C*D*E*F+B*C*D*E*F))"),
    .INIT(64'haaaa00aa0a0a2222))
    \O_pixel[1]_syn_3  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(memory_data[1]),
    .c(memory_data[37]),
    .d(memory_data[73]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[1]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[1]_syn_5  (
    .a(\O_pixel[20]_syn_4 ),
    .b(\O_pixel[1]_syn_4 ),
    .o(\O_pixel[1]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("N2"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[20]_syn_2  (
    .doq({open_n730,\O_pixel[20]_dup_1 }),
    .opad(O_pixel[20]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(F*~(~E*D*C*B*A))"),
    .INIT(64'hffff7fff00000000))
    \O_pixel[20]_syn_3  (
    .a(\O_pixel[18]_syn_402 ),
    .b(\O_pixel[18]_syn_645 ),
    .c(\O_pixel[18]_syn_847 ),
    .d(\O_pixel[18]_syn_1030 ),
    .e(\O_pixel[18]_syn_1048 ),
    .f(read_valid),
    .o(\O_pixel[20]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(~(B)*~(C)*~(D)*~(E)*~(F)+~(B)*C*~(D)*~(E)*~(F)+~(B)*~(C)*D*~(E)*~(F)+~(B)*C*D*~(E)*~(F)+~(B)*~(C)*~(D)*E*~(F)+B*~(C)*~(D)*E*~(F)+~(B)*~(C)*D*E*~(F)+B*~(C)*D*E*~(F)+~(B)*~(C)*~(D)*~(E)*F+B*~(C)*~(D)*~(E)*F+~(B)*C*~(D)*~(E)*F+B*C*~(D)*~(E)*F+~(B)*~(C)*~(D)*E*F+B*~(C)*~(D)*E*F+~(B)*C*~(D)*E*F+B*C*~(D)*E*F+~(B)*~(C)*D*E*F+B*~(C)*D*E*F+~(B)*C*D*E*F+B*C*D*E*F))"),
    .INIT(64'haaaa00aa0a0a2222))
    \O_pixel[20]_syn_5  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(memory_data[20]),
    .c(memory_data[56]),
    .d(memory_data[92]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[20]_syn_6 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[20]_syn_7  (
    .a(\O_pixel[20]_syn_4 ),
    .b(\O_pixel[20]_syn_6 ),
    .o(\O_pixel[20]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("N3"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[21]_syn_2  (
    .doq({open_n754,\O_pixel[21]_dup_1 }),
    .opad(O_pixel[21]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[21]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[21]),
    .c(memory_data[57]),
    .d(memory_data[93]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[21]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \O_pixel[21]_syn_5  (
    .a(\O_pixel[18]_syn_1128 ),
    .b(\O_pixel[21]_syn_4 ),
    .o(\O_pixel[21]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("R2"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[22]_syn_2  (
    .doq({open_n778,\O_pixel[22]_dup_1 }),
    .opad(O_pixel[22]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[22]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[22]),
    .c(memory_data[58]),
    .d(memory_data[94]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[22]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \O_pixel[22]_syn_5  (
    .a(\O_pixel[18]_syn_1128 ),
    .b(\O_pixel[22]_syn_4 ),
    .o(\O_pixel[22]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("R1"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[23]_syn_2  (
    .doq({open_n802,\O_pixel[23]_dup_1 }),
    .opad(O_pixel[23]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[23]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[23]),
    .c(memory_data[59]),
    .d(memory_data[95]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[23]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \O_pixel[23]_syn_5  (
    .a(\O_pixel[18]_syn_1128 ),
    .b(\O_pixel[23]_syn_4 ),
    .o(\O_pixel[23]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("P1"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[24]_syn_2  (
    .doq({open_n826,\O_pixel[24]_dup_1 }),
    .opad(O_pixel[24]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \O_pixel[24]_syn_3  (
    .a(\O_pixel[20]_syn_4 ),
    .b(\O_pixel[18]_syn_1128 ),
    .o(\O_pixel[24]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("G16"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[2]_syn_2  (
    .doq({open_n846,open_n847,open_n848,open_n849,open_n850,open_n851,open_n852,open_n853,open_n854,\O_pixel[2]_dup_1 }),
    .opad(O_pixel[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[2]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[2]),
    .c(memory_data[38]),
    .d(memory_data[74]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[2]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*A)"),
    .INIT(4'hd))
    \O_pixel[2]_syn_5  (
    .a(\O_pixel[18]_syn_1131 ),
    .b(\O_pixel[2]_syn_4 ),
    .o(\O_pixel[2]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("J16"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[3]_syn_2  (
    .doq({open_n907,open_n908,open_n909,open_n910,open_n911,open_n912,open_n913,open_n914,open_n915,\O_pixel[3]_dup_1 }),
    .opad(O_pixel[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(~(B)*~(C)*~(D)*~(E)*~(F)+~(B)*C*~(D)*~(E)*~(F)+~(B)*~(C)*D*~(E)*~(F)+~(B)*C*D*~(E)*~(F)+~(B)*~(C)*~(D)*E*~(F)+B*~(C)*~(D)*E*~(F)+~(B)*~(C)*D*E*~(F)+B*~(C)*D*E*~(F)+~(B)*~(C)*~(D)*~(E)*F+B*~(C)*~(D)*~(E)*F+~(B)*C*~(D)*~(E)*F+B*C*~(D)*~(E)*F+~(B)*~(C)*~(D)*E*F+B*~(C)*~(D)*E*F+~(B)*C*~(D)*E*F+B*C*~(D)*E*F+~(B)*~(C)*D*E*F+B*~(C)*D*E*F+~(B)*C*D*E*F+B*C*D*E*F))"),
    .INIT(64'haaaa00aa0a0a2222))
    \O_pixel[3]_syn_3  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(memory_data[3]),
    .c(memory_data[39]),
    .d(memory_data[75]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[3]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[3]_syn_5  (
    .a(\O_pixel[20]_syn_4 ),
    .b(\O_pixel[3]_syn_4 ),
    .o(\O_pixel[3]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("H17"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[4]_syn_2  (
    .doq({open_n968,open_n969,open_n970,open_n971,open_n972,open_n973,open_n974,open_n975,open_n976,\O_pixel[4]_dup_1 }),
    .opad(O_pixel[4]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[4]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[4]),
    .c(memory_data[40]),
    .d(memory_data[76]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[4]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("K17"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[5]_syn_2  (
    .doq({open_n1029,open_n1030,open_n1031,open_n1032,open_n1033,open_n1034,open_n1035,open_n1036,open_n1037,\O_pixel[5]_dup_1 }),
    .opad(O_pixel[5]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[5]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[5]),
    .c(memory_data[41]),
    .d(memory_data[77]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[5]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \O_pixel[5]_syn_5  (
    .a(\O_pixel[18]_syn_1128 ),
    .b(\O_pixel[5]_syn_4 ),
    .o(\O_pixel[5]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("J13"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[6]_syn_2  (
    .doq({open_n1090,open_n1091,open_n1092,open_n1093,open_n1094,open_n1095,open_n1096,open_n1097,open_n1098,\O_pixel[6]_dup_1 }),
    .opad(O_pixel[6]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(~(B)*~(C)*~(D)*~(E)*~(F)+~(B)*C*~(D)*~(E)*~(F)+~(B)*~(C)*D*~(E)*~(F)+~(B)*C*D*~(E)*~(F)+~(B)*~(C)*~(D)*E*~(F)+B*~(C)*~(D)*E*~(F)+~(B)*~(C)*D*E*~(F)+B*~(C)*D*E*~(F)+~(B)*~(C)*~(D)*~(E)*F+B*~(C)*~(D)*~(E)*F+~(B)*C*~(D)*~(E)*F+B*C*~(D)*~(E)*F+~(B)*~(C)*~(D)*E*F+B*~(C)*~(D)*E*F+~(B)*C*~(D)*E*F+B*C*~(D)*E*F+~(B)*~(C)*D*E*F+B*~(C)*D*E*F+~(B)*C*D*E*F+B*C*D*E*F))"),
    .INIT(64'haaaa00aa0a0a2222))
    \O_pixel[6]_syn_3  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(memory_data[6]),
    .c(memory_data[42]),
    .d(memory_data[78]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[6]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[6]_syn_5  (
    .a(\O_pixel[20]_syn_4 ),
    .b(\O_pixel[6]_syn_4 ),
    .o(\O_pixel[6]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HR_PAD_V2 #(
    //.LOCATION("J14"),
    //.ODT("OFF"),
    //.PULL_STRENGTH("25K"),
    //.SLEWRATE("MED"),
    .DIRBYPEN("DISABLE"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .LOWPOWEREN("ENABLE"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("NONE"),
    .TSMUX("0"))
    \O_pixel[7]_syn_2  (
    .doq({open_n1151,open_n1152,open_n1153,open_n1154,open_n1155,open_n1156,open_n1157,open_n1158,open_n1159,\O_pixel[7]_dup_1 }),
    .opad(O_pixel[7]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[7]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[7]),
    .c(memory_data[43]),
    .d(memory_data[79]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[7]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("V1"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[8]_syn_2  (
    .doq({open_n1216,\O_pixel[8]_dup_1 }),
    .opad(O_pixel[8]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(~(B)*~(C)*~(D)*~(E)*~(F)+~(B)*C*~(D)*~(E)*~(F)+~(B)*~(C)*D*~(E)*~(F)+~(B)*C*D*~(E)*~(F)+~(B)*~(C)*~(D)*E*~(F)+B*~(C)*~(D)*E*~(F)+~(B)*~(C)*D*E*~(F)+B*~(C)*D*E*~(F)+~(B)*~(C)*~(D)*~(E)*F+B*~(C)*~(D)*~(E)*F+~(B)*C*~(D)*~(E)*F+B*C*~(D)*~(E)*F+~(B)*~(C)*~(D)*E*F+B*~(C)*~(D)*E*F+~(B)*C*~(D)*E*F+B*C*~(D)*E*F+~(B)*~(C)*D*E*F+B*~(C)*D*E*F+~(B)*C*D*E*F+B*C*D*E*F))"),
    .INIT(64'haaaa00aa0a0a2222))
    \O_pixel[8]_syn_3  (
    .a(\O_pixel[18]_syn_1048 ),
    .b(memory_data[8]),
    .c(memory_data[44]),
    .d(memory_data[80]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[8]_syn_4 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \O_pixel[8]_syn_5  (
    .a(\O_pixel[20]_syn_4 ),
    .b(\O_pixel[8]_syn_4 ),
    .o(\O_pixel[8]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  PH1P_PHY_HD_PAD #(
    //.DRIVE("8"),
    //.LOCATION("U1"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("FAST"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("BYPASS"),
    .ODLYEN("DISABLE"),
    .OTYPE("DIRECTD0"),
    .TSMUX("0"))
    \O_pixel[9]_syn_2  (
    .doq({open_n1240,\O_pixel[9]_dup_1 }),
    .opad(O_pixel[9]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  AL_MAP_LUT6 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)*~(F)+B*C*~(D)*~(E)*~(F)+B*~(C)*D*~(E)*~(F)+B*C*D*~(E)*~(F)+~(B)*C*~(D)*E*~(F)+B*C*~(D)*E*~(F)+~(B)*C*D*E*~(F)+B*C*D*E*~(F)+~(B)*~(C)*D*~(E)*F+B*~(C)*D*~(E)*F+~(B)*C*D*~(E)*F+B*C*D*~(E)*F))"),
    .INIT(64'h0000aa00a0a08888))
    \O_pixel[9]_syn_3  (
    .a(mux2_syn_27),
    .b(memory_data[9]),
    .c(memory_data[45]),
    .d(memory_data[81]),
    .e(read_bank[0]),
    .f(read_bank[1]),
    .o(\O_pixel[9]_dup_1 ));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(8)
  // address_offset=0;data_offset=0;depth=1024;width=16;num_section=1;width_per_section=16;section_size=16;working_depth=1024;working_width=20;working_numbyte=2;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // PH1P_LOGIC_ERAM_Inst_first_high_1024x16
  PH1P_PHY_ERAM_V2 #(
    .ASYNC_RESET_RELEASE_A("ASYNC"),
    .ASYNC_RESET_RELEASE_B("ASYNC"),
    .CLKAMUX("SIG"),
    .CLKBMUX("SIG"),
    .CLKMODE("ASYNC"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("0"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("20"),
    .DATA_WIDTH_B("20"),
    .ECC_DECODE("DISABLE"),
    .ECC_ENCODE("DISABLE"),
    .INITP_00(256'h2232223332007720030111302333326331100111113123313533305313111331),
    .INITP_01(256'h0303301333321313352333022133223031331321113101133103121135123123),
    .INITP_02(256'h7233073737763376303000002013023731711027613101113773107111117603),
    .INITP_03(256'h5533637275541555551755710203200010100121131033321111333055664473),
    .INITP_04(256'h3031230333731123333103775755743555372554277563045753752531622311),
    .INITP_05(256'h5525533470312043113331553331307221112133331015553301163351531144),
    .INITP_06(256'h0117111117617010071071171310177631131011121031011303110107111111),
    .INITP_07(256'h7704777775175103077010072233225533111313113306103333034510311112),
    .INITP_08(256'h7170450177717777710176776760467677756757045565077777557557777577),
    .INITP_09(256'h7302030111076073747757617555674375557745575755756035575075175670),
    .INITP_0A(256'h5445555540452552555545547507466575673745455054757577577355555335),
    .INITP_0B(256'h6577737753355344776577655553375555447550577455055555455570557555),
    .INITP_0C(256'h1310713111111776307071616317774375375677770677347730775517163007),
    .INITP_0D(256'h3170511073311301315334150171111731011133032111113171001723311033),
    .INITP_0E(256'h1001113031112031111111712103701103123132301361713131133073111703),
    .INITP_0F(256'h1010110010111155111111105013041140111334303111111013313030111120),
    .INIT_00(256'h1E3B157E167B1E3E16700000157E1E5C1EBB143B19BD1EBE1EDE1E5E142C1EDB),
    .INIT_01(256'h1E3E1EBD1EBC1EAB1EDC1EDC1EDE19BD1EBE19BB1E3C19AC1E271E5B1E5E1EDE),
    .INIT_02(256'h1EA7143C1ED01EBD1EDD1EA9143C1EC71E271E30167C1E3D1E301E3010D6167D),
    .INIT_03(256'h1E501E4D167D16671E4C1E471E5D143D143D16690000000010DB10DB142E0000),
    .INIT_04(256'h1EBB14BC00001EBE1E9B1D0714BC1E9C1E9D147B16DD1E871E1E1E9E1E901E1B),
    .INIT_05(256'h1EBE16DD1EB71E0F16DC1E1C1EA914BD14BD14A81EBC14BB00001E9B1E9E1E1E),
    .INIT_06(256'h1E9E14661E101E9B1E1D19DD00001E071EA714BB19DC1EBD19C71EB01D1E14B2),
    .INIT_07(256'h1E891E8200001E9E1D1B1E871E9E1D1C19DD1E9C19DE1D1D16DB1D1216C01D0D),
    .INIT_08(256'h1EDB16FE185C1EDE1F3B1F2816FE1F3E1F7E1F5B1F5E1F7B185E16E80000103E),
    .INIT_09(256'h1EDE1F7C185D1F5C1F3E00001ED6185D16E81F5E1EDC1F7E1F671F7D1F3C1F5E),
    .INIT_0A(256'h171E1F47103C1F671F5000001F701F4C1EC71F301F301EDD1F271ED0171D13DB),
    .INIT_0B(256'h16E61028103E171D000016F0171E16FB103913DD18461847103C103C184E1848),
    .INIT_0C(256'h1FBB1FDE1FDB1FBE1FFB1DBC1DBB000018A618E61867186818E818A818661DBE),
    .INIT_0D(256'h1FBE1FA81FDE1FD000001FD81FFA1FB81FDC11DB1FBC00001DBE11D81FFC1DAE),
    .INIT_0E(256'h18BD18FD163C187D18FD18BD187D163E1FA711CD1FC711DC1FE71FB000001FD0),
    .INIT_0F(256'h18BC18FC11DC1DB9186811DC187C1DA7187E18BE18FA18A7163D18F218BE18FE),
    .INIT_10(256'h19FD1C5D1C5D157C1C5D19FD156E1C5D10BE107A10271AC710A81AD0107E1074),
    .INIT_11(256'h19FF19F3157D1C5B15671C5B19FB19F9139A1C5C1C521C521C47157D00001C47),
    .INIT_12(256'h1ADD139D1ADE107C000010BC103B103B19E61C5D1C461C4E1C5F19E8139D1C5E),
    .INIT_13(256'h139C00001ADC107E138710BE0000139C1ADD10B2103210BC107C107C1AC810BE),
    .INIT_14(256'h145C149C0000149C149C13E8149C145C113E16711E7C14BB101C167C1227122F),
    .INIT_15(256'h1488100B101C101C1487149D145D149D149D145D149D1487101E1133113B113B),
    .INIT_16(256'h167D101E173D14BC14BC167C123B123B145B149B144C149C173D148813FB1447),
    .INIT_17(256'h123E123D14B6113F123D14BD14A3112C13FD166714BD167D1728166B1E6A173D),
    .INIT_18(256'h1B9B1A3D1E271A3E1E2B1E3E1E471E5E00001C7D1B9C1E1E1E3B1E5C1E5B1E3C),
    .INIT_19(256'h1A211E1B1E1C1A3C1E5E00001E3E1E5F1E1E1A3A1B9E1EF01A3D1EFD1EE71E0E),
    .INIT_1A(256'h1E071C7D13FC1E1C1C7D13FC1EFE1DBC1B5E1A3E1B5D00001EFC1DBB1DA11DA7),
    .INIT_1B(256'h000013EF1B5B1C7B13FD1EFE1EFB13FA1B5C1C7C1C6E13FD1C641E271B581E47),
    .INIT_1C(256'h1E7B1EFB1EFE1E7E00001A1C124712531F1B1F101A1D1F1E1C7E1F9E1F9B1A0A),
    .INIT_1D(256'h1E7E1EFE1F1C13101F9C1A1E1C7B1A1D1F1E1F831E7C1EFC000011671F9E1C6E),
    .INIT_1E(256'h1F07116D117D1F90131D1F101F87117D1E671EE71EFE1E7D1EF01E70125B125B),
    .INIT_1F(256'h1F6F1F7E0000124B117B117B1F7E11731F7C125D131C1F7C125D131C13081A1E),
    .INIT_20(256'h119B119B11BB11BB127B127B167612FF12FD167E167C169B168612FD167E1680),
    .INIT_21(256'h11BD11B7119D127D118711BD127D119D0000127E12FB12FB17E7126E000017E6),
    .INIT_22(256'h17F11B3E00001B3D13911392139D17FC118717FE11A700001267118C17FE11BF),
    .INIT_23(256'h139B1B3C17FD000012EA12E11B331B23167B169E169E1B3B1674169E169F1666),
    .INIT_24(256'h17A7000010DE189D181D17BD189D0000180618DD10FE183D18DD1808183D0000),
    .INIT_25(256'h17BD181C18DE189C136C183E180D18C8181E17BE189E183C18DC189E17BE181E),
    .INIT_26(256'h181D18C8182C182618C6181D182810FC17A618061808188617B8137D188710DC),
    .INIT_27(256'h181C10DC000010CE000010DC000010FE10FC10FC0000137B180E10E7181E10DE),
    .INIT_28(256'h189D197D18F318FD197D189D18FD1DFE1B8619DD199D1BA619DD1DFC1DFB199D),
    .INIT_29(256'h189C197C189518FC1DFE18F71969197E19CF19DD199C0000199C1997189E19DB),
    .INIT_2A(256'h1B9D19C619861BBD19C81B9D1BBD198818861966000018E61968188818E81F5E),
    .INIT_2B(256'h1F5C1BB11B881F5C1BBB1BBB1B9B1B9B1B8700001F521BA01DEB1EFC1EFD1DE7),
    .INIT_2C(256'h1A3D1A3F1C7D1B5D1B471A3D1B5D1C7D1B46000016FB1BDD1B6616F61BDD1BDC),
    .INIT_2D(256'h1B5B1B5D1A271BCF1E011C7B1A3B00001A2E1E1C1E1C1C6D1BDB1BDB00001C69),
    .INIT_2E(256'h1B5D1B7D1B481BC61B7D1B5D1B70143B1A261B501C66131C131C1E1D1B461C7D),
    .INIT_2F(256'h1B6D143D1B7B1B7B1B51131D1B5B1B5B142A1308131D16FE16FE131116E816EA),
    .INIT_30(256'h1C9D1CFD117E00001CFD1C9D129B129B10BE1FDC103E1FF5117C102700001FFE),
    .INIT_31(256'h1FDC129D117C1FDC129D1CF61CFB1C9B1C981FDE00001FCD1CFC1C9C141B1287),
    .INIT_32(256'h141D00001FDE00001FFC10BC1FC8103C1CFB14121CDE1C8C1CFD1C9D128A141D),
    .INIT_33(256'h1CDB141C1CD21CC71FFE10BE141C103E103C103C10BC10BC10B21FFC1FFC1FE7),
    .INIT_34(256'h101E109C1C3D105C11070000111E1C3E1DC7105C100610DC113E0000101C101C),
    .INIT_35(256'h101C109E10CE105E10DC10DC105C105C0000105E105410DE105C105C109C109C),
    .INIT_36(256'h1DD1113C13BD1DDE105E13AC10DE13BD000010471C3D111C109E1080105E1C3D),
    .INIT_37(256'h1DDE113E1C3C000013BB111C113611291C3B1DDB1DDC111E1101101E0000113C),
    .INIT_38(256'h147D14DB133C13DC13DC133C151D0000133D151D147E141C141C133D120A147D),
    .INIT_39(256'h13C7147C141D132D133D13DD147C1327151C141D13DD133D1331141D133B1411),
    .INIT_3A(256'h121C147C147C143C143C147C1DDB121C175014DC0000175D1DDC000014DC13DE),
    .INIT_3B(256'h14DD142B120714DD147D143D175D142D175B121C143D147D14670000147B14DD),
    .INIT_3C(256'h15130000151C14DC14DC151C115C1830115E0000157C155C155C157C114C0000),
    .INIT_3D(256'h11870000155D157D151D14DD14D71187115C000014DD151D157D155D155D157C),
    .INIT_3E(256'h185D184915DD15BC15BC15DC154C1567119D0000151F14DB0000118F185B183D),
    .INIT_3F(256'h15D315AF183D182715DD15BD15D615B8183D000015BD15DD183B185D119B119B),
    .MODE("DP20K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .OREGSET_A("RESET"),
    .OREGSET_B("RESET"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("ASYNC"),
    .RESETMODE_B("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .SSROVERCE("DISABLE"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    PH1P_LOGIC_ERAM_Inst_first_high_syn_2 (
    .addra(14'b00000000001111),
    .addrb({memory_address[9:0],4'b1111}),
    .clka(clk_dup_1),
    .clkb(clk_dup_1),
    .dia({open_n1290,open_n1291,open_n1292,13'b0000000000000}),
    .dia_extra({open_n1293,3'b000}),
    .dib({open_n1294,open_n1295,open_n1296,13'b0000000000000}),
    .dib_extra({open_n1297,3'b000}),
    .dob({open_n1385,open_n1386,open_n1387,memory_data[33],memory_data[31:28],memory_data[26:23],memory_data[21:18]}),
    .dob_extra({open_n1388,memory_data[32],memory_data[27],memory_data[22]}));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(580)
  // address_offset=0;data_offset=0;depth=1024;width=18;num_section=1;width_per_section=18;section_size=18;working_depth=1024;working_width=20;working_numbyte=2;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // PH1P_LOGIC_ERAM_Inst_first_low_1024x18
  PH1P_PHY_ERAM_V2 #(
    .ASYNC_RESET_RELEASE_A("ASYNC"),
    .ASYNC_RESET_RELEASE_B("ASYNC"),
    .CLKAMUX("SIG"),
    .CLKBMUX("SIG"),
    .CLKMODE("ASYNC"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("0"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("20"),
    .DATA_WIDTH_B("20"),
    .ECC_DECODE("DISABLE"),
    .ECC_ENCODE("DISABLE"),
    .INITP_00(256'h1471407523002060001776200427612531032067300610530705400000555340),
    .INITP_01(256'h1603005050000547571077000007115035612015260200530005002072205310),
    .INITP_02(256'h5115042042530231400010160167017230403026130322060725010550500304),
    .INITP_03(256'h2226102001622700442666430400010131130434020056040207000055111153),
    .INITP_04(256'h2001110027502010555000205151412157503001127722034642464646221645),
    .INITP_05(256'h4225657521223115547022020063112314022555222217200000232264200204),
    .INITP_06(256'h0300550402627040060242325360004160005057315177010535633301050000),
    .INITP_07(256'h1101202522206013072121060017110233060505350000360055000701755503),
    .INITP_08(256'h2060160703007775550570220000057464623262000223050202024760305276),
    .INITP_09(256'h2004000120026201416556105545120012026046775220003046666056444160),
    .INITP_0A(256'h0112000020261240455416615505111322225614642001004474666354456006),
    .INITP_0B(256'h4200520046507413461546125652075102246000320600044646164650045563),
    .INITP_0C(256'h0252110120205203504000101556111222006200410422014410660242400206),
    .INITP_0D(256'h3120207300016400502546460760464401612000012120201010304600704002),
    .INITP_0E(256'h2317557400223005200022003005202212245502222215275000222025102632),
    .INITP_0F(256'h5673552350220520764022532050040530225540002255627000220310002270),
    .INIT_00(256'h47142AB068994EBD51EC000050442817471447140DB94EBD4EBD15480ECC4714),
    .INIT_01(256'h15480D1B28170EAA5D60281770642C361548679528172ECE6C2147144EBD1548),
    .INIT_02(256'h0BAF071572C9232523256BC207160BAF0BAF316C0716232571ED72C9175C0DB9),
    .INIT_03(256'h72C941322C366C2040B00BAF232526AF724C4D26000000006716471421B40000),
    .INIT_04(256'h4714071500004EBD67140BAF0716281723256716724C0BAF4EBD154872C94714),
    .INIT_05(256'h15480DB9177211C6071628170D2426AF724C6B4328176716000067954EBD1548),
    .INIT_06(256'h4EBD493C72C9471423252C3600000BAF0BAF4714279523256C2172C94EBD54D0),
    .INIT_07(256'h0D22253F0000154867140BAF4DB928170DB92817734F3EE168993362643B2FC1),
    .INIT_08(256'h47142AB0481A4EBD47140C2150444EBD4EBD47144EBD471450444CA400002835),
    .INIT_09(256'h15482817293A28171548000037DC6F410CA21548281715482B2F0E21281772EC),
    .INIT_0A(256'h50E30BAF07150BAF72C9000072C960300BAF72C971EE43A50BAF72C92C366716),
    .INIT_0B(256'h69B96D2473400DB90000316C5ADE67147A7B30C669B92B200715071670C50C20),
    .INIT_0C(256'h47147FE147146E3F471428176714000069B969B96C210C200C200C2069B935CA),
    .INIT_0D(256'h15480CA116CB524A000059773B59797728176716281700004EBD58F6281701B2),
    .INIT_0E(256'h293A293A07166F416F416F41293A16CD0BAF41310BAF07150BAF72C9000072C9),
    .INIT_0F(256'h481A481A071639796D240715481A0BAF504434435AFD2B2F724C32E250445044),
    .INIT_10(256'h293A6F41293A0716293A6F4162B56F4128355A7D2B2F2B2E6D24516D28355569),
    .INIT_11(256'h156533E526AF68174BA0681747147B577C5A0716736332E22B2F724C00004BA0),
    .INIT_12(256'h0DB926AF4EBD0715000007156716471469B954C369B930C338710C20724C57CF),
    .INIT_13(256'h07160000279573406C217340000007152FA6736453E30715071607150CA211C9),
    .INIT_14(256'h071507150000071507166CA30716071670E432EF071647140715281A0BAF02B5),
    .INIT_15(256'h6D246E4C071507162B2F26AF26AF26AF724C724C724C2B2F734013E567164714),
    .INIT_16(256'h0DB928352C3607150716071647146716471447144ECF6A920D1A2CA267164BA0),
    .INIT_17(256'h726A30C6175B1669293A26AF4633402E30C64C20724C724C2C222FAB2EA80DB9),
    .INIT_18(256'h67140DB94BA04EBD2D4A15484BA01548000054C327954EBD6714281767142817),
    .INIT_19(256'h44BD6714281727954EBD00004EBD176F15481BD84EBD72C92C3623250BAF30C3),
    .INIT_1A(256'h0BAF6F4107157DE1293A0716154807164EBD764D6FC2000028176817653E6C21),
    .INIT_1B(256'h000071C86714681726AF4EBD47141AFC2795071621B4724C67360BAF18F50BAF),
    .INIT_1C(256'h471447144EBD4EBD000027950BAF1364471412482C364EBD4EBD4EBD47144E29),
    .INIT_1D(256'h154815482817516D28174EBD67140DB9154867352817281700000BAF15480133),
    .INIT_1E(256'h0BAF4FC130C672C9724C72C90BAF293A0BAF0BAF574F232572C972C947146716),
    .INIT_1F(256'h31C7734000004FAC67164714104674E6071630C607160715293A07150C21764D),
    .INIT_20(256'h471467164714671647146716577015E8293A50444B16671469B930C62AB023BA),
    .INIT_21(256'h293A78F4293A30C64BA030C6293A30C600003FE6471467162B2F3044000069B9),
    .INIT_22(256'h52E04EBD00000DB9726074D130C6481A0BAF50440BAF00000BAF202D2AB03068),
    .INIT_23(256'h671627956F4100000E28243C355346B367145E5C50446714756B2AB014E469B9),
    .INIT_24(256'h4BA000002835693C6F416F416F41000069B96F412835293A293A0C206F410000),
    .INIT_25(256'h4D9C481A5044481A2E4D504441B22AC12AB02AB04B30481A481A504450445044),
    .INIT_26(256'h293A0C204ECE69B969B96F410C20071569B969B92B4269B97AD530C62BAE0715),
    .INIT_27(256'h481A0715000042340000289900007340071607150000671621B42B2F50447340),
    .INIT_28(256'h293A293A1363293A6F416F416F41154869B9293A293A69B96F41281767146F41),
    .INIT_29(256'h481A481A36D9481A4EBD37722DA50F40023561AB481A0000281879D170C54714),
    .INIT_2A(256'h293A69B969B9293A0C206F416F410C2069B969B9000069B90C200C200C205C54),
    .INIT_2B(256'h071533CC0CA2071668174714471468172B2F0000545163B80F2B071641AB0BAF),
    .INIT_2C(256'h293A17F0293A6F416C216F41293A6F4169B900006714293A69B916ED6F416A12),
    .INIT_2D(256'h47144F242B2F02B4243C68174714000030440716271561336817471400004C45),
    .INIT_2E(256'h293A6F410CA269B9293A6F413248671669B971EE69B907160715462F69BA54C3),
    .INIT_2F(256'h213151494714681752E0724C471468176DC90A4026AF50442AB0126E0CA14EA9),
    .INIT_30(256'h293A493A73C000006F416F41471467162835699F2835375907152B2F000049BD),
    .INIT_31(256'h071630C607150715293A37DD6817681779777340000021310716071647146C20),
    .INIT_32(256'h26AF000070620000071507156D2407157D5E33634EBD0E4E54C354C30E28724C),
    .INIT_33(256'h6714071633620B2F734073400715734007160715071607153362071607154BA0),
    .INIT_34(256'h7340071554C307154BA00000283570E50BAF0715693D07152835000007150716),
    .INIT_35(256'h071573400133734007160715281807150000734015D573400716071507160715),
    .INIT_36(256'h72E0071530C64EBD283560B02835293A000009BE6F410715283503392835293A),
    .INIT_37(256'h15487340481A000067160715166E2D256817671428177340043D283500000715),
    .INIT_38(256'h26AF47140715071507160716724C000030C626AF5C520715071649BB6EAA724C),
    .INIT_39(256'h6C210716724C013126AF26AF07152B2F07165E63724C724C53CD26AF67167260),
    .INIT_3A(256'h0716291C07150715071607166817071572CB071500000DB9071600000716324E),
    .INIT_3B(256'h724C6FAD6C216CB726AF26AF2C3641B167950715724C724C4BA00000471426AF),
    .INIT_3C(256'h13E400000715071507160716071572CB734000000715071507160716602F0000),
    .INIT_3D(256'h4BA00000724C724C26AF26AF78730BAF07150000724C724C26AF26AF6FC30797),
    .INIT_3E(256'h2C366C4767B32795071607166FC04BA030C6000016EA47140000433767950DB9),
    .INIT_3F(256'h74E722B72C364BA026AF26AF57DD19D36EBD0000724C724C67950DB967164714),
    .MODE("DP20K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .OREGSET_A("RESET"),
    .OREGSET_B("RESET"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("ASYNC"),
    .RESETMODE_B("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .SSROVERCE("DISABLE"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    PH1P_LOGIC_ERAM_Inst_first_low_syn_1 (
    .addra(14'b00000000001111),
    .addrb({memory_address[9:0],4'b1111}),
    .clka(clk_dup_1),
    .clkb(clk_dup_1),
    .dia({open_n1427,15'b000000000000000}),
    .dia_extra({open_n1428,3'b000}),
    .dib({open_n1429,15'b000000000000000}),
    .dib_extra({open_n1430,3'b000}),
    .dob({open_n1518,memory_data[17:15],memory_data[13:10],memory_data[8:5],memory_data[3:0]}),
    .dob_extra({open_n1519,memory_data[14],memory_data[9],memory_data[4]}));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(563)
  // address_offset=0;data_offset=0;depth=1024;width=16;num_section=1;width_per_section=16;section_size=16;working_depth=1024;working_width=20;working_numbyte=2;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // PH1P_LOGIC_ERAM_Inst_second_high_1024x16
  PH1P_PHY_ERAM_V2 #(
    .ASYNC_RESET_RELEASE_A("ASYNC"),
    .ASYNC_RESET_RELEASE_B("ASYNC"),
    .CLKAMUX("SIG"),
    .CLKBMUX("SIG"),
    .CLKMODE("ASYNC"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("0"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("20"),
    .DATA_WIDTH_B("20"),
    .ECC_DECODE("DISABLE"),
    .ECC_ENCODE("DISABLE"),
    .INITP_00(256'h3335535333323033002335140633110130113163111017722112130113303131),
    .INITP_01(256'h3533535502673343535375553553021213303031110433311310313143333246),
    .INITP_02(256'h1335333431130523103115322232330512013330333313552233250402133333),
    .INITP_03(256'h5577653711377677774331550651605415477571501555451455776567552754),
    .INITP_04(256'h5577273730111167775151350171710777777777747767677777777770276770),
    .INITP_05(256'h5535533075206553757245575777357753377775777745777732755557733377),
    .INITP_06(256'h7155756044755771515554445777656654770767555575555777757754551555),
    .INITP_07(256'h6755555575374335757537645773644656757507755570755775755776755757),
    .INITP_08(256'h5355773471757757135754715557775354755757425555405555550555575065),
    .INITP_09(256'h7063727701077716167305547077137106767777772073357773777750733577),
    .INITP_0A(256'h3131131110533155113333131503333103131342102113131313010101133111),
    .INITP_0B(256'h3503170770313771311311371335523170313113311313021331133101133177),
    .INITP_0C(256'h3103112111133031101311111010333333011100177733331333313311011113),
    .INITP_0D(256'h3330233332533232030373330133777033113337012311331133333532032540),
    .INITP_0E(256'h1511055415051353111133101130005323131111111131301313111111113035),
    .INITP_0F(256'h3070071313307160322311310331103131131001111100111313711020310310),
    .INIT_00(256'h1C87165D16FD1C88165C1970000016FC177D169D187F1768169C177C123C18FD),
    .INIT_01(256'h123C000018FD18FE169D177D1EE7123C164E16FE165D176818FB1EFC1EFC1697),
    .INIT_02(256'h18E718E8168C187D169B139B17701388164D1EE7197D1C9E165E16F516FB16FB),
    .INIT_03(256'h187B1C9B1C9E139D13901C9D139D197D197C197F1879122C18720000187D1974),
    .INIT_04(256'h1ABE181D1ABD00001BD11A1D1ABC1A1E1B321A5E1AAF1BDB1ABF1BC711A714B6),
    .INIT_05(256'h1ABC1BDE181B00001ABD00001ABE1A1C1A1D1AAE1A0C1EC9181D181C12101ABD),
    .INIT_06(256'h1B3D1A5D1B2F1A5E14BB1B3D11BB11BB181E1EDC1EDF121C1AA812071A161813),
    .INIT_07(256'h1A5611BD121C1A5C11B4121C1B3B1B3E00001BD614AE14BE1A5D1BDC11A71AA2),
    .INIT_08(256'h1D2B1CEE1CFE1C7E1D27105C0000104D1E671D871D1E161D1D3C1D85161C1D3B),
    .INIT_09(256'h1D1B1C7400001D1C1CE21D3E161F00001CFB1C7B12531CFC1D161C7B105C105B),
    .INIT_0A(256'h1E7D1D071D9E1E7E1D0C1DDC161B160A1C671CE711FC1C70125C11FC00001DDB),
    .INIT_0B(256'h1E7E1D9E125C105E11FC125C11F110471D9B1E7B1E7C1D9C00001DDD1D2711ED),
    .INIT_0C(256'h1FFB1D6E107B107B115B115B114F1D7D11C715F711DB11DB126E15FC11DB1207),
    .INIT_0D(256'h1FFE1D6011C7115D106C1D7B115D1FE5107C00001FFC1E9C1E8E11DD10671D7C),
    .INIT_0E(256'h11DB11DB11C7127C127C193D121B121B1FE71067106C193B11471FF0107C1E9A),
    .INIT_0F(256'h121D121C11DD11C315E7121D126211DD193D193D127C15FE15FE15ED107B107B),
    .INIT_10(256'h121B121B123B123B125B125B127B127B12FD0000110E12901D6C12FD12E30000),
    .INIT_11(256'h123D127D121D125D127D123D125D121D126F130712FB12FB1249121D1278123B),
    .INIT_12(256'h129B129B131D11DC131711FC111C131D000011ED123E11FE125E11DE00001215),
    .INIT_13(256'h131D131B129D12E611071D7B111E129D111C000011C711FC11F511DC12881D7C),
    .INIT_14(256'h179E16CF107E1C4815DB186610FB10FB1826179E17CE1C5B107C107D179E17DD),
    .INIT_15(256'h171E1C5E107C17DE17DE179E15CD171E16DE15DE17DC16DB171310FE15DE16DE),
    .INIT_16(256'h159E170617C612F5170C183D171B159E187D16C6159F15C312FD187E16DB15DD),
    .INIT_17(256'h183C183012FC187E187E12FC12EF00001786183E1C4700001789187C183E107E),
    .INIT_18(256'h14DB191D18BD18DD191D185D18DD18BD191D190E193D19BD115E191D19BD193D),
    .INIT_19(256'h185C184D18BC18DC000018C2190A191B191C185E193C19BC18BE19BB185E14DE),
    .INIT_1A(256'h1906115C192619A6192C190819A819281846190618A618C61908151B18C818A8),
    .INIT_1B(256'h157D115E151E15CC1DFB151E156D115615071509157E15DE15DE157E1DFC115C),
    .INIT_1C(256'h195D193D195D13DD193D195D13DD195D199D198E19FD1D1D1A7B199D1D1E19FD),
    .INIT_1D(256'h195C1947192D1D1C195B13DB0000193B19FA1D1B1A7D1A7B19FB0000199B1A7D),
    .INIT_1E(256'h19861D9D19E61D1D13BD199A19FD1D0B19461926194613BD1928194819471948),
    .INIT_1F(256'h1F881F9E1A6B1D9B1D8C1E5E1A7D1D941F9C1D9C13BC1F9C1E5E13BC13AE1E5C),
    .INIT_20(256'h1A5D1A5D1A9D163E163E1A5D00001A9D1BFE1BFD1B7D1B861BFD00001B871B7D),
    .INIT_21(256'h1CD91CC81BA61CDD1A9B19A61A5B1BAA1A4711871BFB1BFB1B7B1B7B1A8B0000),
    .INIT_22(256'h129C119F1B661B9D1BE61B6C1B9D129C1A461CDB1A9619BB1BBB1BBB1A9B119C),
    .INIT_23(256'h1F7C119C163B1F7C1B9B1B9B119E162A19BD129C1BBD1CDD19B219BD1CDD1BBD),
    .INIT_24(256'h1BDD15511BFD15DD1CBC1BDD1CDD1BFD1CFD00001C1D15D915DD1CFD1CBB1C1D),
    .INIT_25(256'h00001BE91C1E1BD81BFC1BFB1BDB1BDB1C1B1CBD109400001CBD15DC109E1CFB),
    .INIT_26(256'h137D1C071C1D109E00001CFD1CE61CF31BC600001BE61CDD1363109C1CDD137E),
    .INIT_27(256'h155E00001CA7109C1CBD15DE1CDC155E0000137C000015511CDB155B137C1CC9),
    .INIT_28(256'h12FC113C11BC10FC000011B3000012FC000018B9145C11BC11BC145C145E18B8),
    .INIT_29(256'h0000113E11BE10FE145D11BC11E7113F12EE12FB13C7145D11BC10FC12FC113C),
    .INIT_2A(256'h18BD139C129C11A413DD129C139C11BD12BC11FD000013DD10EC113110FE11BF),
    .INIT_2B(256'h129612BC13DC18BB139813DC12BC139E139D000011FD129E129D18BD11FB11FB),
    .INIT_2C(256'h14FC13FC137C13BC13BC137C13FC14FC152E169B153C14FC14FC153C1493149E),
    .INIT_2D(256'h149B000014FD153D137D13BD14FD13FD13FD14FD13BD137D153D14FD00001767),
    .INIT_2E(256'h177B169C159C14FD169D159C17711FBE14FB13E91B5E159E159E136A177D13BC),
    .INIT_2F(256'h1B5B15930000177D159D1FB115891FBE149F169D1B5C159D1B4D1FBC1FBC169D),
    .INIT_30(256'h179C165D16FD16DD165C179D16DC16FC173D171D180817BC171C173C17BD178B),
    .INIT_31(256'h16F716C2000017BD171D173D17910000179D1E9C1E9C1E8F165D164F16DD16FD),
    .INIT_32(256'h17091727181D179D171C173E191B191D19730000197D178D165B15FC16DB16FB),
    .INIT_33(256'h179B181B191615FD191B181B178D197D1975197B191D15E515FE0000179D181D),
    .INIT_34(256'h189D187D185D183D191C191B18DB1E3D18DD18EA0000191D194D1E3C1E2B0000),
    .INIT_35(256'h183B185B187B189B190018DD191D1D90188D187218271845187D189D183D185D),
    .INIT_36(256'h000018FD0000195D1D9C193D189D193418671886183C185D1D8D1D961D9B0000),
    .INIT_37(256'h195D195C18FB000018E9189B193C193C193D188E1E34189D18FD18D9195D18C7),
    .INIT_38(256'h1A3D19FD1A3E19FE1A7D1A5D1A7E1A5E1AFD1A9D1AFE1A9E1A7D00001A7E17E6),
    .INIT_39(256'h1AEC1A7E1A3C19FC1A9D1AFD1A7C1A5C1A5D1A7D1AFC1A9C19FD1A3D1A7C1A3F),
    .INIT_3A(256'h1AFF1ADD1B7C1ADE1A7F1AFC15FD1A931B7B15FD19E215E91A7B1A4A155E1AFC),
    .INIT_3B(256'h1B7F155E1B7E1ADC000017F1155E17E815FC17FE1AC815551ADD1AFD17FE1AFE),
    .INIT_3C(256'h1B1D1A9D1B1E1A9E17061D3B1D3C00001CC71BF31BBE1BDE1BC91BBC1BFE0000),
    .INIT_3D(256'h1BBB1BDB1B1C1A9C1BFB1B081D4718C41B1B1BD11D9B1BDC1BED1D871BFC1D3E),
    .INIT_3E(256'h1CD212C81BA91CDE1D5C18DD1BBE1D5B1D491A9F1A9718DB1D9B000012DD1D9C),
    .INIT_3F(256'h12DC1D27171E00001D27171E1D9E12DC18DD1CDB1CDC0000170E1D5E170D0000),
    .MODE("DP20K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .OREGSET_A("RESET"),
    .OREGSET_B("RESET"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("ASYNC"),
    .RESETMODE_B("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .SSROVERCE("DISABLE"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    PH1P_LOGIC_ERAM_Inst_second_high_syn_2 (
    .addra(14'b00000000001111),
    .addrb({memory_address[9:0],4'b1111}),
    .clka(clk_dup_1),
    .clkb(clk_dup_1),
    .dia({open_n1558,open_n1559,open_n1560,13'b0000000000000}),
    .dia_extra({open_n1561,3'b000}),
    .dib({open_n1562,open_n1563,open_n1564,13'b0000000000000}),
    .dib_extra({open_n1565,3'b000}),
    .dob({open_n1653,open_n1654,open_n1655,memory_data[69],memory_data[67:64],memory_data[62:59],memory_data[57:54]}),
    .dob_extra({open_n1656,memory_data[68],memory_data[63],memory_data[58]}));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(614)
  // address_offset=0;data_offset=0;depth=1024;width=18;num_section=1;width_per_section=18;section_size=18;working_depth=1024;working_width=20;working_numbyte=2;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // PH1P_LOGIC_ERAM_Inst_second_low_1024x18
  PH1P_PHY_ERAM_V2 #(
    .ASYNC_RESET_RELEASE_A("ASYNC"),
    .ASYNC_RESET_RELEASE_B("ASYNC"),
    .CLKAMUX("SIG"),
    .CLKBMUX("SIG"),
    .CLKMODE("ASYNC"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("0"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("20"),
    .DATA_WIDTH_B("20"),
    .ECC_DECODE("DISABLE"),
    .ECC_ENCODE("DISABLE"),
    .INITP_00(256'h0022666705645077036502614255451000717702332300210551260255712205),
    .INITP_01(256'h7220500402407325453526020250317005005050715372475550750513107300),
    .INITP_02(256'h3603026100000601705542030003020000004550007042203455300600550520),
    .INITP_03(256'h2067164254070602020207200260013356226065000232220402026606024200),
    .INITP_04(256'h1267301200505012026040020741110562626262100236100202020260645250),
    .INITP_05(256'h2420703057003204755266006565200675070270772025001111052057100406),
    .INITP_06(256'h0105074201770020505551115555121126220710272210042444666644444666),
    .INITP_07(256'h1160446722202032565126215555113123120200604000064442666646460606),
    .INITP_08(256'h2000007360465446225456605050000063510504320000104740760636454036),
    .INITP_09(256'h0010102700070021201101505054706703330000042062404442261640665604),
    .INITP_0A(256'h4200620620423702500552260202674501112006112500000000070206202036),
    .INITP_0B(256'h0505551152027022020452520650737020225555222255030000222240002270),
    .INITP_0C(256'h0022004770776077425503057056020065077730720173772555252255322256),
    .INITP_0D(256'h0000100076577373050525552717770000006556672577775555000271076230),
    .INITP_0E(256'h5050067120157575250520200543134064007700770077045555555555555055),
    .INITP_0F(256'h2300075050003560731507101740002000000307040060055555500000553050),
    .INIT_00(256'h0BAF2DB90DB90CA20716716C000007160DB90DB9176F0CA10716071607150DB9),
    .INIT_01(256'h071500002C3613C02C362C360BAF071650C55549724C2C2267950715071679D1),
    .INIT_02(256'h0BAF6CA360300DB968996716716E0CA221312B2F0DB94EBD29B9566C1CDB6899),
    .INIT_03(256'h6795671452CE30C671EE49BC293A2C3627951461397840B053E300002C361467),
    .INIT_04(256'h4EBD0DB90DB9000072600DB927954EBD744F764D11C6671414634BA00BAF78DD),
    .INIT_05(256'h27954EBD679500000DB900004EBD27952C3630C320AE2D262C36281A116B2C36),
    .INIT_06(256'h293A0DB971C94EBD67166F41471467163A5B0716166807156CA36C21166E55D3),
    .INIT_07(256'h36EF30C607162795356907154714736D0000785E423450446DBB4B152B2F6631),
    .INIT_08(256'h6F2C42344EBD4EBD4BA02817000061330BAF0BAF4EBD0DB9281748B907166714),
    .INIT_09(256'h671476D70000281705BF4EBD17EE00006714671433E5281777706716499E4714),
    .INIT_0A(256'h22A10BAF4EBD4EBD4F4F071668996EA90BAF0BAF071572CC0715071600006817),
    .INIT_0B(256'h154830E407155C540715071611EE6C21671467142817281700006F410BAF70C3),
    .INIT_0C(256'h471462B5471467164714671622366F410BAF3772471467164235071667140BAF),
    .INIT_0D(256'h74E103392B2F30C60E4D6817493A08382817000028170716304330C62B2F0716),
    .INIT_0E(256'h471467160BAF071607152C36671647140BAF2B2F2ECF67950BAF72C96A925BD9),
    .INIT_0F(256'h30C66EA0293A66B46C21293A05BF30C60DB968B707152AB0504400B047146716),
    .INIT_10(256'h47146716471467164714671647146716293A000021B351ED40AE30C626B20000),
    .INIT_11(256'h293A30C6293A30C6293A30C6293A30C631460BAF471467166DA720A97A534714),
    .INIT_12(256'h47146716293A071558730715071530C600000F4108357340364B73400000566D),
    .INIT_13(256'h0B946716293A69BD4BA06817734030C6071500006ABF071556ED07150C210716),
    .INIT_14(256'h5FDF31C673406D24479569B96716471469B92AB01042671407154ABE50446F41),
    .INIT_15(256'h2AB04EBD07152AB0504411484FC150442AB02AB0481A471475554CB650445044),
    .INIT_16(256'h2AB069B969B936D960306F41671450446F4169B913EF0632724C5B5E6714493B),
    .INIT_17(256'h481A316B071650442AB007155147000069B92AB00BAF00004D26481A50442835),
    .INIT_18(256'h6716293A293A293A6F416F416F416F41293A62B5293A293A28356F416F416F41),
    .INIT_19(256'h481A00B0481A481A000045304EA84714481A2AB0481A481A5DD84714504453EE),
    .INIT_1A(256'h69B9071569B969B96FC00C200C200C2069B969B969B969B90C2067160C200C20),
    .INIT_1B(256'h0F23734050446F4068172AB061B2785E0BAF2DA52AB02AB05044504407160715),
    .INIT_1C(256'h293A293A293A30C66F416F41293A6F41293A21B3293A6F4147146F4152CD6F41),
    .INIT_1D(256'h481A4BA05041071647146716000047143A7C6817293A47954714000047146F41),
    .INIT_1E(256'h69B96F4169B954C3724C3A7D5E630F2A69B969B969B926AF0C200C202B202CA1),
    .INIT_1F(256'h0CA173404D4768174F4F72696733756A07160716071607155FE7071570C40716),
    .INIT_20(256'h293A2323293A50442AB06F4100006F415B506F41293A69B9293A00004BA06F41),
    .INIT_21(256'h59FA4C2369B954C3471469B947144D484BA02B2F47146817471468170F2A0000),
    .INIT_22(256'h071618D669B9293A69B960306F41071569B9681716ED47144714681767950715),
    .INIT_23(256'h07160715671407156817471405AD6EA96F410715293A6F415362293A293A6F41),
    .INIT_24(256'h293A326F293A724C07166F4154C36F41293A00006F41397926AF6F416817293A),
    .INIT_25(256'h00004DA71341195208176817471468176817293A155500006F41071628356817),
    .INIT_26(256'h724C0BAF54C37340000054C3093C55D369B9000069B9293A66B507156F4173E0),
    .INIT_27(256'h504400006C20071554C33FE607162AB000000715000072616817471407160DA4),
    .INIT_28(256'h0715071507150715000013E500000716000059FA071607154797071516CE3876),
    .INIT_29(256'h0000734073407340724C07150BAF70EA71457D5D0B2F26AF0715071507150715),
    .INIT_2A(256'h0DB907150715073526AF0716071669BC071530C60000724C2ECF72602835166A),
    .INIT_2B(256'h77F107160715679558F60716071509BC724C000067B278542B962C3647146716),
    .INIT_2C(256'h0715071507150715071607160716071662B56899071507150716071613645044),
    .INIT_2D(256'h67160000724C724C26AF26AF26AF26AF724C724C724C724C26AF26AF00004BA0),
    .INIT_2E(256'h67950716071521AC0DB9071632E038D547140BC44EBD50442AB04E292C362898),
    .INIT_2F(256'h6714546600000DB926AF52E02DA57340376D5E642795724C0F4007150716724C),
    .INIT_30(256'h07160DB90DB90DB907160DB9071607160DB90DB94C230716071607160DB90D4A),
    .INIT_31(256'h57F3663200002C362C362C36734E00002C360716071511C62C3651472C362C36),
    .INIT_32(256'h6CC62B2F0DB90DB96A1F53C367950DB933E500000DB900306899071668996899),
    .INIT_33(256'h6795679537DC724C6795681721312C3655EC67952C36483A09BC00002C362C36),
    .INIT_34(256'h0DB90DB90DB90DB96818679567950EA12C362EA800002C3620B007166FAD0000),
    .INIT_35(256'h6795679567956795233A0DB90DB910EA613212E12B2F28B82C362C362C362C36),
    .INIT_36(256'h00000DB900000DB907160DB90DB975EA2B2F08BB6A9122A14FC1366F68170000),
    .INIT_37(256'h2FA42795679500002DA56795079527952C3621B455E92C362C365AD62C364BA1),
    .INIT_38(256'h0DB90DB94EBD4EBD0DB90DB94EBD4EBD0DB90DB94EBD4EBD0DB900004EBD69B9),
    .INIT_39(256'h603072EA279527952C362C36279527952C362C36279527952C362C36279530E8),
    .INIT_3A(256'h1FE00DB927954EBD17500714724C5553671426AF053E4D263CDC4E2908B62795),
    .INIT_3B(256'h16EA50444EBD2795000011EE2AB00CA1071650440C21566D2C360DB92AB04EBD),
    .INIT_3C(256'h0DB90DB94EBD4EBD69B96714281700000BAF35534EBD4EBD4DA74A1F4EBD0000),
    .INIT_3D(256'h671467142795279567144CA40BAF27366714326F4714279520B10BAF27954EBD),
    .INIT_3E(256'h73646CA40DA54EBD28172C365E5A67142DA5366B17F1679567140000724C2817),
    .INIT_3F(256'h07162BA0504400000BAF2AB04EBD07150DB967142817000070C44EBD00B10000),
    .MODE("DP20K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .OREGSET_A("RESET"),
    .OREGSET_B("RESET"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("ASYNC"),
    .RESETMODE_B("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .SSROVERCE("DISABLE"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    PH1P_LOGIC_ERAM_Inst_second_low_syn_1 (
    .addra(14'b00000000001111),
    .addrb({memory_address[9:0],4'b1111}),
    .clka(clk_dup_1),
    .clkb(clk_dup_1),
    .dia({open_n1695,15'b000000000000000}),
    .dia_extra({open_n1696,3'b000}),
    .dib({open_n1697,15'b000000000000000}),
    .dib_extra({open_n1698,3'b000}),
    .dob({open_n1786,memory_data[53:51],memory_data[49:46],memory_data[44:41],memory_data[39:36]}),
    .dob_extra({open_n1787,memory_data[50],memory_data[45],memory_data[40]}));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(597)
  // address_offset=0;data_offset=0;depth=1024;width=16;num_section=1;width_per_section=16;section_size=16;working_depth=1024;working_width=20;working_numbyte=2;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // PH1P_LOGIC_ERAM_Inst_third_high_1024x16
  PH1P_PHY_ERAM_V2 #(
    .ASYNC_RESET_RELEASE_A("ASYNC"),
    .ASYNC_RESET_RELEASE_B("ASYNC"),
    .CLKAMUX("SIG"),
    .CLKBMUX("SIG"),
    .CLKMODE("ASYNC"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("0"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("20"),
    .DATA_WIDTH_B("20"),
    .ECC_DECODE("DISABLE"),
    .ECC_ENCODE("DISABLE"),
    .INITP_00(256'h7354072530027723253423770071001713337001111111110011201123236212),
    .INITP_01(256'h7707177657710567466777752714435510750007753507153255554455776170),
    .INITP_02(256'h6010543575771757751023577773474607564675157777515577701757777571),
    .INITP_03(256'h7776030776357777777075605553755555775355552375557752747537756657),
    .INITP_04(256'h3345713753750751715554553531531107167676250555777471577775555755),
    .INITP_05(256'h1003130135310311001333111154011510033310030311313111111310330331),
    .INITP_06(256'h5335325232333330333003430503555011323331336331131331733130733073),
    .INITP_07(256'h5777065555505577224623777215244610335654315373355531055333775505),
    .INITP_08(256'h0474050757545555457577554060557455577575670466775555577057505555),
    .INITP_09(256'h5057077777000556770577547555555701750057575555755770767677515777),
    .INITP_0A(256'h5535715333753771730361376600457147710755777755175051551725511010),
    .INITP_0B(256'h0000040755507700000700405006577757045570757517557777551775577505),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h000000001DBE1D7E1F0700001DFE1DDE1F511F1C1F271D7E12AC1F47123C1F30),
    .INIT_01(256'h123C1D7B1D7C1F1B12DA1DEE1D77123C1DBB1D7B1D7C1DBC1DFB1DDB1DDC1DFC),
    .INIT_02(256'h1D67137B1F3B13701D671F5B12BB12BB1D671DA712DD1DDF1DC71DE71DBD12DD),
    .INIT_03(256'h12BD1F31137D1372000012BD1F4D137D1F3C123C00001F0712DB12DB1F101F5C),
    .INIT_04(256'h1F7B1F68103E103B115B115B114E12B9117B117B113B113B11E7199D141D198E),
    .INIT_05(256'h199D00001968115D0000000000001966113E103C1F7C10320000113D199B117D),
    .INIT_06(256'h116713081127131B11FB11FB141B116C1F67197B161C102711471F7112BB12BB),
    .INIT_07(256'h131D131C000011FD161D131D11FD140812BD141E197D161F160712BD1407197D),
    .INIT_08(256'h12DB12DB143B164114DB0000133D1A501ABD16BE16BD165E165E1ABD16BE117E),
    .INIT_09(256'h0000161E12DD14331ABD161A161E12DD133C14A2142614DE14DE143E1ABB133C),
    .INIT_0A(256'h161B153C117C000017B517BB1AA0160B1A5D14CC143C17BD14AE1A5D12D814C9),
    .INIT_0B(256'h1A47132C117E00001520153617BD14BB16A6153E16461A5B117C165B153E16BB),
    .INIT_0C(256'h1EB01B1D1A1D15AB1B1D14471EB81A1D17DD1E3B19DD1ADD1A2C14E71ADD19DD),
    .INIT_0D(256'h1A081ADD1B1B1B1B1A1B17DD17431778177E175E17C917DB19DB1ADB175E177E),
    .INIT_0E(256'h14FB1A3D19C600001A3D1AD519CB0000174617661A0615BC1B06145B177B175B),
    .INIT_0F(256'h1E361EBC1EBC1EA8000015BD00001A3B14FE1E2A15BD145E1A2F1E3C1E3C14FE),
    .INIT_10(256'h1A9D1CB21ABD16BB1CBD1A9D1F4C1ABD1B3D1C3D1C1D1C9D1C3D1B3D1C9D1C1D),
    .INIT_11(256'h00001AA2119E1A871ABB1AB71A9B1A891F871C9B00001C3B1C1E1C1B1B3B1B3B),
    .INIT_12(256'h1B26119C1C061C9D1C261C281C871F3C159C1CBD1F9C16BC1CBD159316BD119E),
    .INIT_13(256'h1F9B1F8F1F281F371F5C16BD159D1F5C1F3C159D1F5C1F3C00001F5E1CBB119C),
    .INIT_14(256'h12BC12DC127C125C125C127C12DC12BC135C0000135C163C0000135C163D135C),
    .INIT_15(256'h124E12670000163E135D16BB135D000012CA12BE1347135D127C125C12BE12DC),
    .INIT_16(256'h00001750175D163B155C16BD195D175C195B1940135D1348000019DD1CFE135D),
    .INIT_17(256'h19DD00000000154D1CFB155D1CEE1CE716BD135B155D195D19C716BC19DB175D),
    .INIT_18(256'h1BAF18BD1B3B19FD1D3C1B1C199D1BBE1B3C00001D3B19BD1C0C00001D3B1B1B),
    .INIT_19(256'h19FB19FE18BB198F199C1B1E19BD1BBC1B3E19BC1D2F199D18BD1BBB19FD19AD),
    .INIT_1A(256'h1BFE1B7E1B9E000000001B9E15E71C1E000015FE000018AB109B109B15FE0000),
    .INIT_1B(256'h10881B7D1B9E15E01B2D1BED109C1B671B9B1B081BFB1B7B1BED1C1B1C1A0000),
    .INIT_1C(256'h10BB10BB1CBE1C5E0000101B161B1D5E1FBB1FDB111B111B10DB10DB00001492),
    .INIT_1D(256'h1C5200001FBC1FDC149B108710DC100A1CBB1C5B10BC1CBD111D1D5B1D5C101C),
    .INIT_1E(256'h1FA71FC710D311071FA71FC910BB10BB10831CA71C5A13FB1D47100710A8104E),
    .INIT_1F(256'h161E10B8105B105B000010A81610161E13FD13FE14960000149A13FD109B109B),
    .INIT_20(256'h111B111B133E133B141B135B145B0000165E13BB17DE0000169B17DE167B165E),
    .INIT_21(256'h133D17D4141D135D1766133D135E16DB1A6C145E0000140713A813AD145913BD),
    .INIT_22(256'h1DA716DE177E16CE1A7B177E16DE1DBB111E000013470000111D1DBC145C1413),
    .INIT_23(256'h000016701A7D168800001DBD00001A7D167E177F169E165B17C6169E165B167E),
    .INIT_24(256'h1AFB1E5C1E5C00001A1B1E59172A1747175E173E1B1E1C1E1AFE1AFC173E175E),
    .INIT_25(256'h00001C1B1A1D1AFD000000001AFD1A1D173E163E17BE179E179E17BE163E173E),
    .INIT_26(256'h1ADD1AFD1C071B1D1AFD1ADD1B1D1FA816261726178617A617BE179C173B163B),
    .INIT_27(256'h1B1B00001FB01AD700001E5C1ADB1AFB172617460000000000001FBC1FBC1A1E),
    .INIT_28(256'h1FFE00001D5317DD1D5D1D3D17DC1D1E1C271FFC1FFC17FD1C27000017FD0000),
    .INIT_29(256'h1FE81D1D1F3E17FD00001D1B1D5B1D3B1F3C1EDC1EDC1F3C1D5C1D3C17DD1D1C),
    .INIT_2A(256'h151E17FD00001C3E1F121C3E153C151E1ECC1F270000000015AF1D3E1EC51C9E),
    .INIT_2B(256'h1F1C15BE17FB1F1C1F1E1C9B15BE153D153D1C3B15151F0317FD1F1C1F1C1C3B),
    .INIT_2C(256'h101B101B10FB10FB14FB1E1B1CBE147B1E7C1F9C1F9C1E7C15BD1DFE00001E1C),
    .INIT_2D(256'h1F8F15BE00001EA81EBC1DFC15BE0000147E16BE153E14FE1CBB153E16BE1DFB),
    .INIT_2E(256'h0000000000001D54000000001EB6000016BB00000000152D14FE100910FB147E),
    .INIT_2F(256'h000000000000000000001FCC00001D5B1E001FDC1FDC00001E7E1D5C00000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .MODE("DP20K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .OREGSET_A("RESET"),
    .OREGSET_B("RESET"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("ASYNC"),
    .RESETMODE_B("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .SSROVERCE("DISABLE"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    PH1P_LOGIC_ERAM_Inst_third_high_syn_2 (
    .addra(14'b00000000001111),
    .addrb({memory_address[9:0],4'b1111}),
    .clka(clk_dup_1),
    .clkb(clk_dup_1),
    .dia({open_n1826,open_n1827,open_n1828,13'b0000000000000}),
    .dia_extra({open_n1829,3'b000}),
    .dib({open_n1830,open_n1831,open_n1832,13'b0000000000000}),
    .dib_extra({open_n1833,3'b000}),
    .dob({open_n1921,open_n1922,open_n1923,memory_data[105],memory_data[103:100],memory_data[98:95],memory_data[93:90]}),
    .dob_extra({open_n1924,memory_data[104],memory_data[99],memory_data[94]}));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(648)
  // address_offset=0;data_offset=0;depth=1024;width=18;num_section=1;width_per_section=18;section_size=18;working_depth=1024;working_width=20;working_numbyte=2;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // PH1P_LOGIC_ERAM_Inst_third_low_1024x18
  PH1P_PHY_ERAM_V2 #(
    .ASYNC_RESET_RELEASE_A("ASYNC"),
    .ASYNC_RESET_RELEASE_B("ASYNC"),
    .CLKAMUX("SIG"),
    .CLKBMUX("SIG"),
    .CLKMODE("ASYNC"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("0"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("20"),
    .DATA_WIDTH_B("20"),
    .ECC_DECODE("DISABLE"),
    .ECC_ENCODE("DISABLE"),
    .INITP_00(256'h2460064201002010020120200025004600004412000000000055005510057001),
    .INITP_01(256'h6102226120670624030202240020042070600005100702020120024102020514),
    .INITP_02(256'h1610405257500000000000466627641300620172245020000224202447470604),
    .INITP_03(256'h7201020051521200245067105552520041000776771000004643424650443366),
    .INITP_04(256'h0134222005020100505151512402675107520201000070004340164646464646),
    .INITP_05(256'h7001056552251207015027720663055213002020322500100000222220220050),
    .INITP_06(256'h6004140301004060555002350004027007040570504770773505205500256000),
    .INITP_07(256'h7602016066404220002024027062003450002303000020000255000500200205),
    .INITP_08(256'h0141060675735000170307002010422265225230700334620232222072000700),
    .INITP_09(256'h0066000055000020442666415555200000460046777700000200034377354200),
    .INITP_0A(256'h0702100520777200050505276100607535170000020222723055662032016050),
    .INITP_0B(256'h0000060062001200000700200004260537012200000207700202205222007602),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h000000004EBD4EBD2BAF00004EBD4EBD534C28170BAF4EBD402F0BAF071572C9),
    .INIT_01(256'h07156714281747141AFB62B55950071667146714281728176714671428172817),
    .INIT_02(256'h0BAF6716471412482B2F4714671647140BAF0BAF30C615660BAF0BAF20A7293A),
    .INIT_03(256'h30C652EF293A34D00000293A413130C628171DDF00000BAF6716471472C92817),
    .INIT_04(256'h47140C21375047144714671662B55B5747146716471467160BAF0DB94B1462B5),
    .INIT_05(256'h2C3600000A40514700000000000069B934422817281712E1000030C6679530C6),
    .INIT_06(256'h0BAF2C230BAF67164714671667164F4F0BAF471407160BAF0BAF52EF67164714),
    .INIT_07(256'h293A6D9C000030C6724C30C6293A6D2430C650446F4113E00BAF293A2B2F293A),
    .INIT_08(256'h471467166716653E67160000724C51ED293A2AB020262AB050446F4150442835),
    .INIT_09(256'h00005044293A75541EE27C5A2AB030C6071625BF293B50447751504447140715),
    .INIT_0A(256'h671428180715000037596795443A4D486F412E4E27972C360132293A7AD54D26),
    .INIT_0B(256'h6C2060307340000064BC78DE0DB9671669B92AB069B947140715671450446714),
    .INIT_0C(256'h31EC6F41293A6F2C293A2B2F59776F410DB96714293A293A2FAD4BA16F416F41),
    .INIT_0D(256'h4B420D1A4714681747142C3646B438F62AB02AB00DA567954714471450445044),
    .INIT_0E(256'h6716293A69B900006F4135EB2FAB000069B969B969B9071669B9671667146714),
    .INIT_0F(256'h166E071607150CA20000724C000047144B310EA826AF5FE011C6071607155044),
    .INIT_10(256'h293A334C293A689954C36F416F4F6F41293A6F41293A6F41293A6F41293A6F41),
    .INIT_11(256'h000045B14CB62B2F471438DF47142DA50BAF6817000068170EBF681747146817),
    .INIT_12(256'h69B9071569B954C369B90CA109BA6B130716293A281707166F4113640DB97340),
    .INIT_13(256'h471431C64CA378F40716724C724C0715071526AF281807160000734068170715),
    .INIT_14(256'h071507150715071507160716071607160716000007160716000007150DB90715),
    .INIT_15(256'h10436BA000003044724C6899724C00006EA9124D2B2E26AF071507155E5A0715),
    .INIT_16(256'h000032C90DB9689907162C362C360716679543BA293A2C2300000DB94EBD30C6),
    .INIT_17(256'h2C36000000007042671426AF21B46ABF0DB96716724C0DB96C21071667952C36),
    .INIT_18(256'h71C80DB967140DB9071627950DB94EBD2795000067160DB90E4E000068176714),
    .INIT_19(256'h67952C36679563B827954EBD2C3627954EBD279563382C362C3667142C362F41),
    .INIT_1A(256'h4EBD4EBD4EBD0000000039596BA14EBD0000504400006ECD471467162AB00000),
    .INIT_1B(256'h6B44089930C564BB704241B228174BA067140C21671467142FCF67143A7C0000),
    .INIT_1C(256'h471467164EBD4EBD0000471467144EBD47144714671647144714671600003362),
    .INIT_1D(256'h33E300002817281767164BA068994E29671467142817299C30C6671428172817),
    .INIT_1E(256'h0BAF0BAF14D20BAF2B2F6CC64714671666B40BAF5AFD67160BAF0BAF2C222234),
    .INIT_1F(256'h2AB038754714671600006D2410EB5044293A5064577000001AFB30C667164714),
    .INIT_20(256'h471467165CD5671667166716671600002AB067165044000067142AB067145044),
    .INIT_21(256'h293A756830C630C669B930C6564D6714402F504400004BA04CA3213159F930C6),
    .INIT_22(256'h6C212AB05044304447142AB0504468177FE600006C200000212A0716479714D2),
    .INIT_23(256'h0000124A293A0CA100006F4100006F412AB015E52AB05CDD69B9504467145044),
    .INIT_24(256'h471407160715000047143A556D484BA02AB02AB013424EBD50E3281A50445044),
    .INIT_25(256'h00006714293A6F4100000000293A6F412AB02AB02AB02AB05044504450445044),
    .INIT_26(256'h293A293A2B2F6F416F416F41293A2CA269B969B969B969B932CE489967146714),
    .INIT_27(256'h4714000071EE37F20000291C4714471469B969B9000000000000071507163FE5),
    .INIT_28(256'h764C000034650DB96F416F4127167ADB2BA0071607154B146A4000000DB90000),
    .INIT_29(256'h4CA36D3773402C3600006817681768170715071607150716071607162C360716),
    .INIT_2A(256'h50440DB900004EBD34504EBD07162AB040306C200000000002355B5E07B74EBD),
    .INIT_2B(256'h07152AB06795071673406714504426AF724C671435EC26332C36071607156714),
    .INIT_2C(256'h4714671647146716671668174EBD67160716071607150715452B0F4200000716),
    .INIT_2D(256'h71C72AB000000CA10716071650440000504450445044714967142AB02AB06817),
    .INIT_2E(256'h00000000000014E800000000375B000067140000000061B15A5C0B4447142322),
    .INIT_2F(256'h0000000000000000000060B00000681743BA071607150000164A071600000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .MODE("DP20K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .OREGSET_A("RESET"),
    .OREGSET_B("RESET"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("ASYNC"),
    .RESETMODE_B("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .SSROVERCE("DISABLE"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    PH1P_LOGIC_ERAM_Inst_third_low_syn_1 (
    .addra(14'b00000000001111),
    .addrb({memory_address[9:0],4'b1111}),
    .clka(clk_dup_1),
    .clkb(clk_dup_1),
    .dia({open_n1963,15'b000000000000000}),
    .dia_extra({open_n1964,3'b000}),
    .dib({open_n1965,15'b000000000000000}),
    .dib_extra({open_n1966,3'b000}),
    .dob({open_n2054,memory_data[89:87],memory_data[85:82],memory_data[80:77],memory_data[75:72]}),
    .dob_extra({open_n2055,memory_data[86],memory_data[81],memory_data[76]}));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(631)
  PH1P_PHY_HR_PAD_V2 #(
    //.INHYS("ON"),
    //.LOCATION("K5"),
    //.ODT("OFF"),
    .DIRBYPEN("DISABLE"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS18"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .MODE("IN"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("PULLUP"),
    .TSMUX("1"))
    clk_syn_2 (
    .ipad(clk),
    .di(clk_dup_1));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(5)
  PH1P_PHY_CONFIG_V2 #(
    .JTAG_PERSISTN("DISABLE"),
    .SPIX4_PERSISTN("ENABLE"))
    config_inst ();
  AL_MAP_LUT4 #(
    .EQN("(C@(A*~(B)*~(D)+A*B*~(D)+~(A)*B*D+A*B*D))"),
    .INIT(16'h3c5a))
    \memory_address[0]_syn_1  (
    .a(\displacement[0]_syn_1 [0]),
    .b(\displacement[0]_syn_1 [1]),
    .c(\I_addr[9]_dup_3 ),
    .d(\I_addr[8]_dup_3 ),
    .o(memory_address[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \memory_address[10]_syn_7  (
    .a(\memory_address[10]_syn_1 [0]),
    .b(\memory_address[10]_syn_1 [1]),
    .c(\I_addr[8]_dup_3 ),
    .o(memory_address[10]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \memory_address[11]_syn_7  (
    .a(\memory_address[11]_syn_1 [0]),
    .b(\memory_address[11]_syn_1 [1]),
    .c(\I_addr[8]_dup_3 ),
    .o(memory_address[11]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT4 #(
    .EQN("(C@(A*~(B)*~(D)+A*B*~(D)+~(A)*B*D+A*B*D))"),
    .INIT(16'h3c5a))
    \memory_address[1]_syn_1  (
    .a(\displacement[1]_syn_1 [0]),
    .b(\displacement[1]_syn_1 [1]),
    .c(\I_addr[10]_dup_3 ),
    .d(\I_addr[8]_dup_3 ),
    .o(memory_address[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT4 #(
    .EQN("(C@(A*~(B)*~(D)+A*B*~(D)+~(A)*B*D+A*B*D))"),
    .INIT(16'h3c5a))
    \memory_address[2]_syn_1  (
    .a(\displacement[2]_syn_1 [0]),
    .b(\displacement[2]_syn_1 [1]),
    .c(\I_addr[11]_dup_3 ),
    .d(\I_addr[8]_dup_3 ),
    .o(memory_address[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT4 #(
    .EQN("(C@(A*~(B)*~(D)+A*B*~(D)+~(A)*B*D+A*B*D))"),
    .INIT(16'h3c5a))
    \memory_address[3]_syn_1  (
    .a(\displacement[3]_syn_1 [0]),
    .b(\displacement[3]_syn_1 [1]),
    .c(\I_addr[12]_dup_3 ),
    .d(\I_addr[8]_dup_3 ),
    .o(memory_address[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT4 #(
    .EQN("(C@(A*~(B)*~(D)+A*B*~(D)+~(A)*B*D+A*B*D))"),
    .INIT(16'h3c5a))
    \memory_address[4]_syn_1  (
    .a(\displacement[4]_syn_1 [0]),
    .b(\displacement[4]_syn_1 [1]),
    .c(\I_addr[13]_dup_3 ),
    .d(\I_addr[8]_dup_3 ),
    .o(memory_address[4]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT4 #(
    .EQN("(C@(A*~(B)*~(D)+A*B*~(D)+~(A)*B*D+A*B*D))"),
    .INIT(16'h3c5a))
    \memory_address[5]_syn_1  (
    .a(\displacement[5]_syn_1 [0]),
    .b(\displacement[5]_syn_1 [1]),
    .c(\I_addr[14]_dup_3 ),
    .d(\I_addr[8]_dup_3 ),
    .o(memory_address[5]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \memory_address[6]_syn_7  (
    .a(\memory_address[6]_syn_1 [0]),
    .b(\memory_address[6]_syn_1 [1]),
    .c(\I_addr[8]_dup_3 ),
    .o(memory_address[6]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \memory_address[7]_syn_7  (
    .a(\memory_address[7]_syn_1 [0]),
    .b(\memory_address[7]_syn_1 [1]),
    .c(\I_addr[8]_dup_3 ),
    .o(memory_address[7]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \memory_address[8]_syn_7  (
    .a(\memory_address[8]_syn_1 [0]),
    .b(\memory_address[8]_syn_1 [1]),
    .c(\I_addr[8]_dup_3 ),
    .o(memory_address[8]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \memory_address[9]_syn_7  (
    .a(\memory_address[9]_syn_1 [0]),
    .b(\memory_address[9]_syn_1 [1]),
    .c(\I_addr[8]_dup_3 ),
    .o(memory_address[9]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(11)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_349"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_100 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_354),
    .f8muxo(mux0_syn_358));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_359"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_103 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_364),
    .f8muxo(mux0_syn_368));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_369"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_123 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_374),
    .f8muxo(mux0_syn_378));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_379"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_126 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_384),
    .f8muxo(mux0_syn_388));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_389"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_146 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_394),
    .f8muxo(mux0_syn_398));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_399"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_149 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_404),
    .f8muxo(mux0_syn_408));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_409"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_169 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_414),
    .f8muxo(mux0_syn_418));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_419"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_172 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_424),
    .f8muxo(mux0_syn_428));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_429"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_192 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_434),
    .f8muxo(mux0_syn_438));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_439"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_195 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_444),
    .f8muxo(mux0_syn_448));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_449"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_215 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_454),
    .f8muxo(mux0_syn_458));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_459"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_218 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_464),
    .f8muxo(mux0_syn_468));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_469"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_238 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_474),
    .f8muxo(mux0_syn_478));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_479"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_241 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_484),
    .f8muxo(mux0_syn_488));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_489"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_261 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_494),
    .f8muxo(mux0_syn_498));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_499"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_264 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_504),
    .f8muxo(mux0_syn_508));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_509"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_284 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_514),
    .f8muxo(mux0_syn_518));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_519"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_287 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_524),
    .f8muxo(mux0_syn_528));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_289"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b10001101001010000000101100000001),
    .INIT_LUT5B(32'b01001011100000000011111010101010),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_289 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_294[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+A*~B*~C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+A*~B*C*~D*E*0+A*B*C*~D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+A*~B*~C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+A*~B*C*~D*E*1+A*B*C*~D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_289"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b11101000010110110000110110001000),
    .INIT_LUT5B(32'b01100000101011101010001010111000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_290 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_294[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_289"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b01011001001010100001010001110001),
    .INIT_LUT5B(32'b10110110100111010110100010101010),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_291 (
    .f78i(mux0_syn_298),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[0]_syn_1 [0]),
    .relut6(mux0_syn_294[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_289"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b10110001101100011010000011101000),
    .INIT_LUT5B(32'b01000101000011001001010101010110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_292 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_294[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*~B*C*~D*E*0+A*~B*~C*D*E*0+~A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*~B*C*~D*E*1+A*~B*~C*D*E*1+~A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_299"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00001001000100100101001010000111),
    .INIT_LUT5B(32'b10010010001000000110000000100001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_299 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_304[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*C*~D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+A*B*~C*~D*E*0+A*~B*C*~D*E*0+A*B*C*~D*E*0+~A*B*~C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*C*~D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+A*B*~C*~D*E*1+A*~B*C*~D*E*1+A*B*C*~D*E*1+~A*B*~C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_299"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00011000100101001111011111010001),
    .INIT_LUT5B(32'b10000100101010110100100110111111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_300 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_304[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*~D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*C*D*~E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+~A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*~D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*C*D*~E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+~A*~B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_299"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00101011011010001100001010011001),
    .INIT_LUT5B(32'b00010000011000001000011001000000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_301 (
    .f78i(mux0_syn_308),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[0]_syn_1 [1]),
    .relut6(mux0_syn_304[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*B*~C*~D*E*~0+A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*~C*D*~E*0+A*B*C*D*~E*0+A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*B*~C*~D*E*~1+A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*~C*D*~E*1+A*B*C*D*~E*1+A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_299"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b11010010000001001110001100100000),
    .INIT_LUT5B(32'b01111100001010001000100000101000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_302 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_304[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*~B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*~B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_309"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b01010110010001100010010100110001),
    .INIT_LUT5B(32'b10100101000110011010101111000010),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_309 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_314[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_289"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_31 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_294),
    .f8muxo(mux0_syn_298));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*~C*D*E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*~C*D*E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_309"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00101010000000000001011011100100),
    .INIT_LUT5B(32'b00111111111001001100101110100011),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_310 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_314[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_309"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00111101101011010001111010000011),
    .INIT_LUT5B(32'b11001011000001100000000100100000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_311 (
    .f78i(mux0_syn_318),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[1]_syn_1 [0]),
    .relut6(mux0_syn_314[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*B*~C*D*~E*~0+~A*B*~C*~D*E*~0+A*~B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*~B*C*D*~E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*B*~C*D*~E*~1+~A*B*~C*~D*E*~1+A*~B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*~B*C*D*~E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1)"),
    //.MACRO("mux0_syn_309"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b10100010000001000000010000001010),
    .INIT_LUT5B(32'b00000011010110000001000111000100),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_312 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_314[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+A*~B*~C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+A*~B*~C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_319"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00100011111100101011111010001110),
    .INIT_LUT5B(32'b11001011100000101010101010110111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_319 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_324[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*B*~C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+A*B*C*D*E*~0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+A*B*C*~D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*B*~C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+A*B*C*D*E*~1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+A*B*C*~D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_319"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b10001101110001000000111100100010),
    .INIT_LUT5B(32'b11000000101100000000110100110000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_320 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_324[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_319"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b11001100001100101110111000010000),
    .INIT_LUT5B(32'b10110000011011010010100111011001),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_321 (
    .f78i(mux0_syn_328),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[1]_syn_1 [1]),
    .relut6(mux0_syn_324[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*~C*D*E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*~B*C*~D*E*0+A*~B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*~C*D*E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*~B*C*~D*E*1+A*~B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_319"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b10101001000010010100001101011101),
    .INIT_LUT5B(32'b00100010001001111000000000011101),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_322 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_324[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_329"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b01000001010100000110000010100011),
    .INIT_LUT5B(32'b00110101000001111100100100110001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_329 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_334[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_329"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00111001100000000000100100000100),
    .INIT_LUT5B(32'b00100010101100000000101000110011),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_330 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_334[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+A*~B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+A*~B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_329"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00010011010100010101000010000110),
    .INIT_LUT5B(32'b00000001101000001010100100001101),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_331 (
    .f78i(mux0_syn_338),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[2]_syn_1 [0]),
    .relut6(mux0_syn_334[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*B*~C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*B*~C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_329"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b10100111110101100000000110111010),
    .INIT_LUT5B(32'b10000100000100100000010111010110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_332 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_334[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_339"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b10001100101101100111101011010101),
    .INIT_LUT5B(32'b11000110011100000110110000111111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_339 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_344[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_299"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_34 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_304),
    .f8muxo(mux0_syn_308));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*B*~C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*B*~C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_339"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00000111100101010110110110110111),
    .INIT_LUT5B(32'b10001001110000000001100110100010),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_340 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_344[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*~C*D*~E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*C*~D*~E*0+~A*B*~C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*B*~C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*~C*D*~E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*C*~D*~E*1+~A*B*~C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*B*~C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_339"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00101000000000000000100001001000),
    .INIT_LUT5B(32'b00001001100001010000010010000000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_341 (
    .f78i(mux0_syn_348),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[2]_syn_1 [1]),
    .relut6(mux0_syn_344[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_339"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b00000000000100010000111101010010),
    .INIT_LUT5B(32'b01011010110111110111110101011000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_342 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_344[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*B*~C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*B*~C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_349"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b10100100110100010100010001000001),
    .INIT_LUT5B(32'b00100101000011110000000000000000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_349 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_354[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+A*B*~C*~D*E*0+A*~B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+A*B*~C*~D*E*1+A*~B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_349"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b11110001100011101000000001000101),
    .INIT_LUT5B(32'b01000110101010110011101100100001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_350 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_354[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+~A*~B*C*~D*~E*0+A*B*C*~D*~E*0+A*B*~C*D*~E*0+A*B*C*D*~E*0+~A*B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+~A*~B*C*~D*~E*1+A*B*C*~D*~E*1+A*B*~C*D*~E*1+A*B*C*D*~E*1+~A*B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_349"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b01101000011111100000000011000110),
    .INIT_LUT5B(32'b00100110110101001000100010010000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_351 (
    .f78i(mux0_syn_358),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[3]_syn_1 [0]),
    .relut6(mux0_syn_354[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*~C*D*E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*~C*D*E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_349"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b00101001000001110001000011011001),
    .INIT_LUT5B(32'b01100000000111010000010101110001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_352 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_354[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*B*~C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*B*~C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_359"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00000011110110100101100001010100),
    .INIT_LUT5B(32'b11101010100001001100000010100100),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_359 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_364[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_359"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00110101001011010000000000001100),
    .INIT_LUT5B(32'b01001001000000011000000101000011),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_360 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_364[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+~A*B*~C*D*~E*0+A*B*~C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+~A*B*~C*D*~E*1+A*B*~C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_359"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b11111000011100110000001001001000),
    .INIT_LUT5B(32'b00100010110010000000010001101000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_361 (
    .f78i(mux0_syn_368),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[3]_syn_1 [1]),
    .relut6(mux0_syn_364[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*~B*C*~D*~E*0+~A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*~B*C*~D*~E*1+~A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_359"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b00110010110000010110001111110011),
    .INIT_LUT5B(32'b01000100000011010010010000100000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_362 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_364[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_369"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b01011100110100000001100100000000),
    .INIT_LUT5B(32'b01110000000010111100011100100010),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_369 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_374[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*C*D*E*~0+~A*B*C*~D*~E*0+A*~B*C*D*~E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*C*D*E*~1+~A*B*C*~D*~E*1+A*~B*C*D*~E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_369"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b01000001100000000000100100000000),
    .INIT_LUT5B(32'b00101011000000000010000001000000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_370 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_374[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_369"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b01000001000001100100000001000100),
    .INIT_LUT5B(32'b01000011000110001010000100000000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_371 (
    .f78i(mux0_syn_378),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[4]_syn_1 [0]),
    .relut6(mux0_syn_374[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*B*~C*D*~E*0+~A*~B*~C*D*E*0+~A*~B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*B*~C*D*~E*1+~A*~B*~C*D*E*1+~A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_369"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b10100010000101100000010000000000),
    .INIT_LUT5B(32'b00010001000000000000010010010110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_372 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_374[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*C*~D*E*~0+A*B*~C*D*E*~0+A*B*C*~D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*C*~D*E*~1+A*B*~C*D*E*~1+A*B*C*~D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_379"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00001000100100100101110000000100),
    .INIT_LUT5B(32'b00011010011001011100000010000000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_379 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_384[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*~B*C*D*~E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*~B*C*D*~E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_379"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00010001100110000001000000110000),
    .INIT_LUT5B(32'b10011110010000001010110001000110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_380 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_384[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*D*~E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*~C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*D*~E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*~C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_379"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00101000000000000000010000000000),
    .INIT_LUT5B(32'b00100000000000000000100110001000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_381 (
    .f78i(mux0_syn_388),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[4]_syn_1 [1]),
    .relut6(mux0_syn_384[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*C*~D*~E*~0+A*~B*C*D*~E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*~D*E*0+A*B*C*~D*E*0)"),
    //.LUT5B("(~A*B*C*~D*~E*~1+A*~B*C*D*~E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*~D*E*1+A*B*C*~D*E*1)"),
    //.MACRO("mux0_syn_379"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b01110010011000000010000001000000),
    .INIT_LUT5B(32'b00000000100100000000110001001011),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_382 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_384[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_389"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b11010001110111110111001010101010),
    .INIT_LUT5B(32'b01110001100110011101110100110001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_389 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_394[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*~C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*~C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_389"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b10110110111100000010001101001010),
    .INIT_LUT5B(32'b10111111000001000010100000111011),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_390 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_394[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*B*C*D*E*~0+~A*B*C*~D*~E*0+~A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*B*C*D*E*~1+~A*B*C*~D*~E*1+~A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_389"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b01001110010011111001100001100111),
    .INIT_LUT5B(32'b10011100000011101100010001000000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_391 (
    .f78i(mux0_syn_398),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[5]_syn_1 [0]),
    .relut6(mux0_syn_394[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*~C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*C*D*~E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*~B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*~C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*C*D*~E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_389"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b01010001000101000101001111010010),
    .INIT_LUT5B(32'b00010110000000000001000010001000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_392 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_394[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+A*B*~C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+A*B*~C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_399"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b11001000101100000111111000010000),
    .INIT_LUT5B(32'b11011001101111010111000000100111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_399 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_404[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*C*D*~E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*B*~C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*C*D*~E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*B*~C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_399"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b10011101111101111010000100100110),
    .INIT_LUT5B(32'b10001001100000000001000011011001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_400 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_404[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_399"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00101000000000000000100110101010),
    .INIT_LUT5B(32'b00111100001100111100111000000000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_401 (
    .f78i(mux0_syn_408),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\displacement[5]_syn_1 [1]),
    .relut6(mux0_syn_404[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+A*~B*~C*D*~E*0+A*~B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+A*~B*~C*D*~E*1+A*~B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_399"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b11111100011100000100101001100000),
    .INIT_LUT5B(32'b10111101011011110010001011000100),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_402 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_404[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*D*E*~0+~A*B*C*D*E*~0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*D*E*~1+~A*B*C*D*E*~1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_409"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b01000100000000110101110111010101),
    .INIT_LUT5B(32'b10101101001011011110100101001100),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_409 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_414[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*~B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*~C*~D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*~B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*~C*~D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_409"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b01100100011111111111010010110000),
    .INIT_LUT5B(32'b01001010000001000010001001011011),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_410 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_414[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_409"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b01000111010101101101011101011110),
    .INIT_LUT5B(32'b01100100110000010011010100100001),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_411 (
    .f78i(mux0_syn_418),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[6]_syn_1 [0]),
    .relut6(mux0_syn_414[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+~A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+~A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_409"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b01100101000101100110010010101101),
    .INIT_LUT5B(32'b11101000111100011011100100010000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_412 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_414[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*B*~C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*B*~C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_419"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b11001111011111101011110111101011),
    .INIT_LUT5B(32'b10001001111001000000000000100111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_419 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_424[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+A*~B*~C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+A*~B*~C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_419"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b11110110000100001011100110011110),
    .INIT_LUT5B(32'b01110111001111110100001010100001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_420 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_424[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*B*~C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+~A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*B*~C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+~A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_419"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b11011110000001000000101111111011),
    .INIT_LUT5B(32'b11001101010001111100001111001011),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_421 (
    .f78i(mux0_syn_428),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[6]_syn_1 [1]),
    .relut6(mux0_syn_424[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_419"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b00010100100110010110001110001000),
    .INIT_LUT5B(32'b00111000011100000010111101111111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_422 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_424[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*D*~E*~0+A*B*C*D*~E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*D*~E*~1+A*B*C*D*~E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_429"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b11100110001011001000001000000000),
    .INIT_LUT5B(32'b11101011111100110101110010100001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_429 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_434[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*B*~C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+A*~B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*B*~C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+A*~B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_429"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00100011111111111100100011001111),
    .INIT_LUT5B(32'b11101101110000000000000100010010),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_430 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_434[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*~B*C*D*~E*~0+A*~B*~C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*~B*C*D*~E*~1+A*~B*~C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_429"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b10110000100000100010000001100110),
    .INIT_LUT5B(32'b10111111111111011001101111011110),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_431 (
    .f78i(mux0_syn_438),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[7]_syn_1 [0]),
    .relut6(mux0_syn_434[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+A*B*C*~D*~E*0+A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+A*B*C*~D*~E*1+A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_429"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b10110110000101111110101100111110),
    .INIT_LUT5B(32'b11100000111111111100100010001111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_432 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_434[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_439"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b01001101110100001011110101111101),
    .INIT_LUT5B(32'b01000010110000000000000001000101),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_439 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_444[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1)"),
    //.MACRO("mux0_syn_439"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b10101011111101111101101011110110),
    .INIT_LUT5B(32'b00000001100011001010010110100001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_440 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_444[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+~A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+~A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_439"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b11010111011111111111110010100100),
    .INIT_LUT5B(32'b00001101011101000000011001101011),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_441 (
    .f78i(mux0_syn_448),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[7]_syn_1 [1]),
    .relut6(mux0_syn_444[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*~E*~0+A*B*~C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*~E*~1+A*B*~C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_439"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b11100111110111110000100000001000),
    .INIT_LUT5B(32'b00111011110101010110101110110101),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_442 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_444[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_449"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00001101110101110010110101111111),
    .INIT_LUT5B(32'b00110110110001011110000001001101),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_449 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_454[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*B*C*D*E*~0+A*B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+~A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*B*C*D*E*~1+A*B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+~A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_449"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b10011101111011010111110101011011),
    .INIT_LUT5B(32'b00010110001101111110011000101000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_450 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_454[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_449"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b10110111110011011111011001011111),
    .INIT_LUT5B(32'b10111011111111011101101111011110),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_451 (
    .f78i(mux0_syn_458),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[8]_syn_1 [0]),
    .relut6(mux0_syn_454[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*~C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*C*~D*~E*0+A*B*~C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*~C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*C*~D*~E*1+A*B*~C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_449"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b01000100000101100110010111001100),
    .INIT_LUT5B(32'b01110000000100011000100010000111),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_452 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_454[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*B*~C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*~C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*B*~C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*~C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_459"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00001001000100100011011011110001),
    .INIT_LUT5B(32'b10000010111001011001111100010110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_459 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_464[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_459"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b01011000110001010000000001010000),
    .INIT_LUT5B(32'b01010001100000010100000000000001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_460 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_464[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*B*C*D*E*~0+A*B*~C*~D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+A*~B*~C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*B*C*D*E*~1+A*B*~C*~D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+A*~B*~C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_459"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b10010111101001110110000000001110),
    .INIT_LUT5B(32'b00000010000000000011000000001000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_461 (
    .f78i(mux0_syn_468),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[8]_syn_1 [1]),
    .relut6(mux0_syn_464[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*D*~E*0+A*~B*~C*~D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*D*~E*1+A*~B*~C*~D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_459"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b11111010000100011001111000110111),
    .INIT_LUT5B(32'b11011100000000100001000000001110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_462 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_464[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+A*~B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+A*~B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_469"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00111110001000111101010111110110),
    .INIT_LUT5B(32'b11001011011110000101000010110001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_469 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_474[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*C*~D*~E*0+~A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*C*~D*~E*1+~A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_469"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b11000011111111111100100111001111),
    .INIT_LUT5B(32'b10011100111100111100010000010000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_470 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_474[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+A*B*~C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+A*B*~C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_469"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b10000111000010011101011001111111),
    .INIT_LUT5B(32'b00100100110010111001100011011110),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_471 (
    .f78i(mux0_syn_478),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[9]_syn_1 [0]),
    .relut6(mux0_syn_474[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*~B*~C*D*~E*~0+~A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*~B*~C*D*~E*~1+~A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1)"),
    //.MACRO("mux0_syn_469"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b11000000000101100100001001110011),
    .INIT_LUT5B(32'b00000000000000000000000000000000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_472 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_474[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*B*C*~D*~E*0+A*~B*~C*~D*E*0+A*~B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*B*C*~D*~E*1+A*~B*~C*~D*E*1+A*~B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_479"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00110000100100011000000100000000),
    .INIT_LUT5B(32'b00111110001000100000000010011000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_479 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_484[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+A*B*C*~D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*~B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+A*B*C*~D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*~B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_479"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00100111001101000001110010000011),
    .INIT_LUT5B(32'b10101111111100100001101011111110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_480 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_484[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*B*C*D*~E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*~B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*B*~C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*B*C*D*~E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*~B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*B*~C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_479"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00100000010110001001001101010001),
    .INIT_LUT5B(32'b11111100111111011100100110010110),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_481 (
    .f78i(mux0_syn_488),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[9]_syn_1 [1]),
    .relut6(mux0_syn_484[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_479"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b01010101101001101111001111001000),
    .INIT_LUT5B(32'b11100011111111010101110110100011),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_482 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_484[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+A*B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+A*B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_489"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b10110011111001001001100000000000),
    .INIT_LUT5B(32'b11101000001110001101111110110000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_489 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_494[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+A*B*C*~D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+~A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+A*B*C*~D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+~A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_489"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b11000000100100101000000010000100),
    .INIT_LUT5B(32'b00011000001110111101010110010100),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_490 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_494[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*B*~C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*B*~C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*B*~C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*B*~C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_489"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b10001111000010111101111111111001),
    .INIT_LUT5B(32'b01100100110010011011110011111111),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_491 (
    .f78i(mux0_syn_498),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[10]_syn_1 [0]),
    .relut6(mux0_syn_494[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*~C*D*E*~0+~A*~B*C*D*E*~0+A*B*~C*~D*~E*0+A*B*C*~D*E*0)"),
    //.LUT5B("(~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*~C*D*E*~1+~A*~B*C*D*E*~1+A*B*~C*~D*~E*1+A*B*C*~D*E*1)"),
    //.MACRO("mux0_syn_489"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b00010010000101111101110000000000),
    .INIT_LUT5B(32'b00000000100000000000000000001000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_492 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_494[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*B*C*~D*~E*~0+A*B*~C*D*~E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*B*~C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+~A*B*C*~D*E*0)"),
    //.LUT5B("(~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*B*C*~D*~E*~1+A*B*~C*D*~E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*B*~C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+~A*B*C*~D*E*1)"),
    //.MACRO("mux0_syn_499"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b01000100111000000000100010001100),
    .INIT_LUT5B(32'b00000000010100011001111100000001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_499 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_504[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*C*~D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+~A*B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*B*C*~D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+~A*B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_499"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b11011100010101010011000001000000),
    .INIT_LUT5B(32'b01010001100000010100000000000010),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_500 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_504[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+A*B*~C*~D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*B*C*D*E*~0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*~C*~D*E*0+A*B*~C*~D*E*0+A*B*C*~D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+A*B*~C*~D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*B*C*D*E*~1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*~C*~D*E*1+A*B*~C*~D*E*1+A*B*C*~D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_499"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b10110111001001110110000000001110),
    .INIT_LUT5B(32'b11110000100010100000000000011100),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_501 (
    .f78i(mux0_syn_508),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[10]_syn_1 [1]),
    .relut6(mux0_syn_504[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*C*D*~E*~0+~A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*B*C*D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*C*D*~E*0+A*B*C*D*~E*0+A*B*~C*~D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*C*D*~E*~1+~A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*B*C*D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*C*D*~E*1+A*B*C*D*~E*1+A*B*~C*~D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_499"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b10011000010110010110000111000000),
    .INIT_LUT5B(32'b00110000000010001001000001010110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_502 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_504[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*B*C*~D*~E*0+A*~B*C*D*~E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+~A*B*~C*D*E*0)"),
    //.LUT5B("(A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*B*C*~D*~E*1+A*~B*C*D*~E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+~A*B*~C*D*E*1)"),
    //.MACRO("mux0_syn_509"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b00000000000110000000000000000000),
    .INIT_LUT5B(32'b00000100000001100010000001001110),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_509 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_514[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*~B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*~C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*~B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*~C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1+A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_509"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00110110000000000000000000000000),
    .INIT_LUT5B(32'b11100000110001000010001000100001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_510 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_514[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*~B*C*D*~E*~0+~A*B*~C*~D*E*~0+~A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*C*D*E*~0+A*~B*C*D*E*~0+A*~B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*B*C*D*E*0)"),
    //.LUT5B("(A*~B*C*D*~E*~1+~A*B*~C*~D*E*~1+~A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*C*D*E*~1+A*~B*C*D*E*~1+A*~B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*B*C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_509"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b00110000110101000010000000000000),
    .INIT_LUT5B(32'b10011011001000000000000000000000),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_511 (
    .f78i(mux0_syn_518),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[11]_syn_1 [0]),
    .relut6(mux0_syn_514[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+A*~B*C*D*~E*~0+A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+~A*B*C*~D*E*~0+A*B*C*~D*E*~0+~A*B*~C*D*E*~0+A*B*~C*D*E*~0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0+~A*~B*C*D*E*0+A*~B*C*D*E*0+~A*B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+A*~B*C*D*~E*~1+A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+~A*B*C*~D*E*~1+A*B*C*~D*E*~1+~A*B*~C*D*E*~1+A*B*~C*D*E*~1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1+~A*~B*C*D*E*1+A*~B*C*D*E*1+~A*B*C*D*E*1)"),
    //.MACRO("mux0_syn_509"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b00001100111010000010001110110111),
    .INIT_LUT5B(32'b01111111000000000000000000000000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_512 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_514[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+~A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+~A*~B*C*D*~E*~0+A*~B*C*D*~E*~0+A*B*C*D*~E*~0+~A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*B*~C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+A*B*C*D*E*~0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*~B*C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+~A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+~A*~B*C*D*~E*~1+A*~B*C*D*~E*~1+A*B*C*D*~E*~1+~A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*B*~C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+A*B*C*D*E*~1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*~B*C*D*E*1)"),
    //.MACRO("mux0_syn_519"),
    //.R_POSITION("X0Y0Z0"),
    .INIT_LUT5A(32'b10000011000011011011010101110011),
    .INIT_LUT5B(32'b00100101100011100110000001100000),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_519 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_524[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+~A*B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+A*B*C*~D*~E*~0+~A*~B*~C*D*~E*~0+A*~B*~C*D*~E*~0+~A*B*~C*D*~E*~0+A*B*~C*D*~E*~0+~A*B*C*D*~E*~0+A*B*C*D*~E*~0+A*~B*~C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+A*~B*C*D*E*~0+~A*~B*~C*~D*~E*0+~A*B*~C*~D*~E*0+A*B*~C*~D*~E*0+~A*~B*C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*~B*C*D*~E*0+A*~B*~C*~D*E*0+~A*B*~C*~D*E*0+A*B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0+A*B*~C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+~A*B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+A*B*C*~D*~E*~1+~A*~B*~C*D*~E*~1+A*~B*~C*D*~E*~1+~A*B*~C*D*~E*~1+A*B*~C*D*~E*~1+~A*B*C*D*~E*~1+A*B*C*D*~E*~1+A*~B*~C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+A*~B*C*D*E*~1+~A*~B*~C*~D*~E*1+~A*B*~C*~D*~E*1+A*B*~C*~D*~E*1+~A*~B*C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*~B*C*D*~E*1+A*~B*~C*~D*E*1+~A*B*~C*~D*E*1+A*B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1+A*B*~C*D*E*1)"),
    //.MACRO("mux0_syn_519"),
    //.R_POSITION("X0Y0Z1"),
    .INIT_LUT5A(32'b00100011101000101100111110110101),
    .INIT_LUT5B(32'b00001110011111100010011101111101),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_520 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_524[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(A*B*~C*D*E*~0+~A*B*C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+~A*B*C*~D*~E*0+A*B*C*~D*~E*0+~A*~B*~C*D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+~A*~B*C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+A*B*C*D*~E*0+~A*~B*~C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0)"),
    //.LUT5B("(A*B*~C*D*E*~1+~A*B*C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+~A*B*C*~D*~E*1+A*B*C*~D*~E*1+~A*~B*~C*D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+~A*~B*C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+A*B*C*D*~E*1+~A*~B*~C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1)"),
    //.LUT8MODE("LUT8_ON"),
    //.MACRO("mux0_syn_519"),
    //.R_POSITION("X0Y0Z2"),
    .INIT_LUT5A(32'b01001000000000000000000000000000),
    .INIT_LUT5B(32'b00000011000000011111111111100001),
    .LOC_F7CY("F7"),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"),
    .OFA_SD("F7CY"))
    mux0_syn_521 (
    .f78i(mux0_syn_528),
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .ofa(\memory_address[11]_syn_1 [1]),
    .relut6(mux0_syn_524[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_LSLICE #(
    //.LUT5A("(~A*~B*~C*~D*~E*~0+A*~B*~C*~D*~E*~0+~A*~B*C*~D*~E*~0+A*~B*C*~D*~E*~0+A*~B*~C*~D*E*~0+~A*B*~C*~D*E*~0+A*~B*C*~D*E*~0+A*B*C*~D*E*~0+~A*~B*~C*D*E*~0+A*~B*~C*D*E*~0+~A*B*~C*D*E*~0+~A*~B*~C*~D*~E*0+A*~B*C*~D*~E*0+A*~B*~C*D*~E*0+~A*B*~C*D*~E*0+A*B*~C*D*~E*0+A*~B*C*D*~E*0+~A*B*C*D*~E*0+~A*~B*~C*~D*E*0+A*~B*~C*~D*E*0+~A*~B*C*~D*E*0+A*~B*C*~D*E*0+~A*B*C*~D*E*0+A*B*C*~D*E*0+~A*~B*~C*D*E*0+A*~B*~C*D*E*0+~A*B*~C*D*E*0)"),
    //.LUT5B("(~A*~B*~C*~D*~E*~1+A*~B*~C*~D*~E*~1+~A*~B*C*~D*~E*~1+A*~B*C*~D*~E*~1+A*~B*~C*~D*E*~1+~A*B*~C*~D*E*~1+A*~B*C*~D*E*~1+A*B*C*~D*E*~1+~A*~B*~C*D*E*~1+A*~B*~C*D*E*~1+~A*B*~C*D*E*~1+~A*~B*~C*~D*~E*1+A*~B*C*~D*~E*1+A*~B*~C*D*~E*1+~A*B*~C*D*~E*1+A*B*~C*D*~E*1+A*~B*C*D*~E*1+~A*B*C*D*~E*1+~A*~B*~C*~D*E*1+A*~B*~C*~D*E*1+~A*~B*C*~D*E*1+A*~B*C*~D*E*1+~A*B*C*~D*E*1+A*B*C*~D*E*1+~A*~B*~C*D*E*1+A*~B*~C*D*E*1+~A*B*~C*D*E*1)"),
    //.MACRO("mux0_syn_519"),
    //.R_POSITION("X0Y0Z3"),
    .INIT_LUT5A(32'b00000111101001100000000000110011),
    .INIT_LUT5B(32'b00000111111100110110111000100001),
    .LUT5A_SD0("IC"),
    .LUT5A_SD1("IE"),
    .LUT5B_SD2("ID"),
    .LUTMODE("LUT6"))
    mux0_syn_522 (
    .ia(\I_addr[0]_dup_3 ),
    .ib(\I_addr[1]_dup_3 ),
    .ic(\I_addr[2]_dup_3 ),
    .id(\I_addr[3]_dup_3 ),
    .ie(\I_addr[4]_dup_3 ),
    .imf(\I_addr[5]_dup_3 ),
    .relut6(mux0_syn_524[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_309"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_54 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_314),
    .f8muxo(mux0_syn_318));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_319"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_57 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_324),
    .f8muxo(mux0_syn_328));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_329"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_77 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_334),
    .f8muxo(mux0_syn_338));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  PH1P_PHY_F78MUX
    //.MACRO("mux0_syn_339"),
    //.R_POSITION("X0Y0Z0"),
    mux0_syn_80 (
    .f7sel({\I_addr[6]_dup_3 ,\I_addr[6]_dup_3 }),
    .f8sel(\I_addr[7]_dup_3 ),
    .muxi(mux0_syn_344),
    .f8muxo(mux0_syn_348));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(22)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[0]  (
    .clk(clk_dup_1),
    .d(\I_addr[0]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[10]  (
    .clk(clk_dup_1),
    .d(\I_addr[10]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[10]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[11]  (
    .clk(clk_dup_1),
    .d(\I_addr[11]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[11]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[12]  (
    .clk(clk_dup_1),
    .d(\I_addr[12]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[12]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[13]  (
    .clk(clk_dup_1),
    .d(\I_addr[13]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[13]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[14]  (
    .clk(clk_dup_1),
    .d(\I_addr[14]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[14]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[1]  (
    .clk(clk_dup_1),
    .d(\I_addr[1]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[2]  (
    .clk(clk_dup_1),
    .d(\I_addr[2]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[2]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[3]  (
    .clk(clk_dup_1),
    .d(\I_addr[3]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[3]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[4]  (
    .clk(clk_dup_1),
    .d(\I_addr[4]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[4]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[5]  (
    .clk(clk_dup_1),
    .d(\I_addr[5]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[5]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[6]  (
    .clk(clk_dup_1),
    .d(\I_addr[6]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[6]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[7]  (
    .clk(clk_dup_1),
    .d(\I_addr[7]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[7]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[8]  (
    .clk(clk_dup_1),
    .d(\I_addr[8]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[8]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_address_reg[9]  (
    .clk(clk_dup_1),
    .d(\I_addr[9]_dup_3 ),
    .sr(rst_n_dup_1),
    .q(read_address[9]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_bank_reg[0]  (
    .clk(clk_dup_1),
    .d(memory_address[10]),
    .sr(rst_n_dup_1),
    .q(read_bank[0]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \read_bank_reg[1]  (
    .clk(clk_dup_1),
    .d(memory_address[11]),
    .sr(rst_n_dup_1),
    .q(read_bank[1]));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  AL_MAP_SEQ_GSR #(
    .CEMUX("1"),
    .CLKMUX("SIG"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    read_valid_reg (
    .clk(clk_dup_1),
    .d(1'b1),
    .sr(rst_n_dup_1),
    .q(read_valid));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(542)
  PH1P_PHY_HR_PAD_V2 #(
    //.INHYS("ON"),
    //.LOCATION("A18"),
    //.ODT("OFF"),
    //.PCICLAMP("OFF"),
    //.PULL_STRENGTH("25K"),
    .DIRBYPEN("DISABLE"),
    .IDDRMODE("OFF"),
    .IDLYSRC("IOB"),
    .IEVENDATASAMP("DISABLE"),
    .INDELMUX("NODEL"),
    .IOTYPE("LVCMOS33"),
    .IPCLK_POS_NEG_EN("DISABLE"),
    .MODE("IN"),
    .ODDRMODE("OFF"),
    .ODLYSRC("ODDR"),
    .OUTDELMUX("NODEL"),
    .PULLMODE("PULLUP"),
    .TSMUX("1"))
    rst_n_syn_2 (
    .ipad(rst_n),
    .di(rst_n_dup_1));  // ../../../user_source/hdl_source/anlogic_logo_palette.v(6)

  // synthesis translate_off
  glbl glbl();
  always @(*) begin
    glbl.gsr <= PH1P_PHY_GSR.gsr;
    glbl.gsrn <= PH1P_PHY_GSR.gsrn;
    glbl.done_gwe <= PH1P_PHY_GSR.done_gwe;
    glbl.usr_gsrn_en <= PH1P_PHY_GSR.usr_gsrn_en;
  end
  // synthesis translate_on

endmodule 

