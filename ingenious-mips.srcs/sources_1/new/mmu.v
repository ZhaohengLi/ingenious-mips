`include "defines.v"

module MMU(
    input wire clk,
    input wire rst,
    input wire[7:0] asid_i,
    input wire userMode_i,
    input wire[`InstAddrBus] instVirtAddr_i,
    input wire[`InstAddrBus] dataVirtAddr_i,

    //mmu result inst_result
    output wire[31:0] physInstAddr_o,
    output wire[31:0] virtInstAddr_o,
    output wire instInvalid_o,
    output wire instMiss_o,
    output wire instDirty_o,
    output wire instIllegal_o,

    //mmu result data result
    output wire[`InstAddrBus] physDataAddr_o,
    output wire[`InstAddrBus] virtDataAddr_o,
    output wire dataInvalid_o,
    output wire dataMiss_o,
    output wire dataDirty_o,
    output wire dataIllegal_o,

    // tlbr/tlbwi/tlbwr
    input wire[3:0] tlbrw_index,
    input wire tlbrw_Enable,
    input wire[2:0] tlbrw_wc0,
    input wire[2:0] tlbrw_wc1,
    input wire[7:0] tlbrw_wasid,
    input wire[18:0] tlbrw_wvpn2,
    input wire[23:0] tlbrw_wpfn0,
    input wire[23:0] tlbrw_wpfn1,
    input wire tlbrw_wd1,
    input wire tlbrw_wv1,
    input wire tlbrw_wd0,
    input wire tlbrw_wv0,
    input wire tlbrw_wG,
    output wire[2:0] tlbrw_rc0_o,
    output wire[2:0] tlbrw_rc1_o,
    output wire[7:0] tlbrw_rasid_o,
    output wire[18:0] tlbrw_rvpn2_o,
    output wire[23:0] tlbrw_rpfn0_o,
    output wire[23:0] tlbrw_rpfn1_o,
    output wire tlbrw_rd1_o,
    output wire tlbrw_rv1_o,
    output wire tlbrw_rd0_o,
    output wire tlbrw_rv0_o,
    output wire tlbrw_rG_o,
    //tlbp
    input wire[31:0] tlbp_entry_hi,
    output wire[31:0] tlbp_index_o

    );
    generate
        if(`ENABLE_CPU_MMU == 1'b1) begin
            wire inst_mapped;
            wire data_mapped;
            wire[31:0] tlb_physInstAddr; //inst_tlb_result.phys_addr
            wire[3:0] tlb_Instwhich; //inst_tlb_result.which
            wire tlb_Instmiss; //inst_tlb_result.miss
            wire tlb_Instdirty; //inst_tlb_result.dirty
            wire tlb_Instvalid; //inst_tlb_result.valid
            wire[2:0] tlb_Instcache_flag; //inst_tlb_result.cache_flag

            wire[31:0] tlb_physDataAddr; //data_tlb_result.phys_addr
            wire[3:0] tlb_Datawhich; //data_tlb_result.which
            wire tlb_Datamiss; //data_tlb_result.miss
            wire tlb_Datadirty; //data_tlb_result.dirty
            wire tlb_Datavalid; //data_tlb_result.valid
            wire[2:0] tlb_Datacache_flag; //data_tlb_result.cache_flag

            assign inst_mapped = (~instVirtAddr_i[31] || instVirtAddr_i[31:30] == 2'b11);
            assign data_mapped = (~dataVirtAddr_i[31] || dataVirtAddr_i[31:30] == 2'b11);

            wire user_peripheral;
            assign user_peripheral = (dataVirtAddr_i[31:24] >= 8'ha2 && dataVirtAddr_i[31:24] <= 8'ha7);

            assign instDirty_o = 1'b0;
            assign instMiss_o =(inst_mapped & tlb_Instmiss);
            assign instIllegal_o = (userMode_i & instVirtAddr_i[31]);
            assign instInvalid_o = (inst_mapped & ~tlb_Instvalid);
            assign physInstAddr_o = (inst_mapped ? tlb_physInstAddr :{instVirtAddr_i[31:0]});
            assign virtInstAddr_o = instVirtAddr_i;

            assign dataDirty_o = (~data_mapped | tlb_Datadirty);
            assign dataMiss_o = (data_mapped & tlb_Datamiss);
            assign dataIllegal_o = (userMode_i & dataVirtAddr_i[31]) & ~user_peripheral;
            assign dataInvalid_o = (data_mapped & ~tlb_Datavalid);
            assign physDataAddr_o = data_mapped ? tlb_physDataAddr: {dataVirtAddr_i[31:0]};
            assign virtDataAddr_o = dataVirtAddr_i;

             tlb tlb_instance(
                .clk(clk),
                .rst(rst),
                .asid(asid_i),
                .instAddr_i(instVirtAddr_i),
                .dataAddr_i(dataVirtAddr_i),
                .physInstAddr_o(tlb_physInstAddr),
                .instWhich_o(tlb_Instwhich),
                .instMiss_o(tlb_Instmiss),
                .instDirty_o(tlb_Instdirty),
                .instValid_o(tlb_Instvalid),
                .instCache_flag_o(tlb_Instcache_flag),
                .physDataAddr_o(tlb_physDataAddr),
                .dataWhich_o(tlb_Datawhich),
                .dataMiss_o(tlb_Datamiss),
                .dataDirty_o(tlb_Datadirty),
                .dataValid_o(tlb_Datavalid),
                .dataCache_flag_o(tlb_Datacache_flag),

                //tlbr/tlbwi/tlbwr
                .tlbrw_index(tlbrw_index),
                .tlbrw_Enable(tlbrw_Enable),
                .tlbrw_wc0(tlbrw_wc0),
                .tlbrw_wc1(tlbrw_wc1),
                .tlbrw_wasid(tlbrw_wasid),
                .tlbrw_wvpn2(tlbrw_wvpn2),
                .tlbrw_wpfn0(tlbrw_wpfn0),
                .tlbrw_wpfn1(tlbrw_wpfn1),
                .tlbrw_wd1(tlbrw_wd1),
                .tlbrw_wv1(tlbrw_wv1),
                .tlbrw_wd0(tlbrw_wd0),
                .tlbrw_wv0(tlbrw_wv0),
                .tlbrw_wG(tlbrw_wG),
                .tlbrw_rc0(tlbrw_rc0_o),
                .tlbrw_rc1(tlbrw_rc1_o),
                .tlbrw_rasid(tlbrw_rasid_o),
                .tlbrw_rvpn2(tlbrw_rvpn2_o),
                .tlbrw_rpfn0(tlbrw_rpfn0_o),
                .tlbrw_rpfn1(tlbrw_rpfn1_o),
                .tlbrw_rd1(tlbrw_rd1_o),
                .tlbrw_rv1(tlbrw_rv1_o),
                .tlbrw_rd0(tlbrw_rd0_o),
                .tlbrw_rv0(tlbrw_rv0_o),
                .tlbrw_rG(tlbrw_rG_o),
                .tlbp_entry_hi(tlbp_entry_hi),
                .tlbp_index(tlbp_index_o)
             );
    end else begin
       assign physInstAddr_o = instVirtAddr_i;
       assign virtInstAddr_o = 32'h00000000;
       assign instInvalid_o = 1'b0;
       assign instMiss_o = 1'b0;
       assign instDirty_o = 1'b0;
       assign instIllegal_o = 1'b0;

       assign physDataAddr_o = dataVirtAddr_i;
       assign virtDataAddr_o = 32'h00000000;
       assign dataInvalid_o = 1'b0;
       assign dataMiss_o = 1'b0;
       assign dataDirty_o = 1'b1;
       assign dataIllegal_o = 1'b0;
   end

    endgenerate
endmodule
