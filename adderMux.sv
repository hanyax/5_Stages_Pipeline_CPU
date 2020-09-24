// Test bench for ALU
`timescale 1ns/10ps

module adderMux(A, B, S0, CI, out, CO);
	input logic A, B, S0, CI;
	output logic out, CO;
	
	logic Binvert;
	not #50 (Binvert, B);
	
	logic [1:0]muxin;
	
	assign muxin[0] = B;
	assign muxin[1] = Binvert;	
	
	logic muxout;

	TwoToOneMux mux1 (muxout, S0, muxin);
	fullAdder adder1 (A, muxout, CI, out, CO);


endmodule

module adderMux_testbench;
	logic A, B, S0, CI, out, CO;
	
	initial begin
		S0 = 0; A = 0; B = 0; CI = 0; #400;
		S0 = 0; A = 0; B = 0; CI = 1; #400;
		S0 = 0; A = 0; B = 1; CI = 0; #400;
		S0 = 0; A = 0; B = 1; CI = 1; #400;
		S0 = 0; A = 1; B = 0; CI = 0; #400;
		S0 = 0; A = 1; B = 0; CI = 1; #400;
		S0 = 0; A = 1; B = 1; CI = 0; #400;
		S0 = 0; A = 1; B = 1; CI = 1; #400;
		
		S0 = 1; A = 0; B = 0; CI = 0; #400;
		S0 = 1; A = 0; B = 0; CI = 1; #400;
		S0 = 1; A = 0; B = 1; CI = 0; #400;
		S0 = 1; A = 0; B = 1; CI = 1; #400;
		S0 = 1; A = 1; B = 0; CI = 0; #400;
		S0 = 1; A = 1; B = 0; CI = 1; #400;
		S0 = 1; A = 1; B = 1; CI = 0; #400;
		S0 = 1; A = 1; B = 1; CI = 1; #400;
	end

		adderMux dut(.A, .B, .S0, .CI, .out, .CO);


endmodule