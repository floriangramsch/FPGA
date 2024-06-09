
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex01_halfAdder IS
    PORT (
        i_ah : IN STD_LOGIC; -- Eingang A
        i_bh : IN STD_LOGIC; -- Eingang B
        o_sh : OUT STD_LOGIC; -- Summe
        o_ch : OUT STD_LOGIC -- Carry-Out
    );
END ENTITY ex01_halfAdder;

ARCHITECTURE arch1 OF ex01_halfAdder IS

BEGIN

    o_sh <= i_ah XOR i_bh;
    o_ch <= i_ah AND i_bh;

END ARCHITECTURE arch1;