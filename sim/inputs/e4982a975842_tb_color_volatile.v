`timescale 1ns/1ps
// Volatile editor contract: independent defaults, atomic commit, full field limits,
// mode retention, preview, restore and reset. No SD model or completion is supplied.
module tb_color_volatile;
    reg clk=0,rst_n=0;
    always #5 clk=~clk;
    reg [6:0] keys=0;
    reg preview=0,valid=0,last=0;
    reg [11:0] y=0;
    wire [239:0] edit_bus,eff;
    wire pending,editing,panel,preview_out,restore_sel,edge_toggle,status_show,committed;
    wire [1:0] mode,cursor;
    wire [2:0] page;
    wire [31:0] version;
    localparam [239:0] DEFAULTS={16'd32,16'd18,16'd44,16'd40,16'd40,16'd20,
        16'd40,16'd48,16'd12,16'd48,16'd36,16'd12,16'd48,16'd48,16'd24};
    reg [239:0] expected=DEFAULTS,old_eff;
    integer field,step,upper,lower;
    color_ui_fsm #(.MS_CYC(2),.POST_EXIT_MS(4)) editor(
        .clk(clk),.rst_n(rst_n),.I_preview_select(preview),
        .I_k1_short(keys[0]),.I_k1_long(keys[1]),.I_k2_short(keys[2]),.I_k2_long(keys[3]),
        .I_k3_step(keys[4]),.I_k4_step(keys[5]),.I_k4_long15(keys[6]),.I_eff(eff),
        .O_edit_bus(edit_bus),.O_commit_req(pending),.O_mode(mode),.O_edit(editing),
        .O_panel(panel),.O_preview(preview_out),.O_page(page),.O_cursor(cursor),
        .O_edge_toggle(edge_toggle),.O_status_show(status_show),.O_restore_sel(restore_sel));
    color_param_bank #(.IMG_H(4)) bank(.clk(clk),.rst_n(rst_n),.valid_i(valid),
        .last_i(last),.y_i(y),.I_edit(edit_bus),.I_commit_req(pending),
        .O_eff(eff),.O_version(version),.O_committed(committed));
    task pulse;
        input [6:0] mask;
        begin @(negedge clk);keys=mask;@(negedge clk);keys=0;end
    endtask
    task check_edit;
        begin if(edit_bus!==expected)$fatal(1,"FAIL edit expected=%h got=%h",expected,edit_bus);end
    endtask
    task commit_frame;
        begin
            @(negedge clk);valid=1;last=1;y=3;
            @(negedge clk);valid=0;last=0;y=0;
            if(eff!==expected||pending)$fatal(1,"FAIL atomic frame end commit");
        end
    endtask
    initial begin
        repeat(3)@(negedge clk);rst_n=1;repeat(2)@(negedge clk);
        check_edit();if(eff!==DEFAULTS||pending||version!==0)$fatal(1,"FAIL defaults");
        pulse(1);pulse(1);pulse(1);pulse(2);
        if(!editing||!panel||mode!=3)$fatal(1,"FAIL editor blocked without SD");
        old_eff=eff;pulse(32);expected[15:0]=25;check_edit();
        repeat(30)@(negedge clk);
        if(eff!==old_eff||!pending)$fatal(1,"FAIL changed before last pixel");
        @(negedge clk);valid=1;last=1;y=2;
        @(negedge clk);valid=0;last=0;
        if(eff!==old_eff)$fatal(1,"FAIL non-final row committed");
        commit_frame();if(version!=1)$fatal(1,"FAIL commit version");
        pulse(8);pulse(1);pulse(1);pulse(1);pulse(1);
        repeat(1200)@(negedge clk);check_edit();
        if(eff!==expected||mode!=3||editing)$fatal(1,"FAIL retention across modes/idle");
        preview=1;pulse(2);if(!preview_out)$fatal(1,"FAIL HIT preview");
        preview=0;repeat(2)@(negedge clk);if(preview_out)$fatal(1,"FAIL RGB preview");
        for(field=0;field<15;field=field+1)begin
            if(page!=(field/3)||cursor!=(field%3))$fatal(1,"FAIL navigation %0d",field);
            upper=field==14?4096:((field<12&&field%3!=0)?120:255);
            lower=field==14?1:((field<12&&field%3!=0)?32:0);
            for(step=0;step<upper+2;step=step+1)begin
                pulse(32);if(expected[field*16+:16]<upper)expected[field*16+:16]=expected[field*16+:16]+1;
            end
            check_edit();commit_frame();
            pulse(48);check_edit(); // Opposite steps together must cancel.
            for(step=0;step<upper+2;step=step+1)begin
                pulse(16);if(expected[field*16+:16]>lower)expected[field*16+:16]=expected[field*16+:16]-1;
            end
            check_edit();commit_frame();pulse(4);
        end
        if(!restore_sel)$fatal(1,"FAIL restore selection");
        pulse(64);expected=DEFAULTS;check_edit();commit_frame();
        pulse(4);pulse(32);expected[15:0]=25;check_edit();commit_frame();
        @(negedge clk);rst_n=0;#1;
        if(edit_bus!==DEFAULTS||eff!==DEFAULTS)$fatal(1,"FAIL asynchronous reset defaults");
        @(negedge clk);rst_n=1;repeat(3)@(negedge clk);
        if(mode!=0||editing||pending||version!=0)$fatal(1,"FAIL clean reset state");
        $display("PASS volatile color defaults, all 15 field limits, atomic commit, retention, preview, restore and reset");
        $finish;
    end
    initial begin #3000000;$fatal(1,"FAIL timeout");end
endmodule
