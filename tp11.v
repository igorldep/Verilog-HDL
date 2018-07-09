module RegB(ck,d,s1,s2,Data,Signal,out1,out2);
	input [1:0]d,s1,s2;
	input [7:0]Data;
	input [0:0]Signal,ck;
	output [7:0]out1,out2;
	reg [7:0]RF[3:0];
	
	initial
	begin
		RF[2'b00] <= 8'b00000000;
		RF[2'b11] <= 8'b00000000;
		RF[2'b01] <= 8'b00000000;
		RF[2'b10] <= 8'b00000000;
	end
	
	//saídas
	assign out1 = RF[s1];
	assign out2 = RF[s2];

	always @(posedge ck)
	begin
		if(Signal == 1 & (d[0] == 0 | d[1] == 0))
		begin
			RF[d] <= Data;
		end
	end

endmodule


module memoryInst(ck,endereco,out);
	input ck;
	input [7:0]endereco;
	output reg [7:0] out;
	integer i;
	reg [7:0] MEM[127:0];
	reg [7:0] instrucao;
	wire [0:2] inst75, inst20;
	wire [0:1] inst23, inst01;
	reg inst4, inst3, TipoInst;
	
	initial begin
		MEM[8'b00000000] <= 8'b00000000; // add $s0, 0, 0		-	000 0 00 00
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4	-	001 1 0 100
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)	-	010 0 0 000
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)	-	010 1 1 000
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1 -	011 1 00 01
		MEM[8'b00000101] <= 8'b00000000; // add $s0, 0, 0		-	000 0 00 00
		MEM[8'b00000110] <= 8'b10010000; // sw  $s1, 0($s0)	-	100 1 0 000
		
		MEM[8'b00000000] <= 8'b00000001; // add $s0, 0, 1
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1
		MEM[8'b00000101] <= 8'b00000001; // add $s0, 0, 1
		MEM[8'b00000110] <= 8'b10010000; // sw  $s1, 0($s0)
		
		MEM[8'b00000000] <= 8'b00000010; // add $s0, 0, 2
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1
		MEM[8'b00000101] <= 8'b00000010; // add $s0, 0, 2
		MEM[8'b00000110] <= 8'b10010000; // sw  $s1, 0($s0)
		
		MEM[8'b00000000] <= 8'b00000011; // add $s0, 0, 3
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1
		MEM[8'b00000101] <= 8'b00000011; // add $s0, 0, 3
		MEM[8'b00000110] <= 8'b10010000; // sw  $s1, 0($s0)
		
		
		//Decodificação
		$display ("Decodificação: ");
		
		MEM[8'b00000000] <= 8'b00000000; // add $s0, 0, 0
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1
		MEM[8'b00000101] <= 8'b00000000; // add $s0, 0, 0
		
		MEM[8'b00000000] <= 8'b00000001; // add $s0, 0, 1
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1
		MEM[8'b00000101] <= 8'b00000001; // add $s0, 0, 1
		
		MEM[8'b00000000] <= 8'b00000010; // add $s0, 0, 2
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1
		MEM[8'b00000101] <= 8'b00000010; // add $s0, 0, 2
		
		MEM[8'b00000000] <= 8'b00000011; // add $s0, 0, 3
		MEM[8'b00000001] <= 8'b00110100; // add $s1, $s0, 4
		MEM[8'b00000010] <= 8'b01000000; // lw  $s0, 0($s0)
		MEM[8'b00000011] <= 8'b01011000; // lw  $s1, 0($s1)
		MEM[8'b00000100] <= 8'b01110001; // xor $s1, $s0, $s1
		MEM[8'b00000101] <= 8'b00000011; // add $s0, 0, 3
				
	end
	
	always @(endereco) begin
		instrucao <= MEM[endereco];
	end

	always @(instrucao, TipoInst) begin
		case(instrucao)
			//addi
			3'b000: begin TipoInst <= 1; end
			3'b001: begin TipoInst <= 0; end
			3'b010: begin TipoInst <= 0; end
			3'b011: begin TipoInst <= 1; end
			3'b100: begin TipoInst <= 0; end
	  endcase
	end
	
	always @(instrucao) begin
		if (TipoInst) begin	// Tipo 1 : 000 0 00 00
			inst75 <= instrucao[7:5];
			inst4  <= instrucao[4];
			inst23 <= instrucao[2:3];
			inst01 <= instrucao[0:1];
		end
		else begin //Tipo 0 : 000 0 0 000
			inst75 <= instrucao[7:5];
			inst4  <= instrucao[4];
			inst3  <= instrucao[3];
			inst20 <= instrucao[2:0];
		end
	end
		
	//Leitura na descida do clock
	//always @(negedge ck)
	//begin
	//	out <= MEM[endereco];
	//end
endmodule


module Memory(ck,signalite,signalRead,endereco,Data,out);
	input ck,signalite,signalRead;
	input [7:0] Data,endereco;
	reg [7:0]aux;
	output reg [7:0] out;
	reg [7:0]MEM[127:0]; //memoria de 8 bits com 128 posicoes
	
	initial begin
		MEM[8'b00000000] <= 8'b00000110; // 6: G
		MEM[8'b00000001] <= 8'b00000000; // 0: A
		MEM[8'b00000010] <= 8'b00001011; //11: L
		MEM[8'b00000011] <= 8'b00001110; //14: O
		
		//Chave
		MEM[8'b00000100] <= 8'b00001010; //10: K
		MEM[8'b00000101] <= 8'b00000100; // 4: E
		MEM[8'b00000110] <= 8'b00011000; //24: Y
		MEM[8'b00000111] <= 8'b00010111; //23: X
	end
	
	//escreve: subida do ck
	always @(posedge ck)
	begin
		if(signalite == 1)
		begin
			MEM[endereco] <= Data;
		end
	end
	
	//lê: descida do ck
	always @(signalRead,endereco)
	begin
		if(signalRead == 1)
		begin
			out <= MEM[endereco];
		end
	end
endmodule


module PC(ck,pc_novo,pc_atual);
	input ck;
	input [7:0] pc_novo;
	output reg [7:0]pc_atual;
	
	initial begin
		pc_atual <= 8'b00000000; //Inicio: 0
	end
	
	//Borda de subida
	always @(posedge ck)
	begin
		pc_atual <= pc_novo;
	end
endmodule


module Control(op,MemWrite,MemRead,PCSrc,ALUSrc,ALUOp,RegDst,RegWrite,MemtoReg);
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
				//if(LastBit == 1'b0) begin
					MemWrite <= 0; 
					MemRead 	<= 0; 
					PCSrc 	<= 0; 
					ALUSrc 	<= 0; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 0;
					MemtoReg <= 0;						//x
				//end
				
/*				else begin
					MemWrite <= 0;
					MemRead 	<= 0; 
					PCSrc 	<= 1; 
					ALUSrc 	<= 1; 
					ALUOp 	<= 0; 
					RegDst 	<= 0; 
					RegWrite <= 0;
					MemtoReg <= 0;						//x
				end 
*/			end
			
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
	
	$monitor ("saída ULA: %d", out1);
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
		if(in == 0) begin	out <= {7'b0000000, in}; end
		else begin out <= {7'b1111111, in}; end
	end
endmodule


module Extensor5_8(in, out);
	input [4:0] in;
	output reg [7:0] out;
	
	always @(in) begin
		if(in[4] == 0) begin	out <= {3'b000, in}; end
		else begin out <= {3'b111, in}; end
	end
endmodule


module tp11(); //nRisc
	reg clk;
	wire [7:0] PCSearch,PCNew,inst, pc_;
	wire [1:0] selMuxBranch;
	wire MemWrite,MemRead,JumpInc,Branch,ALUOp,RegORIm,RegWrite,RegSource;
	wire [1:0] MuxInRegOut;
	wire [7:0] reg1,reg2,wrRegData,im,inALU,outALU,outMem;
	wire [7:0] dJump,dBranch,jumpExt;
	wire zero;
	//reg [7:0] PC;

	initial begin clk <= 0; end
	
	PC pc_(clk,PCSearch,PCNew);
	memoryInst memI_(clk,PCNew,inst);
	Somador soma_(PCNew,8'b00000001, pc_);
	Control controle_(inst75,MemWrite,MemRead,JumpInc,Branch,ALUOp,RegORIm,RegWrite,RegSource);
	//Mux2B2_1 mux2b21_(inst[4:3],inst[2:1],RegSource,MuxInRegOut);
	RegB rBank_(clk,inst[4:3],MuxInRegOut,inst[2:1],wrRegData,RegWrite,reg1,reg2);
	//Extensor1_8 ext18_(inst[0],im);
	//Mux2_1 mux21_(reg1,im,RegORIm,inALU);
	ALU ula_(clk,ALUOp,reg2,inALU,outALU,zero);
	Branch desvio_(zero,outALU[7:7],inst[7:5],JumpInc,Branch,selMuxBranch);
	Extensor5_8 ext58_(inst[4:0],jumpExt);
	Somador s_jump(_pc,jumpExt,dJump);
	Somador s_branch(_pc,im,dBranch);
	Memory mem_(clk,MemWrite,MemRead,reg2,reg1,outMem);
	
endmodule
