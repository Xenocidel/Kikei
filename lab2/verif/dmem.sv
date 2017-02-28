module dmem(input  logic			clk, we, 
			input  logic [31:0]		a, wd,
			output logic [31:0]		rd);

			logic [31:0] RAM[63:0];

		  assign rd = RAM[a[31:2]]; // word aligned

		  always @(posedge clk)
		    if (we)
		      RAM[a[31:2]] <= wd;

	// logic [7:0] RAM0 [511:0];
	// logic [7:0] RAM1[511:0];
	// logic [7:0] RAM2 [511:0];
	// logic [7:0] RAM3[511:0];
	//
	// //assign rd = RAM[a[31:2]];	//word aligned
	// always_comb begin
	// 	if(be) begin
	// 	casex(a[1:0])
	// 	2'b00:
	// 	rd <= {22'b0, RAM0[a[31:2]]};
	// 	2'b01:
	// 	rd <= {22'b0, RAM1[a[31:2]]};
	// 	2'b10:
	// 	rd <= {22'b0, RAM2[a[31:2]]};
	// 	2'b11:
	// 	rd <= {22'b0, RAM3[a[31:2]]};
	//
	// 	endcase
	// 	end
	// 	else begin
	// 	rd <= {RAM3[a[31:2]], RAM2[a[31:2]], RAM1[a[31:2]], RAM0[a[31:2]]};
	// 	end
	// end
	//
	// always_ff@(posedge clk)
	// 	if(we) begin
	// 	if(be)begin
	// 	casex(a[1:0])
	// 	2'b00:
	// 	RAM0[a[10:2]] <= wd[7:0];
	// 	2'b01:
	// 	RAM1[a[10:2]] <= wd[7:0];
	// 	2'b10:
	// 	RAM2[a[10:2]] <= wd[7:0];
	// 	2'b11:
	// 	RAM3[a[10:2]] <= wd[7:0];
	// 	endcase
	// 	end
	// 	else begin
	// 	RAM0[a[10:2]] <= wd[7:0];
	// 	RAM1[a[10:2]] <= wd[15:8];
	// 	RAM2[a[10:2]] <= wd[23:16];
	// 	RAM3[a[10:2]] <= wd[31:24];
	// 	end
	// 	end
endmodule
