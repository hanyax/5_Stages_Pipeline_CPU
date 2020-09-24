`timescale 1ns/10ps

module RegCircuit(D1, D2, RegDataIn, Rn, Rm, Rd_write, Rd_read, RegWrite, Reg2Loc, clk);
						
 	output logic [63:0]	D1, D2;
	input logic	[4:0] 	Rn, Rm, Rd_write, Rd_read;
	input logic [63:0]	RegDataIn; // data written to reegister
	input logic 			RegWrite, Reg2Loc, clk;
	
	logic [4:0] Reg2LocOut;
	TwoToOneMux5bit mux1 (.out(Reg2LocOut), .a(Rd_read), .b(Rm), .control(Reg2Loc));
	
	logic invert;
	not not1 (invert, clk);
		
	regfile regFile (.ReadData1(D1), .ReadData2(D2), .WriteData(RegDataIn), 
							.ReadRegister1(Rn), .ReadRegister2(Reg2LocOut), .WriteRegister(Rd_write),
							.RegWrite(RegWrite), .clk(invert));

endmodule
