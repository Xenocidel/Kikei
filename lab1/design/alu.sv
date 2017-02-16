module alu(
    input logic [31:0] A, B,
    //input logic [3:0] ALUControl,
	input logic [1:0] ALUControl,
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
		C = 1'b0;
		Z = ~|ALUResult;
		
        case(ALUControl)
            // 4'b0000 :  // No OP
            // begin
                // ALUResult = 32'd0;
				// N = 1'b0;
                // C = 1'b0;
                // V = 1'b0;
                // Z = 1'b0;
            // end
            2'b00 :   // Add
            begin
                {C,ALUResult} = A + B;
                if (A[31] & B[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~A[31] & ~B[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
                Z = 1'b0;
				N = ALUResult[31];
            end
            2'b01 :   // SUB
            begin
                {C,ALUResult} = A - B;
                if (A[31] & ~B[31] & ~ALUResult[31])
                    V = 1'b1;
                else if (~A[31] & B[31] & ALUResult[31])
                    V = 1'b1;
                else
                    V = 1'b0;
                Z = 1'b0;
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
            2'b10 :   // AND
            begin
                ALUResult = A & B;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
            2'b11 :   // OR
            begin
                ALUResult = A | B;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
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
            // 4'b1000 :   // XOR
            // begin
                // ALUResult = A ^ B;
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

