// Igor Luciano de Paula & Eduardo Junqueira de Matos

module memory(address, clock, data, wren, qram, out, raddress, dataram, wrenram);
	
	input clock;
	input [7:0] address, qram;
	input [3:0] data;
	input wren;
	output reg [7:0] out;
	output reg [7:0] raddress, dataram;
	output reg wrenram;
	reg hit;
	reg [3:0] temp;
	integer i, j;
	reg [15:0]cache[3:0];						/* 1111 11111111 11 1 1
									
									// 15 = validade
									// 14 = dirty
									// 13:12 = lru
									// 11:4 = tag
									// 3:0 = data */

	initial begin //Inicialização
			cache[0] = 16'b1000011001000101;
			cache[1] = 16'b1001011001100001;
			cache[2] = 16'b0011011010010101;
			cache[3] = 16'b1010011001010011;
	end
	
	always @(posedge clock) begin
		hit = 0;

		//escrita
		if (wren == 1'b1) begin
			for (i=0; i<=3; i = i + 1) begin
				if(cache[i][11:4] == address) begin // hit
					hit = 1;
					cache[i][3:0] = data; // recebe o dado 
					cache[i][15] = 1'b1; // valid
					cache[i][14] = 1'b1; // dirty
					for(j=0; j<=3; j = j + 1)begin // atualiza LRU
						if(cache[j][13:12] != 2'b11) begin
							cache[j][13:12] = cache[j][13:12] + 2'b01;
						end
					end
					cache[i][13:12] = 2'b00;//Atualiza LRU do novo bloco
				end
			end//endfor possivel hit
			if (hit == 0) begin // miss
				for (i = 0; i <= 3; i = i + 1) begin
					if(cache[i][13:12] == 2'b11) begin // Mais antigo
						if(cache[i][15] == 1'b1 && cache[i][14] == 1'b1) begin //Write-back
							raddress = cache[i][11:4];
							dataram = cache[i][3:0];
							wrenram = 1;
						end
						cache[i][3:0] = data;
						cache[i][11:4] = address;
						cache[i][13:12] = 2'b00; // lru
						cache[i][14] = 1'b1; // dirty
						cache[i][15] = 1'b1; // valid

					end
					else begin
						cache[i][13:12] = cache[i][13:12] + 2'b01; // resto da lru
					end
				end //endfor
			end //endif miss
		end //endif escrita
		else begin // leitura
			for(i = 0; i <= 3; i = i + 1) begin
				if(cache[i][11:4] == address && cache[i][15] == 1) begin // hit
					hit = 1;
					out = cache[i][3:0]; // dar o dado
					for(j = 0; j <= 3; j = j + 1)begin // atualizar LRU
						if(cache[j][13:12] != 2'b11) begin
							cache[j][13:12] = cache[j][13:12] + 2'b01;
						end
					end
					cache[i][13:12] = 2'b00;
				end //endif hit
			end //endfor
			if (hit == 0) begin // miss
				raddress = address;
				dataram = data;
				wrenram = 0; // lendo o dado da memoria
				for (i = 0; i <= 3; i = i + 1) begin
					if(cache[i][13:12] == 2'b11) begin
						//temp[3:0] = qram[3:0];
						if(cache[i][15] == 1'b1 && cache[i][14] == 1'b1) begin // writeback 
							raddress = cache[i][11:4];
							dataram = cache[i][3:0];
							wrenram = 1;
						end
						//Pega os dados *** ?Erro? ***
						out = qram[3:0];
						cache[i][3:0] = qram[3:0]; // atualizando a L1
						cache[i][11:4] = address;
						cache[i][13:12] = 2'b00; // lru
						cache[i][14] = 0; // dirty
						cache[i][15] = 1; // valid

					end
					else begin
						cache[i][13:12] = cache[i][13:12] + 2'b01; // resto da lru
					end
				end //endfor
			end //endif miss
		end //endif leitura
	end
endmodule
