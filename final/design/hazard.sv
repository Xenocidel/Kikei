module hazard(input  logic			MemtoRegE,	// if data to be written is from ALU (0) or data Mem (1)
			  input  logic			RegWriteW,	// if data is queued to be written to rf
			  input  logic			RegWriteM,	// if data is queued to be written to rf
			  input  logic [3:0]	RA1E,		// register address used for SrcA of ALU
			  input  logic [3:0]	RA2E,
			  
			  input  logic			Match,
			  output logic [1:0]	ForwardAE,
			  output logic [1:0]	ForwardBE,
			  output logic			FlushE,
			  output logic			StallD,
			  output logic			StallF);

	
	
	
endmodule
