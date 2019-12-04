`include "defines.v"

module DATA_BUS(
	input wire clk_i,
	input wire rst_i,
	
	input wire       cpuEnable_i,
	input wire       cpuWriteEnable_i,
	input wire[3:0]  cpuSel_i,
	input wire[31:0] cpuAddr_i,
	input wire[31:0] cpuData_i,
	output reg[31:0] cpuData_o,
	
	output reg stallReq,
	
	output reg       ramEnable_o,
	output reg       ramWriteEnable_o,
	output reg       uartEnable_o,
	output reg       uartWriteEnable_o,
	output reg[31:0] ramData_o,
	output reg[31:0] ramAddr_o,
	output reg[3:0]  ramSel_o,
	input  wire[31:0]ramData_i,
	input  wire      ramRdy_i
	
);

	reg[3:0] busState;

	always @ (posedge clk_i) begin
		if(rst_i == `Enable) begin
			busState <= `BUS_IDLE;
			ramAddr_o <= `ZeroWord;
			ramData_o <= `ZeroWord;
			ramSel_o <= 4'b0000;
			ramWriteEnable_o <= `Disable;
			ramEnable_o <= `Disable;
			uartWriteEnable_o <= `Disable;
			uartEnable_o <= `Disable;
		end else begin
			case (busState)
				`BUS_IDLE: begin
					if(cpuEnable_i == `Enable) begin
						if(`baseRAM_Border_l <= cpuAddr_i && cpuAddr_i < `baseRAM_Border_r) begin
							ramAddr_o <= cpuAddr_i - `baseRAM_Border_l;
							ramData_o <= cpuData_i;
							if(cpuWriteEnable_i == `Enable) begin
							    ramSel_o <= cpuSel_i;
							end else begin
							    ramSel_o <= 4'hf;
							end
							ramWriteEnable_o <= cpuWriteEnable_i;
							ramEnable_o <= cpuEnable_i;
                            uartWriteEnable_o <= `Disable;
                            uartEnable_o <= `Disable;
						end
						else if(`uartBorder_l <= cpuAddr_i && cpuAddr_i < `uartBorder_r) begin
							ramAddr_o <= cpuAddr_i - `uartBorder_l;
							ramData_o <= cpuData_i;
							if(cpuWriteEnable_i == `Enable) begin
							    ramSel_o <= cpuSel_i;
							end else begin
							    ramSel_o <= 4'hf;
							end
							uartWriteEnable_o <= cpuWriteEnable_i;
							uartEnable_o <= cpuEnable_i;
                            ramWriteEnable_o <= `Disable;
                            ramEnable_o <= `Disable;
						end else begin
						
						end
						busState <= `BUS_BUSY;
					end							
				end
				`BUS_BUSY: begin
					if(ramRdy_i == 1'b1) begin
						ramAddr_o <= `ZeroWord;
						ramData_o <= `ZeroWord;
						ramSel_o <=  4'b0000;
						ramWriteEnable_o <= `Disable;
						ramEnable_o <= `Disable;
						uartWriteEnable_o <= `Disable;
						uartEnable_o <= `Disable;
						busState <= `BUS_WAIT;
					end
				end
				`BUS_WAIT: begin
				    busState <= `BUS_IDLE;
				end
				default: begin
				    busState <= `BUS_IDLE;
				end
			endcase
		end
	end
	
	always @ (*) begin
		if(rst_i == `Enable) begin
			stallReq <= `NoStop;
			cpuData_o <= 32'h000000aa;
		end else begin
			case (busState)
				`BUS_IDLE: begin
					if(cpuEnable_i == `Enable) begin
						stallReq <= `Stop;
					end
				end
				`BUS_BUSY: begin
					if(ramRdy_i == 1'b1) begin
						stallReq <= `NoStop;
						if(cpuWriteEnable_i == `Disable) begin
							cpuData_o <= ramData_i;
						end
					end else begin
						stallReq <= `Stop;
					end
				end
				default: begin
		          	stallReq <= `NoStop;
				end 
			endcase
		end
	end
			

	/*always @ (*) begin
		if(rst == `Enable) begin
			stallReq <= `NoStop;
			cpuData_o <= `ZeroWord;
		end else begin
			stallReq <= `NoStop;
			case (wishboneState)
				`WB_IDLE: begin
					if(cpuEnable_i == `Enable) begin
						stallReq <= `Stop;
						cpuData_o <= `ZeroWord;				
					end
				end
				`WB_BUSY: begin
					if(ramRdy_i == `Enable || uartStall_i == `Enable) begin
						stallReq <= `NoStop;
						if(cpuWriteEnable_o == `Disable) begin
							cpuData_o <= regBuf;
						end else begin
							cpuData_o <= `ZeroWord;
						end							
					end else begin
						stallReq <= `Stop;
						cpuData_o <= `ZeroWord;				
					end
				end
				default: begin
				end 
			endcase
		end
	end*/

endmodule
