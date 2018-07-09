library verilog;
use verilog.vl_types.all;
entity muxx is
    port(
        i0              : in     vl_logic;
        i1              : in     vl_logic;
        sel             : in     vl_logic;
        s               : out    vl_logic
    );
end muxx;
