--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex00_top is
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

architecture arch of ex00_top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

    -- 32 bit counter
    signal cnt : std_logic_vector(31 downto 0);
--    signal cnt_next : std_logic_vector(31 downto 0);

begin

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    -- drive leds(3..0) from switches
    led(3 downto 1) <= sw(3 downto 1);

    e_and : entity work.ex00_and
    port map (
        i_a => sw(0),
        i_b => sw(1),
        o_and => led(0)--,
    );

--    cnt_next <= std_logic_vector(unsigned(cnt) + 1);

    -- clocked process
    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then -- async reset
        -- reset counter
        cnt <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        -- increment counter on each clock cycle
        cnt <= std_logic_vector(unsigned(cnt) + 1);
--        cnt <= cnt_next;
        --
    end if;
    end process;

    -- drive leds(7..4) with 4 bits of counter
    led(7 downto 4) <= cnt(23 downto 20);

end architecture;
