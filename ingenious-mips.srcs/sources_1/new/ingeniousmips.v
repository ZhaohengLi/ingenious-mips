module IngeniousMIPS(
    input wire clk_50M,           //50MHz 时钟输入
    input wire clk_11M0592,       //11.0592MHz 时钟输入（备用，可不用）

    input wire clock_btn,         //BTN5手动时钟按钮��?关，带消抖电路，按下时为1
    input wire reset_btn,         //BTN6手动复位按钮��?关，带消抖电路，按下时为1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4，按钮开关，按下时为1
    input  wire[31:0] dip_sw,     //32位拨码开关，拨到"ON"时为1
    output reg[15:0] leds,       //16位LED，输出时1点亮
    output wire[7:0]  dpy0,       //数码管低位信号，包括小数点，输出1点亮
    output wire[7:0]  dpy1,       //数码管高位信号，包括小数点，输出1点亮

    //CPLD串口控制器信��?
    output wire uart_rdn,         //读串口信号，低有��?
    output wire uart_wrn,         //写串口信号，低有��?
    input wire uart_dataready,    //串口数据准备��?
    input wire uart_tbre,         //发�?�数据标��?
    input wire uart_tsre,         //数据发�?�完毕标��?

    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共��?
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持��?0
    output wire base_ram_ce_n,       //BaseRAM片�?�，低有��?
    output wire base_ram_oe_n,       //BaseRAM读使能，低有��?
    output wire base_ram_we_n,       //BaseRAM写使能，低有��?

    //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持��?0
    output wire ext_ram_ce_n,       //ExtRAM片�?�，低有��?
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有��?
    output wire ext_ram_we_n,       //ExtRAM写使能，低有��?

    //直连串口信号
    output wire txd,  //直连串口发�?�端
    input  wire rxd,  //直连串口接收��?

    //Flash存储器信号，参�?? JS28F640 芯片手册
    output wire [22:0]flash_a,      //Flash地址，a0仅在8bit模式有效��?16bit模式无意��?
    inout  wire [15:0]flash_d,      //Flash数据
    output wire flash_rp_n,         //Flash复位信号，低有效
    output wire flash_vpen,         //Flash写保护信号，低电平时不能擦除、烧��?
    output wire flash_ce_n,         //Flash片�?�信号，低有��?
    output wire flash_oe_n,         //Flash读使能信号，低有��?
    output wire flash_we_n,         //Flash写使能信号，低有��?
    output wire flash_byte_n,       //Flash 8bit模式选择，低有效。在使用flash��?16位模式时请设��?1

    //USB 控制器信号，参�?? SL811 芯片手册
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //USB数据线与网络控制器的dm9k_sd[7:0]共享
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //网络控制器信号，参�?? DM9000A 芯片手册
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //图像输出信号
    output wire[2:0] video_red,    //红色像素��?3��?
    output wire[2:0] video_green,  //绿色像素��?3��?
    output wire[1:0] video_blue,   //蓝色像素��?2��?
    output wire video_hsync,       //行同步（水平同步）信��?
    output wire video_vsync,       //场同步（垂直同步）信��?
    output wire video_clk,         //像素时钟输出
    output wire video_de           //行数据有效信号，用于区分消隐��?
);

    wire[31:0] romAddr_cpu_to_rom;
    wire[31:0] romData_cpu_to_rom;
    wire[3:0] romSel_cpu_to_rom;
    wire romWriteEnable_cpu_to_rom;
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

    wire stall_if_bus_to_cpu;
    wire stall_data_bus_to_cpu;

    wire enable_bus_to_baseRAM;
    wire writeEnable_bus_to_baseRAM;
    wire[3:0] sel_bus_to_baseRAM;
    wire[`RegBus] data_bus_to_baseRAM;
    wire[`RegBus] addr_bus_to_baseRAM;
    wire[`RegBus] data_baseRAM_to_bus;
    wire rdy_baseRAM_to_bus;

    wire enable_bus_to_flash;
    wire writeEnable_bus_to_flash;
    wire[3:0] sel_bus_to_flash;
    wire[`RegBus] data_bus_to_flash;
    wire[`RegBus] addr_bus_to_flash;
    wire[`RegBus] data_flash_to_bus;
    wire rdy_flash_to_bus;

    wire enable_bus_to_extRAM;
    wire writeEnable_bus_to_extRAM;
    wire[3:0] sel_bus_to_extRAM;
    wire[`RegBus] data_bus_to_extRAM;
    wire[`RegBus] addr_bus_to_extRAM;
    wire[`RegBus] data_extRAM_to_bus;
    wire rdy_extRAM_to_bus;

    wire enable_bus_to_uart;
    wire writeEnable_bus_to_uart;
    wire[1:0] uartReg_uart_to_bus;

    reg already_read;
    always @ ( * ) begin
        if(uart_dataready == `Disable) begin
            already_read <= 1'b0;
        end else if(uart_dataready ==`Enable) begin
            if(stall_data_bus_to_cpu == 1'b1) begin
                already_read <= 1'b1;
            end
        end
    end
    assign cp0Inte_cpu_to_cpu = {cp0TimerInte_cpu_to_cpu, 4'b00, uart_dataready^already_read};

    CPU cpu1(
        .clk(clk_50M),
        .rst(reset_btn),

        .romStallReq_i(stall_if_bus_to_cpu),
        .ramStallReq_i(stall_data_bus_to_cpu),

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

    BUS bus(

        .clk_i(clk_50M),
        .rst_i(reset_btn),

        .ifEnable_i(romEnable_cpu_to_rom),
        .ifWriteEnable_i(`Disable),
        .ifSel_i(4'b1111),
        .ifAddr_i(romAddr_cpu_to_rom),
        .ifData_i(`ZeroWord),
        .ifData_o(romData_rom_to_cpu),

        .dataEnable_i(ramEnable_cpu_to_ram),
        .dataWriteEnable_i(ramWriteEnable_cpu_to_ram),
        .dataSel_i(ramSel_cpu_to_ram),
        .dataAddr_i(ramAddr_cpu_to_ram),
        .dataData_i(ramData_cpu_to_ram),
        .dataData_o(ramData_ram_to_cpu),

		.ifStallReq_o(stall_if_bus_to_cpu),
		.dataStallReq_o(stall_data_bus_to_cpu),

		.baseRAM_Enable_o(enable_bus_to_baseRAM),
		.baseRAM_WriteEnable_o(writeEnable_bus_to_baseRAM),
		.uartEnable_o(enable_bus_to_uart),
		.uartWriteEnable_o(writeEnable_bus_to_uart),
		.baseRAM_Data_o(data_bus_to_baseRAM),
		.baseRAM_Addr_o(addr_bus_to_baseRAM),
		.baseRAM_Sel_o(sel_bus_to_baseRAM),
		.baseRAM_Data_i(data_baseRAM_to_bus),
		.baseRAM_Rdy_i(rdy_baseRAM_to_bus),
		.uartReg_i(uartReg_uart_to_bus),

		.extRAM_Enable_o(enable_bus_to_extRAM),
		.extRAM_WriteEnable_o(writeEnable_bus_to_extRAM),
		.extRAM_Data_o(data_bus_to_extRAM),
		.extRAM_Addr_o(addr_bus_to_extRAM),
		.extRAM_Sel_o(sel_bus_to_extRAM),
		.extRAM_Data_i(data_extRAM_to_bus),
		.extRAM_Rdy_i(rdy_extRAM_to_bus),

		.romEnable_o(enable_bus_to_flash),
		.romWriteEnable_o(writeEnable_bus_to_flash),
		.romData_o(data_bus_to_flash),
		.romAddr_o(addr_bus_to_flash),
		.romSel_o(sel_bus_to_flash),
		.romData_i(data_flash_to_bus),
		.romRdy_i(rdy_flash_to_bus)

    );

    RAM ext_ram(

	   .clk_i(clk_50M),
	   .rst_i(reset_btn),

	   .ramEnable_i(enable_bus_to_extRAM),
	   .ramWriteEnable_i(writeEnable_bus_to_extRAM),
	   .ramData_i(data_bus_to_extRAM),
	   .ramAddr_i(addr_bus_to_extRAM),
	   .ramSel_i(sel_bus_to_extRAM),
	   .ramData_o(data_extRAM_to_bus),
	   .ramRdy_o(rdy_extRAM_to_bus),

	   .SRAM_CE_o(ext_ram_ce_n),
	   .SRAM_OE_o(ext_ram_oe_n),
	   .SRAM_WE_o(ext_ram_we_n),
	   .SRAM_BE_o(ext_ram_be_n),
	   .SRAM_Data(ext_ram_data),
	   .SRAM_Addr_o(ext_ram_addr)
    );

    ROM flash(

	   .clk_i(clk_50M),
	   .rst_i(reset_btn),

	   .romEnable_i(enable_bus_to_flash),
	   .romWriteEnable_i(writeEnable_bus_to_flash),
	   .romData_i(data_bus_to_flash),
	   .romAddr_i(addr_bus_to_flash),
	   .romSel_i(sel_bus_to_flash),
	   .romData_o(data_flash_to_bus),
	   .romRdy_o(rdy_flash_to_bus),

	   .flashAddr_o(flash_a),
	   .flashData(flash_d),
	   .flashRP_o(flash_rp_n),
	   .flashVpen_o(flash_vpen),
	   .flashCE_o(flash_ce_n),
	   .flashOE_o(flash_oe_n),
	   .flashWE_o(flash_we_n),
	   .flashByte_o(flash_byte_n)

    );

    RAM_UART base_ram(

	   .clk_i(clk_50M),
	   .rst_i(reset_btn),

	   .ramEnable_i(enable_bus_to_baseRAM),
	   .ramWriteEnable_i(writeEnable_bus_to_baseRAM),
	   .uartEnable_i(enable_bus_to_uart),
	   .uartWriteEnable_i(writeEnable_bus_to_uart),
	   .ramData_i(data_bus_to_baseRAM),
	   .ramAddr_i(addr_bus_to_baseRAM),
	   .ramSel_i(sel_bus_to_baseRAM),
	   .ramData_o(data_baseRAM_to_bus),
	   .ramRdy_o(rdy_baseRAM_to_bus),

	   .SRAM_CE_o(base_ram_ce_n),
	   .SRAM_OE_o(base_ram_oe_n),
	   .SRAM_WE_o(base_ram_we_n),
	   .SRAM_BE_o(base_ram_be_n),
	   .SRAM_Data(base_ram_data),
	   .SRAM_Addr_o(base_ram_addr),

	   .uartRD_o(uart_rdn),
	   .uartWR_o(uart_wrn),
	   .uartDataReady_i(uart_dataready),
	   .uartTBRE_i(uart_tbre),
	   .uartTSRE_i(uart_tsre),

	   .uartReg_o(uartReg_uart_to_bus)

    );

endmodule
