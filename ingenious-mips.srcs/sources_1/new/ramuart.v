`include "defines.v"

module RAM_UART(
	input wire clk_i,
	input wire rst_i,

	input wire ramEnable_i,
	input wire ramWriteEnable_i,
	input wire uartEnable_i,
	input wire uartWriteEnable_i,
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
	output wire[19:0] SRAM_Addr_o,
	
    output reg uartRD_o,
    output reg uartWR_o,
    input wire uartDataReady_i, 
    input wire uartTBRE_i,
    input wire uartTSRE_i,
    
    output reg[1:0] uartReg_o
	
);

reg[3:0] ramState;

assign SRAM_BE_o = ~ramSel_i;
assign SRAM_Addr_o = ramAddr_i[21:2]; 
assign SRAM_CE_o = !(ramEnable_i && !uartEnable_i);
assign SRAM_Data = (ramWriteEnable_i || uartWriteEnable_i)? ramData_i : 32'bz;

always @ (*) begin
    if(uartDataReady_i == 1'b1) begin
        uartReg_o[1] <= 1'b1;
    end else if(uartDataReady_i == 1'b0) begin
        uartReg_o[1] <= 1'b0;
    end
end

always @ (clk_i) begin
	if(rst_i == 1'b1) begin
		SRAM_OE_o <= 1'b1;
		SRAM_WE_o <= 1'b1;
		uartRD_o <= 1'b1;
		uartWR_o <= 1'b1;
		ramState <= 4'h0;
		ramRdy_o <= 1'b0;
		uartReg_o[0] <= 1'b1;
	end else if(ramEnable_i == `Enable) begin
		if(ramState == 4'h0) begin
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
	end else if(uartEnable_i == `Enable) begin
		if(ramState == 4'h0) begin
			ramRdy_o <= 1'b0;
			if(uartWriteEnable_i == `Enable) begin
				uartWR_o <= 1'b0;
				ramState <= 4'h1;
			end else begin
			    uartReg_o[0] <= 1'b0;
				uartRD_o <= 1'b1;
				ramState <= 4'h9;
			end
		end else begin
			case(ramState)
				4'h1: begin
					uartWR_o <= 1'b1;
					ramState <= ramState + 4'h1;
				end
				4'h2: begin
					if(uartTBRE_i == 1'b1) begin
						ramState <= ramState + 4'h1;
					end
				end
				4'h3: begin
					if(uartTSRE_i == 1'b1) begin
						ramRdy_o <= 1'b1;
						ramState <= ramState + 4'h1;
					end
				end
				4'h4: begin
					ramRdy_o <= 1'b0;
					ramState <= 4'h0;
				end
				4'h9: begin
					if(uartDataReady_i == 1'b1) begin
						uartRD_o <= 1'b0;
						ramState <= ramState + 4'h1;
					end
				end
				4'ha: begin
				    ramData_o <= {24'b0,SRAM_Data[7:0]};
				    uartReg_o[0] <= 1'b1;
					uartRD_o <= 1'b1;
					ramRdy_o <= 1'b1;
					ramState <= ramState + 4'h1;
				end
				4'hb: begin
					ramRdy_o <= 1'b0;
					ramState <= 4'h0;
				end
				default: begin
				end
			endcase
		end
		
	end else begin
		SRAM_OE_o <= 1'b1;
		SRAM_WE_o <= 1'b1;
		uartRD_o <= 1'b1;
		uartWR_o <= 1'b1;
		ramState <= 4'h0;
		ramRdy_o <= 1'b0;
		uartReg_o[0] <= 1'b1;
	end
end

endmodule