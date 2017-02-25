module alu(
    input logic [31:0] A, B,
    input logic [3:0] ALUControl,
	//input logic [1:0] ALUControl,
	output logic [31:0] ALUResult,
	output logic [3:0] ALUFlags,
	input logic [2:0] ShiftOp	//used for determining which kind of shift instruction. For test/compare, this carries the S in right-most bit. 
    );
	
	logic N, V, C, Z;
	assign ALUFlags = {N, V, C, Z};
	
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
                {C,ALUResult} = A + B + C;
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
                {C,ALUResult} = A - B - C;	//-C or +C?
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
                {C,ALUResult} = B - A - C;	//-C or +C?
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
					ALUResult = B;
				end
				3'b001 : 	//LSL
				begin
					ALUResult = A << B;
				end
				3'b010 : 	//LSR
				begin
					ALUResult = A >> B;
				end
				3'b011 : 	//ASR
				begin
					ALUResult = A >>> B;
				end
				3'b100 : 	//RRX
				begin
					{ALUResult, C} = {C, ALUResult};
				end
				3'b000 : 	//ROR
				begin
					if (B>0) begin
						//ALUResult = {A[B-1:0], A[31:B]};
						tmp2 = {A, A} >> B;
						ALUResult = tmp2[31:0];
					end
					else if (B<0) begin
						tmp2 = {A, A} >> B;
						ALUResult = tmp2[63:32];
					end
					else
						ALUResult = A;
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

