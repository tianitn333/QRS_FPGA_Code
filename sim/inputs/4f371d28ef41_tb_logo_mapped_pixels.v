`timescale 1ns/1ps
module tb_logo_mapped_pixels;
    reg clk=0, rst_n=0;
    always #6.666 clk=~clk;
    reg [14:0] address=0;
    wire [24:0] actual, reference;
    reg [24:0] expected [0:32767];
    reg [24:0] held;
    integer index, base_index, bit_index;
    reg [14:0] base_address;
    anlogic_logo_palette dut (.clk(clk),.rst_n(rst_n),.I_addr(address),.O_pixel(actual));
    anlogic_logo_rom frozen (.I_addr(address),.O_pixel(reference));
    initial begin
        $readmemh("expected.hex",expected);
        repeat(20)@(negedge clk);
        rst_n=1;
        @(posedge clk);#1;
        held=actual;
        for(index=0;index<32768;index=index+1)begin
            @(negedge clk);address=index;#1;
            if(actual!==held)$fatal(1,"FAIL output changed before read edge index=%d",index);
            @(posedge clk);#1;
            if(actual!==reference||actual!==expected[index])
                $fatal(1,"FAIL palette index=%d actual=%h original=%h expected=%h",index,actual,reference,expected[index]);
            held=actual;
        end
        @(negedge clk);address=5494;
        @(posedge clk);#1;if(actual!==expected[5494])$fatal(1,"FAIL mapped known pixel");
        #1;rst_n=0;#1;if(actual!==0)$fatal(1,"FAIL mapped asynchronous reset mask");
        @(negedge clk);address=5499;rst_n=1;
        @(posedge clk);#1;if(actual!==expected[5499])$fatal(1,"FAIL mapped reset recovery");
        $display("PASS:32768 exact original pixels in actual TD mapped netlist,packed physical ERAM initialization,one-clock read/hold/reset;no SDF timing claim");
        $finish;
    end
endmodule
