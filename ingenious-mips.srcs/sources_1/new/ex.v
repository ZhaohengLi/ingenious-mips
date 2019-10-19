`include "defines.v"

module EX(
	input wire rst,
    
    input wire[`AluOpBus] aluOp_i,
	input wire[`AluSelBus] aluSel_i,
	input wire[`RegBus] operand1_i,
	input wire[`RegBus] operand2_i,
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,
	
	input wire[`RegBus] regHI_i,
	input wire[`RegBus] regLO_i,
	
	input wire mem_regHILOEnable_i,
	input wire[`RegBus] mem_regHI_i,
	input wire[`RegBus] mem_regLO_i,
	
	input wire mem_wb_regHILOEnable_i,
	input wire[`RegBus] mem_wb_regHI_i,
	input wire[`RegBus] mem_wb_regLO_i,

	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o,
	
	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o

);
    reg[`RegBus] logic_out;
    reg[`RegBus] shift_res;
    reg[`RegBus] move_res;
    reg[`RegBus] hi; // latest value of reg hi
    reg[`RegBus] lo; // latest value of reg lo
    
    // set the latest value of reg hi & lo
    always @ (*) begin
        if (rst == `Enable) begin
            hi <= `ZeroWord;
            lo <= `ZeroWord;
        end else if (mem_regHILOEnable_i == `Enable) begin
            hi <= mem_regHI_i;
            lo <= mem_regLO_i;
        end else if (mem_wb_regHILOEnable_i == `Enable) begin
            hi <= mem_wb_regHI_i;
            lo <= mem_wb_regLO_i;
        end else begin
            hi <= regHI_i;
            lo <= regLO_i;
        end
    end
    
    // set move_res
    always @ (*) begin
        if (rst == `Enable) begin
            move_res <= `ZeroWord;
        end else begin
            move_res <= `ZeroWord;
            case (aluOp_i)
                `EXE_MFHI_OP: begin
                    move_res <= hi;
                end
                `EXE_MFLO_OP: begin
                    move_res <= lo;
                end
                `EXE_MOVZ_OP: begin
                    move_res <= operand1_i;
                end
                `EXE_MOVN_OP: begin
                    move_res <= operand2_i;
                end
                default: begin
                end
            endcase
        end
    end
    
    // set regHI_o regLO_o regHILOEnable_o
    always @ (*) begin
        if (rst == `Enable) begin
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
        end else if (aluOp_i == `EXE_MTHI_OP) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= operand1_i;
            regLO_o <= lo;
        end else if (aluOp_i == `EXE_MTLO_OP) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= hi;
            regLO_o <= operand1_i;
        end else begin
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
        end
    end
    
    // set logic_out
    always @ (*) begin
        if (rst == `Enable) begin //set logic output to zero
            logic_out <= `ZeroWord;
        end else begin
            case(aluOp_i)
                `EXE_OR_OP: begin
                    logic_out <= operand1_i | operand2_i;
                end //exe_or_op
                `EXE_AND_OP:begin
                    logic_out <= operand1_i & operand2_i;
                end
                `EXE_NOR_OP: begin
                    logic_out <= ~(operand1_i | operand2_i);
                end
                `EXE_XOR_OP:begin
                    logic_out <= operand1_i ^ operand2_i;
                end
                default: begin
                    logic_out <= `ZeroWord;
                end //default

            endcase
        end //if
    end //always
    
    
    // set shift_res
    always @(*) begin
        if(rst == `Enable) begin
            shift_res <= `ZeroWord;
        end else begin
            case(aluOp_i)
                `EXE_SLL_OP: begin
                    shift_res <= operand2_i << operand1_i[4:0];
                end
                `EXE_SRL_OP: begin
                    shift_res <= operand2_i >> operand1_i[4:0];
                end
                `EXE_SRA_OP: begin // operand2 >> operand1[4:0]
                    shift_res <= ({32{operand2_i[31]}} << (6'd32 - {1'b0, operand1_i[4:0]}))| operand2_i >> operand1_i[4:0];
                end
                default: begin
                    shift_res <= `ZeroWord;
                end
            endcase
        end//if
    end
    
    // set regWriteData_o
    always @(*) begin
        regWriteEnable_o <= regWriteEnable_i;
        regWriteAddr_o <= regWriteAddr_i;
        case(aluSel_i)
            `EXE_RES_LOGIC: begin
                regWriteData_o <= logic_out; //write out the logic operation result
            end
            `EXE_RES_SHIFT: begin
                regWriteData_o <= shift_res;
            end
            `EXE_RES_MOVE: begin
                regWriteData_o <= move_res;
            end
            default: begin
                regWriteData_o <= `ZeroWord;
            end
        endcase
    end

endmodule
