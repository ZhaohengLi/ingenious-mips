`include "defines.v"

module ID(
    input wire rst,
	input wire[`InstAddrBus] instAddr_i, //pc
	input wire[`InstBus] inst_i,

	input wire[`RegBus] reg1Data_i,
	input wire[`RegBus] reg2Data_i,

	input wire[`RegBus] ex_regWriteData_i,
	input wire[`RegAddrBus] ex_regWriteAddr_i,
	input wire ex_regWriteEnable_i,

	input wire[`RegBus] mem_regWriteData_i,
	input wire[`RegAddrBus] mem_regWriteAddr_i,
	input wire mem_regWriteEnable_i,

	input wire isInDelayslot_i,

	output reg reg1Enable_o, //enable read reg1
	output reg reg2Enable_o, //enable read reg2

	output reg[`RegAddrBus] reg1Addr_o,
	output reg[`RegAddrBus] reg2Addr_o,

	output reg[`AluOpBus] aluOp_o,
	output reg[`AluSelBus] aluSel_o,

	output reg[`RegBus] operand1_o, //reg1_o
	output reg[`RegBus] operand2_o, //reg2_o

	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,

	output wire stallReq_o,

	output reg branchFlag_o,
	output reg[`RegBus] branchTargetAddr_o,
	output reg isInDelayslot_o,
	output reg[`RegBus] linkAddr_o,
	output reg nextInstInDelayslot_o
);

    assign stallReq_o = `NoStop;

    //to see if it's an ori operation, look at 31:26
    //rd <- rs[reg1] (?) rt [reg2]
    wire [5:0] op = inst_i[31:26]; //op
    wire [4:0] rs = inst_i[25:21];
    wire [4:0] rt = inst_i[20:16]; //op4
    wire [4:0] rd = inst_i[15:11];
    wire [4:0] shamt = inst_i[10:6]; //op2
    wire [5:0] func = inst_i[5:0]; //op3

    //immediate
    reg [31:0] immediate;
    reg valid_instruct;

    wire[`RegBus] instAddr_plus_8;
    wire[`RegBus] instAddr_plus_4;
    wire[`RegBus] imm_sll2_signedext;

    assign instAddr_plus_8 = instAddr_i + 8;
    assign instAddr_plus_4 = instAddr_i + 4;

    assign imm_sll2_signedext = {{14{inst_i[15]}}, inst_i[15:0], 2'b00};

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
            linkAddr_o <= `ZeroWord;
            branchTargetAddr_o <= `ZeroWord;
            branchFlag_o <= `NotBranch;
            nextInstInDelayslot_o <= `NotInDelaySlot;

            case(op)
                `EXE_ORI: begin //rt <- rs | imm
                    regWriteEnable_o <= `Enable; //enable writing the result of ori
                    aluOp_o <= `EXE_OR_OP; //belongs to the or type operation
                    aluSel_o <= `EXE_RES_LOGIC; //belongs to logic operation tpe
                    reg1Enable_o <= `Enable; //read register from Register.v's 1st register
                    reg2Enable_o <= `Disable; //doesn't need to read from second register
                    immediate <= {16'h0, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid; //instruction valid
                end
                `EXE_ANDI:begin //rt <- rs & imm
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_AND_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {16'h0, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid; //instruction valid
                end
                `EXE_XORI:begin //rt <- rs ^ imm
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_XOR_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {16'h0, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid; //instruction valid
                end
                `EXE_LUI:begin //move imm to the upper 16 bits of rt
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_OR_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Enable; //read register from Register.v's 1st register
                    reg2Enable_o <= `Disable; //doesn't need to read from second register
                    immediate <= {inst_i[15:0],16'h0};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid; //instruction valid
                end
                `EXE_PREF:begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_NOP_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Disable;
                    reg2Enable_o <= `Disable; //doesn't need to read from second register
                    valid_instruct <= `InstValid; //instruction valid
                end
                `EXE_SLTI:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_SLT_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid;
                end
                `EXE_SLTIU:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_SLTU_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid;
                end
                `EXE_ADDI:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_ADDI_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid;
                end
                `EXE_ADDIU:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_ADDIU_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    valid_instruct <= `InstValid;
                end
                `EXE_J: begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_J_OP;
                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                    reg1Enable_o <= `Disable;
                    reg2Enable_o <= `Disable;
                    linkAddr_o <= `ZeroWord;
                    branchFlag_o <= `Branch;
                    nextInstInDelayslot_o <= `InDelaySlot;
                    valid_instruct <= `InstValid;
                    branchTargetAddr_o <= {instAddr_plus_4[31:28], inst_i[25:0], 2'b00};
                end
                `EXE_JAL: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_JAL_OP;
                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                    reg1Enable_o <= `Disable;
                    reg2Enable_o <= `Disable;
                    regWriteAddr_o <= 5'b11111;
                    linkAddr_o <= instAddr_plus_8;
                    branchFlag_o <= `Branch;
                    nextInstInDelayslot_o <= `InDelaySlot;
                    valid_instruct <= `InstValid;
                    branchTargetAddr_o <= {instAddr_plus_4[31:28], inst_i[25:0], 2'b00};
                end
                `EXE_BEQ: begin //not equal
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_BEQ_OP;
                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    valid_instruct <= `InstValid;
                    if(operand1_o == operand2_o) begin
                        branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                        branchFlag_o <= `Branch;
                        nextInstInDelayslot_o <= `InDelaySlot;
                    end
                end
                `EXE_BGTZ: begin //greater than zero
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_BGTZ_OP;
                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    valid_instruct <= `InstValid;
                    if((operand1_o[31] == 1'b0) && (operand1_o != `ZeroWord)) begin
                        branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                        branchFlag_o <= `Branch;
                        nextInstInDelayslot_o <= `InDelaySlot;
                    end
                end
                `EXE_BLEZ: begin //less than equal to zero
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_BLEZ_OP;
                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    valid_instruct <= `InstValid;
                    if((operand1_o[31] == 1'b1) || (operand1_o == `ZeroWord)) begin
                        branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                        branchFlag_o <= `Branch;
                        nextInstInDelayslot_o <= `InDelaySlot;
                    end
                end
                `EXE_BNE: begin // not equal
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_BLEZ_OP;
                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    valid_instruct <= `InstValid;
                    if(operand1_o != operand2_o) begin
                        branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                        branchFlag_o <= `Branch;
                        nextInstInDelayslot_o <= `InDelaySlot;
                    end
                end
                `EXE_REGIMM_INST: begin
                    case (rt)
                        `EXE_BGEZ : begin //greater than equal to zero
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_BGEZ_OP;
                            aluSel_o <= `EXE_RES_JUMP_BRANCH;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            valid_instruct <= `InstValid;
                            if(operand1_o[31] == 1'b0) begin
                                branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                                branchFlag_o <= `Branch;
                                nextInstInDelayslot_o <= `InDelaySlot;
                            end
                        end
                        `EXE_BGEZAL: begin
                            regWriteEnable_o <= `Enable;
                            aluOp_o <= `EXE_BGEZAL_OP;
                            aluSel_o <= `EXE_RES_JUMP_BRANCH;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            linkAddr_o <= instAddr_plus_8;
                            regWriteAddr_o <= 5'b11111;
                            valid_instruct <= `InstValid;
                            if(operand1_o[31] == 1'b0) begin
                                branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                                branchFlag_o <= `Branch;
                                nextInstInDelayslot_o <= `InDelaySlot;
                            end
                        end
                        `EXE_BLTZ: begin //less than zero
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_BGEZAL_OP;
                            aluSel_o <= `EXE_RES_JUMP_BRANCH;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            valid_instruct <= `InstValid;
                            if(operand1_o[31] == 1'b1) begin
                                branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                                branchFlag_o <= `Branch;
                                nextInstInDelayslot_o <= `InDelaySlot;
                            end
                        end
                        `EXE_BLTZAL: begin
                            regWriteEnable_o <= `Enable;
                            aluOp_o <= `EXE_BGEZAL_OP;
                            aluSel_o <= `EXE_RES_JUMP_BRANCH;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            linkAddr_o <= instAddr_plus_8;
                            regWriteAddr_o <= 5'b11111;
                            valid_instruct <= `InstValid;
                            if(operand1_o[31] == 1'b1) begin
                                branchTargetAddr_o <= instAddr_plus_4 + imm_sll2_signedext;
                                branchFlag_o <= `Branch;
                                nextInstInDelayslot_o <= `InDelaySlot;
                            end
                        end
                        default: begin
                        end
                    endcase
                end
                `EXE_SPECIAL_INST: begin
                    case(shamt)
                        5'b00000: begin
                            case(func)
                                `EXE_SLT: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SLT_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_SLTU: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SLTU_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_ADD: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_ADD_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_ADDU: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_ADDU_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_SUB: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SUB_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_SUBU: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SUBU_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_MULT: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MULT_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_MULTU: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MULTU_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_DIV: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_DIV_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_DIVU: begin
                                   regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_DIVU_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end

                                `EXE_MFHI: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_MFHI_OP;
                                    aluSel_o <= `EXE_RES_MOVE;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                 end
                                `EXE_MFLO: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_MFLO_OP;
                                    aluSel_o <= `EXE_RES_MOVE;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_MTHI: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MTHI_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Disable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_MTLO: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MTLO_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Disable;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_MOVN: begin
                                    aluOp_o <= `EXE_MOVN_OP;
                                    aluSel_o <= `EXE_RES_MOVE;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                    if (operand2_o != `ZeroWord) begin
                                        regWriteEnable_o <= `Enable;
                                    end else begin
                                        regWriteEnable_o <= `Disable;
                                    end
                                end
                                `EXE_MOVZ: begin
                                    aluOp_o <= `EXE_MOVZ_OP;
                                    aluSel_o <= `EXE_RES_MOVE;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid;
                                    if (operand2_o == `ZeroWord) begin
                                        regWriteEnable_o <= `Enable;
                                    end else begin
                                        regWriteEnable_o <= `Disable;
                                    end
                                end
                                `EXE_OR: begin // rd <- rs | rt
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_OR_OP;
                                    aluSel_o <= `EXE_RES_LOGIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_AND:begin //rd <- rs & rt
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_AND_OP;
                                    aluSel_o <= `EXE_RES_LOGIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_XOR:begin // rd <- rs ^ rt
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_XOR_OP;
                                    aluSel_o <= `EXE_RES_LOGIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_NOR:begin // rd <- not(rs|rt)
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_NOR_OP;
                                    aluSel_o <= `EXE_RES_LOGIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_SLLV:begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SLL_OP;
                                    aluSel_o <= `EXE_RES_SHIFT;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_SRLV:begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SRL_OP;
                                    aluSel_o <= `EXE_RES_SHIFT;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_SRAV:begin //
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SRA_OP;
                                    aluSel_o <= `EXE_RES_SHIFT;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_SYNC:begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_NOP_OP;
                                    aluSel_o <= `EXE_RES_NOP;
                                    reg1Enable_o <= `Disable;
                                    reg2Enable_o <= `Enable;
                                    valid_instruct <= `InstValid; //instruction valid
                                end
                                `EXE_JR: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_JR_OP;
                                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Disable;
                                    linkAddr_o <= `ZeroWord;
                                    branchTargetAddr_o <= operand1_o;
                                    branchFlag_o <= `Branch;
                                    nextInstInDelayslot_o <= `InDelaySlot;
                                    valid_instruct <= `InstValid;
                                end
                                `EXE_JALR: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_JALR_OP;
                                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Disable;
                                    regWriteAddr_o <= rd;
                                    linkAddr_o <= instAddr_plus_8;
                                    branchTargetAddr_o <= operand1_o;
                                    branchFlag_o <= `Branch;
                                    nextInstInDelayslot_o <= `InDelaySlot;
                                    valid_instruct <= `InstValid;
                                end
                                default: begin
                                end
                            endcase //func
                        end
                        default: begin
                        end
                    endcase //shamt
                end //exespecialinst
                `EXE_SPECIAL2_INST:begin
                    case(func)
                        `EXE_CLZ:begin
                            regWriteEnable_o <= `Enable;
                            aluOp_o <= `EXE_CLZ_OP;
                            aluSel_o <= `EXE_RES_ARITHMETIC;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            valid_instruct <= `InstValid;
                        end
                        `EXE_CLO:begin
                            regWriteEnable_o <= `Enable;
                            aluOp_o <= `EXE_CLO_OP;
                            aluSel_o <= `EXE_RES_ARITHMETIC;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            valid_instruct <= `InstValid;
                        end
                        `EXE_MUL:begin
                            regWriteEnable_o <= `Enable;
                            aluOp_o <= `EXE_MUL_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            valid_instruct <= `InstValid;
                        end
                        `EXE_MADD:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MADD_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            valid_instruct <= `InstValid;
                        end
                        `EXE_MADDU:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MADDU_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            valid_instruct <= `InstValid;
                        end
                        `EXE_MSUB:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MSUB_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            valid_instruct <= `InstValid;
                        end
                        `EXE_MSUBU:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MSUBU_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            valid_instruct <= `InstValid;
                        end
                        default:begin
                        end
                    endcase
                end
                default:begin
                end
            endcase // op
            if(inst_i[31:21] == 11'b00000000000) begin
                case(func)
                    `EXE_SLL: begin //rd <- rt << shamt
                        regWriteEnable_o <= `Enable;
                        aluOp_o <= `EXE_SLL_OP;
                        aluSel_o <= `EXE_RES_SHIFT;
                        reg1Enable_o <= `Disable;
                        reg2Enable_o <= `Enable;
                        immediate[4:0] <= shamt;
                        regWriteAddr_o <= rd;
                        valid_instruct <= `InstValid; //instruction valid
                    end
                    `EXE_SRL: begin //rd <- rt >> shamt (logical)
                         regWriteEnable_o <= `Enable;
                        aluOp_o <= `EXE_SRL_OP;
                        aluSel_o <= `EXE_RES_SHIFT;
                        reg1Enable_o <= `Disable;
                        reg2Enable_o <= `Enable;
                        immediate[4:0] <= shamt;
                        regWriteAddr_o <= rd;
                        valid_instruct <= `InstValid; //instruction valid
                    end
                    `EXE_SRA:begin //rd <- rt >> shamt (arithmetic)
                         regWriteEnable_o <= `Enable;
                        aluOp_o <= `EXE_SRA_OP; //belongs to the sra type operation
                        aluSel_o <= `EXE_RES_SHIFT;
                        reg1Enable_o <= `Disable;
                        reg2Enable_o <= `Enable;
                        immediate[4:0] <= shamt;
                        regWriteAddr_o <= rd;
                        valid_instruct <= `InstValid; //instruction valid
                    end
                    default: begin
                    end

                endcase //func
            end

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
            linkAddr_o <= `ZeroWord;
            branchTargetAddr_o <= `ZeroWord;
            branchFlag_o <= `NotBranch;
            nextInstInDelayslot_o <= `NotInDelaySlot;
        end //if
    end //always


    //OPERAND1
    always @ (*) begin
        if(rst == `Enable) begin
            operand1_o <= `ZeroWord;
        end else if ((reg1Enable_o == `Enable) &&(ex_regWriteEnable_i == `Enable) &&
        (ex_regWriteAddr_i == reg1Addr_o)) begin
            operand1_o <= ex_regWriteData_i;
        end else if ((reg1Enable_o == `Enable) &&(mem_regWriteEnable_i == `Enable) &&
        (mem_regWriteAddr_i == reg1Addr_o)) begin
            operand1_o <= mem_regWriteData_i;
        end else if (reg1Enable_o == `Enable) begin
            operand1_o <= reg1Data_i;
        end else if(reg1Enable_o == `Disable) begin
            operand1_o <= immediate;
        end else begin
            operand1_o <= `ZeroWord;
        end
    end //always


    //OPERAND2
    always @ (*) begin
        if(rst == `Enable) begin
            operand2_o <= `ZeroWord;
        end else if ((reg2Enable_o == `Enable) &&(ex_regWriteEnable_i == `Enable) &&
        (ex_regWriteAddr_i == reg2Addr_o)) begin
            operand2_o <= ex_regWriteData_i;
        end else if ((reg2Enable_o == `Enable) &&(mem_regWriteEnable_i == `Enable) &&
        (mem_regWriteAddr_i == reg2Addr_o)) begin
            operand2_o <= mem_regWriteData_i;
        end else if (reg2Enable_o == `Enable) begin
            operand2_o <= reg2Data_i;
        end else if(reg2Enable_o == `Disable) begin
            operand2_o <= immediate;
        end else begin
            operand2_o <= `ZeroWord;
        end
    end //always

    always @ (*) begin
        if(rst == `Enable) begin
            isInDelayslot_o <= `NotInDelaySlot;
        end else begin
            isInDelayslot_o <= isInDelayslot_i;
        end
    end

endmodule
