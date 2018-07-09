module somador(a, b, te, ts, saida);
input a, b, te;
output ts, saida;

assign saida = a ^ b ^ te;
assign ts = a & b | a & te | b & te;

endmodule

module decod_2bits(SW, HEX0);
input [15:17] SW;
output [0:6] HEX0;
wire ts, s;

somador ( SW[17], SW[16], SW[15], ts, s);
decod (ts, s, HEX0[0:6]);

endmodule