library verilog;
use verilog.vl_types.all;
entity Coprocessador is
    port(
        clock_50MHz     : in     vl_logic;
        q               : in     vl_logic_vector(7 downto 0);
        enable_start    : in     vl_logic;
        pixel           : out    vl_logic;
        rdaddress       : out    vl_logic_vector(11 downto 0);
        wraddress       : out    vl_logic_vector(11 downto 0);
        enable          : out    vl_logic;
        ACABOU          : out    vl_logic
    );
end Coprocessador;
