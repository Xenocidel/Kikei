module alu_32(
    input logic [31:0] A, B,
    input logic [3:0] opcode,
	output logic N,	//negative
    output logic V,	//overflow
    output logic C,	//carry
    output logic Z,	//zero
    output logic [31:0] output1
    );


    always_comb 
    begin
        // Default values to be overwritten.
        // To prevent the accidental creation of latches when the values are not assigned
        N = 1'b0;
		V = 1'b0;
        C = 1'b0;
        Z = 1'b0;
        output1 = 32'd0;

        case(opcode)
            4'b0000 :  // No OP
            begin
                output1 = 32'd0;
				N = 1'b0;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
            end
            4'b0001 :   // Add
            begin
                {C,output1} = A + B;
                if (A[31] & B[31] & ~output1[31])
                    V = 1'b1;
                else if (~A[31] & ~B[31] & output1[31])
                    V = 1'b1;
                else
                    V = 1'b0;
                Z = 1'b0;
				N = output1[31];
            end
            4'b0010 :   // SUB
            begin
                {C,output1} = A - B;
                if (A[31] & ~B[31] & ~output1[31])
                    V = 1'b1;
                else if (~A[31] & B[31] & output1[31])
                    V = 1'b1;
                else
                    V = 1'b0;
                Z = 1'b0;
				N = output1[31];
            end
            4'b0011 :   // COMP
            begin
                output1 = 32'd0;    
                C = 1'b0;
                V = 1'b0;
                if (A == B)
                    Z = 1'b1;
                else
                    Z = 1'b0;
				N = 1'b0;
            end
            4'b0101 :   // AND
            begin
                output1 = A & B;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
            4'b0110 :   // OR
            begin
                output1 = A | B;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
            4'b0111 :   // NOT
            begin
                output1 = ~A;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
            4'b1000 :   // XOR
            begin
                output1 = A ^ B;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
            4'b1001 :   // SLL
            begin
                {C,output1} = $unsigned(A) << $unsigned(B);
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
            4'b1011 :   // MOV
            begin
                output1 = A;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
            default :
            begin
                output1 = 32'd0;
                C = 1'b0;
                V = 1'b0;
                Z = 1'b0;
				N = 1'b0;
            end
        endcase
    end

endmodule

