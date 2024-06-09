--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex03_clkdiv_tb is
generic (
    g_CLK_MHZ : real := 100.0--;
);
end entity;

architecture arch of ex03_clkdiv_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    -- clock output from clkdiv (clock divider)
    signal clkdiv_clk : std_logic;

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    -- instantiate the clkdiv module
    -- and map the testbench signals to the top module ports
    e_clkdiv : entity work.ex03_clkdiv
    generic map (
        -- divide clock by factor 10
        N => 5--,
    )
    port map (
        o_clk => clkdiv_clk,
        i_reset_n => reset_n,
        i_clk => clk--,
    );

end architecture;
