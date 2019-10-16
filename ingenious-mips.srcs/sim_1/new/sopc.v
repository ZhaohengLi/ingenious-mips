module SOPC(
    input wire clk,
    input wire rst
);

    wire[31:0] instAddr;
    wire[31:0] inst;
    wire romEnable;
    
    CPU cpu1(
        .clk(clk), .rst(rst),
        .romAddr_o(instAddr), .romEnable_o(romEnable),
        .romData_i(inst)
    );
        
    ROM rom1(
        .romAddr_i(instAddr), .romEnable(romEnable),
        .romData_o(inst)
    );
    
endmodule;