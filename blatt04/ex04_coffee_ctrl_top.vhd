--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex04_coffee_ctrl_top IS
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

ARCHITECTURE arch OF ex04_coffee_ctrl_top IS

    SIGNAL led : STD_LOGIC_VECTOR(o_led_n'RANGE) := (OTHERS => '0');
    SIGNAL sw : STD_LOGIC_VECTOR(i_sw_n'RANGE);

    CONSTANT c_CLK1_HZ : INTEGER := 1;
    SIGNAL clk1 : STD_LOGIC;

    SIGNAL temp_sw_n : STD_LOGIC;

BEGIN

    o_led_n <= NOT led;
    sw <= NOT i_sw_n;

    e_clkdiv : ENTITY work.ex03_clkdiv
        GENERIC MAP(
            N => 12000000 / c_CLK1_HZ / 2
        )
        PORT MAP(
            o_clk => clk1,
            i_reset_n => i_reset_n,
            i_clk => i_clk
        );

    -- blink led(7) with slow clock
    led(7) <= clk1;

    -- use edge detector to generate 1 clock cycle signals (slow clock)
    -- for coffee_ctrl
    generate_sw : FOR i IN sw'RANGE GENERATE
        temp_sw_n <= NOT i_sw_n(i);
        e_edge_detector : ENTITY work.ex02_edge_detector
            PORT MAP(
                i_d => temp_sw_n,
                o_q => sw(i),
                i_clk => clk1
            );
    END GENERATE;

    coffee_ctrl : ENTITY work.ex04_coffee_ctrl
        PORT MAP(
            i_btn => sw,
            o_state => led(4 DOWNTO 0),
            i_reset_n => i_reset_n,
            i_clk => clk1
        );

END ARCHITECTURE;