`include "defines.v"

module IF_ID(
    input wire clk,
    input wire rst,
    input wire[`InstAddrBus] instAddr_i,
    input wire[`InstBus] inst_i,

    output reg[`InstAddrBus] instAddr_o,
    output reg[`InstBus] inst_o
);
    always @(posedge clk) begin
        if (rst == `Disable) begin
            instAddr_o <= instAddr_i;
            inst_o <= inst_i;
        end else begin
            instAddr_o <= `ZeroWord;
            inst_o <= `ZeroWord;
        end
    end

endmodule
