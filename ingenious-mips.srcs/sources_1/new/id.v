`include "defines.v"

module ID(
    input wire rst,
	input wire[`InstAddrBus] instAddr_i,
	input wire[`InstBus] inst_i,

	input wire[`RegBus] reg1Data_i,
	input wire[`RegBus] reg2Data_i,

	output reg reg1Enable_o, //enable read reg1
	output reg reg2Enable_o, //enable read reg2
	
	output reg[`RegAddrBus] reg1Addr_o,
	output reg[`RegAddrBus] reg2Addr_o, 	      
	
	output reg[`AluOpBus] aluOp_o,
	output reg[`AluSelBus] aluSel_o,
	
	output reg[`RegBus] operand1_o, //reg1out
	output reg[`RegBus] operand2_o, //reg2out
	
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWritEnablee_o
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
            regWritEnablee_o <= `Disable; //don't write
            valid_instruct <= `InstInvalid; //command invalid
            reg1Enable_o <= 1'b0;
            reg2Enable_o <= 1'b0;
            reg1Addr_o <= rs;
            reg2Addr_o <= rt;
            immediate <= 32'h00000000;
            
            case(op)
                `EXE_ORI: begin
                    regWritEnablee_o <= 1'b1; //enable writing the result of ori
                    aluOp_o <= `EXE_OR_OP; //belongs to the or type operation
                    aluSel_o <= `EXE_RES_LOGIC; //belongs to logic operation tpe
                    reg1Enable_o <= 1'b1; //read register from Register.v's 1st register
                    reg2Enable_o <= 1'b0; //doesn't need to read from second register
                    immediate <= {16'h0, inst_i[15:0]}; //the immediate needed for ori operation
                    regWriteAddr_o <= rd;
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
            reg1Addr_o <= `NOPRegAddr;
            reg2Addr_o <= `NOPRegAddr;
            regWritEnablee_o <= `Disable; //don't write
            valid_instruct <= `InstValid; //command valid
            reg1Enable_o <= 1'b0;
            reg2Enable_o <= 1'b0;
            immediate <= 32'h0;
        end //if
    end //always
    
    always @ (*) begin
        if(rst == `Enable) begin
            operand1_o <= 32'h00000000;
        end else if (reg1Enable_o == 1'b1) begin
            operand1_o <= reg1Data_i;
        end else if(reg1Enable_o == 1'b0) begin
            operand1_o <= immediate;
        end else begin
            operand1_o <= 32'h00000000;
        end
    end //always
    always @ (*) begin
        if(rst == `Enable) begin
            operand2_o <= 32'h00000000;
        end else if (reg2Enable_o == 1'b1) begin
            operand2_o <= reg2Data_i;
        end else if(reg2Enable_o == 1'b0) begin
            operand2_o <= immediate;
        end else begin
            operand2_o <= 32'h00000000;
        end
    end //always

endmodule