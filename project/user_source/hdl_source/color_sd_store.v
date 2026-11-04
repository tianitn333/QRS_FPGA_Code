// Four-sector CTP1/CTC1 journal. No filesystem and no implicit writes on boot.
module color_sd_store #(
 parameter integer CLK_HZ=50000000,POWER_CYCLES=500000,HOST_TIMEOUT=100000000,
 parameter integer INIT_DIV=123,SPEED_DIV=23,SESSION_TIMEOUT=150000000
)(input wire clk,rst_n,
 input wire save_valid,input wire[239:0]save_data,input wire[31:0]save_revision,
 output wire save_ready,output reg result_valid,input wire result_ready,
 output wire[282:0]result_data,
 output wire sd_clk,sd_mosi,sd_cs_n,input wire sd_miso);
 `include "color_param_codec.vh"
 localparam BOOT=0,INIT_WAIT=1,SCAN_START=2,SCAN_WAIT=3,IDLE=4,
   PREP=5,WRITE_START=6,WRITE_WAIT=7,VERIFY_START=8,VERIFY_WAIT=9;
 reg[3:0]state;reg boot_session,reinit_used,have_record,active_bank,target_bank;
 reg[1:0]scan_index;reg[2:0]step;
 reg[31:0]latest_seq,pending_seq,pending_revision,latest_crc,app_crc,commit_crc;
 reg[116:0]latest_compact,pending_compact;
 wire[239:0]latest_params=color_unpack(latest_compact),pending_params=color_unpack(pending_compact);
 reg[31:0]watchdog,crc_work;reg[5:0]prep_index;reg preparing_commit;
 reg h_start,abort_host;reg[1:0]h_op;reg[31:0]h_lba;
 wire h_done,h_busy,h_ready,rv;wire[7:0]h_error,rd;wire[8:0]ti,ri;
 reg[31:0]rx_magic,rx_seq,rx_stored,rx_link,rx_calc;
 reg[116:0]rx_compact;wire[239:0]rx_params=color_unpack(rx_compact);reg rx_range_bad;reg[7:0]rx_format,rx_length;reg rx_bad;
 reg candidate_valid;reg[31:0]candidate_seq,candidate_crc;
 reg scan_bad,mismatch,rx_ff,rx_zero;
 reg response_boot,response_ok,response_record;reg[7:0]response_error;
 // The selected bank/pending snapshot remains held while result_valid is set.
 wire[239:0]response_params=boot_session?latest_params:pending_params;
 wire commit_block=state==SCAN_WAIT?scan_index[0]:(step==2||step==4);
 wire session_active=state!=IDLE&&!result_valid;
 assign save_ready=state==IDLE&&!result_valid;
 assign result_data={response_boot,response_ok,response_error,response_record,pending_revision,response_params};
 function[31:0]crc32;input[31:0]v;input[7:0]d;reg[31:0]w;integer n;
   begin w=v^d;for(n=0;n<8;n=n+1)w=w[0]?(w>>1)^32'hedb88320:w>>1;crc32=w;end endfunction
 function newer;input[31:0]a,b;reg[31:0]d;begin d=a-b;newer=d!=0&&!d[31];end endfunction
 function[7:0]packet_byte;
   input is_commit;input[8:0]idx;input[31:0]seq;input[239:0]p;
   input[31:0]data_crc,descriptor_crc;
   begin
    packet_byte=8'hff;
    case(idx)
     0:packet_byte="C";1:packet_byte="T";2:packet_byte=is_commit?"C":"P";3:packet_byte="1";
     4:packet_byte=1;5:packet_byte=is_commit?8:30;6,7:packet_byte=0;
     8:packet_byte=seq[0+:8];
     9:packet_byte=seq[8+:8];
     10:packet_byte=seq[16+:8];
     11:packet_byte=seq[24+:8];
     12:packet_byte=is_commit?data_crc[0+:8]:p[0+:8];
     13:packet_byte=is_commit?data_crc[8+:8]:p[8+:8];
     14:packet_byte=is_commit?data_crc[16+:8]:p[16+:8];
     15:packet_byte=is_commit?data_crc[24+:8]:p[24+:8];
     16:packet_byte=is_commit?descriptor_crc[0+:8]:p[32+:8];
     17:packet_byte=is_commit?descriptor_crc[8+:8]:p[40+:8];
     18:packet_byte=is_commit?descriptor_crc[16+:8]:p[48+:8];
     19:packet_byte=is_commit?descriptor_crc[24+:8]:p[56+:8];
     20:packet_byte=is_commit?8'hff:p[64+:8];
     21:packet_byte=is_commit?8'hff:p[72+:8];
     22:packet_byte=is_commit?8'hff:p[80+:8];
     23:packet_byte=is_commit?8'hff:p[88+:8];
     24:packet_byte=is_commit?8'hff:p[96+:8];
     25:packet_byte=is_commit?8'hff:p[104+:8];
     26:packet_byte=is_commit?8'hff:p[112+:8];
     27:packet_byte=is_commit?8'hff:p[120+:8];
     28:packet_byte=is_commit?8'hff:p[128+:8];
     29:packet_byte=is_commit?8'hff:p[136+:8];
     30:packet_byte=is_commit?8'hff:p[144+:8];
     31:packet_byte=is_commit?8'hff:p[152+:8];
     32:packet_byte=is_commit?8'hff:p[160+:8];
     33:packet_byte=is_commit?8'hff:p[168+:8];
     34:packet_byte=is_commit?8'hff:p[176+:8];
     35:packet_byte=is_commit?8'hff:p[184+:8];
     36:packet_byte=is_commit?8'hff:p[192+:8];
     37:packet_byte=is_commit?8'hff:p[200+:8];
     38:packet_byte=is_commit?8'hff:p[208+:8];
     39:packet_byte=is_commit?8'hff:p[216+:8];
     40:packet_byte=is_commit?8'hff:p[224+:8];
     41:packet_byte=is_commit?8'hff:p[232+:8];
     42:packet_byte=is_commit?8'hff:data_crc[0+:8];
     43:packet_byte=is_commit?8'hff:data_crc[8+:8];
     44:packet_byte=is_commit?8'hff:data_crc[16+:8];
     45:packet_byte=is_commit?8'hff:data_crc[24+:8];
     default:packet_byte=8'hff;
    endcase
   end
 endfunction
 wire packet_write=state==WRITE_START||state==WRITE_WAIT;
 wire[8:0]packet_index=state==PREP?{3'd0,prep_index}:packet_write?ti:ri;
 wire packet_commit=state==PREP?preparing_commit:packet_write?(step==2):commit_block;
 wire[7:0]packet_value=packet_byte(packet_commit,packet_index,pending_seq,pending_params,app_crc,commit_crc);
 wire[7:0]tx=packet_value,expected=packet_value;
 wire[31:0]prep_crc_next=crc32(crc_work,packet_value);
 wire packet_ok=rx_magic==(commit_block?32'h43544331:32'h43545031)&&rx_format==1&&
     rx_length==(commit_block?8:30)&&!rx_bad&&rx_stored==~rx_calc;
 sd_host #(.POWER_CYCLES(POWER_CYCLES),.TIMEOUT_CYCLES(HOST_TIMEOUT),.INIT_DIV(INIT_DIV),
   .WRITE_LBA_FIRST(2058),.WRITE_LBA_LAST(2061)) host(
   .clk(clk),.rst_n(rst_n&&!abort_host),.start(h_start),.op(h_op),.allow_write(1'b1),
   .lba(h_lba),.speed_div(SPEED_DIV[15:0]),.tx_data(tx),.tx_index(ti),
   .rx_valid(rv),.rx_index(ri),.rx_data(rd),.busy(h_busy),.done(h_done),.ready(h_ready),
   .error(h_error),.last_r1(),.phase(),.blocks(),.cid(),
   .sd_clk(sd_clk),.sd_mosi(sd_mosi),.sd_cs_n(sd_cs_n),.sd_miso(sd_miso));
 // Data parameters remain in rx_compact across their following commit read.
 // The caller supplies the UPCOMING block type: commit_block describes the
 // receive state and is not the right decoder while SCAN_START is active.
 task read_block;input[31:0]addr;input[3:0]next_state;input reading_commit;
   begin h_lba<=addr;h_op<=1;h_start<=1;state<=next_state;
     rx_magic<=0;rx_seq<=0;rx_stored<=0;rx_link<=0;rx_calc<=32'hffffffff;
     if(!reading_commit)rx_compact<=0;rx_range_bad<=0;rx_format<=0;rx_length<=0;rx_bad<=0;mismatch<=0;rx_ff<=1;rx_zero<=1;end
 endtask
 task finish;input ok;input[7:0]code;
   begin state<=IDLE;result_valid<=1;response_boot<=boot_session;response_ok<=ok;
     response_error<=code;response_record<=have_record;

     if(!ok)abort_host<=1;end
 endtask
 always @(posedge clk or negedge rst_n)begin
  if(!rst_n)begin
   state<=BOOT;boot_session<=1;reinit_used<=0;have_record<=0;active_bank<=0;target_bank<=0;
   scan_index<=0;step<=0;latest_seq<=0;pending_seq<=0;pending_revision<=0;latest_crc<=0;
   app_crc<=0;commit_crc<=0;latest_compact<=0;pending_compact<=0;watchdog<=0;
   crc_work<=0;prep_index<=0;preparing_commit<=0;h_start<=0;abort_host<=0;h_op<=0;h_lba<=0;
   rx_magic<=0;rx_seq<=0;rx_stored<=0;rx_link<=0;rx_calc<=0;rx_compact<=0;rx_range_bad<=0;
   rx_format<=0;rx_length<=0;rx_bad<=0;candidate_valid<=0;candidate_seq<=0;candidate_crc<=0;
   scan_bad<=0;mismatch<=0;rx_ff<=1;rx_zero<=1;
   result_valid<=0;response_boot<=1;response_ok<=0;response_record<=0;
   response_error<=0;
  end else begin
   h_start<=0;abort_host<=0;
   if(result_valid&&result_ready)result_valid<=0;
   if(session_active)watchdog<=watchdog+1'b1;
   if(rv)begin
    if(rd!=8'hff)rx_ff<=0;if(rd!=0)rx_zero<=0;
    if(state==VERIFY_WAIT&&rd!=expected)mismatch<=1;
    if(ri<(commit_block?16:42))rx_calc<=crc32(rx_calc,rd);
    if(ri<4)rx_magic<={rx_magic[23:0],rd};
    if(ri==4)rx_format<=rd;if(ri==5)rx_length<=rd;
    if((ri==6||ri==7)&&rd!=0)rx_bad<=1;
    if(ri>=8&&ri<12)rx_seq[(ri-8)*8+:8]<=rd;
    if(ri>=12&&ri<16)rx_link[(ri-12)*8+:8]<=rd;
    if(!commit_block)case(ri)
     12:begin rx_compact[0+:8]<=rd[7:0];end
     13:if(rd!=0)rx_range_bad<=1;
     14:begin rx_compact[8+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     15:if(rd!=0)rx_range_bad<=1;
     16:begin rx_compact[15+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     17:if(rd!=0)rx_range_bad<=1;
     18:begin rx_compact[22+:8]<=rd[7:0];end
     19:if(rd!=0)rx_range_bad<=1;
     20:begin rx_compact[30+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     21:if(rd!=0)rx_range_bad<=1;
     22:begin rx_compact[37+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     23:if(rd!=0)rx_range_bad<=1;
     24:begin rx_compact[44+:8]<=rd[7:0];end
     25:if(rd!=0)rx_range_bad<=1;
     26:begin rx_compact[52+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     27:if(rd!=0)rx_range_bad<=1;
     28:begin rx_compact[59+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     29:if(rd!=0)rx_range_bad<=1;
     30:begin rx_compact[66+:8]<=rd[7:0];end
     31:if(rd!=0)rx_range_bad<=1;
     32:begin rx_compact[74+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     33:if(rd!=0)rx_range_bad<=1;
     34:begin rx_compact[81+:7]<=rd[6:0];if(rd[7])rx_range_bad<=1;end
     35:if(rd!=0)rx_range_bad<=1;
     36:begin rx_compact[88+:8]<=rd[7:0];end
     37:if(rd!=0)rx_range_bad<=1;
     38:begin rx_compact[96+:8]<=rd[7:0];end
     39:if(rd!=0)rx_range_bad<=1;
     40:begin rx_compact[104+:8]<=rd[7:0];end
     41:begin rx_compact[112+:5]<=rd[4:0];if(rd[7:5]!=0)rx_range_bad<=1;end
     default:;endcase
    if(commit_block&&ri>=16&&ri<20)rx_stored[(ri-16)*8+:8]<=rd;
    if(!commit_block&&ri>=42&&ri<46)rx_stored[(ri-42)*8+:8]<=rd;
    if(ri>=(commit_block?20:46)&&rd!=8'hff)rx_bad<=1;
   end
   if(session_active&&watchdog>=SESSION_TIMEOUT)begin abort_host<=1;finish(0,8'h30);end
   else case(state)
    BOOT:begin h_op<=0;h_start<=1;state<=INIT_WAIT;scan_index<=0;watchdog<=0;end
    INIT_WAIT:if(h_done)begin
      if(h_error!=0)finish(0,h_error);else state<=SCAN_START;
    end
    SCAN_START:read_block(2058+scan_index,SCAN_WAIT,scan_index[0]);
    SCAN_WAIT:if(h_done)begin
      if(h_error!=0)begin
        scan_bad<=1;candidate_valid<=0;
        if(scan_index<2&&!reinit_used)begin
          reinit_used<=1;scan_index<=2;h_op<=0;h_start<=1;state<=INIT_WAIT;
        end else if(boot_session)finish(have_record,have_record?8'd0:h_error);
        else finish(0,h_error);
      end else begin
        if(!packet_ok&&!rx_ff&&!rx_zero)scan_bad<=1;
        if(!scan_index[0])begin
          candidate_valid<=packet_ok&&!rx_range_bad&&color_valid(rx_params);
          candidate_seq<=rx_seq;candidate_crc<=rx_stored;
          if(rx_magic==32'h43545031&&(!packet_ok||rx_range_bad||!color_valid(rx_params)))scan_bad<=1;
        end else if(packet_ok&&candidate_valid&&rx_seq==candidate_seq&&rx_link==candidate_crc)begin
          if(!have_record||newer(candidate_seq,latest_seq))begin
            have_record<=1;active_bank<=scan_index[1];latest_seq<=candidate_seq;
            latest_compact<=rx_compact;latest_crc<=candidate_crc;
          end
        end else if(rx_magic==32'h43544331)scan_bad<=1;
        if(scan_index==3)begin state<=PREP;prep_index<=0;preparing_commit<=0;crc_work<=32'hffffffff;end
        else begin scan_index<=scan_index+1'b1;state<=SCAN_START;end
      end
    end
    PREP:if(boot_session)finish(have_record||!scan_bad,have_record||!scan_bad?8'd0:8'h21);
      else if(prep_index==0&&!preparing_commit&&have_record&&pending_params==latest_params)finish(1,0);
      else begin
        if(prep_index==0&&!preparing_commit)begin pending_seq<=latest_seq+1'b1;target_bank<=have_record?!active_bank:1'b0;end
        crc_work<=prep_crc_next;
        if(prep_index==(preparing_commit?15:41))begin
          if(!preparing_commit)begin
            app_crc<=~prep_crc_next;
            preparing_commit<=1;prep_index<=0;crc_work<=32'hffffffff;
          end else begin
            commit_crc<=~prep_crc_next;
            step<=0;state<=WRITE_START;
          end
        end else prep_index<=prep_index+1'b1;
      end
    IDLE:if(save_valid&&save_ready)begin
      boot_session<=0;pending_compact<=color_pack(save_data);pending_revision<=save_revision;watchdog<=0;
      if(!color_valid(save_data))begin
        result_valid<=1;response_boot<=0;response_ok<=0;response_record<=have_record;
        response_error<=8'h22;
      end else if(!h_ready)begin
        have_record<=0;latest_seq<=0;latest_compact<=0;scan_index<=0;scan_bad<=0;reinit_used<=0;
        state<=BOOT;
      end else begin state<=PREP;prep_index<=0;preparing_commit<=0;crc_work<=32'hffffffff;end
    end
    WRITE_START:begin h_lba<=2058+{target_bank,1'b0}+(step==2?1:0);h_op<=2;h_start<=1;state<=WRITE_WAIT;end
    WRITE_WAIT:if(h_done)begin if(h_error!=0)finish(0,h_error);else begin step<=step+1'b1;state<=VERIFY_START;end end
    VERIFY_START:read_block(2058+{target_bank,1'b0}+(step==4?1:0),VERIFY_WAIT,step==4);
    VERIFY_WAIT:if(h_done)begin
      if(h_error!=0)finish(0,h_error);
      else if(mismatch||!packet_ok)finish(0,8'h20);
      else if(step==1)begin step<=2;state<=WRITE_START;end
      else if(step==3)begin step<=4;state<=VERIFY_START;end
      else begin
        have_record<=1;active_bank<=target_bank;latest_seq<=pending_seq;
        latest_compact<=pending_compact;latest_crc<=app_crc;finish(1,0);response_record<=1;
      end
    end
    default:finish(0,8'h0f);
   endcase
  end
 end
endmodule
