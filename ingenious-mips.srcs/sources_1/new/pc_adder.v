`include "defines.v"

module PC_ADDER(
    input wire rst,
    input wire [31:0] instAddr_i,

    output reg [31:0] instAddr_o
);

    always @ (*) begin
        case (rst)
        `Enable : instAddr_o <= `ZeroWord;
        `Disable : instAddr_o <= instAddr_i + 32'd4;
        endcase
    end

endmodule
