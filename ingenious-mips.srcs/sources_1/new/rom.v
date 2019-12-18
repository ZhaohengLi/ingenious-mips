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

    output reg[22:0] flashAddr_o,      //Flash鍦板潃锛?0浠呭湪8bit妯″紡鏈夋晥锛?16bit妯″紡鏃犳剰涔?
    inout  wire[15:0] flashData,      //Flash鏁版嵁
    output wire flashRP_o,         //Flash澶嶄綅淇″彿锛屼綆鏈夋晥
    output wire flashVpen_o,         //Flash鍐欎繚鎶や俊鍙凤紝浣庣數骞虫椂涓嶈兘鎿﹂櫎銆佺儳鍐?
    output reg  flashCE_o,         //Flash鐗囬繅淇″彿锛屼綆鏈夋暱
    output reg  flashOE_o,         //Flash璇讳娇鑳戒俊鍙凤紝浣庢湁鏁?
    output wire flashWE_o,         //Flash鍐欎娇鑳戒俊鍙凤紝浣庢湁鏁?
    output wire flashByte_o       //Flash 8bit妯″紡閫夋嫨锛屼綆鏈夋晥銆傚湪浣跨敤flash鐨?16浣嶆ā寮忔椂璇疯涓?1
	
);

    reg[3:0] waitState;


    assign flashWE_o = 1'b1;
    assign flashRP_o = 1'b1;
	assign flashVpen_o = 1'b0;
	assign flashByte_o = 1'b1;

    always @(posedge clk_i) begin
        if(rst_i == 1'b1 ) begin
            waitState <= 4'h0;
            romData_o <= `ZeroWord;
			romRdy_o <= 1'b0;
			flashOE_o <= 1'b1;
			flashCE_o <= 1'b1;
        end else if(romEnable_i == 1'b0) begin
            waitState <= 4'h0;
            romData_o <= `ZeroWord;
			romRdy_o <= 1'b0;
			flashOE_o <= 1'b1;
			flashCE_o <= 1'b1;
        end else if(waitState == 4'h0) begin
			waitState <= waitState + 4'h1;
			flashAddr_o <= {romAddr_i[22:2],2'b00};
        end else begin
            waitState <= waitState + 4'h1;
            if(waitState == 4'h1) begin
			    flashCE_o <= 1'b0;
            end
            if(waitState == 4'h2) begin
                flashOE_o <= 1'b0;
            end
			if(waitState == 4'h5) begin
				romData_o[15:0] <= flashData;
				flashAddr_o <= {romAddr_i[22:2],2'b10};
			end else if(waitState == 4'h8) begin
				romData_o[31:16] <= flashData;  
				flashCE_o <= 1'b1;
				romRdy_o <= 1'b1;
			end else if(waitState == 4'h9) begin
				romRdy_o <= 1'b0;
				waitState <= 4'h0;
				flashOE_o <= 1'b1;
            end
        end
    end
endmodule