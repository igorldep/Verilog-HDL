 /*Deve mostrar: Dependencia verdadeira RAW, antidependência WAR, depência de saída WAW, Hazard Estrutural(stall),
  *				  2 unidades funcionais tentam escrever no cdb simultaneamente, adiantamento na RS e renomeação de registradores.
  */
  
module tomasulo(clock);

	input clock;
	wire [15:0] reg1_as, reg2_as, reg1_md, reg2_md, inst, out_as, out_md, data_in, data_out, cdb;
	wire [15:0] regout1_as, regout2_as, regout1_md, regout2_md, instr_as, instr_md, label_as, label_md, out1; 
	wire [2:0] req1_as, req2_as, req1_md, req2_md;
	wire [1:0] disp_as, disp_md;
	wire write, do_as, do_md, in_signal, disp_signal, ula_disp_as, ula_disp_md;
	
	ULA_muldiv md(clock, reg1_md, reg2_md, inst, do_md, out_as, ula_disp_as);
	ULA_addsub as(clock, reg1_as, reg2_as, inst, do_as, out_md, ula_disp_md);
	inst_queue fila(data_in, clock, in_signal, disp_as, disp_md, instr_as, instr_md, disp_signal); //sinais conectados daqui para cima

	Reservation_Station rs_add_sub(clock, cdb, 0, instr_as, disp_signal, ula_disp_as, regout1_as, regout2_as, req1_as, req2_as, disp_as, label_as, reg1_as, reg1_as, do_as);
	Reservation_Station rs_mul_div(clock, cdb, 1, instr_md, disp_signal, ula_disp_md, regout1_md, regout2_md, req1_md, req2_md, disp_md, label_md, reg1_md, reg2_md, do_md);
	Registers_Bank reg_bank(label_as, label_md, req1_as, req2_as, req1_md, req2_md, cdb, clock, write, regout1_as, regout2_as, regout1_md, regout2_md);
	CDB_Arbriter cdb1(clock, out_as, out_md, write, cdb);

endmodule
 
//ROM ENVIA INSTRUÇÕES PARA A FILA DE INSTRUÇÕES
// OU INITIAL CONTENDO TODAS AS INTRUÇÕES
module inst_queue(data_in, clock, in_signal, disp_as, disp_md, out_as, out_md, signal); //FIFO
	input clock, in_signal;
	input [1:0] disp_as, disp_md;
	input [15:0] data_in;
	reg [15:0] queue [0:15]; //Fila de 16 instruções de 16 bits
	reg [3:0] first, last;
	output reg [15:0] out_as, out_md;
	output reg signal;
	
	initial begin
		first = 0;
		last =  0;
	end

	
	always @(posedge clock) begin
	 // O número máximo de instruções desejadas é 16. Não é necessário Alocação Dinâmica.
		if(in_signal) begin // Colocar dado
			if (last < 4'd16) begin // Verifica fila cheia
				if (!first) begin // Se a primeira posição for 0
					queue[last] = data_in; // Adiciona na posição 0
				end
				else begin // Se o primeiro NÃO for 0
					last = last + 1'd1; // Adicona 1 em decimal
					queue[last] = data_in;
				end
			end
		end
		
		if (first > 4'd0) begin
			if(queue[first][15:13] <= 3'b001) begin // instrução de add_sub
				if (disp_as != 2'b00) begin // se tiver slot
					signal = disp_as; // fala em qual slot a instrução vai entrar
					out_as = queue[first]; // despacha a instrução
					first = first + 1; 
				end
			end
			else begin // instrução de mul_div
				if (disp_md != 2'b00) begin // se tiver slot
					signal = disp_md; // fala em qual slot a instrução vai entrar
					out_md = queue[first]; // despacha a instrução
					first = first + 1;
				end
			end
		end
		
	end //always
	
endmodule


module ULA_addsub(clock, A, B, inst, do, out, disponivel);
	
	input [15:0] A, B; //operandos
	input [2:0] inst; //parte da instrução que indica a operação a ser realizada - add ou sub
	input clock, do; //sinal vindo do RS, indicando que a operação pode ser feita(operandos corretos)
	output reg disponivel;
	output reg [15:0] out; //saída
	reg [2:0] estado;
	reg [15:0] reg1, reg2;

	initial begin
		disponivel = 1;
	end
	
	always @(posedge clock) begin
	
		out = 16'd0;

		if (do) begin // ler a armazenar os registradires
			estado = 3'd0;
			reg1 = A;
			reg2 = B;
			disponivel = 0;
		end
	
		estado = estado + 1;
		
		if (estado == 2) begin // dois ciclos para add/sub
			case(inst)
				3'b000 : out = reg1 + reg2;
				3'b001 : out = reg1 - reg2;
			endcase
			estado = 3'd0;
			reg1 = 0;
			reg2 = 0;
			disponivel = 1;
		end
		
	end //always

endmodule


module ULA_muldiv(clock, A, B, inst, do, out, disponivel);
	
	input [15:0] A, B; //operandos
	input [2:0] inst; //parte da instrução que indica a operação a ser realizada
	input clock, do; //sinal vindo do RS, indicando que a operação pode ser feita(operandos corretos)
	output reg disponivel;
	output reg [15:0] out; //saída
	reg [2:0] estado;
	reg [15:0] reg1, reg2;

	initial begin
		disponivel = 1;
	end
	
	always @(posedge clock) begin
	
		out = 16'd0;
		
		if (do) begin // ler e armazenar os registradores
			reg1 = A;
			reg2 = B;
			estado = 3'd0;
			disponivel = 0;
		end
		
		estado = estado + 1;
		
		if (estado == 3) begin // 3 ciclos para mul
			if (inst == 3'b010) begin
				out = reg1 * reg2; // mul
				estado = 3'd0; // resetar
				reg1 = 0;
				reg2 = 0;
				disponivel = 1;
			end
		end
		else if (estado == 4) begin // 4 ciclos para div
			if (inst == 3'b011) begin
				out = reg1 / reg2; // div
				estado = 3'd0; // resetar
				reg1 = 0;
				reg2 = 0;
				disponivel = 1;
			end
		end
	end //always
 
endmodule
 
  
module Registers_Bank(label_as, label_md, req1_as, req2_as, req1_md, req2_md, cdb, clock, write, regout1_as, regout2_as, regout1_md, regout2_md);
	input [2:0] req1_as, req2_as, req1_md, req2_md;
	input [15:0] cdb, label_as, label_md;
	input write;
	input clock;
	
	reg [15:0] regs [7:0];
	
	output reg [15:0] regout1_as, regout2_as, regout1_md, regout2_md;
	
	reg [4:0] i;
	
	initial begin
		regs[0] = 16'd0;
		regs[1] = 16'd0;
		regs[2] = 16'd0;
		regs[3] = 16'd0;
		regs[4] = 16'd0;
		regs[5] = 16'd0;
		regs[6] = 16'd0;
		regs[7] = 16'd0;
	end

	always@(posedge clock) begin
		if(write != 1) begin // quando as estaçoes de reserva pedem os registradores
			regout1_as = regs[req1_as];
			regout2_as = regs[req2_as];
			regout1_md = regs[req1_md];
			regout2_md = regs[req2_md];
		end
		else begin
			for (i = 0; i <= 7; i = i + 1) begin
				if(regs[i][15:13] == cdb[15:13]) begin
					regs[i] = cdb;
					regs[i][15:13] = 3'b000;
				end
			end
		end
		if(label_as != 16'd0) begin // se receber sinal de label, atualiza o registrador com a label
			for (i = 0; i <= 7; i = i + 1) begin
				if(regs[i][15:13] == label_as[15:13]) begin
					regs[i] = label_as;
				end
			end
		end
		if(label_md != 16'd0) begin // se receber sinal de label, atualiza o registrador com a label
			for (i = 0; i <= 7; i = i + 1) begin
				if (regs[i][15:13] == label_md[15:13]) begin
					regs[i] = label_md;
				end
			end
		end
	end

endmodule

module CDB_Arbriter(clock, add_sub, mul_div, write, cdb);
	input clock;
	input [15:0] add_sub, mul_div;
	reg [15:0] temp;
	output reg [15:0] cdb;
	output reg write;
	
	always@(posedge clock) begin
		write = 0;
		cdb = 16'd0;
		if(temp != 16'd0) begin // se o buffer estiver cheio, primeiramente libera;
			cdb = temp;
			temp = 16'd0;
			write = 1;
		end
		else begin
			if(add_sub != 16'd0 & mul_div != 16'd0) begin // se tiverem dois dados na fila, libeira primeiro mul_div e coloca o add_sub no buffer
				cdb = mul_div;
				temp = add_sub;
				write = 1;
			end
			else if(add_sub != 16'd0 & mul_div == 16'd0) begin // se tiver add_sub e não tiver mul_div, manda add_sub
				cdb = add_sub;
				write = 1;
			end
			else if(add_sub == 16'd0 & mul_div != 16'd0) begin // se tiver mul_div e não tiver add_sub, manda mul_div
				cdb = mul_div;
				write = 1;
			end
		end
	end
endmodule
 
module Reservation_Station(clock, cdb, tipo, instr, disp, ula_disp, entrada_reg1, entrada_reg2, req1, req2, disponivel, label_out, instr_out, out1, out2, do);
	input tipo, clock, ula_disp; // 0 = add/sub, 1 = mul/div
	input [1:0] disp;
	input [15:0] instr, entrada_reg1, entrada_reg2, cdb;
	
	output reg do;
	output reg [2:0] req1, req2;
	output reg [1:0] disponivel;
	output reg [15:0] out1, out2, label_out, instr_out;
	
	reg [15:0] reserva [2:0];
	
	reg [2:0] op, reg1, reg2, reg3;

	reg [15:0] vj [2:0];
	reg [15:0] vk [2:0];

	reg [3:0] i;
	
	initial begin

	end
	
	always@(posedge clock) begin
		do = 0;
		label_out = 16'd0;
		if(disp != 0) begin // colocando na reserva
			reserva[disp-1][15] = 1; // busy
			reserva[disp-1][14:12] = instr[15:13]; // instrucao opcode
			reserva[disp-1][11:9] = instr[12:10]; // registrador de escrita
			reserva[disp-1][8:6] = instr[9:7]; // registrador 1
			reserva[disp-1][5:3] = instr[6:4]; // registrador 2
			reserva[disp-1][2] = 0; // estado
			// pedindo os registradores
			req1 = instr[9:7];
			req2 = instr[6:4];
			//
		end


		// mudando os estados
		for (i = 0; i <= 2; i = i + 1) begin 
			reserva[i][2:1] = reserva[i][2:1] + 1;
		end
		// estado 1: recebe instruçao, quebra, coloca na RS, e pede registradores;
		// estado 2: recebe registradores
		// estado 3+: tenta executar

		// se estiver no estado 2, recebe os registradores em vj e vk
		for (i = 0; i <= 1; i = i + 1) begin
			if(reserva[i][2:1] == 2'b10) begin // estado = 2
				vj[i] = entrada_reg1;
				vk[i] = entrada_reg2;
				
				//escrever no banco de dados a tag do registrador que escreveremos
				if(tipo == 0) begin // add_sub
					if(i == 0)
						label_out = 16'b0010000000000000; // label = 1 (ADD_SUB1)
					else
						label_out = 16'b0100000000000000; // label = 2 (ADD_SUB2)
				end
				else begin // mul_div
					if(i == 0)
						label_out = 16'b0110000000000000; // label = 3 (MUL_DIV1)
					else
						label_out = 16'b1000000000000000; // label = 4 (MUL_DIV2)
				end
				//
			end
		end
		//
		
		// ver se no cdb existe um dado com a label que preciso
		for (i = 0; i <= 2; i = i + 1) begin
		
			if(reserva[i][2:1] == 2'b01) begin // estado
			end
			else begin
				if(reserva[i][15] == 0) begin // busy
				end
				else begin
					if (cdb[15:13] == reserva[i][8:6]) begin
						vj[i] = cdb;
						vj[i][15:13] = 3'b000;
					end

					if (cdb[15:13] == reserva[i][5:3]) begin
						vk[i] = cdb;
						vk[i][15:13] = 3'b000;
					end
				end
			end
		end
		//
		
		// testar se não tem label nos registradores
		// se sim, mandar para a ula
		// se nao, espera
		for (i= 0 ; i <= 2; i=i+1) begin

			if(reserva[i][2:1] != 2'b11) begin // se estado não for 3
			end
			else begin
				if(reserva[i][15] == 0) begin // busy
				end
				else begin
					if(vj[i][15:13] == 3'b000 & vk[i][15:13] == 3'b000) begin
						if(ula_disp) begin // se a ula estiver disponivel
							do = 1;
							out1 = vj[i];
							out2 = vk[i];
							label_out = reserva[i][11:9]; // avisando qual reg será escrito (pelo label)
							instr_out = reserva[i][14:12]; // avisando qual será a operação pelo opcode
							reserva[i] = 16'd0; // limpando o slot da reserva
							vk[i] = 16'd0;
							vj[i] = 16'd0;
						end
					end
				end
			end
		end
		
		disponivel = 2'b00;
		for (i = 0; i <= 2; i = i + 1) begin
			if (reserva[i][15] == 0) begin
				disponivel = i + 1;
			end
		end
	
	end
	
endmodule
 