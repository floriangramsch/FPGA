--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex00_top IS
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

ARCHITECTURE arch OF ex00_top IS

    SIGNAL led : STD_LOGIC_VECTOR(o_led_n'RANGE) := (OTHERS => '0');
    SIGNAL sw : STD_LOGIC_VECTOR(i_sw_n'RANGE);

    -- 32 bit counter
    SIGNAL cnt : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --    signal cnt_next : std_logic_vector(31 downto 0);

BEGIN

    -- output led's are active low
    o_led_n <= NOT led;
    -- input switches are active low
    sw <= NOT i_sw_n;

    -- drive leds(3..0) from switches
    led(3 DOWNTO 1) <= sw(3 DOWNTO 1);

    e_and : ENTITY work.ex00_xor
        PORT MAP(
            i_a => sw(0),
            i_b => sw(1),
            o_xor => led(0)--,
        );

    --    cnt_next <= std_logic_vector(unsigned(cnt) + 1);

    -- clocked process
    PROCESS (i_clk, i_reset_n)
    BEGIN
        IF (i_reset_n = '0') THEN -- async reset
            -- reset counter
            cnt <= (OTHERS => '0');
            --
        ELSIF rising_edge(i_clk) THEN
            -- increment counter on each clock cycle
            cnt <= STD_LOGIC_VECTOR(unsigned(cnt) + 1);
            --        cnt <= cnt_next;
            --
        END IF;
    END PROCESS;

    -- drive leds(7..4) with 4 bits of counter
    led(7 DOWNTO 4) <= cnt(23 DOWNTO 20);

END ARCHITECTURE;