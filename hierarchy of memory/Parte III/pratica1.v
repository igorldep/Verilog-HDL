module display(value, hex);
	input [3:0] value;
	output reg [6:0] hex;
	always @(*)
	begin
		case(value)
			4'b0000 : hex = 7'b1000000;
			4'b0001 : hex = 7'b1111001;
			4'b0010 : hex = 7'b0100100;
			4'b0011 : hex = 7'b0110000;
			4'b0100 : hex = 7'b0011001;
			4'b0101 : hex = 7'b0010010;
			4'b0110 : hex = 7'b0000010;
			4'b0111 : hex = 7'b1111000;
			4'b1000 : hex = 7'b0000000;
			4'b1001 : hex = 7'b0010000;
			default : hex = 7'b0111111;
		endcase
	end
endmodule

module pratica1(SW, HEX0, HEX1, HEX2);
	input [17:0] SW;
	output [6:0] HEX0, HEX1, HEX2; 

	wire [7:0] cache_address, cache_out, ram_address, ram_data, ram_out;
	wire [3:0] cache_data;
	wire cache_wren, clock, ram_wren;
	assign cache_address = SW[17:10];
	assign cache_data = SW[3:0];
	assign cache_wren = SW[8];
	assign clock = SW[9];

	
	//ram1 m(address, clock, data, wren, out);

	memory cache(cache_address, clock, cache_data, cache_wren, ram_out, cache_out, ram_address, ram_data, ram_wren);
	
	ram1 m(ram_address, clock, ram_data, ram_wren, ram_out);	
	
	//ram1 m(SW[17:10], SW[9], SW[7:0], SW[8], out);
	
	wire [3:0] c, d, u;
	assign c = cache_out / 100;
	assign d = (cache_out % 100) / 10;
	assign u = cache_out % 10;
	display d1(c, HEX2);
	display d2(d, HEX1);
	display d3(u, HEX0);
	
endmodule
