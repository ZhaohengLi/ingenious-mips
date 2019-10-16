`include "defines.v"

module PC(
    input wire clk,
    input wire rst,
    input wire [`InstAddrBus] instAddr_i,
    output reg[`InstAddrBus] instAddr_o,
    output reg ce_o
);
    always @(posedge clk) begin
        if (rst == `Enable) begin
            ce_o <= `Disable;
        end else begin
            ce_o <= `Enable;
        end
    end
    
    always @(posedge clk) begin
        case (ce_o)
        `Disable : instAddr_o <= `ZeroWord;
        `Enable : instAddr_o <= instAddr_i;
        endcase
    end
    
endmodule