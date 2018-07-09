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

module memoryInst(ck,sce,out);
	input ck;
	input [7:0]sce;
	output reg [7:0] out;
	integer i;
	reg [7:0]MEM[127:0];
	
	initial
	begin
		$readmemb("arq.txt",MEM,0,45);
	end
		
	//Leitura na descida do clock
	always @(negedge ck)
	begin
		out <= MEM[sce];
	end
endmodule

module memory(ck,signalite,signalRead,sce,Data,out);
	input ck,signalite,signalRead;
	input [7:0] Data,sce;
	reg [7:0]aux;
	output reg [7:0] out;
	reg [7:0]MEM[127:0];//memoria de 8 bits com 128 posicoes
	
	initial
	begin
		MEM[8'b00000000] <= 8'b00000100;
		MEM[8'b00000001] <= 8'b00000000;
		MEM[8'b00000010] <= 8'b00000111;
		MEM[8'b00000011] <= 8'b00000010;
	end
	
	//escreve: subida do ck
	always @(posedge ck)
	begin
		if(signalite == 1)
		begin
			MEM[sce] <= Data;
		end
	end
	
	//lê: descida do ck
	always @(signalRead,sce)
	begin
		if(signalRead == 1)
		begin
			out <= MEM[sce];
		end
	end
endmodule

module PC(ck,pc_novo,pc_atual);
	input ck;
	input [7:0] pc_novo;
	output reg [7:0]pc_atual;
	
	initial
	begin
		pc_atual <= 8'b00000000; //Inicio: 0
	end
	
	//Borda de subida
	always @(posedge ck)
	begin
		pc_atual <= pc_novo;
	end
endmodule
