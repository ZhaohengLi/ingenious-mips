`include "defines.v"

module ID(
    input wire rst,
	input wire[`InstAddrBus] instAddr_i,
	input wire[`InstBus] inst_i,

	input wire[`RegBus] reg1Data_i,
	input wire[`RegBus] reg2Data_i,

	output reg reg1Enable_o,
	output reg reg2Enable_o,
	
	output reg[`RegAddrBus] reg1Addr_o,
	output reg[`RegAddrBus] reg2Addr_o, 	      
	
	output reg[`AluOpBus] aluOp_o,
	output reg[`AluSelBus] aluSel_o,
	
	output reg[`RegBus] operand1_o,
	output reg[`RegBus] operand2_o,
	
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWritEnablee_o
);

endmodule