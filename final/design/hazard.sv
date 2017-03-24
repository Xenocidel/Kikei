module hazard(input  logic			MemtoRegE,	// if data to be written is from ALU (0) or data Mem (1)
			  input  logic			RegWriteW,	// if data is queued to be written to rf
			  input  logic			RegWriteM,	// if data is queued to be written to rf
			  input  logic [3:0]	RA1E,		// register address used for SrcA of ALU
			  input  logic [3:0]	RA2E,
			  input  logic [3:0]	WA3M,		// register to be written to
			  input  logic [3:0]	WA3W,
			  //input  logic			Match,
			  output logic [1:0]	ForwardAE,
			  output logic [1:0]	ForwardBE,
			  output logic			FlushD,
			  output logic			FlushE,
			  output logic			StallD,
			  output logic			StallF);

	
	// Stalling Logic slide 157
	logic Match_12D_E = (RA1D == WA3E) || (RA2D == WA3E);
	logic ldrStallD = Match_12D_E && MemtoRegE
	
	// Control Stalling Logic slide 163
	logic PCWrPendingF = PCSrcD || PCSrcE || PCSrcM;
	assign StallF = ldrStallD || PCWrPendingF;
	assign FlushD = PCWrPendingF || PCSrcW || BranchTakenE;
	assign FlushE = ldrStallD || BranchTakenE;
	assign StallD = ldrStallD;
	
	// Data Forwarding slide 153
	logic Match_1E_M = (RA1E == WA3M);
	logic Match_2E_M = (RA2E == WA3M);
	logic Match_1E_W = (RA1E == WA3W);
	logic Match_2E_W = (RA2E == WA3W);
	
	always_comb
	begin
		if (Match_1E_M && RegWriteM)
			ForwardAE = 2'b10;
		else if (Match_1E_W && RegWriteW)
			ForwardAE = 2'b01;
		else
			ForwardAE = 2'b00;
		
		if (Match_2E_M && RegWriteM)
			ForwardBE = 2'b10;
		else if (Match_2E_W && RegWriteW)
			ForwardBE = 2'b01;
		else
			ForwardBE = 2'b00;
	end
	
endmodule
