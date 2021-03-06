`include "defines.v"

module MEM(
	input wire rst,
	input wire[`RegAddrBus] regWriteAddr_i, // wd_i
	input wire regWriteEnable_i, //wreg_i
	input wire[`RegBus] regWriteData_i,//wdata_i
    input wire regHILOEnable_i, //whilo_i
	input wire[`RegBus] regHI_i, //hi_i
	input wire[`RegBus] regLO_i, //lo_i
	input wire[`AluOpBus] aluOp_i,
	//input wire[`RegBus] memAddr_i,
	input wire[`RegBus] operand2_i,
	input wire[`RegBus] memData_i,
	input wire LLbitData_i, //LLbit_i
	input wire mem_wb_LLbitData_i,//wb_LLbit_value_i
	input wire mem_wb_LLbitWriteEnable_i,//wb_LLbit_we_i
	input wire cp0WriteEnable_i,
	input wire[4:0] cp0WriteAddr_i,
	input wire[`RegBus] cp0WriteData_i,
	input wire[`RegBus] exceptionType_i,//第[8]位为syscall [9]置为1表示指令无效 [10] trap [11] overflow [12]表示eret 其他位为0
	input wire isInDelayslot_i,
	input wire[`RegBus] instAddr_i,
	input wire[`RegBus] cp0Status_i,
	input wire[`RegBus] cp0Cause_i,
	input wire[`RegBus] cp0EPC_i,
	input wire mem_wb_cp0WriteEnable_i,
	input wire[4:0] mem_wb_cp0WriteAddr_i,
	input wire[`RegBus] mem_wb_cp0WriteData_i,

	output reg[`InstAddrBus] badAddr_o,

	input wire[31:0] physDataAddr_i,
    input wire[31:0] virtDataAddr_i,
    input wire dataInvalid_i,
    input wire dataMiss_i,
    input wire dataDirty_i,
    input wire dataIllegal_i,

	output wire isInstTLBR_o,
	output wire isInstTLBWR_o,
	output wire isInstTLBWI_o,
	output wire isInstTLBP_o,

	output reg[`RegAddrBus] regWriteAddr_o,//wd_o,
	output reg regWriteEnable_o,//wreg_o,
	output reg[`RegBus] regWriteData_o,//wdata_o
	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o,
	output reg[`RegBus] memAddr_o,
	output wire memWriteEnable_o,
	output reg[3:0] memSel_o,
	output reg[`RegBus] memData_o,
	output reg memEnable_o,
	output reg LLbitData_o, //LLbit_value_o
	output reg LLbitWriteEnable_o, //LLbit_we_o
	output reg cp0WriteEnable_o,
	output reg[4:0] cp0WriteAddr_o,
	output reg[`RegBus] cp0WriteData_o,
	output reg[`RegBus] exceptionType_o,
	output wire[`RegBus] instAddr_o,
	output wire isInDelayslot_o,
	output wire[`RegBus] cp0EPC_o
);

	reg load_alignment_error;
	reg store_alignment_error;

    reg memWriteEnable;
    assign memWriteEnable_o = memWriteEnable & (~(|exceptionType_o));

    wire[`RegBus] ZERO;//temp value
    assign ZERO = `ZeroWord;

    reg LLbitData_latest;//latest value of LLbit (LLbit)
	reg[`RegBus] cp0Status_latest;
	reg[`RegBus] cp0Cause_latest;
	reg[`RegBus] cp0EPC_latest;

	assign isInDelayslot_o = isInDelayslot_i;
	assign instAddr_o = instAddr_i;
	assign cp0EPC_o = cp0EPC_latest;

	assign isInstTLBR_o = (aluOp_i == `EXE_TLBR_OP);
	assign isInstTLBWR_o = (aluOp_i == `EXE_TLBWR_OP);
	assign isInstTLBWI_o = (aluOp_i == `EXE_TLBWI_OP);
	assign isInstTLBP_o = (aluOp_i == `EXE_TLBP_OP);

	always @ (*) begin
		if(rst == `Enable) begin
			cp0Status_latest <= `ZeroWord;
		end else if((mem_wb_cp0WriteEnable_i == `Enable) && (mem_wb_cp0WriteAddr_i == `CP0_REG_STATUS ))begin
			cp0Status_latest <= mem_wb_cp0WriteData_i;
		end else begin
		  cp0Status_latest <= cp0Status_i;
		end
	end

	always @ (*) begin
		if(rst == `Enable) begin
			cp0EPC_latest <= `ZeroWord;
		end else if((mem_wb_cp0WriteEnable_i == `Enable) && (mem_wb_cp0WriteAddr_i == `CP0_REG_EPC ))begin
			cp0EPC_latest <= mem_wb_cp0WriteData_i;
		end else begin
		  cp0EPC_latest <= cp0EPC_i;
		end
	end

	always @ (*) begin
		if(rst == `Enable) begin
			cp0Cause_latest <= `ZeroWord;
		end else if((mem_wb_cp0WriteEnable_i == `Enable) && (mem_wb_cp0WriteAddr_i == `CP0_REG_CAUSE ))begin
			cp0Cause_latest[9:8] <= mem_wb_cp0WriteData_i[9:8];
			cp0Cause_latest[22] <= mem_wb_cp0WriteData_i[22];
			cp0Cause_latest[23] <= mem_wb_cp0WriteData_i[23];
		end else begin
		  cp0Cause_latest <= cp0Cause_i;
		end
	end

	always @(*) begin
			if(rst == `Enable) begin
					LLbitData_latest <= 1'b0;
			end else begin
					if(mem_wb_LLbitWriteEnable_i == `Enable) begin
							LLbitData_latest <= mem_wb_LLbitData_i;
					end else begin
							LLbitData_latest <= LLbitData_i;
					end
			end
	end


	////第[8]位为syscall [9]置为1表示指令无效 [10] trap [11] overflow [12]表示eret [13] adel [14] tlbl
	always @ (*) begin
		if(rst == `Enable) begin
			exceptionType_o <= `ZeroWord;
			badAddr_o <= `ZeroWord;
		end else begin
			exceptionType_o <= `ZeroWord;
			badAddr_o <= `ZeroWord;
			if(instAddr_i != `ZeroWord) begin
				if(((cp0Cause_latest[15:8] & (cp0Status_latest[15:8])) != 8'h00) && (cp0Status_latest[1] == 1'b0) && (cp0Status_latest[0] == 1'b1)) begin //8个外部中断和掩码 异常级 和 中断使能
					exceptionType_o <= 32'h00000001;        //interrupt
				end else if(exceptionType_i[14] == 1'b1) begin //AdEL 取指阶段
					exceptionType_o <= 32'h00000004;
					badAddr_o <= instAddr_i;
				end else if(exceptionType_i[13] == 1'b1) begin //tlbl 取指阶段
					exceptionType_o <= 32'h00000002;
					badAddr_o <= instAddr_i;
				end else if(exceptionType_i[8] == 1'b1) begin //syscall
					exceptionType_o <= 32'h00000008;
				end else if(exceptionType_i[11] == 1'b1) begin //ov
					exceptionType_o <= 32'h0000000c;
				end else if(exceptionType_i[10] ==1'b1) begin //trap
					exceptionType_o <= 32'h0000000d;
				end else if(exceptionType_i[12] == 1'b1) begin //eret
					exceptionType_o <= 32'h0000000e;
				end else if(exceptionType_i[9] == 1'b1) begin //ri  无效指令
					exceptionType_o <= 32'h0000000a;
				end else if(load_alignment_error == `True_v && !(virtDataAddr_i[31:24]>=8'hbc || virtDataAddr_i[31:24] <= 8'hbf)) begin //AdEL mem访存阶段
					exceptionType_o <= 32'h00000004;
					badAddr_o <= virtDataAddr_i;
				end else if(store_alignment_error == `True_v && !(virtDataAddr_i[31:24]>=8'hbc || virtDataAddr_i[31:24] <= 8'hbf)) begin //AdES mem访存阶段
					exceptionType_o <= 32'h00000005;
					badAddr_o <= virtDataAddr_i;
				end else if(dataIllegal_i == 1'b1) begin
					if(memWriteEnable ==`Enable && memEnable_o == `Enable) begin
						exceptionType_o <= 32'h00000005; //ades
						badAddr_o <= virtDataAddr_i;
					end
					else if(memWriteEnable ==`Disable && memEnable_o == `Enable) begin
						exceptionType_o <= 32'h00000004;  //adel
						badAddr_o <= virtDataAddr_i;
					end
				end else if(dataMiss_i == 1'b1) begin
					if(memWriteEnable ==`Enable && memEnable_o == `Enable) begin
						exceptionType_o <= 32'h00000003;  //TLBS
						badAddr_o <= virtDataAddr_i;
					end
					else if(memWriteEnable ==`Disable && memEnable_o == `Enable) begin
						exceptionType_o <= 32'h00000002;  //TLBL
						badAddr_o <= virtDataAddr_i;
					end
				end else if(dataInvalid_i == 1'b1) begin
					if(memWriteEnable ==`Enable && memEnable_o == `Enable) begin
						exceptionType_o <= 32'h00000003;  //TLBS
						badAddr_o <= virtDataAddr_i;
					end
					else if(memWriteEnable ==`Disable && memEnable_o == `Enable) begin
						exceptionType_o <= 32'h00000002;  //TLBL
						badAddr_o <= virtDataAddr_i;
					end
				end else if(memWriteEnable && ~dataDirty_i) begin
					exceptionType_o <= 32'h0000000f;  //TLBMOD
					badAddr_o <= virtDataAddr_i;
				end
			end

		end//if(rst==`Enable)
	end//always

    always @(*) begin
        if(rst == `Enable) begin
            regWriteAddr_o <= `NOPRegAddr;
            regWriteEnable_o <= `Disable;
            regWriteData_o <= `ZeroWord;
            regHILOEnable_o <= `Disable;
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
            memAddr_o <= `ZeroWord;
            memWriteEnable <= `Disable;
            memSel_o <= 4'b0000;
            memData_o <= `ZeroWord;
            memEnable_o <= `Disable;
            LLbitData_o <= 1'b0;
            LLbitWriteEnable_o <= `Disable;
            cp0WriteEnable_o <= `Disable;
            cp0WriteAddr_o <= 5'b00000;
            cp0WriteData_o <= `ZeroWord;
						load_alignment_error <=`False_v;
						store_alignment_error <= `False_v;
        end else begin
            regWriteAddr_o <= regWriteAddr_i;
            regWriteEnable_o <= regWriteEnable_i;
            regWriteData_o <= regWriteData_i;
            regHILOEnable_o <= regHILOEnable_i;
            regHI_o <= regHI_i;
            regLO_o <=  regLO_i;
            memWriteEnable <= `Disable;
            memAddr_o <= `ZeroWord;
            memSel_o <= 4'b1111;
            memEnable_o <= `Disable;
            LLbitData_o <= 1'b0;
            LLbitWriteEnable_o <= `Disable;
            cp0WriteEnable_o <= cp0WriteEnable_i;
            cp0WriteAddr_o <= cp0WriteAddr_i;
            cp0WriteData_o <= cp0WriteData_i;
						load_alignment_error <=`False_v;
						store_alignment_error <= `False_v;
            case(aluOp_i)
                `EXE_LL_OP: begin
                    memAddr_o <= physDataAddr_i;
                    memWriteEnable <= `Disable;
                    LLbitWriteEnable_o <= `Enable;
                    LLbitData_o <= 1'b1;
										case(physDataAddr_i[1:0])
											2'b00: begin
												memEnable_o <= `Enable;
												regWriteData_o <= memData_i;
												memSel_o <= 4'b1111;
											end
											default: begin
												memEnable_o <= `Disable;
												regWriteData_o <= `ZeroWord;
												memSel_o <= 4'b0000;
												load_alignment_error <= `True_v;
											end
										endcase
                end
                `EXE_SC_OP: begin
                    if(LLbitData_latest == 1'b1) begin
                        LLbitWriteEnable_o <= `Enable;
                        LLbitData_o <= 1'b0;
                        memAddr_o <= physDataAddr_i;
                        memData_o <= operand2_i;
                        regWriteData_o <= 32'b1;
												case(physDataAddr_i[1:0])
													2'b00: begin
														memSel_o <= 4'b1111;
														memWriteEnable <= `Enable;
														memEnable_o <= `Enable;
													end
													default: begin
														memSel_o <= 4'b0000;
														memWriteEnable <= `Disable;
														memEnable_o <= `Disable;
														store_alignment_error <= `True_v;
													end
												endcase
                    end else begin
                        regWriteData_o <= `ZeroWord;
												memSel_o <= 4'b0000;
												memWriteEnable <= `Disable;
												memEnable_o <= `Disable;
                    end
                end
                `EXE_LB_OP:		begin
					memAddr_o <= physDataAddr_i;
					memWriteEnable <= `Disable;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{24{memData_i[7]}},memData_i[7:0]};
							memSel_o <= 4'b0001;
							memEnable_o <= `Enable;
						end
						2'b01:	begin
							regWriteData_o <= {{24{memData_i[15]}},memData_i[15:8]};
							memSel_o <= 4'b0010;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							regWriteData_o <= {{24{memData_i[23]}},memData_i[23:16]};
							memSel_o <= 4'b0100;
							memEnable_o <= `Enable;
						end
						2'b11:	begin
							regWriteData_o <= {{24{memData_i[31]}},memData_i[31:24]};
							memSel_o <= 4'b1000;
							memEnable_o <= `Enable;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							load_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_LBU_OP:		begin
					memAddr_o <= physDataAddr_i;
					memWriteEnable <= `Disable;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[7:0]};
							memSel_o <= 4'b0001;
							memEnable_o <= `Enable;
						end
						2'b01:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[15:8]};
							memSel_o <= 4'b0010;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[23:16]};
							memSel_o <= 4'b0100;
							memEnable_o <= `Enable;
						end
						2'b11:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[31:24]};
							memSel_o <= 4'b1000;
							memEnable_o <= `Enable;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							load_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_LH_OP:		begin
					memAddr_o <= physDataAddr_i;
					memWriteEnable <= `Disable;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{16{memData_i[15]}},memData_i[15:0]};
							memSel_o <= 4'b0011;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							regWriteData_o <= {{16{memData_i[31]}},memData_i[31:16]};
							memSel_o <= 4'b1100;
							memEnable_o <= `Enable;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							load_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_LHU_OP:		begin
					memAddr_o <= physDataAddr_i;
					memWriteEnable <= `Disable;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{16{1'b0}},memData_i[15:0]};
							memSel_o <= 4'b0011;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							regWriteData_o <= {{16{1'b0}},memData_i[31:16]};
							memSel_o <= 4'b1100;
							memEnable_o <= `Enable;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							load_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_LW_OP:		begin
					memAddr_o <= physDataAddr_i;
					memWriteEnable <= `Disable;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= memData_i;
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							load_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_LWL_OP:		begin
					memAddr_o <= {physDataAddr_i[31:2], 2'b00};
					memWriteEnable <= `Disable;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {memData_i[7:0],operand2_i[23:0]};
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						2'b01:	begin
							regWriteData_o <= {memData_i[15:0],operand2_i[15:0]};
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							regWriteData_o <= {memData_i[23:0],operand2_i[7:0]};
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						2'b11:	begin
							regWriteData_o <= memData_i[31:0];
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							load_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_LWR_OP:		begin
					memAddr_o <= {physDataAddr_i[31:2], 2'b00};
					memWriteEnable <= `Disable;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= memData_i;
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						2'b01:	begin
							regWriteData_o <= {operand2_i[31:24],memData_i[31:8]};
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							regWriteData_o <= {operand2_i[31:16],memData_i[31:16]};
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						2'b11:	begin
							regWriteData_o <= {operand2_i[31:8],memData_i[31:24]};
							memSel_o <= 4'b1111;
							memEnable_o <= `Enable;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							load_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_SB_OP:		begin
					memAddr_o <= physDataAddr_i;
					memData_o <= {operand2_i[7:0],operand2_i[7:0],operand2_i[7:0],operand2_i[7:0]};
					case (physDataAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b0001;
							memEnable_o <= `Enable;
							memWriteEnable <= `Enable;
						end
						2'b01:	begin
							memSel_o <= 4'b0010;
							memEnable_o <= `Enable;
							memWriteEnable <= `Enable;
						end
						2'b10:	begin
							memSel_o <= 4'b0100;
							memEnable_o <= `Enable;
							memWriteEnable <= `Enable;
						end
						2'b11:	begin
							memSel_o <= 4'b1000;
							memEnable_o <= `Enable;
							memWriteEnable <= `Enable;
						end
						default:	begin
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							memWriteEnable <= `Disable;
							store_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_SH_OP:		begin
					memAddr_o <= physDataAddr_i;
					memData_o <= {operand2_i[15:0],operand2_i[15:0]};
					case (physDataAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b0011;
							memEnable_o <= `Enable;
							memWriteEnable <= `Enable;
						end
						2'b10:	begin
							memSel_o <= 4'b1100;
							memEnable_o <= `Enable;
							memWriteEnable <= `Enable;
						end
						default:	begin
							memSel_o <= 4'b0000;
							memEnable_o <= `Disable;
							memWriteEnable <= `Disable;
							store_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_SW_OP:		begin
					memAddr_o <= physDataAddr_i;
					memData_o <= operand2_i;
					case (physDataAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b1111;
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						default:	begin
							memSel_o <= 4'b0000;
							memWriteEnable <= `Disable;
							memEnable_o <= `Disable;
							store_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_SWL_OP:		begin
					memAddr_o <= {physDataAddr_i[31:2], 2'b00};
					case (physDataAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b0001;
							memData_o <= {ZERO[23:0],operand2_i[31:24]};
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						2'b01:	begin
							memSel_o <= 4'b0011;
							memData_o <= {ZERO[15:0],operand2_i[31:16]};
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							memSel_o <= 4'b0111;
							memData_o <= {ZERO[7:0],operand2_i[31:8]};
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						2'b11:	begin
							memSel_o <= 4'b1111;
							memData_o <= operand2_i;
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						default:	begin
							memSel_o <= 4'b0000;
							memWriteEnable <= `Disable;
							memEnable_o <= `Disable;
							store_alignment_error <= `True_v;
						end
					endcase
				end
				`EXE_SWR_OP:		begin
					memAddr_o <= {physDataAddr_i[31:2], 2'b00};
					case (physDataAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b1111;
							memData_o <= operand2_i[31:0];
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						2'b01:	begin
							memSel_o <= 4'b1110;
							memData_o <= {operand2_i[23:0],ZERO[7:0]};
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						2'b10:	begin
							memSel_o <= 4'b1100;
							memData_o <= {operand2_i[15:0],ZERO[15:0]};
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						2'b11:	begin
							memSel_o <= 4'b1000;
							memData_o <= {operand2_i[7:0],ZERO[23:0]};
							memWriteEnable <= `Enable;
							memEnable_o <= `Enable;
						end
						default:	begin
							memSel_o <= 4'b0000;
							memData_o <= `ZeroWord;
							memWriteEnable <= `Disable;
							memEnable_o <= `Disable;
						end
					endcase
				end
                default: begin
                end
            endcase
        end
    end

endmodule
