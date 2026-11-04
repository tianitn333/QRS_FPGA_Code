`timescale 1ns/1ps
module tb_probe_command_loss;
    parameter CHECK_GAP=0;
    reg clock=0,reset_n=0,arm=0,reference=0;
    always #6.666667 clock=~clock;
    reg [3:0] fault_mode=0;
    wire transmit,peer_transmit;
    wire bus_level=transmit & peer_transmit;
    wire host_receive=fault_mode==2 ? 1'b1 : fault_mode==3 ? 1'b0 : bus_level;
    wire peer_receive=(fault_mode>=1 && fault_mode<=3) ? 1'b1 : bus_level;
    wire [3:0] state,error;
    reg [7:0] address=0,write_data=0;
    wire [7:0] read_data;
    reg cycle=0,strobe=0,write_enable=0;
    wire acknowledge;
    integer accepts=0,completions=0,low_samples=0,rx_count=0,cycles=0;
    integer commands=0,checks=0,last_done=-1,gaps_checked=0,min_gap=2147483647;
    integer mode,index,axis,timeout;
    reg [7:0] value,function_code;
    main_can_harness dut(.clk(clock),.rst_n(reset_n),.I_motor_arm(arm),.I_motor_reference(reference),
        .I_can_receive(host_receive),.O_can_transmit(transmit),.state(state),.error(error));
    // Accelerate switch debounce; it was separately tested at real20ms.
    // Application deadline20ms stays greater than the unchanged transport10ms.
    // New main's real1500000-cycle command gap is NOT shortened.
    defparam dut.u_motor_arm_switch.STABLE_CYCLES=64;
    defparam dut.u_motor_reference_switch.STABLE_CYCLES=64;
    defparam dut.u_motor_commands.C_RESPONSE_CLOCKS=1500000;
    can_top peer(.wb_clk_i(clock),.wb_rst_i(!reset_n),.clk_i(clock),.wb_dat_i(write_data),
        .wb_dat_o(read_data),.wb_cyc_i(cycle),.wb_stb_i(strobe),.wb_we_i(write_enable),
        .wb_adr_i(address),.wb_ack_o(acknowledge),.rx_i(peer_receive),.tx_o(peer_transmit),
        .bus_off_on(),.irq_on(),.clkout_o(),.o_probe_registers());
    always @(posedge clock)begin
        if(!reset_n)begin accepts<=0;completions<=0;low_samples<=0;rx_count<=0;cycles<=0;
            last_done<=-1;gaps_checked<=0;min_gap<=2147483647;end
        else begin
            cycles<=cycles+1;
            if(dut.S_motor_command_done && dut.S_motor_command<6)last_done<=cycles;
            if(dut.S_motor_request && dut.S_motor_command<6 && last_done>=0)begin
                if(CHECK_GAP && cycles-last_done<1500000)$fatal(1,"FAIL real20ms gap missing");
                if(cycles-last_done<min_gap)min_gap<=cycles-last_done;
                gaps_checked<=gaps_checked+1;
            end
            if(dut.S_can_tx_valid && dut.S_can_tx_ready)accepts<=accepts+1;
            if(dut.S_can_tx_done)completions<=completions+1;
            if(dut.S_can_rx_valid)rx_count<=rx_count+1;
            if(!transmit)low_samples<=low_samples+1;
        end
    end
    task write_register;
        input [7:0] register_address,data;
        integer count;
        begin
            @(negedge clock);address=register_address;write_data=data;write_enable=1;cycle=1;strobe=1;count=0;
            while(acknowledge!==1 && count<100)begin @(negedge clock);count=count+1;end
            if(count==100)$fatal(1,"FAIL peer WB write");
            cycle=0;strobe=0;write_enable=0;repeat(10)@(negedge clock);
        end
    endtask
    task read_register;
        input [7:0] register_address;
        output [7:0] data;
        integer count;
        begin
            @(negedge clock);address=register_address;write_enable=0;cycle=1;strobe=1;count=0;
            while(acknowledge!==1 && count<100)begin @(negedge clock);count=count+1;end
            if(count==100)$fatal(1,"FAIL peer WB read");
            data=read_data;cycle=0;strobe=0;repeat(10)@(negedge clock);
        end
    endtask
    task configure_peer;
        integer j;
        begin
            write_register(0,1);write_register(31,8'h80);write_register(6,4);write_register(7,8'h2a);
            for(j=0;j<4;j=j+1)begin write_register(16+j,0);write_register(20+j,8'hff);end
            write_register(0,0);
        end
    endtask
    task check_byte;
        input [7:0] actual,expected;
        begin checks=checks+1;if(actual!==expected)$fatal(1,"FAIL CAN byte actual=%h expected=%h",actual,expected);end
    endtask
    task receive_peer;
        input [28:0] identifier;
        input [3:0] length;
        input [63:0] payload;
        integer j,count;
        reg [63:0] shifted;
        begin
            count=0;value=0;
            while(!value[0] && count<100000)begin read_register(2,value);count=count+1;end
            if(count==100000)$fatal(1,"FAIL peer receive timeout state=%d error=%d",state,error);
            read_register(16,value);check_byte(value,{4'h8,length});
            read_register(17,value);check_byte(value,identifier[28:21]);
            read_register(18,value);check_byte(value,identifier[20:13]);
            read_register(19,value);check_byte(value,identifier[12:5]);
            read_register(20,value);check_byte(value,{identifier[4:0],3'd0});shifted=payload;
            for(j=0;j<length;j=j+1)begin read_register(21+j,value);check_byte(value,shifted[63:56]);shifted=shifted<<8;end
            write_register(1,4);commands=commands+1;
        end
    endtask
    task send_peer;
        input [28:0] identifier;
        input [3:0] length;
        input [63:0] payload;
        integer j,baseline,count;
        reg [63:0] shifted;
        begin
            baseline=rx_count;
            write_register(16,{4'h8,length});write_register(17,identifier[28:21]);
            write_register(18,identifier[20:13]);write_register(19,identifier[12:5]);
            write_register(20,{identifier[4:0],3'd0});shifted=payload;
            for(j=0;j<length;j=j+1)begin write_register(21+j,shifted[63:56]);shifted=shifted<<8;end
            write_register(1,1);count=0;
            while(rx_count==baseline && count<100000)begin @(negedge clock);count=count+1;end
            if(count==100000)$fatal(1,"FAIL host receive timeout");
        end
    endtask
    task restart;
        begin
            @(negedge clock);reset_n=0;arm=0;reference=0;cycle=0;strobe=0;write_enable=0;
            repeat(20)@(negedge clock);reset_n=1;configure_peer();
        end
    endtask
    task start_reference;
        begin
            arm=1;wait(state==1);wait(dut.S_can_ready);repeat(100)@(negedge clock);reference=1;
            wait(dut.S_motor_reference);
        end
    endtask
    initial begin
        restart();arm=1;wait(state==1);wait(dut.S_can_ready);repeat(100)@(negedge clock);
        // Keep initialization and its MODE/BTR intact. Drop only command-register writes.
        force dut.u_motor_can.CanCore_Inst.i_can_registers.we_command=1'b0;
        reference=1;wait(dut.S_motor_reference);timeout=0;
        while(state!=6 && timeout<10000000)begin @(negedge clock);timeout=timeout+1;end
        $display("OBS lost_command state=%d err=%d accepts=%d done=%d tx_low=%d ready=%b core_mode=%h btr0=%h",state,error,
            accepts,completions,low_samples,dut.S_can_ready,dut.u_motor_can.CanCore_Inst.i_can_registers.mode,
            dut.u_motor_can.CanCore_Inst.i_can_registers.bus_timing_0);
        if(state!=6 || error!=1 || low_samples!=0 || accepts!=5 || completions!=5 || !dut.S_can_ready ||
            dut.u_motor_can.CanCore_Inst.i_can_registers.mode!==0 || dut.u_motor_can.CanCore_Inst.i_can_registers.bus_timing_0!==8'h04)
            $fatal(1,"FAIL command-register write loss classification");
        if(!dut.S_can_probe_valid || dut.S_can_probe_snapshot[127:96]!=32'h0080042a ||
            dut.S_can_probe_snapshot[79:64]!=16'h0146 || dut.S_can_probe_snapshot[63:56]!=4 ||
            dut.S_can_probe_snapshot[47:32]!=16'h0101 || dut.S_can_probe_snapshot[31:24]!=0 || dut.S_can_probe_snapshot[15:0]!=16'h01d1)
            $fatal(1,"FAIL command-loss first fault snapshot %h",dut.S_can_probe_snapshot);
        $display("SNAP command_loss words=%h %h %h %h",dut.S_can_probe_snapshot[127:96],dut.S_can_probe_snapshot[95:64],
            dut.S_can_probe_snapshot[63:32],dut.S_can_probe_snapshot[31:0]);
        release dut.u_motor_can.CanCore_Inst.i_can_registers.we_command;
        $display("PASS valid MODE/BTR, missing TX command writes produce false tx_done and CAN6 ERR1 without a frame");$finish;
    end
    initial begin #700000000;$fatal(1,"FAIL deeper causes watchdog");end
endmodule
