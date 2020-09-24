module TwoToFourDecoder(out, in, enable);
	output logic [3:0] out;
	input logic [1:0] in;
	input logic enable;
	
	logic NotFirst, NotSecond;
	
	not n1 (NotFirst, in[0]);
	not n2 (NotSecond, in[1]);
	
	and a1 (out[0], NotFirst, NotSecond, Enable);
	and a2 (out[1], in[0], NotSecond, Enable);
	and a3 (out[2], NotFirst, in[1], Enable);
	and a4 (out[3], in[0], in[1],  Enable);
endmodule

module TwoToFourDecoder_testbench;
	logic [1:0] in;
	logic enable;
	logic [3:0] out;
	
	initial begin
		in = 2'b00; #10;
		in = 2'b01; #10;
		in = 2'b10; #10;
		in = 2'b11; #10;
	end
	
	TwoToFourDecoder dut (.out, .in, .enable);
	
endmodule
