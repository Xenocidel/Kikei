module top(
    input  logic clk, reset,
    output logic [31:0] DataAdr,
    output logic [31:0] WriteData,
    logic MemWrite
    );

    logic [31:0] PC, InstrF,InstrD, ReadData;
    logic[31:0] PCF;
    logic be;


    // instantiate processor and memories
    arm  arm(clk, reset, PC, InstrD, MemWrite, DataAdr, WriteData, ReadData, be);
    pcif pcfi(clk, PC, PCF);
	// arm  arm(clk, reset, PC, Instr, MemWrite, ALUResult, WriteData, ReadData);



    imem imem(PCF, InstrF);

    ifid ifid(clk, InstrF, InstrD);

    dmem dmem(clk, MemWrite,be, DataAdr, WriteData, ReadData);

endmodule
