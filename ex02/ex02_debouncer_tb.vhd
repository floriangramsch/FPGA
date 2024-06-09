--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex02_debouncer_tb is
generic (
    g_CLK_MHZ : real := 100.0--;
);
end entity;

architecture arch of ex02_debouncer_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal d : std_logic := '0';
    signal q : std_logic;

    -- test vectors:
    -- each bit of `ds` is an input at clock cycle `i`
    constant ds : std_logic_vector := "000111011110111110000000101111111111111101000000000001010000";
    -- each bit of `qs` is an expected output at clock cycle `i`
    constant qs : std_logic_vector := "000000000000000001111100000000011111111111111110000000000000";
    --                   cycle (time): 012345678901234567890123456789012345678901234567890123456789

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    -- adjust time period to 4 clock cycles
    e_debouncer : entity work.ex02_debouncer
    generic map (
        g_N => 4--,
    )
    port map (
        i_d => d,
        o_q => q,
        i_reset_n => reset_n,
        i_clk => clk--,
    );

    process
    begin
        for i in ds'range loop
            -- set input from `ds` test vector
            d <= ds(i);
            wait until falling_edge(clk);
            -- check output to `qs` test vector
            assert ( q = qs(i) ) report "error at clock cycle " & integer'image(i) severity warning;
            wait until rising_edge(clk);
        end loop;

        report "Simulation DONE";
        wait;
    end process;

end architecture;
