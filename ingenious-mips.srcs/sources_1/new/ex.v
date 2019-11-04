`include "defines.v"

module EX(
	input wire rst,
    
    input wire[`RegBus] inst_i,
    input wire[`AluOpBus] aluOp_i,
	input wire[`AluSelBus] aluSel_i,
	input wire[`RegBus] operand1_i,
	input wire[`RegBus] operand2_i,
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire regWriteEnable_i,

	input wire[`RegBus] regHI_i,
	input wire[`RegBus] regLO_i,

	input wire mem_regHILOEnable_i,
	input wire[`RegBus] mem_regHI_i,
	input wire[`RegBus] mem_regLO_i,

	input wire mem_wb_regHILOEnable_i,
	input wire[`RegBus] mem_wb_regHI_i,
	input wire[`RegBus] mem_wb_regLO_i,

	input wire[`DoubleRegBus] regHILOTemp_i,
	input wire[1:0] cnt_i,
	output reg[`DoubleRegBus] regHILOTemp_o,
	output reg[1:0] cnt_o,

    input wire[`DoubleRegBus] divResult_i,
    input wire divFinished_i,

    input wire isInDelayslot_i,
    input wire[`RegBus] linkAddr_i,
    
    output wire[`AluOpBus] aluOp_o,
    output wire[`RegBus] memAddr_o, //mem_addr_o
    output wire[`RegBus] operand2_o, //reg2_o
    
	output reg[`RegAddrBus] regWriteAddr_o,
	output reg regWriteEnable_o,
	output reg[`RegBus] regWriteData_o,

	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o,

	output reg divStart_o,
	output reg[`RegBus] divOperand1_o,
	output reg[`RegBus] divOperand2_o,
	output reg divSigned_o,

	output reg stallReq_o,
	
	input wire mem_cp0WriteEnable_i,
	input wire[4:0] mem_cp0WriteAddr_i,
	input wire[`RegBus] mem_cp0WriteData_i,
	
	input wire mem_wb_cp0WriteEnable_i,
	input wire[4:0] mem_wb_cp0WriteAddr_i,
	input wire[`RegBus] mem_wb_cp0WriteData_i,
	
	input wire[`RegBus] cp0Data_i,
	output reg[4:0] cp0ReadAddr_o,
	
	output reg cp0WriteEnable_o,
	output reg[4:0] cp0WriteAddr_o,
	output reg[`RegBus] cp0WriteData_o
);
    
    assign aluOp_o = aluOp_i;
    assign memAddr_o = operand1_i + {{16{inst_i[15]}}, {inst_i[15:0]}};
    assign operand2_o = operand2_i;
    
    //assign stallReq_o = `NoStop;
    reg stallReq_div;

    reg[`RegBus] logic_out;
    reg[`RegBus] shift_res;
    reg[`RegBus] move_res;
    reg[`RegBus] hi; // latest value of reg hi
    reg[`RegBus] lo; // latest value of reg lo

    wire overflow; //ov_sum
    wire operand1_eq_operand2; //reg1_eq_reg2
    wire operand1_lt_operand2; //reg1_lt_reg2
    reg[`RegBus] arithmetic_res; //arithmeticres
    wire[`RegBus] operand2_twos; // reg2_i_mux
    wire[`RegBus] operand1_not; // reg1_i_not
    wire[`RegBus] sum_res; //result_sum
    wire[`RegBus] mult1; //opdata1_mult
    wire[`RegBus] mult2; //opdata2_mult
    wire[`DoubleRegBus] hilo_res; //hilo_temp
    reg[`DoubleRegBus] hilo_res1; //hilo_temp1
    reg madd_msub_stallreq;
    reg[`DoubleRegBus] mul_res; //mulres

    assign operand2_twos = ((aluOp_i == `EXE_SUB_OP)||(aluOp_i == `EXE_SUBU_OP)||(aluOp_i == `EXE_SLT_OP)) ? (~operand2_i)+1 : operand2_i ;
    assign sum_res = operand1_i + operand2_twos;
    assign overflow = ((!operand1_i[31] && !operand2_twos[31]) && sum_res[31]) || ((operand1_i[31] && operand2_twos[31]) && (!sum_res[31]));
    assign operand1_lt_operand2 = (aluOp_i == `EXE_SLT_OP) ?
                                  ((operand1_i[31] && !operand2_i[31])||(!operand1_i[31] && !operand2_i[31] && sum_res[31])||(operand1_i[31] && operand2_i[31] && sum_res[31])) :
                                  (operand1_i < operand2_i) ;
    assign operand1_not = ~operand1_i;
//    assign mult1 = (((aluOp_i == `EXE_MUL_OP)|| (aluOp_i == `EXE_MULT_OP) ||(aluOp_i == `EXE_MADD_OP) || (aluOp_i == `EXE_MSUB_OP)) &&
//                (operand1_i[31] == 1'b1)) ? (~operand1_i + 1): operand1_i;
//    assign mult2 = (((aluOp_i == `EXE_MUL_OP)|| (aluOp_i == `EXE_MULT_OP) ||(aluOp_i == `EXE_MADD_OP) || (aluOp_i == `EXE_MSUB_OP)) &&
//                (operand2_i[31] == 1'b1)) ? (~operand2_i + 1): operand2_i;
//    assign hilo_res = mult1 * mult2;
    // set arithmetic_res
    
    always @ (*) begin
        if( rst==`Enable ) begin
            arithmetic_res <= `ZeroWord;
        end else begin
            case (aluOp_i)
                `EXE_SLT_OP, `EXE_SLTU_OP: begin
                    arithmetic_res <= operand1_lt_operand2;
                end
                `EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP: begin
                    arithmetic_res <= sum_res;
                end
                `EXE_SUB_OP, `EXE_SUBU_OP: begin
                    arithmetic_res <= sum_res;
                end
                `EXE_CLZ_OP: begin
                    arithmetic_res <= operand1_i[31] ? 0 :
                                      operand1_i[30] ? 1 :
                                      operand1_i[29] ? 2 :
                                      operand1_i[28] ? 3 :
                                      operand1_i[27] ? 4 :
                                      operand1_i[26] ? 5 :
                                      operand1_i[25] ? 6 :
                                      operand1_i[24] ? 7 :
                                      operand1_i[23] ? 8 :
                                      operand1_i[22] ? 9 :
                                      operand1_i[21] ? 10 :
                                      operand1_i[20] ? 11 :
                                      operand1_i[19] ? 12 :
                                      operand1_i[18] ? 13 :
                                      operand1_i[17] ? 14 :
                                      operand1_i[16] ? 15 :
                                      operand1_i[15] ? 16 :
                                      operand1_i[14] ? 17 :
                                      operand1_i[13] ? 18 :
                                      operand1_i[12] ? 19 :
                                      operand1_i[11] ? 20 :
                                      operand1_i[10] ? 21 :
                                      operand1_i[9] ? 22 :
                                      operand1_i[8] ? 23 :
                                      operand1_i[7] ? 24 :
                                      operand1_i[6] ? 25 :
                                      operand1_i[5] ? 26 :
                                      operand1_i[4] ? 27 :
                                      operand1_i[3] ? 28 :
                                      operand1_i[2] ? 29 :
                                      operand1_i[1] ? 30 :
                                      operand1_i[0] ? 31 :
                                      32 ;
                end
                `EXE_CLO_OP: begin
                    arithmetic_res <= operand1_not[31] ? 0 :
                                      operand1_not[30] ? 1 :
                                      operand1_not[29] ? 2 :
                                      operand1_not[28] ? 3 :
                                      operand1_not[27] ? 4 :
                                      operand1_not[26] ? 5 :
                                      operand1_not[25] ? 6 :
                                      operand1_not[24] ? 7 :
                                      operand1_not[23] ? 8 :
                                      operand1_not[22] ? 9 :
                                      operand1_not[21] ? 10 :
                                      operand1_not[20] ? 11 :
                                      operand1_not[19] ? 12 :
                                      operand1_not[18] ? 13 :
                                      operand1_not[17] ? 14 :
                                      operand1_not[16] ? 15 :
                                      operand1_not[15] ? 16 :
                                      operand1_not[14] ? 17 :
                                      operand1_not[13] ? 18 :
                                      operand1_not[12] ? 19 :
                                      operand1_not[11] ? 20 :
                                      operand1_not[10] ? 21 :
                                      operand1_not[9] ? 22 :
                                      operand1_not[8] ? 23 :
                                      operand1_not[7] ? 24 :
                                      operand1_not[6] ? 25 :
                                      operand1_not[5] ? 26 :
                                      operand1_not[4] ? 27 :
                                      operand1_not[3] ? 28 :
                                      operand1_not[2] ? 29 :
                                      operand1_not[1] ? 30 :
                                      operand1_not[0] ? 31 :
                                      32 ;
                end
                default: begin
                    arithmetic_res <= `ZeroWord;
                end
            endcase
        end
    end

    assign mult1 = (((aluOp_i == `EXE_MUL_OP)||(aluOp_i == `EXE_MULT_OP)|| (aluOp_i == `EXE_MADD_OP) || (aluOp_i == `EXE_MSUB_OP)) && (operand1_i[31])) ? (~operand1_i+1) : operand1_i ;
    assign mult2 = (((aluOp_i == `EXE_MUL_OP)||(aluOp_i == `EXE_MULT_OP)|| (aluOp_i == `EXE_MADD_OP) || (aluOp_i == `EXE_MSUB_OP)) && (operand2_i[31])) ? (~operand2_i+1) : operand2_i ;

    assign hilo_res = mult1 * mult2;

    // set mul_res
    always @ (*) begin
        if (rst == `Enable) begin
            mul_res <= {`ZeroWord, `ZeroWord};
        end else if ((aluOp_i == `EXE_MULT_OP)||(aluOp_i == `EXE_MUL_OP) || (aluOp_i == `EXE_MADD_OP) || (aluOp_i == `EXE_MSUB_OP)) begin
            if (operand1_i[31] ^ operand2_i[31]) begin
                mul_res <= ~hilo_res+1;
            end else begin
                mul_res <= hilo_res;
            end
        end else begin
            mul_res <= hilo_res;
        end
    end
    //madd, maddu, msub, msubu
    always @ (*) begin
        if (rst == `Enable) begin
            regHILOTemp_o <= {`ZeroWord, `ZeroWord};
            cnt_o <= 2'b00;
            madd_msub_stallreq <= `NoStop;
        end else begin
            case(aluOp_i)
                `EXE_MADD_OP, `EXE_MADDU_OP: begin
                    if(cnt_i == 2'b00) begin
                        regHILOTemp_o <= mul_res;
                        cnt_o <= 2'b01;
                        hilo_res1 <= {`ZeroWord, `ZeroWord};
                        madd_msub_stallreq <= `Stop;
                    end else if (cnt_i == 2'b01) begin
                        regHILOTemp_o <= {`ZeroWord, `ZeroWord};
                        cnt_o <= 2'b10;
                        hilo_res1 <= regHILOTemp_i + {hi, lo};
                        madd_msub_stallreq <= `NoStop;
                    end
                end
                `EXE_MSUB_OP, `EXE_MSUBU_OP: begin
                    if(cnt_i == 2'b00) begin
                        regHILOTemp_o <= ~mul_res + 1;
                        cnt_o <= 2'b01;
                        madd_msub_stallreq <= `Stop;
                    end else if(2'b01) begin
                        regHILOTemp_o <= {`ZeroWord, `ZeroWord};
                        cnt_o <= 2'b10;
                        hilo_res1 <= regHILOTemp_i + {hi, lo};
                        madd_msub_stallreq <= `NoStop;
                    end
                end
                default: begin
                    regHILOTemp_o <= {`ZeroWord, `ZeroWord};
                    cnt_o <= 2'b00;
                    madd_msub_stallreq <= `NoStop;
                end
            endcase
        end// if
    end //always
    //div
    always @ (*) begin
        if(rst ==`Enable) begin
            stallReq_div <= `NoStop;
            divOperand1_o <= `ZeroWord;
            divOperand2_o <= `ZeroWord;
            divStart_o <= `DivStop;
            divSigned_o <= 1'b0;
        end else begin
            stallReq_div <= `NoStop;
            divOperand1_o <= `ZeroWord;
            divOperand2_o <= `ZeroWord;
            divStart_o <= `DivStop;
            divSigned_o <= 1'b0;
            case(aluOp_i)
                `EXE_DIV_OP: begin
                    if (divFinished_i == `DivResultNotReady) begin
                        divOperand1_o <= operand1_i;
                        divOperand2_o <= operand2_i;
                        divStart_o <= `DivStart;
                        divSigned_o <= 1'b1;
                        stallReq_div <= `Stop;
                    end else if(divFinished_i == `DivResultReady) begin
                        divOperand1_o <= operand1_i;
                        divOperand2_o <= operand2_i;
                        divStart_o <= `DivStop;
                        divSigned_o <= 1'b1;
                        stallReq_div <= `NoStop;
                    end else begin
                        divOperand1_o <= `ZeroWord;
                        divOperand2_o <= `ZeroWord;
                        divStart_o <= `DivStop;
                        divSigned_o <= 1'b0;
                        stallReq_div <= `NoStop;
                    end
                end
                `EXE_DIVU_OP: begin
                    if(divFinished_i == `DivResultNotReady) begin
                        divOperand1_o <= operand1_i;
                        divOperand2_o <= operand2_i;
                        divStart_o <= `DivStart;
                        divSigned_o <= 1'b0;
                        stallReq_div <= `Stop;
                    end else if (divFinished_i == `DivResultReady) begin
                        divOperand1_o <= operand1_i;
                        divOperand2_o <= operand2_i;
                        divStart_o <= `DivStop;
                        divSigned_o <= 1'b0;
                        stallReq_div <= `NoStop;
                    end else begin
                        divOperand1_o <= `ZeroWord;
                        divOperand2_o <= `ZeroWord;
                        divStart_o <= `DivStop;
                        divSigned_o <= 1'b0;
                        stallReq_div <= `NoStop;
                    end
                end
            endcase
        end
    end

    //set stallReq_o
    always @ (*) begin
        stallReq_o <= madd_msub_stallreq || stallReq_div;
    end//always
    // set the latest value of reg hi & lo
    always @ (*) begin
        if (rst == `Enable) begin
            hi <= `ZeroWord;
            lo <= `ZeroWord;
        end else if (mem_regHILOEnable_i == `Enable) begin
            hi <= mem_regHI_i;
            lo <= mem_regLO_i;
        end else if (mem_wb_regHILOEnable_i == `Enable) begin
            hi <= mem_wb_regHI_i;
            lo <= mem_wb_regLO_i;
        end else begin
            hi <= regHI_i;
            lo <= regLO_i;
        end
    end

    // set move_res
    always @ (*) begin
        if (rst == `Enable) begin
            move_res <= `ZeroWord;
        end else begin
            move_res <= `ZeroWord;
            case (aluOp_i)
                `EXE_MFHI_OP: begin
                    move_res <= hi;
                end
                `EXE_MFLO_OP: begin
                    move_res <= lo;
                end
                `EXE_MOVZ_OP: begin
                    move_res <= operand1_i;
                end
                `EXE_MOVN_OP: begin
                    move_res <= operand1_i;
                end
                `EXE_MFC0_OP: begin
                    cp0ReadAddr_o <= inst_i[15:11];
                    move_res <= cp0Data_i;
                    if(mem_cp0WriteEnable_i == `Enable && mem_cp0WriteAddr_i == inst_i[15:11]) begin
                        move_res <= mem_cp0WriteData_i;
                    end else if(mem_wb_cp0WriteEnable_i == `Enable && mem_wb_cp0WriteAddr_i == inst_i[15:11]) begin
                        move_res <= mem_wb_cp0WriteData_i;
                    end
                end
                default: begin
                end
            endcase
        end
    end

    // set regHI_o regLO_o regHILOEnable_o
    always @ (*) begin
        if (rst == `Enable) begin
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
        end else if((aluOp_i == `EXE_MSUB_OP ) || (aluOp_i == `EXE_MSUBU_OP)) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= hilo_res1[63:32];
            regLO_o <= hilo_res1[31:0];
        end else if((aluOp_i == `EXE_MADD_OP) || (aluOp_i == `EXE_MADDU_OP)) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= hilo_res1[63:32];
            regLO_o <= hilo_res1[31:0];
        end else if ((aluOp_i == `EXE_MULT_OP) || (aluOp_i == `EXE_MULTU_OP)) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= mul_res[63:32];
            regLO_o <= mul_res[31:0];
        end else if (aluOp_i == `EXE_MTHI_OP) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= operand1_i;
            regLO_o <= lo;
        end else if (aluOp_i == `EXE_MTLO_OP) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= hi;
            regLO_o <= operand1_i;
        end else if((aluOp_i == `EXE_DIV_OP) || (aluOp_i == `EXE_DIVU_OP)) begin
            regHILOEnable_o <= `Enable;
            regHI_o <= divResult_i[63:32];
            regLO_o <= divResult_i[31:0];
        end else begin
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
        end
    end

    // set logic_out
    always @ (*) begin
        if (rst == `Enable) begin //set logic output to zero
            logic_out <= `ZeroWord;
        end else begin
            case(aluOp_i)
                `EXE_OR_OP: begin
                    logic_out <= operand1_i | operand2_i;
                end //exe_or_op
                `EXE_AND_OP:begin
                    logic_out <= operand1_i & operand2_i;
                end
                `EXE_NOR_OP: begin
                    logic_out <= ~(operand1_i | operand2_i);
                end
                `EXE_XOR_OP:begin
                    logic_out <= operand1_i ^ operand2_i;
                end
                default: begin
                    logic_out <= `ZeroWord;
                end //default

            endcase
        end //if
    end //always


    // set shift_res
    always @(*) begin
        if(rst == `Enable) begin
            shift_res <= `ZeroWord;
        end else begin
            case(aluOp_i)
                `EXE_SLL_OP: begin
                    shift_res <= operand2_i << operand1_i[4:0];
                end
                `EXE_SRL_OP: begin
                    shift_res <= operand2_i >> operand1_i[4:0];
                end
                `EXE_SRA_OP: begin // operand2 >> operand1[4:0]
                    shift_res <= ({32{operand2_i[31]}} << (6'd32 - {1'b0, operand1_i[4:0]}))| operand2_i >> operand1_i[4:0];
                end
                default: begin
                    shift_res <= `ZeroWord;
                end
            endcase
        end//if
    end

    // set regWriteData_o
    always @(*) begin
        regWriteEnable_o <= regWriteEnable_i;
        if (((aluOp_i == `EXE_ADD_OP) || (aluOp_i == `EXE_ADDI_OP) || (aluOp_i == `EXE_SUB_OP)) && overflow) begin
            regWriteEnable_o <= `Disable;
        end else begin
            regWriteAddr_o <= regWriteAddr_i;
        end
        case(aluSel_i)
            `EXE_RES_LOGIC: begin
                regWriteData_o <= logic_out; //write out the logic operation result
            end
            `EXE_RES_SHIFT: begin
                regWriteData_o <= shift_res;
            end
            `EXE_RES_MOVE: begin
                regWriteData_o <= move_res;
            end
            `EXE_RES_ARITHMETIC: begin
                regWriteData_o <= arithmetic_res;
            end
            `EXE_RES_MUL: begin
                regWriteData_o <= mul_res[31:0];
            end
            `EXE_RES_JUMP_BRANCH: begin
                regWriteData_o <= linkAddr_i;
            end
            default: begin
                regWriteData_o <= `ZeroWord;
            end
        endcase
    end
    
    always @ (*) begin
		if(rst == `Enable) begin
			cp0WriteAddr_o <= 5'b00000;
			cp0WriteEnable_o <= `Disable;
			cp0WriteData_o <= `ZeroWord;
		end else if(aluOp_i == `EXE_MTC0_OP) begin
			cp0WriteAddr_o <= inst_i[15:11];
			cp0WriteEnable_o <= `Enable;
			cp0WriteData_o <= operand1_i;
	  end else begin
			cp0WriteAddr_o <= 5'b00000;
			cp0WriteEnable_o <= `Disable;
			cp0WriteData_o <= `ZeroWord;
		end				
	end	
endmodule
