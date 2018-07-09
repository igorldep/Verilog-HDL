module decod (TS, S, saida);

input TS, S;
output reg [0:6] saida;

always @(*)
	begin
		case ({TS, S}) //Concatenar}			
		   2'b00: saida = 7'b0000001;
			2'b01: saida = 7'b1001111;
			2'b10: saida = 7'b0010010;
			2'b11: saida = 7'b0000110;
		endcase
end
endmodule	
