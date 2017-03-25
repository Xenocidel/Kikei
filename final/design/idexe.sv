module idexe(input logic clk,
  input logic [1:0] RegSrcD,
  input logic RegWriteD,
  input logic [1:0] ImmSrcD,
  input logic ALUSrcD,
  input logic [3:0] ALUControlD,
  input logic MemWriteD, MemtoRegD,
  input logic PCSrcD,
  output logic[1:0] RegSrcE,
  output logic RegWriteE,
  output logic [1:0]ImmSrcE,
  output logic ALUSrcE,
  output logic [3:0] ALUControlE,
  output logic MemWriteE, MemtoRegE,
  output logic PCSrcE);

  always@(posedge clk)
  begin
  RegSrcE <=RegSrcD;
  RegWriteE <= RegWriteD;
  ImmSrcE <= ImmSrcD;
  ALUSrcE <= ALUSrcD;
  ALUControlE <= ALUControlD;
  MemWriteE <= MemWriteD;
  MemtoRegE <= MemtoRegD;
  PCSrcE <= PCSrcD;
  end

endmodule
