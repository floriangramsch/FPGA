--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex04_button_decoder_top is
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

architecture arch of ex04_button_decoder_top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

    signal btn : std_logic;

    constant c_CLK1_HZ : integer := 10;
    signal clk1 : std_logic;

    signal reset_n_inv : std_logic;

begin

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    reset_n_inv <= not i_reset_n;

    -- debounce input button (i_reset_n)
    e_debouncer : entity work.ex02_debouncer
    generic map (
        -- 1 ms
        g_N => 12000/2--,
    )
    port map (
        i_d         => reset_n_inv,
        o_q         => btn,
        i_reset_n   => '1',
        i_clk       => i_clk--,
    );

    led(0) <= not i_reset_n;

    -- generate slow clock
    -- (use 'Sinplify Pro' synthesis tool)
    e_clkdiv : entity work.ex03_clkdiv
    generic map (
        N => 12000000 / c_CLK1_HZ / 2--,
    )
    port map (
        o_clk       => clk1,
        i_reset_n   => '1',
        i_clk       => i_clk--,
    );

    -- blink led(7) with slow clock
    led(7) <= clk1;

    e_button_decoder : entity work.ex04_button_decoder
    generic map (
        -- short press - 0.5 s
        T_SHORT => c_CLK1_HZ / 2,
        -- long press - 1 s
        T_LONG => c_CLK1_HZ--,
    )
    port map (
        i_btn       => btn,
        o_single    => led(1),
        o_double    => led(2),
        o_triple    => led(3),
        o_long      => led(4),
        i_reset_n   => '1',
        i_clk       => clk1--,
    );

end architecture;
