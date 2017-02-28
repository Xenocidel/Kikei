module decoder(input  logic [1:0] Op,
			   input  logic [5:0] Funct,
			   input  logic [3:0] Rd,
			   input  logic [11:0] Src2,
			   output logic [1:0] FlagW,
			   output logic 	  PCS, RegW, MemW,
			   output logic       MemtoReg, ALUSrc,
			   output logic [1:0] ImmSrc, RegSrc,
			   output logic [3:0] ALUControl,
			   output logic [2:0] ShiftOp,
			   output logic wr14,
				 output logic be
			   );
	logic [9:0] controls;
	logic 		Branch, ALUOp, S;

	// Main Decoder
	always_comb
		casex(Op)
								 // Data-processing immediate
			2'b00: if (Funct[5]) controls = 10'b0000101001;
								 // Data-processing register
				   else 		 controls = 10'b0000001001;
								 // LDR
			2'b01: if (Funct[0]) begin
			 controls = 10'b0001111000;
			 if(Funct[2]) begin
			 be = 1'b1;
			 end
			 else begin
			 be = 1'b0;
			 end
			 end
								 // STR
				   else begin
					 controls = 10'b1001110100;
					 if(Funct[2]) begin
					 be = 1'b1;
					 end
					 else begin
					 be = 1'b0;
					 end
					 end
								 // B
			2'b10: begin 			 	 controls = 10'b0110100010;
				assign wr14 = (controls[1] == 1 && Funct[4] == 1) ? 1 : 0;
				end
								// Unimplemented
			default: 			 controls = 10'bx;
	endcase

	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
			RegW, MemW, Branch, ALUOp} = controls;

	// ALU Decoder
	always_comb
	if (ALUOp) begin // which DP Instr?
		case(Funct[4:1])
			//4'b0100: ALUControl = 2'b00; // ADD
			//4'b0010: ALUControl = 2'b01; // SUB
			//4'b0000: ALUControl = 2'b10; // AND
			//4'b1100: ALUControl = 2'b11; // ORR
			4'b1000,
			4'b1001,
			4'b1010,
			4'b1011:
			begin
				S = 1;	//set S = 1 for TST, TEQ, CMP, CMN
				ALUControl = Funct[4:1];
			end
			default:
			begin
				S = Funct[0];
				ALUControl = Funct[4:1];
			end
		endcase

	// ALU Shift Functions
	begin
	if ((Funct[5] == 1'b1) || (Src2[11:4] == 8'b00000000))	//Move, ((Funct[5] == 1'b1)| (Src2[11:4] == 8'b00000000))
		ShiftOp[2:0] = 3'b000;
	else if ((Funct[5] == 1'b0) & (Src2[6:5] == 2'b00) & (Src2[11:4] != 8'b00000000))	//Log. Shift Left
		begin
			ShiftOp[2:0] = 3'b001;
			// Src2Val = Src2[4];
			// if (Src2[4] == 0)
			// begin
				// Rm = Src2[3:0];
			// end
			// else if (Src2[4] == 1)
			// begin
				// Rs = Src2[11:8];
				// Rm = Src2[3:0];
			// end
		end
	else if ((Funct[5] == 1'b0) & (Src2[6:5] == 2'b01))		//Log. Shift Right
	begin
		ShiftOp[2:0] = 3'b010;
		// Src2Val = Src2[4];
		// if (Src2[4] == 0)
		// begin
			// Rm = Src2[3:0];
		// end
		// else if (Src2[4] == 1)
		// begin
			// Rs = Src2[11:8];
			// Rm = Src2[3:0];
		// end
	end
	else if ((Funct[5] == 1'b0) & (Src2[6:5] == 2'b10))		//Arithmetic Shift Right
	begin
		ShiftOp[2:0] = 3'b011;
		// Src2Val = Src2[4];
		// if (Src2[4] == 0)
		// begin
			// Rm = Src2[3:0];
		// end
		// else if (Src2[4] == 1)
		// begin
			// Rs = Src2[11:8];
			// Rm = Src2[3:0];
		// end
	end
	else if ((Funct[5] == 1'b0) & (Src2[6:5] == 2'b11) & (Src2[11:4] == 8'b00000000))	//Rotate Right Extend
	begin
		ShiftOp[2:0] = 3'b100;
		// Src2Val = Src2[4];
		// if (Src2[4] == 0)
		// begin
			// Rm = Src2[3:0];
		// end
		// else if (Src2[4] == 1)
		// begin
			// Rs = Src2[11:8];
			// Rm = Src2[3:0];
		// end
	end
	else if ((Funct[5] == 1'b0) & (Src2[6:5] == 2'b11) & (Src2[11:4] != 8'b00000000)) //Rotate Right
	begin
		ShiftOp[2:0] = 3'b101;
		// Src2Val = Src2[4];
		// if (Src2[4] == 0)
			// begin
				// Rm = Src2[3:0];
			// end
			// else if (Src2[4] == 1)
			// begin
				// Rs = Src2[11:8];
				// Rm = Src2[3:0];
			// end
	end
	end

		// update flags if S bit is set or if TST/CMP (C & V only for arith and compare, see https://www.scss.tcd.ie/~waldroj/3d1/arm_arm.pdf page 50)
		FlagW[1] = S | (ALUControl == 4'b1000 | ALUControl == 4'b1001 | ALUControl == 4'b1010 | ALUControl == 4'b1011); // NZ flags
		FlagW[0] = S &(ALUControl == 4'b0010 | ALUControl == 4'b0011 | ALUControl == 4'b0100 | ALUControl == 4'b0101 | ALUControl == 4'b0110 | ALUControl == 4'b0111 | ALUControl == 4'b1000 | ALUControl == 4'b1001 | ALUControl == 4'b1010 | ALUControl == 4'b1011);
	end
	else begin
		ALUControl = 4'b0100; // ADD for non-DP instructions
		FlagW = 2'b00; // don't update Flags
	end

	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
