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
	input wire id_in_delayslot,
	input wire[`RegBus] id_link_addr,
	input wire delayslot_inst_i,
	
	input wire[5:0] stall_i,
	
	output reg[`AluOpBus] aluOp_o,
	output reg[`AluSelBus] aluSel_o,
	output reg[`RegBus] operand1_o,
	output reg[`RegBus] operand2_o,
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg ex_in_delayslot,
	output reg[`RegBus] ex_link_addr,
	output reg is_in_delayslot_o
	
);
    always @ (posedge clk) begin
        if(rst == `Enable) begin
            aluSel_o <= `EXE_RES_NOP;
            aluOp_o <= `EXE_NOP_OP;
            operand1_o <= `ZeroWord;
            operand2_o <= `ZeroWord;
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            ex_link_addr <= `ZeroWord;
            ex_in_delayslot <= `NotInDelaySlot;
            is_in_delayslot_o <= `NotInDelaySlot;
        end else if (stall_i[2] == `Stop && stall_i[3] == `NoStop) begin
            aluSel_o <= `EXE_RES_NOP;
            aluOp_o <= `EXE_NOP_OP;
            operand1_o <= `ZeroWord;
            operand2_o <= `ZeroWord;
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            ex_link_addr <= `ZeroWord;
            ex_in_delayslot <= `NotInDelaySlot;
        end else if (stall_i[2] == `NoStop) begin
            aluSel_o <= aluSel_i;
            aluOp_o <= aluOp_i;
            operand1_o <= operand1_i;
            operand2_o <= operand2_i;
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            ex_link_addr <= id_link_addr;
            ex_in_delayslot <= id_in_delayslot;
            is_in_delayslot_o <= delayslot_inst_i;
        end
    end //always
endmodule