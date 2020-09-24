// Test bench for ALU
`timescale 1ns/10ps

module bitALU(A, B, CI, S, CO, out);
	input logic A, B, CI;
	input logic [2:0]S;
	output logic CO, out;
	
	logic andAB, xorAB, orAB, adderR;
	
	and #50 and1(andAB, A, B);
	xor #50 xor1(xorAB, A, B);
	or #50 or1(orAB, A, B);
	
	adderMux addermux1(A, B, S[0], CI, adderR, CO);
	
	
	logic [7:0]muxin;
	assign muxin[0] = B;
	assign muxin[2] = adderR;
	assign muxin[3] = adderR;
	assign muxin[4] = andAB;
	assign muxin[5] = orAB;
	assign muxin[6] = xorAB;
	
	eightToOneMux mux1(S, muxin, out);
	
endmodule

module bitALU_testbench;
	logic A, B, CI;
	logic [2:0]S;
	logic CO, out;
	
	initial begin
		
		B = 0; S = 3'b000; #800;
		B = 1; S = 3'b000; #800;
		B = 0; S = 3'b000; #800;
		B = 1; S = 3'b000; #800;
		
		
		
		// test and
		A = 0; B = 0; S = 3'b100; #800;
		A = 0; B = 1; S = 3'b100; #800;
		A = 1; B = 0; S = 3'b100; #800;
		A = 1; B = 1; S = 3'b100; #800;
		
		A = 0; B = 0; S = 3'b100; #800;
		A = 0; B = 1; S = 3'b100; #800;
		A = 1; B = 0; S = 3'b100; #800;
		A = 1; B = 1; S = 3'b100; #800;
		
		
		
		// test or 
		A = 0; B = 0; S = 3'b101; #800;
		A = 0; B = 1; S = 3'b101; #800;
		A = 1; B = 0; S = 3'b101; #800;
		A = 1; B = 1; S = 3'b101; #800;
		
		A = 0; B = 0; S = 3'b101; #800;
		A = 0; B = 1; S = 3'b101; #800;
		A = 1; B = 0; S = 3'b101; #800;
		A = 1; B = 1; S = 3'b101; #800;
		
		
		
		// test xor 
		A = 0; B = 0; S = 3'b110; #800;
		A = 0; B = 1; S = 3'b110; #800;
		A = 1; B = 0; S = 3'b110; #800;
		A = 1; B = 1; S = 3'b110; #800;
		
		A = 0; B = 0; S = 3'b110; #800;
		A = 0; B = 1; S = 3'b110; #800;
		A = 1; B = 0; S = 3'b110; #800;
		A = 1; B = 1; S = 3'b110; #800;
		
		
		// test add
		
		A = 0; B = 0; CI = 0; S = 3'b010; #800;
		A = 0; B = 1; CI = 0; S = 3'b010; #800;
		A = 1; B = 0; CI = 0; S = 3'b010; #800;
		A = 1; B = 1; CI = 0; S = 3'b010; #800;
		
		
		
		A = 0; B = 0; CI = 1; S = 3'b010; #800;
		A = 0; B = 1; CI = 1; S = 3'b010; #800;
		A = 1; B = 0; CI = 1; S = 3'b010; #800;
		A = 1; B = 1; CI = 1; S = 3'b010; #800;
		
		
	
		// test subtract
		
		A = 0; B = 0; CI = 0; S = 3'b011; #800;
		A = 0; B = 1; CI = 0; S = 3'b011; #800;
		A = 1; B = 0; CI = 0; S = 3'b011; #800;
		A = 1; B = 1; CI = 0; S = 3'b011; #800;
		
		
		
		A = 0; B = 0; CI = 1; S = 3'b010; #800;
		A = 0; B = 1; CI = 1; S = 3'b010; #800;
		A = 1; B = 0; CI = 1; S = 3'b010; #800;
		A = 1; B = 1; CI = 1; S = 3'b010; #800;
		
	end
	

	bitALU dut(.A, .B, .CI, .S, .CO, .out);
endmodule
