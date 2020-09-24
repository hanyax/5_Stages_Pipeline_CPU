`timescale 1ns/10ps

module FiveTo32Decoder(out, in, enable);
	output logic [31:0] out;
	input logic [4:0] in;
	input logic enable;
	
	logic notIn4, enableAndNotIn4, enableAndIn4;
	
	not #50 not4 (notIn4, in[4]);
	and #50 a1 (enableAndNotIn4, enable, notIn4);
	and #50 a2 (enableAndIn4, enable, in[4]);
	
	FourToSixteenDecoder s41 (out[15:0], in[3:0], enableAndNotIn4);
	FourToSixteenDecoder s42 (out[31:16], in[3:0], enableAndIn4);
		
endmodule

module FiveTo32Decoder_testbench;
	logic [31:0] out;
	logic [4:0] in;
	logic enable;
	
	integer i;
	integer j;
	initial begin
	
	enable = 1; #10;
	for (i = 0; i < 32; i++) begin
		in = i; #300;
	end
	
	enable = 0; #10;
	
	for (j = 0; j < 32; j++) begin
		in = j; #300;
	end
	end
	
	FiveTo32Decoder dut (.out, .in, .enable);
	
endmodule
