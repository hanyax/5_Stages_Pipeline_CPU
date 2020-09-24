// Test bench for ALU
`timescale 1ns/10ps

module testZero(out, in);
	input logic [63:0] in;
	output logic out;
	
	logic [63:0] Notin;
	genvar i;
	generate
		for(i=0;i<64;i++) begin : eachNot
			not #50 NOTs (Notin[i], in[i]);
		end
	endgenerate 
	
	and16 and0(out0, Notin[15:0]);
	and16 and1(out1, Notin[31:16]);
	and16 and2(out2, Notin[47:32]);
	and16 and3(out3, Notin[63:48]);
	and #50 and4(out, out0, out1, out2, out3);

endmodule

module testZero_testbench;
	logic [63:0] in;
	logic out;
	
	integer i;
	initial begin
	in = 64'b0; #800;
	in = 64'b1; #800;
	in = 64'b11; #800;
	end
	
	testZero dut (.out, .in);

endmodule
