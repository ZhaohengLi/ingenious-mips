`timescale 1ns/1ps
`define PATH_PREFIX1 "../../../../ingenious-mips.test/"

module TESTBENCH();
    reg CLOCK_50;
    reg rst;

	initial begin
	   $display("simulation started!");
	   rst = 1'b0;
	   CLOCK_50 = 1'b0;
	   forever #2 CLOCK_50 = ~CLOCK_50;
    end

    SOPC sopc1(
        .clk(CLOCK_50),
        .rst(rst)
    );
	
	reg dbus_we_delay;
	reg [15:0] dbus_addr_delay;
	reg [31:0] dbus_data_delay;
	reg [31:0] addr;
	always @(negedge CLOCK_50)
	begin
	dbus_we_delay <= sopc1.ram1.ramWriteEnable_i;
	dbus_addr_delay <= {sopc1.ram1.ramAddr_i[15:2], 2'b0};
	dbus_data_delay <= sopc1.ram1.data_w;
	end
    
    reg post_stall;
    always @(negedge CLOCK_50)
    begin
	post_stall <= sopc1.ram1.stall;
    end

	
	
	task judge;
    input integer fans, cycle;
    input reg[8*25:1] out;
    reg[8*25:1] ans;
    begin
        $fscanf(fans, "%s\n", ans);
        if(out != ans && ans != "skip") begin
            $display("[%0d] %s", cycle, out);
            $display("[Error] Expected: %0s, Got: %0s", ans, out);
            $stop;
        end else begin
            $display("[%0d] %s [%s]", cycle, out, ans == "skip" ? "Skip" : "Correct");
        end
    end
    endtask


	task unitTest;
	input [128*8-1:0] name;
	integer i, fans, cycle, is_event;
	reg[8*25:1] ans, out, info;
	begin
	   $display("======= Unit Test : %0s Started =======", name);
	   cycle = 0; is_event = 0;
	   for(i = 0; i < 1025; i = i + 1) begin
	       sopc1.rom1.instructions[i] = 32'h0;
	   end
	   for(i = 0; i < 8192; i = i + 1) begin
	       sopc1.ram1.inst_ram[i] = 32'h0;
	   end
	   fans = $fopen({ `PATH_PREFIX1, name, ".ans"}, "r");
	   $display("File .ans Loaded.");
	   if(fans) begin
	       $readmemh({ `PATH_PREFIX1, name, ".mem" }, sopc1.rom1.instructions,0,1023);
           $display("File .mem Loaded.");
	   end
	   begin
	       rst = 1'b1;
	       #50 rst = 1'b0;
	   end

	   cycle = 0;
	   while(!$feof(fans))
	   begin @(negedge CLOCK_50);
	       cycle = cycle + 1;
	       
	       //if(!post_stall) begin
               if(sopc1.cpu1.regWriteAddr_mem_wb_to_reg && sopc1.cpu1.regWriteEnable_mem_wb_to_reg) begin
                   //$display(" %0x",sopc1.cpu1.id1.inst_i);
                   $sformat(out, "$%0d=0x%x", sopc1.cpu1.regWriteAddr_mem_wb_to_reg, sopc1.cpu1.regWriteData_mem_wb_to_reg);
                   judge(fans, cycle, out);
               end
               if( sopc1.cpu1.regHILOEnable_mem_wb_to_hilo ) begin
                   $sformat(out, "$hilo=0x%x%x", sopc1.cpu1.regHI_mem_wb_to_hilo, sopc1.cpu1.regLO_mem_wb_to_hilo);
                   judge(fans, cycle, out);
               end
               if(dbus_we_delay) begin
                    $sformat(out, "[0x%x]=0x%x", dbus_addr_delay[15:0], dbus_data_delay);
                    judge(fans, cycle, out);
                end 
            //end
	   end
	   $display("======= Unit Test : %0s Finished =======\n", name, name);
	end
    endtask

	initial begin
	   wait (rst == 1'b0);
	   $display("Unit Test Started.\n");
	   //unitTest("inst_mem_aligned");
	   unitTest("inst_mem_all");
	   //unitTest("inst_logical");
	   //unitTest("inst_shift");
	   //unitTest("inst_move");
	   //unitTest("inst_arith");
	   unitTest("inst_jump");
	   $display("[Done]", 0);
	   $display("Unit Test Finished.\n");
	   $finish;
	   $stop;
    end

endmodule
