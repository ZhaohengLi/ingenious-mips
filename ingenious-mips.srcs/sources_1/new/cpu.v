`include "defines.v"

module CPU(
    input wire clk,
    input wire rst,
    
    input wire[`InstBus] romData_i,
    output wire[`InstAddrBus] romAddr_o,
    output wire romEnable_o

);
 
    //PIPELINE START
     
    //pcadder
    wire [31:0] adder_pc_in;
    
    //if id
    wire [31:0] if_inst_Addr_i;
    wire [31:0] id_inst_Addr_i;
    wire [31:0] id_inst_i;
    
    //IDregister
    wire [7:0] id_aluOp_o;
    wire [2:0] id_aluSel_o;
    wire [31:0] id_operand1_o;
    wire [31:0] id_operand2_o;
    wire [4:0] id_regWriteAddr_o; //target register's address
    wire id_regWritEnablee_o;
    
    //ID-EX
    wire [2:0] ex_aluSel_i;
    wire [7:0] ex_aluOp_i;
    wire [31:0] ex_operand1_i;
    wire [31:0] ex_operand2_i;
    wire [4:0] ex_regWriteAddr_i;
    wire ex_regWriteEnable_i;
    
    //EX
    wire ex_regWriteEnable_o;
    wire [31:0] ex_regWriteData_o;
    wire [4:0] ex_regWriteAddr_o;
    
     //exmem
     wire mem_regWriteEnable_i;
     wire [31:0] mem_regWriteData_i;
     wire [4:0] mem_regWriteAddr_i;
    
     //mem
     wire mem_regWriteEnable_o;
     wire [31:0] mem_regWriteData_o;
     wire [4:0] mem_regWriteAddr_o;
    
     //memwb
     wire wb_regWriteEnable_i;
     wire [31:0] wb_regWriteData_i;
     wire [4:0] wb_regWriteAddr_i;
    
     //register.v
     wire enread1; //enable read1
     wire enread2;
     wire [31:0] reg_data1_i;
     wire [31:0] reg_data2_i;
     wire [4:0] reg1_Addr_i;
     wire [4:0] reg2_Addr_i;
    

     PC pc1(
         .clk(clock_btn),  .rst(reset_btn),
         .instAddr_i(if_inst_Addr_i), 
         .instAddr_o(adder_pc_in), .ce_o(romEnable_o)
     );
     //pcadder.v
     PC_ADDER pc_adder1(
         .pc_in(adder_pc_in), .pc_out(if_inst_Addr_i)
     );
     
     assign romAddr_o = if_inst_Addr_i;
    
     //ifid
     IF_ID if_id1(
         .clk(clock_btn),  .rst(reset_btn),
         .instAddr_i(if_inst_Addr_i), .inst_i(romData_i),
         .instAddr_o(id_inst_Addr_i), .inst_o(id_inst_i)
     );
    
     //IDRegister
     ID id1(
         .rst(reset_btn),  .instAddr_i(id_inst_Addr_i),
         .inst_i(id_inst_i),
         //from registers
         .reg1Data_i(reg_data1_i), .reg2Data_i(reg_data2_i),
         //send to registers
         .reg1Enable_o(enread1), .reg2Enable_o(enread2),
         .reg1Addr_o(reg1_Addr_i), .reg2Addr_o(reg2_Addr_i),
         //send to id/ex
         .aluOp_o(id_aluOp_o), .aluSel_o(id_aluSel_o),
         .operand1_o(id_operand1_o), .operand2_o(id_operand2_o),
         .regWriteEnable_o(id_regWritEnablee_o), .regWriteAddr_o(id_regWriteAddr_o)
     );
    
     //Registers
     REG reg1(
         .clk(clock_btn), .rst(reset_btn),
         .regWriteEnable_i(wb_regWriteData_i), .regWriteAddr_i(wb_regWriteAddr_i),
         .regWriteData_i(wb_regWriteData_i), .reg1Enable_i(enread1),
         .reg1Addr_i(reg1_Addr_i), .reg1Data_o(reg_data1_i),
         .reg2Enable_i(enread2), .reg2Addr_i(reg2_Addr_i),
         .reg2Data_o(reg_data2_i)
     );
    
     //ID/EX
     ID_EX id_ex1(
         .clk(clock_btn), .rst(reset_btn),
    
         .aluSel_i(id_aluSel_o), .aluOp_i(id_aluOp_o),
         .operand1_i(id_operand1_o), .operand2_i(id_operand2_o),
         .regWriteAddr_i(id_regWriteAddr_o), .regWriteEnable_i(id_regWritEnablee_o),
    
         .aluSel_o(ex_aluSel_i), .aluOp_o(ex_aluOp_i),
         .operand1_o(ex_operand1_i), .operand2_o(ex_operand2_i),
         .regWriteAddr_o(ex_regWriteAddr_i), .regWriteEnable_o(ex_regWriteEnable_i)
     );
    
     //ex
     EX ex1(
         .rst(reset_btn),  .aluSel_i(ex_aluSel_i),
         .aluOp_i(ex_aluOp_i), .operand1_i(ex_operand1_i),
         .operand2_i(ex_operand2_i), .regWriteAddr_i(ex_regWriteAddr_i),
         .regWriteEnable_i(ex_regWriteEnable_i),
         .regWriteEnable_o(ex_regWriteEnable_o), .regWriteAddr_o(ex_regWriteAddr_o),
         .regWriteData_o(ex_regWriteData_o)
    
     );
    
     //exmem
     EX_MEM ex_mem1(
         .rst(reset_btn), .clk(clock_btn),
         .regWriteAddr_i(ex_regWriteAddr_o), .regWriteEnable_i(ex_regWriteEnable_o),
         .regWriteData_i(ex_regWriteData_o), .regWriteAddr_o(mem_regWriteAddr_i),
         .regWriteEnable_o(mem_regWriteEnable_i), .regWriteData_o(mem_regWriteData_i)
     );
    
     //mem
     MEM mem1(
         .rst(reset_btn), .regWriteAddr_i(mem_regWriteAddr_i),
         .regWriteEnable_i(mem_regWriteEnable_i), .regWriteData_i(mem_regWriteData_i),
         .regWriteAddr_o(mem_regWriteAddr_o),   .regWriteEnable_o(mem_regWriteEnable_o),
         .regWriteData_o(mem_regWriteData_o)
     );
    
     //memwb
     MEM_WB mem_wb1(
         .rst(reset_btn), .clk(clock_btn),
         .regWriteAddr_i(mem_regWriteAddr_o), .regWriteEnable_i(mem_regWriteEnable_o),
         .regWriteData_i(mem_regWriteData_o), .regWriteAddr_o(wb_regWriteAddr_i),
         .regWriteEnable_o(wb_regWriteEnable_i), .regWriteData_o(wb_regWriteData_i)
     );
     //PIPELINE END

endmodule