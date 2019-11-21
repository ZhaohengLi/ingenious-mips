module SRAM(
	input wire clk_i,
	input wire rst_i,
	input wire ramEnable_i,
	input wire ramWriteEnable_i,
	input wire[31:0] ramAddr_i,
	input wire[3:0] ramSel_i,
	input wire[31:0] ramData_i,
	output reg[31:0] ramData_o,
	
	output wire baseRAM_EN_o,
	output wire baseRAM_RE_o,
	output wire baseRAM_WE_o,
	output wire[3:0] baseRAM_BE_o,
	output wire[20:0] baseRAM_Addr_o,
	output reg[31:0] baseRAM_Data,
	
    reg [3:0] waitstate
);
	
	assign baseRAM_Addr_o = ramAddr_i;
	assign baseRAM_BE_o = ramSel_i;
	assign baseRAM_EN_o = ramEnable_i;
	assign baseRAM_WE_o = ramWriteEnable_i;
	assign baseRAM_RE_o = !ramWriteEnable_i;

    always @(posedge clk_i) begin
		if(rst_i == 1'b1) begin
			waitstate <= 4'h0;
		end if(ramEnable_i == `Disable) begin
			waitstate <= 4'h0;
		end else if(ramWriteEnable_i == `Enable) begin
			baseRAM_Data <= ramData_i;
		end else begin
			waitstate <= waitstate + 4'h0;
			if(waitstate == 4'h1) begin
				ramData_o <= baseRAM_Data;
				waitstate <= 4'h0;
			end
		end
    end

endmodule

