`timescale 1ns/10ps

module rf_reg(D1, D2, MEMout, branch_target_out, Shamt, Rd_out, ShiftControl, MemWrite, MemRead, MemToReg, 
				 Brtaken, RegWrite_out, FlagEn, branchZero_out, Reg2Loc, ALUControl, RegDataIn, branch_target_B, 
				 branch_target_CBZ, ExeValueIn, MemValueIn, instru, Rd_in, ExeRegIn, MemRegIn, RegWrite_in, negative, overflow, 
				 ALU_negative, ALU_overflow, zero, clk, branchZero_in);
	output logic [63:0] D1, D2, MEMout, branch_target_out;
	output logic [5:0] Shamt;
	output logic [4:0] Rd_out;
	output logic [2:0] ALUControl;
	output logic ShiftControl, MemWrite, MemRead, MemToReg, 
					 Brtaken, RegWrite_out, FlagEn, branchZero_out, Reg2Loc; // control signal passed on 
	
	input logic [63:0] RegDataIn, branch_target_B, branch_target_CBZ;
 	input logic [31:0] instru;
	input logic [4:0] Rd_in;
	input logic RegWrite_in, clk, negative, overflow, ALU_negative, ALU_overflow, zero, branchZero_in;
	
	// forwarding control logic
	input logic [4:0] ExeRegIn, MemRegIn;
	input logic [63:0] ExeValueIn, MemValueIn;
	
	// assign value to Rd and Shamt to pass them on
	logic [4:0] Rd_temp; 
	assign Rd_temp = instru[4:0];
	logic [5:0] Shamt_temp;
	assign Shamt_temp = instru[15:10];
	
	logic Reg2Loc_temp, LDUR_STUR, ALUsrc, UncondiBr, Rm_True, Rn_True; // control signal used in this stage 
	logic ShiftControl_temp, MemWrite_temp, MemRead_temp, MemToReg_temp, BrTaken_temp,
			RegWrite_out_temp, FlagEn_temp; // control signal passed on
	logic [2:0] ALUControl_temp;
			
	// generate control		
	CPU_control control (.Reg2Loc(Reg2Loc_temp), .ShiftControl(ShiftControl_temp), .LDUR_STUR, .ALUsrc, .MemWrite(MemWrite_temp), 
							  .MemRead(MemRead_temp), .MemToReg(MemToReg_temp), .UncondiBr, .Brtaken(BrTaken_temp), 
							  .RegWrite(RegWrite_out_temp), .FlagEn(FlagEn_temp), .Rm_True, .Rn_True, .ALUControl(ALUControl_temp),
							  .opcode(instru[31:21]), .negative(ALU_negative), .overflow(ALU_overflow), .zero, .ALU_zero(branchZero_in));
	
	logic [63:0] branch_target_out_temp;
	// Decide Branch address +imm26 or +imm19
	TwoToOneMux64bit mux1 (.out(branch_target_out_temp), .a(branch_target_B), .b(branch_target_CBZ), .control(UncondiBr));
							  
	logic [63:0] D1_temp, D2_temp, D1_temp_forwarding, D2_temp_forwarding ;
	
	logic [4:0] RdToRm;
	TwoToOneMux5bit mux2 (.out(RdToRm), .a(instru[4:0]), .b(instru[20:16]), .control(Reg2Loc_temp));
	RegCircuit regFile (.D1(D1_temp), .D2(D2_temp), .RegDataIn, .Rn(instru[9:5]), .Rm(RdToRm), .Rd_write(Rd_in), .Rd_read(instru[4:0]),
							  .RegWrite(RegWrite_in), .Reg2Loc(Reg2Loc_temp), .clk);
	
	// if D1 or D2 reg =  forwarded reg, then D1 temp/D2 temp value = forwarded value
	forwarding_control fc (.D1(D1_temp_forwarding), .D2(D2_temp_forwarding), .Rn(instru[9:5]), .Rm(RdToRm), .ExeRegIn, .MemRegIn,
								.D1_reg(D1_temp), .D2_reg(D2_temp), .ExeValueIn, .MemValueIn, .Rm_True, .Rn_True);
	
	// check if D2 == 0 for CBZ
	ALU alu (.A(64'bX), .B(D2_temp_forwarding), .cntrl(3'b000), .zero(branchZero_in));
	
	logic [63:0] ALUout_temp, MEMout_temp;
	ExtendedConstant ec (.ALUout(ALUout_temp), .MEMout(MEMout_temp), .D2(D2_temp_forwarding), .Imm12(instru[21:10]), .Imm9(instru[20:12]), .LDUR_STUR, .ALUsrc);
	
	genvar i;
	generate
		for (i=0; i<64; i++) begin : eachDff1
			DFFEn df (.q(D1[i]), .d(D1_temp_forwarding[i]), .enable(1), .clk);
		end
	endgenerate

	genvar j;
	generate
		for (j=0; j<64; j++) begin : eachDff2
			DFFEn df (.q(D2[j]), .d(ALUout_temp[j]), .enable(1), .clk);
		end
	endgenerate	
	
	genvar k;
	generate
		for (k=0; k<64; k++) begin : eachDff3
			DFFEn df (.q(MEMout[k]), .d(MEMout_temp[k]), .enable(1), .clk);
		end
	endgenerate	
	
	DFFEn reg1 (.q(ShiftControl), .d(ShiftControl_temp), .enable(1), .clk);
	DFFEn reg2 (.q(MemWrite), .d(MemWrite_temp), .enable(1), .clk);
	DFFEn reg3 (.q(MemRead), .d(MemRead_temp), .enable(1), .clk);
	DFFEn reg4 (.q(MemToReg), .d(MemToReg_temp), .enable(1), .clk);
	DFFEn reg5 (.q(Brtaken), .d(BrTaken_temp), .enable(1), .clk);
	DFFEn reg6 (.q(RegWrite_out), .d(RegWrite_out_temp), .enable(1), .clk);
	DFFEn reg7 (.q(FlagEn), .d(FlagEn_temp), .enable(1), .clk);
	FiveBit_Reg reg8 (.dataOut(Rd_out), .dataIn(Rd_temp), .writeEnable(1), .clk);
	SixBit_Reg reg9 (.dataOut(Shamt), .dataIn(Shamt_temp), .writeEnable(1), .clk);
	ThreeBit_Reg reg10 (.dataOut(ALUControl), .dataIn(ALUControl_temp), .writeEnable(1), .clk);
	ThirtyTwo_Bit_Register reg11 (.dataOut(branch_target_out), .dataIn(branch_target_out_temp), .writeEnable(1), .clk);
	DFFEn reg12 (.q(branchZero_out), .d(branchZero_in), .enable(1), .clk);
	DFFEn reg13 (.q(Reg2Loc), .d(Reg2Loc_temp), .enable(1), .clk);

endmodule