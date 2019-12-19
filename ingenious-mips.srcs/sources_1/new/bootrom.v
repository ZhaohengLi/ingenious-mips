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
//instructions[0] <= 32'h3c09bfe0;
//instructions[1] <= 32'h354a0000;
//instructions[2] <= 32'h356b0001;
//instructions[3] <= 32'h358c0000;
//instructions[4] <= 32'h35ad0000;
//instructions[5] <= 32'h35ce0000;
//instructions[6] <= 32'h200101f4;
//instructions[7] <= 32'h102d000c;
//instructions[8] <= 32'h000d6a80;
//instructions[9] <= 32'h012d5020;
//instructions[10] <= 32'h014e5020;
//instructions[11] <= 32'h11ae0004;
//instructions[12] <= 32'had4c0000;
//instructions[13] <= 32'h25ad0001;
//instructions[14] <= 32'h25ce0001;
//instructions[15] <= 32'h0401fff6;
//instructions[16] <= 32'had4b0000;
//instructions[17] <= 32'h25ad0001;
//instructions[18] <= 32'h25ce0001;
//instructions[19] <= 32'h0401fff2;
//instructions[20] <= 32'h00000000;

        end else begin
            romData_o <= instructions[romAddr_i[11:2]];
        end
    end

endmodule
