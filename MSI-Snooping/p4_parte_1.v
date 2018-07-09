module p4_parte_1(SW, LEDR, HEX6, HEX7);
	input [17:0] SW;
	output [6:0] HEX6, HEX7;
	output [17:0] LEDR;
	reg readwrite, thread, hitmiss;
	reg write_miss, read_miss, invalidate, wb_block, wb_cache, mem_abort;
	reg [1:0] thread0, thread1; // invalid = 0, shared = 1, exclusive = 2
	
	/* 
		SW[0] = clock
		SW[15] = read (0), write (1)
		SW[16] = miss (0), hit (1)
		SW[17] = thread0 (0), thread1 (1)
 	*/
	
	assign LEDR[17] = wb_block; // Write back block
	assign LEDR[16] = wb_cache; // Write back block cache
	assign LEDR[15] = mem_abort; // Abort memory access
	assign LEDR[2] = write_miss; // Place write miss on bus
	assign LEDR[1] = read_miss; // Place read miss on bus
	assign LEDR[0] = invalidate; // Place invalidate on bus

	initial begin
		thread0 = 2'd0;
		thread1 = 2'd0;
	end
		
	stateDisplay t0(thread0, HEX7);
	stateDisplay t1(thread1, HEX6);

	always @(posedge SW[0]) begin
		thread = SW[17];
		hitmiss = SW[16];
		readwrite = SW[15];
		write_miss = 0;
		read_miss = 0;
		invalidate = 0;
		wb_block = 0;
		wb_cache = 0;
		mem_abort = 0;
		case (thread) // thread principal
			1'b0: // thread0
				begin
					if (readwrite) begin // write
						if(hitmiss) begin // hit
							case (thread0) // estados
								2'd0 : // invalid
									begin
										write_miss = 1;//Place write miss on bus
										thread0 = 2'b10; // > EXCLUSIVE
									end
								2'd1 : // shared
									begin
										invalidate = 1; //Place invalidate on bus
										thread0 = 2'b10; // > EXCLUSIVE
									end
								2'd2 : // exclusivo
									begin
										thread0 = 2'b10; // > EXCLUSIVE (continua)
									end
							endcase
						end
						else begin // miss
							case (thread0) // estados
								2'd0 : // invalid
									begin
										write_miss = 1; //Place write miss on bus
										thread0 = 2'b10; // > EXCLUSIVE
									end
								2'd1 : // shared
									begin
										write_miss = 1; //Place write miss on bus
										thread0 = 2'b10; // > EXCLUSIVE
									end
								2'd2 : // exclusivo
									begin
										wb_cache = 1; // Write-back cache block
										write_miss = 1; // Place write miss on bus
										thread0 = 2'b10; // > EXCLUSIVE (continua)
									end
							endcase
						end
					end
					else begin // read
						if(hitmiss) begin // hit
							case  (thread0) // estados
								2'd0 : // invalid
									begin
										read_miss = 1; //Place read miss on bus
										thread0 = 2'b01; // > SHARED
									end
								2'd1 : // shared
									begin
										thread0 = 2'b01; // > SHARED (continua)
									end
								2'd2 : // exclusivo
									begin
										thread0 = 2'b10; // > EXCLUSIVE (continua)
									end
							endcase
						end
						else begin // miss
							case (thread0) // estados
								2'd0 : // invalid
									begin
										read_miss = 1; //Place read miss on bus
										thread0 = 2'b01; // > SHARED
									end
								2'd1 : // shared
									begin
										read_miss = 1; //Place read miss on bus
										thread0 = 2'b01; // > SHARED
									end
								2'd2 : // exclusivo
									begin
										wb_block = 1; // Write-back block
										thread0 = 2'b01; // > SHARED
									end
							endcase
						end
					end
				end
			1'b1: // thread1
				begin
					if (readwrite) begin // write
						if(hitmiss) begin // hit
							case (thread1) // estados
								2'd0 : // invalid
									begin
										write_miss = 1;//Place write miss on bus
										thread1 = 2'b10; // > EXCLUSIVE
									end
								2'd1 : // shared
									begin
										invalidate = 1; //Place invalidate on bus
										thread1 = 2'b10; // > EXCLUSIVE
									end
								2'd2 : // exclusivo
									begin
										thread1 = 2'b10; // > EXCLUSIVE (continua)
									end
							endcase
						end
						else begin // miss
							case (thread1) // estados
								2'd0 : // invalid
									begin
										write_miss = 1; //Place write miss on bus
										thread1 = 2'b10; // > EXCLUSIVE
									end
								2'd1 : // shared
									begin
										write_miss = 1; //Place write miss on bus
										thread1 = 2'b10; // > EXCLUSIVE
									end
								2'd2 : // exclusivo
									begin
										wb_cache = 1; // Write-back cache block
										write_miss = 1; // Place write miss on bus
										thread1 = 2'b10; // > EXCLUSIVE (continua)
									end
							endcase
						end
					end
					else begin // read
						if(hitmiss) begin // hit
							case (thread1) // estados
								2'd0 : // invalid
									begin
										read_miss = 1; //Place read miss on bus
										thread1 = 2'b01; // > SHARED
									end
								2'd1 : // shared
									begin
										thread1 = 2'b01; // > SHARED (continua)
									end
								2'd2 : // exclusivo
									begin
										thread1 = 2'b10; // > EXCLUSIVE (continua)
									end
							endcase
						end
						else begin // miss
							case (thread1) // estados
								2'd0 : // invalid
									begin
										read_miss = 1; //Place read miss on bus
										thread1 = 2'b01; // > SHARED
									end
								2'd1 : // shared
									begin
										read_miss = 1; //Place read miss on bus
										thread1 = 2'b01; // > SHARED
									end
								2'd2 : // exclusivo
									begin
										wb_block = 1; // Write-back block
										thread1 = 2'b01; // > SHARED
									end
							endcase
						end
					end
				end
		endcase

		case (thread) // thread secundária
			1'b0 : 
				begin
					case (thread1)
						2'd0 : thread1 = 2'd0; // invalid (não acontece nada)
						2'd1 : // shared
							begin
								if (read_miss) begin // Place read miss on bus
									thread1 = 2'd1; // > SHARED (continua)
								end
								else begin
									if (write_miss || invalidate) begin // Place write miss on bus or Place invalidate on bus
										thread1 = 2'd0; // > INVALID
									end
								end
							end
						2'd2 : // exclusive
							begin
								if (read_miss) begin // Place read miss on bus
									wb_block = 1;
									mem_abort = 1;
									thread1 = 2'd1; // > SHARED
								end
								else begin
									if (write_miss) begin // Place write miss on bus
										wb_block = 1;
										mem_abort = 1;
										thread1 = 2'd0; // > INVALID
									end
								end
							end
					endcase
				end
			1'b1 :
				begin
					case (thread0)
						2'd0 : thread0 = 2'd0; // invalid (não acontece nada)
						2'd1 : // shared
							begin
								if (read_miss) begin // Place read miss on bus
									thread0 = 2'd1; // > SHARED (continua)
								end
								else begin
									if (write_miss || invalidate) begin // Place write miss on bus or Place invalidate on bus
										thread0 = 2'd0; // > INVALID
									end
								end
							end
						2'd2 : // exclusive
							begin
								if (read_miss) begin // Place read miss on bus
									wb_block = 1;
									mem_abort = 1;
									thread0 = 2'd1; // > SHARED
								end
								else begin
									if (write_miss) begin // Place write miss on bus
										wb_block = 1;
										mem_abort = 1;
										thread0 = 2'd0; // > INVALID
									end
								end
							end
					endcase
				end
		endcase
	end
endmodule

module stateDisplay(value, hex);
	input [1:0] value;
	output reg [6:0] hex;
	
	always @(value) begin
		case (value)
			2'b00		: hex = 7'b1111001;
			2'b01		: hex = 7'b0010010;
			2'b10		: hex = 7'b0000110;
			default	: hex = 7'b1111111;
		endcase
	end

endmodule
/* 

começam os dois invalid

thread1 = HEX7 (S = shared, E = exclusive, I = invalid)
thread0 = HEX6 (S = shared, E = exclusive, I = invalid)
[] = thread1 (1), thread0 (0)  
[] = hit (1) ou miss (0)
[] = write (1) ou read (0)

COMANDOS:
	CPU read
		INVALID: Place read miss on bus -> SHARED
	CPU write
		INVALID: Place write miss on bus -> EXCLUSIVE
	CPU read hit
		SHARED: -> SHARED (continua)
		EXCLUSIVE: -> EXCLUSIVE (continua)
	CPU write hit
		SHARED: Place invalidate on bus -> EXCLUSIVE
		EXCLUSIVE: -> EXCLUSIVE (continua)
	CPU read miss
		SHARED: Place read miss on bus -> SHARED (continua)
		EXCLUSIVE: Write-back block -> SHARED
	CPU write miss
		SHARED: Place write miss on bus -> EXCLUSIVE
		EXCLUSIVE: Write-back cache block, Place write miss on bus -> EXCLUSIVE (continua)
		
ESTADOS:
	Invalid
	Shared
	Exclusive

SINAIS:
	Place read miss on bus:
		SHARED: -> SHARED (continua)
		EXCLUSIVE: Write back block, abort memory access -> SHARED
		INVALID: irrelevante
	Place write miss on bus
		SHARED: -> INVALID
		EXCLUSIVE; Write-back block, abort memory access -> INVALID
		INVALID: irrelevante
	Place invalidate on bus
		SHARED: -> INVALID
		EXCLUSIVE: irrelevante, não acontece
		INVALID: irrelevante
		
	Write-back block (LEDR)
	Write-back cache block (LEDR)
	Abort memory access (LEDR)


thread1 | thread2 | print






*/
