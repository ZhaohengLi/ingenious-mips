`include "defines.v"

module MEM(
	input wire rst,

	input wire[`RegAddrBus] regWriteAddr_i, // wd_i
	input wire regWriteEnable_i, //wreg_i
	input wire[`RegBus] regWriteData_i,//wdata_i

    input wire regHILOEnable_i, //whilo_i
	input wire[`RegBus] regHI_i, //hi_i
	input wire[`RegBus] regLO_i, //lo_i

	output reg[`RegAddrBus] regWriteAddr_o,//wd_o,
	output reg regWriteEnable_o,//wreg_o,
	output reg[`RegBus] regWriteData_o,//wdata_o
	//HILO
	output reg regHILOEnable_o,
	output reg[`RegBus] regHI_o,
	output reg[`RegBus] regLO_o,

	input wire[`AluOpBus] aluOp_i,
	input wire[`RegBus] memAddr_i,
	input wire[`RegBus] operand2_i,
	input wire[`RegBus] memData_i,
	output reg[`RegBus] memAddr_o,
	output wire memWriteEnable_o,
	output reg[3:0] memSel_o,
	output reg[`RegBus] memData_o,
	output reg memEnable_o,

	input wire LLbitData_i, //LLbit_i
	input wire mem_wb_LLbitData_i,//wb_LLbit_value_i
	input wire mem_wb_LLbitWriteEnable_i,//wb_LLbit_we_i

	output reg LLbitData_o, //LLbit_value_o
	output reg LLbitWriteEnable_o //LLbit_we_o

);

    reg memWriteEnable;
    assign memWriteEnable_o = memWriteEnable;

    wire[`RegBus] ZERO;//temp value
    assign ZERO = `ZeroWord;

    reg LLbitData;//latest value of LLbit (LLbit)

    always @(*) begin
        if(rst == `Enable) begin
            LLbitData <= 1'b0;
        end else begin
            if(mem_wb_LLbitWriteEnable_i == `Enable) begin
                LLbitData <= mem_wb_LLbitData_i;
            end else begin
                LLbitData <= LLbitData_i;
            end
        end
    end

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
            case(aluOp_i)
                `EXE_LL_OP: begin
                    memAddr_o <= memAddr_i;
                    memWriteEnable <= `Disable;
                    regWriteData_o <= memData_i;
                    LLbitWriteEnable_o <= `Enable;
                    LLbitData_o <= 1'b1;
                    memSel_o <= 4'b1111;
                    memEnable_o <= `Enable;
                end
                `EXE_SC_OP: begin
                    if(LLbitData == 1'b1) begin
                        LLbitWriteEnable_o <= `Enable;
                        LLbitData_o <= 1'b0;
                        memAddr_o <= memAddr_i;
                        memWriteEnable <= `Enable;
                        memData_o <= operand2_i;
                        regWriteData_o <= 32'b1;
                        memSel_o <= 4'b1111;
                        memEnable_o <= `Enable;
                    end else begin
                        regWriteData_o <= `ZeroWord;
                    end
                end
                `EXE_LB_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Disable;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{24{memData_i[31]}},memData_i[31:24]};
							memSel_o <= 4'b1000;
						end
						2'b01:	begin
							regWriteData_o <= {{24{memData_i[23]}},memData_i[23:16]};
							memSel_o <= 4'b0100;
						end
						2'b10:	begin
							regWriteData_o <= {{24{memData_i[15]}},memData_i[15:8]};
							memSel_o <= 4'b0010;
						end
						2'b11:	begin
							regWriteData_o <= {{24{memData_i[7]}},memData_i[7:0]};
							memSel_o <= 4'b0001;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LBU_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Disable;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[31:24]};
							memSel_o <= 4'b1000;
						end
						2'b01:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[23:16]};
							memSel_o <= 4'b0100;
						end
						2'b10:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[15:8]};
							memSel_o <= 4'b0010;
						end
						2'b11:	begin
							regWriteData_o <= {{24{1'b0}},memData_i[7:0]};
							memSel_o <= 4'b0001;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LH_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Disable;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{16{memData_i[31]}},memData_i[31:16]};
							memSel_o <= 4'b1100;
						end
						2'b10:	begin
							regWriteData_o <= {{16{memData_i[15]}},memData_i[15:0]};
							memSel_o <= 4'b0011;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LHU_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Disable;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {{16{1'b0}},memData_i[31:16]};
							memSel_o <= 4'b1100;
						end
						2'b10:	begin
							regWriteData_o <= {{16{1'b0}},memData_i[15:0]};
							memSel_o <= 4'b0011;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LW_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Disable;
					regWriteData_o <= memData_i;
					memSel_o <= 4'b1111;
					memEnable_o <= `Enable;
				end
				`EXE_LWL_OP:		begin
					memAddr_o <= {memAddr_i[31:2], 2'b00};
					memWriteEnable <= `Disable;
					memSel_o <= 4'b1111;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= memData_i[31:0];
						end
						2'b01:	begin
							regWriteData_o <= {memData_i[23:0],operand2_i[7:0]};
						end
						2'b10:	begin
							regWriteData_o <= {memData_i[15:0],operand2_i[15:0]};
						end
						2'b11:	begin
							regWriteData_o <= {memData_i[7:0],operand2_i[23:0]};
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LWR_OP:		begin
					memAddr_o <= {memAddr_i[31:2], 2'b00};
					memWriteEnable <= `Disable;
					memSel_o <= 4'b1111;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							regWriteData_o <= {operand2_i[31:8],memData_i[31:24]};
						end
						2'b01:	begin
							regWriteData_o <= {operand2_i[31:16],memData_i[31:16]};
						end
						2'b10:	begin
							regWriteData_o <= {operand2_i[31:24],memData_i[31:8]};
						end
						2'b11:	begin
							regWriteData_o <= memData_i;
						end
						default:	begin
							regWriteData_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_SB_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Enable;
					memData_o <= {operand2_i[7:0],operand2_i[7:0],operand2_i[7:0],operand2_i[7:0]};
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b1000;
						end
						2'b01:	begin
							memSel_o <= 4'b0100;
						end
						2'b10:	begin
							memSel_o <= 4'b0010;
						end
						2'b11:	begin
							memSel_o <= 4'b0001;
						end
						default:	begin
							memSel_o <= 4'b0000;
						end
					endcase
				end
				`EXE_SH_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Enable;
					memData_o <= {operand2_i[15:0],operand2_i[15:0]};
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b1100;
						end
						2'b10:	begin
							memSel_o <= 4'b0011;
						end
						default:	begin
							memSel_o <= 4'b0000;
						end
					endcase
				end
				`EXE_SW_OP:		begin
					memAddr_o <= memAddr_i;
					memWriteEnable <= `Enable;
					memData_o <= operand2_i;
					memSel_o <= 4'b1111;
					memEnable_o <= `Enable;
				end
				`EXE_SWL_OP:		begin
					memAddr_o <= {memAddr_i[31:2], 2'b00};
					memWriteEnable <= `Enable;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b1111;
							memData_o <= operand2_i;
						end
						2'b01:	begin
							memSel_o <= 4'b0111;
							memData_o <= {ZERO[7:0],operand2_i[31:8]};
						end
						2'b10:	begin
							memSel_o <= 4'b0011;
							memData_o <= {ZERO[15:0],operand2_i[31:16]};
						end
						2'b11:	begin
							memSel_o <= 4'b0001;
							memData_o <= {ZERO[23:0],operand2_i[31:24]};
						end
						default:	begin
							memSel_o <= 4'b0000;
						end
					endcase
				end
				`EXE_SWR_OP:		begin
					memAddr_o <= {memAddr_i[31:2], 2'b00};
					memWriteEnable <= `Enable;
					memEnable_o <= `Enable;
					case (memAddr_i[1:0])
						2'b00:	begin
							memSel_o <= 4'b1000;
							memData_o <= {operand2_i[7:0],ZERO[23:0]};
						end
						2'b01:	begin
							memSel_o <= 4'b1100;
							memData_o <= {operand2_i[15:0],ZERO[15:0]};
						end
						2'b10:	begin
							memSel_o <= 4'b1110;
							memData_o <= {operand2_i[23:0],ZERO[7:0]};
						end
						2'b11:	begin
							memSel_o <= 4'b1111;
							memData_o <= operand2_i[31:0];
						end
						default:	begin
							memSel_o <= 4'b0000;
						end
					endcase
				end
                default: begin
                end
            endcase
        end
    end

endmodule
