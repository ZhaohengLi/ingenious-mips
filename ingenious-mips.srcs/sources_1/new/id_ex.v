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
	
	input wire[`RegBus] inst_i,
    output reg[`RegBus] inst_o,
    
	input wire isInDelayslot_i,//id_is_in_delayslot
	input wire[`RegBus] linkAddr_i,//id_link_address
	input wire nextInstInDelayslot_i,//next_inst_in_delayslot_i

	input wire[5:0] stall_i,

	output reg[`AluOpBus] aluOp_o,
	output reg[`AluSelBus] aluSel_o,
	output reg[`RegBus] operand1_o,
	output reg[`RegBus] operand2_o,
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,

	output reg isInDelayslot_o,//ex_is_in_delayslot
	output reg[`RegBus] linkAddr_o,//ex_link_address
	output reg nextInstInDelayslot_o//is_in_delayslot_o

);
    always @ (posedge clk) begin
        if(rst == `Enable) begin
            aluSel_o <= `EXE_RES_NOP;
            aluOp_o <= `EXE_NOP_OP;
            operand1_o <= `ZeroWord;
            operand2_o <= `ZeroWord;
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            linkAddr_o <= `ZeroWord;
            isInDelayslot_o <= `NotInDelaySlot;
            nextInstInDelayslot_o <= `NotInDelaySlot;
            inst_o <= `ZeroWord;
        end else if (stall_i[2] == `Stop && stall_i[3] == `NoStop) begin
            aluSel_o <= `EXE_RES_NOP;
            aluOp_o <= `EXE_NOP_OP;
            operand1_o <= `ZeroWord;
            operand2_o <= `ZeroWord;
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            linkAddr_o <= `ZeroWord;
            isInDelayslot_o <= `NotInDelaySlot;
            inst_o <= `ZeroWord;
        end else if (stall_i[2] == `NoStop) begin
            aluSel_o <= aluSel_i;
            aluOp_o <= aluOp_i;
            operand1_o <= operand1_i;
            operand2_o <= operand2_i;
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            linkAddr_o <= linkAddr_i;
            isInDelayslot_o <= isInDelayslot_i;
            nextInstInDelayslot_o <= nextInstInDelayslot_i;
            inst_o <= inst_i;
        end
    end //always
endmodule
