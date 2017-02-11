module alu(
    input logic [31:0] A, B,
    input logic [3:0] ALUControl,
	//input logic [1:0] ALUControl,
	output logic [31:0] ALUResult,
	output logic [3:0] ALUFlags
    );
	
	reg N, V, C, Z;
	assign ALUFlags = {N, V, C, Z};

    always_comb 
    begin
        // Default values to be overwritten.
        // To prevent the accidental creation of latches when the values are not assigned
        ALUResult = 32'd0;
		N = ALUResult[31];
		V = 1'b0;
		//C = 1'b0;
		Z = ~|ALUResult;
		
        case(ALUControl)
			4'b0000 :   // AND
            begin
                ALUResult = A & B;
                C = 1'b0;
                V = 1'b0;
                Z = ~|ALUResult;
				N = 1'b0;
            end
			4'b0001 :   // XOR
            begin
                ALUResult = A ^ B;
                C = 1'b0;
                V = 1'b0;
                Z = ~|ALUResult;
				N = 1'b0;
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
                {C,ALUResult} = A - B - C;
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
                {C,ALUResult} = B - A - C;
                if (B[31] & ~A[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~B[31] & A[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
                Z = ~|ALUResult;
				N = ALUResult[31];
            end
            // 4'b0011 :   // COMP
            // begin
                // ALUResult = 32'd0;    
                // C = 1'b0;
                // V = 1'b0;
                // if (A == B)
                    // Z = 1'b1;
                // else
                    // Z = 1'b0;
				// N = 1'b0;
            // end
            4'b1100 :   // OR
            begin
                ALUResult = A | B;
                C = 1'b0;
                V = 1'b0;
                Z = ~|ALUResult;
				N = 1'b0;
            end
            // 4'b0111 :   // NOT
            // begin
                // ALUResult = ~A;
                // C = 1'b0;
                // V = 1'b0;
                // Z = 1'b0;
				// N = 1'b0;
            // end
            // 4'b1001 :   // SLL
            // begin
                // {C,ALUResult} = $unsigned(A) << $unsigned(B);
                // V = 1'b0;
                // Z = 1'b0;
				// N = 1'b0;
            // end
            // 4'b1011 :   // MOV
            // begin
                // ALUResult = A;
                // C = 1'b0;
                // V = 1'b0;
                // Z = 1'b0;
				// N = 1'b0;
            // end
            default :
            begin
                ALUResult = 32'd0;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
        endcase
    end

endmodule

