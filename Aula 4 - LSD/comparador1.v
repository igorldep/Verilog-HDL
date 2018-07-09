module comparador1 (A, B, igual, maior, menor);

input [1:0] A, B;
output igual, maior, menor;

assign igual = ( A == B );
assign maior = ( A > B );
assign menor = ( A < B );

endmodule