`timescale 1ns/10ps

module TwoToFourDecoder(out, in, enable);
	output logic [3:0] out;
	input logic [1:0] in;
	input logic enable;
	
	logic NotFirst, NotSecond;
	logic [3:0] outTemp;
	
	not #50 n1 (NotFirst, in[0]);
	not #50 n2 (NotSecond, in[1]);
	
	and #50 at1 (outTemp[0], NotFirst, NotSecond);
	and #50 at2 (outTemp[1], in[0], NotSecond);
	and #50 at3 (outTemp[2], NotFirst, in[1]);
	and #50 at4 (outTemp[3], in[0], in[1]);
	
	and #50 a1 (out[0], outTemp[0],enable);
	and #50 a2 (out[1], outTemp[1],enable);
	and #50 a3 (out[2], outTemp[2],enable);
	and #50 a4 (out[3], outTemp[3],enable);
	
endmodule

module TwoToFourDecoder_testbench;
	logic [3:0] out;
	
	logic [1:0] in;
	
	logic enable;
	
	initial begin
		enable = 1; #10;
		in = 2'b00; #300;
		in = 2'b01; #300;
		in = 2'b10; #300;
		in = 2'b11; #300;
		
		enable = 0; #10;
		in = 2'b00; #300;
		in = 2'b01; #300;
		in = 2'b10; #300;
		in = 2'b11; #300;
	end
	
	TwoToFourDecoder dut (.out, .in, .enable);
	
endmodule
