`include "defines.v"

module CPU(
    input wire clk,
    input wire rst,
    input wire[`InstBus] romData_i,
    output wire[`InstAddrBus] romAddr_o,
    output wire romEnable_o,
    
    input wire[`RegBus] ramData_i,
    output wire[`RegBus] ramAddr_o,
    output wire[`RegBus] ramData_o,
    output wire ramWriteEnable_o,
    output wire[3:0] ramSel_o,
    output wire ramEnable_o
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
    wire [1:0] cnt_ex_to_ex_mem;

    wire[`DoubleRegBus] regHILOTemp_ex_mem_to_ex;
    wire [1:0] cnt_ex_mem_to_ex;

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
    wire stallReqFromID_id_to_ctrl;
    wire stallReqFromEX_ex_to_ctrl;

    //EX and DIV
    wire divStart_ex_to_div;
    wire [`RegBus] divOperand1_ex_to_div;
    wire [`RegBus] divOperand2_ex_to_div;
    wire divSigned_ex_to_div;
    wire[`DoubleRegBus] divResult_div_to_ex;
    wire divFinished_div_to_ex;

    CTRL ctrl1(
        .rst(rst),
        .stallReqFromID_i(stallReqFromID_id_to_ctrl), .stallReqFromEX_i(stallReqFromEX_ex_to_ctrl),
        .stall_o(stall_ctrl_to_all)
    );

    PC pc1(
        .clk(clk), .rst(rst),
        .instAddr_i(instAddr_pc_adder_to_pc), .instAddr_o(instAddr_pc_to_if_id),
        .branchTargetAddr_i(branchTarget_id_to_pc), .branchFlag_i(branchFlag_id_to_pc),
        .stall_i(stall_ctrl_to_all),
        .ce_o(romEnable_o)
    );

    assign romAddr_o = instAddr_pc_to_if_id;

    PC_ADDER pc_adder1(
        .rst(rst),
        .instAddr_i(instAddr_pc_to_if_id), .instAddr_o(instAddr_pc_adder_to_pc)
    );

    IF_ID if_id1(
        .clk(clk), .rst(rst),
        .instAddr_i(instAddr_pc_to_if_id), .inst_i(romData_i),
        .instAddr_o(instAddr_if_id_to_id), .inst_o(inst_if_id_to_id),
        .stall_i(stall_ctrl_to_all)
    );

    ID id1(
        .rst(rst),
        .instAddr_i(instAddr_if_id_to_id),   .inst_i(inst_if_id_to_id),
        //from registers
        .reg1Data_i(reg1Data_reg_to_id), .reg2Data_i(reg2Data_reg_to_id),
        //send to registers
        .reg1Enable_o(reg1Enable_id_to_reg), .reg2Enable_o(reg2Enable_id_to_reg),
        .reg1Addr_o(reg1Addr_id_to_reg), .reg2Addr_o(reg2Addr_id_to_reg),
        //send to id/ex
        .aluOp_o(aluOp_id_to_id_ex), .aluSel_o(aluSel_id_to_id_ex),
        .operand1_o(operand1_id_to_id_ex), .operand2_o(operand2_id_to_id_ex),
        .regWriteEnable_o(regWriteEnable_id_to_id_ex), .regWriteAddr_o(regWriteAddr_id_to_id_ex),
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
        .linkAddr_o(linkAddr_id_to_id_ex), .nextInstInDelayslot_o(nextInstInDelayslot_id_to_id_ex),
        .branchTargetAddr_o(branchTarget_id_to_pc), .branchFlag_o(branchFlag_id_to_pc),
        .inst_o(inst_id_to_id_ex),
        .ex_aluOp_i(aluOp_ex_to_ex_mem)
    );

    REG reg1(
        .clk(clk), .rst(rst),
        .reg1Addr_i(reg1Addr_id_to_reg), .reg2Addr_i(reg2Addr_id_to_reg),
        .reg1Enable_i(reg1Enable_id_to_reg), .reg2Enable_i(reg2Enable_id_to_reg),
        .reg1Data_o(reg1Data_reg_to_id), .reg2Data_o(reg2Data_reg_to_id),
        .regWriteAddr_i(regWriteAddr_mem_wb_to_reg), .regWriteData_i(regWriteData_mem_wb_to_reg), .regWriteEnable_i(regWriteEnable_mem_wb_to_reg)
    );

    ID_EX id_ex1(
        .clk(clk), .rst(rst),
        .aluOp_i(aluOp_id_to_id_ex), .aluSel_i(aluSel_id_to_id_ex),
        .operand1_i(operand1_id_to_id_ex), .operand2_i(operand2_id_to_id_ex),
        .regWriteAddr_i(regWriteAddr_id_to_id_ex), .regWriteEnable_i(regWriteEnable_id_to_id_ex),
        .aluOp_o(aluOp_id_ex_to_ex), .aluSel_o(aluSel_id_ex_to_ex),
        .operand1_o(operand1_id_ex_to_ex), .operand2_o(operand2_id_ex_to_ex),
        .regWriteAddr_o(regWriteAddr_id_ex_to_ex), .regWriteEnable_o(regWriteEnable_id_ex_to_ex),
        .stall_i(stall_ctrl_to_all),
        .isInDelayslot_i(isInDelayslot_id_to_id_ex), .linkAddr_i(linkAddr_id_to_id_ex),
        .isInDelayslot_o(isInDelayslot_id_ex_to_ex), .linkAddr_o(linkAddr_id_ex_to_ex),
        .inst_i(inst_id_to_id_ex), .inst_o(inst_id_ex_to_ex),
        .nextInstInDelayslot_i(nextInstInDelayslot_id_to_id_ex), .nextInstInDelayslot_o(isInDelayslot_id_ex_to_id)//P211 port "nextInstInDelayslot_o" of id_ex1 to port "isInDelayslot_i" of id1 , it is not a typo
    );

    EX ex1(
        .rst(rst),
        .aluOp_i(aluOp_id_ex_to_ex), .aluSel_i(aluSel_id_ex_to_ex),
        .operand1_i(operand1_id_ex_to_ex), .operand2_i(operand2_id_ex_to_ex),
        .regWriteAddr_i(regWriteAddr_id_ex_to_ex), .regWriteEnable_i(regWriteEnable_id_ex_to_ex),
        .regWriteAddr_o(regWriteAddr_ex_to_ex_mem), .regWriteData_o(regWriteData_ex_to_ex_mem),
        .regWriteEnable_o(regWriteEnable_ex_to_ex_mem),

        .mem_regHILOEnable_i(regHILOEnable_mem_to_mem_wb), .mem_regHI_i(regHI_mem_to_mem_wb), .mem_regLO_i(regLO_mem_to_mem_wb),
        .mem_wb_regHILOEnable_i(regHILOEnable_mem_wb_to_hilo), .mem_wb_regHI_i(regHI_mem_wb_to_hilo), .mem_wb_regLO_i(regLO_mem_wb_to_hilo),

        //from hilo
        .regHI_i(regHI_hilo_to_ex), .regLO_i(regLO_hilo_to_ex),

        .regHILOEnable_o(regHILOEnable_ex_to_ex_mem), .regHI_o(regHI_ex_to_ex_mem), .regLO_o(regLO_ex_to_ex_mem),

        .regHILOTemp_i(regHILOTemp_ex_mem_to_ex), .cnt_i(cnt_ex_mem_to_ex),
        .regHILOTemp_o(regHILOTemp_ex_to_ex_mem), .cnt_o(cnt_ex_to_ex_mem),

        .divResult_i(divResult_div_to_ex), .divFinished_i(divFinished_div_to_ex),
        .divStart_o(divStart_ex_to_div), .divSigned_o(divSigned_ex_to_div),
        .divOperand1_o(divOperand1_ex_to_div), .divOperand2_o(divOperand2_ex_to_div),
        .isInDelayslot_i(isInDelayslot_id_ex_to_ex), .linkAddr_i(linkAddr_id_ex_to_ex),
        .stallReq_o(stallReqFromEX_ex_to_ctrl),
        .inst_i(inst_id_ex_to_ex),
        .aluOp_o(aluOp_ex_to_ex_mem),
        .memAddr_o(memAddr_ex_to_ex_mem),
        .operand2_o(operand2_ex_to_ex_mem)
    );

    EX_MEM ex_mem1(
        .clk(clk), .rst(rst),
        .regWriteAddr_i(regWriteAddr_ex_to_ex_mem), .regWriteEnable_i(regWriteEnable_ex_to_ex_mem), .regWriteData_i(regWriteData_ex_to_ex_mem),
        .regWriteAddr_o(regWriteAddr_ex_mem_to_mem), .regWriteEnable_o(regWriteEnable_ex_mem_to_mem), .regWriteData_o(regWriteData_ex_mem_to_mem),
        //ex to ex_mem
        .regHILOEnable_i(regHILOEnable_ex_to_ex_mem), .regHI_i(regHI_ex_to_ex_mem),
        .regLO_i(regLO_ex_to_ex_mem),
        //ex_mem_to mem
        .regHILOEnable_o(regHILOEnable_ex_mem_to_mem), .regHI_o(regHI_ex_mem_to_mem),
        .regLO_o(regLO_ex_mem_to_mem),
        .regHILOTemp_i(regHILOTemp_ex_to_ex_mem), .cnt_i(cnt_ex_to_ex_mem),
        .regHILOTemp_o(regHILOTemp_ex_mem_to_ex), .cnt_o(cnt_ex_mem_to_ex),
        .stall_i(stall_ctrl_to_all),
        .aluOp_i(aluOp_ex_to_ex_mem), .aluOp_o(aluOp_ex_mem_to_mem),
        .memAddr_i(memAddr_ex_to_ex_mem), .memAddr_o(memAddr_ex_mem_to_mem),
        .operand2_i(operand2_ex_to_ex_mem), .operand2_o(operand2_ex_mem_to_mem)
    );

    MEM mem1(
        .rst(rst),
        .regWriteAddr_i(regWriteAddr_ex_mem_to_mem), .regWriteEnable_i(regWriteEnable_ex_mem_to_mem), .regWriteData_i(regWriteData_ex_mem_to_mem),
        .regWriteAddr_o(regWriteAddr_mem_to_mem_wb), .regWriteEnable_o(regWriteEnable_mem_to_mem_wb), .regWriteData_o(regWriteData_mem_to_mem_wb),
        //ex_mem to mem hilo
        .regHILOEnable_i(regHILOEnable_ex_mem_to_mem), .regHI_i(regHI_ex_mem_to_mem),
        .regLO_i(regLO_ex_mem_to_mem),
        //mem to mem_wb hilo
        .regHILOEnable_o(regHILOEnable_mem_to_mem_wb), .regHI_o(regHI_mem_to_mem_wb),
        .regLO_o(regLO_mem_to_mem_wb),
        .memData_i(ramData_i),
        .aluOp_i(aluOp_ex_mem_to_mem),
        .memAddr_i(memAddr_ex_mem_to_mem),
        .operand2_i(operand2_ex_mem_to_mem),
        .memAddr_o(ramAddr_o),
        .memWriteEnable_o(ramWriteEnable_o),
        .memSel_o(ramSel_o),
        .memData_o(ramData_o),
        .memEnable_o(ramEnable_o)
    );

    MEM_WB mem_wb1 (
        .clk(clk), .rst(rst),
        .regWriteAddr_i(regWriteAddr_mem_to_mem_wb), .regWriteEnable_i(regWriteEnable_mem_to_mem_wb), .regWriteData_i(regWriteData_mem_to_mem_wb),
        .regWriteAddr_o(regWriteAddr_mem_wb_to_reg), .regWriteEnable_o(regWriteEnable_mem_wb_to_reg), .regWriteData_o(regWriteData_mem_wb_to_reg),
        //mem to mem_wb
        .regHILOEnable_i(regHILOEnable_mem_to_mem_wb), .regHI_i(regHI_mem_to_mem_wb),
        .regLO_i(regLO_mem_to_mem_wb),
        //mem_wb to hilo
        .regHILOEnable_o(regHILOEnable_mem_wb_to_hilo), .regHI_o(regHI_mem_wb_to_hilo),
        .regLO_o(regLO_mem_wb_to_hilo),
        .stall_i(stall_ctrl_to_all)
    );

    HILO hilo1 (
        .clk(clk), .rst(rst),
        .regHILOEnable_i(regHILOEnable_mem_wb_to_hilo), .regHI_i(regHI_mem_wb_to_hilo), .regLO_i(regLO_mem_wb_to_hilo),
        .regHI_o(regHI_hilo_to_ex), .regLO_o(regLO_hilo_to_ex)
    );
    DIV div1(
        .rst(rst), .clk(clk),
        .signed_div_i(divSigned_ex_to_div),
        .operand1_i(divOperand1_ex_to_div), .operand2_i(divOperand2_ex_to_div),
        .start_i(divStart_ex_to_div), .annul_i(1'b0),
        .quotient_o(divResult_div_to_ex), .finished_o(divFinished_div_to_ex)
    );

endmodule
