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
    input wire[`AluOpBus] ex_aluOp_i,

	input wire[`RegBus] mem_regWriteData_i,
	input wire[`RegAddrBus] mem_regWriteAddr_i,
	input wire mem_regWriteEnable_i,

	input wire isInDelayslot_i,//从idex过来的 表示当前指令是否为延迟槽指令

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

	output reg branchFlag_o,
	output reg[`RegBus] branchTargetAddr_o,

	output reg isInDelayslot_o,//传给idex 表示当前指令是否为延迟槽指令

	output reg[`RegBus] linkAddr_o,//跳转指令的链接指令 一般是zero或者当前地址+8

	output reg nextInstInDelayslot_o,//当 当前指令为跳转指令时 将其置1 表示下一条指令为延迟槽指令
    output wire stallReq_o,
	output wire[`RegBus] inst_o,
    output wire[`RegBus] exceptionType_o,//第[8]位为syscall [9]置为1表示指令无效 [12]表示eret 其他位为0
    output wire[`RegBus] instAddr_o
);

    wire [5:0] op = inst_i[31:26]; //op
    wire [4:0] rs = inst_i[25:21];
    wire [4:0] rt = inst_i[20:16]; //op4
    wire [4:0] rd = inst_i[15:11];
    wire [4:0] shamt = inst_i[10:6]; //op2
    wire [5:0] func = inst_i[5:0]; //op3

    reg exception_is_syscall;
    reg exception_is_eret;
    reg instruction_is_valid;

    reg [`RegBus] immediate;

    reg stallReq_for_reg1_load_relate;
    reg stallReq_for_reg2_load_relate;

    wire[`RegBus] instAddr_plus_8;
    wire[`RegBus] instAddr_plus_4;

    wire[`RegBus] immediate_sll2_signed_extended;

    wire pre_instruction_is_load;

    assign exceptionType_o = {19'b0, exception_is_eret, 2'b0, instruction_is_valid, exception_is_syscall, 8'b0};
    assign pre_instruction_is_load = ((ex_aluOp_i == `EXE_LB_OP) ||
                               (ex_aluOp_i == `EXE_LBU_OP)||
  							   (ex_aluOp_i == `EXE_LH_OP) ||
  							   (ex_aluOp_i == `EXE_LHU_OP)||
  							   (ex_aluOp_i == `EXE_LW_OP) ||
  							   (ex_aluOp_i == `EXE_LWR_OP)||
  							   (ex_aluOp_i == `EXE_LWL_OP)||
  							   (ex_aluOp_i == `EXE_LL_OP) ||
  							   (ex_aluOp_i == `EXE_SC_OP)) ? 1'b1 : 1'b0;
    assign stallReq_o = stallReq_for_reg1_load_relate | stallReq_for_reg2_load_relate;
    assign inst_o = inst_i;
    assign instAddr_o = instAddr_i;
    assign instAddr_plus_8 = instAddr_i + 8;
    assign instAddr_plus_4 = instAddr_i + 4;
    assign immediate_sll2_signed_extended = {{14{inst_i[15]}}, inst_i[15:0], 2'b00};

    always @(*) begin
        if(rst == `Disable) begin //首先给出默认的值
            aluOp_o <= `EXE_NOP_OP;
            aluSel_o <= `EXE_RES_NOP;
            regWriteAddr_o <= rd;
            regWriteEnable_o <= `Disable; //don't write
            instruction_is_valid <= `InstInvalid; //command invalid
            reg1Enable_o <= `Disable;
            reg2Enable_o <= `Disable;
            reg1Addr_o <= rs;
            reg2Addr_o <= rt;
            immediate <= `ZeroWord;
            linkAddr_o <= `ZeroWord;
            branchTargetAddr_o <= `ZeroWord;
            branchFlag_o <= `NotBranch;
            nextInstInDelayslot_o <= `NotInDelaySlot;
            exception_is_syscall <= `False_v;
            exception_is_eret <= `False_v;

            case(op)
                `EXE_LL: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LL_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_SC: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_SC_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_LB: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LB_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_LBU: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LBU_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_LH: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LH_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_LHU: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LHU_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_LW: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LW_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_LWL: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LWL_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_LWR: begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_LWR_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_SB: begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_SB_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_SH: begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_SH_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_SW: begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_SW_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_SWL: begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_SWL_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_SWR: begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_SWR_OP;
                    aluSel_o <= `EXE_RES_LOAD_STORE;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_ORI: begin //rt <- rs | imm
                    regWriteEnable_o <= `Enable; //enable writing the result of ori
                    aluOp_o <= `EXE_OR_OP; //belongs to the or type operation
                    aluSel_o <= `EXE_RES_LOGIC; //belongs to logic operation tpe
                    reg1Enable_o <= `Enable; //read register from Register.v's 1st register
                    reg2Enable_o <= `Disable; //doesn't need to read from second register
                    immediate <= {16'h0, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid; //instruction valid
                end
                `EXE_ANDI:begin //rt <- rs & imm
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_AND_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {16'h0, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid; //instruction valid
                end
                `EXE_XORI:begin //rt <- rs ^ imm
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_XOR_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {16'h0, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid; //instruction valid
                end
                `EXE_LUI:begin //move imm to the upper 16 bits of rt
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_OR_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Enable; //read register from Register.v's 1st register
                    reg2Enable_o <= `Disable; //doesn't need to read from second register
                    immediate <= {inst_i[15:0],16'h0};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid; //instruction valid
                end
                `EXE_PREF:begin
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_NOP_OP;
                    aluSel_o <= `EXE_RES_LOGIC;
                    reg1Enable_o <= `Disable;
                    reg2Enable_o <= `Disable; //doesn't need to read from second register
                    instruction_is_valid <= `InstValid; //instruction valid
                end
                `EXE_SLTI:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_SLT_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_SLTIU:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_SLTU_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_ADDI:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_ADDI_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
                end
                `EXE_ADDIU:begin
                    regWriteEnable_o <= `Enable;
                    aluOp_o <= `EXE_ADDIU_OP;
                    aluSel_o <= `EXE_RES_ARITHMETIC;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Disable;
                    immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                    regWriteAddr_o <= rt;
                    instruction_is_valid <= `InstValid;
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
                    instruction_is_valid <= `InstValid;
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
                    instruction_is_valid <= `InstValid;
                    branchTargetAddr_o <= {instAddr_plus_4[31:28], inst_i[25:0], 2'b00};
                end
                `EXE_BEQ: begin //not equal
                    regWriteEnable_o <= `Disable;
                    aluOp_o <= `EXE_BEQ_OP;
                    aluSel_o <= `EXE_RES_JUMP_BRANCH;
                    reg1Enable_o <= `Enable;
                    reg2Enable_o <= `Enable;
                    instruction_is_valid <= `InstValid;
                    if(operand1_o == operand2_o) begin
                        branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
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
                    instruction_is_valid <= `InstValid;
                    if((operand1_o[31] == 1'b0) && (operand1_o != `ZeroWord)) begin
                        branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
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
                    instruction_is_valid <= `InstValid;
                    if((operand1_o[31] == 1'b1) || (operand1_o == `ZeroWord)) begin
                        branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
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
                    instruction_is_valid <= `InstValid;
                    if(operand1_o != operand2_o) begin
                        branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
                        branchFlag_o <= `Branch;
                        nextInstInDelayslot_o <= `InDelaySlot;
                    end
                end
                `EXE_REGIMM_INST: begin
                    case (rt)
                        `EXE_TEQI: begin
                        	regWriteEnable_o <= `Disable;
                        	aluOp_o <= `EXE_TEQI_OP;
                        	aluSel_o <= `EXE_RES_NOP;
                        	reg1Enable_o <= `Enable;
                        	reg2Enable_o <= `Disable;
                        	immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                        	instruction_is_valid <= `InstValid;
                        end
                        `EXE_TGEI: begin
                        	regWriteEnable_o <= `Disable;
                        	aluOp_o <= `EXE_TGEI_OP;
                        	aluSel_o <= `EXE_RES_NOP;
                        	reg1Enable_o <= `Enable;
                        	reg2Enable_o <= `Disable;
                        	immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                        	instruction_is_valid <= `InstValid;
                        end
                        `EXE_TGEIU: begin
                        	regWriteEnable_o <= `Disable;
                        	aluOp_o <= `EXE_TGEIU_OP;
                        	aluSel_o <= `EXE_RES_NOP;
                        	reg1Enable_o <= `Enable;
                        	reg2Enable_o <= `Disable;
                        	immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                        	instruction_is_valid <= `InstValid;
                        end
                        `EXE_TLTI: begin
                        	regWriteEnable_o <= `Disable;
                        	aluOp_o <= `EXE_TLTI_OP;
                        	aluSel_o <= `EXE_RES_NOP;
                        	reg1Enable_o <= `Enable;
                        	reg2Enable_o <= `Disable;
                        	immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                        	instruction_is_valid <= `InstValid;
                        end
                        `EXE_TLTIU: begin
                        	regWriteEnable_o <= `Disable;
                        	aluOp_o <= `EXE_TLTIU_OP;
                        	aluSel_o <= `EXE_RES_NOP;
                        	reg1Enable_o <= `Enable;
                        	reg2Enable_o <= `Disable;
                        	immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                        	instruction_is_valid <= `InstValid;
                        end
                        `EXE_TNEI: begin
                        	regWriteEnable_o <= `Disable;
                        	aluOp_o <= `EXE_TNEI_OP;
                        	aluSel_o <= `EXE_RES_NOP;
                        	reg1Enable_o <= `Enable;
                        	reg2Enable_o <= `Disable;
                        	immediate <= {{16{inst_i[15]}}, inst_i[15:0]};
                        	instruction_is_valid <= `InstValid;
                        end
                        `EXE_BGEZ : begin //greater than equal to zero
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_BGEZ_OP;
                            aluSel_o <= `EXE_RES_JUMP_BRANCH;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            instruction_is_valid <= `InstValid;
                            if(operand1_o[31] == 1'b0) begin
                                branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
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
                            instruction_is_valid <= `InstValid;
                            if(operand1_o[31] == 1'b0) begin
                                branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
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
                            instruction_is_valid <= `InstValid;
                            if(operand1_o[31] == 1'b1) begin
                                branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
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
                            instruction_is_valid <= `InstValid;
                            if(operand1_o[31] == 1'b1) begin
                                branchTargetAddr_o <= instAddr_plus_4 + immediate_sll2_signed_extended;
                                branchFlag_o <= `Branch;
                                nextInstInDelayslot_o <= `InDelaySlot;
                            end
                        end
                        default: begin
                        end
                    endcase
                end
                `EXE_SPECIAL_INST: begin
                    case(func)
                        `EXE_TEQ: begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_TEQ_OP;
                            aluSel_o <= `EXE_RES_NOP;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_TGE: begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_TGE_OP;
                            aluSel_o <= `EXE_RES_NOP;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_TGEU: begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_TGEU_OP;
                            aluSel_o <= `EXE_RES_NOP;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_TLT: begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_TLT_OP;
                            aluSel_o <= `EXE_RES_NOP;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_TLTU: begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_TLTU_OP;
                            aluSel_o <= `EXE_RES_NOP;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_TNE: begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_TNE_OP;
                            aluSel_o <= `EXE_RES_NOP;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_SYSCALL: begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_SYSCALL_OP;
                            aluSel_o <= `EXE_RES_NOP;
                            reg1Enable_o <= `Disable;
                            reg2Enable_o <= `Disable;
                            instruction_is_valid <= `InstValid;
                            exception_is_syscall<= `True_v;
                        end
                        default: begin
                        end
                    endcase
                    case(shamt)
                        5'b00000: begin
                            case(func)
                                `EXE_SLT: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SLT_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_SLTU: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SLTU_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_ADD: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_ADD_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_ADDU: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_ADDU_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_SUB: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SUB_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_SUBU: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SUBU_OP;
                                    aluSel_o <= `EXE_RES_ARITHMETIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_MULT: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MULT_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_MULTU: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MULTU_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_DIV: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_DIV_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_DIVU: begin
                                   regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_DIVU_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end

                                `EXE_MFHI: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_MFHI_OP;
                                    aluSel_o <= `EXE_RES_MOVE;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                 end
                                `EXE_MFLO: begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_MFLO_OP;
                                    aluSel_o <= `EXE_RES_MOVE;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_MTHI: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MTHI_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Disable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_MTLO: begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_MTLO_OP;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Disable;
                                    instruction_is_valid <= `InstValid;
                                end
                                `EXE_MOVN: begin
                                    aluOp_o <= `EXE_MOVN_OP;
                                    aluSel_o <= `EXE_RES_MOVE;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid;
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
                                    instruction_is_valid <= `InstValid;
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
                                    instruction_is_valid <= `InstValid; //instruction valid
                                end
                                `EXE_AND:begin //rd <- rs & rt
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_AND_OP;
                                    aluSel_o <= `EXE_RES_LOGIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid; //instruction valid
                                end
                                `EXE_XOR:begin // rd <- rs ^ rt
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_XOR_OP;
                                    aluSel_o <= `EXE_RES_LOGIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid; //instruction valid
                                end
                                `EXE_NOR:begin // rd <- not(rs|rt)
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_NOR_OP;
                                    aluSel_o <= `EXE_RES_LOGIC;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid; //instruction valid
                                end
                                `EXE_SLLV:begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SLL_OP;
                                    aluSel_o <= `EXE_RES_SHIFT;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid; //instruction valid
                                end
                                `EXE_SRLV:begin
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SRL_OP;
                                    aluSel_o <= `EXE_RES_SHIFT;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid; //instruction valid
                                end
                                `EXE_SRAV:begin //
                                    regWriteEnable_o <= `Enable;
                                    aluOp_o <= `EXE_SRA_OP;
                                    aluSel_o <= `EXE_RES_SHIFT;
                                    reg1Enable_o <= `Enable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid; //instruction valid
                                end
                                `EXE_SYNC:begin
                                    regWriteEnable_o <= `Disable;
                                    aluOp_o <= `EXE_NOP_OP;
                                    aluSel_o <= `EXE_RES_NOP;
                                    reg1Enable_o <= `Disable;
                                    reg2Enable_o <= `Enable;
                                    instruction_is_valid <= `InstValid; //instruction valid
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
                                    instruction_is_valid <= `InstValid;
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
                                    instruction_is_valid <= `InstValid;
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
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_CLO:begin
                            regWriteEnable_o <= `Enable;
                            aluOp_o <= `EXE_CLO_OP;
                            aluSel_o <= `EXE_RES_ARITHMETIC;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Disable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_MUL:begin
                            regWriteEnable_o <= `Enable;
                            aluOp_o <= `EXE_MUL_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_MADD:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MADD_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_MADDU:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MADDU_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_MSUB:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MSUB_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
                        end
                        `EXE_MSUBU:begin
                            regWriteEnable_o <= `Disable;
                            aluOp_o <= `EXE_MSUBU_OP;
                            aluSel_o <= `EXE_RES_MUL;
                            reg1Enable_o <= `Enable;
                            reg2Enable_o <= `Enable;
                            instruction_is_valid <= `InstValid;
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
                        instruction_is_valid <= `InstValid; //instruction valid
                    end
                    `EXE_SRL: begin //rd <- rt >> shamt (logical)
                        regWriteEnable_o <= `Enable;
                        aluOp_o <= `EXE_SRL_OP;
                        aluSel_o <= `EXE_RES_SHIFT;
                        reg1Enable_o <= `Disable;
                        reg2Enable_o <= `Enable;
                        immediate[4:0] <= shamt;
                        regWriteAddr_o <= rd;
                        instruction_is_valid <= `InstValid; //instruction valid
                    end
                    `EXE_SRA:begin //rd <- rt >> shamt (arithmetic)
                        regWriteEnable_o <= `Enable;
                        aluOp_o <= `EXE_SRA_OP; //belongs to the sra type operation
                        aluSel_o <= `EXE_RES_SHIFT;
                        reg1Enable_o <= `Disable;
                        reg2Enable_o <= `Enable;
                        immediate[4:0] <= shamt;
                        regWriteAddr_o <= rd;
                        instruction_is_valid <= `InstValid; //instruction valid
                    end
                    default: begin
                    end
                endcase //func
            end

            if (inst_i == `EXE_ERET) begin
                regWriteEnable_o <= `Disable;
                aluOp_o <= `EXE_ERET_OP;
                aluSel_o <= `EXE_RES_NOP;
                reg1Enable_o <= `Disable;
                reg2Enable_o <= `Disable;
                instruction_is_valid <= `InstValid;
                exception_is_eret<= `True_v;
            end else if(inst_i[31:21] == 11'b01000000000 && inst_i[10:3] == 8'b0) begin
                aluOp_o <= `EXE_MFC0_OP;
                aluSel_o <= `EXE_RES_MOVE;
                regWriteAddr_o <= rt;
                regWriteEnable_o <= `Enable;
                instruction_is_valid <= `InstValid;
                reg1Enable_o <= `Disable;
                reg2Enable_o <= `Disable;
            end else if(inst_i[31:21] == 11'b01000000100 && inst_i[10:3] == 8'b0) begin
                aluOp_o <= `EXE_MTC0_OP;
                aluSel_o <= `EXE_RES_NOP;
                regWriteEnable_o <= `Disable;
                instruction_is_valid <= `InstValid;
                reg1Enable_o <= `Enable;
                reg2Enable_o <= `Disable;
                reg1Addr_o <= rt;
            end

        end else begin
            //when rst = `Enable everything to zero
            aluOp_o <= `EXE_NOP_OP;
            aluSel_o <= `EXE_RES_NOP;
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            instruction_is_valid <= `InstValid;
            reg1Addr_o <= `NOPRegAddr;
            reg2Addr_o <= `NOPRegAddr;
            reg1Enable_o <= `Disable;
            reg2Enable_o <= `Disable;
            immediate <= `ZeroWord;
            linkAddr_o <= `ZeroWord;
            branchTargetAddr_o <= `ZeroWord;
            branchFlag_o <= `NotBranch;
            nextInstInDelayslot_o <= `NotInDelaySlot;
            exception_is_eret <= `False_v;
            exception_is_syscall <= `False_v;
        end
    end

    //OPERAND1 数据相关和load相关暂停
    always @ (*) begin
        stallReq_for_reg1_load_relate <= `NoStop;
        if(rst == `Enable) begin
            operand1_o <= `ZeroWord;
        end else if ((pre_instruction_is_load == 1'b1) && (ex_regWriteAddr_i == reg1Addr_o) && (reg1Enable_o == `Enable)) begin
            stallReq_for_reg1_load_relate <= `Stop;
        end else if ((reg1Enable_o == `Enable) &&(ex_regWriteEnable_i == `Enable) && (ex_regWriteAddr_i == reg1Addr_o)) begin
            operand1_o <= ex_regWriteData_i;
        end else if ((reg1Enable_o == `Enable) &&(mem_regWriteEnable_i == `Enable) && (mem_regWriteAddr_i == reg1Addr_o)) begin
            operand1_o <= mem_regWriteData_i;
        end else if (reg1Enable_o == `Enable) begin
            operand1_o <= reg1Data_i;
        end else if(reg1Enable_o == `Disable) begin
            operand1_o <= immediate;
        end else begin
            operand1_o <= `ZeroWord;
        end
    end

    //OPERAND2 数据相关和load相关暂停
    always @ (*) begin
        stallReq_for_reg2_load_relate <= `NoStop;
        if(rst == `Enable) begin
            operand2_o <= `ZeroWord;
        end else if ((pre_instruction_is_load == 1'b1) && (ex_regWriteAddr_i == reg2Addr_o) && (reg2Enable_o == `Enable)) begin
            stallReq_for_reg2_load_relate <= `Stop;
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
    end

    //isInDelayslot 输出
    always @ (*) begin
        if(rst == `Enable) begin
            isInDelayslot_o <= `NotInDelaySlot;
        end else begin
            isInDelayslot_o <= isInDelayslot_i;
        end
    end

endmodule
