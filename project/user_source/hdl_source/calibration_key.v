// KEY2 release events: a long hold must never also toggle the overlay.
module calibration_key #(
    parameter integer DEBOUNCE_CYCLES = 750000,
    parameter integer HOLD_CYCLES = 150000000
)(
    input wire clk,
    input wire rst_n,
    input wire key_n,
    output reg short_o,
    output reg calibrate_o
);
    reg [2:0] key_sync;
    reg stable_n;
    reg [27:0] debounce_count;
    reg [27:0] hold_count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_sync <= 3'b111;
            stable_n <= 1'b1;
            debounce_count <= 0;
            hold_count <= 0;
            short_o <= 0;
            calibrate_o <= 0;
        end else begin
            key_sync <= {key_sync[1:0], key_n};
            short_o <= 0;
            calibrate_o <= 0;
            if (!stable_n && hold_count < HOLD_CYCLES)
                hold_count <= hold_count + 1'b1;
            if (key_sync[2] == stable_n) begin
                debounce_count <= 0;
            end else if (debounce_count == DEBOUNCE_CYCLES-1) begin
                debounce_count <= 0;
                stable_n <= key_sync[2];
                if (!key_sync[2]) begin
                    hold_count <= 0;
                end else begin
                    calibrate_o <= hold_count >= HOLD_CYCLES;
                    short_o <= hold_count < HOLD_CYCLES;
                    hold_count <= 0;
                end
            end else begin
                debounce_count <= debounce_count + 1'b1;
            end
        end
    end
endmodule
