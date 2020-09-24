module SixteenToOneMux(out, s, d);
	output logic out;
	input logic [15:0] d;
	input logic [3:0] s;
	
	logic [3:0] m;
	
	FourToOneMux f0 (m[0], s[1:0], d[3:0]);
	FourToOneMux f1 (m[1], s[1:0], d[7:4]);
	FourToOneMux f2 (m[2], s[1:0], d[11:8]);
	FourToOneMux f3 (m[3], s[1:0], d[15:12]);
	
	FourToOneMux f4 (out, s[3:2], m);
endmodule

module SixteenToOneMux_testbench;

	logic out;
	logic [15:0] d;
	
	logic [3:0] s;
	
	integer i;
	initial begin
	s=4'b0000;
	d=16'b0000000000000000;
	for (i = 0; i < 16; i++) begin
		d[i] = 1; #400;
		d[i] = 0;
		s++;
	end
	end

	SixteenToOneMux dut (.out, .s, .d);

endmodule