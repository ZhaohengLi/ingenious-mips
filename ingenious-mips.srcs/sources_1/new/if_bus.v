`include "defines.v"

module IF_BUS(
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
	output reg[31:0] ramData_o,
	output reg[31:0] ramAddr_o,
	output reg[3:0]  ramSel_o,
	input  wire[31:0] ramData_i,
	input  wire       ramRdy_i,
	
	output reg       romEnable_o,
	output reg       romWriteEnable_o,
	output reg[31:0] romData_o,
	output reg[31:0] romAddr_o,
	output reg[3:0]  romSel_o,
	input  wire[31:0] romData_i,
	input  wire       romRdy_i
	
);

	reg[1:0] busState;

	always @ (posedge clk_i) begin
		if(rst_i == `Enable) begin
			busState <= `BUS_IDLE;
			ramAddr_o <= `ZeroWord;
			ramData_o <= `ZeroWord;
			ramSel_o <= 4'b0000;
			ramWriteEnable_o <= `Disable;
			ramEnable_o <= `Disable;
			romAddr_o <= `ZeroWord;
			romData_o <= `ZeroWord;
			romSel_o <= 4'b0000;
			romWriteEnable_o <= `Disable;
			romEnable_o <= `Disable;
		end else begin
			case (busState)
				`BUS_IDLE: begin
					if(cpuEnable_i == `Enable) begin
						if(`extRAM_Border_l <= cpuAddr_i && cpuAddr_i < `extRAM_Border_r) begin
							ramAddr_o <= cpuAddr_i - `extRAM_Border_l;
							ramData_o <= cpuData_i;
							if(cpuWriteEnable_i == `Enable) begin
							    ramSel_o <= cpuSel_i;
							end else begin
							    ramSel_o <= 4'hf;
							end
							ramWriteEnable_o <= cpuWriteEnable_i;
							ramEnable_o <= cpuEnable_i;
						end
						else if(`romBorder_l <= cpuAddr_i && cpuAddr_i < `romBorder_r) begin
							romAddr_o <= cpuAddr_i - `romBorder_l;
							romData_o <= cpuData_i;
							if(cpuWriteEnable_i == `Enable) begin
							    romSel_o <= cpuSel_i;
							end else begin
							    romSel_o <= 4'hf;
							end
							romWriteEnable_o <= cpuWriteEnable_i;
							romEnable_o <= cpuEnable_i;
						end
						busState <= `BUS_BUSY;
					end							
				end
				`BUS_BUSY: begin
					if(ramRdy_i == `Enable) begin
						ramAddr_o <= `ZeroWord;
						ramData_o <= `ZeroWord;
						ramSel_o <=  4'b0000;
						ramWriteEnable_o <= `Disable;
						ramEnable_o <= `Disable;
						busState <= `BUS_IDLE;
					end else if(romRdy_i == `Enable) begin
						romAddr_o <= `ZeroWord;
						romData_o <= `ZeroWord;
						romSel_o <=  4'b0000;
						romWriteEnable_o <= `Disable;
						romEnable_o <= `Disable;
						busState <= `BUS_IDLE;
					end
				end
				default: begin
				end 
			endcase
		end
	end
			

	always @ (*) begin
		if(rst_i == `Enable) begin
			stallReq <= `NoStop;
			cpuData_o <= `ZeroWord;
		end else begin
			case (busState)
				`BUS_IDLE: begin
					if(cpuEnable_i == `Enable) begin
						stallReq <= `Stop;
						cpuData_o <= `ZeroWord;				
					end
				end
				`BUS_BUSY: begin
					if(ramRdy_i == `Enable || romRdy_i == `Enable) begin
						stallReq <= `NoStop;
						if(cpuWriteEnable_i == `Disable) begin
							if(ramRdy_i == `Enable) begin
							    cpuData_o <= ramData_i;
							end else if(romRdy_i == `Enable) begin
							    cpuData_o <= romData_i;
							end
						end else begin
							cpuData_o <= `ZeroWord;
						end							
					end else begin
						stallReq <= `Stop;
						cpuData_o <= `ZeroWord;				
					end
				end
				default: begin
		          	stallReq <= `NoStop;
				end 
			endcase
		end
	end

endmodule
