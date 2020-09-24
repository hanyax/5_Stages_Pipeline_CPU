`timescale 1ns/10ps

module ex_reg	(ExecOut, MemOut, ExecOut_forwarding, WriteReg_Out, WriteReg_Forwaring, negative, zero, overflow, carry_out, 
					ALU_negative, ALU_overflow, MemWirte_out, MemRead_out, MemToReg_out, RegWrite_out, D1, D2, MemIn, Shamt, 
					WriteReg_In, ALUControl, MemWirte_in, MemRead_in, MemToReg_in, RegWrite_in, Reg2Loc, ShiftControl, FlagEn, clk);
	input logic [63:0] D1, D2, MemIn;
	input logic [5:0] Shamt;
	input logic [4:0] WriteReg_In; // Pass down write reg 
	input logic [2:0] ALUControl; // used in 
	input logic ShiftControl, FlagEn, clk;
	input logic MemWirte_in, MemRead_in, MemToReg_in, RegWrite_in, Reg2Loc;// pass in
	
	output logic [63:0] ExecOut, MemOut, ExecOut_forwarding;
	output logic [4:0] WriteReg_Out, WriteReg_Forwaring;	
	output logic negative, zero, overflow, carry_out, ALU_negative, ALU_overflow; // flag
	output logic MemWirte_out, MemRead_out, MemToReg_out, RegWrite_out;// pass out
	
	logic [63:0] ALUout, ShiftOut, ExecOut_temp;
	
	logic ALU_zero, ALU_carry_out, ALU_overflow_temp, ALU_negative_temp;
	
	TwoToOneMux5bit mux4 (.out(WriteReg_Forwaring), .a(5'b00000), .b(WriteReg_In), .control(Reg2Loc));
	//assign WriteReg_Forwaring = WriteReg_In; 
	assign ExecOut_forwarding = ExecOut_temp;
	
	// ALU output 
	ALU alu (.A(D1), .B(D2), .cntrl(ALUControl), .result(ALUout), .negative(ALU_negative_temp), 
				.zero(ALU_zero), .overflow(ALU_overflow_temp), .carry_out(ALU_carry_out));
				
	TwoToOneMux mux2 (.out(ALU_overflow), .s(FlagEn), .d({ALU_overflow_temp, overflow})); 
	TwoToOneMux mux3 (.out(ALU_negative), .s(FlagEn), .d({ALU_negative_temp, negative})); 
	
	// shift output 
	shifter shift (.value(D1), .direction(1'b1), .distance(Shamt),.result(ShiftOut));
	
	// exec output - could be shift/ALU depends on ShiftControl
	TwoToOneMux64bit mux1 (.out(ExecOut_temp), .a(ALUout), .b(ShiftOut), .control(ShiftControl));
	
	DFFEn reg1 (.q(negative), .d(ALU_negative), .enable(FlagEn), .clk);
	DFFEn reg2 (.q(zero), .d(ALU_zero), .enable(FlagEn), .clk);
	DFFEn reg3 (.q(overflow), .d(ALU_overflow), .enable(FlagEn), .clk);
	DFFEn reg4 (.q(carry_out), .d(ALU_carry_out), .enable(FlagEn), .clk);
	DFFEn reg5(.q(MemWirte_out), .d(MemWirte_in), .enable(1), .clk);
	DFFEn reg6 (.q(MemRead_out), .d(MemRead_in), .enable(1), .clk);
	DFFEn reg7 (.q(MemToReg_out), .d(MemToReg_in), .enable(1), .clk);
	DFFEn reg8 (.q(RegWrite_out), .d(RegWrite_in), .enable(1), .clk);
	FiveBit_Reg reg9 (.dataOut(WriteReg_Out), .dataIn(WriteReg_In), .writeEnable(1), .clk); // Pass on WriterReg
	SixtyFour_Bit_Register reg10 (.dataOut(ExecOut), .dataIn(ExecOut_temp), .writeEnable(1), .clk);
	SixtyFour_Bit_Register reg11 (.dataOut(MemOut), .dataIn(MemIn), .writeEnable(1), .clk); // Pass on Memout

endmodule