module BOOT_ROM(
    input wire rst_i,
    input wire[31:0] romAddr_i,
    output reg[31:0] romData_o

);
    reg[31:0] instructions[0:1023];

    always @ (*) begin
        if (rst_i == 1'b1) begin
            romData_o <= 32'b0;
            instructions[0] <= 32'h3c09be00;
            instructions[1] <= 32'h3c0abe80;
            instructions[2] <= 32'h3c0b8000;
            instructions[3] <= 32'h112a0005;
            instructions[4] <= 32'h8d2c0000;
            instructions[5] <= 32'had6c0000;
            instructions[6] <= 32'h25290004;
            instructions[7] <= 32'h256b0004;
            instructions[8] <= 32'h1000fffa;
            instructions[9] <= 32'h3c0c8000;
            instructions[10] <= 32'h01800008;
            instructions[11] <= 32'h00000000;
        end else begin
            romData_o <= instructions[romAddr_i[11:2]];
        end
    end

endmodule
