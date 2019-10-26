`include "defines.v"

module EX_MEM(
	input wire clk,
	input wire rst,
	
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,
	input wire[`RegBus] regWriteData_i, 	
    
    input wire regHILOEnable_i,
	input wire[`RegBus] regHI_i,
	input wire[`RegBus] regLO_i,
	
	input wire[5:0] stall_i,
	
    input wire[`DoubleRegBus] regHILO_i,
    input wire[1:0] cnt_i,
	
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o,
	//HILO
	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o,
	
	output reg[`DoubleRegBus] regHILO_o,
	output reg[1:0] cnt_o
);
    always @ (posedge clk) begin
        if(rst == `Enable) begin
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord; 
            regHILO_o <= {`ZeroWord, `ZeroWord};
            cnt_o <= 2'b00;
        end else if (stall_i[3] == `Stop && stall_i[4] == `NoStop) begin
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord; 
            regHILO_o <= regHILO_i;
            cnt_o <= cnt_i;
        end else if (stall_i[3] == `NoStop) begin
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            regWriteData_o <= regWriteData_i;
            regHILOEnable_o <= regHILOEnable_i;
            regHI_o <= regHI_i;
            regLO_o <=  regLO_i;
            regHILO_o <= {`ZeroWord, `ZeroWord};
            cnt_o <= 2'b00;
        end else begin
            regHILO_o <= regHILO_i;
            cnt_o <= cnt_i;
        end
    end //always

endmodule