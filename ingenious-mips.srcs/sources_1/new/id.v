`include "defines.v"

module ID(
    input wire rst,
	input wire[`InstAddrBus] instAddr_i,
	input wire[`InstBus] inst_i,

	input wire[`RegBus] reg1Data_i,
	input wire[`RegBus] reg2Data_i,

//	input wire[`RegBus] ex_regWriteData_i,
//	input wire[`RegAddrBus] ex_regWriteAddr_i,
//	input wire ex_regWriteEnable_i,

//	input wire[`RegBus] mem_regWriteData_i,
//	input wire[`RegAddrBus] mem_regWriteAddr_i,
//	input wire mem_regWriteEnable_i,

	output reg reg1Enable_o, //enable read reg1
	output reg reg2Enable_o, //enable read reg2

	output reg[`RegAddrBus] reg1Addr_o,
	output reg[`RegAddrBus] reg2Addr_o,

	output reg[`AluOpBus] aluOp_o,
	output reg[`AluSelBus] aluSel_o,

	output reg[`RegBus] operand1_o, //reg1wdata_out
	output reg[`RegBus] operand2_o, //reg2wdata_out

	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o
);
    //to see if it's an ori operation, look at 31:26
    //rd <- rs[reg1] (?) rt [reg2]
    wire [5:0] op = inst_i[31:26];
    wire [4:0] rs = inst_i[25:21];
    wire [4:0] rt = inst_i[20:16];
    wire [4:0] rd = inst_i[15:11];
    wire [4:0] shamt = inst_i[10:6];
    wire [5:0] func = inst_i[5:0];

    //immediate
    reg [31:0] immediate;
    reg valid_instruct;
    
    always @(*) begin
        if(rst == `Disable) begin
            aluOp_o <= `EXE_NOP_OP;
            aluSel_o <= `EXE_RES_NOP;
            regWriteAddr_o <= rd;
            regWriteEnable_o <= `Disable; //don't write
            valid_instruct <= `InstInvalid; //command invalid
            reg1Enable_o <= `Disable;
            reg2Enable_o <= `Disable;
            reg1Addr_o <= rs;
            reg2Addr_o <= rt;
            immediate <= `ZeroWord;

            case(op)
                `EXE_ORI: begin
                    regWriteEnable_o <= `Enable; //enable writing the result of ori
                    aluOp_o <= `EXE_OR_OP; //belongs to the or type operation
                    aluSel_o <= `EXE_RES_LOGIC; //belongs to logic operation tpe
                    reg1Enable_o <= `Enable; //read register from Register.v's 1st register
                    reg2Enable_o <= `Disable; //doesn't need to read from second register
                    immediate <= {16'h0, inst_i[15:0]}; //the immediate needed for ori operation
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid; //instruction valid
                end
                default:begin
                end
            endcase
            
        end else begin
            //everything to zero
            aluOp_o <= `EXE_NOP_OP;
            aluSel_o <= `EXE_RES_NOP;
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            reg1Addr_o <= `NOPRegAddr;
            reg2Addr_o <= `NOPRegAddr;
            reg1Enable_o <= `Disable;
            reg2Enable_o <= `Disable;
            valid_instruct <= `InstValid;
            immediate <= `ZeroWord;
        end //if
    end //always

    always @ (*) begin
        if(rst == `Enable) begin
            operand1_o <= `ZeroWord;
//        end else if ((reg1Enable_o == 1'b1) &&(ex_regWriteEnable_i == 1'b1) &&
//        (ex_regWriteAddr_i == reg1Addr_o)) begin
//            operand1_o <= ex_regWriteData_i;
//        end else if ((reg1Enable_o == 1'b1) &&(mem_regWriteEnable_i == 1'b1) &&
//        (mem_regWriteAddr_i == reg1Addr_o)) begin
//            operand1_o <= mem_regWriteData_i;
        end else if (reg1Enable_o == `Enable) begin
            operand1_o <= reg1Data_i;
        end else if(reg1Enable_o == `Disable) begin
            operand1_o <= immediate;
        end else begin
            operand1_o <= `ZeroWord;
        end
    end //always
    always @ (*) begin
        if(rst == `Enable) begin
            operand2_o <= `ZeroWord;
//        end else if ((reg2Enable_o == 1'b1) &&(ex_regWriteEnable_i == 1'b1) &&
//        (ex_regWriteAddr_i == reg1Addr_o)) begin
//            operand2_o <= ex_regWriteData_i;
//        end else if ((reg2Enable_o == 1'b1) &&(mem_regWriteEnable_i == 1'b1) &&
//        (mem_regWriteAddr_i == reg1Addr_o)) begin
//            operand2_o <= mem_regWriteData_i;
        end else if (reg2Enable_o == `Enable) begin
            operand2_o <= reg2Data_i;
        end else if(reg2Enable_o == `Disable) begin
            operand2_o <= immediate;
        end else begin
            operand2_o <= `ZeroWord;
        end
    end //always

endmodule
