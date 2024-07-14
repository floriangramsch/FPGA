library ieee;
use ieee.std_logic_1164.all;

-- clock divider
-- Period(o_clk) = 2 * N * Period(i_clk)
entity ex03_clkdivv is
generic (
    N : positive := 500000--;
);
port (
    o_clk       : out   std_logic;
    i_reset_n   : in    std_logic := '1';
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of ex03_clkdivv is

    signal clk : std_logic := '0';
    signal cnt : integer range 0 to N-1 := 0;

begin

    o_clk <= clk;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        clk <= '0';
        cnt <= 0;
        --
    elsif rising_edge(i_clk) then
        if ( cnt = N-1 ) then
            clk <= not clk;
            cnt <= 0;
        else
            cnt <= cnt + 1;
        end if;
        --
    end if;
    end process;

end architecture;
