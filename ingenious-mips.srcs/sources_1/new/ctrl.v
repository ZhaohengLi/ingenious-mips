`include "defines.v"

module CTRL(
  input wire rst,
  input wire stallReqFromID_i,
  input wire stallReqFromEX_i,
  output reg[5:0] stall_o
);
    always @ (*) begin
        if (rst == `Enable) begin
            stall_o <= 6'b000000;
        end else if (stallReqFromEX_i == `Stop) begin
            stall_o <= 6'b001111;
        end else if (stallReqFromID_i == `Stop) begin
            stall_o <= 6'b000111;
        end else begin
            stall_o <= 6'b000000;
        end
    end

endmodule
