module tlb_lookup(
	/*TLB TLBFlatEntries*/
    input wire[47:0] flat_entries_c0,
    input wire[47:0] flat_entries_c1,
    input wire[127:0] flat_entries_asid,
    input wire[303:0] flat_entries_vpn2,
    input wire[383:0] flat_entries_pfn0,
    input wire[383:0] flat_entries_pfn1,
    input wire[15:0] flat_entries_d1,
    input wire[15:0] flat_entries_v1,
    input wire[15:0] flat_entries_d0,
    input wire[15:0] flat_entries_v0,
    input wire[15:0] flat_entries_G,

    input wire[31:0] virtAddr_i,	//MemAddr_t
    input wire[7:0] asid_i,

	/* TLBResult_t */
    output reg[31:0] physAddr_o,
    output wire[3:0] which_o,//配对表项的index
    output wire miss_o,
    output reg dirty_o,
    output reg valid_o,
    output reg[2:0] cache_flag_o
    );

    //所有的tlb表项 16个
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

    reg[3:0] which_matched;//匹配的表项index

    //检查是哪一项匹配
    wire[15:0] matched;

    //匹配的tlb表项
    wire[2:0] matched_entry_c0;
    wire[2:0] matched_entry_c1;
    wire[7:0] matched_entry_asid;
    wire[18:0] matched_entry_vpn2;
    wire[23:0] matched_entry_pfn0;
    wire[23:0] matched_entry_pfn1;
    wire matched_entry_d1;
    wire matched_entry_v1;
    wire matched_entry_d0;
    wire matched_entry_v0;
    wire matched_entry_G;
    //给匹配的表项赋值
    assign matched_entry_c0 = entries_c0[which_matched];
    assign matched_entry_c1 = entries_c1[which_matched];
    assign matched_entry_asid = entries_asid[which_matched];
    assign matched_entry_vpn2 = entries_vpn2[which_matched];
    assign matched_entry_pfn0 = entries_pfn0[which_matched];
    assign matched_entry_pfn1 = entries_pfn1[which_matched];
    assign matched_entry_d1 = entries_d1[which_matched];
    assign matched_entry_v1 = entries_v1[which_matched];
    assign matched_entry_d0 = entries_d0[which_matched];
    assign matched_entry_v0 = entries_v0[which_matched];
    assign matched_entry_G = entries_G[which_matched];

    //给输出赋值
    assign miss_o = (matched == 16'b0);
    assign which_o = which_matched;
    always @(*) begin
        physAddr_o[11:0] = virtAddr_i[11:0];
        if(virtAddr_i[12] == 1'b1) begin
            dirty_o <= matched_entry_d1;
            physAddr_o[31:12] <= matched_entry_pfn1[19:0];
            valid_o <= matched_entry_v1;
            cache_flag_o <= matched_entry_c1;
        end else begin
            dirty_o <= matched_entry_d0;
            physAddr_o[31:12] <= matched_entry_pfn0[19:0];
            valid_o <= matched_entry_v0;
            cache_flag_o <= matched_entry_c0;
        end
    end

    //从flat导出所有的表项，同时记录匹配的表项在matched中
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin
            assign entries_c0[i] = flat_entries_c0[i * `SIZE_C0 +: `SIZE_C0];
            assign entries_c1[i] = flat_entries_c1[i * `SIZE_C1 +: `SIZE_C1];
            assign entries_asid[i] = flat_entries_asid[i * `SIZE_ASID +: `SIZE_ASID];
            assign entries_vpn2[i] = flat_entries_vpn2[i * `SIZE_VPN2 +: `SIZE_VPN2];
            assign entries_pfn0[i] = flat_entries_pfn0[i * `SIZE_PFN0 +: `SIZE_PFN0];
            assign entries_pfn1[i] = flat_entries_pfn1[i * `SIZE_PFN1 +: `SIZE_PFN1];
            assign entries_d1[i] = flat_entries_d1[i +: 1];
            assign entries_v1[i] = flat_entries_v1[i +: 1];
            assign entries_d0[i] = flat_entries_d0[i +: 1];
            assign entries_v0[i] = flat_entries_v0[i +:1];
            assign entries_G[i] = flat_entries_G[i +: 1];

            assign matched[i] = ((entries_vpn2[i] == virtAddr_i[31:13]) && (entries_asid[i] == asid_i || entries_G[i]));
        end
    endgenerate

    //翻译 matched 的信息到 which_matched
    always @(*) begin
        if(matched[0] == 1'b1) which_matched <= 0;
        else if(matched[1] == 1'b1) which_matched <= 1;
        else if(matched[2] == 1'b1) which_matched <= 2;
        else if(matched[3] == 1'b1) which_matched <= 3;
        else if(matched[4] == 1'b1) which_matched <= 4;
        else if(matched[5] == 1'b1) which_matched <= 5;
        else if(matched[6] == 1'b1) which_matched <= 6;
        else if(matched[7] == 1'b1) which_matched <= 7;
        else if(matched[8] == 1'b1) which_matched <= 8;
        else if(matched[9] == 1'b1) which_matched <= 9;
        else if(matched[10] == 1'b1) which_matched <= 10;
        else if(matched[11] == 1'b1) which_matched <= 11;
        else if(matched[12] == 1'b1 which_matched <= 12;
        else if(matched[13] == 1'b1 which_matched <= 13;
        else if(matched[14] == 1'b1) which_matched <= 14;
        else if(matched[15] == 1'b1) which_matched <= 15;
        else which_matched <= 0;
    end

endmodule
