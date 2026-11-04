// Include inside a module. Lossless coding of the 15 legal parameter fields.
// Public buses and on-card records remain 15 x 16 bits; no version is truncated.
function [116:0] color_pack; input [239:0] p; begin
 color_pack[0 +: 8]=p[0 +: 8];
 color_pack[8 +: 7]=p[16 +: 7];
 color_pack[15 +: 7]=p[32 +: 7];
 color_pack[22 +: 8]=p[48 +: 8];
 color_pack[30 +: 7]=p[64 +: 7];
 color_pack[37 +: 7]=p[80 +: 7];
 color_pack[44 +: 8]=p[96 +: 8];
 color_pack[52 +: 7]=p[112 +: 7];
 color_pack[59 +: 7]=p[128 +: 7];
 color_pack[66 +: 8]=p[144 +: 8];
 color_pack[74 +: 7]=p[160 +: 7];
 color_pack[81 +: 7]=p[176 +: 7];
 color_pack[88 +: 8]=p[192 +: 8];
 color_pack[96 +: 8]=p[208 +: 8];
 color_pack[104 +: 13]=p[224 +: 13];
end endfunction
function [239:0] color_unpack; input [116:0] p; begin
 color_unpack=240'd0;
 color_unpack[0 +: 8]=p[0 +: 8];
 color_unpack[16 +: 7]=p[8 +: 7];
 color_unpack[32 +: 7]=p[15 +: 7];
 color_unpack[48 +: 8]=p[22 +: 8];
 color_unpack[64 +: 7]=p[30 +: 7];
 color_unpack[80 +: 7]=p[37 +: 7];
 color_unpack[96 +: 8]=p[44 +: 8];
 color_unpack[112 +: 7]=p[52 +: 7];
 color_unpack[128 +: 7]=p[59 +: 7];
 color_unpack[144 +: 8]=p[66 +: 8];
 color_unpack[160 +: 7]=p[74 +: 7];
 color_unpack[176 +: 7]=p[81 +: 7];
 color_unpack[192 +: 8]=p[88 +: 8];
 color_unpack[208 +: 8]=p[96 +: 8];
 color_unpack[224 +: 13]=p[104 +: 13];
end endfunction
function color_valid; input [239:0] p; integer n; reg[15:0]v;
 begin color_valid=1;for(n=0;n<15;n=n+1)begin v=p[n*16+:16];
  if(n==14)begin if(v<1||v>4096)color_valid=0;end
  else if(n<12&&n%3!=0)begin if(v<32||v>120)color_valid=0;end
  else if(v>255)color_valid=0;
 end end
endfunction
