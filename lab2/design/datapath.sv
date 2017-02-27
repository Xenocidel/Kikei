module datapath(input logic clk, reset,
				input logic [1:0] RegSrc,
				input logic RegWrite,
				input logic [1:0] ImmSrc,
				input logic ALUSrc,
				input logic [3:0] ALUControl,
				input logic MemtoReg,
				input logic PCSrc,
				output logic [3:0] ALUFlags,
				output logic [31:0] PC,
				input logic [31:0] Instr,
				output logic [31:0] ALUResult, WriteData,
				input logic [31:0] ReadData,
				logic [2:0] ShiftOp
				);
	logic [31:0] PCNext, PCPlus4, PCPlus8;
	logic [31:0] ExtImm, SrcA, SrcAPre, SrcB, Result, RD1;
	// logic [3:0] RA1A;
	logic [3:0] RA1B, RA1, RA2;

	// next PC logic
	mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
	flopr #(32) pcreg(clk, reset, PCNext, PC);
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

	// register file logic
	// mux2 #(4) ra1muxA(Instr[11:7], Instr[11:8], Instr[4], RA1A);	//shamt5 and Rs selected by Instr[4]
	mux2 #(4) ra1muxB(Instr[19:16], 4'b1111, RegSrc[0], RA1B);	//Rn and R15 selected by B
	mux2 #(4) ra1mux(Instr[11:8], RA1B, Instr[25:21]!=01101, RA1);	//result of above 2 selected by if its not a non-MOV shift operation
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2); //Rm and Rd selected by STR
	regfile rf(clk, RegWrite, RA1, RA2,
				Instr[15:12], Result, PCPlus8,
				RD1, WriteData);
	mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
	extend ext(Instr[23:0], ImmSrc, ExtImm);

	// ALU logic
	mux2 #(32) srcamux(RD1, {Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11], Instr[11:7]}, Instr[4]==0 && Instr[25:21]==5'b01101, SrcAPre);	//shamt5 and Rn/R15 selected by non-MOV shift op
	mux2 #(32) rightshiftmux(SrcAPre, 32'b00000000000000000000000000100000, (ShiftOp==011 || ShiftOp==100 || ShiftOp == 110)&&(Instr[4]==0 && Instr[25:21]==5'b01101), SrcA); //shamt5 and 32 selected by right shift op
	mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB);	
	alu 		alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags, ShiftOp);
endmodule