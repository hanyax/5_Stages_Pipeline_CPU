// Test bench for ALU
`timescale 1ns/10ps

module TwoToOneMux (out, s, d);
	output logic out;
	input logic s;
	input logic [1:0] d;
	
	not #50 invs (invS, s);
	and #50 andA (and0, d[0], invS);
	and #50 andB (and1, d[1], s);
	or #50 OR (out, and0, and1);
	
endmodule

module TwoToOneMux_testbench;

	logic out;
	logic [1:0] d;
	logic  s;
	
	initial begin
	d = 2'b00; s=0;#400;
	d = 2'b01; s=0;#400;
	d = 2'b10; s=1;#400;
	d = 2'b11; s=1;#400;
	d = 2'b00; s=0;#400;
	d = 2'b01; s=0;#400;
	d = 2'b10; s=1;#400;
	d = 2'b11; s=1;#400;
	d = 2'b00; s=0;#400;
	d = 2'b01; s=0;#400;
	d = 2'b10; s=1;#400;
	d = 2'b11; s=1;#400;
	
	end
	
	TwoToOneMux dut (.out, .s, .d);


endmodule