LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY riscv_ram IS
    PORT (
        i_addr : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        o_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        i_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        i_we : IN STD_LOGIC;
        i_clk : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE rtl OF riscv_ram IS
    TYPE ram_type IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));
BEGIN
    PROCESS (i_clk)
    BEGIN
        IF rising_edge(i_clk) THEN
            o_rdata <= (OTHERS => '0');
            -- Check if address is word-aligned by ensuring the two LSBs are 0
            IF i_addr(1 DOWNTO 0) = "00" THEN
                IF i_we = '1' THEN
                    -- Write operation
                    ram(TO_INTEGER(unsigned(i_addr(9 DOWNTO 2)))) <= i_wdata;
                ELSE
                    -- Read operation
                    o_rdata <= ram(TO_INTEGER(unsigned(i_addr(9 DOWNTO 2))));
                END IF;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;