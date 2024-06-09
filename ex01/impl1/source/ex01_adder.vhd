LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex01_adder IS
    GENERIC (
        g_W : INTEGER := 4 -- Breite der Eingangs- und Ausgangssignale
    );
    PORT (
        i_a : IN STD_LOGIC_VECTOR(g_W - 1 DOWNTO 0); -- Eingang A
        i_b : IN STD_LOGIC_VECTOR(g_W - 1 DOWNTO 0); -- Eingang B
        i_c : IN STD_LOGIC; -- Carry-In
        o_s : OUT STD_LOGIC_VECTOR(g_W - 1 DOWNTO 0); -- Summe
        o_c : OUT STD_LOGIC -- Carry-Out 
    );
END ENTITY ex01_adder;

ARCHITECTURE arch OF ex01_adder IS
    SIGNAL sum : STD_LOGIC_VECTOR(g_W - 1 DOWNTO 0);
    SIGNAL carry : STD_LOGIC_VECTOR(g_W DOWNTO 0);
    SIGNAL temp_sum, temp_carry : STD_LOGIC_VECTOR(g_W - 1 DOWNTO 0);
BEGIN
    carry(0) <= i_c;

    gen_adders: FOR loop_var IN 0 TO g_W - 1 GENERATE
        ha_inst: ENTITY work.ex01_halfAdder
            PORT MAP(
                i_ah => i_a(loop_var),
                i_bh => i_b(loop_var),
                o_sh => temp_sum(loop_var),
                o_ch => temp_carry(loop_var)
            );

        PROCESS (temp_sum, carry, temp_carry)
        BEGIN
            sum(loop_var) <= temp_sum(loop_var) XOR carry(loop_var);
            carry(loop_var + 1) <= (temp_sum(loop_var) AND carry(loop_var)) OR temp_carry(loop_var);
        END PROCESS;
    END GENERATE;

    o_s <= sum;
    o_c <= carry(g_W);
END ARCHITECTURE arch;