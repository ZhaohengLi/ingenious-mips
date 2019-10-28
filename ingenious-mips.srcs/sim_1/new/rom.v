module ROM(
    input wire romEnable_i,
    input wire[31:0] romAddr_i,
    output reg[31:0] romData_o
);

    reg[31:0] instractions[0:1024];

    initial begin
        instractions[0] <= 32'h3401ffff;
        instractions[1] <= 32'h00010c00;
        instractions[2] <= 32'h3421fffb;
        instractions[3] <= 32'h34020006;
        instractions[4] <= 32'h00220018; //mult $1 $2
        instractions[5] <= 32'h70220000;
        instractions[6] <= 32'h70220001;
        instractions[7] <= 32'h70220004;
        instractions[8] <= 32'h70220005;
    end

    always @ (*) begin
        if (romEnable_i == 1'b0) begin
            romData_o <= 32'b0;
        end else begin
            romData_o <= instractions[romAddr_i[11:2]];
        end
    end

endmodule;
