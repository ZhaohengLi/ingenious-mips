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

    always @ (*) begin
        if (rst == `Enable) begin //set logic output to zero
            logic_out <= `ZeroWord;
        end else begin
            case(aluOp_i)
                `EXE_OR_OP: begin
                    logic_out <= operand1_i | operand2_i;
                end //exe_or_op
                default: begin
                    logic_out <= `ZeroWord;
                end //default

            endcase
        end //if
    end //always

    always @(*) begin
        regWriteEnable_o <= regWriteEnable_i;
        regWriteAddr_o <= regWriteAddr_i;
        case(aluSel_i)
            `EXE_RES_LOGIC: begin
                regWriteData_o <= logic_out; //write out the logic operation result
            end
            default: begin
                regWriteData_o <= `ZeroWord;
            end
        endcase
    end

endmodule
