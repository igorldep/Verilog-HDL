module pratica2 (SW, Resetn, Run, HEX3, HEX2, HEX1, HEX0, HEX5, HEX7);

	input Resetn, Run;
	input [17:0]SW;

	wire Done;
	output [6:0] HEX3, HEX2, HEX1, HEX0, HEX5, HEX7;
	wire [15:0] Bus;
	wire MClock, PClock;
	assign MClock = SW[17];
	assign PClock = SW[0];
	wire [15:0] data;
	wire [3:0] out_counter;
	wire Resetn2;
	assign Resetn2 = 0;
	wire [1:0] countee;

	instr_counter ic (MClock, Resetn2, out_counter);
	
	ROM mem(out_counter, MClock, data);

	processador corei10(PClock, data, Run, Resetn2, Done, Bus, countee);
	reg [3:0] c, d, u, m;
	initial begin
		m <= 7'b0000000;
		c <= 7'b0000000;
		d <= 7'b0000000;
		u <= 7'b0000000;
	end
	always @(*) begin
		
		if(Done) begin
			m <= Bus / 1000;
			c <= (Bus % 1000)/ 100;
			d <= (Bus % 100) / 10;
			u <= Bus % 10;
		end
	end
	display d0(m, HEX3);
	display d1(c, HEX2);
	display d2(d, HEX1);
	display d3(u, HEX0);
	display d5(out_counter, HEX5);
	display d7(countee, HEX7);
endmodule



module processador(clock, DIN, run, resetn, done, bus, countee);

	input [15:0]DIN;
	input clock, run, resetn;
	output reg [1:0] countee;
	wire [1:0] count;
	wire [2:0] Rout, Iout, r1out, r2out, addsub;
	wire [15:0] R [7:0];
	wire [15:0] A, G, addout;
	wire [7:0] Rin;
	wire Ain, Gin, clear, Gout, DINout, IRin;

	output done;
	output [15:0] bus;

	counter c(clock, done | resetn, count);

	regs r0(bus, clock, Rin[0], R[0]);
	regs r1(bus, clock, Rin[1], R[1]);
	regs r2(bus, clock, Rin[2], R[2]);
	regs r3(bus, clock, Rin[3], R[3]);
	regs r4(bus, clock, Rin[4], R[4]);
	regs r5(bus, clock, Rin[5], R[5]);
	regs r6(bus, clock, Rin[6], R[6]);
	regs r7(bus, clock, Rin[7], R[7]);
	
	regs a(bus, clock, Ain, A);
	regs g(addout, clock, Gin, G);
	
	//A: saída do reg a; G: saída do reg g; addout: saída da ULA
	addsub ula(A, bus, addsub, addout);

	mux m(DIN, R[0], R[1], R[2], R[3], R[4], R[5], R[6], R[7], G, DINout, Rout, Gout, bus);

	//Casar variáveis dos módulos abaixo com o top level
	IR ir(DIN, IRin, clock, Iout, r1out, r2out);
	control_unit control(count, Iout, r1out, r2out, resetn, Rin, Rout, Gout, addsub, Ain, Gin, done, DINout, IRin, clear);
	
	always @(*) begin
		countee = count;
	end

endmodule

module mux(DIN, R0, R1, R2, R3, R4, R5, R6, R7, G, DINout, Rout, Gout, bus);

	input [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	input [15:0] DIN, G;
	input [2:0] Rout;
	input DINout, Gout;
	output reg [15:0] bus;

	always @(*) begin
		bus = 0;
		if (DINout == 1) begin
			bus = DIN;
		end
		else begin
			if (Gout == 1) begin
				bus = G;
			end
			else begin
				case (Rout)
					3'b000	 : bus = R0;
					3'b001	 : bus = R1;
					3'b010	 : bus = R2;
					3'b011	 : bus = R3;
					3'b100	 : bus = R4;
					3'b101	 : bus = R5;
					3'b110	 : bus = R6;
					3'b111	 : bus = R7;
					default	 : bus = 0;
				endcase
			end // gout == 1
		end // dinout == 1
	end //always
endmodule


module addsub(A, bus, ctrl, out);

	input [15:0] A, bus;
	input [2:0] ctrl;
	output reg [15:0] out;

	always @(*) begin
		case(ctrl)
			3'b000 : out = A + bus;
			3'b001 : out = A - bus;
			3'b010 : out = A | bus;
			3'b011 :
				begin
					if(A < bus) begin
						out = 16'b0000000000000001;
					end
					else begin
						out = 16'b0000000000000000;
					end
				end
			3'b100 : out = A << bus;
			3'b101 : out = A >> bus;
		endcase
	end //always

endmodule

module regs(bus, clock, in, out);
	input clock, in;
	input [15:0] bus;
	output reg [15:0] out;
	
	reg [15:0] self;
	
	initial begin
		self = 16'b0000000000000010;
	end

	always @(posedge clock) begin
		if (in == 1) begin
			self = bus;
		end
		out = self;
	end

endmodule

module IR(DIN, IRin, clock, iout, r1out, r2out);
	input [15:0] DIN;
	input IRin, clock;
	
	output reg [2:0] iout, r1out, r2out;
	
	reg [8:0] ireg;
	
	always @(posedge clock) begin
		if(IRin == 1) begin
			ireg = DIN[15:7];
		end
		iout = ireg[8:6];
		r1out = ireg[5:3];
		r2out = ireg[2:0];
	end

endmodule

module counter(Clock, Clear, Q);
	input Clear, Clock;
	output [1:0] Q;
	reg [1:0] Q;
	always @(posedge Clock) begin
		if(Q == 2'b11)
			Q <= 2'b0;
		else begin
			if (Clear)
				Q <= 2'b0;
			else
				Q <= Q + 1'b1;
		end
	end
endmodule

module control_unit(count, instr, r1, r2, Resetn, Rin, Rout, Gout, AddSub, Ain, Gin, Done, DINout, IRin, Clear);

	input [1:0] count;
	input [2:0] instr, r1, r2;
	input Resetn;
	
	output reg Gout, Ain, Gin, Done, IRin, Clear, DINout;
	output reg [7:0] Rin;
	output reg [2:0] Rout, AddSub;
	
	always @(*) begin
		Ain = 0;
		Gin = 0;
		Gout = 0;
		AddSub = 3'b000;
		Done = 0;
		Clear = 0;
		IRin = 0;
		DINout = 0;
		Rout = 3'b000;
		Rin = 8'b00000000;
		
		/*if(Resetn == 1) begin
			Clear = 1;
			Done  = 1;
		end*/

		case(instr)
			3'b110 : begin //mov
				case(count)
					2'b00 : begin
						IRin = 1;
					end
					2'b01 : begin
						//IRin = 0;
						//r1 = r2;
						Rout = r2;
						Rin[r1] = 1; //ou r1?
						Done = 1;
						Clear = 1;
					end
				endcase
			end

			3'b111: begin //movi
				case(count)
					2'b00 : begin
						IRin = 1;
					end
					2'b01 : begin //2 ciclos de ck
						//IRin = 0;
						//r1 = D;
						DINout = 1; //?
						Rin[r1] = 1;
						Done = 1;
						Clear = 1;
					end
				endcase

			end
			
			default : begin // outras
				case(count)
					2'b00 : begin
						IRin = 1;
					end
					2'b01 : begin
						//IRin = 0;
						Rout = r1;
						Ain = 1;
					end
					2'b10 : begin
						Rout = r2;
						AddSub = instr;
						Gin = 1;
					end
					2'b11 : begin
						Gout = 1;
						Rin[r1] = 1; //funfa?
						Done = 1;
						Clear = 1;
					end
				endcase
			end
			//3'b010 : ;
		endcase
	end
endmodule

module instr_counter(clock, resetn, out);
	input clock, resetn;
	output reg [3:0] out;
	
	reg [3:0] count;

	initial begin
		count = 4'b0000;
	end

	always @(posedge clock) begin
		if(resetn == 1) begin
			count = 4'b0000;
		end
		count = count + 1;
		out = count;
	end

endmodule


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
