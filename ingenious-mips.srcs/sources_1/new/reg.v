`include "defines.v"

module REG(
	input wire clk,
	input wire rst,
	input wire[`RegAddrBus] regWriteAddr_i,
	input wire[`RegBus] regWriteData_i,
	input wire regWriteEnable_i,
	input wire[`RegAddrBus] reg1Addr_i,
	input wire reg1Enable_i,
	input wire[`RegAddrBus] reg2Addr_i,
	input wire reg2Enable_i,

	output reg[`RegBus] reg1Data_o,
	output reg[`RegBus] reg2Data_o
);

    reg[`RegBus] registers[0:`RegNum-1];
    integer i;

    always @(posedge clk) begin
        if(rst == `Enable) begin
            for(i=0; i<`RegNum; i=i+1) begin
                registers[i] = `ZeroWord;
            end
        end else begin
            if((regWriteEnable_i == `Enable) && (regWriteAddr_i != `ZeroWord)) begin
                registers[regWriteAddr_i] <= regWriteData_i;
            end
        end
    end

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
