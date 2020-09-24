// Test bench for ALU
`timescale 1ns/10ps

module ALU(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output negative, zero, overflow, carry_out;
	
	logic [63:0] carryout;
	
	bitALU alu0 (.A(A[0]), .B(B[0]), .CI(cntrl[0]), .S(cntrl), .CO(carryout[0]), .out(result[0]));
	
	genvar i;
	generate
		for(i=1;i<64;i++) begin : eachALU
			bitALU ALUs (.A(A[i]), .B(B[i]), .CI(carryout[i-1]), .S(cntrl), .CO(carryout[i]), .out(result[i]));
		end
	endgenerate 
	
	testZero Zero(zero, result);
	assign negative = result[63];
	xor #50 xor1(overflow, carryout[63], carryout[62]);
	assign carry_out = carryout[63];
	
endmodule