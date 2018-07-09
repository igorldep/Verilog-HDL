module f_exor(Y, A, B);

output Y;
input A, B;

assign Y = ( ( ( ~A ) & B ) | ( A & ( ~B ) ) );

endmodule