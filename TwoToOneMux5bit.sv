`timescale 1ns/10ps

module TwoToOneMux5bit(out, a, b, control);
	output logic [4:0] out;
	input logic [4:0] a, b;
	input logic control;
	
	genvar i;
	generate
		for (i=0;i<5;i++) begin : muxs
			TwoToOneMux mux (.out(out[i]), .s(control), .d({b[i], a[i]}));
		end
	endgenerate
endmodule

module TwoToOneMux5bit_testbench;
	logic [4:0] out, a, b;
	logic control;
	
	initial begin
	a = 5'b00000;b = 5'b00000; control=0;#400;
	control=1;#400;
	
	b = 5'b00000;a = 5'b00000; control=0;#400;
	control=1;#400;
	
	end
	
	TwoToOneMux5bit dut (.out, .a, .b, .control);
	
endmodule
