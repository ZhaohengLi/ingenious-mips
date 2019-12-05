module FAKE_RAM(
	input wire clk,
	input wire ramEnable_i,
	input wire ramWriteEnable_i,
	input wire[31:0] ramAddr_i,
	input wire[3:0] ramSel_i,
	input wire[31:0] ramData_i,
	output reg[31:0] ramData_o
);
	`define MEM_SIZE 8192
	reg [31:0] inst_ram[`MEM_SIZE - 1:0];
	integer i;
	initial begin
    for(i = 0; i < `MEM_SIZE; i = i + 1)
        inst_ram[i] <= 32'h0;
	end
	
	reg[31:0] data_w;
	
	reg read_ready;
    wire stall;
	always @(posedge clk)
	begin
		if(ramEnable_i == `Disable) begin
			read_ready <= 1'b0;
		end else if( ramWriteEnable_i == `Disable && ~read_ready) begin
			read_ready <= 1'b1;
		end else begin
			read_ready <= 1'b0;
		end
	end
	assign stall = ( ramWriteEnable_i == `Enable) & ~read_ready;

	always @ (*) begin
	if(ramEnable_i == `Disable || ramWriteEnable_i == `Enable)
	begin
		ramData_o <= `ZeroWord;
	end else begin
		ramData_o <=  inst_ram[ramAddr_i[15:2]];
	end
	end
	
	always @ (*) begin
		if(ramWriteEnable_i == `Enable)
		begin
			data_w = inst_ram[ramAddr_i[15:2]];
			if(ramSel_i[0] == 1'b1) data_w[7:0]   = ramData_i[7:0];
			if(ramSel_i[1] == 1'b1) data_w[15:8]  = ramData_i[15:8];
			if(ramSel_i[2] == 1'b1) data_w[23:16] = ramData_i[23:16];
			if(ramSel_i[3] == 1'b1) data_w[31:24] = ramData_i[31:24];
		end else data_w = 32'h0;
	end
	
	always @(posedge clk)
	begin
		if(ramWriteEnable_i == `Enable) begin
			inst_ram[ramAddr_i[15:2]] <= data_w;
		end
	end

endmodule 