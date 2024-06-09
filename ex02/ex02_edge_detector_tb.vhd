--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex02_edge_detector_tb is
generic (
    g_CLK_MHZ : real := 10.0--;
);
end entity;

architecture arch of ex02_edge_detector_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal d, q : std_logic := '0';

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_edge_detector : entity work.ex02_edge_detector
    port map (
        i_d => d,
        o_q => q,
        i_clk => clk--,
    );

    -- values are changed on rising edge of the clock
    -- and are checked on falling edge
    process
    begin
        -- wait until out of reset
        wait until ( reset_n = '1' );

        -- wait for N clock cycles
        for i in 0 to 2 loop
            wait until falling_edge(clk);
            -- check that output is '0'
            assert ( q = '0' ) report "error" severity error;
        end loop;

        wait until rising_edge(clk);
        -- toggle input to '1'
        d <= '1';

        wait until falling_edge(clk);
        -- observe output pulse on rising edge of input
        assert ( q = '1' ) report "error" severity error;

        wait until falling_edge(clk);
        -- the pulse should be 1 clock cycle long
        assert ( q = '0' ) report "error" severity error;

        wait until rising_edge(clk);
        -- toggle input '0'
        d <= '0';

        wait until falling_edge(clk);
        -- observe no pulse on falling edge of input
        assert ( q = '0' ) report "error" severity error;

        report "Simulation DONE";
        wait;
    end process;

end architecture;
