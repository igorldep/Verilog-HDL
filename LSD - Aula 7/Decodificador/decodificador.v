module decod (A, B, C, D, a, b, c, d, e, f, g );
input A, B, C, D;
output a, b, c, d, e, f, g;

http://www.32x8.com
~A & ~B & ~C & ~D |

assign a = ( ~B & ~D | A & ~D | ~A & ~B & C | ~A & B & D | B & C & D | A & ~B & ~C );
//assign b = (~A & B & ~C & D | ~A & B & C & ~D);
//assign c = (~B & C & ~D | ~A & ~B & ~C & D);
//assign d = ( B & ~C & ~D | B & C & D | ~A & ~B & ~C & D);
//assign e = (D | B & ~C);
//assign f = (~B & C | C & D | ~A & ~B & D);
//assign g = ( ~A & ~B & ~C | ~A & ~B & ~D | B & C & D);

endmodule

module decodificador (SW,HEX0);
input SW[17:0];
output HEX0[0:6];

decod ( SW[17],SW[16], SW[15], SW[14], HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6] );

endmodule

