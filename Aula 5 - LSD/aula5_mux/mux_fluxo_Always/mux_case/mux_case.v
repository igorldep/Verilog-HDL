module funcao (output reg s, input i0, i1, sel);

always @(*)
	begin
		case(sel)
			1'b0 : s = i0;
			1'b1 : s = i1;
		endcase
	end
	
endmodule
//O modulo função poderia estar em outro arquivo verilog hdl

module mux_case(output [17:0] LEDR, input [17:0] SW);

funcao (LEDR[0], SW[17], SW[16], SW[0]);

endmodule
