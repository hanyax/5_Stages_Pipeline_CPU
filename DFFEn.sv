`timescale 1ns/10ps

module DFFEn (q, d, enable, clk);
	output logic q;
	input logic d, enable, clk;
	
	logic in;
	logic notEn, andOut, andIn;
	
	not #50 noten (notEn, enable);
	and #50 andout (andOut, q, notEn);
	and #50 andin (andIn, enable, d);
	or #50 actualIn (in, andOut, andIn);
	
	D_FF d_ff (.q, .d(in), .reset(1'b0), .clk);
	
endmodule

module DFFEn_testbench;
	logic q, d, enable, clk;
	
	parameter period = 500;
 
 DFFEn dut (.q, .d, .enable, .clk);
 
 initial begin
 clk <= 1;
 forever #(period/2) clk<=~clk;
 end
 
 initial begin
	enable <= 1; d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
					 d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
	enable <= 0; d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
					 d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
	enable <= 1; d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
					 d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
	enable <= 0; d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
					 d <= 0; @(posedge clk);
								@(posedge clk);
					 d <= 1;  @(posedge clk);
								@(posedge clk);
	$stop();
 end

endmodule 