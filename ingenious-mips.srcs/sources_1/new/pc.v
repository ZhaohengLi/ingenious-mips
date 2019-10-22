`include "defines.v"

module PC(
    input wire clk,
    input wire rst,
    input wire [`InstAddrBus] instAddr_i,
    input wire[5:0] stall_i,
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
        if (ce_o == `Disable) begin
            instAddr_o <= `ZeroWord;
        end else if (stall_i[0] == `NoStop) begin
            instAddr_o <= instAddr_i;
        end 
    end
    
endmodule