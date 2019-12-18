`include "defines.v"

module CP0(
	input wire clk,
	input wire rst,
	//写入相关
	input wire cp0WriteEnable_i,
	input wire[4:0] cp0WriteAddr_i,
	input wire[31:0] cp0WriteData_i,
	//读出相关
	input wire[4:0] cp0ReadAddr_i,
	output reg[`RegBus] cp0Data_o,
	//外部中断传入
	input wire[5:0] cp0Inte_i,
	//随从mem直接传入
	input wire[`RegBus] exceptionType_i,
	input wire[`RegBus] instAddr_i,
	input wire isInDelayslot_i,
	input wire[31:0] badAddr_i,

	//内部寄存器
	output reg[`RegBus] cp0Index_o,//0
	output reg[`RegBus] cp0Random_o,//1
	output reg[`RegBus] cp0EntryLO0_o,//2
	output reg[`RegBus] cp0EntryLO1_o,//3
	output reg[`RegBus] cp0Context_o,//4
	output reg[`RegBus] cp0Pagemask_o,//5
	output reg[`RegBus] cp0Wired_o,//6
	output reg[`RegBus] cp0Badvaddr_o,//8
	output reg[`RegBus] cp0Count_o,//9
	output reg[`RegBus] cp0EntryHI_o,//10
	output reg[`RegBus] cp0Compare_o,//11
	output reg[`RegBus] cp0Status_o,//12
	output reg[`RegBus] cp0Cause_o,//13
	output reg[`RegBus] cp0EPC_o,//14
	output reg[`RegBus] cp0EBase_o,//15 prid
	output reg[`RegBus] cp0Config_o,//16
	output reg[`RegBus] cp0ErrorEPC_o,//30
	//时钟中断传出
	output reg cp0TimerInte_o,

	input wire[`RegBus] tlbpRes_i,

	input wire isInstTLBP_i,
	input wire isInstTLBR_i,
	input wire isInstTLBWR_i,
	input wire isInstTLBWI_i,
	//tlbr_res from mmu
	input wire[2:0] tlbc0_i,
	input wire[2:0] tlbc1_i,
	input wire[7:0] tlbasid_i,
	input wire[18:0] tlbvpn2,
	input wire[23:0] tlbpfn0,
	input wire[23:0] tlbpfn1,
	input wire tlbd1,
	input wire tlbv1,
	input wire tlbd0,
	input wire tlbv0,
	input wire tlbG,
	//tlbp_res from mmu
	output wire userMode_o,
	output wire[7:0] asid_o
);

	assign userMode_o = (cp0Status_o[4:1] == 4'b1000);
	assign asid_o = cp0EntryHI_o[7:0];

	always @ (posedge clk) begin
		if(rst == `Enable) begin
			cp0TimerInte_o <= `InterruptNotAssert;
			cp0Index_o <= `ZeroWord;
			cp0Random_o <= `TLB_ENTRIES_NUM - 1;
			cp0EntryLO1_o <= `ZeroWord;
            cp0EntryLO0_o <= `ZeroWord;
			cp0Context_o <= `ZeroWord;
			cp0Pagemask_o <= `ZeroWord;
			cp0Wired_o <= `ZeroWord;
			cp0Badvaddr_o <= `ZeroWord;
			cp0Count_o <= `ZeroWord;
			cp0EntryHI_o <= `ZeroWord;
			cp0Compare_o <= `ZeroWord;
			cp0Status_o <= 32'b00010000010000000000000000000000;
			cp0Cause_o <= `ZeroWord;
			cp0EPC_o <= `ZeroWord;
			cp0EBase_o <= 32'h80000000;
			cp0Config_o <= `ZeroWord;
			cp0ErrorEPC_o <= `ZeroWord;
		end else begin

			cp0Count_o <= cp0Count_o + 1 ;
			cp0Cause_o[15:10] <= cp0Inte_i;
			cp0Random_o <= cp0Random_o + isInstTLBWR_i;
			if(cp0Compare_o != `ZeroWord && cp0Count_o == cp0Compare_o) cp0TimerInte_o <= `InterruptAssert;

			if(isInstTLBR_i ==1'b1) begin
				cp0EntryHI_o[31:13] = tlbvpn2;
				cp0EntryHI_o[7:0] = tlbasid_i;
				cp0EntryLO0_o = {2'b0,tlbpfn0,tlbc0_i,tlbd0,tlbv0,tlbG};
				cp0EntryLO1_o = {2'b0,tlbpfn1,tlbc1_i,tlbd1,tlbv1,tlbG};
			end

			if(isInstTLBP_i) begin
				cp0Index_o <= tlbpRes_i;
			end

			//异常判断
			case (exceptionType_i)
				32'h00000001: begin //六个外部中断 两个软件中断
					if(isInDelayslot_i == `InDelaySlot ) begin
						cp0EPC_o <= instAddr_i - 4 ;
						cp0Cause_o[31] <= 1'b1;
					end else begin
					  cp0EPC_o <= instAddr_i;
					  cp0Cause_o[31] <= 1'b0;
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b00000;
				end

				32'h00000002: begin  //TLBL tlb加载异常或者取指异常或者保留
					if (cp0Status_o[1] == 1'b0) begin
							if (isInDelayslot_i == `InDelaySlot) begin
									cp0EPC_o <= instAddr_i - 4;
									cp0Cause_o[31] <= 1'b1;
							end else begin
									cp0EPC_o <= instAddr_i;
									cp0Cause_o[31] <= 1'b0;
							end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b00010;
					cp0Badvaddr_o <= badAddr_i;
					cp0Context_o[22:4] = badAddr_i[31:13];
					cp0EntryHI_o[31:13] = badAddr_i[31:13];
                end

				32'h00000003: begin //TLBS tlb储存异常或者保留
					if (cp0Status_o[1] == 1'b0) begin
							if (isInDelayslot_i == `InDelaySlot) begin
									cp0EPC_o <= instAddr_i - 4;
									cp0Cause_o[31] <= 1'b1;
							end else begin
									cp0EPC_o <= instAddr_i;
									cp0Cause_o[31] <= 1'b0;
							end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b00011;
					cp0Badvaddr_o <= badAddr_i;
					cp0Context_o[22:4] = badAddr_i[31:13];
					cp0EntryHI_o[31:13] = badAddr_i[31:13];
                end

				32'h00000004: begin //ADEL 加载或者取指过程中 地址错误异常
					if (cp0Status_o[1] == 1'b0) begin
							if (isInDelayslot_i == `InDelaySlot) begin
									cp0EPC_o <= instAddr_i - 4;
									cp0Cause_o[31] <= 1'b1;
							end else begin
									cp0EPC_o <= instAddr_i;
									cp0Cause_o[31] <= 1'b0;
							end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b00100;
					cp0Badvaddr_o <= badAddr_i;
                end

				32'h00000005: begin //ADES 存储过程中 地址错误异常
						if (cp0Status_o[1] == 1'b0) begin
								if (isInDelayslot_i == `InDelaySlot) begin
										cp0EPC_o <= instAddr_i - 4;
										cp0Cause_o[31] <= 1'b1;
								end else begin
										cp0EPC_o <= instAddr_i;
										cp0Cause_o[31] <= 1'b0;
								end
						end
						cp0Status_o[1] <= 1'b1;
						cp0Cause_o[6:2] <= 5'b00101;
						cp0Badvaddr_o <= badAddr_i;
				end

				32'h00000008: begin //sys 系统调用sysall
					if(cp0Status_o[1] == 1'b0) begin
						if(isInDelayslot_i == `InDelaySlot ) begin
							cp0EPC_o <= instAddr_i - 4 ;
							cp0Cause_o[31] <= 1'b1;
						end else begin
							cp0EPC_o <= instAddr_i;
							cp0Cause_o[31] <= 1'b0;
						end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b01000;
				end

				32'h0000000a: begin //RI 执行未定义的指令的异常
					if(cp0Status_o[1] == 1'b0) begin
						if(isInDelayslot_i == `InDelaySlot ) begin
							cp0EPC_o <= instAddr_i - 4 ;
							cp0Cause_o[31] <= 1'b1;
						end else begin
							cp0EPC_o <= instAddr_i;
							cp0Cause_o[31] <= 1'b0;
						end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b01010;
				end

				32'h0000000c: begin //ov 溢出异常
					if(cp0Status_o[1] == 1'b0) begin
						if(isInDelayslot_i == `InDelaySlot ) begin
							cp0EPC_o <= instAddr_i - 4 ;
							cp0Cause_o[31] <= 1'b1;
						end else begin
							cp0EPC_o <= instAddr_i;
							cp0Cause_o[31] <= 1'b0;
						end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b01100;
				end

				32'h0000000d: begin //tr 自陷指令引起的异常
					if(cp0Status_o[1] == 1'b0) begin
						if(isInDelayslot_i == `InDelaySlot ) begin
							cp0EPC_o <= instAddr_i - 4 ;
							cp0Cause_o[31] <= 1'b1;
						end else begin
							cp0EPC_o <= instAddr_i;
							cp0Cause_o[31] <= 1'b0;
						end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b01101;
				end

				32'h0000000e: begin //eret
					cp0Status_o[1] <= 1'b0;
				end

				32'h0000000f: begin //TLB MOD tlb修改异常或者保留
					if (cp0Status_o[1] == 1'b0) begin
						if (isInDelayslot_i == `InDelaySlot) begin
							cp0EPC_o <= instAddr_i - 4;
							cp0Cause_o[31] <= 1'b1;
						end else begin
							cp0EPC_o <= instAddr_i;
							cp0Cause_o[31] <= 1'b0;
					    end
					end
					cp0Status_o[1] <= 1'b1;
					cp0Cause_o[6:2] <= 5'b00001;
					cp0Badvaddr_o <= badAddr_i;
				end

				default: begin
				end
			endcase

			//写入数据
			if(cp0WriteEnable_i == `Enable) begin
				case (cp0WriteAddr_i)
					`CP0_REG_INDEX:    cp0Index_o <= {cp0WriteData_i[31], 27'b0, cp0WriteData_i[3:0]};
					//CP0_REG_RANDOM 不可写
					`CP0_REG_ENTRYLO0: cp0EntryLO0_o[31:0] <= cp0WriteData_i[31:0];
					`CP0_REG_ENTRYLO1: cp0EntryLO1_o[31:0] <= cp0WriteData_i[31:0];
					`CP0_REG_CONTEXT:  cp0Context_o[31:23] <= cp0WriteData_i[31:23];
					`CP0_REG_PAGEMASK: cp0Pagemask_o[28:12] <= cp0WriteData_i[28:12];
					`CP0_REG_WIRED:    cp0Wired_o[3:0] <= cp0WriteData_i[3:0];//是不是只写后4位有点不太确定
					//CP0_REG_BADVADDR 不可写
					`CP0_REG_COUNT:    cp0Count_o <= cp0WriteData_i;
					`CPO_REG_ENTRYHI:  cp0EntryHI_o <= {cp0WriteData_i[31:12], 4'b0, cp0WriteData_i[7:0]};
					`CP0_REG_COMPARE:  begin
						cp0Compare_o <= cp0WriteData_i;
						cp0TimerInte_o <= `InterruptNotAssert;
					end
					`CP0_REG_STATUS:   cp0Status_o <= cp0WriteData_i;
					`CP0_REG_CAUSE:	begin
						cp0Cause_o[9:8] <= cp0WriteData_i[9:8];
						cp0Cause_o[23:22] <= cp0WriteData_i[23:22];
					end
					`CP0_REG_EPC:      cp0EPC_o <= cp0WriteData_i;
					`CP0_REG_EBASE:    cp0EBase_o[29:12] <= cp0WriteData_i[29:12];
					`CP0_REG_CONFIG:   cp0Config_o[2:0] <= cp0WriteData_i[2:0];
					`CP0_REG_ERROREPC: cp0ErrorEPC_o <= cp0WriteData_i;
					default: begin
					end
				endcase
			end//if

		end//if
	end//always

	always @ (*) begin
		if(rst == `Enable) begin
			cp0Data_o <= `ZeroWord;
		end else begin
			case (cp0ReadAddr_i)
				`CP0_REG_INDEX:    cp0Data_o <= cp0Index_o;
				`CP0_REG_RANDOM:   cp0Data_o <= cp0Random_o;
				`CP0_REG_ENTRYLO0: cp0Data_o <= cp0EntryLO0_o;
				`CP0_REG_ENTRYLO1: cp0Data_o <= cp0EntryLO1_o;
				`CP0_REG_CONTEXT:  cp0Data_o <= cp0Context_o;
				`CP0_REG_PAGEMASK: cp0Data_o <= cp0Pagemask_o;
				`CP0_REG_WIRED:    cp0Data_o <= cp0Wired_o;
				`CP0_REG_BADVADDR: cp0Data_o <= cp0Badvaddr_o;
				`CP0_REG_COUNT:	   cp0Data_o <= cp0Count_o;
				`CPO_REG_ENTRYHI:  cp0Data_o <= cp0EntryHI_o;
				`CP0_REG_COMPARE:  cp0Data_o <= cp0Compare_o;
				`CP0_REG_STATUS:   cp0Data_o <= cp0Status_o;
				`CP0_REG_CAUSE:	   cp0Data_o <= cp0Cause_o;
				`CP0_REG_EPC:	   cp0Data_o <= cp0EPC_o;
				`CP0_REG_EBASE:    cp0Data_o <= cp0EBase_o;
				`CP0_REG_CONFIG:   cp0Data_o <= cp0Config_o;
				`CP0_REG_ERROREPC: cp0Data_o <= cp0ErrorEPC_o;
				default: 	begin
				end
			endcase
		end//if
	end//always

endmodule
