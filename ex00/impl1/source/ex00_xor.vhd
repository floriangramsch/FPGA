--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex00_xor IS
    PORT (
        i_a : IN STD_LOGIC;
        i_b : IN STD_LOGIC;
        o_xor : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch0 OF ex00_xor IS
BEGIN

    -- use logic operator
    o_xor <= i_a XOR i_b;

END ARCHITECTURE;

ARCHITECTURE arch1 OF ex00_xor IS
BEGIN

    -- use when/else
    o_xor <= '1' WHEN (i_a = '1' XOR i_b = '1') ELSE
        '0';

END ARCHITECTURE;

ARCHITECTURE arch2 OF ex00_xor IS
BEGIN

    -- this implementation uses process

    -- combinational process, i.e not clocked process,
    -- must have sensitivity list containing all signals that are used as inputs
    PROCESS (i_a, i_b)
    BEGIN
        o_xor <= '0';
        -- note that if/else can only be used inside process block
        IF (i_a = '1' XOR i_b = '1') THEN
            o_xor <= '1';
        ELSE
            o_xor <= '0';
        END IF;
    END PROCESS;

END ARCHITECTURE;