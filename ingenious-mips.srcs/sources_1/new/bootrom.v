module BOOT_ROM(
    input wire rst_i,
    input wire[31:0] romAddr_i,
    output reg[31:0] romData_o

);
    reg[31:0] instructions[0:1023];

    always @ (*) begin
        if (rst_i == 1'b1) begin
            romData_o <= 32'b0;
            //ucore
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
            
            //for test
/*instructions[0] <= 32'h00094824;
instructions[1] <= 32'h3c09bfe0;
instructions[2] <= 32'h000d6824;
instructions[3] <= 32'h01a05025;
instructions[4] <= 32'h000a5280;
instructions[5] <= 32'h01495021;
instructions[6] <= 32'h000e7024;
instructions[7] <= 32'h014e5821;
instructions[8] <= 32'had6d0000;
instructions[9] <= 32'h25ce0001;
instructions[10] <= 32'h24010258;
instructions[11] <= 32'h15c1fffb;
instructions[12] <= 32'h25ad0001;
instructions[13] <= 32'h24010320;
instructions[14] <= 32'h15a1fff4;
instructions[15] <= 32'h00000000;*/

        end else begin
            romData_o <= instructions[romAddr_i[11:2]];
        end
    end

endmodule
