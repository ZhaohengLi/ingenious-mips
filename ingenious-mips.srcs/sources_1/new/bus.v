`include "defines.v"

module BUS(
	input wire clk_i,
	input wire rst_i,
	input wire flush_i,
	
	input wire       ifEnable_i,
	input wire       ifWriteEnable_i,
	input wire[3:0]  ifSel_i,
	input wire[31:0] ifAddr_i,
	input wire[31:0] ifData_i,
	output reg[31:0] ifData_o,
	
	input wire       dataEnable_i,
	input wire       dataWriteEnable_i,
	input wire[3:0]  dataSel_i,
	input wire[31:0] dataAddr_i,
	input wire[31:0] dataData_i,
	output reg[31:0] dataData_o,
	
	output reg ifStallReq_o,
	output reg dataStallReq_o,
	
	output reg        baseRAM_Enable_o,
	output reg        baseRAM_WriteEnable_o,
	output reg[31:0]  baseRAM_Data_o,
	output reg[31:0]  baseRAM_Addr_o,
	output reg[3:0]   baseRAM_Sel_o,
	input  wire[31:0] baseRAM_Data_i,
	input  wire       baseRAM_Rdy_i,
	output reg        uartEnable_o,
	output reg        uartWriteEnable_o,
	input  wire       uartRdy_i,
	input  wire[1:0]  uartReg_i,
	
	output reg        extRAM_Enable_o,
	output reg        extRAM_WriteEnable_o,
	output reg[31:0]  extRAM_Data_o,
	output reg[31:0]  extRAM_Addr_o,
	output reg[3:0]   extRAM_Sel_o,
	input  wire[31:0] extRAM_Data_i,
	input  wire       extRAM_Rdy_i,
	
	output reg       romEnable_o,
	output reg       romWriteEnable_o,
	output reg[31:0] romData_o,
	output reg[31:0] romAddr_o,
	output reg[3:0]  romSel_o,
	input  wire[31:0]romData_i,
	input  wire      romRdy_i,
	
	output reg[31:0] bootromAddr_o,
	input wire[31:0] bootromData_i,
	
	input wire[9:0] hdata_i,
	input wire[9:0] vdata_i,
	output reg[7:0] displayData_o,
	
	output wire[15:0] leds_o,
	output wire[7:0]  num0_o,
	output wire[7:0]  num1_o
	
);

	reg[3:0] ifBusState;
	reg[3:0] dataBusState;
	
	reg[1:0] baseRAM_State;
	reg[1:0] extRAM_State;
	reg[1:0] romState;
	reg[1:0] bootromState;
	
	reg[15:0] leds;
	reg[7:0]  num_0;
	reg[7:0]  num_1;
	
    /*reg[1:0] displayMemory_0[799:0][599:0];
    reg[1:0] displayMemory_1[799:0][599:0];
    reg[1:0] displayMemory_2[799:0][599:0];
    reg[1:0] displayMemory_3[799:0][599:0];
    
    assign displayData_o = {displayMemory_3[hdata_i][vdata_i], displayMemory_2[hdata_i][vdata_i], displayMemory_1[hdata_i][vdata_i], displayMemory_0[hdata_i][vdata_i]};
    */
    
    reg[599:0] displayMemory[799:0];
    //assign displayData_o = (displayMemory[hdata_i][vdata_i] == 1'b1) ? 8'hff : 8'h00;
    
    reg jumpState;
    
    always @ (*) begin
        if(10'd0 <= hdata_i && hdata_i < 10'd800 && 10'd0 <= vdata_i && vdata_i <= 10'd600) begin
            if(displayMemory[hdata_i][vdata_i] == 1'b1) begin
                displayData_o <= 8'hff;
            end else begin
                displayData_o <= 8'h00;
            end
        end else begin
            displayData_o <= 8'h00;
        end
    end
    
    assign leds_o = leds;
    assign num0_o = num_0;
    assign num1_o = num_1;
    
	always @ (clk_i) begin
		if(rst_i == `Enable || flush_i == `Enable) begin
			ifBusState <= `BUS_IDLE;
			dataBusState <= `BUS_IDLE;
			baseRAM_State <= 2'b00;
			extRAM_State <= 2'b00;
			romState <= 2'b00;
			bootromState <= 2'b00;
			leds <= 16'h0;
			num_0 <= 8'hff;
			num_1 <= 8'hff;
		end else begin
			case(ifBusState)
				`BUS_IDLE: begin
					if(ifEnable_i == `Enable) begin
						if(`baseRAM_Border_l <= ifAddr_i && ifAddr_i < `baseRAM_Border_r) begin
							if(baseRAM_State[1] == 1'b0 && (dataEnable_i == `Disable || (!(`baseRAM_Border_l <= dataAddr_i && dataAddr_i < `baseRAM_Border_r) && dataAddr_i != `uartDataAddr))) begin
								baseRAM_State[0] <= 1'b1;
								ifBusState <= `BUS_BUSY_BASE_RAM;
							end
						end  else if(`extRAM_Border_l <= ifAddr_i && ifAddr_i < `extRAM_Border_r) begin
							if(extRAM_State[1] == 1'b0 && (dataEnable_i == `Disable || !(`extRAM_Border_l <= dataAddr_i && dataAddr_i < `extRAM_Border_r)) ) begin
								extRAM_State[0] <= 1'b1;
								ifBusState <= `BUS_BUSY_EXT_RAM;
							end
						end else if(`romBorder_l <= ifAddr_i && ifAddr_i < `romBorder_r) begin
							if(romState[1] == 1'b0 && (dataEnable_i == `Disable || !(`romBorder_l <= dataAddr_i && dataAddr_i < `romBorder_r))) begin
								romState[0] <= 1'b1;
								ifBusState <= `BUS_BUSY_ROM;
							end
						end else if(`bootrom_l <= ifAddr_i && ifAddr_i < `bootrom_r) begin
						    if(bootromState[1] == 1'b0 && (dataEnable_i == `Disable || !(`bootrom_l <= dataAddr_i && dataAddr_i < `bootrom_r))) begin
						        bootromState[0] <= 1'b1;
						        ifBusState <= `BUS_BUSY_BOOTROM;
						    end
						end else begin
						    ifBusState <= `BUS_ERROR;
						end
					end
				end
				`BUS_BUSY_BASE_RAM: begin
					if(baseRAM_Rdy_i == `Enable) begin
						baseRAM_State[0] <= 1'b0;
						ifBusState <= `BUS_IDLE;
					end
				end
				`BUS_BUSY_EXT_RAM: begin
					if(extRAM_Rdy_i == `Enable) begin
						extRAM_State[0] <= 1'b0;
						ifBusState <= `BUS_IDLE;
					end
				end
				`BUS_BUSY_ROM: begin
					if(romRdy_i == `Enable) begin
						romState[0] <= 1'b0;
						ifBusState <= `BUS_IDLE;
					end
				end
				`BUS_BUSY_BOOTROM: begin
				    bootromState[0] <= 1'b0;
				    ifBusState <= `BUS_IDLE;
				end
				default: begin
				end
			endcase
			
			case(dataBusState)
				`BUS_IDLE: begin
					if(dataEnable_i == `Enable) begin
						if(`baseRAM_Border_l <= dataAddr_i && dataAddr_i < `baseRAM_Border_r) begin
							if(baseRAM_State[0] == 1'b0) begin
								baseRAM_State[1] <= 1'b1;
								dataBusState <= `BUS_BUSY_BASE_RAM;
							end
						end else if(dataAddr_i == `uartDataAddr) begin
							if(baseRAM_State[0] == 1'b0) begin
								baseRAM_State[1] <= 1'b1;
								dataBusState <= `BUS_BUSY_BASE_RAM;
							end
						end else if(dataAddr_i == `uartRegAddr) begin
						    dataBusState <= `BUS_UART_REG;
						end else if(`extRAM_Border_l <= dataAddr_i && dataAddr_i < `extRAM_Border_r) begin
							if(extRAM_State[0] == 1'b0) begin
								extRAM_State[1] <= 1'b1;
								dataBusState <= `BUS_BUSY_EXT_RAM;
							end
						end else if(`romBorder_l <= dataAddr_i && dataAddr_i < `romBorder_r) begin
							if(romState[0] == 1'b0) begin
								romState[1] <= 1'b1;
								dataBusState <= `BUS_BUSY_ROM;
							end
						end else if(`bootrom_l <= dataAddr_i && dataAddr_i < `bootrom_r) begin
						    if(bootromState[0] == 1'b0) begin
						        bootromState[1] <= 1'b1;
						        dataBusState <= `BUS_BUSY_BOOTROM;
						    end
						end else if(`displayMemory_l <= dataAddr_i && dataAddr_i < `displayMemory_r) begin
						    /*displayMemory_0[dataAddr_i[19:0]][dataAddr_i[9:0]] <= dataData_i[1:0];
						    displayMemory_1[dataAddr_i[19:0]][dataAddr_i[9:0]] <= dataData_i[3:2];
						    displayMemory_2[dataAddr_i[19:0]][dataAddr_i[9:0]] <= dataData_i[5:4];
						    displayMemory_3[dataAddr_i[19:0]][dataAddr_i[9:0]] <= dataData_i[7:6];*/
						    displayMemory[dataAddr_i[21:12]][dataAddr_i[11:2]] <= dataData_i[0];
						    dataBusState <= `BUS_WAIT;
						end else if(`ledAddr == dataAddr_i) begin
						    leds <= dataData_i[15:0];
						    dataBusState <= `BUS_WAIT;
						end else if(dataAddr_i == `numAddr) begin
                            case (dataData_i[3:0])
                                4'h0: begin
                                    num_0 <= 8'b01111110;
                                end
                                4'h1: begin
                                    num_0 <= 8'b00010010;
                                end
                                4'h2: begin
                                    num_0 <= 8'b10111100;
                                end
                                4'h3: begin
                                    num_0 <= 8'b10110110;
                                end
                                4'h4: begin
                                    num_0 <= 8'b11010010;
                                end
                                4'h5: begin
                                    num_0 <= 8'b11100110;
                                end
                                4'h6: begin
                                    num_0 <= 8'b11101110;
                                end
                                4'h7: begin
                                    num_0 <= 8'b00110010;
                                end
                                4'h8: begin
                                    num_0 <= 8'b11111110;
                                end
                                4'h9: begin
                                    num_0 <= 8'b11110110;
                                end
                                4'ha: begin
                                    num_0 <= 8'b10001110;
                                end
                                4'hb: begin
                                    num_0 <= 8'b11001110;
                                end
                                4'hc: begin
                                    num_0 <= 8'b10001100;
                                end
                                4'hd: begin
                                    num_0 <= 8'b10011110;
                                end
                                4'he: begin
                                    num_0 <= 8'b11101100;
                                end
                                4'hf: begin
                                    num_0 <= 8'b11101000;
                                end
                            endcase
                            case (dataData_i[7:4])
                                4'h0: begin
                                    num_1 <= 8'b01111110;
                                end
                                4'h1: begin
                                    num_1 <= 8'b00010010;
                                end
                                4'h2: begin
                                    num_1 <= 8'b10111100;
                                end
                                4'h3: begin
                                    num_1 <= 8'b10110110;
                                end
                                4'h4: begin
                                    num_1 <= 8'b11010010;
                                end
                                4'h5: begin
                                    num_1 <= 8'b11100110;
                                end
                                4'h6: begin
                                    num_1 <= 8'b11101110;
                                end
                                4'h7: begin
                                    num_1 <= 8'b00110010;
                                end
                                4'h8: begin
                                    num_1 <= 8'b11111110;
                                end
                                4'h9: begin
                                    num_1 <= 8'b11110110;
                                end
                                4'ha: begin
                                    num_1 <= 8'b10001110;
                                end
                                4'hb: begin
                                    num_1 <= 8'b11001110;
                                end
                                4'hc: begin
                                    num_1 <= 8'b10001100;
                                end
                                4'hd: begin
                                    num_1 <= 8'b10011110;
                                end
                                4'he: begin
                                    num_1 <= 8'b11101100;
                                end
                                4'hf: begin
                                    num_1 <= 8'b11101000;
                                end
                            endcase
                            dataBusState <= `BUS_WAIT;
						end else if(dataAddr_i == `JUMPSTATE) begin
						    if(dataWriteEnable_i == `Enable) begin
						        jumpState <= dataData_i[0];
						        dataBusState <= `BUS_WAIT;
				            end else begin
						        dataBusState <= `BUS_MAGIC;
						    end
						end else begin
						    dataBusState <= `BUS_ERROR;
						end
					end
				end
				`BUS_BUSY_BASE_RAM: begin
					if(baseRAM_Rdy_i == `Enable) begin
						baseRAM_State[1] <= 1'b0;
						dataBusState <= `BUS_WAIT;
					end
				end
				`BUS_BUSY_EXT_RAM: begin
					if(extRAM_Rdy_i == `Enable) begin
						extRAM_State[1] <= 1'b0;
						dataBusState <= `BUS_WAIT;
					end
				end
				`BUS_BUSY_ROM: begin
					if(romRdy_i == `Enable) begin
						romState[1] <= 1'b0;
						dataBusState <= `BUS_WAIT;
					end
				end
				`BUS_ERROR: begin
				    dataBusState <= `BUS_WAIT;
				end
				`BUS_WAIT: begin
				    dataBusState <= `BUS_IDLE;
				end
				`BUS_UART_REG: begin
				    dataBusState <= `BUS_WAIT;
				end
				`BUS_MAGIC: begin
				    dataBusState <= `BUS_IDLE;
				end
				`BUS_BUSY_BOOTROM: begin
				    bootromState[1] <= 1'b0;
					dataBusState <= `BUS_WAIT;
				end
				default: begin
				end
			endcase
			
		end
	end
	
	always @ (baseRAM_State) begin
		case(baseRAM_State)
			2'b00: begin
				baseRAM_Addr_o <= `ZeroWord;
				baseRAM_Data_o <= `ZeroWord;
				baseRAM_Sel_o <=  4'b0000;
				baseRAM_WriteEnable_o <= `Disable;
				baseRAM_Enable_o <= `Disable;
				uartWriteEnable_o <= `Disable;
				uartEnable_o <= `Disable;
			end
			2'b01: begin
				baseRAM_Data_o <= ifData_i;
				if(`baseRAM_Border_l <= ifAddr_i && ifAddr_i < `baseRAM_Border_r) begin
					baseRAM_Addr_o <= ifAddr_i - `baseRAM_Border_l;
					baseRAM_WriteEnable_o <= ifWriteEnable_i;
					baseRAM_Enable_o <= ifEnable_i;
					uartWriteEnable_o <= `Disable;
					uartEnable_o <= `Disable;
				end else begin
					baseRAM_Addr_o <= ifAddr_i - `uartDataAddr;
					baseRAM_WriteEnable_o <= `Disable;
					baseRAM_Enable_o <= `Disable;
					uartWriteEnable_o <= ifWriteEnable_i;
					uartEnable_o <= ifEnable_i;
				end
				if(ifWriteEnable_i == `Enable) begin
					baseRAM_Sel_o <= ifSel_i;
				end else begin
					baseRAM_Sel_o <= 4'hf;
				end
			end
			2'b10: begin
				baseRAM_Data_o <= dataData_i;
				if(`baseRAM_Border_l <= dataAddr_i && dataAddr_i < `baseRAM_Border_r) begin
					baseRAM_Addr_o <= dataAddr_i - `baseRAM_Border_l;
					baseRAM_WriteEnable_o <= dataWriteEnable_i;
					baseRAM_Enable_o <= dataEnable_i;
					uartWriteEnable_o <= `Disable;
					uartEnable_o <= `Disable;
				end else begin
					baseRAM_Addr_o <= dataAddr_i - `uartDataAddr;
					baseRAM_WriteEnable_o <= `Disable;
					baseRAM_Enable_o <= `Disable;
					uartWriteEnable_o <= dataWriteEnable_i;
					uartEnable_o <= dataEnable_i;
				end
				if(dataWriteEnable_i == `Enable) begin
					baseRAM_Sel_o <= dataSel_i;
				end else begin
					baseRAM_Sel_o <= 4'hf;
				end
			end
			default: begin
			end
		endcase
	end
			
	always @ (extRAM_State) begin
		case(extRAM_State)
			2'b00: begin
				extRAM_Addr_o <= `ZeroWord;
				extRAM_Data_o <= `ZeroWord;
				extRAM_Sel_o <=  4'b0000;
				extRAM_WriteEnable_o <= `Disable;
				extRAM_Enable_o <= `Disable;
			end
			2'b01: begin
				extRAM_Addr_o <= ifAddr_i - `extRAM_Border_l;
				extRAM_Data_o <= ifData_i;
				if(ifWriteEnable_i == `Enable) begin
					extRAM_Sel_o <= ifSel_i;
				end else begin
					extRAM_Sel_o <= 4'hf;
				end
				extRAM_WriteEnable_o <= ifWriteEnable_i;
				extRAM_Enable_o <= ifEnable_i;
			end
			2'b10: begin
				extRAM_Addr_o <= dataAddr_i - `extRAM_Border_l;
				extRAM_Data_o <= dataData_i;
				if(dataWriteEnable_i == `Enable) begin
					extRAM_Sel_o <= dataSel_i;
				end else begin
					extRAM_Sel_o <= 4'hf;
				end
				extRAM_WriteEnable_o <= dataWriteEnable_i;
				extRAM_Enable_o <= dataEnable_i;
			end
			default: begin
			end
		endcase
	end
	
	always @ (romState) begin
		case(romState)
			2'b00: begin
				romAddr_o <= `ZeroWord;
				romData_o <= `ZeroWord;
				romSel_o <=  4'b0000;
				romWriteEnable_o <= `Disable;
				romEnable_o <= `Disable;
			end
			2'b01: begin
				romAddr_o <= ifAddr_i - `romBorder_l;
				romData_o <= ifData_i;
				if(ifWriteEnable_i == `Enable) begin
					romSel_o <= ifSel_i;
				end else begin
					romSel_o <= 4'hf;
				end
				romWriteEnable_o <= ifWriteEnable_i;
				romEnable_o <= ifEnable_i;
			end
			2'b10: begin
				romAddr_o <= dataAddr_i - `romBorder_l;
				romData_o <= dataData_i;
				if(dataWriteEnable_i == `Enable) begin
					romSel_o <= dataSel_i;
				end else begin
					romSel_o <= 4'hf;
				end
				romWriteEnable_o <= dataWriteEnable_i;
				romEnable_o <= dataEnable_i;
			end
			default: begin
			end
		endcase
	end
	
	always @ (bootromState) begin
		case(bootromState)
			2'b00: begin
				bootromAddr_o <= `ZeroWord;
			end
			2'b01: begin
				bootromAddr_o <= ifAddr_i - `bootrom_l;
			end
			2'b10: begin
				bootromAddr_o <= dataAddr_i - `bootrom_l;
			end
			default: begin
			end
		endcase
	end

	always @ (*) begin
		if(rst_i == `Enable||| flush_i == `Enable) begin
			dataStallReq_o <= `NoStop;
			dataData_o <= `ZeroWord;
		end else begin
			case (dataBusState)
				`BUS_IDLE: begin
					if(dataEnable_i == `Enable) begin
						dataStallReq_o <= `Stop;
						dataData_o <= `ZeroWord;
					end else if(dataEnable_i == `Disable) begin
					    dataStallReq_o <= `NoStop;
						dataData_o <= `ZeroWord;
					end
				end
				`BUS_BUSY_BASE_RAM: begin
					if(baseRAM_Rdy_i == `Enable) begin
						dataStallReq_o <= `NoStop;
						if(dataWriteEnable_i == `Disable) begin
							dataData_o <= baseRAM_Data_i;
						end else begin
							dataData_o <= `ZeroWord;
						end							
					end else begin
						dataStallReq_o <= `Stop;
						dataData_o <= `ZeroWord;				
					end
				end
				`BUS_BUSY_EXT_RAM: begin
					if(extRAM_Rdy_i == `Enable) begin
						dataStallReq_o <= `NoStop;
						if(dataWriteEnable_i == `Disable) begin
							dataData_o <= extRAM_Data_i;
						end else begin
							dataData_o <= `ZeroWord;
						end							
					end else begin
						dataStallReq_o <= `Stop;
						dataData_o <= `ZeroWord;				
					end
				end
				`BUS_BUSY_BOOTROM: begin
					dataStallReq_o <= `NoStop;
					dataData_o <= bootromData_i;
				end
				`BUS_BUSY_ROM: begin
					if(romRdy_i == `Enable) begin
						dataStallReq_o <= `NoStop;
						if(dataWriteEnable_i == `Disable) begin
							dataData_o <= romData_i;
						end else begin
							dataData_o <= `ZeroWord;
						end
					end else begin
						dataStallReq_o <= `Stop;
						dataData_o <= `ZeroWord;				
					end
				end
				`BUS_UART_REG: begin
				    dataData_o <= {30'b0, uartReg_i};
				    dataStallReq_o <= `NoStop;
				end
				`BUS_MAGIC: begin
				    dataData_o <= {31'b0, jumpState};
				    dataStallReq_o <= `NoStop;
				end
				`BUS_ERROR: begin
				    dataStallReq_o <= `NoStop;
				end
				default: begin
		          	dataStallReq_o <= `NoStop;
				end
			endcase
		end
	end
	
	always @ (*) begin
		if(rst_i == `Enable || flush_i == `Enable) begin
			ifStallReq_o <= `NoStop;
			ifData_o <= `ZeroWord;
		end else begin
			case (ifBusState)
				`BUS_IDLE: begin
					if(ifEnable_i == `Enable) begin
						ifStallReq_o <= `Stop;
						ifData_o <= `ZeroWord;
					end else if(ifEnable_i == `Disable) begin
						ifStallReq_o <= `NoStop;
						ifData_o <= `ZeroWord;
					end
				end
				`BUS_BUSY_BASE_RAM: begin
					if(baseRAM_Rdy_i == `Enable) begin
						ifStallReq_o <= `NoStop;
						if(ifWriteEnable_i == `Disable) begin
							ifData_o <= baseRAM_Data_i;
						end else begin
							ifData_o <= `ZeroWord;
						end							
					end else begin
						ifStallReq_o <= `Stop;
						ifData_o <= `ZeroWord;				
					end
				end
				`BUS_BUSY_EXT_RAM: begin
					if(extRAM_Rdy_i == `Enable) begin
						ifStallReq_o <= `NoStop;
						if(ifWriteEnable_i == `Disable) begin
							ifData_o <= extRAM_Data_i;
						end else begin
							ifData_o <= `ZeroWord;
						end							
					end else begin
						ifStallReq_o <= `Stop;
						ifData_o <= `ZeroWord;				
					end
				end
				`BUS_BUSY_ROM: begin
					if(romRdy_i == `Enable) begin
						ifStallReq_o <= `NoStop;
						if(ifWriteEnable_i == `Disable) begin
							ifData_o <= romData_i;
						end else begin
							ifData_o <= `ZeroWord;
						end
					end else begin
						ifStallReq_o <= `Stop;
						ifData_o <= `ZeroWord;				
					end
				end
				`BUS_BUSY_BOOTROM: begin
					ifStallReq_o <= `NoStop;
					ifData_o <= bootromData_i;
				end
				`BUS_UART_REG: begin
				    ifData_o <= {30'b0, uartReg_i};
				    ifStallReq_o <= `NoStop;
				end
				`BUS_ERROR: begin
				    ifStallReq_o <= `NoStop;
				end
				`BUS_WAIT: begin
				    ifStallReq_o <= `NoStop;
				end
				default: begin
		          	ifStallReq_o <= `NoStop;
				end
			endcase
		end
	end

endmodule
