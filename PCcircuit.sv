`timescale 1ns/10ps

module PCcircuit(PCout, PCin, Imm26, Imm19, UncondiBr, Brtaken);
	output logic [63:0] PCout;
	input logic [63:0] PCin;
	input logic [25:0] Imm26;
	input logic [18:0] Imm19;
	input logic UncondiBr, Brtaken;

	logic [63:0] add4out, Brout;
	Branches Br (.PCBranchout(Brout), .PCin(PCin), .Imm26(Imm26), .Imm19(Imm19), .UncondiBr(UncondiBr));
	ALU alu (.A(PCin), .B(4), .cntrl(3'b010), .result(add4out));
	
	TwoToOneMux64bit mux1(.out(PCout), .a(add4out), .b(Brout), .control(Brtaken));
	
endmodule


module PCcircuit_testbench;
	logic [63:0] PCout, PCin;
	logic [25:0] Imm26;
	logic [18:0] Imm19;
	logic UncondiBr, Brtaken;
	
	initial begin
	Imm26 = 26'b00000000000000000000000001;
	Imm19 = 19'b0000000000000000010;
	PCin = 64'b0;
	
	Brtaken = 1;
	UncondiBr = 0; #1200;
	PCin = PCout;
	UncondiBr = 1; #1200;
	PCin = PCout;
	UncondiBr = 0; #1200;
	PCin = PCout;
	UncondiBr = 1; #1200;
	PCin = PCout;
	
	Brtaken = 0;
	UncondiBr = 0; #1200;
	PCin = PCout;
	UncondiBr = 1; #1200;
	PCin = PCout;
	UncondiBr = 0; #1200;
	PCin = PCout;
	UncondiBr = 1; #1200;
	PCin = PCout;
	end

	PCcircuit dut (.PCout, .PCin, .Imm26, .Imm19, .UncondiBr, .Brtaken);

endmodule
