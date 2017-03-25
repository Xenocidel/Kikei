module memwb(
  input logic clk,
  input logic PCSrcM,
  input logic RegWriteM,
  input logic MemtoRegM,
  output logic PCSrcW,
  output logic RegWriteW,
  output logic MemtoRegW
  );

  always@(posedge clk)
  begin
  PCSrcW <= PCSrcM;
  RegWriteW <= RegWriteM;
  MemtoRegW <= MemtoRegM;

  end

endmodule
