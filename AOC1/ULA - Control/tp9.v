//ALUNO: 2014422040348 - Igor Luciano de Paula

module Control(op,LastBit,MemWrite,MemRead,PCSrc,ALUSrc,ALUOp,RegDst,RegWrite,MemtoReg);
	input [2:0]op;
	input LastBit;
	output reg MemWrite,MemRead,PCSrc,ALUSrc,ALUOp,RegDst,RegWrite,MemtoReg;
	
	always @(op,LastBit) begin
		case(op)
			//jal - fl
			3'b000: begin
					MemWrite <= 0; 
					MemRead 	<= 0; 
					PCSrc 	<= 0; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 1;
					MemtoReg <= 0;						//x : assumido como 0
			end
			
			//jr - fr
			3'b001: begin
					MemWrite <= 0; 
					MemRead 	<= 0; 
					PCSrc 	<= 0; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 0;
					MemtoReg <= 0;
			end
			
			//add - sum
			3'b010: begin
					MemWrite <= 0; 
					MemRead 	<= 0; 
					PCSrc 	<= 1; 
					ALUSrc 	<= 1; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 1;
					MemtoReg <= 0;
			end

			//beq - bq
			3'b011: begin
				if(LastBit == 1'b0) begin
					MemWrite <= 0; 
					MemRead 	<= 0; 
					PCSrc 	<= 0; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 0;
					MemtoReg <= 0;						//x
				end
				
				else begin
					MemWrite <= 0; 
					MemRead 	<= 0; 
					PCSrc 	<= 1; 
					ALUSrc 	<= 1; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 0;
					MemtoReg <= 0;						//x
				end
			end
			
			//sw - sw
			3'b100: begin
					MemWrite <= 1; 
					MemRead 	<= 0; 
					PCSrc 	<= 1; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 0;
					MemtoReg <= 0;
			end
			
			//lw - lw
			3'b101: begin
					MemWrite <= 0; 
					MemRead 	<= 1; 
					PCSrc 	<= 1; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 1;
					MemtoReg <= 1;
			end
			
			//xor - xr
			3'b110: begin
					MemWrite <= 0;
					MemRead 	<= 0; 
					PCSrc 	<= 1; 
					ALUSrc 	<= 1; 
					ALUOp 	<= 1; 
					RegDst 	<= 0; 
					RegWrite <= 1;
					MemtoReg <= 0;
			end
			
			//la - ca
			3'b111: begin
					MemWrite <= 0;
					MemRead 	<= 1; 
					PCSrc 	<= 1; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 1;
					MemtoReg <= 1;
			end
			
			//halt - ht
			8'b11111111: begin						//últimos 5 bits diferem 'ca' do 'ht'
					MemWrite <= 0;
					MemRead 	<= 0; 
					PCSrc 	<= 0; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 0;
					MemtoReg <= 0;
			end
	  endcase
	end
endmodule

module ALU(ck,ALUOp,in1,in2,out1,zero);
	input ALUOp,ck;
	input [7:0]in1,in2;
	output reg[7:0]out1;
	output zero;
	assign zero = (out1 == 0);						//caso todos são 0

	always @(ALUOp,in1,in2) begin
		case(ALUOp)
			0: out1 <= in1 + in2;
			1: out1 <= in1 ^ in2;
			
			default: out1 <= 1;
		endcase   
	end
endmodule


module tp9();

endmodule
