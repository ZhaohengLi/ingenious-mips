`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2019 11:01:22 AM
// Design Name: 
// Module Name: Min_SOPC
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


module Min_SOPC(
    input wire clk,
    input wire rst
    );
    wire [31:0] inst_addr;
    wire [31:0] inst;
    wire rom_ce;
    
    IngeniousMIPS ingeniousmips1(
        .clock_btn(clk), .reset_btn(rst),
        .rom_addrOUT(inst_addr), .rom_dataIN(inst),
        .rom_ce(rom_ce)
    );
    
    ROM_instruct rom_instruct1(
        .ce(rom_ce), .address(inst_addr),
        .instruction(inst)
    );
    
endmodule
