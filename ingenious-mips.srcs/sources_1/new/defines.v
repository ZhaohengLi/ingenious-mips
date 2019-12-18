`define Enable 1'b1
`define Disable 1'b0
`define ZeroWord 32'h00000000
`define AluOpBus 7:0
`define AluSelBus 2:0
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define Branch 1'b1
`define NoBranch 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0

`define SIZE_C0 3
`define SIZE_C1 3
`define SIZE_ASID 8
`define SIZE_VPN2 19
`define SIZE_PFN0 24
`define SIZE_PFN1 24

`define ENABLE_CPU_MMU 1'b1
`define TLB_ENTRIES_NUM 16
`define TLB_ENTRIES_NUM_LOG2  4
`define PC_RESET_VECTOR 32'hbfc00000

`define EXE_ORI  6'b001101
`define EXE_NOP 6'b000000
`define EXE_AND 6'b100100
`define EXE_OR 6'b100101
`define EXE_XOR 6'b100110
`define EXE_NOR 6'b100111
`define EXE_ANDI 6'b001100
`define EXE_XORI 6'b001110
`define EXE_LUI 6'b001111
`define EXE_SPECIAL_INST 6'b000000
`define EXE_REGIMM_INST 6'b000001
`define EXE_SPECIAL2_INST 6'b011100
`define EXE_J 6'b000010
`define EXE_JAL 6'b000011
`define EXE_BEQ 6'b000100
`define EXE_BGTZ 6'b000111
`define EXE_BLEZ 6'b000110
`define EXE_BNE 6'b000101
`define EXE_REGIMM 6'b000001
`define EXE_SLL 6'b000000
`define EXE_SLLV 6'b000100
`define EXE_SRL 6'b000010
`define EXE_SRLV 6'b000110
`define EXE_SRA 6'b000011
`define EXE_SRAV 6'b000111
`define EXE_MOVN 6'b001011
`define EXE_MOVZ 6'b001010
`define EXE_MFHI 6'b010000
`define EXE_MFLO 6'b010010
`define EXE_MTHI 6'b010001
`define EXE_MTLO 6'b010011
`define EXE_SLT  6'b101010
`define EXE_SLTU  6'b101011
`define EXE_SLTI  6'b001010
`define EXE_SLTIU  6'b001011
`define EXE_ADD  6'b100000
`define EXE_ADDU  6'b100001
`define EXE_SUB  6'b100010
`define EXE_SUBU  6'b100011
`define EXE_ADDI  6'b001000
`define EXE_ADDIU  6'b001001
`define EXE_CLZ  6'b100000
`define EXE_CLO  6'b100001
`define EXE_MULT  6'b011000
`define EXE_MULTU  6'b011001
`define EXE_MUL  6'b000010
`define EXE_DIV 6'b011010
`define EXE_DIVU 6'b011011
`define EXE_JR 6'b001000
`define EXE_JALR 6'b001001
`define EXE_MADD 6'b000000
`define EXE_MADDU 6'b000001
`define EXE_MSUB 6'b000100
`define EXE_MSUBU 6'b000101
`define EXE_LB  6'b100000
`define EXE_LBU  6'b100100
`define EXE_LH  6'b100001
`define EXE_LHU  6'b100101
`define EXE_LL  6'b110000
`define EXE_LW  6'b100011
`define EXE_LWL  6'b100010
`define EXE_LWR  6'b100110
`define EXE_SB  6'b101000
`define EXE_SC  6'b111000
`define EXE_SH  6'b101001
`define EXE_SW  6'b101011
`define EXE_SWL  6'b101010
`define EXE_SWR  6'b101110
`define EXE_SYNC 6'b001111
`define EXE_PREF 6'b110011
`define EXE_BLTZ 5'b00000
`define EXE_BLTZAL 5'b10000
`define EXE_BGEZ 5'b00001
`define EXE_BGEZAL 5'b10001
`define EXE_TEQ 6'b110100
`define EXE_TGE 6'b110000
`define EXE_TGEU 6'b110001
`define EXE_TLT 6'b110010
`define EXE_TLTU 6'b110011
`define EXE_TNE 6'b110110
`define EXE_TEQI 5'b01100
`define EXE_TGEI 5'b01000
`define EXE_TGEIU 5'b01001
`define EXE_TLTI 5'b01010
`define EXE_TLTIU 5'b01011
`define EXE_TNEI 5'b01110
`define EXE_SYSCALL 6'b001100
`define EXE_ERET 32'b01000010000000000000000000011000

`define EXE_TLBR 6'b000001
`define EXE_TLBP 6'b001000
`define EXE_TLBWI 6'b000010
`define EXE_TLBWR 6'b000110
`define EXE_COP0 6'b010000

`define EXE_OR_OP 8'b00100101
`define EXE_AND_OP 8'b00100100
`define EXE_XOR_OP 8'b00100110
`define EXE_NOR_OP 8'b00100111
`define EXE_SLL_OP 8'b00000100
`define EXE_SRL_OP 8'b00000010
`define EXE_SRA_OP 8'b00000011
`define EXE_MOVZ_OP  8'b00001010
`define EXE_MOVN_OP  8'b00001011
`define EXE_MFHI_OP  8'b00010000
`define EXE_MTHI_OP  8'b00010001
`define EXE_MFLO_OP  8'b00010010
`define EXE_MTLO_OP  8'b00010011
`define EXE_SLT_OP  8'b00101010
`define EXE_SLTU_OP  8'b00101011
`define EXE_ADD_OP  8'b00100000
`define EXE_ADDU_OP  8'b00100001
`define EXE_ADDI_OP  8'b01010101
`define EXE_ADDIU_OP  8'b01010110
`define EXE_SUB_OP  8'b00100010
`define EXE_SUBU_OP  8'b00100011
`define EXE_MULT_OP  8'b00011000
`define EXE_MULTU_OP  8'b00011001
`define EXE_MUL_OP  8'b10101001
`define EXE_DIV_OP 8'b00011010
`define EXE_DIVU_OP 8'b00011011
`define EXE_MADD_OP  8'b10100110
`define EXE_MADDU_OP  8'b10101000
`define EXE_MSUB_OP  8'b10101010
`define EXE_MSUBU_OP  8'b10101011
`define EXE_CLZ_OP  8'b10110000
`define EXE_CLO_OP  8'b10110001
`define EXE_J_OP 8'b01000010
`define EXE_JAL_OP 8'b01000011
`define EXE_JALR_OP 8'b01001001
`define EXE_JR_OP 8'b01001000
`define EXE_BEQ_OP 8'b01000100
`define EXE_BGTZ_OP 8'b01000111
`define EXE_BLEZ_OP 8'b01000110
`define EXE_BLTZ_OP 8'b01000000
`define EXE_BLTZAL_OP 8'b01010000
`define EXE_BGEZ_OP 8'b01000001
`define EXE_BGEZAL_OP 8'b01010001
`define EXE_LB_OP  8'b11100000
`define EXE_LBU_OP  8'b11100100
`define EXE_LH_OP  8'b11100001
`define EXE_LHU_OP  8'b11100101
`define EXE_LL_OP  8'b11110000
`define EXE_LW_OP  8'b11100011
`define EXE_LWL_OP  8'b11100010
`define EXE_LWR_OP  8'b11100110
`define EXE_PREF_OP  8'b11110011
`define EXE_SB_OP  8'b11101000
`define EXE_SC_OP  8'b11111000
`define EXE_SH_OP  8'b11101001
`define EXE_SW_OP  8'b11101011
`define EXE_SWL_OP  8'b11101010
`define EXE_SWR_OP  8'b11101110
`define EXE_SYNC_OP  8'b00001111
`define EXE_MFC0_OP 8'b01011101
`define EXE_MTC0_OP 8'b01100000
`define EXE_NOP_OP 8'b00000000
`define EXE_TEQ_OP 8'b01110100
`define EXE_TGE_OP 8'b01110000
`define EXE_TGEU_OP 8'b01110001
`define EXE_TLT_OP 8'b01110010
`define EXE_TLTU_OP 8'b01110011
`define EXE_TNE_OP 8'b01110110
`define EXE_TEQI_OP 8'b00101100
`define EXE_TGEI_OP 8'b00101000
`define EXE_TGEIU_OP 8'b00101001
`define EXE_TLTI_OP 8'b01001010
`define EXE_TLTIU_OP 8'b01001011
`define EXE_TNEI_OP 8'b00001110
`define EXE_SYSCALL_OP 8'b01001100
`define EXE_ERET_OP 8'b01011000

`define EXE_TLBR_OP 8'b11000001
`define EXE_TLBP_OP 8'b11001000
`define EXE_TLBWI_OP 8'b11000010
`define EXE_TLBWR_OP 8'b11000110

`define EXE_RES_NOP 3'b000
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_SHIFT 3'b010
`define EXE_RES_MOVE 3'b011
`define EXE_RES_ARITHMETIC 3'b100
`define EXE_RES_MUL 3'b101
`define EXE_RES_JUMP_BRANCH 3'b110
`define EXE_RES_LOAD_STORE 3'b111

`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071
`define InstMemNumLog2 17
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000
`define DivFree 2'b00
`define DivByZero 2'b01
`define DivOn 2'b10
`define DivEnd 2'b11
`define DivResultNotReady 1'b0
`define DivResultReady 1'b1
`define DivStart 1'b1
`define DivStop 1'b0

//CP0
`define CP0_REG_INDEX     5'b00000
`define CP0_REG_RANDOM    5'b00001
`define CP0_REG_ENTRYLO0  5'b00010
`define CP0_REG_ENTRYLO1  5'b00011
`define CP0_REG_CONTEXT   5'b00100
`define CP0_REG_PAGEMASK  5'b00101
`define CP0_REG_WIRED     5'b00110
//7保留
`define CP0_REG_BADVADDR  5'b01000
`define CP0_REG_COUNT     5'b01001
`define CPO_REG_ENTRYHI   5'b01010
`define CP0_REG_COMPARE   5'b01011
`define CP0_REG_STATUS    5'b01100
`define CP0_REG_CAUSE     5'b01101
`define CP0_REG_EPC       5'b01110
`define CP0_REG_EBASE     5'b01111
`define CP0_REG_CONFIG    5'b10000
`define CP0_REG_ERROREPC  5'b11110

`define BUS_IDLE 4'h0
`define BUS_BUSY 4'h1
`define BUS_BUSY_BASE_RAM 4'h1
`define BUS_BUSY_EXT_RAM 4'h2
`define BUS_BUSY_ROM 4'h3
`define BUS_WAIT 4'h4
`define BUS_UART_REG 4'h5
`define BUS_BUSY_BOOTROM 4'h6
`define BUS_ERROR 4'h7

`define PC_INIT_ADDR      32'hBFC00000

`define baseRAM_Border_l  32'h00000000
`define baseRAM_Border_r  32'h00400000
`define extRAM_Border_l   32'h00400000
`define extRAM_Border_r   32'h00800000

`define romBorder_l       32'h1E000000
`define romBorder_r       32'h1E800000

`define uartDataAddr      32'h1FD003F8
`define uartRegAddr       32'h1FD003FC

`define bootrom_l         32'h1FC00000
`define bootrom_r         32'h1FC04000
