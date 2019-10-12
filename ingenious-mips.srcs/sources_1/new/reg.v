`include "defines.v"

module REG(
	input wire clk,
	input wire rst,
	
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire[`RegBus] regWriteData_i,
	input wire regWriteEnable_i,
	
	input wire[`RegAddrBus] reg1Addr_i,
	input wire reg1Enable_i,
	output reg[`RegBus] reg1Data_o,
	
	input wire[`RegAddrBus] reg2Addr_i,
	input wire reg2Enable_i,
	output reg[`RegBus] reg2Data_o
);

endmodule
