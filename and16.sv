`timescale 1ns/10ps

module and16(out, in);
	input logic [15:0] in;
	output logic out;
	
	and #50 and0(out0, in[0], in[1], in[2], in[3]);
	and #50 and1(out1, in[4], in[5], in[6], in[7]);
	and #50 and2(out2, in[8], in[9], in[10], in[11]);
	and #50 and3(out3, in[12], in[13], in[14], in[15]);
	and #50 and4(out, out0, out1, out2, out3);
	
endmodule

module and16_testbench;
	logic [15:0] in;
	logic out;
	
	integer i;
	initial begin
	in = 16'b0; #300;
	for (i = 0; i < 65536; i++) begin
		in += 1; #300;
	end
	end
	
	and16 dut (.out, .in);

endmodule
