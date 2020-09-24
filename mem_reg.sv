`timescale 1ns/10ps

module mem_reg(MemWirte_in, MemRead_in, MemToReg_in, RegWrite_in, ExecIn, MemIn, WriteReg_In, 
					clk, out, out_forwarding, WriteReg_Out, WriteReg_forwarding, RegWrite_out);
					
	input logic MemWirte_in, MemRead_in, MemToReg_in, RegWrite_in;
	input logic [63:0] ExecIn, MemIn;
	input logic [4:0] WriteReg_In;
	input logic clk;
	
	output logic [63:0] out, out_forwarding;
	output logic [4:0] WriteReg_Out, WriteReg_forwarding;
	output logic RegWrite_out;
	
	logic [63:0] MemOut, out_temp;
	
	assign WriteReg_forwarding = WriteReg_In;
	assign out_forwarding = out_temp;
	
	// Write to mem and get value out 
	datamem dm (.address(ExecIn), .write_enable(MemWirte_in), .read_enable(MemRead_in), .write_data(MemIn),
					.clk(clk), .xfer_size(4'b1000), .read_data(MemOut));
					
	// MemToReg				
	TwoToOneMux64bit mux1(.out(out_temp), .a(ExecIn), .b(MemOut), .control(MemToReg_in));
	
	// Pass on RegWrite_out and RegDataIn
	DFFEn reg1 (.q(RegWrite_out), .d(RegWrite_in), .enable(1), .clk);
	FiveBit_Reg reg8 (.dataOut(WriteReg_Out), .dataIn(WriteReg_In), .writeEnable(1), .clk); // Pass on WriterReg
	SixtyFour_Bit_Register reg2 (.dataOut(out), .dataIn(out_temp), .writeEnable(1), .clk);
	
endmodule