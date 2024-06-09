--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex03_top_clkdiv is
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

architecture arch of ex03_top_clkdiv is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

    signal clkdiv_clk : std_logic;

begin

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    e_clkdiv : entity work.ex03_clkdiv
    generic map (
        -- divide by factor 2 * 10^6
        N => 1000000--,
    )
    port map (
        o_clk => clkdiv_clk,
        i_reset_n => i_reset_n,
        i_clk => i_clk--,
    );
    led(0) <= clkdiv_clk;

   e_clkdiv_sel : entity work.ex03_clkdiv_sel
   port map (
       o_clk => led(1),
       i_sel => sw,
       i_reset_n => i_reset_n,
       i_clk => clkdiv_clk--,
   );

end architecture;
