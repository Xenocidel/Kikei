module pcif(input logic clk, input logic [31:0] PC,
output logic [31:0] PCF);

always@(posedge clk)
begin
PCF <=PC;

end


endmodule
