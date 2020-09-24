`timescale 1ns/10ps

module fullAdder(A, B, CI, out, CO);
	input logic A, B, CI;
	output logic out, CO;
	
	logic s1, s2, s3;
	
	xor #50 ab(out, A, B, CI);
	and #50 and1(S1, A, CI);
	and #50 and2(S2, B, CI);
	and #50 and3(S3, A, B);
	or #50 or1(CO, S1, S2, S3);
	
	
endmodule


module fullAdder_testbench;
	logic A, B, CI, out, CO;
	
	initial begin
		A = 0; B = 0; CI = 0; #10;
		A = 0; B = 0; CI = 1; #10;
		A = 0; B = 1; CI = 0; #10;
		A = 0; B = 1; CI = 1; #10;
		A = 1; B = 0; CI = 0; #10;
		A = 1; B = 0; CI = 1; #10;
		A = 1; B = 1; CI = 0; #10;
		A = 1; B = 1; CI = 1; #10;
	
	end
	
	
	fullAdder dut(.A, .B, .CI, .out, .CO);
endmodule
