`timescale 1ns/10ps

module MemCircuit(out, ALUin, DataIn, xfer_size, WriteEn, ReadEn, MemToReg, clk);
	output logic [63:0] 	out;
	input logic [63:0] 	ALUin, DataIn;
	input logic	[3:0]		xfer_size;
	input logic WriteEn, ReadEn, MemToReg, clk;
	
	logic [63:0] MemOut;
	
	datamem dm (.address(ALUin), .write_enable(WriteEn), .read_enable(ReadEn), .write_data(DataIn),
					.clk(clk), .xfer_size(xfer_size), .read_data(MemOut));
	TwoToOneMux64bit mux (.out, .a(ALUin), .b(MemOut), .control(MemToReg));

endmodule