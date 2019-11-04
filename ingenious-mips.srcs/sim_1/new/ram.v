module RAM(
	input wire clk,
	input wire ramEnable_i,
	input wire ramWriteEnable_i,
	input wire[31:0] ramAddr_i,
	input wire[3:0] ramSel_i,
	input wire[31:0] ramData_i,
	output reg[31:0] ramData_o
);

	reg[7:0]  data_mem0[0:1023];
	reg[7:0]  data_mem1[0:1023];
	reg[7:0]  data_mem2[0:1023];
	reg[7:0]  data_mem3[0:1023];

	always @ (posedge clk) begin
		if (ramEnable_i == `Disable) begin
			//ramData_o <= ZeroWord;
		end else if(ramWriteEnable_i == `Enable) begin
			  if (ramSel_i[3] == 1'b1) begin
		      data_mem3[ramAddr_i[11:2]] <= ramData_i[31:24];
		    end
			  if (ramSel_i[2] == 1'b1) begin
		      data_mem2[ramAddr_i[11:2]] <= ramData_i[23:16];
		    end
		    if (ramSel_i[1] == 1'b1) begin
		      data_mem1[ramAddr_i[11:2]] <= ramData_i[15:8];
		    end
			  if (ramSel_i[0] == 1'b1) begin
		      data_mem0[ramAddr_i[11:2]] <= ramData_i[7:0];
		    end
		end
	end

	always @ (*) begin
		if (ramEnable_i == `Disable) begin
			ramData_o <= `ZeroWord;
	  end else if(ramWriteEnable_i == `Disable) begin
		    ramData_o <= {data_mem3[ramAddr_i[11:2]],
		               data_mem2[ramAddr_i[11:2]],
		               data_mem1[ramAddr_i[11:2]],
		               data_mem0[ramAddr_i[11:2]]};
		end else begin
				ramData_o <= `ZeroWord;
		end
	end

endmodule
