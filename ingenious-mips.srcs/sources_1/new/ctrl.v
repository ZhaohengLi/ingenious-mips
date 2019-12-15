`include "defines.v"

module CTRL(
  input wire rst,

  input wire stallReqFromIF_i,
  input wire stallReqFromID_i,

  input wire stallReqFromEX_i,
  input wire stallReqFromMEM_i,

  input wire[`RegBus] exceptionType_i,
  input wire[`RegBus] cp0EPC_i,
  input wire[`RegBus] cp0EBase_i,
  input wire[`RegBus] cp0Status_i,
  input wire[`RegBus] cp0Cause_i,

  output reg[`RegBus] newInstAddr_o,
  output reg[5:0] stall_o,
  output reg flush_o
);
    reg[31:0] base;

    always @ (*) begin
        if (rst == `Enable) begin
            stall_o <= 6'b000000;
            flush_o  <= 1'b0;
            newInstAddr_o <= `ZeroWord;
        end else if (exceptionType_i != `ZeroWord) begin
            flush_o <= 1'b1;
            stall_o <= 6'b000000;
            if (cp0Status_i[22]==1'b1) base <= 32'hbfc00200;
            else base <= {cp0EBase_i[31:12], 12'b0};
            
            case(exceptionType_i)
                32'h00000001: begin // int
                    if(cp0Cause_i[23] == 1'b1) newInstAddr_o <= base + 32'h200;
                    else newInstAddr_o <= base + 32'h180;
                end 
                32'h00000002: newInstAddr_o <= base + 32'h000; // tlbl
                32'h00000003: newInstAddr_o <= base + 32'h000; // tlbs
                32'h00000004: newInstAddr_o <= base + 32'h180; // adel
                32'h00000005: newInstAddr_o <= base + 32'h180; // ades
				32'h00000008: newInstAddr_o <= base + 32'h180; // sys
				32'h0000000a: newInstAddr_o <= base + 32'h180; // ri
				32'h0000000c: newInstAddr_o <= base + 32'h180; // ov
                32'h0000000d: newInstAddr_o <= base + 32'h180; // tr
				32'h0000000e: newInstAddr_o <= cp0EPC_i;       // eret
                32'h0000000f: newInstAddr_o <= base + 32'h180; // mod
				default	: begin
	            end
            endcase
        end else if (stallReqFromMEM_i == `Stop) begin
            stall_o <= 6'b011111;
            flush_o <= 1'b0;
        end else if (stallReqFromEX_i == `Stop) begin
            stall_o <= 6'b001111;
            flush_o <= 1'b0;
        end else if (stallReqFromID_i == `Stop) begin
            stall_o <= 6'b000111;
            flush_o <= 1'b0;
        end else if (stallReqFromIF_i == `Stop) begin
            stall_o <= 6'b000111;
            flush_o <= 1'b0;
        end else begin
            stall_o <= 6'b000000;
            flush_o <= 1'b0;
            newInstAddr_o <= `ZeroWord;
        end
    end

endmodule
