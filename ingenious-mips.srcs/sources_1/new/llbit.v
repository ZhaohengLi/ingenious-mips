`include "defines.v"

module LLBIT(
	input wire clk,
	input wire rst,
	input wire flush_i,
	input wire LLbitData_i,
	input wire LLbitWriteEnable_i,
	
	output reg LLbitData_o
);

    always @ (posedge clk) begin
	   if (rst == `Enable) begin
          LLbitData_o <= 1'b0;
		end else if(flush_i == 1'b1) begin
		  LLbitData_o <= 1'b0;
		end else if((LLbitWriteEnable_i == `Enable)) begin
		  LLbitData_o <= LLbitData_i;
		end
	end

endmodule
