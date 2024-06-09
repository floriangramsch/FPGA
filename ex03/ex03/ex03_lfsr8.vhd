--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex03_lfsr8 IS
    GENERIC (
        -- LFSR reset value
        g_SEED : std_logic_vector(7 downto 0) := (others => '0')
    );
    PORT (
        -- output LFSR value
        o_lfsr : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- output period of this LFSR
        o_period : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- input reset (active low)
        i_reset_n : IN STD_LOGIC;
        -- input clock
        i_clk : IN STD_LOGIC--;
    );
END ENTITY;

ARCHITECTURE arch OF ex03_lfsr8 IS
    SIGNAL lfsr : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL feedback : STD_LOGIC;
    SIGNAL period_cntr : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

BEGIN
    -- lsfr
    PROCESS (i_clk, i_reset_n)
    BEGIN
        IF i_reset_n = '0' THEN
            lfsr <= g_SEED;
        ELSIF rising_edge(i_clk) THEN
            lfsr <= lfsr(6 DOWNTO 0) & feedback;
        END IF;

    END PROCESS;

    -- Counter
    PROCESS (i_clk, i_reset_n)
    BEGIN
        IF i_reset_n = '0' THEN
            period_cntr <= (OTHERS => '0');
        ELSIF rising_edge(i_clk) THEN
            IF lfsr = g_SEED THEN
                period_cntr <= (OTHERS => '0');
            ELSE
                period_cntr <= STD_LOGIC_VECTOR(unsigned(period_cntr) + 1);
            END IF;
        END IF;

    END PROCESS;
    feedback <= lfsr(7) XOR lfsr(5) XOR lfsr(4) XOR lfsr(3);
    o_lfsr <= lfsr;
    o_period <= period_cntr;
END ARCHITECTURE arch;
