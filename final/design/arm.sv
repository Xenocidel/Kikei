module arm(input logic clk, reset,
		output logic [31:0] PC,
		input logic [31:0] Instr,
		output logic MemWrite,
		output logic [31:0] ALUResult, WriteData,
		input logic [31:0] ReadData,
		output logic be		//byte enable
		);
	logic [3:0] ALUFlags, ALUControl;
	logic RegWrite,
			ALUSrc, MemtoReg, PCSrc;
	logic [1:0] RegSrc, ImmSrc;
	logic [2:0] ShiftOp;
	logic wr14;
	logic PrevC;
	controller c(clk, reset, Instr, ALUFlags,
			RegSrc, RegWrite, ImmSrc,
			ALUSrc, ALUControl,
			MemWrite, MemtoReg, PCSrc, ShiftOp, wr14, PrevC, be);
	// add pipeline registers here, controller outputs are from Decode stage
	// forwarding logic in Ch7 slide 153
	// stalling logic in Ch7 slide 157, 163
	// early branch resolution Ch7 slide 160
	// complete diagram in Ch7 slide 164
	datapath dp(clk, reset,
			RegSrc, RegWrite, ImmSrc,
			ALUSrc, ALUControl,
			MemtoReg, PCSrc,
			ALUFlags, PC, Instr,
			ALUResult, WriteData, ReadData, ShiftOp, wr14, PrevC);
endmodule
