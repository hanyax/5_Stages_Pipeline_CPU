`timescale 1ns/10ps

module ThirtyTwo_Bit_Register (dataOut, dataIn, writeEnable, clk);
	output logic [31:0] dataOut;
	input logic [31:0] dataIn;
	input logic writeEnable, clk;
	
	genvar i;
	generate
		for (i=0; i<32; i++) begin : eachDff
			DFFEn df (.q(dataOut[i]), .d(dataIn[i]), .enable(writeEnable), .clk);
		end
	endgenerate

endmodule