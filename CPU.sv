`timescale 1ns/10ps

module CPU(reset, clk);
	input logic reset, clk;
	logic [63:0] PC;
	logic [31:0] instruction; 
	logic negative, zero, overflow, carry_out;
	logic Reg2Loc, ShiftControl, LDUR_STUR, ALUsrc, MemWrite, 
			MemRead, MemToReg, UncondiBr, Brtaken, RegWrite, FlagEn;
	logic [2:0] ALUControl;
		
	instructmem ins_mem( .address(PC), .instruction(instruction), .clk);
	
	logic ALU_negative, ALU_zero, ALU_overflow, ALU_carry_out;
	CPU_control control (.Reg2Loc, .ShiftControl, .LDUR_STUR, .ALUsrc, .MemWrite, 
							.MemRead, .MemToReg, .UncondiBr, .Brtaken, .RegWrite, .FlagEn,
							.ALUControl, .opcode(instruction[31:21]), .negative, .overflow, .zero, .ALU_zero);
	
	CPU_datapath datapath(.PCout(PC), .negative(ALU_negative), .zero(ALU_zero), .overflow(ALU_overflow), .carry_out(ALU_carry_out),
								 .Rn(instruction[9:5]), .Rm(instruction[20:16]), .Rd(instruction[4:0]), .Shamt(instruction[15:10]), .RegWrite, 
								 .ShiftControl, .Reg2Loc, .Imm12(instruction[21:10]), .Imm9(instruction[20:12]), .LDUR_STUR, .ALUsrc, .ALUControl, .xfer_size(4'b1000), 
							    .MemRead, .MemWrite, .MemToReg, .Imm26(instruction[25:0]), .Imm19(instruction[23:5]), .UncondiBr, .Brtaken, .reset, .clk);
								 
	DFFEn dff1 (.q(negative), .d(ALU_negative), .enable(FlagEn), .clk);
	DFFEn dff2 (.q(zero), .d(ALU_zero), .enable(FlagEn), .clk);
	DFFEn dff3 (.q(overflow), .d(ALU_overflow), .enable(FlagEn), .clk);
	DFFEn dff4 (.q(carry_out), .d(ALU_carry_out), .enable(FlagEn), .clk);
endmodule

module CPU_testbench;

	parameter ClockDelay = 10000;

	logic clk, reset;

	CPU dut (.reset, .clk);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	integer i;
	initial begin
		// Read every location, including just past the end of the memory.
		reset = 1;@(posedge clk); 
		reset = 0;@(posedge clk); 
		repeat(2000) begin
		@(posedge clk); 
		end
		$stop;
	end
	
endmodule