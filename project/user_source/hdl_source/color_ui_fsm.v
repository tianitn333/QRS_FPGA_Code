`include "color_params.vh"
// Four-mode volatile editor. Reset restores defaults; frame-end commit remains atomic.
module color_ui_fsm #(
    parameter integer MS_CYC      = 75000,   // 1ms
    parameter integer POST_EXIT_MS= 2000,    // 退出编辑后状态行保留时长

    // 工厂默认（与 color_param_bank 同源）
    parameter integer DEF_R_DIFF   = `COLOR_DEF_R_DIFF,
    parameter integer DEF_R_RG_Q5  = `COLOR_DEF_R_RG_Q5,
    parameter integer DEF_R_RB_Q5  = `COLOR_DEF_R_RB_Q5,
    parameter integer DEF_G_DIFF   = `COLOR_DEF_G_DIFF,
    parameter integer DEF_G_GR_Q5  = `COLOR_DEF_G_GR_Q5,
    parameter integer DEF_G_GB_Q5  = `COLOR_DEF_G_GB_Q5,
    parameter integer DEF_DB_DIFF  = `COLOR_DEF_DB_DIFF,
    parameter integer DEF_DB_BR_Q5 = `COLOR_DEF_DB_BR_Q5,
    parameter integer DEF_DB_BG_Q5 = `COLOR_DEF_DB_BG_Q5,
    parameter integer DEF_LB_DIFF  = `COLOR_DEF_LB_DIFF,
    parameter integer DEF_LB_BR_Q5 = `COLOR_DEF_LB_BR_Q5,
    parameter integer DEF_LB_GR_Q5 = `COLOR_DEF_LB_GR_Q5,
    parameter integer DEF_MIN_LUMA = `COLOR_DEF_MIN_LUMA,
    parameter integer DEF_MIN_SAT  = `COLOR_DEF_MIN_SAT,
    parameter integer DEF_MIN_AREA = `COLOR_DEF_MIN_AREA
)(
 input wire clk,rst_n,
 input wire I_preview_select, // Debounced SW1: down/RGB=0, up/HIT=1; editor only.
 input wire I_k1_short,I_k1_long,I_k2_short,I_k2_long,I_k3_step,I_k4_step,I_k4_long15,
 input wire[239:0]I_eff,
 output wire[239:0]O_edit_bus,output wire O_commit_req,
 output reg[1:0]O_mode,output reg O_edit,O_panel,
 output reg[2:0]O_page,output reg[1:0]O_cursor,output reg O_edge_toggle,
 output wire O_status_show,output wire O_restore_sel,
 output reg O_preview
);
    localparam [239:0] DEF_BUS = {
        DEF_MIN_AREA[15:0], DEF_MIN_SAT[15:0],  DEF_MIN_LUMA[15:0],
        DEF_LB_GR_Q5[15:0], DEF_LB_BR_Q5[15:0], DEF_LB_DIFF[15:0],
        DEF_DB_BG_Q5[15:0], DEF_DB_BR_Q5[15:0], DEF_DB_DIFF[15:0],
        DEF_G_GB_Q5[15:0],  DEF_G_GR_Q5[15:0],  DEF_G_DIFF[15:0],
        DEF_R_RB_Q5[15:0],  DEF_R_RG_Q5[15:0],  DEF_R_DIFF[15:0]
    };


 // Detector interface remains 15 little-endian 16-bit fields.
 // Legal values need only 117 bits internally; no runtime barrel shift is used.
 `include "color_param_codec.vh"
 function integer bits_for;
   input integer count;
   integer n;
   begin
     n=count-1;bits_for=0;
     while(n>0)begin bits_for=bits_for+1;n=n>>1;end
     if(bits_for<1)bits_for=1;
   end
 endfunction
 localparam integer MS_WIDTH=bits_for(MS_CYC);
 localparam integer POST_WIDTH=bits_for(POST_EXIT_MS+1);
 localparam [116:0] DEF_PACK=color_pack(DEF_BUS);
 reg[MS_WIDTH-1:0]ms_count;wire tick=ms_count==MS_CYC-1;
 reg[POST_WIDTH-1:0]post_ms;
 reg[116:0]edit_pack; // Retained across mode changes and races, reset to DEF_PACK.
 wire enter_edit=I_k1_long&&!O_edit&&O_mode==3;
 wire exit_edit=I_k2_long&&O_edit;
 wire restore=O_restore_sel&&I_k4_long15&&!I_k1_short&&!I_k2_short&&!exit_edit;
 wire[4:0]selection={O_page,O_cursor};
 wire is_ratio=O_page<4&&O_cursor!=0;
 wire is_area=O_page==4&&O_cursor==2;
 reg[12:0]value;
 always @*begin
   value=13'd0;
   case(selection)
     5'd0:value={5'd0,edit_pack[7:0]};
     5'd1:value={6'd0,edit_pack[14:8]};
     5'd2:value={6'd0,edit_pack[21:15]};
     5'd4:value={5'd0,edit_pack[29:22]};
     5'd5:value={6'd0,edit_pack[36:30]};
     5'd6:value={6'd0,edit_pack[43:37]};
     5'd8:value={5'd0,edit_pack[51:44]};
     5'd9:value={6'd0,edit_pack[58:52]};
     5'd10:value={6'd0,edit_pack[65:59]};
     5'd12:value={5'd0,edit_pack[73:66]};
     5'd13:value={6'd0,edit_pack[80:74]};
     5'd14:value={6'd0,edit_pack[87:81]};
     5'd16:value={5'd0,edit_pack[95:88]};
     5'd17:value={5'd0,edit_pack[103:96]};
     5'd18:value=edit_pack[116:104];
     default:value=13'd0;
   endcase
 end
 wire[12:0]lo=is_area?13'd1:(is_ratio?13'd32:13'd0);
 wire[12:0]hi=is_area?13'd4096:(is_ratio?13'd120:13'd255);
 wire can_step=I_k4_step?(value<hi):(value>lo);
 wire step_edit=O_edit&&!O_restore_sel&&(I_k3_step^I_k4_step)&&can_step;
 wire[12:0]step_value=value+(I_k4_step?13'd1:13'h1fff);
 wire changed=restore?(edit_pack!=DEF_PACK):step_edit;
 assign O_edit_bus=color_unpack(edit_pack);
 assign O_restore_sel=O_edit&&O_page==4&&O_cursor==3;
 assign O_commit_req=O_edit_bus!=I_eff;
 assign O_status_show=O_edit||post_ms!=0;
 always @(posedge clk or negedge rst_n)begin
   if(!rst_n)begin
     ms_count<=0;post_ms<=0;O_mode<=0;O_edit<=0;O_panel<=0;O_page<=0;O_cursor<=0;
     O_preview<=0;O_edge_toggle<=0;edit_pack<=DEF_PACK;
   end else begin
     ms_count<=tick?0:ms_count+1'b1;O_edge_toggle<=0;
     if(tick)begin
       if(post_ms!=0)post_ms<=post_ms-1'b1;
     end
     if(!O_edit)begin
       O_preview<=0;
       if(I_k1_short)O_mode<=O_mode+1'b1;
       if(I_k2_short&&O_mode==2)O_edge_toggle<=1;
       if(enter_edit)begin O_edit<=1;O_panel<=1;O_cursor<=0;O_preview<=I_preview_select;
       end
     end else begin
       O_preview<=I_preview_select;
       if(I_k1_long)O_panel<=!O_panel;
       // Two short events in one cycle cancel navigation; no parameter change.
       if(I_k1_short&&!I_k2_short)begin
         if(O_cursor==0)begin
           O_page<=O_page==0?4:O_page-1'b1;
           O_cursor<=O_page==0?3:2;
         end else O_cursor<=O_cursor-1'b1;
       end else if(I_k2_short&&!I_k1_short)begin
         if(O_cursor==(O_page==4?3:2))begin O_cursor<=0;O_page<=O_page==4?0:O_page+1'b1;end
         else O_cursor<=O_cursor+1'b1;
       end
       if(exit_edit)begin O_edit<=0;O_panel<=0;O_preview<=0;post_ms<=POST_EXIT_MS;end
     end
     if(changed)begin
       if(restore)edit_pack<=DEF_PACK;
       else case(selection)
         5'd0:edit_pack[7:0]<=step_value[7:0];
         5'd1:edit_pack[14:8]<=step_value[6:0];
         5'd2:edit_pack[21:15]<=step_value[6:0];
         5'd4:edit_pack[29:22]<=step_value[7:0];
         5'd5:edit_pack[36:30]<=step_value[6:0];
         5'd6:edit_pack[43:37]<=step_value[6:0];
         5'd8:edit_pack[51:44]<=step_value[7:0];
         5'd9:edit_pack[58:52]<=step_value[6:0];
         5'd10:edit_pack[65:59]<=step_value[6:0];
         5'd12:edit_pack[73:66]<=step_value[7:0];
         5'd13:edit_pack[80:74]<=step_value[6:0];
         5'd14:edit_pack[87:81]<=step_value[6:0];
         5'd16:edit_pack[95:88]<=step_value[7:0];
         5'd17:edit_pack[103:96]<=step_value[7:0];
         5'd18:edit_pack[116:104]<=step_value;
         default:edit_pack<=edit_pack;
       endcase
     end
   end
 end
endmodule
