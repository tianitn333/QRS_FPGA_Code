`timescale 1ns/1ns
module tb_edge_fill_capacity;
 tb_edge_fill_stream #(.W(1280),.H(64),.HT(1650),.FRAMES(10),.CAP(6144),
 .IN_FILE("sim/inputs/7261561338c3_input.hex"),
 .EXP_FILE("sim/inputs/1b1100923f24_expected.hex"),
 .CNT_FILE("sim/inputs/c7f4864e27eb_counts.hex")) capacity();
endmodule
