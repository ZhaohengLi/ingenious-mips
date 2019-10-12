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

endmodule