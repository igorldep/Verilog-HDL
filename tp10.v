//ALUNO: 201422040348 - Igor Luciano de Paula

module tp10();

endmodule


module Mux2_1(in1, in2, sel, out);
	input [7:0]in1, in2;
	input sel;
	output reg[7:0]out;
	
	always @(in1, in2, sel)
	begin
		case(sel)
			1'b0: out <= in1;
			1'b1: out <= in2;
		endcase
	end
endmodule


module Mux2B2_1(in1, in2, sel, out);
	input [1:0]in1, in2;
	input sel;
	output reg[1:0]out;
	
	always @(in1, in2, sel) begin
		case(sel)
		 	1'b0: out <= in1;
			1'b1: out <= in2;
		endcase
	end
endmodule


module Somador(in1, in2, out);
	input [7:0]in1, in2;
	output reg [7:0] out;
	
	always@(in1, in2) begin out <= in1 + in2; end
endmodule


module Branch(zero, comp, inst, sJump, sBranch, out);
	input zero, comp, sJump, sBranch;
	input [2:0]inst;
	output reg[1:0]out;
	
	always @(zero, sJump, sBranch, comp) begin
		if(sJump == 1) begin out <= 2'b10; end
		else if( (sBranch == 1 && zero == 1 && inst == 3'b100) || (sBranch == 1 && comp == 1 && inst == 3'b110))
		begin
			out <= 2'b01;
		end
		else begin out <= 2'b00; end
	end
endmodule


module Extensor1_8(in, out);
	input in;
	output reg [7:0] out;
	
	always @(in) begin
		if(in == 0) begin out <= {7'b0000000, in}; end
		else begin out <= {7'b1111111, in}; end
	end
endmodule


module Extensor5_8(in, out);
	input [4:0] in;
	output reg [7:0] out;
	
	always @(in) begin
		if(in[4] == 0) begin out <= {3'b000, in}; end
		else begin out <= {3'b111, in}; end
	end
endmodule
