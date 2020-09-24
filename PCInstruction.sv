`timescale 1ns/10ps

module PCInstruction(instruction, BrTaken, UncondiBr, clk);
	output logic  [31:0] instruction;
	input logic BrTaken, UncondiBr, clk;

	logic [63:0] PC = 64'b0;
	logic [63:0] PCAdd4Out;
	logic negative, zero, overflow, carry_out;
	
	ALU add4 (.A(PC), .B(4), .cntrl(3'b010), .result(PCAdd4Out), .negative, .zero, .overflow, .carry_out);
	
	
	instructmem allocInstruc (.address(PC), .instruction, .clk);
endmodule 