`include "defines.v"

module HILO(
    input wire clk,
    input wire rst,
    
    input wire regHILOEnable_i,
    input wire[`RegBus] regHI_i,
    input wire[`RegBus] regLO_i,
    
    output reg[`RegBus] regHI_o,
    output reg[`RegBus] regLO_o
    
);

    always @ (posedge clk) begin
        if(rst == `Enable) begin
            regHI_o <= `ZeroWord;
            regLO_o <= `ZeroWord;
        end else if (regHILOEnable_i == `Enable) begin
            regHI_o <= regHI_i;
            regLO_o <= regLO_i;
        end
    end
    
endmodule