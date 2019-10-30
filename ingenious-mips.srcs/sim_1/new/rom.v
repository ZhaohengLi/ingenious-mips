module ROM(
    input wire romEnable_i,
    input wire[31:0] romAddr_i,
    output reg[31:0] romData_o
);

    reg[31:0] instractions[0:1024];

    initial begin
        $readmemh("/media/psf/Home/Projects/ingenious-mips/ingenious-mips.test/7_2.txt", instractions,0,100);
    end

    always @ (*) begin
        if (romEnable_i == 1'b0) begin
            romData_o <= 32'b0;
        end else begin
            romData_o <= instractions[romAddr_i[11:2]];
        end
    end

endmodule;
