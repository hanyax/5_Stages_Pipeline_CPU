`timescale 1ns/10ps

module CPU_datapath(PCout, negative, zero, overflow, carry_out, 
						  Rn, Rm, Rd, Shamt, RegWrite, 
						  ShiftControl, Reg2Loc, Imm12, Imm9, LDUR_STUR, ALUsrc, ALUControl, xfer_size, 
						  MemRead, MemWrite, MemToReg, Imm26, Imm19, UncondiBr, Brtaken, reset, clk);
	output logic [63:0] PCout;
	output logic negative, zero, overflow, carry_out;

	// RegCircuit
	input logic	[4:0] 	Rn, Rm, Rd;
	input	logic	[5:0]		Shamt;
	input logic 			RegWrite, ShiftControl, Reg2Loc;
	
	// Constant
	input logic [11:0] Imm12;
	input logic [8:0] Imm9;
	input logic LDUR_STUR, ALUsrc;
	
	// ALU
	input logic [2:0] ALUControl;
	
	// Mem Circuit
	input logic	[3:0]		xfer_size;
	input logic MemRead, MemWrite, MemToReg;
	
	// PC Circuit 
	input logic [25:0] Imm26;
	input logic [18:0] Imm19;
	input logic Brtaken, UncondiBr, reset, clk;
	
	logic [63:0] D1,D2, ALUout, RegDataIn;
	logic [63:0] OutToALU, OutToMem;
	
	logic [63:0] PCCircuitOut;
	
	PC pc (.out(PCout), .in(PCCircuitOut), .reset, .clk);
	
	RegCircuit regC (.D1(D1), .D2(D2), .RegDataIn(RegDataIn), 
						.Rn(Rn), .Rm(Rm), .Rd(Rd), .Shamt(Shamt),
						.RegWrite(RegWrite), .shiftControl(ShiftControl), .Reg2Loc(Reg2Loc), .clk);
						
	ExtendedConstant ex (.ALUout(OutToALU), .MEMout(OutToMem), .D2(D2), .Imm12(Imm12), .Imm9(Imm9), .LDUR_STUR(LDUR_STUR), .ALUsrc(ALUsrc));
	
	ALU alu (.A(D1), .B(OutToALU), .cntrl(ALUControl), .result(ALUout), .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out));
	
	MemCircuit Dmem (.out(RegDataIn), .ALUin(ALUout), .DataIn(OutToMem), .xfer_size(4'b1000), .WriteEn(MemWrite), .ReadEn(MemRead), .MemToReg(MemToReg), .clk(clk));
	
	/*
	logic CBZ_Uncondi_OUT, CBZ_BrTaken_OUT;
	TwoToOneMux64bit m1(.out(CBZ_Uncondi_OUT), .a(UncondiBr), .b(D2==64'b0), .control(CBZtaken));
	TwoToOneMux64bit m2(.out(CBZ_BrTaken_OUT), .a(Brtaken), .b(D2==64'b0), .control(CBZtaken));
	*/
	
	PCcircuit PCcir (.PCout(PCCircuitOut), .PCin(PCout), .Imm26(Imm26), .Imm19(Imm19), .UncondiBr, .Brtaken);
	
endmodule