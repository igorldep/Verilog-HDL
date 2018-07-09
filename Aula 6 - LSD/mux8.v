module mux8 (i0, i1, i2, i3, sela, selb, s);

input i0, i1, i2, i3, sela, selb;
wire s0, s1;
output s;


muxx bloco0 (i0, i1, selb, s0);
muxx bloco1 (i2, i3, selb, s1);
muxx bloco2 (s0, s1 , sela, s);


endmodule