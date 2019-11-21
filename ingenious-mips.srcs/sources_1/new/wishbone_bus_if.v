
`include "defines.v"

module WISHBONE_BUS_IF(

	input wire clk,
	input wire rst,
	
	//ctrl
	input wire[5:0] stall_i,
	input 			flush_i,
	
	//CPU
	input wire 			cpuCE_i,
	input wire[`RegBus] cpuData_i,
	input wire[`RegBus] cpuAddr_i,
	input wire          cpuWE_i,
	input wire[3:0]     cpuSel_i,
	output reg[`RegBus] cpuData_o,
	
	//Wishbone
	input wire[`RegBus] wishboneData_i,
	input wire          wishboneAck_i,
	output reg[`RegBus] wishboneAddr_o,
	output reg[`RegBus] wishboneData_o,
	output reg          wishboneWE_o,
	output reg[3:0]     wishboneSel_o,
	output reg          wishboneStb_o,
	output reg          wishboneCyc_o,

	output reg          stallReq	       
	
);

  reg[1:0] wishboneState;
  reg[`RegBus] rdBuf;

	always @ (posedge clk) begin
		if(rst == `Enable) begin
			wishboneState <= `WB_IDLE;
			wishboneAddr_o <= `ZeroWord;
			wishboneData_o <= `ZeroWord;
			wishboneWE_o <= `Disable;
			wishboneSel_o <= 4'b0000;
			wishboneStb_o <= 1'b0;
			wishboneCyc_o <= 1'b0;
			rdBuf <= `ZeroWord;
//			cpuData_o <= `ZeroWord;
		end else begin
			case (wishboneState)
				`WB_IDLE: begin
					if((cpuCE_i == 1'b1) && (flush_i == `False_v)) begin
						wishboneStb_o <= 1'b1;
						wishboneCyc_o <= 1'b1;
						wishboneAddr_o <= cpuAddr_i;
						wishboneData_o <= cpuData_i;
						wishboneWE_o <= cpuWE_i;
						wishboneSel_o <=  cpuSel_i;
						wishboneState <= `WB_BUSY;
						rdBuf <= `ZeroWord;
//					end else begin
//						wishboneState <= WB_IDLE;
//						wishboneAddr_o <= `ZeroWord;
//						wishboneData_o <= `ZeroWord;
//						wishboneWE_o <= `WriteDisable;
//						wishboneSel_o <= 4'b0000;
//						wishboneStb_o <= 1'b0;
//						wishboneCyc_o <= 1'b0;
//						cpuData_o <= `ZeroWord;			
					end							
				end
				`WB_BUSY: begin
					if(wishboneAck_i == 1'b1) begin
						wishboneStb_o <= 1'b0;
						wishboneCyc_o <= 1'b0;
						wishboneAddr_o <= `ZeroWord;
						wishboneData_o <= `ZeroWord;
						wishboneWE_o <= `Disable;
						wishboneSel_o <=  4'b0000;
						wishboneState <= `WB_IDLE;
						if(cpuWE_i == `Disable) begin
							rdBuf <= wishboneData_i;
						end
						
						if(stall_i != 6'b000000) begin
							wishboneState <= `WB_WAIT_FOR_STALL;
						end					
					end else if(flush_i == `True_v) begin
					  wishboneStb_o <= 1'b0;
						wishboneCyc_o <= 1'b0;
						wishboneAddr_o <= `ZeroWord;
						wishboneData_o <= `ZeroWord;
						wishboneWE_o <= `Disable;
						wishboneSel_o <=  4'b0000;
						wishboneState <= `WB_IDLE;
						rdBuf <= `ZeroWord;
					end
				end
				`WB_WAIT_FOR_STALL: begin
					if(stall_i == 6'b000000) begin
						wishboneState <= `WB_IDLE;
					end
				end
				default: begin
				end 
			endcase
		end
	end
			

	always @ (*) begin
		if(rst == `Enable) begin
			stallReq <= `NoStop;
			cpuData_o <= `ZeroWord;
		end else begin
			stallReq <= `NoStop;
			case (wishboneState)
				`WB_IDLE: begin
					if((cpuCE_i == 1'b1) && (flush_i == `False_v)) begin
						stallReq <= `Stop;
						cpuData_o <= `ZeroWord;				
					end
				end
				`WB_BUSY: begin
					if(wishboneAck_i == 1'b1) begin
						stallReq <= `NoStop;
						if(wishboneWE_o == `Disable) begin
							cpuData_o <= wishboneData_i;
						end else begin
						  cpuData_o <= `ZeroWord;
						end							
					end else begin
						stallReq <= `Stop;	
						cpuData_o <= `ZeroWord;				
					end
				end
				`WB_WAIT_FOR_STALL:		begin
					stallReq <= `NoStop;
					cpuData_o <= rdBuf;
				end
				default: begin
				end 
			endcase
		end
	end

endmodule