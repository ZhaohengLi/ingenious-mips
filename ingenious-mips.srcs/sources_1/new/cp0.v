`include "defines.v"

module CP0(
	input wire clk,
	input wire rst,

	input wire cp0WriteEnable_i, //we_i
	input wire[4:0] cp0WriteAddr_i,//waddr_i
	input wire[`RegBus] cp0WriteData_i,//data_i

	input wire[4:0] cp0ReadAddr_i,//raddr_i

	input wire[5:0] cp0Inte_i,//int_i
	input wire[`RegBus] exceptionType_i,
	input wire[`RegBus] instAddr_i,
	input wire isInDelayslot_i,

	output reg[`RegBus] cp0Data_o,//data_o
	output reg[`RegBus] cp0Count_o,//count_o
	output reg[`RegBus] cp0Compare_o,//compare_o
	output reg[`RegBus] cp0Status_o,//status_o
	output reg[`RegBus] cp0Cause_o,//cause_o
	output reg[`RegBus] cp0EPC_o,//epc_o
	output reg[`RegBus] cp0Config_o,//config_o
	output reg[`RegBus] cp0EBase_o,

	output reg cp0TimerInte_o //timer_int_o
);

	always @ (posedge clk) begin
		if(rst == `Enable) begin
			cp0Count_o <= `ZeroWord;
			cp0Compare_o <= `ZeroWord;
			cp0Status_o <= 32'b00010000000000000000000000000000;
			cp0Cause_o <= `ZeroWord;
			cp0EPC_o <= `ZeroWord;
			cp0Config_o <= 32'b0;
			cp0EBase_o <= 32'h80000000;
			cp0TimerInte_o <= `InterruptNotAssert;
		end else begin
			case (exceptionType_i)
				32'h00000001: begin
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
				32'h00000008: begin
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
				32'h0000000a: begin
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
				32'h0000000d: begin
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
				32'h0000000c: begin
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
				32'h0000000e:   begin
					cp0Status_o[1] <= 1'b0;
				end
				default: begin
				end
			endcase
			cp0Count_o <= cp0Count_o + 1 ;
			cp0Cause_o[15:10] <= cp0Inte_i;
			if(cp0Compare_o != `ZeroWord && cp0Count_o == cp0Compare_o) begin
				cp0TimerInte_o <= `InterruptAssert;
			end
			if(cp0WriteEnable_i == `Enable) begin
				case (cp0WriteAddr_i)
					`CP0_REG_COUNT:begin
						cp0Count_o <= cp0WriteData_i;
					end
					`CP0_REG_COMPARE:begin
						cp0Compare_o <= cp0WriteData_i;
						cp0TimerInte_o <= `InterruptNotAssert;
					end
					`CP0_REG_STATUS:	begin
						cp0Status_o <= cp0WriteData_i;
					end
					`CP0_REG_EPC:	begin
						cp0EPC_o <= cp0WriteData_i;
					end
					`CP0_REG_CAUSE:	begin
						cp0Cause_o[9:8] <= cp0WriteData_i[9:8];
						cp0Cause_o[23] <= cp0WriteData_i[23];
						cp0Cause_o[22] <= cp0WriteData_i[22];
					end
					`CP0_REG_EBASE: begin
						cp0EBase_o[29:12] <= cp0WriteData_i[29:12];
					end
				endcase
			end
		end
	end

	always @ (*) begin
		if(rst == `Enable) begin
			cp0Data_o <= `ZeroWord;
		end else begin
				case (cp0ReadAddr_i)
					`CP0_REG_COUNT:		begin
						cp0Data_o <= cp0Count_o ;
					end
					`CP0_REG_COMPARE:	begin
						cp0Data_o <= cp0Compare_o ;
					end
					`CP0_REG_STATUS:	begin
						cp0Data_o <= cp0Status_o ;
					end
					`CP0_REG_CAUSE:	begin
						cp0Data_o <= cp0Cause_o ;
					end
					`CP0_REG_EPC:	begin
						cp0Data_o <= cp0EPC_o ;
					end
					`CP0_REG_CONFIG:	begin
						cp0Data_o <= cp0Config_o ;
					end
					`CP0_REG_EBASE: begin
						cp0Data_o <= {2'b00,cp0EBase_o[29:12],2'b00,cp0EBase_o[9:0]};
					end
					default: 	begin
					end
				endcase
		end
	end

endmodule
