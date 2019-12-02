`include "defines.v"

module ROM(

	input wire clk_i,
	input wire rst_i,
	
	input wire       romEnable_i,
	input wire       romWriteEnable_i,
	input wire[31:0] romData_i,
	input wire[31:0] romAddr_i,
	input wire[3:0]  romSel_i,
	output reg[31:0] romData_o,
	output reg       romRdy_o,

    output reg[22:0] flashAddr_o,      //Flash地址�?0仅在8bit模式有效�?16bit模式无意�?
    inout  wire[15:0] flashData,      //Flash数据
    output wire flashRP_o,         //Flash复位信号，低有效
    output wire flashVpen_o,         //Flash写保护信号，低电平时不能擦除、烧�?
    output wire flashCE_o,         //Flash片鿉信号，低有敿
    output wire flashOE_o,         //Flash读使能信号，低有�?
    output wire flashWE_o,         //Flash写使能信号，低有�?
    output wire flashByte_o       //Flash 8bit模式选择，低有效。在使用flash�?16位模式时请设�?1
	
);

    reg[3:0] waitState;


    assign flashCE_o = !romEnable_i;
    assign flashWE_o = 1'b1;
    assign flashOE_o = !romEnable_i;
    assign flashRP_o = !rst_i;
	assign flashVpen_o = 1'b0;
	assign flashByte_o = 1'b1;

    always @(posedge clk_i) begin
        if(rst_i == 1'b1 ) begin
            waitState <= 4'h0;
			romRdy_o <= 1'b0;
        end else if(romEnable_i == 1'b0) begin
            waitState <= 4'h0;
            romData_o <= `ZeroWord;
			romRdy_o <= 1'b0;
        end else if(waitState == 4'h0) begin
			waitState <= waitState + 4'h1;
			flashAddr_o <= {romAddr_i[22:2],2'b00};
        end else begin
            waitState <= waitState + 4'h1;
			if(waitState == 4'h3) begin
				romData_o[15:0] <= flashData;
				flashAddr_o <= {romAddr_i[22:2],2'b10};
			end else if(waitState == 4'h6) begin
				romData_o[31:16] <= flashData;  
				romRdy_o <= 1'b1;
			end else if(waitState == 4'h7) begin
				romRdy_o <= 1'b0;
				waitState <= 4'h0;
            end
        end
    end
endmodule