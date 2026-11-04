`timescale 1ns / 1ps
// Seven-slot ownership controller. All ports use the DDR clock domain.
// Frame identity, DDR acceptance fence and decision must all match before pinning.
module motion_frame_store_ctrl (
    input wire clk,
    input wire rst_n,
    input wire [31:0] race_i,
    input wire clear_i,
    input wire cancel_analysis_i,
    input wire [6:0] read_protect_i,
    input wire allocate_i,
    input wire [31:0] allocate_source_i,
    input wire [31:0] allocate_race_i,
    input wire allocate_track_i,
    output wire allocate_ready_o,
    output wire [2:0] allocate_slot_o,
    input wire queued_i,
    input wire [2:0] queued_slot_i,
    input wire queued_good_i,
    input wire [31:0] queued_fence_i,
    input wire [31:0] committed_i,
    input wire validate_i,
    input wire [31:0] validate_source_i,
    input wire validate_good_i,
    output wire validate_ready_o,
    input wire decision_i,
    input wire [31:0] decision_source_i,
    input wire [31:0] decision_race_i,
    input wire [2:0] decision_mask_i,
    input wire decision_good_i,
    output wire decision_ready_o,
    input wire [1:0] view_lane_i,
    output wire [2:0] view_slot_o,
    output wire [31:0] view_source_o,
    output wire view_valid_o,
    output wire [2:0] evidence_valid_o,
    output wire [6:0] pinned_o,
    output wire live_valid_o,
    output wire [2:0] live_slot_o,
    output wire [31:0] live_source_o,
    output wire missing_o
);
    reg [6:0] occupied, writing, queued, validated, good, published;
    reg [6:0] tracked, decided, handled;
    reg [31:0] source [0:6];
    reg [31:0] frame_race [0:6];
    reg [31:0] fence [0:6];
    reg [2:0] arrivals [0:6];
    reg [2:0] lane_slot [0:2];
    reg [31:0] lane_source [0:2];
    reg [2:0] lane_valid;
    reg [2:0] history_latest, history_previous, cursor, service_slot;
    reg history_latest_valid, history_previous_valid;
    reg [31:0] race_seen, last_source;
    reg have_source, missing;
    reg [6:0] pin_mask, protected_mask;
    reg allocation_found, validation_found, decision_found;
    reg [2:0] allocation_slot, validation_slot, decision_slot;
    reg publish_found, pin_found;
    reg [2:0] publish_slot, pin_slot;
    integer index, lane, candidate;

    // Comparison is valid for distances shorter than half the 32-bit sequence.
    function reached;
        input [31:0] current, target;
        begin reached = $signed(current - target) >= 0; end
    endfunction

    always @* begin
        pin_mask = 0;
        for (lane = 0; lane < 3; lane = lane + 1)
            if (lane_valid[lane]) pin_mask[lane_slot[lane]] = 1;
        protected_mask = pin_mask | read_protect_i | writing |
                         (occupied & good & ~published) |
                         (occupied & good & ~handled);
        if (history_latest_valid) protected_mask[history_latest] = 1;
        if (history_previous_valid) protected_mask[history_previous] = 1;
        allocation_found = 0; allocation_slot = 0;
        validation_found = 0; validation_slot = 0;
        decision_found = 0; decision_slot = 0;
        publish_found = 0; publish_slot = 0;
        pin_found = 0; pin_slot = 0;
        for (index = 0; index < 7; index = index + 1) begin
            candidate = cursor + index;
            if (candidate >= 7) candidate = candidate - 7;
            if (!allocation_found && !protected_mask[candidate]) begin
                allocation_found = 1; allocation_slot = candidate;
            end
            if (occupied[index] && source[index] == validate_source_i) begin
                validation_found = 1; validation_slot = index;
            end
            if (occupied[index] && source[index] == decision_source_i) begin
                decision_found = 1; decision_slot = index;
            end

        end
        // Inspect one slot per DDR cycle. Complete frames are ordered into the
        // two-entry history by source ID, independently of physical slot order.
        publish_slot=service_slot;pin_slot=service_slot;
        publish_found=occupied[service_slot] && queued[service_slot] && validated[service_slot] &&
                      good[service_slot] && reached(committed_i,fence[service_slot]) && !published[service_slot];
        pin_found=occupied[service_slot] && good[service_slot] && published[service_slot] &&
                  decided[service_slot] && !handled[service_slot];

    end

    assign allocate_ready_o = allocation_found && race_i == race_seen;
    assign allocate_slot_o = allocation_slot;
    // Prevent a stale lookup from modifying a slot reallocated on this edge.
    // Descriptor FIFOs hold their packet until READY, so this is a bounded bubble.
    assign validate_ready_o = !(allocate_i && allocate_ready_o) &&
                              (validation_found || (have_source && reached(last_source, validate_source_i)));
    assign decision_ready_o = !(allocate_i && allocate_ready_o) &&
                              (decision_found || (have_source && reached(last_source, decision_source_i)));
    assign evidence_valid_o = lane_valid;
    assign pinned_o = pin_mask;
    assign view_valid_o = view_lane_i < 3 && lane_valid[view_lane_i];
    assign view_slot_o = view_lane_i < 3 ? lane_slot[view_lane_i] : 0;
    assign view_source_o = view_lane_i < 3 ? lane_source[view_lane_i] : 0;
    assign live_valid_o = history_previous_valid;
    assign live_slot_o = history_previous;
    assign live_source_o = source[history_previous];
    assign missing_o = missing;

    integer reset_slot, reset_lane;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            occupied <= 0; writing <= 0; queued <= 0; validated <= 0;
            good <= 0; published <= 0; tracked <= 0; decided <= 0; handled <= 0;
            lane_valid <= 0; history_latest <= 0; history_previous <= 0;
            history_latest_valid <= 0; history_previous_valid <= 0;
            cursor <= 0; service_slot <= 0; race_seen <= 0; last_source <= 0; have_source <= 0; missing <= 0;
            for (reset_slot = 0; reset_slot < 7; reset_slot = reset_slot + 1) begin
                source[reset_slot] <= 0; frame_race[reset_slot] <= 0;
                fence[reset_slot] <= 0; arrivals[reset_slot] <= 0;
            end
            for (reset_lane = 0; reset_lane < 3; reset_lane = reset_lane + 1) begin
                lane_slot[reset_lane] <= 0; lane_source[reset_lane] <= 0;
            end
        end else begin
            service_slot <= service_slot==6 ? 0 : service_slot+1'b1;
            if (allocate_i && allocate_ready_o) begin
                occupied[allocation_slot] <= 1; writing[allocation_slot] <= 1;
                queued[allocation_slot] <= 0; validated[allocation_slot] <= 0;
                good[allocation_slot] <= 1; published[allocation_slot] <= 0;
                tracked[allocation_slot] <= allocate_track_i && allocate_race_i==race_seen && !clear_i;
                decided[allocation_slot] <= !(allocate_track_i && allocate_race_i==race_seen && !clear_i);
                handled[allocation_slot] <= 0; arrivals[allocation_slot] <= 0;
                source[allocation_slot] <= allocate_source_i;
                frame_race[allocation_slot] <= allocate_race_i;
                last_source <= allocate_source_i; have_source <= 1;
                cursor <= allocation_slot == 6 ? 0 : allocation_slot + 1'b1;
            end
            if (queued_i) begin
                writing[queued_slot_i] <= 0; queued[queued_slot_i] <= 1;
                fence[queued_slot_i] <= queued_fence_i;
                if (!queued_good_i) begin
                    good[queued_slot_i] <= 0; tracked[queued_slot_i] <= 0;
                    decided[queued_slot_i] <= 1;
                end
            end
            if (validate_i && validate_ready_o && validation_found) begin
                validated[validation_slot] <= 1;
                if (!validate_good_i) begin
                    good[validation_slot] <= 0; tracked[validation_slot] <= 0;
                    decided[validation_slot] <= 1;
                    if (arrivals[validation_slot] != 0) missing <= 1;
                end
            end
            if (decision_i && decision_ready_o) begin
                if (decision_found && frame_race[decision_slot] == decision_race_i && decision_race_i == race_seen) begin
                    decided[decision_slot] <= 1;
                    if (decision_good_i) arrivals[decision_slot] <= decision_mask_i;
                    else arrivals[decision_slot] <= 0;
                end else if(decision_found && frame_race[decision_slot]==decision_race_i)begin
                    decided[decision_slot]<=1;arrivals[decision_slot]<=0;
                end else if (decision_good_i && decision_mask_i != 0 && decision_race_i == race_seen) missing <= 1;
            end
            if (publish_found) begin
                published[publish_slot] <= 1;
                if(!history_latest_valid || reached(source[publish_slot],source[history_latest]))begin
                    history_previous <= history_latest;
                    history_previous_valid <= history_latest_valid;
                    history_latest <= publish_slot; history_latest_valid <= 1;
                end else if(!history_previous_valid || reached(source[publish_slot],source[history_previous]))begin
                    history_previous <= publish_slot;history_previous_valid<=1;
                end
            end
            if (pin_found) begin
                handled[pin_slot] <= 1;
                if (frame_race[pin_slot] == race_seen && good[pin_slot]) begin
                    for (reset_lane = 0; reset_lane < 3; reset_lane = reset_lane + 1)
                        if (arrivals[pin_slot][reset_lane] && !lane_valid[reset_lane]) begin
                            lane_valid[reset_lane] <= 1;
                            lane_slot[reset_lane] <= pin_slot;
                            lane_source[reset_lane] <= source[pin_slot];
                        end
                end
            end
            if (cancel_analysis_i) begin
                tracked <= 0;
                decided <= 7'b1111111;
            end
            if (clear_i || race_i != race_seen) begin
                race_seen <= race_i; lane_valid <= 0; missing <= 0;
                tracked <= 0; decided <= 7'b1111111;
                handled <= 7'b1111111;
                for (reset_slot = 0; reset_slot < 7; reset_slot = reset_slot + 1) arrivals[reset_slot] <= 0;
            end
        end
    end
endmodule
