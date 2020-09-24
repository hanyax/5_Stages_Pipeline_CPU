`timescale 1ns/10ps

module TwoToOneMux64bit(out, a, b, control);
	output logic [63:0] out;
	input logic [63:0] a, b;
	input logic control;
	
	genvar i;
	generate
		for (i=0;i<64;i++) begin : muxs
			TwoToOneMux mux (.out(out[i]), .s(control), .d({b[i], a[i]}));
		end
	endgenerate
endmodule

module TwoToOneMux64bit_testbench;
	logic [63:0] out, a, b;
	logic control;
	
	initial begin
	a = 64'h0000000000000000;b = 64'h1111111111111111; control=0;#400;
	control=1;#400;
	
	b = 64'h0000000000000000;a = 64'h1111111111111111; control=0;#400;
	control=1;#400;
	
	end
	
	TwoToOneMux64bit dut (.out, .a, .b, .control);
	
endmodule
