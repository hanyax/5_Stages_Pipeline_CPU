module regfile (ReadData1, ReadData2, WriteData, 
					 ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk);
	output logic [63:0]	ReadData1, ReadData2;
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	
	logic [31:0] decoderOut;
	logic [63:0] regOut [31:0];
	
	FiveTo32Decoder decoder (.out(decoderOut), .in(WriteRegister), .enable(RegWrite));
	
	assign regOut[31] = 64'b0;
	
	genvar i;
	generate
		for(i=0;i<31;i++) begin : eachReg
			SixtyFour_Bit_Register regs (.dataOut(regOut[i]), .dataIn(WriteData), .writeEnable(decoderOut[i]), .clk);
		end
	endgenerate 
	
	SixtyFourBitThirtyTwoToOneMux read1 (.out(ReadData1), .in(regOut), .s(ReadRegister1));
	SixtyFourBitThirtyTwoToOneMux read2 (.out(ReadData2), .in(regOut), .s(ReadRegister2));
endmodule
