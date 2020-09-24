`timescale 1ns/10ps

module PC(out, in, reset, clk);
	output logic [63:0] out;
	input logic [63:0] in;
	input reset, clk;
	
	DFF64bit dff1 (.out, .in, .reset, .clk);

endmodule
