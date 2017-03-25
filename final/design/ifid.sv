module ifid(input logic clk,input logic [31:0] InstrF,
  output logic [31:0] InstrD);

  always@(posedge clk)
  begin
  InstrD <= InstrF;
  end


endmodule
