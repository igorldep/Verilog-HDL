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

module memoria(address, clock, data, wren, out);
	input [7:0] address, data;
	input clock, wren;
	output [7:0] out;
	
	ram1 m(address, clock, data, wren, out);
endmodule


module pratica1(SW, HEX0, HEX1, HEX2, HEX3);
	input [17:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3; 

	wire [7:0] address, data, out;
	wire wren, clock;
	assign address = SW[17:10];
	assign data = SW[7:0];
	assign wren = SW[8];
	assign clock = SW[9];

	ram1 m(address, clock, data, wren, out);
                                            
	
	//ram1 m(SW[17:10], SW[9], SW[7:0], SW[8], out);
	
	wire [3:0] c, d, u;
	assign c = out / 100;
	assign d = (out % 100) / 10;
	assign u = out % 10;
	display d1(c, HEX2);
	display d2(d, HEX1);
	display d3(u, HEX0);
	assign HEX3 = 7'b1111111;
	
endmodule
