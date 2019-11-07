module SOPC(
    input wire clk,
    input wire rst
);

    wire[31:0] romAddr_cpu_to_rom;
    wire[31:0] romData_rom_to_cpu;
    wire romEnable_cpu_to_rom;
    wire[31:0] ramAddr_cpu_to_ram;
    wire[31:0] ramData_cpu_to_ram;
    wire[3:0] ramSel_cpu_to_ram;
    wire ramWriteEnable_cpu_to_ram;
    wire ramEnable_cpu_to_ram;
    wire[31:0] ramData_ram_to_cpu;
    wire[5:0] cp0Inte_cpu_to_cpu;
    wire cp0TimerInte_cpu_to_cpu;

    assign cp0Inte_cpu_to_cpu = {5'b0, cp0TimerInte_cpu_to_cpu};

    CPU cpu1(
        .clk(clk),
        .rst(rst),
        .romAddr_o(romAddr_cpu_to_rom),
        .romEnable_o(romEnable_cpu_to_rom),
        .romData_i(romData_rom_to_cpu),
        .ramData_i(ramData_ram_to_cpu),
        .ramAddr_o(ramAddr_cpu_to_ram),
        .ramData_o(ramData_cpu_to_ram),
        .ramSel_o(ramSel_cpu_to_ram),
        .ramWriteEnable_o(ramWriteEnable_cpu_to_ram),
        .ramEnable_o(ramEnable_cpu_to_ram),
        .cp0Inte_i(cp0Inte_cpu_to_cpu),
        .cp0TimerInte_o(cp0TimerInte_cpu_to_cpu)
    );

    ROM rom1(
        .romAddr_i(romAddr_cpu_to_rom),
        .romEnable_i(romEnable_cpu_to_rom),
        .romData_o(romData_rom_to_cpu)
    );

    RAM ram1(
        .clk(clk),
        .ramAddr_i(ramAddr_cpu_to_ram),
        .ramData_i(ramData_cpu_to_ram),
        .ramSel_i(ramSel_cpu_to_ram),
        .ramWriteEnable_i(ramWriteEnable_cpu_to_ram),
        .ramEnable_i(ramEnable_cpu_to_ram),
        .ramData_o(ramData_ram_to_cpu)
    );

endmodule;
