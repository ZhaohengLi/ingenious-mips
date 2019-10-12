`include "defines.v"

module ID_EX(

	input wire clk,
	input wire rst,
	
	input wire[`AluOpBus] aluOp_i,
	input wire[`AluSelBus] aluSel_i,
	input wire[`RegBus] operand1_i,
	input wire[`RegBus] operand2_i,
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,
	
	output reg[`AluOpBus] aluOp_o,
	output reg[`AluSelBus] aluSel_o,
	output reg[`RegBus] operand1_o,
	output reg[`RegBus] operand2_o,
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o
);
    always @ (posedge clk) begin
        if(rst == `Disable) begin
            aluSel_o <= aluSel_i;
            aluOp_o <= aluOp_i;
            operand1_o <= operand1_i;
            operand2_o <= operand2_i;
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
        end else begin
            aluSel_o <= `EXE_RES_NOP;
            aluOp_o <= `EXE_NOP_OP;
            operand1_o <= `ZeroWord;
            operand2_o <= `ZeroWord;
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
        end
    end //always
endmodule