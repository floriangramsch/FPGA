--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex01_top_tb is
generic (
    g_CLK_MHZ : real := 12.0--;
);
end entity;

architecture arch of ex01_top_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal led_n : std_logic_vector(7 downto 0);
    signal sw_n : std_logic_vector(3 downto 0);

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_top : entity work.ex01_top_adder
    port map (
        o_led_n => led_n,
        i_sw_n => sw_n,
        i_clk => clk,
        i_reset_n => reset_n--,
    );

    process
    begin
        -- reset switches
        sw_n <= (others => '1');

        -- wait until out of reset
        wait until ( reset_n = '1' );

        wait for 100 ns;
        -- flip switch 0
        sw_n <= not "0000";
        wait for 10 ns;
        assert ( not led_n(2 downto 0) = "000" ) report "E [TB] @cycle = " & integer'image(cycle) severity error;

        wait for 100 ns;
        -- flip switch 1
        sw_n <= not "1001";
        wait for 10 ns;
        assert ( not led_n(2 downto 0) = "011" ) report "E [TB] @cycle = " & integer'image(cycle) severity error;

        wait for 100 ns;
        -- flip switch 2
        sw_n <= not "1010";
        wait for 10 ns;
        assert ( not led_n(2 downto 0) = "100" ) report "E [TB] @cycle = " & integer'image(cycle) severity error;

        wait for 100 ns;
        -- flip switch 3
        sw_n <= not "1111";
        wait for 10 ns;
        assert ( not led_n(2 downto 0) = "110" ) report "E [TB] expected 110 @cycle = " & integer'image(cycle) severity error;

        wait for 100 ns;
        wait;
    end process;

end architecture;
