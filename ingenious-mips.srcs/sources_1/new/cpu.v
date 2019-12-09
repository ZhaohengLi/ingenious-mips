`include "defines.v"

module CPU(
    input wire clk,
    input wire rst,

    input wire[5:0] cp0Inte_i,

    input wire[`InstBus] romData_i,
    input wire[`RegBus] ramData_i,

    input wire romStallReq_i,
    input wire ramStallReq_i,

    output wire[`RegBus] ramAddr_o,
    output wire[`InstAddrBus] romAddr_o,
    output wire romEnable_o,
    output wire ramEnable_o,
    output wire[`RegBus] ramData_o,
    output wire ramWriteEnable_o,
    output wire[3:0] ramSel_o,

	output wire cp0TimerInte_o
);

	//MMU TLB
	wire[`InstAddrBus] physInstAddr_mmu_to_pc;
	wire[`InstAddrBus] virtInstAddr_mmu_to_pc;

	wire instInvalid_mmu_to_pc;
	wire instMiss_mmu_to_pc;
	wire instDirty_mmu_to_pc;
	wire instIllegal_mmu_to_pc;

	wire[`InstAddrBus] physDataAddr_mmu_to_ex_mem;
	wire[`InstAddrBus] virtDataAddr_mmu_to_ex_mem;
	wire DataInvalid_mmu_to_ex_mem;
	wire DataMiss_mmu_to_ex_mem;
	wire DataDirty_mmu_to_ex_mem;
	wire DataIllegal_mmu_to_ex_mem;

	wire[`InstAddrBus] physDataAddr_ex_mem_to_mem;
	wire[`InstAddrBus] virtDataAddr_ex_mem_to_mem;
	wire DataInvalid_ex_mem_to_mem;
	wire DataMiss_ex_mem_to_mem;

	wire DataDirty_ex_mem_to_mem;
	wire DataIllegal_ex_mem_to_mem;

    // PC & PC_ADDER & IF_ID
	//wire[`InstAddrBus] pc;

	wire[`InstAddrBus] instAddrForMMU_pc_to_mmu; //to mmu,
	wire[`InstAddrBus] dataVirtAddr_ex_to_mmu; //to mmu,
  wire[`RegBus] branchTarget_id_to_pc;
  wire branchFlag_id_to_pc;
	wire[`RegBus] exceptionType_pc_to_if_id;

    // IF_ID & REG & ID_EX
    wire[`InstBus] inst_if_id_to_id;
    wire[`InstAddrBus] instAddr_if_id_to_id;
    wire[`RegBus] reg1Data_reg_to_id;
    wire[`RegBus] reg2Data_reg_to_id;
    wire reg1Enable_id_to_reg;
    wire reg2Enable_id_to_reg;
    wire[`RegAddrBus] reg1Addr_id_to_reg;
    wire[`RegAddrBus] reg2Addr_id_to_reg;
    wire[`AluOpBus] aluOp_id_to_id_ex;
    wire[`AluSelBus] aluSel_id_to_id_ex;
    wire[`RegBus]operand1_id_to_id_ex;
    wire[`RegBus]operand2_id_to_id_ex;
    wire[`RegBus]inst_id_to_id_ex;
    wire regWriteEnable_id_to_id_ex;
    wire[`RegAddrBus] regWriteAddr_id_to_id_ex;
    wire isInDelayslot_id_to_id_ex;
    wire [`RegBus] linkAddr_id_to_id_ex;
    wire nextInstInDelayslot_id_to_id_ex;
	wire[`RegBus] exceptionType_if_id_to_id;
    // ID_EX & EX & EX_MEM
    wire isInDelayslot_id_ex_to_id;//P211 port "nextInstInDelayslot_o" of id_ex1 to port "isInDelayslot_i" of id1
    wire[`AluOpBus] aluOp_id_ex_to_ex;
    wire[`AluSelBus] aluSel_id_ex_to_ex;
    wire[`RegBus] operand1_id_ex_to_ex;
    wire[`RegBus] operand2_id_ex_to_ex;
    wire[`RegAddrBus] regWriteAddr_id_ex_to_ex;
    wire regWriteEnable_id_ex_to_ex;
    wire[`RegBus] linkAddr_id_ex_to_ex;
    wire isInDelayslot_id_ex_to_ex;
    wire[`RegBus] inst_id_ex_to_ex;
    wire[`RegAddrBus] regWriteAddr_ex_to_ex_mem;
    wire regWriteEnable_ex_to_ex_mem;
    wire[`RegBus] regWriteData_ex_to_ex_mem;
    wire regHILOEnable_ex_to_ex_mem;
    wire[`RegBus] regHI_ex_to_ex_mem;
    wire[`RegBus] regLO_ex_to_ex_mem;
    wire[`AluOpBus] aluOp_ex_to_ex_mem;
    wire[`RegBus] operand2_ex_to_ex_mem;
    wire[`DoubleRegBus] regHILOTemp_ex_to_ex_mem;
    wire[1:0] cnt_ex_to_ex_mem;
    wire[`DoubleRegBus] regHILOTemp_ex_mem_to_ex;
    wire[1:0] cnt_ex_mem_to_ex;
    wire[4:0] cp0ReadAddr_ex_to_cp0;
    wire[`RegBus] cp0WriteData_ex_to_ex_mem;
    wire[4:0] cp0WriteAddr_ex_to_ex_mem;
    wire cp0WriteEnable_ex_to_ex_mem;
    // EX_MEM & MEM & MEM_WB
    wire[`RegAddrBus] regWriteAddr_ex_mem_to_mem;
    wire regWriteEnable_ex_mem_to_mem;
    wire[`RegBus] regWriteData_ex_mem_to_mem;
    wire[`RegAddrBus] regWriteAddr_mem_to_mem_wb;
    wire regWriteEnable_mem_to_mem_wb;
    wire[`RegBus] regWriteData_mem_to_mem_wb;
    wire regHILOEnable_ex_mem_to_mem;
    wire[`RegBus] regHI_ex_mem_to_mem;
    wire[`RegBus] regLO_ex_mem_to_mem;
    wire[`AluOpBus] aluOp_ex_mem_to_mem;
    wire[`RegBus] operand2_ex_mem_to_mem;
    wire LLbitData_mem_to_mem_wb;
    wire LLbitWriteEnable_mem_to_mem_wb;
    wire[`RegBus] cp0WriteData_ex_mem_to_mem;
    wire[4:0] cp0WriteAddr_ex_mem_to_mem;
    wire cp0WriteEnable_ex_mem_to_mem;
    wire[`RegBus] cp0WriteData_mem_to_mem_wb;
    wire[4:0] cp0WriteAddr_mem_to_mem_wb;
    wire cp0WriteEnable_mem_to_mem_wb;
    // MEM_WB & REG
    wire[`RegAddrBus] regWriteAddr_mem_wb_to_reg;
    wire regWriteEnable_mem_wb_to_reg;
    wire[`RegBus] regWriteData_mem_wb_to_reg;
    wire regHILOEnable_mem_to_mem_wb;
    wire[`RegBus] regHI_mem_to_mem_wb;
    wire[`RegBus] regLO_mem_to_mem_wb;
    wire isInstTLBR_mem_to_mem_wb;
    wire isInstTLBWR_mem_to_mem_wb;
    wire isInstTLBWI_mem_to_mem_wb;
    wire isInstTLBP_mem_to_mem_wb;
    // MEM_WB & HILO
    wire regHILOEnable_mem_wb_to_hilo;
    wire[`RegBus] regHI_mem_wb_to_hilo;
    wire[`RegBus] regLO_mem_wb_to_hilo;
    // HILO & EX
    wire[`RegBus] regHI_hilo_to_ex;
    wire[`RegBus] regLO_hilo_to_ex;
    // CTRL
    wire[5:0] stall_ctrl_to_all;
    wire stallReqFromID_id_to_ctrl;
    wire stallReqFromEX_ex_to_ctrl;
    //EX and DIV
    wire divStart_ex_to_div;
    wire [`RegBus] divOperand1_ex_to_div;
    wire [`RegBus] divOperand2_ex_to_div;
    wire divSigned_ex_to_div;
    wire[`DoubleRegBus] divResult_div_to_ex;
    wire divFinished_div_to_ex;
    // MEM_WB & LLBIT
    wire LLbitWriteEnable_mem_wb_to_llbit;
    wire LLbitData_mem_wb_to_llbit;
    //LLBIT & MEM
    wire LLbitData_llbit_to_mem;
    //MEME_WB & CP0
    wire[`RegBus] cp0WriteData_mem_wb_to_cp0;
    wire[4:0] cp0WriteAddr_mem_wb_to_cp0;
    wire cp0WriteEnable_mem_wb_to_cp0;
    wire isInstTLBR_mem_wb_to_cp0;
    wire isInstTLBWR_mem_wb_to_cp0;
    wire isInstTLBWI_mem_wb_to_cp0;
    wire isInstTLBP_mem_wb_to_cp0;
    //EX & CP0
    wire[`RegBus] cp0Data_cp0_to_ex;
    wire flush_ctrl_to_all;
    wire[`RegBus] newInstAddr_ctrl_to_pc;
    wire[`RegBus] exceptionType_id_to_id_ex;
    wire[`RegBus] instAddr_id_to_id_ex;
    wire[`RegBus] exceptionType_id_ex_to_ex;
    wire[`RegBus] instAddr_id_ex_to_ex;
    wire[`RegBus] exceptionType_ex_to_ex_mem;
    wire[`RegBus] instAddr_ex_to_ex_mem;
    wire isInDelayslot_ex_to_ex_mem;
    wire[`RegBus] exceptionType_ex_mem_to_mem;
    wire[`RegBus] instAddr_ex_mem_to_mem;
    wire isInDelayslot_ex_mem_to_mem;

    wire[`RegBus] cp0_count;
    wire[`RegBus] cp0_wired;
    wire[`RegBus] cp0_compare;
    wire[`RegBus] cp0_status;
    wire[`RegBus] cp0_cause;
    wire[`RegBus] cp0_epc;
    wire[`RegBus] cp0_config;
    wire[`RegBus] cp0_ebase;
    wire[`RegBus] cp0_index;
    wire[`RegBus] cp0_entrylo0;
    wire[`RegBus] cp0_entrylo1;
    wire[`RegBus] cp0_badvaddr;
    wire[`RegBus] cp0_entryhi;
    wire[`RegBus] cp0_random;
    wire[`RegBus] cp0_pagemask;
    wire[`RegBus] bad_address;
	wire[`RegBus] cp0_prID;
	wire[`RegBus] cp0_context;

	wire[`InstAddrBus] badAddr_mem_to_mem_wb;
  wire[31:0] badAddr_mem_wb_to_cp0;
    wire[`RegBus] exceptionType_mem_to_cp0_ctrl;
    wire[`RegBus] instAddr_mem_to_cp0;
    wire isInDelayslot_mem_to_cp0;
    wire[`RegBus] cp0EPC_mem_to_ctrl;
    //cp0 to mmu
    wire userMode_cp0_to_mmu;
    wire[7:0] asid_cp0_to_mmu;
    //mmu read entry to CP0
    wire tlbrwEnable_mmu;

	wire[`RegBus] mmu_cp0_tlpb_res;
	wire[2:0] tlbrw_rc0_o;
    wire[2:0] tlbrw_rc1_o;
    wire[7:0] tlbrw_rasid_o;
    wire[18:0] tlbrw_rvpn2_o;
    wire[23:0] tlbrw_rpfn0_o;
    wire[23:0] tlbrw_rpfn1_o;
    wire tlbrw_rd1_o;
    wire tlbrw_rv1_o;
    wire tlbrw_rd0_o;
    wire tlbrw_rv0_o;
    wire tlbrw_rG_o;

	wire[3:0] tlbrw_index;
    wire tlbrw_Enable;
    wire[2:0] tlbrw_wc0;
    wire[2:0] tlbrw_wc1;
    wire[7:0] tlbrw_wasid;
    wire[18:0] tlbrw_wvpn2;
    wire[23:0] tlbrw_wpfn0;
    wire[23:0] tlbrw_wpfn1;
    wire tlbrw_wd1;
    wire tlbrw_wv1;
    wire tlbrw_wd0;
    wire tlbrw_wv0;
    wire tlbrw_wG;

    PC pc1(
        .clk(clk),
        .rst(rst),
	    .flush_i(flush_ctrl_to_all),
	    .stall_i(stall_ctrl_to_all),
	    .branchTargetAddr_i(branchTarget_id_to_pc),
        .branchFlag_i(branchFlag_id_to_pc),
	    .newInstAddr_i(newInstAddr_ctrl_to_pc),
    	.physInstAddr_i(physInstAddr_mmu_to_pc),
   		.virtInstAddr_i(virtInstAddr_mmu_to_pc),
    	.instInvalid_i(instInvalid_mmu_to_pc),
    	.instMiss_i(instMiss_mmu_to_pc),
    	.instDirty_i(instDirty_mmu_to_pc),
    	.instIllegal_i(instIllegal_mmu_to_pc),
        .instAddrForMMU_o(instAddrForMMU_pc_to_mmu),
    	.instAddrForBus_o(romAddr_o),
    	.exceptionType_o(exceptionType_pc_to_if_id),
        .ce_o(romEnable_o)
    );

    IF_ID if_id1(
        .clk(clk),
        .rst(rst),
        .exceptionType_i(exceptionType_pc_to_if_id),
		.exceptionType_o(exceptionType_if_id_to_id),
        .instAddr_i(instAddrForMMU_pc_to_mmu),
        .inst_i(romData_i),
        .instAddr_o(instAddr_if_id_to_id),
        .inst_o(inst_if_id_to_id),
        .stall_i(stall_ctrl_to_all),
        .flush_i(flush_ctrl_to_all)
    );

    ID id1(
        .rst(rst),
        .instAddr_i(instAddr_if_id_to_id),
        .inst_i(inst_if_id_to_id),
        //from registers
        .reg1Data_i(reg1Data_reg_to_id),
        .reg2Data_i(reg2Data_reg_to_id),
        //send to registers
        .reg1Enable_o(reg1Enable_id_to_reg),
        .reg2Enable_o(reg2Enable_id_to_reg),
        .reg1Addr_o(reg1Addr_id_to_reg),
        .reg2Addr_o(reg2Addr_id_to_reg),
        //send to id/ex
        .aluOp_o(aluOp_id_to_id_ex),
        .aluSel_o(aluSel_id_to_id_ex),
        .operand1_o(operand1_id_to_id_ex),
        .operand2_o(operand2_id_to_id_ex),
        .regWriteEnable_o(regWriteEnable_id_to_id_ex),
        .regWriteAddr_o(regWriteAddr_id_to_id_ex),
        //from ex
        .ex_regWriteData_i(regWriteData_ex_to_ex_mem),
        .ex_regWriteAddr_i(regWriteAddr_ex_to_ex_mem),
        .ex_regWriteEnable_i(regWriteEnable_ex_to_ex_mem),
        .mem_regWriteData_i(regWriteData_mem_to_mem_wb),
        .mem_regWriteAddr_i(regWriteAddr_mem_to_mem_wb),
        .mem_regWriteEnable_i(regWriteEnable_mem_to_mem_wb),
        .stallReq_o(stallReqFromID_id_to_ctrl),
        //branch
        .isInDelayslot_i(isInDelayslot_id_ex_to_id), //P211 port "nextInstInDelayslot_o" of id_ex1 to port "isInDelayslot_i" of id1
        .isInDelayslot_o(isInDelayslot_id_to_id_ex),
        .linkAddr_o(linkAddr_id_to_id_ex),
        .nextInstInDelayslot_o(nextInstInDelayslot_id_to_id_ex),
        .branchTargetAddr_o(branchTarget_id_to_pc),
        .branchFlag_o(branchFlag_id_to_pc),
        .inst_o(inst_id_to_id_ex),
        .ex_aluOp_i(aluOp_ex_to_ex_mem),
		    .exceptionType_i(exceptionType_if_id_to_id),
        .exceptionType_o(exceptionType_id_to_id_ex),
        .instAddr_o(instAddr_id_to_id_ex)
    );

    ID_EX id_ex1(
        .clk(clk),
        .rst(rst),
        .aluOp_i(aluOp_id_to_id_ex),
        .aluSel_i(aluSel_id_to_id_ex),
        .operand1_i(operand1_id_to_id_ex),
        .operand2_i(operand2_id_to_id_ex),
        .regWriteAddr_i(regWriteAddr_id_to_id_ex),
        .regWriteEnable_i(regWriteEnable_id_to_id_ex),
        .aluOp_o(aluOp_id_ex_to_ex),
        .aluSel_o(aluSel_id_ex_to_ex),
        .operand1_o(operand1_id_ex_to_ex),
        .operand2_o(operand2_id_ex_to_ex),
        .regWriteAddr_o(regWriteAddr_id_ex_to_ex),
        .regWriteEnable_o(regWriteEnable_id_ex_to_ex),
        .stall_i(stall_ctrl_to_all),
        .isInDelayslot_i(isInDelayslot_id_to_id_ex),
        .linkAddr_i(linkAddr_id_to_id_ex),
        .isInDelayslot_o(isInDelayslot_id_ex_to_ex),
        .linkAddr_o(linkAddr_id_ex_to_ex),
        .inst_i(inst_id_to_id_ex),
        .inst_o(inst_id_ex_to_ex),
        .nextInstInDelayslot_i(nextInstInDelayslot_id_to_id_ex),
        .nextInstInDelayslot_o(isInDelayslot_id_ex_to_id),//P211 port "nextInstInDelayslot_o" of id_ex1 to port "isInDelayslot_i" of id1 , it is not a typo
        .flush_i(flush_ctrl_to_all),
        .exceptionType_i(exceptionType_id_to_id_ex),
        .instAddr_i(instAddr_id_to_id_ex),
        .exceptionType_o(exceptionType_id_ex_to_ex),
        .instAddr_o(instAddr_id_ex_to_ex)
    );

    EX ex1(
        .rst(rst),
        .aluOp_i(aluOp_id_ex_to_ex),
        .aluSel_i(aluSel_id_ex_to_ex),
        .operand1_i(operand1_id_ex_to_ex),
        .operand2_i(operand2_id_ex_to_ex),
        .regWriteAddr_i(regWriteAddr_id_ex_to_ex),
        .regWriteEnable_i(regWriteEnable_id_ex_to_ex),
        .regWriteAddr_o(regWriteAddr_ex_to_ex_mem),
        .regWriteData_o(regWriteData_ex_to_ex_mem),
        .regWriteEnable_o(regWriteEnable_ex_to_ex_mem),
        .mem_regHILOEnable_i(regHILOEnable_mem_to_mem_wb),
        .mem_regHI_i(regHI_mem_to_mem_wb),
        .mem_regLO_i(regLO_mem_to_mem_wb),
        .mem_wb_regHILOEnable_i(regHILOEnable_mem_wb_to_hilo),
        .mem_wb_regHI_i(regHI_mem_wb_to_hilo),
        .mem_wb_regLO_i(regLO_mem_wb_to_hilo),
        //from hilo
        .regHI_i(regHI_hilo_to_ex),
        .regLO_i(regLO_hilo_to_ex),
        .regHILOEnable_o(regHILOEnable_ex_to_ex_mem),
        .regHI_o(regHI_ex_to_ex_mem), .regLO_o(regLO_ex_to_ex_mem),
        .regHILOTemp_i(regHILOTemp_ex_mem_to_ex),
        .cnt_i(cnt_ex_mem_to_ex),
        .regHILOTemp_o(regHILOTemp_ex_to_ex_mem),
        .cnt_o(cnt_ex_to_ex_mem),
        .divResult_i(divResult_div_to_ex),
        .divFinished_i(divFinished_div_to_ex),
        .divStart_o(divStart_ex_to_div),
        .divSigned_o(divSigned_ex_to_div),
        .divOperand1_o(divOperand1_ex_to_div),
        .divOperand2_o(divOperand2_ex_to_div),
        .isInDelayslot_i(isInDelayslot_id_ex_to_ex),
        .linkAddr_i(linkAddr_id_ex_to_ex),
        .stallReq_o(stallReqFromEX_ex_to_ctrl),
        .inst_i(inst_id_ex_to_ex),
        .aluOp_o(aluOp_ex_to_ex_mem),
        .memAddr_o(dataVirtAddr_ex_to_mmu),
        .operand2_o(operand2_ex_to_ex_mem),
        .cp0Data_i(cp0Data_cp0_to_ex),
        .cp0ReadAddr_o(cp0ReadAddr_ex_to_cp0),
        .cp0WriteEnable_o(cp0WriteEnable_ex_to_ex_mem),
        .cp0WriteAddr_o(cp0WriteAddr_ex_to_ex_mem),
        .cp0WriteData_o(cp0WriteData_ex_to_ex_mem),
        .mem_cp0WriteEnable_i(cp0WriteEnable_mem_to_mem_wb),
        .mem_cp0WriteAddr_i(cp0WriteAddr_mem_to_mem_wb),
        .mem_cp0WriteData_i(cp0WriteData_mem_to_mem_wb),
        .mem_wb_cp0WriteEnable_i(cp0WriteEnable_mem_wb_to_cp0),
        .mem_wb_cp0WriteAddr_i(cp0WriteAddr_mem_wb_to_cp0),
        .mem_wb_cp0WriteData_i(cp0WriteData_mem_wb_to_cp0),
        .exceptionType_i(exceptionType_id_ex_to_ex),
        .instAddr_i(instAddr_id_ex_to_ex),
        .exceptionType_o(exceptionType_ex_to_ex_mem),
        .instAddr_o(instAddr_ex_to_ex_mem),
        .isInDelayslot_o(isInDelayslot_ex_to_ex_mem)
    );

    EX_MEM ex_mem1(
        .clk(clk),
        .rst(rst),
        .regWriteAddr_i(regWriteAddr_ex_to_ex_mem),
        .regWriteEnable_i(regWriteEnable_ex_to_ex_mem),
        .regWriteData_i(regWriteData_ex_to_ex_mem),
        .regWriteAddr_o(regWriteAddr_ex_mem_to_mem),
        .regWriteEnable_o(regWriteEnable_ex_mem_to_mem),
        .regWriteData_o(regWriteData_ex_mem_to_mem),
        //ex to ex_mem
        .regHILOEnable_i(regHILOEnable_ex_to_ex_mem),
        .regHI_i(regHI_ex_to_ex_mem),
        .regLO_i(regLO_ex_to_ex_mem),
        //ex_mem_to mem
        .regHILOEnable_o(regHILOEnable_ex_mem_to_mem),
        .regHI_o(regHI_ex_mem_to_mem),
        .regLO_o(regLO_ex_mem_to_mem),
        .regHILOTemp_i(regHILOTemp_ex_to_ex_mem),
        .cnt_i(cnt_ex_to_ex_mem),
        .regHILOTemp_o(regHILOTemp_ex_mem_to_ex),
        .cnt_o(cnt_ex_mem_to_ex),
        .stall_i(stall_ctrl_to_all),
        .aluOp_i(aluOp_ex_to_ex_mem),
        .aluOp_o(aluOp_ex_mem_to_mem),
        //.memAddr_i(),
        //.memAddr_o(),
        .operand2_i(operand2_ex_to_ex_mem),
        .operand2_o(operand2_ex_mem_to_mem),
        .cp0WriteEnable_i(cp0WriteEnable_ex_to_ex_mem),
        .cp0WriteAddr_i(cp0WriteAddr_ex_to_ex_mem),
        .cp0WriteData_i(cp0WriteData_ex_to_ex_mem),
        .cp0WriteEnable_o(cp0WriteEnable_ex_mem_to_mem),
        .cp0WriteAddr_o(cp0WriteAddr_ex_mem_to_mem),
        .cp0WriteData_o(cp0WriteData_ex_mem_to_mem),
        .flush_i(flush_ctrl_to_all),
        .exceptionType_i(exceptionType_ex_to_ex_mem),
        .instAddr_i(instAddr_ex_to_ex_mem),
        .isInDelayslot_i(isInDelayslot_ex_to_ex_mem),
        .exceptionType_o(exceptionType_ex_mem_to_mem),
        .instAddr_o(instAddr_ex_mem_to_mem),

        .physDataAddr_i(physDataAddr_mmu_to_ex_mem),
        .virtDataAddr_i(virtDataAddr_mmu_to_ex_mem),
        .dataInvalid_i(DataInvalid_mmu_to_ex_mem),
        .dataMiss_i(DataMiss_mmu_to_ex_mem),
        .dataDirty_i(DataDirty_mmu_to_ex_mem),
        .dataIllegal_i(DataIllegal_mmu_to_ex_mem),

        .physDataAddr_o(physDataAddr_ex_mem_to_mem),
        .virtDataAddr_o(virtDataAddr_ex_mem_to_mem),
        .dataInvalid_o(DataInvalid_ex_mem_to_mem),
        .dataMiss_o(DataMiss_ex_mem_to_mem),
        .dataDirty_o(DataDirty_ex_mem_to_mem),
        .dataIllegal_o(DataIllegal_ex_mem_to_mem),

        .isInDelayslot_o(isInDelayslot_ex_mem_to_mem)
    );

    MEM mem1(
        .rst(rst),
        .regWriteAddr_i(regWriteAddr_ex_mem_to_mem),
        .regWriteEnable_i(regWriteEnable_ex_mem_to_mem),
        .regWriteData_i(regWriteData_ex_mem_to_mem),
        .regWriteAddr_o(regWriteAddr_mem_to_mem_wb),
        .regWriteEnable_o(regWriteEnable_mem_to_mem_wb),
        .regWriteData_o(regWriteData_mem_to_mem_wb),
        //ex_mem to mem hilo
        .regHILOEnable_i(regHILOEnable_ex_mem_to_mem),
        .regHI_i(regHI_ex_mem_to_mem),
        .regLO_i(regLO_ex_mem_to_mem),
        //mem to mem_wb hilo
        .regHILOEnable_o(regHILOEnable_mem_to_mem_wb),
        .regHI_o(regHI_mem_to_mem_wb),
        .regLO_o(regLO_mem_to_mem_wb),
        .memData_i(ramData_i),
        .aluOp_i(aluOp_ex_mem_to_mem),
        //.memAddr_i(mmu_mem_virtual_addr),
        .operand2_i(operand2_ex_mem_to_mem),
        .memAddr_o(ramAddr_o),
        .memWriteEnable_o(ramWriteEnable_o),
        .memSel_o(ramSel_o),
        .memData_o(ramData_o),
        .memEnable_o(ramEnable_o),
        .LLbitData_i(LLbitData_llbit_to_mem),
        .mem_wb_LLbitData_i(LLbitData_mem_wb_to_llbit),
        .mem_wb_LLbitWriteEnable_i(LLbitWriteEnable_mem_wb_to_llbit),
        .LLbitData_o(LLbitData_mem_to_mem_wb),
        .LLbitWriteEnable_o(LLbitWriteEnable_mem_to_mem_wb),
        .cp0WriteEnable_i(cp0WriteEnable_ex_mem_to_mem),
        .cp0WriteAddr_i(cp0WriteAddr_ex_mem_to_mem),
        .cp0WriteData_i(cp0WriteData_ex_mem_to_mem),
        .cp0WriteEnable_o(cp0WriteEnable_mem_to_mem_wb),
        .cp0WriteAddr_o(cp0WriteAddr_mem_to_mem_wb),
        .cp0WriteData_o(cp0WriteData_mem_to_mem_wb),
        .exceptionType_i(exceptionType_ex_mem_to_mem),
        .instAddr_i(instAddr_ex_mem_to_mem),
        .isInDelayslot_i(isInDelayslot_ex_mem_to_mem),
        .cp0Status_i(cp0_status),
        .cp0Cause_i(cp0_cause),
        .cp0EPC_i(cp0_epc),
        .mem_wb_cp0WriteEnable_i(cp0WriteEnable_mem_wb_to_cp0),
        .mem_wb_cp0WriteAddr_i(cp0WriteAddr_mem_wb_to_cp0),
        .mem_wb_cp0WriteData_i(cp0WriteData_mem_wb_to_cp0),
        .exceptionType_o(exceptionType_mem_to_cp0_ctrl),
        .instAddr_o(instAddr_mem_to_cp0),
        .isInDelayslot_o(isInDelayslot_mem_to_cp0),

        .badAddr_o(badAddr_mem_to_mem_wb),
        //mmu data result
        .physDataAddr_i(physDataAddr_ex_mem_to_mem),
        .virtDataAddr_i(virtDataAddr_ex_mem_to_mem),
        .dataInvalid_i(DataInvalid_ex_mem_to_mem),
        .dataMiss_i(DataMiss_ex_mem_to_mem),
        .dataDirty_i(DataDirty_ex_mem_to_mem),
        .dataIllegal_i(DataIllegal_ex_mem_to_mem),

        .isInstTLBR_o(isInstTLBR_mem_to_mem_wb),
        .isInstTLBWR_o(isInstTLBWR_mem_to_mem_wb),
        .isInstTLBWI_o(isInstTLBWI_mem_to_mem_wb),
        .isInstTLBP_o(isInstTLBP_mem_to_mem_wb),

        .cp0EPC_o(cp0EPC_mem_to_ctrl)
    );

    MEM_WB mem_wb1 (
        .clk(clk),
        .rst(rst),
        .regWriteAddr_i(regWriteAddr_mem_to_mem_wb),
        .regWriteEnable_i(regWriteEnable_mem_to_mem_wb),
        .regWriteData_i(regWriteData_mem_to_mem_wb),
        .regWriteAddr_o(regWriteAddr_mem_wb_to_reg),
        .regWriteEnable_o(regWriteEnable_mem_wb_to_reg),
        .regWriteData_o(regWriteData_mem_wb_to_reg),
        //mem to mem_wb
        .regHILOEnable_i(regHILOEnable_mem_to_mem_wb),
        .regHI_i(regHI_mem_to_mem_wb),
        .regLO_i(regLO_mem_to_mem_wb),
        .isInstTLBR_i(isInstTLBR_mem_to_mem_wb),
        .isInstTLBWR_i(isInstTLBWR_mem_to_mem_wb),
        .isInstTLBWI_i(isInstTLBWI_mem_to_mem_wb),
        .isInstTLBP_i(isInstTLBP_mem_to_mem_wb),
        .badAddr_i(badAddr_mem_to_mem_wb),
        //mem_wb to hilo
        .regHILOEnable_o(regHILOEnable_mem_wb_to_hilo),
        .regHI_o(regHI_mem_wb_to_hilo),
        .regLO_o(regLO_mem_wb_to_hilo),
        .stall_i(stall_ctrl_to_all),
        .LLbitData_i(LLbitData_mem_to_mem_wb),
        .LLbitWriteEnable_i(LLbitWriteEnable_mem_to_mem_wb),
        .LLbitData_o(LLbitData_mem_wb_to_llbit),
        .LLbitWriteEnable_o(LLbitWriteEnable_mem_wb_to_llbit),
        .cp0WriteEnable_i(cp0WriteEnable_mem_to_mem_wb),
        .cp0WriteAddr_i(cp0WriteAddr_mem_to_mem_wb),
        .cp0WriteData_i(cp0WriteData_mem_to_mem_wb),
        .cp0WriteEnable_o(cp0WriteEnable_mem_wb_to_cp0),
        .cp0WriteAddr_o(cp0WriteAddr_mem_wb_to_cp0),
        .cp0WriteData_o(cp0WriteData_mem_wb_to_cp0),
        .isInstTLBR_o(isInstTLBR_mem_wb_to_cp0),
        .isInstTLBWR_o(isInstTLBWR_mem_wb_to_cp0),
        .isInstTLBWI_o(isInstTLBWI_mem_wb_to_cp0),
        .isInstTLBP_o(isInstTLBP_mem_wb_to_cp0),
        .badAddr_o(badAddr_mem_wb_to_cp0),
        .flush_i(flush_ctrl_to_all)
    );

    CP0 cp01(
        .clk(clk),
        .rst(rst),
        .cp0ReadAddr_i(cp0ReadAddr_ex_to_cp0),
        .cp0WriteEnable_i(cp0WriteEnable_mem_wb_to_cp0),
        .cp0WriteData_i(cp0WriteData_mem_wb_to_cp0),
        .cp0WriteAddr_i(cp0WriteAddr_mem_wb_to_cp0),
        .cp0Data_o(cp0Data_cp0_to_ex), //cp0 rdata

		.cp0Inte_i(cp0Inte_i),
        .exceptionType_i(exceptionType_mem_to_cp0_ctrl),
		.badAddr_i(badAddr_mem_wb_to_cp0),
        .instAddr_i(instAddr_mem_to_cp0),
        .isInDelayslot_i(isInDelayslot_mem_to_cp0),


        .cp0Count_o(cp0_count),//count_o
		.cp0Compare_o(cp0_compare),//compare_o
		.cp0Status_o(cp0_status),//status_o
		.cp0Cause_o(cp0_cause),//cause_o
		.cp0EPC_o(cp0_epc),//epc_o
		.cp0Config_o(cp0_config),//config_o
		.cp0EBase_o(cp0_ebase),//ebase_o

		.cp0Random_o(cp0_random),
		.cp0Index_o(cp0_index),
		.cp0EntryHI_o(cp0_entryhi),
		.cp0EntryLO1_o(cp0_entrylo1),
		.cp0EntryLO0_o(cp0_entrylo0), //lo0 not loo or l00
		.cp0Badvaddr_o(bad_address),
		.cp0Pagemask_o(cp0_pagemask),
		.cp0Context_o(cp0_context),
    .cp0Wired_o(cp0_wired),


		.tlbpRes_i(mmu_cp0_tlpb_res),   //tlpb from mmu tlb

        .isInstTLBP_i(isInstTLBP_mem_wb_to_cp0),
		.isInstTLBR_i(isInstTLBR_mem_wb_to_cp0),
		.isInstTLBWR_i(isInstTLBWR_mem_wb_to_cp0),
		.isInstTLBWI_i(isInstTLBWI_mem_wb_to_cp0),
		//tlbr_res from mmu A TLB Entry
		.tlbc0_i(tlbrw_rc0_o),
		.tlbc1_i(tlbrw_rc1_o),
		.tlbasid_i(tlbrw_rasid_o),
		.tlbvpn2(tlbrw_rvpn2_o),
		.tlbpfn0(tlbrw_rpfn0_o),
		.tlbpfn1(tlbrw_rpfn1_o),
		.tlbd1(tlbrw_rd1_o),
		.tlbv1(tlbrw_rv1_o),
		.tlbd0(tlbrw_rd0_o),
		.tlbv0(tlbrw_rv0_o),
		.tlbG(tlbrw_rG_o),

		.asid_o(asid_cp0_to_mmu),
		.userMode_o(userMode_cp0_to_mmu),
        .cp0TimerInte_o(cp0TimerInte_o)
    );


    HILO hilo1 (
        .clk(clk),
        .rst(rst),
        .regHILOEnable_i(regHILOEnable_mem_wb_to_hilo),
        .regHI_i(regHI_mem_wb_to_hilo),
        .regLO_i(regLO_mem_wb_to_hilo),
        .regHI_o(regHI_hilo_to_ex),
        .regLO_o(regLO_hilo_to_ex)
    );

    DIV div1(
        .rst(rst),
        .clk(clk),
        .signed_div_i(divSigned_ex_to_div),
        .operand1_i(divOperand1_ex_to_div),
        .operand2_i(divOperand2_ex_to_div),
        .start_i(divStart_ex_to_div),
        .annul_i(1'b0),
        .quotient_o(divResult_div_to_ex),
        .finished_o(divFinished_div_to_ex)
    );

    LLBIT llbit1(
        .rst(rst),
        .clk(clk),
        .flush_i(flush_ctrl_to_all),
        .LLbitData_i(LLbitData_mem_wb_to_llbit),
        .LLbitWriteEnable_i(LLbitWriteEnable_mem_wb_to_llbit),
        .LLbitData_o(LLbitData_llbit_to_mem)
    );

    CTRL ctrl1(
        .rst(rst),
        .stallReqFromIF_i(romStallReq_i),
        .stallReqFromID_i(stallReqFromID_id_to_ctrl),
        .stallReqFromEX_i(stallReqFromEX_ex_to_ctrl),
        .stallReqFromMEM_i(ramStallReq_i),
        .stall_o(stall_ctrl_to_all),
        .cp0EPC_i(cp0EPC_mem_to_ctrl),
        .cp0EBase_i(cp0_ebase),
        .exceptionType_i(exceptionType_mem_to_cp0_ctrl),
        .newInstAddr_o(newInstAddr_ctrl_to_pc),
        .flush_o(flush_ctrl_to_all)
    );

    REG reg1(
        .clk(clk),
        .rst(rst),
        .reg1Addr_i(reg1Addr_id_to_reg),
        .reg2Addr_i(reg2Addr_id_to_reg),
        .reg1Enable_i(reg1Enable_id_to_reg),
        .reg2Enable_i(reg2Enable_id_to_reg),
        .reg1Data_o(reg1Data_reg_to_id),
        .reg2Data_o(reg2Data_reg_to_id),
        .regWriteAddr_i(regWriteAddr_mem_wb_to_reg),
        .regWriteData_i(regWriteData_mem_wb_to_reg),
        .regWriteEnable_i(regWriteEnable_mem_wb_to_reg)
    );

    MMU mmu1(
        .clk(clk),
        .rst(rst),
        .asid_i(asid_cp0_to_mmu),
        .userMode_i(userMode_cp0_to_mmu),
        .instVirtAddr_i(instAddrForMMU_pc_to_mmu),
        .dataVirtAddr_i(dataVirtAddr_ex_to_mmu),
        //mmu result inst_result
        .physInstAddr_o(physInstAddr_mmu_to_pc),
        .virtInstAddr_o(virtInstAddr_mmu_to_pc),
        .instInvalid_o(instInvalid_mmu_to_pc),
        .instMiss_o(instMiss_mmu_to_pc),
        .instDirty_o(instDirty_mmu_to_pc),
        .instIllegal_o(instIllegal_mmu_to_pc),
        //mmu result data result
        .physDataAddr_o(physDataAddr_mmu_to_ex_mem),
        .virtDataAddr_o(virtDataAddr_mmu_to_ex_mem),
        .dataInvalid_o(DataInvalid_mmu_to_ex_mem),
        .dataMiss_o(DataMiss_mmu_to_ex_mem),
        .dataDirty_o(DataDirty_mmu_to_ex_mem),
        .dataIllegal_o(DataIllegal_mmu_to_ex_mem),

        // tlbr/tlbwi/tlbwr
        .tlbrw_index(tlbrw_index),   //input
        .tlbrw_Enable(tlbrw_Enable),  //input
		//tlbrw_wdata     //input
        .tlbrw_wc0(tlbrw_wc0),
        .tlbrw_wc1(tlbrw_wc1),
        .tlbrw_wasid(tlbrw_wasid),
        .tlbrw_wvpn2(tlbrw_wvpn2),
        .tlbrw_wpfn0(tlbrw_wpfn0),
        .tlbrw_wpfn1(tlbrw_wpfn1),
        .tlbrw_wd1(tlbrw_wd1),
        .tlbrw_wv1(tlbrw_wv1),
        .tlbrw_wd0(tlbrw_wd0),
        .tlbrw_wv0(tlbrw_wv0),
        .tlbrw_wG(tlbrw_wG),
		//tlbw_rdata      //output to cp0
        .tlbrw_rc0_o(tlbrw_rc0_o),
        .tlbrw_rc1_o(tlbrw_rc1_o),
        .tlbrw_rasid_o(tlbrw_rasid_o),
        .tlbrw_rvpn2_o(tlbrw_rvpn2_o),
        .tlbrw_rpfn0_o(tlbrw_rpfn0_o),
        .tlbrw_rpfn1_o(tlbrw_rpfn1_o),
        .tlbrw_rd1_o(tlbrw_rd1_o),
        .tlbrw_rv1_o(tlbrw_rv1_o),
        .tlbrw_rd0_o(tlbrw_rd0_o),
        .tlbrw_rv0_o(tlbrw_rv0_o),
        .tlbrw_rG_o(tlbrw_rG_o),

        //tlbp
        .tlbp_entry_hi(cp0_entryhi),  //input
        .tlbp_index_o(mmu_cp0_tlpb_res)    //output
    );

    assign tlbrw_Enable = (isInstTLBWI_mem_to_mem_wb | isInstTLBWR_mem_to_mem_wb);
	assign tlbrw_index = (isInstTLBWI_mem_wb_to_cp0 == 1'b1) ? cp0_index : cp0_random;
	assign tlbrw_wvpn2 = cp0_entryhi[31:13];
	assign tlbrw_wasid = cp0_entryhi[7:0];
	assign tlbrw_wpfn0 = cp0_entrylo0[29:6];
	assign tlbrw_wpfn1 = cp0_entrylo1[29:6];
	assign tlbrw_wc0 = cp0_entrylo0[5:3];
	assign tlbrw_wc1 = cp0_entrylo1[5:3];
	assign tlbrw_wd0 = cp0_entrylo0[2];
	assign tlbrw_wd1 = cp0_entrylo1[2];
	assign tlbrw_wv0 = cp0_entrylo0[1];
	assign tlbrw_wv1 = cp0_entrylo1[1];
	assign tlbrw_wG = cp0_entrylo0[0];

endmodule
