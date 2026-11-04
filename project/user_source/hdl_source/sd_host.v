// SPI SDHC single-block host. Byte engine is reused from the official example.
// No filesystem/erase commands; hardware write whitelist: LBA 2048..2057.
module sd_host #(
    parameter integer POWER_CYCLES=500000,
    parameter integer TIMEOUT_CYCLES=100000000,
    parameter integer INIT_DIV=123,
    parameter [31:0] WRITE_LBA_FIRST=2048,WRITE_LBA_LAST=2057
)(
    input wire clk,rst_n,start,
    input wire [1:0] op, // 0 init, 1 read, 2 write
    input wire allow_write,
    input wire [31:0] lba,
    input wire [15:0] speed_div,
    input wire [7:0] tx_data,
    output wire [8:0] tx_index,
    output reg rx_valid,
    output reg [8:0] rx_index,
    output reg [7:0] rx_data,
    output reg busy,done,ready,
    output reg [7:0] error,last_r1,
    output wire [7:0] phase,
    output reg [31:0] blocks,
    output reg [127:0] cid,
    output wire sd_clk,sd_mosi,
    input wire sd_miso,
    output reg sd_cs_n
);
    localparam IDLE=0,POWER=1,CLOCKS=2,PRE=3,SETUP=4,CMD=5,R1=6,CHECK=7,
      EXTRA=8,EXTRA_CHECK=9,TOKEN=10,DATA=11,CRC_H=12,CRC_L=13,DATA_CHECK=14,
      WRITE_TOKEN=15,WRITE_DATA=16,WRITE_CRC_H=17,WRITE_CRC_L=18,
      RESPONSE=19,WRITE_BUSY=20,END_CLOCK=21,ADVANCE=22,XFER=23;
    reg [7:0] state,ret;
    reg [1:0] operation;
    reg [3:0] init_step;
    reg [31:0] address,timer,power_count;
    reg [15:0] divider;
    reg [47:0] packet;
    reg [9:0] count;
    reg [5:0] polls;
    reg [31:0] extra;
    // Only CID needs a full register image. Capture the CSD fields directly
    // so an unused CID output allows the 128-bit CID shift register to prune.
    reg [127:0] regdata;
    reg [1:0] csd_structure;
    reg [21:0] csd_size;
    reg [15:0] crc,wire_crc;
    reg byte_req,abort_byte;
    reg [7:0] byte_tx,last_byte;
    wire byte_ack;
    wire [7:0] byte_rx;
    wire [22:0] cs_plus_one={1'b0,csd_size}+23'd1;
    wire [32:0] sector_count={cs_plus_one,10'd0};
    assign phase=(state==XFER)?ret:state;
    assign tx_index=count[8:0];
    sd_spi_byte byte_engine(.sys_clk(clk),.rst(!rst_n|abort_byte),.nCS(),
      .DCLK(sd_clk),.MOSI(sd_mosi),.MISO(sd_miso),.CPOL(1'b0),.CPHA(1'b0),
      .nCS_ctrl(sd_cs_n),.clk_div(divider),.wr_req(byte_req),.wr_ack(byte_ack),
      .data_in(byte_tx),.data_out(byte_rx));
    function [15:0] crc16;
      input [15:0] c;input [7:0] d;reg[15:0] t;integer i;
      begin t=c^{d,8'd0};for(i=0;i<8;i=i+1)t=t[15]?(t<<1)^16'h1021:t<<1;crc16=t;end
    endfunction
    function [47:0] command;
      input [5:0] n;input[31:0] a;reg[39:0] p;reg[6:0] c;integer i;
      begin p={2'b01,n,a};c=0;
        for(i=39;i>=0;i=i-1)c=(c[6]^p[i])?{c[5:0],1'b0}^7'h09:{c[5:0],1'b0};
        command={p,c,1'b1};
      end
    endfunction
    task transfer;input[7:0] d;input[7:0] next_state;
      begin byte_tx<=d;byte_req<=1;ret<=next_state;state<=XFER;end
    endtask
    task failure;input[7:0] code;
      begin error<=code;busy<=0;done<=1;state<=IDLE;sd_cs_n<=1;
        byte_req<=0;abort_byte<=1;ready<=0;end
    endtask
    always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin
        state<=IDLE;ret<=0;operation<=0;init_step<=0;address<=0;timer<=0;
        power_count<=0;divider<=INIT_DIV;packet<=0;count<=0;polls<=0;
        extra<=0;regdata<=0;csd_structure<=0;csd_size<=0;crc<=0;wire_crc<=0;byte_req<=0;abort_byte<=0;
        byte_tx<=8'hff;last_byte<=0;rx_valid<=0;rx_index<=0;rx_data<=0;
        busy<=0;done<=0;ready<=0;error<=0;last_r1<=8'hff;blocks<=0;cid<=0;sd_cs_n<=1;
      end else begin
        done<=0;rx_valid<=0;abort_byte<=0;
        if(busy)timer<=timer+1'b1;
        if(busy && timer>=TIMEOUT_CYCLES)failure(8'h80|phase);
        else case(state)
          IDLE:if(start)begin
            busy<=1;error<=0;timer<=0;operation<=op;count<=0;polls<=0;
            address<=lba;divider<=speed_div;sd_cs_n<=1;
            if(op==0)begin ready<=0;blocks<=0;cid<=0;divider<=INIT_DIV;
              power_count<=0;init_step<=0;state<=POWER;end
            else if(!ready)failure(8'h01);
            else if(op>2 || lba>=blocks)failure(8'h07);
            else if(op==2 && (!allow_write || lba<WRITE_LBA_FIRST || lba>WRITE_LBA_LAST))failure(8'h09);
            else state<=PRE;
          end
          POWER:if(power_count>=POWER_CYCLES)begin count<=0;state<=CLOCKS;end
            else power_count<=power_count+1'b1;
          CLOCKS:begin transfer(8'hff,CLOCKS);
            if(count==10)begin count<=0;transfer(8'hff,PRE);end else count<=count+1'b1;
          end
          PRE:begin sd_cs_n<=1;transfer(8'hff,SETUP);end
          SETUP:begin
            sd_cs_n<=0;count<=0;polls<=0;
            if(operation!=0)packet<=command(operation==1?6'd17:6'd24,address);
            else case(init_step)
              0:packet<=command(0,0);1:packet<=command(8,32'h1aa);
              2:packet<=command(55,0);3:packet<=command(41,32'h40000000);
              4:packet<=command(58,0);5:packet<=command(59,1);
              6:packet<=command(9,0);default:packet<=command(10,0);
            endcase
            state<=CMD;
          end
          CMD:begin transfer(packet[47:40],CMD);packet<={packet[39:0],8'hff};
            if(count==5)begin count<=0;transfer(packet[47:40],R1);end
            else count<=count+1'b1;
          end
          R1:transfer(8'hff,CHECK);
          CHECK:if(last_byte[7])begin
            if(polls==31)failure(8'h02);else begin polls<=polls+1'b1;state<=R1;end
          end else begin
            last_r1<=last_byte;
            if(operation!=0)begin
              if(last_byte!=0)failure(8'h03);
              else begin count<=0;crc<=0;state<=operation==1?TOKEN:WRITE_TOKEN;end
            end else case(init_step)
              0,2:if(last_byte!=1)failure(8'h03);else state<=END_CLOCK;
              1:if(last_byte!=1)failure(8'h08);else begin extra<=0;count<=0;state<=EXTRA;end
              3:if(last_byte==1)begin init_step<=1;state<=END_CLOCK;end
                else if(last_byte==0)state<=END_CLOCK;else failure(8'h03);
              4:if(last_byte!=0)failure(8'h03);else begin extra<=0;count<=0;state<=EXTRA;end
              5:if(last_byte!=0)failure(8'h03);else state<=END_CLOCK;
              default:if(last_byte!=0)failure(8'h03);
                else begin count<=0;crc<=0;regdata<=0;csd_structure<=0;csd_size<=0;state<=TOKEN;end
            endcase
          end
          EXTRA:transfer(8'hff,EXTRA_CHECK);
          EXTRA_CHECK:begin extra<={extra[23:0],last_byte};
            if(count==3)begin
              if(init_step==1 && {extra[23:0],last_byte}!=32'h1aa)failure(8'h08);
              else if(init_step==4 && (!extra[23] || !extra[22]))failure(8'h08);
              else state<=END_CLOCK;
              count<=0;
            end else begin count<=count+1'b1;state<=EXTRA;end
          end
          TOKEN:transfer(8'hff,DATA_CHECK);
          DATA_CHECK:if(last_byte==8'hff)state<=TOKEN;
            else if(last_byte!=8'hfe)failure(8'h04);
            else begin count<=0;crc<=0;transfer(8'hff,DATA);end
          DATA:begin
            crc<=crc16(crc,last_byte);
            if(operation==0)begin
              if(init_step==6)begin
                // CSD arrives MSB-first: structure at byte 0, C_SIZE at 7..9.
                case(count)
                  0:csd_structure<=last_byte[7:6];
                  7:csd_size[21:16]<=last_byte[5:0];
                  8:csd_size[15:8]<=last_byte;
                  9:csd_size[7:0]<=last_byte;
                  default:;
                endcase
              end else regdata<={regdata[119:0],last_byte};
            end
            else begin rx_valid<=1;rx_index<=count[8:0];rx_data<=last_byte;end
            if(count==(operation==0?15:511))begin count<=0;state<=CRC_H;end
            else begin count<=count+1'b1;transfer(8'hff,DATA);end
          end
          CRC_H:transfer(8'hff,CRC_L);
          CRC_L:begin wire_crc[15:8]<=last_byte;transfer(8'hff,WRITE_CRC_L);end
          // Shared read-CRC check / write low-CRC send dispatcher.
          WRITE_CRC_L:if(operation==2)transfer(crc[7:0],RESPONSE);
            else if({wire_crc[15:8],last_byte}!=crc)failure(8'h06);
            else if(operation==0 && init_step==6)begin
              if(csd_structure!=1 || sector_count[32] || sector_count<({1'b0,WRITE_LBA_LAST}+33'd1))failure(8'h08);
              else begin blocks<=sector_count[31:0];state<=END_CLOCK;end
            end else begin if(operation==0)cid<=regdata;state<=END_CLOCK;end
          WRITE_TOKEN:begin count<=0;crc<=0;transfer(8'hfe,WRITE_DATA);end
          WRITE_DATA:begin
            transfer(tx_data,WRITE_DATA);crc<=crc16(crc,tx_data);
            if(count==511)begin count<=0;transfer(tx_data,WRITE_CRC_H);end
            else count<=count+1'b1;
          end
          WRITE_CRC_H:transfer(crc[15:8],WRITE_CRC_L);
          RESPONSE:transfer(8'hff,WRITE_BUSY);
          WRITE_BUSY:if(count==0)begin
            if(last_byte==8'hff)state<=RESPONSE;
            else if(last_byte[4:0]!=5)failure(8'h05);
            else begin count<=1;transfer(8'hff,WRITE_BUSY);end
          end else if(last_byte==8'hff)begin count<=0;state<=END_CLOCK;end
            else transfer(8'hff,WRITE_BUSY);
          END_CLOCK:begin sd_cs_n<=1;transfer(8'hff,ADVANCE);end
          ADVANCE:if(operation==0 && init_step<7)begin init_step<=init_step+1'b1;state<=PRE;end
            else begin if(operation==0)ready<=1;busy<=0;done<=1;state<=IDLE;end
          XFER:if(byte_ack)begin byte_req<=0;last_byte<=byte_rx;state<=ret;end
          default:failure(8'h0f);
        endcase
      end
    end
endmodule
