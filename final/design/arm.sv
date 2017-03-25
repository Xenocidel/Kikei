module arm(input logic clk, reset,
		output logic [31:0] PC,
		input logic [31:0] Instr,
		output logic MemWriteM,
		output logic [31:0] ALUResult, WriteData,
		input logic [31:0] ReadData,
		output logic be);
	logic MemWriteD;
	logic [3:0] ALUFlags, ALUControlD, ALUControlE;
	logic RegWriteD,
			ALUSrcD, MemtoRegD, PCSrcD, RegWriteE, ALUSrcE, MemtoRegE, PCSrcE;
	logic PCSrcM, RegWriteM, MemtoRegM;
	logic PCSrcW, RegWriteW, MemtoRegW;
	logic [1:0] RegSrcD, ImmSrcD, RegSrcE, ImmSrcE;
	logic [2:0] ShiftOpD;
	logic wr14;
	logic PrevC;

	logic[31:0] InstrE;
	logic[2:0] ShiftOpE;

	controller c(clk, reset, Instr, ALUFlags,
			RegSrcD, RegWriteD, ImmSrcD,
			ALUSrcD, ALUControlD,
			MemWriteD, MemtoRegD, PCSrcD, ShiftOpD, wr14, PrevC, be);

	idexe idexe(clk, RegSrcD, RegWriteD, ImmSrcD, ALUSrcD, ALUControlD,
		MemWriteD, MemtoRegD, PCSrcD, ShiftOpD, Instr, RegSrcE, RegWriteE, ImmSrcE, ALUSrcE,
		ALUControlE, MemWriteE, MemtoRegE, PCSrcE,ShiftOpE, InstrE);

	exemem exemem(clk,PCSrcE, RegWriteE, MemtoRegE, MemWriteE, PCSrcM, RegWriteM, MemtoRegM, MemWriteM);
	memwb memwb(clk, PCSrcM, RegWriteM, MemtoRegM, PCSrcW, RegWriteW, MemtoRegW);

	datapath dp(clk, reset,
			RegSrcD, RegWriteW, ImmSrcD,
			ALUSrcE, ALUControlE,
			MemtoRegE, PCSrcD,
			ALUFlags, PC, InstrE,
			ALUResult, WriteData, ReadData, ShiftOpE, wr14, PrevC);
endmodule
