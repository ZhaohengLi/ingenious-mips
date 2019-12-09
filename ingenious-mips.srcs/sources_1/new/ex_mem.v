`include "defines.v"

module EX_MEM(
	input wire clk,
	input wire rst,
	input wire flush_i,
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,
	input wire[`RegBus] regWriteData_i,
    input wire regHILOEnable_i,
	input wire[`RegBus] regHI_i,
	input wire[`RegBus] regLO_i,
	input wire[5:0] stall_i,
    input wire[`DoubleRegBus] regHILOTemp_i,
    input wire[1:0] cnt_i,
    input wire[`AluOpBus] aluOp_i,
    //input wire[`RegBus] memAddr_i,
    input wire[`RegBus] operand2_i,
	input wire cp0WriteEnable_i,
	input wire[4:0] cp0WriteAddr_i,
	input wire[`RegBus] cp0WriteData_i,
	input wire[`RegBus] exceptionType_i,
	input wire[`RegBus] instAddr_i,
	input wire isInDelayslot_i,

    output reg[`AluOpBus] aluOp_o,
    //output reg[`RegBus] memAddr_o,
    output reg[`RegBus] operand2_o,
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o,
	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o,
	output reg[`DoubleRegBus] regHILOTemp_o,
	output reg[1:0] cnt_o,
	output reg cp0WriteEnable_o,
	output reg[4:0] cp0WriteAddr_o,
	output reg[`RegBus] cp0WriteData_o,
	output reg[`RegBus] exceptionType_o,
	output reg[`RegBus] instAddr_o,

	input wire[31:0] physDataAddr_i,
    input wire[31:0] virtDataAddr_i,
    input wire dataInvalid_i,
    input wire dataMiss_i,
    input wire dataDirty_i,
    input wire dataIllegal_i,

	output reg[31:0] physDataAddr_o,
    output reg[31:0] virtDataAddr_o,
    output reg dataInvalid_o,
    output reg dataMiss_o,
    output reg dataDirty_o,
    output reg dataIllegal_o,

	output reg isInDelayslot_o
);
    always @ (posedge clk) begin
        if(rst == `Enable || flush_i == 1'b1) begin
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
            regHILOTemp_o <= {`ZeroWord, `ZeroWord};
            cnt_o <= 2'b00;
            aluOp_o <= `EXE_NOP_OP;
            operand2_o <= `ZeroWord;
            cp0WriteEnable_o <= `Disable;
            cp0WriteAddr_o <= 5'b00000;
            cp0WriteData_o <= `ZeroWord;
			exceptionType_o <= `ZeroWord;
			isInDelayslot_o <= `NotInDelaySlot;
			instAddr_o <= `ZeroWord;
			physDataAddr_o <= `ZeroWord;
		    virtDataAddr_o <= `ZeroWord;
			dataInvalid_o <= 1'b0;
			dataMiss_o <= 1'b0;
			dataDirty_o <= 1'b0;
			dataIllegal_o <= 1'b0;
        end else if (stall_i[3] == `Stop && stall_i[4] == `NoStop) begin
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
            regHILOTemp_o <= regHILOTemp_i;
            cnt_o <= cnt_i;
            aluOp_o <= `EXE_NOP_OP;
            operand2_o <= `ZeroWord;
            cp0WriteEnable_o <= `Disable;
            cp0WriteAddr_o <= 5'b00000;
            cp0WriteData_o <= `ZeroWord;
			exceptionType_o <= `ZeroWord;
			isInDelayslot_o <= `NotInDelaySlot;
			instAddr_o <= `ZeroWord;
			physDataAddr_o <= `ZeroWord;
			virtDataAddr_o <= `ZeroWord;
			dataInvalid_o <= 1'b0;
			dataMiss_o <= 1'b0;
			dataDirty_o <= 1'b0;
			dataIllegal_o <= 1'b0;
        end else if (stall_i[3] == `NoStop) begin
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            regWriteData_o <= regWriteData_i;
            regHILOEnable_o <= regHILOEnable_i;
            regHI_o <= regHI_i;
            regLO_o <=  regLO_i;
            regHILOTemp_o <= {`ZeroWord, `ZeroWord};
            cnt_o <= 2'b00;
            aluOp_o <= aluOp_i;
            operand2_o <= operand2_i;
            cp0WriteEnable_o <= cp0WriteEnable_i;
            cp0WriteAddr_o <= cp0WriteAddr_i;
            cp0WriteData_o <= cp0WriteData_i;
			exceptionType_o <= exceptionType_i;
			isInDelayslot_o <= isInDelayslot_i;
			instAddr_o <= instAddr_i;
			physDataAddr_o <=  physDataAddr_i;
			virtDataAddr_o <=  virtDataAddr_i;
			dataInvalid_o <=  dataInvalid_i;
			dataMiss_o <=  dataMiss_i;
			dataDirty_o <=  dataDirty_i;
			dataIllegal_o <=  dataIllegal_i;
        end else begin
            regHILOTemp_o <= regHILOTemp_i;
            cnt_o <= cnt_i;
        end
    end //always

endmodule
