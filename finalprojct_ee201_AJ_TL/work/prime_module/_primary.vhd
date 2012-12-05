library verilog;
use verilog.vl_types.all;
entity prime_module is
    port(
        Clk             : in     vl_logic;
        data_in         : in     vl_logic_vector(7 downto 0);
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        textOut         : out    vl_logic_vector(256 downto 0);
        \next\          : in     vl_logic;
        done            : out    vl_logic
    );
end prime_module;
