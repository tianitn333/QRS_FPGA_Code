`timescale 1ns/1ps
// 只建模命令完成与编码器，不伪装CAN电气或真实机械。
module tb_race_motor_marker;
    reg clock=0;
    always #5 clock=~clock;
    reg reset_n=0,arm=0,reference=0,new_race=0,final_valid=0;
    reg [31:0] final_race=0;
    reg [5:0] ranks=6'h39;
    reg [2:0] arrived=7;
    reg [3:0] final_fault=0;
    wire race_go,bus_reset,request,axis;
    wire [3:0] command;
    wire signed [15:0] target;
    wire [3:0] state,error;
    reg command_ready=1,command_done=0,command_ok=1;
    reg [7:0] motor_status=3;
    reg negative=0;
    reg [31:0] magnitude=0;
    reg [3:0] command_error=0;
    reg [3:0] pending_command;
    reg pending_axis;
    integer pending=0,positions[0:1];
    integer moves=0,go_count=0,stops=0,disables=0,observations=0;
    reg inject_stall=0,inject_wrong_position=0;
    reg [1:0] reference_marker=0;
    reg inject_reset_after_position=0;
    integer saved_moves,saved_go;
    RaceMotorControl #(.C_POLL_CLOCKS(8),.C_MOVE_CLOCKS(800)) dut(
        .i_clk(clock),.i_rstn(reset_n),.i_arm(arm),.i_reference(reference),.i_new_race(new_race),
        .o_race_go(race_go),.i_final_valid(final_valid),.i_final_race(final_race),.i_final_ranks(ranks),
        .i_final_arrived(arrived),.i_final_fault(final_fault),.i_bus_ready(1'b1),.o_bus_reset(bus_reset),
        .o_request(request),.i_command_ready(command_ready),.i_command_done(command_done),.i_command_ok(command_ok),
        .i_command_error(command_error),.i_motor_status(motor_status),.i_position_negative(negative),
        .i_position_magnitude(magnitude),.o_axis(axis),.o_command(command),.o_target(target),.o_state(state),.o_error(error));
    always @(posedge clock)begin
        command_done<=0;
        if(race_go)begin
            if(arm && (positions[0]!=0 || positions[1]!=0))$fatal(1,"FAIL race released before both axes home");
            go_count=go_count+1;
        end
        if(request && command_ready)begin
            pending<=4;command_ready<=0;pending_command<=command;pending_axis<=axis;
            if(command==1)positions[axis]=0;
            if(command==8)reference_marker[axis]=1;
            if(command==3)begin positions[axis]=target;moves=moves+1;end
            if(command==6)stops=stops+1;
            if(command==7)disables=disables+1;
        end else if(pending>0)begin
            pending<=pending-1;
            if(pending==1)begin
                command_done<=1;command_ready<=1;command_ok<=1;
                motor_status<=(inject_stall?8'h0d:8'h03) | (reference_marker[pending_axis]?8'h80:8'h00);
                negative<=positions[pending_axis]<0;
                case(positions[pending_axis])
                    -1727:magnitude<=35369;
                    -2817:magnitude<=57692;
                    -4047:magnitude<=82883;
                    default:magnitude<=0;
                endcase
                if(inject_wrong_position)magnitude<=0;
                if(inject_reset_after_position && pending_command==5)reference_marker[pending_axis]=0;
            end
        end
    end
    task automatic wait_state;
        input [3:0] expected;
        integer timeout;
        begin
            timeout=0;
            while(state!==expected && timeout<2000)begin @(negedge clock);timeout=timeout+1;end
            if(timeout==2000)$fatal(1,"FAIL state timeout expected=%d actual=%d error=%d",expected,state,error);
            observations=observations+1;
        end
    endtask
    task automatic establish_reference;
        begin
            arm=1;wait_state(1);repeat(4)@(negedge clock);
            reference=1;@(negedge clock);reference=0;
            wait_state(2);wait_state(3);
            if(positions[0]!=0 || positions[1]!=0)$fatal(1,"FAIL reference");
        end
    endtask
    task automatic result;
        input [5:0] ranking;
        input integer first_target,second_target;
        integer baseline;
        begin
            baseline=moves;
            @(negedge clock);ranks=ranking;final_race=final_race+1;final_valid=1;
            wait_state(4);wait_state(3);
            if(positions[0]!=first_target || positions[1]!=second_target || moves!=baseline+2)
                $fatal(1,"FAIL targets a=%0d b=%0d moves=%0d",positions[0],positions[1],moves-baseline);
            repeat(30)@(negedge clock);
            if(moves!=baseline+2)$fatal(1,"FAIL repeated same race triggered again");
            final_valid=0;
        end
    endtask
    task automatic begin_next;
        integer baseline;
        begin
            baseline=go_count;
            @(negedge clock);new_race=1;@(negedge clock);new_race=0;
            wait_state(5);wait_state(3);repeat(3)@(negedge clock);
            if(go_count!=baseline+1)$fatal(1,"FAIL pending race launch count");
        end
    endtask
    initial begin
        positions[0]=0;positions[1]=0;
        repeat(4)@(negedge clock);reset_n=1;repeat(3)@(negedge clock);
        new_race=1;@(negedge clock);new_race=0;repeat(3)@(negedge clock);
        if(go_count!=1 || moves || !bus_reset)$fatal(1,"FAIL image-only mode");
        establish_reference();
        result(6'h39,-1727,-2817);begin_next();
        result(6'h2d,-1727,-4047);begin_next();
        result(6'h36,-2817,-1727);begin_next();
        result(6'h1e,-4047,-1727);begin_next();
        result(6'h27,-2817,-4047);begin_next();
        result(6'h1b,-4047,-2817);begin_next();
        final_fault=1;final_race=final_race+1;final_valid=1;
        repeat(30)@(negedge clock);
        if(state!=3 || positions[0] || positions[1])$fatal(1,"FAIL detector error moved motors");
        final_valid=0;final_fault=0;
        inject_stall=1;final_race=final_race+1;final_valid=1;
        wait_state(6);
        if(error!=4 || stops!=2 || disables!=2)$fatal(1,"FAIL stall handling error=%d stops=%d disables=%d",error,stops,disables);
        final_valid=0;inject_stall=0;arm=0;wait_state(0);
        establish_reference();
        inject_stall=1;final_race=final_race+1;final_valid=1;
        while(!(request && command==6))@(negedge clock);
        arm=0;wait_state(0);
        if(stops!=4 || disables!=4)$fatal(1,"FAIL disarm during fault STOP lost remaining commands stops=%0d disables=%0d",stops,disables);
        final_valid=0;inject_stall=0;
        establish_reference();
        // 已参考驱动独立重启：下次动作前必须拒绝，不可先发MOVE。
        saved_moves=moves;reference_marker[0]=0;final_race=final_race+1;final_valid=1;
        wait_state(6);
        if(error!=4 || moves!=saved_moves)$fatal(1,"FAIL lost reference marker permitted MOVE");
        final_valid=0;arm=0;wait_state(0);
        establish_reference();
        // 归位读到位置后重启：最后一次状态复查禁止放行比赛。
        inject_reset_after_position=1;saved_go=go_count;
        @(negedge clock);new_race=1;@(negedge clock);new_race=0;
        wait_state(6);
        if(error!=4 || go_count!=saved_go)$fatal(1,"FAIL restart after position check released race");
        inject_reset_after_position=0;arm=0;wait_state(0);
        establish_reference();
        inject_wrong_position=1;final_race=final_race+1;final_valid=1;
        wait_state(6);
        if(error!=6)$fatal(1,"FAIL stale arrived/position must time out, error=%d",error);
        final_valid=0;inject_wrong_position=0;arm=0;wait_state(0);
        establish_reference();
        final_race=final_race+1;final_valid=1;wait_state(4);arm=0;wait_state(0);
        if(stops<12 || disables<12)$fatal(1,"FAIL disarm stop/disable sequence");
        arm=1;wait_state(1);repeat(30)@(negedge clock);
        if(state!=1 || request)$fatal(1,"FAIL rearmed without new reference");
        reset_n=0;repeat(4)@(negedge clock);arm=0;reset_n=1;repeat(10)@(negedge clock);
        if(state!=0 || request || !bus_reset)$fatal(1,"FAIL reset automatic restart");
        $display("PASS race motor observations=%0d moves=%0d go=%0d stops=%0d",observations,moves,go_count,stops);$finish;
    end
    initial begin #1000000;$fatal(1,"FAIL global timeout");end
endmodule
