--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex03_clkdiv_sel IS
    PORT (
        o_clk : OUT STD_LOGIC;
        i_sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
        i_reset_n : IN STD_LOGIC;
        i_clk : IN STD_LOGIC--;
    );
END ENTITY;

ARCHITECTURE arch OF ex03_clkdiv_sel IS
    TYPE array_positive_t IS ARRAY(NATURAL RANGE <>) OF POSITIVE;
    CONSTANT C_DIVIDER_VALUES : array_positive_t(0 TO 15) := (
        1,   -- 0.125s
        2,   -- 0.25s
        3,   -- 0.375s
        4,   -- 0.5s
        5,   -- 0.625s
        6,   -- 0.75s
        7,   -- 0.875s
        8,   -- 1s
        12,  -- 1.5s
        16,  -- 2s
        20,  -- 2.5s
        24,  -- 3s
        28,  -- 3.5s
        32,  -- 4s
        36,  -- 4.5s
        40   -- 5s
    );
    SIGNAL sel_uint : NATURAL;
    signal clk: std_logic := '0';
    signal counter: integer := 0;

BEGIN
    sel_uint <= to_integer(unsigned(i_sel));
    o_clk <= clk;

    PROCESS (i_clk, i_reset_n)
    BEGIN
    if i_reset_n = '0' then
        clk <= '0';
        counter <= 0;
    elsif rising_edge(i_clk) then
        if counter = C_DIVIDER_VALUES(sel_uint)-1 then
            counter <= 0;
            clk <= not clk;
        else
            counter <= counter + 1;
        end if;
    end if;

    END PROCESS;

END ARCHITECTURE arch;