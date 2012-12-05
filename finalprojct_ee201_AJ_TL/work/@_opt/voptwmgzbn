library verilog;
use verilog.vl_types.all;
entity ee201_debouncer is
    generic(
        N_dc            : integer := 5
    );
    port(
        CLK             : in     vl_logic;
        RESET           : in     vl_logic;
        PB              : in     vl_logic;
        DPB             : out    vl_logic;
        SCEN            : out    vl_logic;
        MCEN            : out    vl_logic;
        CCEN            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N_dc : constant is 1;
end ee201_debouncer;
