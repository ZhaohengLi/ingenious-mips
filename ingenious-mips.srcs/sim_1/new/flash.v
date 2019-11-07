
module FLASH(
	input wire clk_i,
	input wire rst_i,
	input wire[31:0] romAddr_i,
	output reg[31:0] romData_o,
	input wire romEnable_i,
	
	output reg [31:0] flash_Addr_o,
	input [7:0] flash_Data_i,
	output flash_rst_o,
	output flash_ce_o,
	output flash_oe_o,
	output flash_we_o,
	
    reg [3:0] waitstate
);

    //
    // Default address and data bus width
    //
    parameter aw = 19;   // number of address-bits
    parameter dw = 32;   // number of data-bits
    parameter ws = 4'h3; // number of wait-states

    assign flash_ce = romEnable_i;
    assign flash_we = 1'b1;
    assign flash_oe = romEnable_i;


    assign flash_rst = !wb_rst_i;

    always @(posedge clk_i) begin
        if(rst_i == 1'b1 ) begin
            waitstate <= 4'h0;
        end else if(romEnable_i == 1'b0) begin
            waitstate <= 4'h0;
            romData_o <= 32'h00000000;
        end else if(waitstate == 4'h0) begin
			waitstate <= waitstate + 4'h1;
			flash_Addr_o <= {10'b0000000000,romAddr_i[21:2],2'b00};
        end else begin
            waitstate <= waitstate + 4'h1;
			if(waitstate == 4'h3) begin
				romData_o[31:24] <= flash_dat_i;
				flash_Addr_o <= {10'b0000000000,romAddr_i[21:2],2'b01};
			end else if(waitstate == 4'h6) begin
				romData_o[23:16] <= flash_dat_i;
				flash_Addr_o <= {10'b0000000000,romAddr_i[21:2],2'b10};
			end else if(waitstate == 4'h9) begin
				romData_o[15:8] <= flash_dat_i;
				flash_Addr_o <= {10'b0000000000,romAddr_i[21:2],2'b11};
			end else if(waitstate == 4'hc) begin
				romData_o[7:0] <= flash_dat_i;
			end else if(waitstate == 4'hd) begin
				waitstate <= 4'h0;
            end
        end
    end

endmodule
