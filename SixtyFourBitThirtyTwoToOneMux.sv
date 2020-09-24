module SixtyFourBitThirtyTwoToOneMux(out, in, s);
	output logic [63:0] out;
	input logic [63:0] in [31:0];
	input logic [4:0] s;
	
	logic [31:0] actualIn [63:0];
	integer i, j;
	
	always_comb begin
		for (i=0;i<64;i++) begin
			for (j=0;j<32;j++) begin
				actualIn[i][j] = in[j][i];
			end
		end
	end
	
	genvar k;
	generate
		for (k=0; k<64; k++) begin : eachMux
			ThirtyTwoToOneMux mux (.out(out[k]), .s, .d(actualIn[k]));
		end
	endgenerate
	
endmodule

module SixtyFourBitThirtyTwoToOneMux_testbench;
	
	logic [63:0] out;
	logic [63:0] in0, in1;
	logic [63:0] in [31:0];
	logic [4:0] s;
	
	/*
	integer i;
	initial begin
	s=5'b00000;
	inN = 64'b0;
	for(i = 0; i < 32; i++) begin
		inN[i] = 1;		
		in[i] = inN; #1000;
		inN[i] = 0;
		s++;
	end
	end
	*/
	integer i, j;
	initial begin
	in0 = 64'b0;
	in1 = 64'b1111111111111111111111111111111111111111111111111111111111111111;
	for (i=0;i<32;i++) begin
		if ((i%2)==0) begin
			in[i] = in0;
		end else begin
			in[i] = in1;
		end
	end
	
	s=5'b00000;
	for (j=0;j<32;j++) begin
	s++;	#500;
	end
	end
	
	SixtyFourBitThirtyTwoToOneMux dut (.out, .in, .s);

endmodule
