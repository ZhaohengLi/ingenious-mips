`include "defines.v"

module CTRL(
  input wire rst,
  input wire stallReqID_i,
  input wire stallReqEX_i,
  output reg[5:0] stall_o
);
    always @ (*) begin
        if (rst == `Enable) begin
            stall_o <= 6'b000000;
        end else if (stallReqEX_i == `Stop) begin
            stall_o <= 6'b001111;
        end else if (stallReqID_i == `Stop) begin
            stall_o <= 6'b000111;
        end else begin
            stall_o <= 6'b000000;
        end
    end
    
endmodule