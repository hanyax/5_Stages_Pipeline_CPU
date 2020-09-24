// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	ALU dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		// add 0
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		// add 0 and 1
		A = 64'h0000000000000000; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000001 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		// add -1 and 1, case(Cin = 1, Cout = 1)
		A = -1; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		// add -2 and 1
		A = -2; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'b1111111111111111111111111111111111111111111111111111111111111111 && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		// add -2 and -1 
		A = -2; B = -1;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFD && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		// Case(Cin = 1, Cout = 0)
		A = 64'h4000000000000000; B = 64'h4000000000000000;
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);
		
	   // Case(Cin = 0, Cout = 1)
		A = 64'h8000000000000000; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'h00000000000000000 && carry_out == 1 && overflow == 1 && negative == 0 && zero == 1);
		
		
		$display("%t testing subtract", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		// 1 - 2
		A = 1; B = 2;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		
		// 2 - 1
		A = 64'h0000000000000002; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000001 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);
		
		
		// 1 - (-2)
		A = 64'h0000000000000001; B = -2;
		#(delay);
		assert(result == 64'h0000000000000003 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		
		// -1 - 1
		A = -1; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFFE && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		// -1 - (-2)
		A = -1; B = -2;
		#(delay);
		assert(result == 64'h0000000000000001 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);
		
		// -2 - (-1)
		A = -2; B = -1;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		$display("%t testing AND operations", $time);
		cntrl = ALU_AND;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == (A & B) && negative == (A[63] & B[63]) && zero == ((A & B) == 0));
		end

		$display("%t testing OR operations", $time);
		cntrl = ALU_OR;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == (A | B) && negative == (A[63] | B[63]) && zero == ((A | B) == 0));
		end
		
		$display("%t testing OR operations", $time);
		cntrl = ALU_XOR;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == (A ^ B) && negative == (A[63] ^ B[63]) && zero == ((A ^ B) == 0));
		end
	end
endmodule