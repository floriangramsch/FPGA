--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY riscv_alu IS
    PORT (
        -- input operands
        i_s1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        i_s2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- select function (operation)
        i_funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        i_funct7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        -- output result
        o_d : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)--;
    );
END ENTITY;

ARCHITECTURE rtl OF riscv_alu IS

BEGIN

END ARCHITECTURE rtl;