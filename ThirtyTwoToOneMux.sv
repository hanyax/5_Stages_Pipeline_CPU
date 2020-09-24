`timescale 1ns/10ps

module ThirtyTwoToOneMux(out, s, d);
	output logic out;
	input logic [31:0] d;
	input logic [4:0] s;
	
	logic sixteen0, sixteen1;
	logic and0, and1, notS4;
	
	SixteenToOneMux s0 (sixteen0, s[3:0], d[15:0]);
	SixteenToOneMux s1 (sixteen1, s[3:0], d[31:16]);
	
	not #50 nots4 (notS4, s[4]);
	
	and #50 a0 (and0, notS4, sixteen0);
	and #50 a1 (and1, s[4], sixteen1);
	
	or #50 o1 (out, and0, and1);
		
endmodule

module ThirtyTwoToOneMux_testbench;

	logic out;
	logic [31:0] d;
	
	logic [4:0] s;
	
	integer i;
	initial begin
	s=5'b00000;
	d=32'b00000000000000000000000000000000;
	for (i = 0; i < 32; i++) begin
		d[i] = 1; #800;
		d[i] = 0;
		s++;
	end
	end
	
	ThirtyTwoToOneMux dut (.out, .s, .d);

endmodule