// SD MISO input: asynchronous pad -> metastability stage -> stable system domain.
// Only the raw pad to meta is exempt; meta to level remains normally timed.
module sd_miso_sync(input wire clk,rst_n,raw_i,output wire level_o);
 (* async_reg="true" *) reg meta,level;
 always @(posedge clk or negedge rst_n)
  if(!rst_n)begin meta<=1'b1;level<=1'b1;end
  else begin meta<=raw_i;level<=meta;end
 assign level_o=level;
endmodule
