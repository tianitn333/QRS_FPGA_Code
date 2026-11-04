`timescale 1ns/1ns
module tb_edge_fill_random;
 tb_edge_fill_stream #(.FRAMES(33),
 .IN_FILE("sim/inputs/1111c028edee_input.hex"),
 .EXP_FILE("sim/inputs/3c6092bd3794_expected.hex"),
 .CNT_FILE("sim/inputs/956a11a45f28_counts.hex")) random_case();
endmodule
