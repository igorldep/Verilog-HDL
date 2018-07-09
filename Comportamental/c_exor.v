module c_exor(input a, b, output reg y);

/*2'b11 => 2: num. de bits; ': separar; b: binário; "11": num. em binário
 *if, case, for } always (funciona de forma sequencial)
 */
 
always @(a or b)
    begin
	 
	 case ( { a, b } ) //Concatenação => reg output
	     2'b00: y = 0;
		  2'b01: y = 1;
		  2'b10: y = 1;
		  2'b11: y = 0;
    endcase;
end

endmodule