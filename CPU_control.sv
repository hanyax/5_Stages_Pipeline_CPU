`timescale 1ns/10ps

module CPU_control(Reg2Loc, ShiftControl, LDUR_STUR, ALUsrc, MemWrite, 
						  MemRead, MemToReg, UncondiBr, Brtaken, RegWrite, FlagEn,
						  Rm_True, Rn_True, ALUControl, opcode, negative, overflow, zero, ALU_zero);
						  
	output logic 	Reg2Loc, ShiftControl, LDUR_STUR, ALUsrc, MemWrite, 
						MemRead, MemToReg, UncondiBr, Brtaken, RegWrite, FlagEn, Rm_True, Rn_True;
	output logic [2:0] ALUControl;
	input logic [10:0] opcode; 
	input logic negative, overflow, zero, ALU_zero;
	
	always_comb begin
		
		if (opcode[10:1] == 10'b1001000100) begin 
								Reg2Loc = 1'b1; ShiftControl = 0; LDUR_STUR = 0; ALUsrc = 1; ALUControl = 3'b010; MemWrite = 0; 
								MemRead = 0; MemToReg = 0; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 1; FlagEn = 0; Rm_True = 0; Rn_True = 1; 
								end
		else if (opcode == 11'b10101011000) begin 
								Reg2Loc = 1; ShiftControl = 0; LDUR_STUR = 1'bX; ALUsrc = 0; ALUControl = 3'b010; MemWrite = 0; 
								MemRead = 0; MemToReg = 0; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 1; FlagEn = 1; Rm_True = 1; Rn_True = 1; 
								end
		else if (opcode == 11'b10001010000) begin 
								Reg2Loc = 1; ShiftControl = 0; LDUR_STUR = 1'bX; ALUsrc = 0; ALUControl = 3'b100; MemWrite = 0; 
								MemRead = 0; MemToReg = 0; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 1; FlagEn = 0; Rm_True = 1; Rn_True = 1; 
								end
		else if (opcode[10:5] == 6'b000101) begin 
								Reg2Loc = 1'b1; ShiftControl = 1'b0; LDUR_STUR = 1'bX; ALUsrc = 1'bX; ALUControl = 1'bx; MemWrite = 0; 
								MemRead = 0; MemToReg = 1'bX; UncondiBr = 1'b0; Brtaken = 1; RegWrite = 0; FlagEn = 0; Rm_True = 0; Rn_True = 0; 
								end
		else if (opcode[10:3] == 8'b01010100) begin // B.LT
								Reg2Loc = 1'b1; ShiftControl = 1'b0; LDUR_STUR = 1'bX; ALUsrc = 1'bX; ALUControl = 1'bx; MemWrite = 0; 
								MemRead = 0; MemToReg = 1'bX; UncondiBr = (1'b1); Brtaken = (negative != overflow); RegWrite = 0; FlagEn = 0; 
								Rm_True = 0; Rn_True = 0; 
								end
		else if (opcode[10:3] == 8'b10110100) begin // CBZ
								Reg2Loc = 0; ShiftControl = 1'b0; LDUR_STUR = 1'bX; ALUsrc = 0; ALUControl = 3'b000; MemWrite = 0; 
								MemRead = 0; MemToReg = 1'b0; UncondiBr = (1'b1); Brtaken = (ALU_zero); RegWrite = 0; FlagEn = 0; Rm_True = 1; Rn_True = 0; 
								end
		else if (opcode == 11'b11001010000) begin 
								Reg2Loc = 1; ShiftControl = 0; LDUR_STUR = 1'bX; ALUsrc = 0; ALUControl = 3'b110; MemWrite = 0; 
								MemRead = 0; MemToReg = 0; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 1; FlagEn = 0; Rm_True = 1; Rn_True = 1; 
								end
		else if (opcode == 11'b11111000010) begin 
								Reg2Loc = 1'b1; ShiftControl = 0; LDUR_STUR = 1; ALUsrc = 1; ALUControl = 3'b010; MemWrite = 0; 
								MemRead = 1; MemToReg = 1; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 1; FlagEn = 0; Rm_True = 0; Rn_True = 1; 
								end
		else if (opcode == 11'b11010011010) begin // LSR
								Reg2Loc = 1'b1; ShiftControl = 1; LDUR_STUR = 1'bX; ALUsrc = 1'bX; ALUControl = 1'bx; MemWrite = 1'b0; 
								MemRead = 0; MemToReg = 1'b0; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 1; FlagEn = 0; Rm_True = 0; Rn_True = 1; 
								end
		else if (opcode == 11'b11111000000) begin 
								Reg2Loc = 0; ShiftControl = 1'b0; LDUR_STUR = 1; ALUsrc = 1; ALUControl = 3'b010; MemWrite = 1; 
								MemRead = 0; MemToReg = 1'bX; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 0; FlagEn = 0; Rm_True = 1; Rn_True = 1; 
								end
		else if (opcode == 11'b11101011000)	begin 
								Reg2Loc = 1; ShiftControl = 0; LDUR_STUR = 1'bX; ALUsrc = 0; ALUControl = 3'b011; MemWrite = 0; 
								MemRead = 0; MemToReg = 0; UncondiBr = 1'b0; Brtaken = 0; RegWrite = 1; FlagEn = 1; Rm_True = 1; Rn_True = 1; 
								end
	end
	
 
 endmodule