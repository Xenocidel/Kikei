module exemem(input logic clk,
  input logic PCSrcE,
  input logic RegWriteE,
  input logic MemtoRegE,
  input logic MemWriteE,
  output logic PCSrcM,
  output logic RegWriteM,
  output logic MemtoRegM,
  output logic MemWriteM
  );

  always@(posedge clk)
  begin
  PCSrcM <= PCSrcE;
  RegWriteM <= RegWriteE;
  MemtoRegM <= MemtoRegE;
  MemWriteM <= MemWriteE;
  end

endmodule
