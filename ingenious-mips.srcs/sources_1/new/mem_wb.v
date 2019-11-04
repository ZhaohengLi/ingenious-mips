`include "defines.v"

module MEM_WB(
	input wire clk,
	input wire rst,
	
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,
	input wire[`RegBus] regWriteData_i,
	
	input wire regHILOEnable_i,
	input wire[`RegBus] regHI_i,
	input wire[`RegBus] regLO_i,
	
	input wire[5:0] stall_i,

	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o,
	
	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o,
	
	input wire LLbitWriteEnable_i,
	input wire LLbitData_i,
	
	output reg LLbitWriteEnable_o,
	output reg LLbitData_o,
	
	input wire cp0WriteEnable_i,
	input wire[4:0] cp0WriteAddr_i,
	input wire[`RegBus] cp0WriteData_i,
	
	output reg cp0WriteEnable_o,
	output reg[4:0] cp0WriteAddr_o,
	output reg[`RegBus] cp0WriteData_o
);
    always @ (posedge clk) begin
        if(rst == `Enable) begin
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
            LLbitWriteEnable_o <= `Disable;
            LLbitData_o <= 1'b0;
            cp0WriteEnable_o <= `Disable;
            cp0WriteAddr_o <= 5'b00000;
            cp0WriteData_o <= `ZeroWord;
        end else if (stall_i[4] == `Stop && stall_i[5] == `NoStop) begin
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
            LLbitWriteEnable_o <= `Disable;
            LLbitData_o <= 1'b0;
            cp0WriteEnable_o <= `Disable;
            cp0WriteAddr_o <= 5'b00000;
            cp0WriteData_o <= `ZeroWord;
        end else if (stall_i[4] == `NoStop) begin
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            regWriteData_o <= regWriteData_i;
            regHILOEnable_o <= regHILOEnable_i;
            regHI_o <= regHI_i;
            regLO_o <= regLO_i;
            LLbitWriteEnable_o <= LLbitWriteEnable_i;
            LLbitData_o <= LLbitData_i;
            cp0WriteEnable_o <= cp0WriteEnable_i;
            cp0WriteAddr_o <= cp0WriteAddr_i;
            cp0WriteData_o <= cp0WriteData_i;
        end
    end //always
endmodule