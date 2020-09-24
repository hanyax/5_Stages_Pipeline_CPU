module FourToSixteenDecoder(out, in, enable);
	output logic [15:0] out;
	input logic [3:0] in;
	input logic enable;
	
	logic [3:0] s3s2out;
	
	TwoToFourDecoder s3s2 (s3s2out, in[3:2], enable);
	TwoToFourDecoder s1s01 (out[3:0], in[1:0], s3s2out[0]);
	TwoToFourDecoder s1s02 (out[7:4], in[1:0], s3s2out[1]);
	TwoToFourDecoder s1s03 (out[11:8], in[1:0], s3s2out[2]);
	TwoToFourDecoder s1s04 (out[15:12], in[1:0], s3s2out[3]);
	
endmodule


module FourToSixteenDecoder_testbench;
	logic [15:0] out;
	logic [3:0] in;
	logic enable;
	
	initial begin
		enable = 1; #10;
		in = 4'b0000; #300;
		in = 4'b0001; #300;
		in = 4'b0010; #300;
		in = 4'b0011; #300;
		in = 4'b0100; #300;
		in = 4'b0101; #300;
		in = 4'b0110; #300;
		in = 4'b0111; #300;
		in = 4'b1000; #300;
		in = 4'b1001; #300;
		in = 4'b1010; #300;
		in = 4'b1011; #300;
		in = 4'b1100; #300;
		in = 4'b1101; #300;
		in = 4'b1110; #300;
		in = 4'b1111; #300;
		
		enable = 0; #10;
		in = 4'b0000; #300;
		in = 4'b0001; #300;
		in = 4'b0010; #300;
		in = 4'b0011; #300;
		in = 4'b0100; #300;
		in = 4'b0101; #300;
		in = 4'b0110; #300;
		in = 4'b0111; #300;
		in = 4'b1000; #300;
		in = 4'b1001; #300;
		in = 4'b1010; #300;
		in = 4'b1011; #300;
		in = 4'b1100; #300;
		in = 4'b1101; #300;
		in = 4'b1110; #300;
		in = 4'b1111; #300;
		
	end
	
	FourToSixteenDecoder dut (.out, .in, .enable);
	
endmodule
