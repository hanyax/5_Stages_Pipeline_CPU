`timescale 1ns/10ps

module pipeline_CPU(reset, clk);
	input logic reset, clk;
	
	// flag
	logic negative, overflow, zero, carry_out;
	
	// if input
	logic [31:0] instru;
	logic [63:0] branch_target_B, branch_target_CBZ;
	logic Brtaken;
	
	// rf output
	logic [63:0] D1, D2, MEMout;
	logic [63:0] branch_target_out;
	logic [5:0] Shamt;
   logic [4:0] rf_Rd_out; 
	logic [2:0] ALUControl;
	logic ShiftControl, rf_MemWrite, rf_MemRead, rf_MemToReg, rf_RegWrite_out, FlagEn; 
			
	// ex stage input 
	logic [63:0] MemIn;
	logic [4:0] WriteReg_In; // Pass down write reg 
	logic MemWirte_in, MemRead_in, MemToReg_in, RegWrite_in;// pass in
	
	// ex output
	logic [63:0] ex_ExecOut, ex_MemOut, ExecOut_forwarding;
	logic [4:0] ex_WriteReg_Out, WriteReg_Forwaring;	
	logic ex_MemWirte_out, ex_MemRead_out, ex_MemToReg_out, ex_RegWrite_out;// pass out
	
	// mem output
	logic [63:0] mem_out, mem_out_forwarding;
	logic [4:0] mem_WriteReg_Out, mem_WriteReg_forwarding;
	logic mem_RegWrite_out;
	
	// ALU_forwarding
	logic ALU_negative, ALU_overflow;
	
	logic Reg2Loc;

	if_reg if_stage (.instru, .branch_target_B, .branch_target_CBZ, .branch_in(branch_target_out), .BrTaken(Brtaken), .clk, .reset);
	
	logic branchZero;
	rf_reg rf_stage (.D1, .D2, .MEMout, .branch_target_out, .Shamt, .Rd_out(rf_Rd_out), .ShiftControl, .MemWrite(rf_MemWrite), 
									.MemRead(rf_MemRead), .MemToReg(rf_MemToReg), .Brtaken, .RegWrite_out(rf_RegWrite_out), .FlagEn, 
									.branchZero_out(branchZero), .Reg2Loc, .branchZero_in(branchZero), // CBZ
									.ALUControl, .RegDataIn(mem_out), .ExeValueIn(ExecOut_forwarding), 
									.MemValueIn(mem_out_forwarding), .branch_target_B, .branch_target_CBZ, .instru, .Rd_in(mem_WriteReg_Out), .ExeRegIn(WriteReg_Forwaring), 
									.MemRegIn(mem_WriteReg_forwarding), .RegWrite_in(mem_RegWrite_out), .negative, .overflow, .ALU_negative, .ALU_overflow, .zero, .clk);

	ex_reg ex_stage (.ExecOut(ex_ExecOut), .MemOut(ex_MemOut), .ExecOut_forwarding, .WriteReg_Out(ex_WriteReg_Out), .WriteReg_Forwaring, 
					.negative, .zero, .overflow, .carry_out, .ALU_negative, .ALU_overflow, .MemWirte_out(ex_MemWirte_out), .MemRead_out(ex_MemRead_out), .MemToReg_out(ex_MemToReg_out), 
					.RegWrite_out(ex_RegWrite_out), .D1, .D2, .MemIn(MEMout), .Shamt, .WriteReg_In(rf_Rd_out), .ALUControl, 
					.MemWirte_in(rf_MemWrite), .MemRead_in(rf_MemRead), .MemToReg_in(rf_MemToReg), .RegWrite_in(rf_RegWrite_out), .Reg2Loc, .ShiftControl, .FlagEn, .clk);
			
	mem_reg mem_stage (.MemWirte_in(ex_MemWirte_out), .MemRead_in(ex_MemRead_out), .MemToReg_in(ex_MemToReg_out), 
							.RegWrite_in(ex_RegWrite_out), .ExecIn(ex_ExecOut), .MemIn(ex_MemOut), .WriteReg_In(ex_WriteReg_Out), 
							.clk, .out(mem_out), .out_forwarding(mem_out_forwarding), .WriteReg_Out(mem_WriteReg_Out), 
							.WriteReg_forwarding(mem_WriteReg_forwarding), .RegWrite_out(mem_RegWrite_out));

endmodule

module pipeline_CPU_testbench;

	parameter ClockDelay = 10000;

	logic clk, reset;

	pipeline_CPU dut (.reset, .clk);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	integer i;
	initial begin
		reset = 1;@(posedge clk); @(posedge clk); //@(posedge clk);
		reset = 0;
		repeat(2000) begin
		@(posedge clk); 
		end
		$stop;
	end
	
endmodule