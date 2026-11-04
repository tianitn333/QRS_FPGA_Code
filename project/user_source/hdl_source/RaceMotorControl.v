`timescale 1ns/1ps
// Company: QRS / Engineer: project contributors
// Create Date: 2026-11-04 / Design: two rank flags
// Module: RaceMotorControl / Description: explicit reference and race-bound targets
// Simulation: tb_race_motor / References: accepted QRS calibration contract
// Dependencies: EmmCommandInterface / Version: 1.0
// Revision Date: 2026-11-04 / Revision History: isolated implementation
// 公司：QRS / 工程师：工程维护者
// 创建日期：2026-11-04 / 设计：双排名旗帜
// 模块名称：RaceMotorControl / 描述：人工参考与绑定本局的目标控制
// 仿真工程：tb_race_motor / 参考：已确认QRS标定合同
// 依赖：EmmCommandInterface / 版本：1.0
// 修订日期：2026-11-04 / 修订记录：独立控制实现
module RaceMotorControl #(
    parameter C_POLL_CLOCKS = 1500000, // 75MHz下20ms状态轮询。
    parameter C_MOVE_CLOCKS = 750000000 // 整个双轴操作10s时限。
) (
    input wire i_clk, i_rstn, // 单75MHz域、低有效复位。
    input wire i_arm, // 消抖后的SW2；关闭后停止、失能并作废参考。
    input wire i_reference, // SW2打开后新产生的SW3上升沿，人工已放回初始位置。
    input wire i_new_race, // 原比赛开始请求，工作中最多合并保存一次。
    output wire o_race_go, // 完成双轴归位检查后才放行比赛开始。
    input wire i_final_valid, // 原子最终结果包，不来自回放。
    input wire [31:0] i_final_race, // 原比赛ID，仅每局消费一次。
    input wire [5:0] i_final_ranks, // {L3,L2,L1}，每道2位名次。
    input wire [2:0] i_final_arrived, // 三道完整结果必须为111。
    input wire [3:0] i_final_fault, // 非零检测故障不可触发电机。
    input wire i_bus_ready, // CAN初始化已经完成。
    output wire o_bus_reset, // 完成停止流程后OFF状态复位协议层。
    output wire o_request, // 命令层ready时单拍提交。
    input wire i_command_ready, i_command_done, i_command_ok,
    input wire [3:0] i_command_error,
    input wire [7:0] i_motor_status,
    input wire i_position_negative,
    input wire [31:0] i_position_magnitude,
    output wire o_axis, // 0地址1/第一名，1地址2/第二名。
    output wire [3:0] o_command,
    output wire signed [15:0] o_target,
    output wire [3:0] o_state, o_error // 屏幕显示状态码和锁存错误码。
);
    localparam ST_OFF=4'd0, ST_REFERENCE=4'd1, ST_READY=4'd2, ST_SELECT=4'd3;
    localparam ST_ISSUE=4'd4, ST_WAIT=4'd5, ST_EVALUATE=4'd6, ST_PAUSE=4'd7;
    localparam ST_ADVANCE=4'd8, ST_STOP=4'd9, ST_FAULT=4'd10;
    localparam WORK_INIT=2'd0, WORK_HOME=2'd1, WORK_DISPLAY=2'd2, WORK_STOP=2'd3;
    reg [3:0] state_current,state_next;
    reg [1:0] reg_work,reg_first_lane,reg_second_lane;
    reg [3:0] reg_command_o;
    reg flag_axis_o,flag_referenced,flag_arm_previous,flag_stop_pending,flag_new_race;
    reg flag_race_go_o,flag_seen;
    reg [31:0] reg_seen_race;
    reg signed [15:0] reg_target_o;
    reg [16:0] reg_position_low,reg_position_high;
    reg flag_need_move,flag_final_status; // 动作前先查参考标志，位置核对后再查一次状态。
    reg flag_expected_negative;
    reg [3:0] reg_error_o;
    reg [20:0] cnt_poll;
    reg [29:0] cnt_motion;
    reg [1:0] dec_first_lane,dec_second_lane;
    reg flag_permutation;
    wire [1:0] dec_target_lane = reg_work == WORK_DISPLAY ?
                                 (flag_axis_o ? reg_second_lane : reg_first_lane) : 2'd0;
    wire flag_new_final = i_final_valid && (!flag_seen || i_final_race != reg_seen_race);
    wire flag_final_good = i_final_arrived == 7 && i_final_fault == 0 && flag_permutation;
    wire flag_position_range = i_position_magnitude[31:17] == 0 &&
                              i_position_magnitude[16:0] >= reg_position_low &&
                              i_position_magnitude[16:0] <= reg_position_high;
    wire flag_position_sign = !flag_expected_negative || i_position_negative;
    wire flag_position_good = flag_position_range && flag_position_sign;
    wire flag_status_good = i_motor_status[7] == 1 && i_motor_status[3:2] == 0 && i_motor_status[0];
    wire flag_expired = cnt_motion >= C_MOVE_CLOCKS-1;
    assign o_race_go=flag_race_go_o;
    assign o_bus_reset=state_current==ST_OFF;
    assign o_request=state_current==ST_ISSUE && i_command_ready &&
                     (reg_work==WORK_STOP || (i_arm && !flag_stop_pending && !flag_expired));
    assign o_axis=flag_axis_o;
    assign o_command=reg_command_o;
    assign o_target=reg_target_o;
    assign o_error=reg_error_o;
    // 用户界面：0关、1待参考、2初始化、3可比赛、4展示、5归位、6故障。
    assign o_state=state_current==ST_OFF ? 4'd0 : state_current==ST_REFERENCE ? 4'd1 :
                   state_current==ST_FAULT ? 4'd6 : state_current==ST_READY ? 4'd3 :
                   reg_work==WORK_INIT ? 4'd2 : reg_work==WORK_DISPLAY ? 4'd4 : 4'd5;
    always @(*) begin
        flag_permutation=1;dec_first_lane=0;dec_second_lane=0;
        case(i_final_ranks)
            6'h39:begin dec_first_lane=1;dec_second_lane=2;end
            6'h2d:begin dec_first_lane=1;dec_second_lane=3;end
            6'h36:begin dec_first_lane=2;dec_second_lane=1;end
            6'h1e:begin dec_first_lane=3;dec_second_lane=1;end
            6'h27:begin dec_first_lane=2;dec_second_lane=3;end
            6'h1b:begin dec_first_lane=3;dec_second_lane=2;end
            default:flag_permutation=0;
        endcase
    end
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)state_current<=ST_OFF;
        else state_current<=state_next;
    end
    always @(*) begin
        state_next=state_current;
        case(state_current)
            ST_OFF:if(i_arm)state_next=ST_REFERENCE;
            ST_REFERENCE:begin
                if(!i_arm)state_next=ST_OFF;
                else if(i_reference && i_bus_ready)state_next=ST_SELECT;
            end
            ST_READY:begin
                if(flag_stop_pending || !i_arm)state_next=ST_STOP;
                else if(flag_new_race)state_next=ST_SELECT;
                else if(flag_new_final && flag_final_good)state_next=ST_SELECT;
            end
            ST_SELECT:begin
                if((flag_stop_pending || !i_arm || flag_expired) && reg_work!=WORK_STOP)state_next=ST_STOP;
                else state_next=ST_ISSUE;
            end
            ST_ISSUE:begin
                if((flag_stop_pending || !i_arm || flag_expired) && reg_work!=WORK_STOP)state_next=ST_STOP;
                else if(i_command_ready)state_next=ST_WAIT;
            end
            ST_WAIT:if(i_command_done)begin
                if(reg_work==WORK_STOP)state_next=ST_EVALUATE;
                else if(flag_stop_pending || !i_arm || !i_command_ok || flag_expired)state_next=ST_STOP;
                else state_next=ST_EVALUATE;
            end
            ST_EVALUATE:begin
                if(reg_work!=WORK_STOP && (flag_stop_pending || !i_arm || flag_expired))state_next=ST_STOP;
                else if(reg_work==WORK_STOP)begin
                    if(reg_command_o==6)state_next=ST_SELECT;
                    else state_next=ST_ADVANCE;
                end else case(reg_command_o)
                    0,1,2,3,8:state_next=ST_SELECT;
                    4:begin
                        if(!flag_status_good)state_next=ST_STOP;
                        else if(flag_final_status)begin
                            if(reg_work==WORK_INIT || i_motor_status[1])state_next=ST_ADVANCE;
                            else state_next=ST_PAUSE;
                        end else if(flag_need_move || reg_work==WORK_INIT || i_motor_status[1])state_next=ST_SELECT;
                        else state_next=ST_PAUSE;
                    end
                    5:begin
                        if(flag_position_good)state_next=ST_SELECT;
                        else if(reg_work==WORK_INIT)state_next=ST_STOP;
                        else state_next=ST_PAUSE;
                    end
                    default:state_next=ST_STOP;
                endcase
            end
            ST_PAUSE:begin
                if(flag_stop_pending || !i_arm || flag_expired)state_next=ST_STOP;
                else if(cnt_poll>=C_POLL_CLOCKS-1)state_next=ST_SELECT;
            end
            ST_ADVANCE:begin
                if(reg_work!=WORK_STOP && (flag_stop_pending || !i_arm || flag_expired))state_next=ST_STOP;
                else if(!flag_axis_o)state_next=ST_SELECT;
                else if(reg_work==WORK_STOP)begin
                    if(!i_arm)state_next=ST_OFF;
                    else state_next=ST_FAULT;
                end else state_next=ST_READY;
            end
            ST_STOP:state_next=ST_SELECT;
            ST_FAULT:if(!i_arm)state_next=ST_OFF;
            default:state_next=ST_STOP;
        endcase
    end
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)begin
            reg_work<=WORK_INIT;reg_first_lane<=0;reg_second_lane<=0;reg_command_o<=0;
            flag_axis_o<=0;flag_referenced<=0;flag_arm_previous<=0;flag_stop_pending<=0;
            flag_new_race<=0;flag_race_go_o<=0;flag_seen<=0;reg_seen_race<=0;
            reg_target_o<=0;reg_position_low<=0;reg_position_high<=128;flag_expected_negative<=0;
            reg_error_o<=0;cnt_poll<=0;cnt_motion<=0;flag_need_move<=0;flag_final_status<=0;
        end else begin
            flag_arm_previous<=i_arm;flag_race_go_o<=0;
            if(flag_new_final)begin flag_seen<=1;reg_seen_race<=i_final_race;end
            if(i_new_race)begin
                if(!i_arm)flag_race_go_o<=1;
                else if(flag_referenced)flag_new_race<=1;
            end
            if(flag_arm_previous && !i_arm)begin
                flag_referenced<=0;flag_stop_pending<=1;flag_new_race<=0;
            end
            if(state_current==ST_OFF || state_current==ST_REFERENCE || state_current==ST_READY)cnt_motion<=0;
            else if(!flag_expired)cnt_motion<=cnt_motion+1'b1;
            if(state_current!=ST_PAUSE)cnt_poll<=0;
            else cnt_poll<=cnt_poll+1'b1;
            if(state_current==ST_REFERENCE && i_reference && i_bus_ready)begin
                reg_work<=WORK_INIT;flag_axis_o<=0;reg_command_o<=0;reg_error_o<=0;
                flag_stop_pending<=0;flag_new_race<=0;flag_need_move<=0;flag_final_status<=0;
            end
            if(state_current==ST_READY && state_next==ST_SELECT)begin
                flag_axis_o<=0;reg_command_o<=4;flag_need_move<=1;flag_final_status<=0;
                if(flag_new_race)reg_work<=WORK_HOME;
                else begin
                    reg_work<=WORK_DISPLAY;reg_first_lane<=dec_first_lane;reg_second_lane<=dec_second_lane;
                end
            end
            if(state_current==ST_SELECT)begin
                case(dec_target_lane)
                    1:begin reg_target_o<=-16'sd1727;reg_position_low<=35241;reg_position_high<=35497;end
                    2:begin reg_target_o<=-16'sd2817;reg_position_low<=57564;reg_position_high<=57820;end
                    3:begin reg_target_o<=-16'sd4047;reg_position_low<=82755;reg_position_high<=83011;end
                    default:begin reg_target_o<=0;reg_position_low<=0;reg_position_high<=128;end
                endcase
                flag_expected_negative<=dec_target_lane!=0;
            end
            if(state_current==ST_WAIT && i_command_done && !i_command_ok && reg_error_o==0)
                reg_error_o<=i_command_error;
            if(state_current==ST_EVALUATE)begin
                if(reg_work==WORK_STOP)begin
                    if(reg_command_o==6)reg_command_o<=7;
                end else case(reg_command_o)
                    0:reg_command_o<=1;
                    1:reg_command_o<=2;
                    2:reg_command_o<=8;
                    3,8:reg_command_o<=4;
                    4:begin
                        if(flag_need_move)begin reg_command_o<=3;flag_need_move<=0;end
                        else reg_command_o<=5;
                        if(!flag_status_good && reg_error_o==0)reg_error_o<=4;
                    end
                    5:begin
                        if(flag_position_good)begin flag_final_status<=1;reg_command_o<=4;end
                        if(!flag_position_good && reg_work==WORK_INIT && reg_error_o==0)reg_error_o<=5;
                    end
                    default:begin end
                endcase
            end
            if(state_current==ST_PAUSE)begin
                flag_final_status<=0;
                if(state_next==ST_SELECT)reg_command_o<=4;
            end
            if(state_current==ST_ADVANCE)begin
                if(!flag_axis_o)begin
                    flag_axis_o<=1;
                    if(reg_work==WORK_INIT)reg_command_o<=0;
                    else if(reg_work==WORK_STOP)reg_command_o<=6;
                    else reg_command_o<=4;
                    flag_need_move<=reg_work!=WORK_INIT && reg_work!=WORK_STOP;flag_final_status<=0;
                end else begin
                    if(reg_work==WORK_INIT && state_next==ST_READY)flag_referenced<=1;
                    if(reg_work==WORK_HOME && state_next==ST_READY)begin flag_race_go_o<=1;flag_new_race<=0;end
                end
            end
            if(state_current==ST_STOP)begin
                reg_work<=WORK_STOP;flag_axis_o<=0;reg_command_o<=6;
                flag_stop_pending<=0;flag_referenced<=0;flag_new_race<=0;
                if(flag_expired && reg_error_o==0)reg_error_o<=6;
            end
        end
    end
endmodule
