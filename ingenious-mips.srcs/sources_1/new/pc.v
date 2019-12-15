`include "defines.v"

module PC(
    input wire clk,
    input wire rst,
    input wire flush_i,
    input wire[5:0] stall_i,
    input wire branchFlag_i,//branch
    input wire[`RegBus] branchTargetAddr_i,
    input wire[`RegBus] newInstAddr_i,//error handler
    //mmu_inst_result
    input wire[31:0] physInstAddr_i,
    input wire[31:0] virtInstAddr_i,
    input wire instInvalid_i,
    input wire instMiss_i,
    input wire instDirty_i,
    input wire instIllegal_i,
    output reg[`InstAddrBus] instAddrForMMU_o,  //query to mmu
    output reg[`InstAddrBus] instAddrForBus_o, // addr to bus
    output reg[31:0] exceptionType_o,
    output reg ce_o
);

    always @(*) begin
  		if(instIllegal_i == 1'b1) begin
  			exceptionType_o <= {17'b0,1'b1,14'b0};   // EXCCODE_ADEL
  			instAddrForBus_o <= `ZeroWord;
  		end else if (instInvalid_i == 1'b1 || instMiss_i == 1'b1) begin
  			exceptionType_o <= {18'b0,1'b1,13'b0};   // EXCCODE_TLBL
  			instAddrForBus_o <= `ZeroWord;
        end else begin
  		    exceptionType_o <= `ZeroWord;
  		    instAddrForBus_o <= physInstAddr_i;
  	    end
  	end

    always @(posedge clk) begin
        if (rst == `Enable) ce_o <= `Disable;
        else ce_o <= `Enable;
    end

    always @(posedge clk) begin
        if (ce_o == `Disable || rst== `Enable) begin
            instAddrForMMU_o <= `PC_INIT_ADDR;//reset后 pc置为首地址
        end else begin
            if (flush_i == 1'b1) begin
                instAddrForMMU_o <= newInstAddr_i;
            end else if (stall_i[0] == `NoStop) begin
                if(branchFlag_i == `Branch) instAddrForMMU_o <= branchTargetAddr_i;
                else instAddrForMMU_o <= instAddrForMMU_o + 4'h4;
            end
        end
    end

endmodule
