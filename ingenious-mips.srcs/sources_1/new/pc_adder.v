module PC_ADDER(
    input wire [31:0] instAddr_i,
    output reg [31:0] instAddr_o
);
    
    always @ (*) begin
        instAddr_o <= instAddr_i + 32'd4;
    end
    
endmodule
