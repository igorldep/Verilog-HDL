library verilog;
use verilog.vl_types.all;
entity mux8 is
    port(
        i0              : in     vl_logic;
        i1              : in     vl_logic;
        i2              : in     vl_logic;
        i3              : in     vl_logic;
        sela            : in     vl_logic;
        selb            : in     vl_logic;
        s               : out    vl_logic
    );
end mux8;
