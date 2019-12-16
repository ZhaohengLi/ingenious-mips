module IngeniousMIPS(
    input wire clk_50M,           //50MHz 鏃堕挓杈撳叆
    input wire clk_11M0592,       //11.0592MHz 鏃堕挓杈撳叆锛堝鐢紝鍙笉鐢級

    input wire clock_btn,         //BTN5鎵嬪姩鏃堕挓鎸夐挳锟斤拷?鍏筹紝甯︽秷鎶栫數璺紝鎸変笅鏃朵负1
    input wire reset_btn,         //BTN6鎵嬪姩澶嶄綅鎸夐挳锟斤拷?鍏筹紝甯︽秷鎶栫數璺紝鎸変笅鏃朵负1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4锛屾寜閽紑鍏筹紝鎸変笅鏃朵�?1
    input  wire[31:0] dip_sw,     //32浣嶆嫧鐮佸紑鍏筹紝鎷ㄥ埌"ON"鏃朵�?1
    output reg[15:0] leds,       //16浣峀ED锛岃緭鍑烘椂1鐐�?�寒
    output wire[7:0]  dpy0,       //鏁扮爜绠′綆浣嶄俊鍙凤紝鍖呮嫭灏忔暟鐐癸紝杈撳嚭1鐐�?�寒
    output wire[7:0]  dpy1,       //鏁扮爜绠￠珮浣嶄俊鍙凤紝鍖呮嫭灏忔暟鐐癸紝杈撳嚭1鐐�?�寒

    //CPLD涓插彛鎺у埗鍣ㄤ俊锟斤�??
    output wire uart_rdn,         //璇讳覆鍙ｄ俊鍙凤紝浣庢湁锟斤�??
    output wire uart_wrn,         //鍐欎覆鍙ｄ俊鍙凤紝浣庢湁锟斤�??
    input wire uart_dataready,    //涓插彛鏁版嵁鍑嗗锟斤拷?
    input wire uart_tbre,         //鍙戯�??锟芥暟鎹爣锟斤�??
    input wire uart_tsre,         //鏁版嵁鍙戯拷?锟藉畬姣曟爣锟斤�??

    //BaseRAM淇�?�彿
    inout wire[31:0] base_ram_data,  //BaseRAM鏁版嵁锛屼綆8浣嶄笌CPLD涓插彛鎺у埗鍣ㄥ叡锟斤�??
    output wire[19:0] base_ram_addr, //BaseRAM鍦板�?
    output wire[3:0] base_ram_be_n,  //BaseRAM瀛楄妭浣胯兘锛屼綆鏈夋晥銆傚鏋�?笉浣跨敤瀛楄妭浣胯兘锛岃淇濇寔锟斤�??0
    output wire base_ram_ce_n,       //BaseRAM鐗囷�??锟斤紝浣庢湁锟斤�??
    output wire base_ram_oe_n,       //BaseRAM璇讳娇鑳斤紝浣庢湁锟斤拷?
    output wire base_ram_we_n,       //BaseRAM鍐欎娇鑳斤紝浣庢湁锟斤拷?

    //ExtRAM淇�?�彿
    inout wire[31:0] ext_ram_data,  //ExtRAM鏁版�?
    output wire[19:0] ext_ram_addr, //ExtRAM鍦板�?
    output wire[3:0] ext_ram_be_n,  //ExtRAM瀛楄妭浣胯兘锛屼綆鏈夋晥銆傚鏋�?笉浣跨敤瀛楄妭浣胯兘锛岃淇濇寔锟斤�??0
    output wire ext_ram_ce_n,       //ExtRAM鐗囷�??锟斤紝浣庢湁锟斤�??
    output wire ext_ram_oe_n,       //ExtRAM璇讳娇鑳斤紝浣庢湁锟斤拷?
    output wire ext_ram_we_n,       //ExtRAM鍐欎娇鑳斤紝浣庢湁锟斤拷?

    //鐩磋繛涓插彛淇�?�彿
    output wire txd,  //鐩磋繛涓插彛鍙戯�??锟界�?
    input  wire rxd,  //鐩磋繛涓插彛鎺ユ敹锟斤拷?

    //Flash瀛樺偍鍣ㄤ俊鍙凤紝鍙傦拷?? JS28F640 鑺墖鎵嬪唽
    output wire [22:0]flash_a,      //Flash鍦板潃锛�?0浠呭�?8bit妯�?�紡鏈夋晥锟斤拷?16bit妯�?�紡鏃犳剰锟斤拷?
    inout  wire [15:0]flash_d,      //Flash鏁版�?
    output wire flash_rp_n,         //Flash澶嶄綅淇″彿锛屼綆鏈夋晥
    output wire flash_vpen,         //Flash鍐欎繚鎶や俊鍙凤紝浣庣數骞虫椂涓嶈兘鎿﹂櫎銆佺儳锟斤�??
    output wire flash_ce_n,         //Flash鐗囷�??锟戒俊鍙凤紝浣庢湁锟斤拷?
    output wire flash_oe_n,         //Flash璇讳娇鑳戒俊鍙凤紝浣庢湁锟斤�??
    output wire flash_we_n,         //Flash鍐欎娇鑳戒俊鍙凤紝浣庢湁锟斤�??
    output wire flash_byte_n,       //Flash 8bit妯�?�紡閫夋嫨锛屼綆鏈夋晥銆傚湪浣跨敤flash锟斤�??16浣嶆ā寮忔椂璇疯锟斤�??1

    //USB 鎺у埗鍣ㄤ俊鍙凤紝鍙傦�??? SL811 鑺墖鎵嬪唽
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //USB鏁版嵁绾夸笌缃戠粶鎺у埗鍣ㄧ殑dm9k_sd[7:0]鍏变�?
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //缃戠粶鎺у埗鍣ㄤ俊鍙凤紝鍙傦拷?? DM9000A 鑺墖鎵嬪唽
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //鍥惧儚杈撳嚭淇�?�彿
    output wire[2:0] video_red,    //绾㈣壊鍍忕礌锟斤�??3锟斤�??
    output wire[2:0] video_green,  //缁胯壊鍍忕礌锟斤�??3锟斤�??
    output wire[1:0] video_blue,   //钃濊壊鍍忕礌锟斤�??2锟斤�??
    output wire video_hsync,       //琛屽悓姝ワ紙姘村钩鍚屾锛変俊锟斤拷?
    output wire video_vsync,       //鍦哄悓姝ワ紙鍨傜洿鍚屾锛変俊锟斤拷?
    output wire video_clk,         //鍍忕礌鏃堕挓杈撳�?
    output wire video_de           //琛屾暟鎹湁鏁堜俊鍙凤紝鐢ㄤ簬鍖哄垎娑堥殣锟斤拷?
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
    
    /*reg[31:0] romAddr_cpu_to_rom;
    reg[31:0] romData_cpu_to_rom;
    reg[3:0] romSel_cpu_to_rom;
    reg romWriteEnable_cpu_to_rom;
    wire[31:0] romData_rom_to_cpu;
    reg romEnable_cpu_to_rom;
    reg[31:0] ramAddr_cpu_to_ram;
    reg[31:0] ramData_cpu_to_ram;
    reg[3:0] ramSel_cpu_to_ram;
    reg ramWriteEnable_cpu_to_ram;
    reg ramEnable_cpu_to_ram;
    wire[31:0] ramData_ram_to_cpu;
    wire[5:0] cp0Inte_cpu_to_cpu;
    wire cp0TimerInte_cpu_to_cpu;*/

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
    
    wire[31:0] addr_bus_to_bootrom;
    wire[31:0] data_bootrom_to_bus;
    
    reg[3:0] bugState;

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
    
    /*always @(posedge clk_50M) begin
        if(reset_btn == `Enable) begin
            bugState <= 4'h7;
            ramEnable_cpu_to_ram <= 1'b0;
        end else begin
            case(bugState)
                4'h0: begin
                    romData_cpu_to_rom <= 32'h0f0f0f0f;
                    romAddr_cpu_to_rom <= 32'h1FC00004;
                    romWriteEnable_cpu_to_rom <= 1'b1;
                    romEnable_cpu_to_rom <= 1'b1;
                    bugState <= 4'h1;
                end
                4'h6: begin
                    romData_cpu_to_rom <= 32'hf0f0f0f0;
                    romAddr_cpu_to_rom <= 32'h1FC00008;
                    romWriteEnable_cpu_to_rom <= 1'b1;
                    romEnable_cpu_to_rom <= 1'b1;
                    bugState <= 4'h7;
                end
                4'ha: begin
                    romData_cpu_to_rom <= 32'h00000000;
                    romAddr_cpu_to_rom <= 32'h1FC00004;
                    romWriteEnable_cpu_to_rom <= 1'b0;
                    romEnable_cpu_to_rom <= 1'b1;
                    bugState <= 4'hb;
                end
                4'hf: begin
                    bugState <= 'h0;
                end
                default: begin
                    bugState <= bugState + 4'h1;
                end
            endcase
        end
    end*/

    BUS bus(

        .clk_i(clk_50M),
        .rst_i(reset_btn),

        .ifEnable_i(romEnable_cpu_to_rom),
        .ifWriteEnable_i(romWriteEnable_cpu_to_rom),
        .ifSel_i(4'b1111),
        .ifAddr_i(romAddr_cpu_to_rom),
        .ifData_i(romData_cpu_to_rom),
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
		.romRdy_i(rdy_flash_to_bus),
		
		.bootromAddr_o(addr_bus_to_bootrom),
		.bootromData_i(data_bootrom_to_bus)

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
    
    BOOT_ROM boot_rom(
      .rst_i(reset_btn),              // input wire clka
      
      .romAddr_i(addr_bus_to_bootrom),          // input wire [31 : 0] addra
      .romData_o(data_bootrom_to_bus)          // output wire [31 : 0] douta
    );
endmodule
