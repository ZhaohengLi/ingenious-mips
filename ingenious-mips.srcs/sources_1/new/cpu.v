`include "defines.v"

module CPU(
    input wire clk,
    input wire rst,
    
    input wire[`InstBus] romData_i,
    output wire[`InstAddrBus] romAddr_o,
    output wire romEnable_o

);
    // PC & PC_ADDER & IF_ID
    wire[`InstAddrBus] instAddr_pc_adder_to_pc;
    wire[`InstAddrBus] instAddr_pc_to_if_id;
    
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
    
    wire regWriteEnable_id_to_id_ex;
    wire[`RegAddrBus] regWriteAddr_id_to_id_ex;
    
    // ID_EX & EX & EX_MEM
    
    wire[`AluOpBus] aluOp_id_ex_to_ex;
    wire[`AluSelBus] aluSel_id_ex_to_ex;
    wire[`RegBus] operand1_id_ex_to_ex;
    wire[`RegBus] operand2_id_ex_to_ex;
    wire[`RegAddrBus] regWriteAddr_id_ex_to_ex;
    wire regWriteEnable_id_ex_to_ex;
    
    wire[`RegAddrBus] regWriteAddr_ex_to_ex_mem;
    wire regWriteEnable_ex_to_ex_mem;
    wire[`RegBus] regWriteData_ex_to_ex_mem;
    
    wire regHILOEnable_ex_to_ex_mem;
    wire[`RegBus] regHI_ex_to_ex_mem;
    wire[`RegBus] regLO_ex_to_ex_mem;
        
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
    
    // MEM_WB & REG
    
    wire[`RegAddrBus] regWriteAddr_mem_wb_to_reg;
    wire regWriteEnable_mem_wb_to_reg;
    wire[`RegBus] regWriteData_mem_wb_to_reg;
    wire regHILOEnable_mem_to_mem_wb;
    wire[`RegBus] regHI_mem_to_mem_wb;
    wire[`RegBus] regLO_mem_to_mem_wb;
    
    //MEM_WB to HILO
    wire regHILOEnable_mem_wb_to_hilo;
    wire[`RegBus] regHI_mem_wb_to_hilo;
    wire[`RegBus] regLO_mem_wb_to_hilo;
    
    
    PC pc1(
        .clk(clk), .rst(rst),
        .instAddr_i(instAddr_pc_adder_to_pc), .instAddr_o(instAddr_pc_to_if_id),
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
        .instAddr_o(instAddr_if_id_to_id), .inst_o(inst_if_id_to_id)
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
        .ex_regWriteData_i(regWriteData_ex_to_ex_mem), .ex_regWriteAddr_i(regWriteAddr_ex_to_ex_mem),
        .ex_regWriteEnable_i(regWriteEnable_ex_to_ex_mem), .mem_regWriteData_i(regWriteData_mem_to_mem_wb),
        .mem_regWriteAddr_i(regWriteAddr_mem_to_mem_wb), .mem_regWriteEnable_i(regWriteEnable_mem_to_mem_wb)
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
        .regWriteAddr_o(regWriteAddr_id_ex_to_ex), .regWriteEnable_o(regWriteEnable_id_ex_to_ex)
        
        
    );
    
    EX ex1(
        .rst(rst),
        .aluOp_i(aluOp_id_ex_to_ex), .aluSel_i(aluSel_id_ex_to_ex),
        .operand1_i(operand1_id_ex_to_ex), .operand2_i(operand2_id_ex_to_ex),
        .regWriteAddr_i(regWriteAddr_id_ex_to_ex), .regWriteEnable_i(regWriteEnable_id_ex_to_ex),
        .regWriteAddr_o(regWriteAddr_ex_to_ex_mem), .regWriteData_o(regWriteData_ex_to_ex_mem),
        .regWriteEnable_o(regWriteEnable_ex_to_ex_mem),
        
        .mem_regHILOEnable_i(regHILOEnable_mem_to_mem_wb), .mem_regHI_i(regHI_mem_to_mem_wb),
        .mem_regLO_i(regLO_mem_to_mem_wb),
        .mem_wb_regHILOEnable_i(regHILOEnable_mem_wb_to_hilo), .mem_wb_regHI_i(regHI_mem_wb_to_hilo),
        .mem_wb_regLO_i(regLO_mem_wb_to_hilo),
        
        //from hilo
        .regHI_i(), .regLO_i();
        
        .regHILOEnable_o(regHILOEnable_ex_to_ex_mem), .regHI_o(regHI_ex_to_ex_mem),
        .regLO_o(regLO_ex_to_ex_mem)
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
        .regLO_o(regLO_ex_mem_to_mem)
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
        .regLO_o(regLO_mem_to_mem_wb)
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
        .regLO_o(regLO_mem_wb_to_hilo)
    );
    
endmodule