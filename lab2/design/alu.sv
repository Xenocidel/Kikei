module alu(
    input logic [31:0] A, B,
    input logic [3:0] ALUControl,
	//input logic [1:0] ALUControl,
	output logic [31:0] ALUResult,
	output logic [3:0] ALUFlags,
	input logic [2:0] ShiftOp,	//used for determining which kind of shift instruction. For test/compare, this carries the S in right-most bit. 
	input logic PrevC
    );
	
	logic N, Z, C, V;
	assign ALUFlags = {N, Z, C, V};
	
    always_comb 
    begin
        // Default values to be overwritten.
        // To prevent the accidental creation of latches when the values are not assigned
		logic [31:0] tmp; //temporary variable for test/compare
		logic [63:0] tmp2; //temp var for rotate
		ALUResult = 32'd0;
		N = ALUResult[31];
		V = 1'b0;
		C = 1'b0;
		Z = ~|ALUResult;
        
		case(ALUControl)
			4'b0000 :   // AND
            begin
                ALUResult = A & B;
				Z = ~|ALUResult;
				N = ALUResult[31];
			end
			4'b0001 :   // XOR
            begin
                ALUResult = A ^ B;
				Z = ~|ALUResult;
				N = ALUResult[31];
			end
			4'b0010 :   // SUB
            begin
                {C,ALUResult} = A - B;
                if (A[31] & ~B[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~A[31] & B[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
				Z = ~|ALUResult;
				N = ALUResult[31];
            end
			4'b0011 :   // RSB (Reverse Sub)
            begin
                {C,ALUResult} = B - A;
                if (B[31] & ~A[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~B[31] & A[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
				Z = ~|ALUResult;
				N = ALUResult[31];
            end
            4'b0100 :   // Add
            begin
                {C,ALUResult} = A + B;
                if (A[31] & B[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~A[31] & ~B[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
				Z = ~|ALUResult;
				N = ALUResult[31];
            end
			4'b0101 :   // Add with Carry
            begin
                {C,ALUResult} = A + B + PrevC;
                if (A[31] & B[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~A[31] & ~B[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
				Z = ~|ALUResult;
				N = ALUResult[31];
            end
			4'b0110 :   // Sub with Carry
            begin
                {C,ALUResult} = A - B - ~PrevC;		//not working
                if (A[31] & ~B[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~A[31] & B[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
				Z = ~|ALUResult;
				N = ALUResult[31];
            end
			4'b0111 :   // Reverse Sub with Carry
            begin
                {C,ALUResult} = B - A - ~PrevC;		//not working
                if (B[31] & ~A[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~B[31] & A[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
				Z = ~|ALUResult;	
				N = ALUResult[31];
            end
			4'b1000 :	//Test
			begin
				tmp = A & B;
				N = tmp[31];
				Z = ~|tmp;
			end
			4'b1001 :	//TEQ
			begin
				tmp = A ^ B;
				N = tmp[31];
				Z = ~|tmp;
			end
			4'b1010 :	//Compare
			begin
				tmp = A - B;
				N = tmp[31];
				Z = ~|tmp;
			end
			4'b1011 :	//Compare Negative
			begin
				tmp = A + B;
				N = tmp[31];
				Z = ~|tmp;
			end
            4'b1100 :   // OR
            begin
                ALUResult = A | B;
				Z = ~|ALUResult;
				N = ALUResult[31];
            end
            4'b1101 : 	// Shifts
			begin
				case(ShiftOp)
				3'b000 : 	//MOV
				begin
					C = PrevC;	//no change in C flag
					ALUResult = B;
				end
				3'b001 : 	//LSL
				begin
					if (A[7:0] == 0) begin
						C = PrevC;
						ALUResult = B;
					end
					else if (A[7:0] == 32) begin
						C = B[0];
						ALUResult = 0;
					end
					else if (A[7:0] > 32) begin
						C = 0;
						ALUResult = 0;
					end
					else begin
						C = B[32-A];
						ALUResult = B << A[7:0];
					end
				end
				3'b010 : 	//LSR
				begin
					if (A[7:0] == 0) begin
						ALUResult = B;
						C = PrevC;
					end else if (A[7:0] == 32) begin
						ALUResult = 0;
						C = B[31];
					end else if (A[7:0] > 32) begin
						ALUResult = 0;
						C = 0;
					end else begin
						C = B[A[7:0]-1];
						ALUResult = B >> A;
					end
				end
				3'b011 : 	//ASR
				begin
					if (A[7:0] == 0) begin
						ALUResult = B;
						C = PrevC;
					end else if (A[7:0] >= 32) begin
						if (B[31] == 0) begin
							ALUResult = 0;
							C = B[31];
						end
						else begin
							ALUResult = 32'hFFFFFFFF;
							C = B[31];
						end
					end else begin
						C = B[A[7:0] - 1];
						ALUResult = B >>> A;
					end
				end
				3'b100 : 	//RRX
				begin
					{ALUResult, C} = {PrevC, ALUResult};
				end
				3'b101 : 	//ROR
				begin
					if (A[7:0] == 0) begin
						C = PrevC;
						ALUResult = B;
					end else if (A[4:0] == 0) begin
						C = B[31];
						ALUResult = B;
					end else begin
						C = B[A[4:0]-1];
						tmp2 = {B, B} >> A[4:0];
						ALUResult = tmp2[31:0];
					end
				
					// if (A>0) begin
						// ALUResult = {A[B-1:0], A[31:B]};
						// tmp2 = {B, B} >> A;
						// ALUResult = tmp2[31:0];
					// end
					// else if (A<0) begin
						// tmp2 = {B, B} >> A;
						// ALUResult = tmp2[63:32];
					// end
					// else
						// ALUResult = B;
				end
				default:
				begin
				end
				endcase
				Z = ~|ALUResult;
				N = ALUResult[31];
			end
			4'b1110 : 	// Clear
			begin
				ALUResult = A & ~B;
				Z = ~|ALUResult;
				N = ALUResult[31];
			end
			4'b1111 :   // NOT
            begin
                ALUResult = ~B;
				Z = ~|ALUResult;
				N = ALUResult[31];
            end
        endcase
    end

endmodule

