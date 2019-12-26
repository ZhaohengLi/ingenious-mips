`include "defines.v"

module RAM(
	input wire clk_i,
	input wire rst_i,

	input wire ramEnable_i,
	input wire ramWriteEnable_i,
	input wire[31:0] ramData_i,
	input wire[31:0] ramAddr_i,
	input wire[3:0] ramSel_i,
	output reg[31:0] ramData_o,
	output reg ramRdy_o,
	
	output wire SRAM_CE_o,
	output reg SRAM_OE_o,
	output reg SRAM_WE_o,
	output wire[3:0] SRAM_BE_o,
	inout wire[31:0] SRAM_Data,
	output wire[19:0] SRAM_Addr_o
	
);

reg[3:0] ramState;

assign SRAM_BE_o = ~ramSel_i;
assign SRAM_Addr_o = ramAddr_i[21:2]; 
assign SRAM_CE_o = !ramEnable_i;
assign SRAM_Data = ramWriteEnable_i? ramData_i : 32'bz;

always @ (clk_i) begin
	if(rst_i == 1'b1) begin
		ramState <= 4'h0;
		ramRdy_o <= 1'b0;
		SRAM_WE_o <= 1'b1;
		SRAM_OE_o <= 1'b1;
	end else if(ramEnable_i == 1'b1) begin
		if(ramState == 4'h0)begin
			ramRdy_o <= 1'b0;
			ramState <= 4'h1;
			if(ramWriteEnable_i == `Enable) begin
				SRAM_OE_o <= 1'b1;
				SRAM_WE_o <= 1'b0;
			end else begin
				SRAM_OE_o <= 1'b0;
				SRAM_WE_o <= 1'b1;
			end
		end else begin
			ramState <= ramState + 4'h1;
			case(ramState)
				4'h2: begin
					if(ramWriteEnable_i == `Disable) begin
						ramData_o <= SRAM_Data;
					end
					ramRdy_o <= 1'b1;
					SRAM_WE_o <= 1'b1;
					SRAM_OE_o <= 1'b1;
				end
				4'h3: begin
					ramRdy_o <= 1'b0;
					ramState <= 4'h0;
				end
				default: begin
				end
			endcase
		end
	end else begin
		ramState <= 4'h0;
		ramRdy_o <= 1'b0;
		SRAM_WE_o <= 1'b1;
		SRAM_OE_o <= 1'b1;
	end
end

endmodule