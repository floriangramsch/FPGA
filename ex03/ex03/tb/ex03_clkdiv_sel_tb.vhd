--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex03_clkdiv_sel_tb is
generic (
    g_CLK_MHZ : real := 100.0--;
);
end entity;

architecture arc of ex03_clkdiv_sel_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal clkdiv_clk : std_logic;
    signal clkdiv_sel : std_logic_vector(3 downto 0) := (others => '0');

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_clkdiv_sel : entity work.ex03_clkdiv_sel
    port map (
        o_clk => clkdiv_clk,
        i_sel => clkdiv_sel,
        i_reset_n => reset_n,
        i_clk => clk--,
    );

    process
        variable t0, t1 : time;
    begin
        wait until ( reset_n = '1' );

        clkdiv_sel <= "0000";
        wait until rising_edge(clkdiv_clk);
        t0 := now;
        wait until rising_edge(clkdiv_clk);
        t1 := now;
        assert ( abs((t1 - t0) / 2 - 1000 ns / g_CLK_MHZ) < 10 ps ) severity error;
        wait until falling_edge(clkdiv_clk);

        clkdiv_sel <= "0001";
        wait until rising_edge(clkdiv_clk);
        t0 := now;
        wait until rising_edge(clkdiv_clk);
        t1 := now;
        assert ( abs((t1 - t0) / 4 - 1000 ns / g_CLK_MHZ) < 10 ps ) severity error;
        wait until falling_edge(clkdiv_clk);

        clkdiv_sel <= "0010";
        wait until rising_edge(clkdiv_clk);
        t0 := now;
        wait until rising_edge(clkdiv_clk);
        t1 := now;
        assert ( abs((t1 - t0) / 6 - 1000 ns / g_CLK_MHZ) < 10 ps ) severity error;
        wait until falling_edge(clkdiv_clk);

        clkdiv_sel <= "1001";
        wait until rising_edge(clkdiv_clk);
        t0 := now;
        wait until rising_edge(clkdiv_clk);
        t1 := now;
        assert ( abs((t1 - t0) / 32 - 1000 ns / g_CLK_MHZ) < 10 ps ) severity error;
        wait until falling_edge(clkdiv_clk);

        clkdiv_sel <= "1100";
        wait until rising_edge(clkdiv_clk);
        t0 := now;
        wait until rising_edge(clkdiv_clk);
        t1 := now;
        assert ( abs((t1 - t0) / 56 - 1000 ns / g_CLK_MHZ) < 10 ps ) severity error;
        wait until falling_edge(clkdiv_clk);

        clkdiv_sel <= "1111";
        wait until rising_edge(clkdiv_clk);
        t0 := now;
        wait until rising_edge(clkdiv_clk);
        t1 := now;
        assert ( abs((t1 - t0) / 80 - 1000 ns / g_CLK_MHZ) < 10 ps ) severity error;
        wait until falling_edge(clkdiv_clk);

        report "Simulation DONE";
        wait;
    end process;

end architecture;
