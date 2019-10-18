`include "defines.v"

module EX(
	input wire rst,
    
    input wire[`AluOpBus] aluOp_i,
	input wire[`AluSelBus] aluSel_i,
	input wire[`RegBus] operand1_i,
	input wire[`RegBus] operand2_i,
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,

	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o

);
    reg[`RegBus] logic_out;
    reg[`RegBus] shift_res;
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
            default: begin
                regWriteData_o <= `ZeroWord;
            end
        endcase
    end

endmodule
