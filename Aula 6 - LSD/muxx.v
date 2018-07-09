module muxx(i0, i1, sel, s);

input i0, i1, sel;
output reg s;

always@(*)
begin
	s = (((~sel) & i0) | (sel & (i1)));
end

endmodule
