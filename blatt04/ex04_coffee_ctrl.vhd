--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex04_coffee_ctrl IS
    PORT (
        i_btn : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        o_state : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        i_reset_n : IN STD_LOGIC;
        i_clk : IN STD_LOGIC--;
    );
END ENTITY;

ARCHITECTURE rtl OF ex04_coffee_ctrl IS
    SIGNAL state : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11111";
    SIGNAL cnt_beans : INTEGER;
    SIGNAL cnt_water : INTEGER;
    SIGNAL cnt_milk : INTEGER;
    SIGNAL cnt_cleaning : INTEGER;

BEGIN
    o_state <= state;

    PROCESS (i_clk, i_reset_n)
    BEGIN
        IF i_reset_n = '0' THEN
            state <= "00001";
            cnt_beans <= 0;
            cnt_water <= 0;
            cnt_milk <= 0;
            cnt_cleaning <= 4;

        ELSIF rising_edge(i_clk) THEN --stop and clean
            IF i_btn(0) = '1' AND i_btn(1) = '0' AND i_btn(2) = '0' AND i_btn(3) = '0' THEN
                state <= "10000";
                cnt_beans <= 0;
                cnt_water <= 0;
                cnt_milk <= 0;
                cnt_cleaning <= 4;

            ELSIF state(0) = '1' THEN -- if in idle state
                IF i_btn(0) = '0' AND i_btn(1) = '1' AND i_btn(2) = '0' AND i_btn(3) = '0' THEN -- Black  Coffee
                    state <= "00010";
                    cnt_beans <= 3;
                    cnt_water <= 8;
                    cnt_milk <= 0;
                    cnt_cleaning <= 4;

                ELSIF i_btn(0) = '0' AND i_btn(1) = '0' AND i_btn(2) = '1' AND i_btn(3) = '0' THEN -- Espresso
                    state <= "00010";
                    cnt_beans <= 5;
                    cnt_water <= 2;
                    cnt_milk <= 0;
                    cnt_cleaning <= 4;

                ELSIF i_btn(0) = '0' AND i_btn(1) = '0' AND i_btn(2) = '0' AND i_btn(3) = '1' THEN -- Cappuccino
                    state <= "00010";
                    cnt_beans <= 3;
                    cnt_water <= 4;
                    cnt_milk <= 4;
                    cnt_cleaning <= 4;
                END IF;

            ELSIF state(1) = '1' THEN -- if in BEAN_GRINDER state
                IF cnt_beans <= 1 THEN
                    state <= "00100";
                ELSE
                    cnt_beans <= cnt_beans - 1;
                END IF;

            ELSIF state(2) = '1' THEN -- if in WATER_PUMP state
                IF cnt_water <= 1 THEN
                    IF cnt_milk > 1 THEN
                        state <= "01000";
                    ELSE
                        state <= "10000";
                    END IF;
                ELSE
                    cnt_water <= cnt_water - 1;
                END IF;

            ELSIF state(3) = '1' THEN -- if in MILK_PUMP state
                IF cnt_milk <= 1 THEN
                    state <= "10000";
                ELSE
                    cnt_milk <= cnt_milk - 1;
                END IF;

            ELSIF state(4) = '1' THEN -- if in Cleaning state
                IF cnt_cleaning <= 1 THEN
                    state <= "00001";
                ELSE
                    cnt_cleaning <= cnt_cleaning - 1;
                END IF;
            END IF;
        END IF;

    END PROCESS;
END ARCHITECTURE rtl;