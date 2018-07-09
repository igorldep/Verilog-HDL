module E_XOR (Y,A,B);

output Y;
input A, B;
wire notA, notB; //wire = variável apaga o valor após o uso
wire and1, and2;
not (notA, A);
not (notB, B);
and (and1, notA, B);
and (and2, notB, A);
or SaidaXOR (Y, and1, and2); //Saída XOR é o nome do bloco -> facilita a vizualização

endmodule