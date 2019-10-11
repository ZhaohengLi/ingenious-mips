`include "defines.v"

module PC(
    input wire clk,
    input wire rst,
    output reg[`InstAddrBus] instAddr_o,
    output reg ce_o
);
    always @(posedge clk) begin
        case (rst)
        `RstEnable : ce_o <= `ChipDisable;
        `RstDisable : ce_o <= `ChipEnable;
        endcase
    end
    
    always @(posedge clk) begin
        case (ce_o)
        `ChipDisable : instAddr_o <= 32'd0;
        `ChipEnable : instAddr_o <= instAddr_o + 32'd4;
        endcase
    end
    
endmodule