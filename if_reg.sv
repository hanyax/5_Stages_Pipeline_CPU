`timescale 1ns/10ps

module if_reg(instru, branch_target_B, branch_target_CBZ, branch_in, BrTaken, clk, reset);
	output logic [31:0] instru;
	output logic [63:0] branch_target_B, branch_target_CBZ;
	input logic [63:0] branch_in;
	input logic BrTaken, clk, reset;
	
	logic [63:0] PCout, PCin, add4out;
	
	// Update PC
	PC pc (.out(PCout), .in(PCin), .reset, .clk);
	
	// PC = PC + 4
	ALU alu1 (.A(PCout), .B(4), .cntrl(3'b010), .result(add4out));
	
	// Branch or not
	TwoToOneMux64bit mux1(.out(PCin), .a(add4out), .b(branch_in), .control(BrTaken));
	
	// Branch Target
	logic [63:0] br_target;
	TwoToOneMux64bit mux2(.out(br_target), .a(PCout), .b(branch_in), .control(BrTaken));
	
	// Get instruct out
	instructmem instr (.address(PCout), .instruction(instru), .clk);

	// Caculate branch destination
	logic [63:0] Imm26Extended, Imm19Extended, Imm26Shifted, Imm19Shifted;
	
	assign Imm26Extended = {{39{instru[25]}} ,instru[24:0]};
	assign Imm19Extended = {{46{instru[23]}} ,instru[22:5]};
	
	shifter s26 (.value(Imm26Extended), .direction(1'b0), .distance(2), .result(Imm26Shifted));
	shifter s19 (.value(Imm19Extended), .direction(1'b0), .distance(2), .result(Imm19Shifted));
	
	// PC address for B and CBZ/B.LT
	ALU alu2 (.A(Imm26Shifted), .B(PCout), .cntrl(3'b010), .result(branch_target_B));
	ALU alu3 (.A(Imm19Shifted), .B(PCout), .cntrl(3'b010), .result(branch_target_CBZ));
	
endmodule