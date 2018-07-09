module shift_regis (saida, entrada, clock, reset);

input entrada, clock, reset;
output [3:0] saida;
reg [3:0] saida_reg;
assign saida = saida_reg;

always @ (negedge reset or posedge clock)
	begin
		if (~reset )
		saida_reg <= 4'b0; //4'b0000
	else
		saida_reg <= {entrada, saida_reg[3:1]};
	end
endmodule
