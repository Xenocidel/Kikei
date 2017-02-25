module controller(input logic clk, reset,
				input logic [31:0] Instr,
				input logic [3:0] ALUFlags,
				output logic [1:0] RegSrc,
				output logic RegWrite,
				output logic [1:0] ImmSrc,
				output logic ALUSrc,
				output logic [3:0] ALUControl,
				output logic MemWrite, MemtoReg,
				output logic PCSrc
				);
logic [1:0] FlagW;
logic 		PCS, RegW, MemW;
logic [2:0] ShiftOp;
decoder dec(Instr[27:26], Instr[25:20], Instr[15:12], Instr[11:0],
			FlagW, PCS, RegW, MemW,
			MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl, ShiftOp);
condlogic cl(clk, reset, Instr[31:28], ALUFlags,
			FlagW, PCS, RegW, MemW,
			PCSrc, RegWrite, MemWrite);
endmodule
