`include "defines.v"

module PC(
    input wire clk,
    input wire rst,
    input wire [`InstAddrBus] instAddr_i,
    output reg[`InstAddrBus] instAddr_o,
    output reg ce_o
);
    always @(posedge clk) begin
        case (rst)
        `Enable : ce_o <= `Disable;
        `Disable : ce_o <= `Enable;
        endcase
    end
    
    always @(posedge clk) begin
        case (ce_o)
        `Disable : instAddr_o <= `ZeroWord;
        `Enable : instAddr_o <= instAddr_i;
        endcase
    end
    
endmodule