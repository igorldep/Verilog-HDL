library verilog;
use verilog.vl_types.all;
entity mux_21 is
    port(
        y               : out    vl_logic;
        i0              : in     vl_logic;
        i1              : in     vl_logic;
        sel             : in     vl_logic
    );
end mux_21;
