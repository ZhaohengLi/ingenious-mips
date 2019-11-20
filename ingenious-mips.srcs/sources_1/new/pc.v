`include "defines.v"

module PC(
    input wire clk,
    input wire rst,
    input wire flush_i,
    input wire[5:0] stall_i,
    input wire branchFlag_i,
    input wire[`RegBus] branchTargetAddr_i,
    input wire[`InstAddrBus] instAddr_i,
    input wire[`RegBus] newInstAddr_i,

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
        end else begin
            if (flush_i == 1'b1) begin
                instAddr_o <= newInstAddr_i;
            end else if (stall_i[0] == `NoStop) begin
                if(branchFlag_i == `Branch) begin
                    instAddr_o <= branchTargetAddr_i;
                end else begin
                    instAddr_o <= instAddr_i;
                end
            end
        end
    end

endmodule
