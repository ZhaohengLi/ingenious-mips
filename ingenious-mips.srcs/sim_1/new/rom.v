module ROM(
    input wire romEnable_i,
    input wire[31:0] romAddr_i,
    output reg[31:0] romData_o
);

    reg[31:0] instractions[0:1024];

    initial begin
        instractions[0] <= 32'h3c010000;
        instractions[1] <= 32'h3c02ffff;
        instractions[2] <= 32'h3c030505;
        instractions[3] <= 32'h3c040000;
        instractions[4] <= 32'h0041200a;
        instractions[5] <= 32'h0061200b;
        instractions[6] <= 32'h0062200b;
        instractions[7] <= 32'h0043200a;
        instractions[8] <= 32'h00000011;
        instractions[9] <= 32'h00400011;
        instractions[10] <= 32'h00600011;
        instractions[11] <= 32'h00002010;
        instractions[12] <= 32'h00600013;
        instractions[13] <= 32'h00400013;
        instractions[14] <= 32'h00200013;
        instractions[15] <= 32'h00002012;
    end

    always @ (*) begin
        if (romEnable_i == 1'b0) begin
            romData_o <= 32'b0;
        end else begin
            romData_o <= instractions[romAddr_i[11:2]];
        end
    end

endmodule;
