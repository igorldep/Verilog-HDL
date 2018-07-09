module snoop(clock);
	input clock;
	
	wire write_miss0, read_miss0, invalidate0, write_miss1, read_miss1, invalidate1, write_miss2, read_miss2, invalidate2;
	wire readwrite;
	wire [1:0] execpu, flag0, flag1, flag2;
	wire [2:0] memdata, address, data, mem_address0, mem_data0, mem_address1, mem_data1, mem_address2, mem_data2;
	wire [3:0] outcache0, outcache1, outcache2;
	
	sharedMem m(clock, flag0, flag1, flag2, mem_address0, mem_data0, mem_address1, mem_data1, mem_address2, mem_data2, memdata);

	cpu p0(clock, 2'b00, execpu, readwrite, address, data, 
			outcache1, outcache2, write_miss1, read_miss1, invalidate1, write_miss2, read_miss2, invalidate2, 
			memdata, outcache0, flag0, mem_address0, mem_data0, write_miss0, read_miss0, invalidate0);
	cpu p1(clock, 2'b01, execpu, readwrite, address, data,
			outcache0, outcache2, write_miss0, read_miss0, invalidate0, write_miss2, read_miss2, invalidate2,
			memdata, outcache1, flag1, mem_address1, mem_data1, write_miss1, read_miss1, invalidate1);
	cpu p2(clock, 2'b10, execpu, readwrite, address, data,
			outcache0, outcache1, write_miss0, read_miss0, invalidate0, write_miss1, read_miss1, invalidate1, 
			memdata, outcache2, flag2, mem_address2, mem_data2, write_miss2, read_miss2, invalidate2);
	
endmodule

	/*
			Todos os sinais (write_miss, read_miss e invalidate) tiveram que ser criados individualmente para cada CPU
		devido ao erro de compilação ao usar um único como entrada e saída de todos os modulos, por isso existem 3
		(exemplo: invalidate0, invalidate1, invalidate2), e ai ficou bem cheio o cabeçario dos modulos, mas a grande
		maioria é simplesmente a repetição do mesmo sinal, mas para cada um dos modulos.
			O dado que as caches compartilham (outcache) também teve este problema, também tendo 3.
		
	*/
	
module cpu(clock, self, 
		execpu, readwrite, address, data, 
		cachedata1, cachedata2, 
		write_miss1, read_miss1, invalidate1, 
		write_miss2, read_miss2, invalidate2, 
		memdata, outcache, flag, mem_address, mem_data, write_miss, read_miss, invalidate);

	input write_miss1, read_miss1, invalidate1, write_miss2, read_miss2, invalidate2; 
	input clock, readwrite; // qual a instrução a ser executada (read (0) ou write (1))
	input [1:0] self; // qual a cpu atual (p0, p1 ou p2)
	input [1:0] execpu; // em qual cpu será executada a instrução (ex.: p0: read 1)
	input [2:0] address, data; // endereço/dado da instrução a se executar
	input [2:0] memdata; // dado que vem da memória principal, em caso de read miss e miss nas outras caches
	input [3:0] cachedata1, cachedata2; // dado que vem das outras caches, em caso de read miss


	
	reg finished, i; // finished = se acabou, i = bloco
	reg [1:0] estado; // estado atual (0, 1, 2 ou 3)
	reg [7:0] cache [1:0]; // cache
	
	output reg write_miss, read_miss, invalidate; // wb_block, wb_cache, mem_abort;
	output reg [1:0] flag;
	output reg [2:0] mem_address, mem_data;
	output reg [3:0] outcache;
	
	initial begin
		estado = 2'd0;
		cache[0] = 8'd0;
		cache[1] = 8'd0;
		mem_data = 3'd0;
		mem_address = 3'd0;
	end

	always @(posedge clock) begin
	
		if (estado == 2'd0) begin // resetar os sinais
			outcache = 4'b0000;
			flag = 2'b00;
			write_miss = 0;
			read_miss = 0;
			invalidate = 0;
			finished = 0;
		end

		if	(address <= 3'b011) // mapeamento: 0-3 cache[0], 4-8 cache[1]
			i = 0;
		else
			i = 1;

		if (self == execpu) begin // se essa é a máquina principal (que envia sinais)
			if (readwrite) begin // write
				if(cache[i][5:3] == address) begin // hit
					case (cache[i][7:6]) // estados
						2'd0 : // invalid
							begin
								write_miss = 1; // Place write miss on bus
								cache[i][7:6] = 2'b10; // > EXCLUSIVE
								cache[i][2:0] = data; // escrevendo o dado
								finished = 1;
							end
						2'd1 : // shared
							begin
								invalidate = 1; //Place invalidate on bus
								cache[i][7:6] = 2'b10; // > EXCLUSIVE
								cache[i][2:0] = data; // escrevendo o dado
								finished = 1;
							end
						2'd2 : // exclusivo
							begin
								cache[i][7:6] = 2'b10; // > EXCLUSIVE (continua)
								cache[i][2:0] = data; // escrevendo o dado
								finished = 1;
							end
					endcase
				end
				else begin // miss
					case (cache[i][7:6]) // estados
						2'd0 : // invalid
							begin
								write_miss = 1; //Place write miss on bus
								cache[i][7:6] = 2'b10; // > EXCLUSIVE
								cache[i][5:3] = address; // escrevendo o endereço
								cache[i][2:0] = data; // escrevendo o dado
								finished = 1;
							end
						2'd1 : // shared
							begin
								write_miss = 1; //Place write miss on bus
								cache[i][7:6] = 2'b10; // > EXCLUSIVE
								cache[i][5:3] = address; // escrevendo o endereço
								cache[i][2:0] = data; // escrevendo o dado
								finished = 1;
							end
						2'd2 : // exclusivo
							begin
								//wb_cache = 1; // Write-back cache block
								mem_address = cache[i][5:3]; // write-back address
								mem_data = cache[i][2:0]; // write-back data
								flag = 2'b10; // write on mem
								write_miss = 1; // Place write miss on bus
								cache[i][7:6] = 2'b10; // > EXCLUSIVE
								cache[i][5:3] = address; // escrevendo o endereço
								cache[i][2:0] = data; // escrevendo o dado
								finished = 1;
							end
					endcase
				end
			end
			else begin // read
				if(cache[i][5:3] == address) begin // hit
					case  (cache[i][7:6]) // estados
						2'd0 : // invalid
							begin
								read_miss = 1; //Place read miss on bus
								cache[i][5:3] = address; // escrevendo o endereço
								if(estado == 2'd2) begin 
									if(cachedata1[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata1[2:0]; // pegando o dado da outra cache
										cache[i][7:6] = 2'b01; // > SHARED
										finished = 1;
									end
									else if(cachedata2[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata2[2:0]; // pegando o dado da outra cache
										cache[i][7:6] = 2'b01; // > SHARED
										finished = 1;
									end
									else
										flag = 2'b01; // se não for valido o dado da cache, pede para a memória
								end
								else if(estado == 2'd3) begin
									cache[i][2:0] = memdata; // pegando o dado da memória principal
									cache[i][7:6] = 2'b01; // > SHARED
									finished = 1;
								end
							end
						2'd1 : // shared
							begin
								cache[i][7:6] = 2'b01; // > SHARED (continua)
								finished = 1;
							end
						2'd2 : // exclusivo
							begin
								cache[i][7:6] = 2'b10; // > EXCLUSIVE (continua)
								finished = 1;
							end
					endcase
				end
				else begin // miss
					case (cache[i][7:6]) // estados
						2'd0 : // invalid
							begin
								read_miss = 1; //Place read miss on bus
								cache[i][5:3] = address; // escrevendo o endereço
								if(estado == 2'd2) begin
									if(cachedata1[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata1[2:0]; // pegando o dado da outra cache
										cache[i][7:6] = 2'b01; // > SHARED
										finished = 1;
									end
									else if(cachedata2[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata2[2:0]; // pegando o dado da outra cache
										cache[i][7:6] = 2'b01; // > SHARED
										finished = 1;
									end
									else
										flag = 2'b01; // se não for valido o dado da cache, pede para a memória
								end
								else if(estado == 2'd3) begin
									cache[i][2:0] = memdata; // pegando o dado da memória principal
									cache[i][7:6] = 2'b01; // > SHARED
									finished = 1;
								end
							end
						2'd1 : // shared
							begin
								read_miss = 1; //Place read miss on bus
								cache[i][5:3] = address; // escrevendo o endereço
								if(estado == 2'd2) begin
									if(cachedata1[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata1[2:0]; // pegando o dado da outra cache
										finished = 1;
									end
									else if(cachedata2[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata2[2:0]; // pegando o dado da outra cache
										finished = 1;
									end
									else
										flag = 2'b01; // se não for valido o dado da cache, pede para a memória
								end
								else if(estado == 2'd3) begin
									cache[i][2:0] = memdata; // pegando o dado da memória principal
									finished = 1;
								end
							end
						2'd2 : // exclusivo
							//Para a thread principal: Se read miss, não tem como o dado tar Exclusivo, senão seria hit
							begin
								// escrevendo o dado na memória
								//wb_block = 1; // Write-back block
								mem_address = cache[i][5:3]; // write-back address
								mem_data = cache[i][2:0]; // write-back data
								flag = 2'b10; // write on mem
								//
								cache[i][5:3] = address; // escrevendo o endereço
								if(estado == 2'd2) begin
									if(cachedata1[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata1[2:0]; // pegando o dado da outra cache
										cache[i][7:6] = 2'b01; // > SHARED
										finished = 1;
									end
									else if(cachedata2[3] == 1) begin // se o dado for valido (bit de validade = 1)
										cache[i][2:0] = cachedata2[2:0]; // pegando o dado da outra cache
										cache[i][7:6] = 2'b01; // > SHARED
										finished = 1;
									end
									else
										flag = 2'b01; // se não for valido o dado da cache, pede para a memória
								end
								else if(estado == 2'd3) begin
									cache[i][2:0] = memdata; // pegando o dado da memória principal
									cache[i][7:6] = 2'b01; // > SHARED
									finished = 1;
								end
							end
					endcase
				end
			end
			end
		else if(estado == 2'd1 && cache[i][5:3] == address) begin // ou se essa é a thread secundaria (que recebe sinais), só executa se for no estado 1 e se o endereço for o mesmo da instrução
			case (cache[i][7:6])
				2'd0 : cache[i][7:6] = 2'd0; // invalid (não acontece nada)
				2'd1 : // shared
					begin
						if (read_miss1 || read_miss2) begin // Place read miss on bus
							cache[i][7:6] = 2'd1; // > SHARED (continua)
							outcache[3] = 1; // validar o dado
							outcache[2:0] = cache[i][2:0]; // exportar o dado
						end
						else begin
							if (write_miss1 || invalidate1 || write_miss2 || invalidate2) begin // Place write miss on bus or Place invalidate on bus
								cache[i][7:6] = 2'd0; // > INVALID
							end
						end
					end
				2'd2 : // exclusive
					begin
						if (read_miss1 || read_miss2) begin // Place read miss on bus
							// escrevendo o dado na memória
							//wb_block = 1; // Write-back block
							mem_address = cache[i][5:3]; // write-back address
							mem_data = cache[i][2:0]; // write-back data
							flag = 2'b10; // write on mem
							//
							//mem_abort = 1;
							outcache[3] = 1; // validar o dado
							outcache[2:0] = cache[i][2:0]; // exportar o dado
							cache[i][7:6] = 2'b01; // > SHARED
						end
						else begin
							if (write_miss1 ||  write_miss2) begin // Place write miss on bus
								// escrevendo o dado na memória
								//wb_block = 1; // Write-back block
								mem_address = cache[i][5:3]; // write-back address
								mem_data = cache[i][2:0]; // write-back data
								flag = 2'b10; // write on mem
								//
								//mem_abort = 1;
								cache[i][7:6] = 2'd0; // > INVALID
							end
						end
					end
			endcase
		end

		if (estado == 2'd0)
			estado = 2'd1;
		else if (estado == 2'd1)
			estado = 2'd2;
		else if(estado == 2'd2)
			estado = 2'd3;
		else if(estado == 2'd3)
			estado = 2'd0;
		
		if (finished == 1 && estado != 2'd1)
			estado = 2'd0;
		
		if (cache[i][5:3] != address && estado != 2'd1)
			estado = 2'd0;

	end // endalways
endmodule

module sharedMem(clock, flag0, flag1, flag2, tag0, datain0, tag1, datain1, tag2, datain2, memdata);
	//flag: 0 - nada;  1 - envia dado;  2 - escreve dado

	input clock;
	input [1:0] flag0, flag1, flag2;
	input [2:0] tag0, datain0, tag1, datain1, tag2, datain2;
	output reg [2:0] memdata;

	reg [2:0] self [7:0]; //(3) data

	initial begin // pode começar com outro valor
		self[0] = 3'b0;
		self[1] = 3'b0;
		self[2] = 3'b0;
		self[3] = 3'b0;
		self[4] = 3'b0;
		self[5] = 3'b0;
		self[6] = 3'b0;
		self[7] = 3'b0;
	end

	always @(posedge clock) begin
		if (flag0 == 2'b10) begin
			self[tag0] = datain0;
		end
		else if(flag1 == 2'b10) begin
			self[tag1] = datain1;
		end
		else if(flag2 == 2'b10) begin
			self[tag2] = datain2;
		end
		else if (flag0 == 2'b01) begin
			memdata = self[tag0];
		end
		else if (flag1 == 2'b01) begin
			memdata = self[tag1];
		end
		else if (flag2 == 2'b01) begin
			memdata = self[tag2];
		end
	end

endmodule


/* 

Estado 0 : 	thread primaria: execução normal, envia sinais para as threads secundaria; se precisar de um dado (read miss), pede para as caches secundarias
		  threads secundarias: nada
Estado 1	:	thread primaria: nada
	     threads secundarias: recebe os sinais e executa; se necessário e possuir, envia dados para a cache primaria
Estado 2 :	thread primaria: recebe o dado da cache; se for invalido/não satisfazer, pede para a memória principal
	     threads secundarias: nada
Estado 3 : 	thread primaria: recebe o dado da memória principal, e encerra a instrução
		  threads secundarias: nada

*/
