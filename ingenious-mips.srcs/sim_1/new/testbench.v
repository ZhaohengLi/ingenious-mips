`timescale 1ns / 1ps

module TESTBENCH();
    reg CLOCK_50;
    reg rst;
    
    initial begin
        CLOCK_50 = 1'b0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end
    
    initial begin
        rst = 1'b1;
        #100 rst = 1'b0;
        #700 rst = 1'b1;
        #100 $stop;
    end
        
    SOPC sopc1(
        .clk(CLOCK_50), .rst(rst)
    );
    
endmodule
