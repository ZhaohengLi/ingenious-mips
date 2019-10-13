`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2019 10:57:51 AM
// Design Name: 
// Module Name: ROM_instruct
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module ROM_instruct(
    input wire ce, //chip enable
    input wire [31:0] address,
    output reg [31:0] instruction
    );
    
    reg[31:0] mem_instruct[0:`InstMemNum - 1];
    
    initial $readmemh ("inst_rom.data", mem_instruct);
    
    always @(*) begin
        if(ce == `Disable) begin
            instruction <= `ZeroWord;
        end else begin
            instruction <= mem_instruct[address[`InstMemNumLog2 + 1: 2]];
        end
    end
endmodule
