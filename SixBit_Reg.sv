`timescale 1ns/10ps

module SixBit_Reg(dataOut, dataIn, writeEnable, clk);
	output logic [5:0] dataOut;
	input logic [5:0] dataIn;
	input logic writeEnable, clk;
	
	genvar i;
	generate
		for (i=0; i<6; i++) begin : eachDff
			DFFEn df (.q(dataOut[i]), .d(dataIn[i]), .enable(writeEnable), .clk);
		end
	endgenerate
endmodule