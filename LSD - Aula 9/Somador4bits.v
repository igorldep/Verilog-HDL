
module somador(a, b, te, ts, saida);
input a, b, te;
output ts, saida;

assign saida = a ^ b ^ te;
assign ts = a & b | a & te | b & te;

endmodule

//____________________________________________________________________________________________________________________

module somador4(A, B, TE0, TS5, S);

input [3:0] A;
input [3:0] B;
input TE0;
output TS5;
output [5:0] S;
wire [4:0] TS;

wire [5:0] Bn = {1'b0, 1'b0, B};
wire [5:0] An = {1'b0, 1'b0, A};
wire [5:0] Bl;
wire x = {TE0, TE0, TE0, TE0, TE0, TE0}; 

assign Bl = Bn^x;

somador (An[0], Bl[0], TE0,   TS[0], S[0]);
somador (An[1], Bl[1], TS[0], TS[1], S[1]);
somador (An[2], Bl[2], TS[1], TS[2], S[2]);
somador (An[3], Bl[3], TS[2], TS[3], S[3]);
somador (An[4], Bl[4], TS[3], TS[4], S[4]);
somador (An[5], Bl[5], TS[4], TS5, S[5]);

endmodule

//____________________________________________________________________________________________________________________

module decodificador (entrada, saida);
	input [3:0]entrada;
	output reg[0:6]saida;

	always@(*)begin
		case({entrada})
		4'b0000:	saida = 7'b0000001;
		4'b0001:	saida = 7'b1001111;
		4'b0010:	saida = 7'b0010010;
		4'b0011:	saida = 7'b0000110;
		4'b0100:	saida = 7'b1001100;
		4'b0101:	saida = 7'b0100100;
		4'b0110:	saida = 7'b0100000;
		4'b0111:	saida = 7'b0001111;
		4'b1000:	saida = 7'b0000000;
		4'b1001:	saida = 7'b0000100;
		endcase
	end

endmodule
//____________________________________________________________________________________________________________________

module Somador4bits (SW,HEX0, HEX1);

input [17:0] SW;
output [0:6] HEX0, HEX1;
wire TS;
wire [5:0] S, num0, num1;

somador4 (SW [17:14], SW [3:0],  SW[11], TS, S);

assign num0 = ( S / 10 );
assign num1 = ( S % 10 );

decodificador (num0[3:0], HEX1);
decodificador (num1[3:0], HEX0);

endmodule

//____________________________________________________________________________________________________________________