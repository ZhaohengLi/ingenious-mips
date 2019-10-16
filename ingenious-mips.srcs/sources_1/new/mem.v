`include "defines.v"

module MEM(
	input wire rst,
	
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,
	input wire[`RegBus] regWriteData_i,

	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o
	
);
    always @(*) begin
        if(rst == `Disable) begin
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            regWriteData_o <= regWriteData_i;
        end else begin //rst to all zero
            regWriteAddr_o <= `NOPRegAddr; 
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
        end
    end

endmodule