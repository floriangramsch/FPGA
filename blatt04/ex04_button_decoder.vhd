--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex04_button_decoder IS
    GENERIC (
        T_SHORT : POSITIVE := 4;
        T_LONG : POSITIVE := 8--;
    );
    PORT (
        i_btn : IN STD_LOGIC;
        o_single : OUT STD_LOGIC;
        o_double : OUT STD_LOGIC;
        o_triple : OUT STD_LOGIC;
        o_long : OUT STD_LOGIC;
        i_reset_n : IN STD_LOGIC := '1';
        i_clk : IN STD_LOGIC--;
    );
END ENTITY;
 
ARCHITECTURE rtl OF ex04_button_decoder IS
    SIGNAL btn_high : STD_LOGIC;
    SIGNAL btn_low : STD_LOGIC;
    SIGNAL cnt_time : INTEGER;
    SIGNAL cnt_pressed : INTEGER;
BEGIN
    rising_btn : ENTITY work.ex02_edge_detector
        GENERIC MAP(
            g_EDGE => 1--,
        )
        PORT MAP(
            i_d => i_btn,
            o_q => btn_high,
            i_clk => i_clk
        );

    falling_btn : ENTITY work.ex02_edge_detector
        GENERIC MAP(
            g_EDGE => -1--,
        )
        PORT MAP(
            i_d => i_btn,
            o_q => btn_low,
            i_clk => i_clk
        );

    PROCESS (i_clk, i_reset_n)
    BEGIN
        IF i_reset_n = '0' THEN
            cnt_time <= 0;
            cnt_pressed <= 0;
            o_single <= '0';
            o_double <= '0';
            o_triple <= '0';
            o_long <= '0';
        ELSIF rising_edge(i_clk) THEN
            o_single <= '0';
            o_double <= '0';
            o_triple <= '0';
            o_long <= '0';
            cnt_time <= cnt_time + 1;

            IF cnt_time >= T_SHORT - 1 THEN
                IF cnt_pressed = 1 THEN
                    o_single <= '1';
                ELSIF cnt_pressed = 2 THEN
                    o_double <= '1';
                ELSIF cnt_pressed = 3 THEN
                    o_triple <= '1';
                END IF;
                cnt_pressed <= 0;
            END IF;

            IF btn_high = '1' THEN
                cnt_time <= 0;
                cnt_pressed <= cnt_pressed + 1;
            ELSIF btn_low = '1' THEN
                IF cnt_time >= T_LONG - 1 THEN
                    o_long <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;