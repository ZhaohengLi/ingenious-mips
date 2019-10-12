`include "defines"

module IF_ID(
    input wire clk,
    input wire rst,
    input wire[`InstAddrBus] instAddr_i,
    input wire[`InstBus] inst_i,
    
    output reg[`InstAddrBus] instAddr_o,
    output reg[`InstBus] inst_o
);

endmodule