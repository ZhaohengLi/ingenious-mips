`timescale 1ns / 1ps

module TESTBENCH();
    reg CLOCK_50;
    reg rst;
    
    initial begin
        CLOCK_50 = 1'b0;
        forever #1 CLOCK_50 = ~CLOCK_50;
    end
    
    initial begin
        rst = 1'b1;
        #10 rst = 1'b0;
        #980 rst = 1'b1;
        #10 $stop;
    end
        
    SOPC sopc1(
        .clk(CLOCK_50), .rst(rst)
    );
    
endmodule
