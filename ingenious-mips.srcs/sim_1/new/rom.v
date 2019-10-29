module ROM(
    input wire romEnable_i,
    input wire[31:0] romAddr_i,
    output reg[31:0] romData_o
);

    reg[31:0] instractions[0:1024];

    initial begin
//        instractions[0] <= 32'h3402ffff;
//        instractions[1] <= 32'h00021400;
//        instractions[2] <= 32'h3442fff9;
//        instractions[3] <= 32'h34030003;
//        instractions[4] <= 32'h0043001a;
        instractions[0] <= 32'h34010001;
        instractions[1] <= 32'h08000008;
        instractions[2] <= 32'h34010002;
        instractions[3] <= 32'h34011111;
        instractions[4] <= 32'h34011100;
        instractions[5] <= 32'h00000000;
        instractions[6] <= 32'h00000000;
        instractions[7] <= 32'h00000000;
        instractions[8] <= 32'h34010003;
        instractions[9] <= 32'h0c000010;
        instractions[10] <= 32'h03e1001a;
        instractions[11] <= 32'h34010005;
        instractions[12] <= 32'h34010006;
        instractions[13] <= 32'h08000018;
        instractions[14] <= 32'h00000000;
        instractions[15] <= 32'h00000000;
        instractions[16] <= 32'h03e01009;
        instractions[17] <= 32'h00400825;
        instractions[18] <= 32'h34010009;
        instractions[19] <= 32'h3401000a;
        instractions[20] <= 32'h08000020;
        instractions[21] <= 32'h00000000;
        instractions[22] <= 32'h00000000;
        instractions[23] <= 32'h00000000;
        instractions[24] <= 32'h34010007;
        instractions[25] <= 32'h00400008;
        instractions[26] <= 32'h34010008;
        instractions[27] <= 32'h34011111;
        instractions[28] <= 32'h34011100;
        instractions[29] <= 32'h00000000;
        instractions[30] <= 32'h00000000;
        instractions[31] <= 32'h00000000;
        instractions[32] <= 32'h00000000;
        instractions[33] <= 32'h08000021;
        instractions[34] <= 32'h00000000;

    end

    always @ (*) begin
        if (romEnable_i == 1'b0) begin
            romData_o <= 32'b0;
        end else begin
            romData_o <= instractions[romAddr_i[11:2]];
        end
    end

endmodule;
