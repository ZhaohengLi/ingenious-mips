`include "defines.v"

module REG(
	input wire clk,
	input wire rst,

	input wire[`RegAddrBus] regWriteAddr_i,
	input wire[`RegBus] regWriteData_i,
	input wire regWriteEnable_i,

	input wire[`RegAddrBus] reg1Addr_i,
	input wire reg1Enable_i,
	output reg[`RegBus] reg1Data_o,

	input wire[`RegAddrBus] reg2Addr_i,
	input wire reg2Enable_i,
	output reg[`RegBus] reg2Data_o
);
    //registers 0 to 31
    reg[`RegBus] registers[0:`RegNum-1];
    //on posedge clk, if rst is enabled, check if write is enabled and writeReg isn't all 0, then write writeData to register[writeReg]
    always @(posedge clk) begin
        if(rst == `Enable) begin
            if((regWriteEnable_i == `Enable) && (regWriteAddr_i != `ZeroWord)) begin
                registers[regWriteAddr_i] <= regWriteData_i;
            end
        end
    end

    //any time, when rst is enabled or when read address is 0, set read data to 0
    //otherwise check read adress == write address, write and read both enabled, set read data to write data
    //otherwise if read is enabled, read data = register[read address]
    //otherwise read data = 0
    always @ (*) begin
        if((rst == `Enable) ||(reg1Addr_i == `ZeroWord)) begin
            reg1Data_o <= `ZeroWord;
        end else if(reg1Enable_i == `Enable) begin
            if((regWriteEnable_i == `Enable) && (reg1Addr_i == regWriteAddr_i)) begin
                reg1Data_o <= regWriteData_i;
            end else begin
                reg1Data_o <= registers[reg1Addr_i];
            end
        end
    end
    always @ (*) begin
        if((rst == `Enable) ||(reg2Addr_i == `ZeroWord)) begin
            reg2Data_o <= `ZeroWord;
        end else if(reg2Enable_i == `Enable) begin
            if((regWriteEnable_i == `Enable) && (reg2Addr_i == regWriteAddr_i)) begin
                reg2Data_o <= regWriteData_i;
            end else begin
                reg2Data_o <= registers[reg2Addr_i];
            end
        end
    end

endmodule
