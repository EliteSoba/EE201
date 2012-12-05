library verilog;
use verilog.vl_types.all;
entity main_calc_cu is
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        dataInBus       : in     vl_logic_vector(7 downto 0);
        btl             : in     vl_logic;
        btr             : in     vl_logic;
        btd             : in     vl_logic;
        btu             : in     vl_logic;
        btc             : in     vl_logic;
        sel1            : out    vl_logic;
        sel2            : out    vl_logic;
        sel3            : out    vl_logic;
        sel4            : out    vl_logic;
        sel5            : out    vl_logic;
        sel6            : out    vl_logic;
        sel7            : out    vl_logic;
        add             : out    vl_logic;
        sub             : out    vl_logic;
        div             : out    vl_logic;
        mult            : out    vl_logic;
        gcd             : out    vl_logic;
        isprime         : out    vl_logic;
        sqrt            : out    vl_logic;
        done            : out    vl_logic;
        num1_out        : out    vl_logic_vector(7 downto 0);
        num2_out        : out    vl_logic_vector(7 downto 0);
        textOut         : out    vl_logic_vector(248 downto 0)
    );
end main_calc_cu;
