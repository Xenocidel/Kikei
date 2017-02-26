
module tb_top();
    logic clk;
    logic reset;
    logic [31:0] DataAdr;
    logic [31:0] WriteData;
    logic MemWrite;


    // instantiate device to be tested
    top dut(clk, reset, DataAdr, WriteData, MemWrite);


    // initialize test
    initial
    begin
        reset <= 1; # 22; reset <= 0;
    end

    // generate clock to sequence tests
    always
    begin
        clk <= 1; # 5; clk <= 0; # 5;
    end

	int clk_cnt;
	always @(posedge clk) begin
		clk_cnt++;
		if (clk_cnt > 100) begin
			for (int i = 0; i<16; i++) begin
				$display("%g %x", i, tb_top.dut.arm.dp.rf.rf[i]);
			end
			$finish;
		end
	end
	
    // check that 7 gets written to address 0x64
    // at end of program
    always @(negedge clk)
    begin
        if(MemWrite) begin
            if(DataAdr === 252 &  WriteData === 22) 
            begin
                $display("Simulation succeeded");
                $stop;
            end 
            else //if (DataAdr !== 96) 
            begin
                $display("Simulation failed");
                $display("your score is %d out of 22", WriteData);
				$stop;
            end
        end
    end

    // Limits sim time to 400ns
    initial begin
    #400;
    $finish;
    end
endmodule
