module SixtyFour_Bit_Register(dataOut, dataIn, writeEnable, clk);
	output logic [63:0] dataOut;
	input logic [63:0] dataIn;
	input logic writeEnable, clk;
	
	genvar i;
	generate
		for (i=0; i<64; i++) begin : eachDff
			DFFEn df (.q(dataOut[i]), .d(dataIn[i]), .enable(writeEnable), .clk);
		end
	endgenerate
endmodule

module SixtyFour_Bit_Register_testbench;

	logic [63:0] dataOut, dataIn;
	logic writeEnable, clk;
	parameter PERIOD = 500;
	
	initial begin
	clk <= 0;
	forever #(PERIOD/2) clk = ~clk;
	end
	
	initial begin
		writeEnable <= 1;
		dataIn = 64'b0000000000000000000000000000000000000000000000000000000000000001; @(posedge clk);
		@(posedge clk);
		dataIn = 64'b0000000000000000000000000000000000000000000000000000000000000010; @(posedge clk); 
		@(posedge clk);
		writeEnable <= 0;
		dataIn = 64'b0000000000000000000000000000000000000000000000000000000000000001; @(posedge clk);
		@(posedge clk);
		dataIn = 64'b0000000000000000000000000000000000000000000000000000000000000010; @(posedge clk); 
		@(posedge clk);
		writeEnable <= 1;
		dataIn = 64'b0000000000000000000000000000000000000000000000000000000000000001; @(posedge clk);
		@(posedge clk);
		dataIn = 64'b0000000000000000000000000000000000000000000000000000000000000010; @(posedge clk); 
		@(posedge clk);

		$stop();
	end
	
	SixtyFour_Bit_Register dut (.dataOut, .dataIn, .writeEnable, .clk);

endmodule
