`timescale 1ns/10ps

module Branches(PCBranchout, PCin, Imm26, Imm19, UncondiBr);
	output logic [63:0] PCBranchout;
	input logic [63:0] PCin;
	input logic [25:0] Imm26;
	input logic [18:0] Imm19;
	input logic UncondiBr;

	logic [63:0] Imm26Extended, Imm19Extended;
	assign Imm26Extended = {{39{Imm26[25]}} ,Imm26[24:0]};
	assign Imm19Extended = {{46{Imm19[18]}} ,Imm19[17:0]};
	
	logic [63:0] Imm26Shifted, Imm19Shifted;
	shifter s26 (.value(Imm26Extended), .direction(1'b0), .distance(2), .result(Imm26Shifted));
	shifter s19 (.value(Imm19Extended), .direction(1'b0), .distance(2), .result(Imm19Shifted));
	
	logic [63:0] muxOut;
	
	TwoToOneMux64bit mux1(.out(muxOut), .a(Imm26Shifted), .b(Imm19Shifted), .control(UncondiBr));
	
	ALU alu (.A(muxOut), .B(PCin), .cntrl(3'b010), .result(PCBranchout));
	
endmodule

module Branches_testbench;
	logic [63:0] PCBranchout, PCin;
	logic [25:0] Imm26;
	logic [18:0] Imm19;
	logic UncondiBr;
	
	initial begin
	Imm26 = 26'b00000000000000000000000001;
	Imm19 = 19'b0000000000000000010;
	PCin = 64'b0;
	UncondiBr = 0; #1200;
	PCin = PCBranchout;
	UncondiBr = 1; #1200;
	PCin = PCBranchout;
	UncondiBr = 0; #1200;
	PCin = PCBranchout;
	UncondiBr = 1; #1200;
	PCin = PCBranchout;
	end

	Branches dut (.PCBranchout, .PCin, .Imm26, .Imm19, .UncondiBr);
	
endmodule