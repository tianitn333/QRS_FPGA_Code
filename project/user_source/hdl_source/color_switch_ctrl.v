// Physical SW1 is asynchronous. Accept a new level after 20 ms unchanged.
// Only S_sync_meta sees the pin; the second stage remains a timed clock path.
module color_switch_ctrl #(
    parameter integer STABLE_CYCLES = 1500000 // 75 MHz * 20 ms
)(
    input wire clk,
    input wire rst_n,
    input wire I_switch,
    output reg O_level
);
    function integer bits_for;
        input integer count;
        integer n;
        begin
            n=count-1; bits_for=0;
            while(n>0)begin bits_for=bits_for+1;n=n>>1;end
            if(bits_for<1)bits_for=1;
        end
    endfunction
    localparam integer COUNT_WIDTH=bits_for(STABLE_CYCLES);
    (* async_reg="true" *) reg S_sync_meta;
    (* async_reg="true" *) reg S_sync_level;
    reg [COUNT_WIDTH-1:0] S_count;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin S_sync_meta<=0;S_sync_level<=0;end
        else begin S_sync_meta<=I_switch;S_sync_level<=S_sync_meta;end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin O_level<=0;S_count<=0;end
        else if(S_sync_level==O_level)S_count<=0;
        else if(S_count==STABLE_CYCLES-1)begin O_level<=S_sync_level;S_count<=0;end
        else S_count<=S_count+1'b1;
    end
endmodule
