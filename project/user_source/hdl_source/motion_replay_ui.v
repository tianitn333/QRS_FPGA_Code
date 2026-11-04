`timescale 1ns / 1ps
// Manual evidence page selection; entering replay never emits a race command.
module motion_replay_ui (
    input wire clk, rst_n, mode_i,
    input wire [2:0] state_i, evidence_i,
    input wire short_key_i, long_key_i, previous_i, next_i,
    output reg replay_o,
    output reg [1:0] lane_o,
    output reg race_key_o,
    output reg no_evidence_o
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            replay_o <= 0; lane_o <= 0; race_key_o <= 0; no_evidence_o <= 0;
        end else begin
            race_key_o <= 0;
            if (!mode_i) begin replay_o <= 0; lane_o <= 0; no_evidence_o <= 0; end
            else if (replay_o) begin
                if (short_key_i) begin replay_o <= 0; no_evidence_o <= 0; end
                else if (previous_i ^ next_i) begin
                    if (next_i) lane_o <= lane_o == 2 ? 0 : lane_o + 1'b1;
                    else lane_o <= lane_o == 0 ? 2 : lane_o - 1'b1;
                end
            end else if (short_key_i) begin race_key_o <= 1; no_evidence_o <= 0; end
            else if (long_key_i && (state_i == 4 || state_i == 5)) begin
                if (evidence_i != 0) begin
                    replay_o <= 1; lane_o <= evidence_i[0] ? 0 : (evidence_i[1] ? 1 : 2);
                    no_evidence_o <= 0;
                end else no_evidence_o <= 1;
            end
        end
    end
endmodule
