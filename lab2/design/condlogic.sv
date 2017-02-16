module condlogic(input logic clk, reset,
			input logic [3:0] Cond,
			input logic [3:0] ALUFlags,
			input logic [1:0] FlagW,
			input logic PCS, RegW, MemW,
			output logic PCSrc, RegWrite,
						MemWrite);
	logic [1:0] FlagWrite;
	logic [3:0] Flags;
	logic CondEx;
	
	flopenr #(2)flagreg1(clk, reset, FlagWrite[1],
			ALUFlags[3:2], Flags[3:2]);
	flopenr #(2)flagreg0(clk, reset, FlagWrite[0],
			ALUFlags[1:0], Flags[1:0]);
			
	// write controls are conditional
	condcheck cc(Cond, Flags, CondEx);
	assign FlagWrite = FlagW & {2{CondEx}};
	assign RegWrite = RegW & CondEx;
	assign MemWrite = MemW & CondEx;
	assign PCSrc = PCS & CondEx;
endmodule

module condcheck(input logic [3:0] Cond,
			input logic [3:0] Flags,
			output logic CondEx);
			
	logic N, Z, C, V, ge;
	
	assign {N, Z, C, V} = Flags;
	assign ge = (N == V);

	always_comb
		case(Cond)
			4'b0000: CondEx = Z; // EQ
			4'b0001: CondEx = ~Z; // NE
			4'b0010: CondEx = C; // CS
			4'b0011: CondEx = ~C; // CC
			4'b0100: CondEx = N; // MI
			4'b0101: CondEx = ~N; // PL
			4'b0110: CondEx = V; // VS
			4'b0111: CondEx = ~V; // VC
			4'b1000: CondEx = C & ~Z; // HI
			4'b1001: CondEx = ~(C & ~Z); // LS
			4'b1010: CondEx = ge; // GE
			4'b1011: CondEx = ~ge; // LT
			4'b1100: CondEx = ~Z & ge; // GT
			4'b1101: CondEx = ~(~Z & ge); // LE
			4'b1110: CondEx = 1'b1; // Always
			default: CondEx = 1'bx; // undefined
		endcase
endmodule