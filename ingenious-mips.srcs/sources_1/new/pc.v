`include "defines.v"

module PC(
    input wire clk,
    input wire rst,
    input wire [`InstAddrBus] instAddr_i,
    input wire[5:0] stall_i,
    input wire branch_flag_i,
    input wire [`RegBus] branch_target_i,
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
            if(branch_flag_i == `Branch) begin
                instAddr_o <= branch_target_i;
            end else begin
                instAddr_o <= instAddr_i;
            end
        end 
    end
    
endmodule