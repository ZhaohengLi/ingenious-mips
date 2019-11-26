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
    // PC & PC_ADDER & IF_ID
    wire[`InstAddrBus] instAddr_pc_adder_to_pc;
    wire[`InstAddrBus] instAddr_pc_to_if_id;
    wire[`RegBus] branchTarget_id_to_pc;
    wire branchFlag_id_to_pc;
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
    wire[`RegBus] memAddr_ex_to_ex_mem;
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
    wire[`RegBus] memAddr_ex_mem_to_mem;
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
    // MEM_WB & HILO
    wire regHILOEnable_mem_wb_to_hilo;
    wire[`RegBus] regHI_mem_wb_to_hilo;
    wire[`RegBus] regLO_mem_wb_to_hilo;
    // HILO & EX
    wire[`RegBus] regHI_hilo_to_ex;
    wire[`RegBus] regLO_hilo_to_ex;
    // CTRL
    wire[5:0] stall_ctrl_to_all;
    wire stallReqFromIF_id_to_ctrl;
    wire stallReqFromID_id_to_ctrl;
    wire stallReqFromEX_ex_to_ctrl;
    wire stallReqFromMEM_id_to_ctrl;
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
    wire[`RegBus] cp0Status_cp0_to_mem;
    wire[`RegBus] cp0Cause_cp0_to_mem;
    wire[`RegBus] cp0EPC_cp0_to_mem;
    wire[`RegBus] exceptionType_mem_to_cp0;
    wire[`RegBus] instAddr_mem_to_cp0;
    wire isInDelayslot_mem_to_cp0;
    wire[`RegBus] cp0EPC_mem_to_ctrl;
    
    wire[`InstAddrBus]  pc_cpu_to_bus;
    
    wire enable_bus_to_baseRAM;
    wire writeEnable_bus_to_baseRAM;
    wire[3:0] sel_bus_to_baseRAM;
    wire[`RegBus] data_bus_to_baseRAM;
    wire[`RegBus] addr_bus_to_baseRAM;
    wire[`RegBus] data_baseRAM_to_bus;
    wire rdy_baseRAM_to_bus;
    
    wire enable_bus_to_flash;
    wire writeEnable_bus_to_flash;
    wire[3:0] sel_bus_to_flash;
    wire[`RegBus] data_bus_to_flash;
    wire[`RegBus] addr_bus_to_flash;
    wire[`RegBus] data_flash_to_bus;
    wire rdy_flash_to_bus;


    assign romAddr_o = instAddr_pc_to_if_id;

    PC pc1(
        .clk(clk),
        .rst(rst),
        .instAddr_i(instAddr_pc_adder_to_pc),
        .instAddr_o(instAddr_pc_to_if_id),
        .branchTargetAddr_i(branchTarget_id_to_pc),
        .branchFlag_i(branchFlag_id_to_pc),
        .stall_i(stall_ctrl_to_all),
        .ce_o(romEnable_o),
        .flush_i(flush_ctrl_to_all),
        .newInstAddr_i(newInstAddr_ctrl_to_pc)
    );

    PC_ADDER pc_adder1(
        .rst(rst),
        .instAddr_i(instAddr_pc_to_if_id),
        .instAddr_o(instAddr_pc_adder_to_pc)
    );

    IF_ID if_id1(
        .clk(clk),
        .rst(rst),
        .instAddr_i(instAddr_pc_to_if_id),
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
        .exceptionType_o(exceptionType_id_to_id_ex),
        .instAddr_o(instAddr_id_to_id_ex)
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
        .memAddr_o(memAddr_ex_to_ex_mem),
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
        .memAddr_i(memAddr_ex_to_ex_mem),
        .memAddr_o(memAddr_ex_mem_to_mem),
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
        .memAddr_i(memAddr_ex_mem_to_mem),
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
        .cp0Status_i(cp0Status_cp0_to_mem),
        .cp0Cause_i(cp0Cause_cp0_to_mem),
        .cp0EPC_i(cp0EPC_cp0_to_mem),
        .mem_wb_cp0WriteEnable_i(cp0WriteEnable_mem_wb_to_cp0),
        .mem_wb_cp0WriteAddr_i(cp0WriteAddr_mem_wb_to_cp0),
        .mem_wb_cp0WriteData_i(cp0WriteData_mem_wb_to_cp0),
        .exceptionType_o(exceptionType_mem_to_cp0),
        .instAddr_o(instAddr_mem_to_cp0),
        .isInDelayslot_o(isInDelayslot_mem_to_cp0),
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
        .flush_i(flush_ctrl_to_all)
    );

    CP0 cp01(
        .clk(clk),
        .rst(rst),
        .cp0ReadAddr_i(cp0ReadAddr_ex_to_cp0),
        .cp0WriteEnable_i(cp0WriteEnable_mem_wb_to_cp0),
        .cp0WriteData_i(cp0WriteData_mem_wb_to_cp0),
        .cp0WriteAddr_i(cp0WriteAddr_mem_wb_to_cp0),
        .cp0Data_o(cp0Data_cp0_to_ex),
        .cp0Inte_i(cp0Inte_i),
        .cp0TimerInte_o(cp0TimerInte_o),
        .exceptionType_i(exceptionType_mem_to_cp0),
        .instAddr_i(instAddr_mem_to_cp0),
        .isInDelayslot_i(isInDelayslot_mem_to_cp0),
        .cp0Status_o(cp0Status_cp0_to_mem),
        .cp0Cause_o(cp0Cause_cp0_to_mem),
        .cp0EPC_o(cp0EPC_cp0_to_mem)
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
        .stallReqFromIF_i(stallReqFromIF_id_to_ctrl),
        .stallReqFromID_i(stallReqFromID_id_to_ctrl),
        .stallReqFromEX_i(stallReqFromEX_ex_to_ctrl),
        .stallReqFromMEM_i(stallReqFromMEM_id_to_ctrl),
        .stall_o(stall_ctrl_to_all),
        .cp0EPC_i(cp0EPC_mem_to_ctrl),
        .exceptionType_i(exceptionType_mem_to_cp0),
        .newInstAddr_o(newInstAddr_ctrl_to_pc),
        .flush_o(flush_ctrl_to_all),
        .stallReqFromIF_i(romStallReq_i),
        .stallReqFromMEM_i(ramStallReq_i)
    );
    
    IF_BUS ibus(
    
        .clk(clk),
        .rst(rst),
        
        .stall_i(stall_ctrl_to_all),
        .flush_i(flush_ctrl_to_all),
        
        .cpuEnable_i(romEnable_o),
        .cpuWriteEnable_i(1'b0),
        .cpuSel_i(4'b1111),
        .cpuAddr_i(pc_cpu_to_bus),
        .cpuData_i(32'h00000000),
        .cpuData_o(romData_i),
        
		.stallReq(stallReqFromMEM_id_to_ctrl),
		
		.ramEnable_o(enable_bus_to_baseRAM),
		.ramWriteEnable_o(writeEnable_bus_to_baseRAM),
		.ramData_o(data_bus_to_baseRAM),
		.ramAddr_o(addr_bus_to_baseRAM),
		.ramSel_o(sel_bus_to_baseRAM),
		.ramData_i(data_baseRAM_to_bus),
		.ramRdy_i(rdy_baseRAM_to_bus),
	
		.romEnable_o(enable_bus_to_flash),
		.romWriteEnable_o(writeEnable_bus_to_flash),
		.romData_o(data_bus_to_flash),
		.romAddr_o(addr_bus_to_flash),
		.romSel_o(sel_bus_to_flash),
		.romData_i(data_flash_to_bus),
		.romRdy_i(rdy_flash_to_bus)
		
    );
    
    RAM base_ram(
    
	   .clk_i(clk),
	   .rst_i(rst),
	   
	   .ramEnable_i(enable_bus_to_baseRAM),
	   .ramWriteEnable_i(writeEnable_bus_to_baseRAM),
	   .ramData_i(data_bus_to_baseRAM),
	   .ramAddr_i(addr_bus_to_baseRAM),
	   .ramSel_i(sel_bus_to_baseRAM),
	   .ramData_o(data_baseRAM_to_bus),
	   .ramRdy_o(rdy_baseRAM_to_bus)
	   
	   /*.SRAM_CE_o,
	   .SRAM_OE_o,
	   .SRAM_WE_o,
	   .SRAM_BE_o,
	   .SRAM_Data,
	   .SRAM_Addr_o,*/
    );
    
    ROM flash(
    
	   .clk_i(clk),
	   .rst_i(rst),
	   
	   .romEnable_i(enable_bus_to_flash),
	   .romWriteEnable_i(writeEnable_bus_to_flash),
	   .romData_i(data_bus_to_flash),
	   .romAddr_i(addr_bus_to_flash),
	   .romSel_i(sel_bus_to_flash),
	   .romData_o(data_flash_to_bus),
	   .romRdy_o(rdy_flash_to_bus)
	   
    );
    
    /*WISHBONE_BUS_IF dwishbone_bus_if(
        .clk(clk),
        .rst(rst),
        
        .stall_i(stall_ctrl_to_all),
        .flush_i(flush_ctrl_to_all),
        
        .cpuCE_i(ramEnable_o),
        .cpuData_i(ramData_o),
        .cpuAddr_i(ramAddr_o),
        .cpuWE_i(ramWriteEnable_o),
        .cpuSel_i(ramSel_o),
        .cpu_data_o(ramData_i),
        
        
		.wishboneData_i(dwishboneData_i),
		.wishboneAck_i(dwishboneAck_i),
		.wishboneAddr_o(dwishboneAddr_o),
		.wishboneData_o(dwishboneData_o),
		.wishboneWE_o(dwishboneWE_o),
		.wishboneSel_o(dwishboneSel_o),
		.wishboneStb_o(dwishboneStb_o),
		.wishboneCyc_o(dwishboneCyc_o),

		.stallReq(stallReqFromMEM_id_to_ctrl)
        
    );
    
    WISHBONE_BUS_IF iwishbone_bus_if(
        .clk(clk),
        .rst(rst),
        
        .stall_i(stall_ctrl_to_all),
        .flush_i(flush_ctrl_to_all),
        
        .cpuCE_i(romEnable_o),
        .cpuData_i(32'h00000000),
        .cpuAddr_i(pc),
        .cpuWE_i(1'b0),
        .cpuSel_i(4'b1111),
        .cpu_data_o(romData_i),
        
		.wishboneData_i(iwishboneData_i),
		.wishboneAck_i(iwishboneAck_i),
		.wishboneAddr_o(iwishboneAddr_o),
		.wishboneData_o(iwishboneData_o),
		.wishboneWE_o(iwishboneWE_o),
		.wishboneSel_o(iwishboneSel_o),
		.wishboneStb_o(iwishboneStb_o),
		.wishboneCyc_o(iwishboneCyc_o),

		.stallReq(stallReqFromIF_id_to_ctrl)
        
    );*/

endmodule
