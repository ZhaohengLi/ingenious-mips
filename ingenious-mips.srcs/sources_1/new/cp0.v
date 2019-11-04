`include "defines.v"

module CP0(
	input wire clk,
	input wire rst,
	input wire cp0WriteEnable_i, //we_i
	input wire[4:0] cp0WriteAddr_i,//waddr_i
	input wire[4:0] cp0ReadAddr_i,//raddr_i
	input wire[`RegBus] cp0WriteData_i,//data_i
	input wire[5:0] cp0Inte_i,//int_i

	output reg[`RegBus] cp0Data_o,//data_o
	output reg[`RegBus] cp0Count_o,//count_o
	output reg[`RegBus] cp0Compare_o,//compare_o
	output reg[`RegBus] cp0Status_o,//status_o
	output reg[`RegBus] cp0Cause_o,//cause_o
	output reg[`RegBus] cp0EPC_o,//epc_o
	output reg[`RegBus] cp0Config_o,//config_o
	output reg[`RegBus] cp0PRId_o,//prid_o
	output reg cp0TimerInte_o //timer_int_o
);

	always @ (posedge clk) begin
		if(rst == `Enable) begin
			cp0Count_o <= `ZeroWord;
			cp0Compare_o <= `ZeroWord;
			cp0Status_o <= 32'b00010000000000000000000000000000;
			cp0Cause_o <= `ZeroWord;
			cp0EPC_o <= `ZeroWord;
			cp0Config_o <= 32'b00000000000000001000000000000000;
			cp0PRId_o <= 32'b00000000010011000000000100000010;
			cp0TimerInte_o <= `InterruptNotAssert;
		end else begin
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
					`CP0_REG_PrId:	begin
						cp0Data_o <= cp0PRId_o ;
					end
					`CP0_REG_CONFIG:	begin
						cp0Data_o <= cp0Config_o ;
					end
					default: 	begin
					end
				endcase
		end
	end

endmodule
