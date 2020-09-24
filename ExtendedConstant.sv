`timescale 1ns/10ps

module ExtendedConstant(ALUout, MEMout, D2, Imm12, Imm9, LDUR_STUR, ALUsrc);
	output logic [63:0] ALUout, MEMout;
	input logic [63:0] D2;
	input logic [11:0] Imm12;
	input logic [8:0] Imm9;
	input logic LDUR_STUR, ALUsrc;
	
	logic [63:0] Imm12Extended, Imm9Extended;
	
	assign Imm12Extended[11:0] = Imm12;
	assign Imm12Extended[63:12] = 52'd0;
	
	assign  Imm9Extended[7:0] = Imm9[7:0];
	assign Imm9Extended[63:8] = {56{Imm9[8]}};
	
	logic [63:0] LDURMuxOut;
	TwoToOneMux64bit m1 (.out(LDURMuxOut), .a(Imm12Extended), .b(Imm9Extended), .control(LDUR_STUR));
	TwoToOneMux64bit m2 (.out(ALUout), .a(D2), .b(LDURMuxOut), .control(ALUsrc));
	
	assign MEMout = D2;

endmodule

module ExtendedConstant_testbench;
	logic [63:0] ALUout, MEMout;
	logic [63:0] D2;
	logic [11:0] Imm12;
	logic [8:0] Imm9;
	logic LDUR_STUR, ALUsrc;
	
	initial begin
	D2 = 64'b0;
	Imm12 = 12'b000000000001;
	Imm9 = 9'b000000010;
	LDUR_STUR = 0;
	ALUsrc = 0; #400;
	LDUR_STUR = 1;
	ALUsrc = 1; #400;
	LDUR_STUR = 1;
	ALUsrc = 0; #400;
	LDUR_STUR = 0;
	ALUsrc = 1; #400;
	
	end
	
	ExtendedConstant dut(.ALUout, .MEMout, .D2, .Imm12, .Imm9, .LDUR_STUR, .ALUsrc);
	
endmodule
