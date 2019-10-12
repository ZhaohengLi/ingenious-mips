`include "defines.v"

module EX_MEM(
	input wire clk,
	input wire rst,
	
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnabale_i,
	input wire[`RegBus] regWriteData_i, 	

	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o
);

endmodule