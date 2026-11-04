`timescale 1ns/1ps
module tb_motion_meta_fifo;
 reg wc=0,rc=0;always #3 wc=~wc;always #7 rc=~rc;
 reg wr=0,rr=0,reset=0;reg[15:0]di=0;wire[15:0]dout;wire full,empty;
 integer sent=0,received=0,errors=0,cycle=0;
 reg pending=0;reg[15:0]expected=0;
 motion_meta_fifo #(.WIDTH(16),.ADDR_WIDTH(4))dut(.wr_clk(wc),.wr_rst_n(reset),.wr_en_i(wr),.wr_data_i(di),
 .full_o(full),.rd_clk(rc),.rd_rst_n(reset),.rd_en_i(rr),.rd_data_o(dout),.empty_o(empty));
 always @(negedge wc)begin
 if(reset)begin
 wr=sent<4096&&!full&&(cycle%5!=0);di=sent;cycle=cycle+1;
 end else wr=0;
 end
 always @(posedge wc)if(reset&&wr&&!full)sent=sent+1;
 always @(negedge rc)begin
 if(pending)begin if(dout!==expected)begin $display("FAIL: FIFO expected=%0d actual=%0d",expected,dout);errors=errors+1;end pending=0;end
 rr=reset&&!empty&&(received%7!=3||cycle%3!=0);
 end
 always @(posedge rc)begin
 if(reset&&rr&&!empty)begin expected=received;received=received+1;pending=1;end
 end
 initial begin repeat(4)@(negedge wc);reset=1;
 wait(received==4096);repeat(8)@(negedge rc);
 if(sent==4096&&empty&&errors==0)$display("PASS: asynchronous FIFO 4096 ordered words, pointer wrap and full/empty stalls");
 else $display("FAIL: FIFO summary");$finish;end
 initial begin #1000000;$display("FAIL: FIFO timeout");$finish;end
endmodule
