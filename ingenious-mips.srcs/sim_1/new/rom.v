module ROM(
    input wire romEnable_i,
    input wire[31:0] romAddr_i,
    output reg[31:0] romData_o
);

    reg[31:0] instractions[0:1024];
    
    initial begin
        instractions[0] <= 32'h34011100; //ori
        instractions[1] <= 32'h34020020; //ori
        instractions[2] <= 32'h00011882; //srl
        instractions[3] <= 32'h3c04ffff; //lui
    end
    
    always @ (*) begin
        if (romEnable_i == 1'b0) begin
            romData_o <= 32'b0;
        end else begin
            romData_o <= instractions[romAddr_i[11:2]];
        end
    end
    
endmodule;