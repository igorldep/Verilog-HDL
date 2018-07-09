module mux_21(y, i0, i1, sel);

output reg y;
input i0, i1, sel;

always@(*)
begin
	y = (((~sel) & i0) | (sel & (i1)));
	
end

endmodule