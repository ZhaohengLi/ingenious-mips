module BOOT_ROM(
    input wire rst_i,
    input wire[31:0] romAddr_i,

    output reg[31:0] romData_o
    
);
    reg[31:0] instructions[0:1023];

    always @ (*) begin
        if (rst_i == 1'b1) begin
            romData_o <= 32'b0;
            instructions[0] <= 32'h00000000;
            instructions[1] <= 32'h10000001;
            instructions[2] <= 32'h00000000;
            instructions[3] <= 32'h3c08beff;
            instructions[4] <= 32'h3508fff8;
            instructions[5] <= 32'h240900ff;
            instructions[6] <= 32'had090000;
            instructions[7] <= 32'h3c10be00;
            instructions[8] <= 32'h240f0000;
            instructions[9] <= 32'h020f7821;
            instructions[10] <= 32'h8de90000;
            instructions[11] <= 32'h8def0004;
            instructions[12] <= 32'h000f7c00;
            instructions[13] <= 32'h012f4825;
            instructions[14] <= 32'h3c08464c;
            instructions[15] <= 32'h3508457f;
            instructions[16] <= 32'h11090003;
            instructions[17] <= 32'h00000000;
            instructions[18] <= 32'h10000042;
            instructions[19] <= 32'h00000000;
            instructions[20] <= 32'h240f0038;
            instructions[21] <= 32'h020f7821;
            instructions[22] <= 32'h8df10000;
            instructions[23] <= 32'h8def0004;
            instructions[24] <= 32'h000f7c00;
            instructions[25] <= 32'h022f8825;
            instructions[26] <= 32'h240f0058;
            instructions[27] <= 32'h020f7821;
            instructions[28] <= 32'h8df20000;
            instructions[29] <= 32'h8def0004;
            instructions[30] <= 32'h000f7c00;
            instructions[31] <= 32'h024f9025;
            instructions[32] <= 32'h3252ffff;
            instructions[33] <= 32'h240f0030;
            instructions[34] <= 32'h020f7821;
            instructions[35] <= 32'h8df30000;
            instructions[36] <= 32'h8def0004;
            instructions[37] <= 32'h000f7c00;
            instructions[38] <= 32'h026f9825;
            instructions[39] <= 32'h262f0008;
            instructions[40] <= 32'h000f7840;
            instructions[41] <= 32'h020f7821;
            instructions[42] <= 32'h8df40000;
            instructions[43] <= 32'h8def0004;
            instructions[44] <= 32'h000f7c00;
            instructions[45] <= 32'h028fa025;
            instructions[46] <= 32'h262f0010;
            instructions[47] <= 32'h000f7840;
            instructions[48] <= 32'h020f7821;
            instructions[49] <= 32'h8df50000;
            instructions[50] <= 32'h8def0004;
            instructions[51] <= 32'h000f7c00;
            instructions[52] <= 32'h02afa825;
            instructions[53] <= 32'h262f0004;
            instructions[54] <= 32'h000f7840;
            instructions[55] <= 32'h020f7821;
            instructions[56] <= 32'h8df60000;
            instructions[57] <= 32'h8def0004;
            instructions[58] <= 32'h000f7c00;
            instructions[59] <= 32'h02cfb025;
            instructions[60] <= 32'h12800010;
            instructions[61] <= 32'h00000000;
            instructions[62] <= 32'h12a0000e;
            instructions[63] <= 32'h00000000;
            instructions[64] <= 32'h26cf0000;
            instructions[65] <= 32'h000f7840;
            instructions[66] <= 32'h020f7821;
            instructions[67] <= 32'h8de80000;
            instructions[68] <= 32'h8def0004;
            instructions[69] <= 32'h000f7c00;
            instructions[70] <= 32'h010f4025;
            instructions[71] <= 32'hae880000;
            instructions[72] <= 32'h26d60004;
            instructions[73] <= 32'h26940004;
            instructions[74] <= 32'h26b5fffc;
            instructions[75] <= 32'h1ea0fff4;
            instructions[76] <= 32'h00000000;
            instructions[77] <= 32'h26310020;
            instructions[78] <= 32'h2652ffff;
            instructions[79] <= 32'h1e40ffd7;
            instructions[80] <= 32'h00000000;
            instructions[81] <= 32'h02600008;
            instructions[82] <= 32'h00000000;
            instructions[83] <= 32'h1000ffff;
            instructions[84] <= 32'h00000000;
            instructions[85] <= 32'h1000ffff;
            instructions[86] <= 32'h00000000;
            instructions[87] <= 32'h00000000;
        end else begin
            romData_o <= instructions[romAddr_i[11:2]];
        end
    end

endmodule