`timescale 1ns/10ps

module forwarding_control(D1, D2, Rn, Rm, ExeRegIn, MemRegIn, D1_reg, D2_reg, ExeValueIn, MemValueIn, Rm_True, Rn_True);
	output logic [63:0] D1, D2;
	
	input logic [63:0] D1_reg, D2_reg, ExeValueIn, MemValueIn;
	input logic [4:0] Rn, Rm, ExeRegIn, MemRegIn;
	input logic Rm_True, Rn_True;
	
	always_comb begin
	
		if (Rn_True == 1) begin
			if (Rn == ExeRegIn) begin
				if (Rn == 5'b11111) begin
					D1 = 64'b0;
				end else begin
					D1 = ExeValueIn;
				end
			end else if (Rn == MemRegIn) begin
				if (Rn == 5'b11111) begin
					D1 = 64'b0;
				end else begin
					D1 = MemValueIn;
				end
			end else begin
				D1 = D1_reg;
			end
		end else begin
			D1 = D1_reg;
		end

		if (Rm_True == 1) begin
			if (Rm == ExeRegIn) begin
				if (Rm == 5'b11111) begin
					D2 = 64'b0;
				end else begin
					D2 = ExeValueIn;
				end
			end else if (Rm == MemRegIn) begin
				if (Rm == 5'b11111) begin
					D2 = 64'b0;
				end else begin
					D2 = MemValueIn;
				end
			end else begin
				D2 = D2_reg;
			end
		end else begin
			D2 = D2_reg;
		end
	end
	
endmodule