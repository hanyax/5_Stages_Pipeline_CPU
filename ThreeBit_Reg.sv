`timescale 1ns/10ps

module ThreeBit_Reg(dataOut, dataIn, writeEnable, clk);
	output logic [2:0] dataOut;
	input logic [2:0] dataIn;
	input logic writeEnable, clk;
	
	genvar i;
	generate
		for (i=0; i<3; i++) begin : eachDff
			DFFEn df (.q(dataOut[i]), .d(dataIn[i]), .enable(writeEnable), .clk);
		end
	endgenerate
endmodule