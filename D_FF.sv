module D_FF (q, d, reset, clk);
 output reg q;
 input d, reset, clk;
 always_ff @(posedge clk)
 if (reset)
 q <= 0; // On reset, set to 0
 else
 q <= d; // Otherwise out = d
endmodule 

module D_FF_testbench; 
 logic q, d, reset, clk;
 
 parameter period = 100;
 
 D_FF dut (.q, .d, .reset, .clk);
 
 initial begin
 clk <= 1;
 forever #(period/2) clk<=~clk;
 end
 
 initial begin
	reset <= 1; d <= 0; @(posedge clk);
					d <= 1; @(posedge clk);
	reset <= 0; d <= 0; @(posedge clk);
					d <= 1; @(posedge clk);
	$stop();
 end

endmodule 

