module IngeniousMIPS(
    input wire clk_50M,           //50MHz 时钟输入
    input wire clk_11M0592,       //11.0592MHz 时钟输入
    
    input wire clock_btn,         //BTN5手动时钟按钮开关，带消抖电路，按下时为1
    input wire reset_btn,         //BTN6手动�?�?按钮开关，带消抖电路，按下时为1
    
    //ROM
    input wire [31:0] rom_dataIN,
    output wire [31:0] rom_addrOUT,
    output wire rom_ce, //ROM chip enable
    
    input  wire[3:0]  touch_btn,  //BTN1~BTN4，按钮开关，按下时为1
    input  wire[31:0] dip_sw,     //32�?拨�?开关，拨到"ON"时为1
    output wire[15:0] leds,       //16�?LED，输出时1点亮
    output wire[7:0]  dpy0,       //数�?管低�?信�?�，包括�?数点，输出1点亮
    output wire[7:0]  dpy1,       //数�?管高�?信�?�，包括�?数点，输出1点亮

    //CPLD串�?�控制器信�?�
    output wire uart_rdn,         //读串�?�信�?�，低有效
    output wire uart_wrn,         //写串�?�信�?�，低有效
    input wire uart_dataready,    //串�?�数�?�准备好
    input wire uart_tbre,         //�?��?数�?�标志
    input wire uart_tsre,         //数�?��?��?完毕标志

    //BaseRAM信�?�
    inout wire[31:0] base_ram_data,  //BaseRAM数�?�，低8�?与CPLD串�?�控制器共享
    output wire[19:0] base_ram_addr, //BaseRAM地�?�
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果�?使用字节使能，请�?�?为0
    output wire base_ram_ce_n,       //BaseRAM片选，低有效
    output wire base_ram_oe_n,       //BaseRAM读使能，低有效
    output wire base_ram_we_n,       //BaseRAM写使能，低有效

    //ExtRAM信�?�
    inout wire[31:0] ext_ram_data,  //ExtRAM数�?�
    output wire[19:0] ext_ram_addr, //ExtRAM地�?�
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果�?使用字节使能，请�?�?为0
    output wire ext_ram_ce_n,       //ExtRAM片选，低有效
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有效
    output wire ext_ram_we_n,       //ExtRAM写使能，低有效

    //直连串�?�信�?�
    output wire txd,  //直连串�?��?��?端
    input  wire rxd,  //直连串�?�接收端

    //Flash存储器信�?�，�?�考 JS28F640 芯片手册
    output wire [22:0]flash_a,      //Flash地�?�，a0仅在8bit模�?有效，16bit模�?无�?义
    inout  wire [15:0]flash_d,      //Flash数�?�
    output wire flash_rp_n,         //Flash�?�?信�?�，低有效
    output wire flash_vpen,         //Flash写�?护信�?�，低电平时�?能擦除�?烧写
    output wire flash_ce_n,         //Flash片选信�?�，低有效
    output wire flash_oe_n,         //Flash读使能信�?�，低有效
    output wire flash_we_n,         //Flash写使能信�?�，低有效
    output wire flash_byte_n,       //Flash 8bit模�?选择，低有效。在使用flash的16�?模�?时请设为1

    //USB 控制器信�?�，�?�考 SL811 芯片手册
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //USB数�?�线与网络控制器的dm9k_sd[7:0]共享
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //网络控制器信�?�，�?�考 DM9000A 芯片手册
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //图�?输出信�?�
    output wire[2:0] video_red,    //红色�?素，3�?
    output wire[2:0] video_green,  //绿色�?素，3�?
    output wire[1:0] video_blue,   //�?色�?素，2�?
    output wire video_hsync,       //行�?�步（水平�?�步）信�?�
    output wire video_vsync,       //场�?�步（垂直�?�步）信�?�
    output wire video_clk,         //�?素时钟输出
    output wire video_de           //行数�?�有效信�?�，用于区分消�?区
);

    assign leds = dip_sw[15:0];
    
    //PIPELINE START
    //pcadder
    wire [31:0] adder_pc_in;
    wire [31:0] adder_pc_out;
    //if id
    wire [31:0] if_inst_Addr_i;
    wire [31:0] id_inst_Addr_i;
    wire [31:0] id_inst_i;
    
    //IDregister
    wire [7:0] id_aluOp_o;
    wire [2:0] id_aluSel_o;
    wire [31:0] id_operand1_o;
    wire [31:0] id_operand2_o;
    wire [4:0] id_regWriteAddr_o; //target register's address
    wire id_regWritEnablee_o;
    
    //ID-EX 
    wire [2:0] ex_aluSel_i;
    wire [7:0] ex_aluOp_i;
    wire [31:0] ex_operand1_i;
    wire [31:0] ex_operand2_i;
    wire [4:0] ex_regWriteAddr_i;
    wire ex_regWriteEnable_i;
    
    //EX
    wire ex_regWriteEnable_o;
    wire [31:0] ex_regWriteData_o;
    wire [4:0] ex_regWriteAddr_o;
    
    //exmem
    wire mem_regWriteEnable_i;
    wire [31:0] mem_regWriteData_i;
    wire [4:0] mem_regWriteAddr_i;
    
    //mem
    wire mem_regWriteEnable_o;
    wire [31:0] mem_regWriteData_o;
    wire [4:0] mem_regWriteAddr_o;
    
    //memwb
    wire wb_regWriteEnable_i;
    wire [31:0] wb_regWriteData_i;
    wire [4:0] wb_regWriteAddr_i;
    
    //register.v
    wire enread1; //enable read1
    wire enread2;
    wire [31:0] reg_data1_i;
    wire [31:0] reg_data2_i;
    wire [4:0] reg1_Addr_i;
    wire [4:0] reg2_Addr_i;
    
    //pc.v
    PC pc1(
        .clk(clock_btn),  .rst(reset_btn),
        .inst_Addr_i(if_inst_Addr_i), .inst_Addr_o(adder_pc_in),
        .ce_o(rom_ce)
    );
    //pcadder.v
    PC_Adder pc_Adder1(
        .pc_in(adder_pc_in), .pc_out(adder_pc_out)
    );
    assign rom_addrOUT = adder_pc_out;
    
    //ifid
    IF_ID if_id1(
        .clk(clock_btn),  .rst(reset_btn),
        .inst_Addr_i(if_inst_Addr_i), .inst_i(rom_dataIN),
        .inst_Addr_o(id_inst_Addr_i), .inst_o(id_inst_i)
    );
    
    //IDRegister
    ID id1(
        .rst(reset_btn),  .inst_Addr_i(id_inst_Addr_i),
        .inst_i(id_inst_i),  
        //from registers
        .reg1Data_i(reg_data1_i), reg2Data_i(reg_data2_i),
        //send to registers 
        .reg1Enable_o(enread1), .reg2Enable_o(enread2),
        .reg1Addr_o(reg1_Addr_i), .reg1Addr_o(reg2_Addr_i),
        //send to idex
        .aluOp_o(id_aluOp_o), .aluSel_o(id_aluSel_o),
        .operand1_o(id_operand1_o), .operand2regWritEnablee_o(id_regWritEnablee_o)
    );
    
    //Registers
    REG REG1(
        .clk(clock_btn), .rst(reset_btn),
        .regWriteEnable_i(wb_regWriteData_i), .regWriteAddr_i(wb_regWriteAddr_i),
        .regWriteData_i(wb_regWriteData_i), .reg1Enable_i(enread1),
        .reg1Addr_i(reg1_Addr_i), .reg1Data_o(reg_data1_i),
        .reg2Enable_i(enread2), .reg2Addr_i(reg2_Addr_i),
        .reg2Data_o(reg_data2_i)
    );
    
    //ID/EX
    ID_EX id_ex1(
        .clk(clock_btn), .rst(reset_btn),
        
        .aluSel_i(id_aluSel_o), .aluOp_i(id_aluOp_o),
        .operand1_i(id_operand1_o), .operand2_i(id_operand2_o),
        .regWriteAddr_i(id_regWriteAddr_o), .regWriteEnable_i(id_regWritEnablee_o),
        
        .aluSel_o(ex_aluSel_i), .aluOp_o(ex_aluOp_i),
        .operand1_o(ex_operand1_i), .operand2_o(ex_operand2_i),
        .regWriteAddr_o(ex_regWriteAddr_i), .regWriteEnable_o(ex_regWriteEnable_i)
    );

    //ex
    EX ex1(
        .rst(reset_btn),  .aluSel_i(ex_aluSel_i),
        .aluOp_i(ex_aluOp_i), .operand1_i(ex_operand1_i),
        .operand2_i(ex_operand2_i), .regWriteAddr_i(ex_regWriteAddr_i),
        .regWriteEnable_i(ex_regWriteEnable_i),
        .regWriteEnable_o(ex_regWriteEnable_o), .regWriteAddr_o(ex_regWriteAddr_o),
        .regWriteData_o(ex_regWriteData_o)
        
    );
    
    //exmem
    EX_MEM ex_mem1(
        .rst(reset_btn), .clk(clock_btn),
        .regWriteAddr_i(ex_regWriteAddr_o), .regWriteEnable_i(ex_regWriteEnable_o),
        .regWriteData_i(ex_regWriteData_o), .regWriteAddr_o(mem_regWriteAddr_i),
        .regWriteEnable_o(mem_regWriteEnable_i), .regWriteData_o(mem_regWriteData_i)
    );
    
    //mem
    MEM mem1(
        .rst(reset_btn), .regWriteAddr_i(mem_regWriteAddr_i),
        .regWriteEnable_i(mem_regWriteEnable_i), .regWriteData_i(mem_regWriteData_i),
        .regWriteAddr_o(mem_regWriteAddr_o),   .regWriteEnable_o(mem_regWriteEnable_o),
        .regWriteData_o(mem_regWriteData_o)
    );
    
    //memwb
    MEM_WB mem_wb1(
        .rst(reset_btn), .clk(clock_btn),
        .regWriteAddr_i(mem_regWriteAddr_o), .regWriteEnable_i(mem_regWriteEnable_o),
        .regWriteData_i(mem_regWriteData_o), .regWriteAddr_o(wb_regWriteAddr_i),
        .regWriteEnable_o(wb_regWriteEnable_i), .regWriteData_o(wb_regWriteData_i)
    );
    //PIPELINE END

endmodule