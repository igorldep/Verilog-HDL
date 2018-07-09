module somador(a, b, te, ts, saida);
input a, b, te;
output ts, saida;

assign saida = a ^ b ^ te;
assign ts = a & b | a & te | b & te;

endmodule

//____________________________________________________________________________________________________________________

module somador4bits(A, B, TE0, TS3, S);

input [3:0] A;
input [3:0] B;
input TE0;
output TS3;
output [3:0] S;
wire [3:0] TS;
//Sem TE

somador (A[0], B[0], TE0, TS[0], S[0]);
somador (A[1], B[1], TS[0], TS[1], S[1]);
somador (A[2], B[2], TS[1], TS[2], S[2]);
somador (A[3], B[3], TS[2], TS3, S[3]);

endmodule

//____________________________________________________________________________________________________________________

module decodificador (A, B, C, D, a, b, c, d, e, f, g );
input A, B, C, D;
output a, b, c, d, e, f, g;

assign a = (~A & B & ~A & ~D);
assign b = (~A & B & ~C & D | ~A & B & C & ~D);
assign c = (~B & C & ~D | ~A & ~B & ~C & D);
assign d = ( B & ~C & ~D | B & C & D | ~A & ~B & ~C & D);
assign e = (D | B & ~C);
assign f = (~B & C | C & D | ~A & ~B & D);
assign g = ( ~A & ~B & ~C | ~A & ~B & ~D | B & C & D);

endmodule

//____________________________________________________________________________________________________________________

module somadorcompleto (SW,HEX3);
input [17:0] SW;
output [0:6] HEX3;
wire TS;
wire [3:0] S;

somador4bits (SW [17:14], SW [3:0],  SW[10], TS, S);
decodificador ( S[3], S[2], S[1], S[0], HEX3[0], HEX3[1], HEX3[2], HEX3[3], HEX3[4], HEX3[5], HEX3[6] );
endmodule
