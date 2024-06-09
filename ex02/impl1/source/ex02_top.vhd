--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex02_top is
port (
    -- 8 light diods (active low)
    o_led_n     : out   std_logic_vector(7 downto 0) := (others => '1');
    -- 4 switches
    i_sw_n      : in    std_logic_vector(3 downto 0);

    -- external clock (12 MHz)
    i_clk       : in    std_logic;
    -- reset button (active low)
    i_reset_n   : in    std_logic--;
);
end entity;

architecture arch of ex02_top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

begin

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    e_edge_detector : entity work.edge_detector
    port map (
        i_d => sw(1),
        o_q => led(1),
        i_clk => i_clk--,
    );

    e_debouncer : entity work.ex02_debouncer
    generic map (
        g_N => 10000000--,
    )
    port map (
        i_d => sw(0),
        o_q => led(0),
        i_reset_n => i_reset_n,
        i_clk => i_clk--,
    );

end architecture;
