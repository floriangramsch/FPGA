--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex01_top_adder IS
    PORT (
        -- 8 light diods (active low)
        o_led_n : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '1');
        -- 4 switches
        i_sw_n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        -- external clock (12 MHz)
        i_clk : IN STD_LOGIC;
        -- reset button (active low)
        i_reset_n : IN STD_LOGIC--;
    );
END ENTITY;

ARCHITECTURE arch OF ex01_top_adder IS

    SIGNAL led : STD_LOGIC_VECTOR(o_led_n'RANGE) := (OTHERS => '0');
    SIGNAL sw : STD_LOGIC_VECTOR(i_sw_n'RANGE);

BEGIN

    -- output led's are active low
    o_led_n <= NOT led;
    -- input switches are active low
    sw <= NOT i_sw_n;

    -- use switches as input to adder (2 2-bit input args)
    -- use LEDs to display result (4-bit sum and 1 bit carry)
    i_adder : ENTITY work.ex01_adder
        GENERIC MAP(
            g_W => 4--,
        )
        PORT MAP(
            i_a => sw,
            -- i_a => sw(1 DOWNTO 0),
            --        i_a(3 downto 2) => "00",

            -- i_b => sw(3 DOWNTO 2),
            i_b => "1111",
            --        i_b(3 downto 2) => (others => '0'),

            i_c => '0',

            -- o_s => led(1 DOWNTO 0),
            o_s => led(3 DOWNTO 0),
            o_c => led(4)--,
        );

END ARCHITECTURE;