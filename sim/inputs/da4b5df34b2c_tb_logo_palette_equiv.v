`timescale 1ns/1ps
module tb_logo_palette_equiv;
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
        for(base_index=0;base_index<8;base_index=base_index+1)begin
            case(base_index)
                0:base_address=0;1:base_address=5494;2:base_address=5499;3:base_address=12000;
                4:base_address=20000;5:base_address=32767;6:base_address=10000;default:base_address=16384;
            endcase
            for(bit_index=0;bit_index<15;bit_index=bit_index+1)begin
                @(negedge clk);address=base_address;address[bit_index]=1'bx;
                @(posedge clk);#1;
                if(actual!==reference)$fatal(1,"FAIL X input base=%d bit=%d",base_index,bit_index);
                @(negedge clk);address=base_address;address[bit_index]=1'bz;
                @(posedge clk);#1;
                if(actual!==reference)$fatal(1,"FAIL Z input base=%d bit=%d",base_index,bit_index);
            end
        end
        @(negedge clk);address=15'hxxxx;
        @(posedge clk);#1;if(actual!==reference)$fatal(1,"FAIL all X");
        @(negedge clk);address=15'hzzzz;
        @(posedge clk);#1;if(actual!==reference)$fatal(1,"FAIL all Z");
        @(negedge clk);address=5494;
        @(posedge clk);#1;if(actual!==expected[5494])$fatal(1,"FAIL recovery after unknown");
        #1;rst_n=0;#1;if(actual!==0)$fatal(1,"FAIL asynchronous reset mask");
        @(negedge clk);address=5499;rst_n=1;
        @(posedge clk);#1;if(actual!==expected[5499])$fatal(1,"FAIL reset recovery");
        $display("PASS:32768 full25bit pixels,242 X/Z cases,one-clock read/hold,async reset and recovery,6 vendor ERAM banks plus constant-zero bank");
        $finish;
    end
endmodule
