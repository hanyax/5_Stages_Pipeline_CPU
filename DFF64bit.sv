`timescale 1ns/10ps

module DFF64bit(out, in, reset, clk);
	output logic [63:0] out;
	input logic [63:0] in;
	input logic reset, clk;
	always_ff @(posedge clk)
		if (reset)
			out <= 64'b0; // On reset, set to 0
		else
			out <= in; // Otherwise out = d

endmodule