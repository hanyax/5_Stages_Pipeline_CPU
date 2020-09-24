module eightToOneMux(S, in, out);
	input logic [2:0] S;
	input logic [7:0] in;
	output logic out;
	
	
	FourToOneMux mux1(out1, S[1:0], in[3:0]);
	FourToOneMux mux2(out2, S[1:0], in[7:4]);
	
	logic [1:0] twoTo1MuxIn;
	assign twoTo1MuxIn[0] = out1;
	assign twoTo1MuxIn[1] = out2;
	
	TwoToOneMux mux3(out, S[2], twoTo1MuxIn);

endmodule

module eightToOneMux_testbench;
	logic out;
	logic [7:0] in;
	
	logic [2:0] S;
	
	integer i;
	initial begin
	S=3'b000;
	in=8'b00000000;
	for (i = 0; i < 8; i++) begin
		in[i] = 1; #800;
		in[i] = 0;
		S++;
	end
	end

	eightToOneMux dut (.S, .in, .out);


endmodule
