`include "defines.v"

module IF_ID(
    input wire clk,
    input wire rst,

    input wire flush_i,
    input wire[5:0] stall_i,

  	input wire[31:0] exceptionType_i,
  	output reg[31:0] exceptionType_o,

    input wire[`InstAddrBus] instAddr_i,
    input wire[`InstBus] inst_i,

    output reg[`InstAddrBus] instAddr_o,
    output reg[`InstBus] inst_o
);
    always @(posedge clk) begin
        if (rst == `Enable || flush_i == 1'b1) begin
            instAddr_o <= `ZeroWord;
            inst_o <= `ZeroWord;
            exceptionType_o <= `ZeroWord;
        end else if (stall_i[1] == `Stop && stall_i[2] == `NoStop) begin
            instAddr_o <= `ZeroWord;
            inst_o <= `ZeroWord;
            exceptionType_o <= `ZeroWord;
        end else if(stall_i[1] == `NoStop) begin
            instAddr_o <= instAddr_i;
            inst_o <= inst_i;
            exceptionType_o <= exceptionType_i;
        end
    end

endmodule
