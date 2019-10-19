`include "defines.v"

module MEM(
	input wire rst,
	
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,
	input wire[`RegBus] regWriteData_i,
    
    input wire regHILOEnable_i,
	input wire[`RegBus] regHI_i,
	input wire[`RegBus] regLO_i,
	
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o,
	//HILO
	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o
	
);
    always @(*) begin
        if(rst == `Disable) begin
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            regWriteData_o <= regWriteData_i;
            regHILOEnable_o <= regHILOEnable_i;
            regHI_o <= regHI_i;
            regLO_o <=  regLO_i;
        end else begin //rst to all zero
            regWriteAddr_o <= `NOPRegAddr; 
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord; 
        end
    end

endmodule