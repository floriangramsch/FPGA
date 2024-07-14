library ieee;
use ieee.std_logic_1164.all;
-- include the package ieee.numeric_std
use ieee.numeric_std.all;

-- clock divider with selector
entity ex03_clkdiv is
    generic (
    N : positive := 500000--;
);
port (
    o_clk       : out   std_logic;
    i_sel       : in    std_logic_vector(3 downto 0) := (others => '0');
    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of ex03_clkdiv is

    -- define in the architecture a new data type
    type array_positive_t is array (natural range <>) of positive;
    -- define a constant of this data type to store the needed divider values
    constant C_DIVIDER_VALUES : array_positive_t(0 to 15) := (
        -- put a comma separated list of 16 divider values
        -- in the last parenthesis for achieving the requested clock periods
        1, 2, 3, 4, 5, 6, 7, 8, 12, 16, 20, 24, 28, 32, 36, 40
    );

    -- define a signal sel_uint of the data type natural,
    -- which will hold the unsigned integer representation of the input port i_sel
    signal sel_uint : natural range C_DIVIDER_VALUES'range;

    signal clk : std_logic := '0';
    signal cnt : integer range 0 to C_DIVIDER_VALUES(C_DIVIDER_VALUES'right)-1 := 0;

begin

    -- convert the std_logic_vector i_sel to the natural sel_uint
    sel_uint <= to_integer(unsigned(i_sel));

    o_clk <= clk;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        clk <= '0';
        cnt <= 0;
        --
    elsif rising_edge(i_clk) then
        -- replace N in the comparison in the process with C_DIVIDER_VALUES(sel_uint)
        if ( cnt >= C_DIVIDER_VALUES(sel_uint)-1 ) then
--        if ( cnt = 0 ) then
            clk <= not clk;
            cnt <= 0;
--            cnt <= C_DIVIDER_VALUES(sel_uint)-1;
        else
            cnt <= cnt + 1;
--            cnt <= cnt - 1;
        end if;
        --
    end if;
    end process;

end architecture;
