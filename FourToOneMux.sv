module FourToOneMux(out, s, d);
	output logic out;
	input logic [3:0] d;
	input logic [1:0] s;
	logic [1:0] m0m1;
	
	TwoToOneMux m0(M0, s[0], d[1:0]);
	TwoToOneMux m1(M1, s[0], d[3:2]);
	assign m0m1[0] = M0;
	assign m0m1[1] = M1;
	TwoToOneMux m2(out, s[1], m0m1);
	
endmodule

module FourToOneMux_testbench;

	logic out;
	logic [3:0] d;
	logic [1:0] s;
	
	initial begin
	d = 4'b0001; s=2'b00;#400;
	d = 4'b0010; s=2'b01;#400;
	d = 4'b0100; s=2'b10;#400;
	d = 4'b1000; s=2'b11;#400;
	d = 4'b0001; s=2'b00;#400;
	d = 4'b0010; s=2'b01;#400;
	d = 4'b0100; s=2'b10;#400;
	d = 4'b1000; s=2'b11;#400;
	
	end
	
	FourToOneMux dut (.out, .s, .d);


endmodule
