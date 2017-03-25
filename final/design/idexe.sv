module idexe(input logic clk,
  input logic [1:0] RegSrcD,
  input logic RegWriteD,
  input logic [1:0] ImmSrcD,
  input logic ALUSrcD,
  input logic [3:0] ALUControlD,
  input logic MemWriteD, MemtoRegD,
  input logic PCSrcD,
  input logic [2:0] ShiftOpD,
  input logic [31:0] InstrD,
  output logic[1:0] RegSrcE,
  output logic RegWriteE,
  output logic [1:0]ImmSrcE,
  output logic ALUSrcE,
  output logic [3:0] ALUControlE,
  output logic MemWriteE, MemtoRegE,
  output logic PCSrcE,
  output logic [2:0] ShiftOpE,
  output logic [31:0] InstrE);

  always@(posedge clk)
  begin
  InstrE <= InstrD;
  ShiftOpE <= ShiftOpD;
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
