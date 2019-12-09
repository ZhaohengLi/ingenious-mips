module tlb(
    input wire clk,
    input wire rst,
    input wire[7:0] asid,
    input wire[31:0] instAddr_i,
    input wire[31:0] dataAddr_i,
	
	//Inst result
    output wire[31:0] physInstAddr_o,
    output wire[3:0] instWhich_o,
    output wire instMiss_o,
    output wire instDirty_o,
    output wire instValid_o,
    output wire[2:0] instCache_flag_o,
	
	//Data result
    output wire[31:0] physDataAddr_o,
    output wire[3:0] dataWhich_o,
    output wire dataMiss_o,
    output wire dataDirty_o,
    output wire dataValid_o,
    output wire[2:0] dataCache_flag_o,
    
    //tlbr/tlbwi/tlbwr
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
    
    output wire[2:0] tlbrw_rc0,
    output wire[2:0] tlbrw_rc1,
    output wire[7:0] tlbrw_rasid,
    output wire[18:0] tlbrw_rvpn2,
    output wire[23:0] tlbrw_rpfn0,
    output wire[23:0] tlbrw_rpfn1,
    output wire tlbrw_rd1,
    output wire tlbrw_rv1,
    output wire tlbrw_rd0,
    output wire tlbrw_rv0,
    output wire tlbrw_rG,
    
    input wire[31:0] tlbp_entry_hi,
    output wire[31:0] tlbp_index

    );
     //flat entries
     reg[47:0] flat_entries_c0;
     reg[47:0] flat_entries_c1;
     reg[127:0] flat_entries_asid;
     reg[303:0] flat_entries_vpn2;
     reg[383:0] flat_entries_pfn0;
     reg[383:0] flat_entries_pfn1;
     reg[15:0] flat_entries_d1;
     reg[15:0] flat_entries_v1;
     reg[15:0] flat_entries_d0;
     reg[15:0] flat_entries_v0;
     reg[15:0] flat_entries_G;
     
     wire[2:0] entries_c0[15:0];
     wire[2:0] entries_c1[15:0];
     wire[7:0] entries_asid[15:0];
     wire[18:0] entries_vpn2[15:0];
     wire[23:0] entries_pfn0[15:0];
     wire[23:0] entries_pfn1[15:0];
     wire entries_d1[15:0];
     wire entries_v1[15:0];
     wire entries_d0[15:0];
     wire entries_v0[15:0];
     wire entries_G[15:0];
     
     assign tlbrw_rc0 = entries_c0[tlbrw_index];
     assign tlbrw_rc1 = entries_c1[tlbrw_index];
     assign tlbrw_rasid = entries_asid[tlbrw_index];
     assign tlbrw_rvpn2 = entries_vpn2[tlbrw_index];
     assign tlbrw_rpfn0 = entries_pfn0[tlbrw_index];
     assign tlbrw_rpfn1 = entries_pfn1[tlbrw_index];
     assign tlbrw_rd1 = entries_d1[tlbrw_index];
     assign tlbrw_rv1 = entries_v1[tlbrw_index];
     assign tlbrw_rd0 = entries_d0[tlbrw_index];
     assign tlbrw_rv0 = entries_v0[tlbrw_index];
     assign tlbrw_rG = entries_G[tlbrw_index];
     genvar i;
     generate
        for(i = 0; i < `TLB_ENTRIES_NUM; i = i + 1) begin
            assign entries_c0[i] = flat_entries_c0[i * `SIZE_C0 +: `SIZE_C0];
            assign entries_c1[i] = flat_entries_c1[i * `SIZE_C1 +: `SIZE_C1];
            assign entries_asid[i] = flat_entries_asid[i*`SIZE_ASID+:`SIZE_ASID];
            assign entries_vpn2[i] = flat_entries_vpn2[i*`SIZE_VPN2 +: `SIZE_VPN2];
            assign entries_pfn0[i] = flat_entries_pfn0[i*`SIZE_PFN0 +: `SIZE_PFN0];
            assign entries_pfn1[i] = flat_entries_pfn1[i*`SIZE_PFN1 +: `SIZE_PFN1];
            assign entries_d1[i] = flat_entries_d1[i +: 1];
            assign entries_v1[i] = flat_entries_v1[i +: 1];
            assign entries_d0[i] = flat_entries_d0[i +: 1];
            assign entries_v0[i] = flat_entries_v0[i +: 1];
            assign entries_G[i] = flat_entries_G[i +: 1];
            
            always @(posedge clk) begin
                if(rst == `Enable) begin
                    flat_entries_c0[i * `SIZE_C0 +: `SIZE_C0] <= {3'b0};
                    flat_entries_c1[i * `SIZE_C1 +: `SIZE_C1] <= {3'b0};
                    flat_entries_asid[i*`SIZE_ASID+:`SIZE_ASID] <= {8'b0};
                    flat_entries_vpn2[i*`SIZE_VPN2 +: `SIZE_VPN2] <= {19'b0};
                    flat_entries_pfn0[i*`SIZE_PFN0 +: `SIZE_PFN0] <= {19'b0};
                    flat_entries_pfn1[i*`SIZE_PFN1 +: `SIZE_PFN1] <= {24'b0};
                    flat_entries_d1[i] <= {1'b0};
                    flat_entries_v1[i] <= {1'b0};
                    flat_entries_d0[i] <= {1'b0};
                    flat_entries_v0[i] <= {1'b0};
                    flat_entries_G[i] <= {1'b0};

                end else begin
                    if((tlbrw_Enable == `Enable) && (i == tlbrw_index)) begin
                        flat_entries_c0[i * `SIZE_C0 +: `SIZE_C0] <= tlbrw_wc0;
                        flat_entries_c1[i * `SIZE_C1 +: `SIZE_C1] <= tlbrw_wc1;
                        flat_entries_asid[i*`SIZE_ASID+:`SIZE_ASID] <= tlbrw_wasid;
                        flat_entries_vpn2[i*`SIZE_VPN2 +: `SIZE_VPN2] <= tlbrw_wvpn2;
                        flat_entries_pfn0[i*`SIZE_PFN0 +: `SIZE_PFN0] <= tlbrw_wpfn0;
                        flat_entries_pfn1[i*`SIZE_PFN1 +: `SIZE_PFN1] <= tlbrw_wpfn1;
                        flat_entries_d1[i] <= tlbrw_wd1;
                        flat_entries_v1[i] <= tlbrw_wv1;
                        flat_entries_d0[i] <= tlbrw_wd0;
                        flat_entries_v0[i] <= tlbrw_wv0;
                        flat_entries_G[i] <= tlbrw_wG;    
                    end
                end
            end //always
            
        end
     endgenerate
     tlb_lookup inst_lookup(
        .flat_entries_c0(flat_entries_c0),
        .flat_entries_c1(flat_entries_c1),
        .flat_entries_asid(flat_entries_asid),
        .flat_entries_vpn2(flat_entries_vpn2),
        .flat_entries_pfn0(flat_entries_pfn0),
        .flat_entries_pfn1(flat_entries_pfn1),
        .flat_entries_d1(flat_entries_d1),
        .flat_entries_v1(flat_entries_v1),
        .flat_entries_d0(flat_entries_d0),
        .flat_entries_v0(flat_entries_v0),
        .flat_entries_G(flat_entries_G),
        .virtAddr_i(instAddr_i),
        .asid_i(asid),
        .physAddr_o(physInstAddr_o),
        .which_o(instWhich_o),
        .miss_o(instMiss_o), 
        .dirty_o(instDirty_o), 
        .valid_o(instValid_o),
        .cache_flag_o(instCache_flag_o)
     );
     tlb_lookup data_lookup(
        .flat_entries_c0(flat_entries_c0),
        .flat_entries_c1(flat_entries_c1),
        .flat_entries_asid(flat_entries_asid),
        .flat_entries_vpn2(flat_entries_vpn2),
        .flat_entries_pfn0(flat_entries_pfn0),
        .flat_entries_pfn1(flat_entries_pfn1),
        .flat_entries_d1(flat_entries_d1),
        .flat_entries_v1(flat_entries_v1),
        .flat_entries_d0(flat_entries_d0),
        .flat_entries_v0(flat_entries_v0),
        .flat_entries_G(flat_entries_G),
        .virtAddr_i(dataAddr_i),
        .asid_i(asid),
        .physAddr_o(physDataAddr_o),
        .which_o(dataWhich_o),
        .miss_o(dataMiss_o), 
        .dirty_o(dataDirty_o), 
        .valid_o(dataValid_o),
        .cache_flag_o(dataCache_flag_o)
     );
     //tlbp_result
     wire[31:0] tlbpres_physAddr;
     wire[3:0] tlbpres_which;
     wire tlbpres_miss;
     wire tlbpres_dirty;
     wire tlbpres_valid;
     wire[2:0] tlbpres_cache_flag;
     tlb_lookup tlbp_lookup(
        .flat_entries_c0(flat_entries_c0),
        .flat_entries_c1(flat_entries_c1),
        .flat_entries_asid(flat_entries_asid),
        .flat_entries_vpn2(flat_entries_vpn2),
        .flat_entries_pfn0(flat_entries_pfn0),
        .flat_entries_pfn1(flat_entries_pfn1),
        .flat_entries_d1(flat_entries_d1),
        .flat_entries_v1(flat_entries_v1),
        .flat_entries_d0(flat_entries_d0),
        .flat_entries_v0(flat_entries_v0),
        .flat_entries_G(flat_entries_G),
        .virtAddr_i(tlbp_entry_hi),
        .asid_i(tlbp_entry_hi[7:0]),
        .physAddr_o(tlbpres_physAddr),
        .which_o(tlbpres_which),
        .miss_o(tlbpres_miss), 
        .dirty_o(tlbpres_dirty), 
        .valid_o(tlbpres_valid),
        .cache_flag_o(tlbpres_cache_flag)
     );
     assign tlbp_index = {tlbpres_miss, {(27){1'b0}}, tlbpres_which};
     
     
     
endmodule
