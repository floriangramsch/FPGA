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
    PROCESS (i_funct3, i_funct7)
    BEGIN
        CASE i_funct3 IS
            WHEN "000" =>
                IF i_funct7 = "0000000" THEN
                    -- ADD Operation
                    o_d <= STD_LOGIC_VECTOR(signed(i_s1) + signed(i_s2)); -- Beispielwert
                ELSIF i_funct7 = "0100000" THEN
                    -- SUB Operation
                    o_d <= STD_LOGIC_VECTOR(signed(i_s1) - signed(i_s2)); -- Beispielwert
                END IF;
            WHEN "001" =>
                IF i_funct7 = "0000000" THEN
                    -- SLL Operation
                    o_d <= "10000000000000000000000000000011"; -- Beispielwert
                END IF;
            WHEN "010" =>
                IF i_funct7 = "0000000" THEN
                    -- SLT Operation
                    o_d <= "00000000000000000000000000000100"; -- Beispielwert
                END IF;
            WHEN "011" =>
                IF i_funct7 = "0000000" THEN
                    -- SLTU Operation
                    o_d <= "00000000000000000000000000000101"; -- Beispielwert
                END IF;
            WHEN "100" =>
                IF i_funct7 = "0000000" THEN
                    -- XOR Operation
                    o_d <= "00000000000000000000000000000110"; -- Beispielwert
                END IF;
            WHEN "101" =>
                IF i_funct7 = "0000000" THEN
                    -- SRL Operation
                    o_d <= "00000000000000000000000000000111"; -- Beispielwert
                ELSIF i_funct7 = "0100000" THEN
                    -- SRA Operation
                    o_d <= "00000000000000000000000000001000"; -- Beispielwert
                END IF;
            WHEN "110" =>
                IF i_funct7 = "0000000" THEN
                    -- OR Operation
                    o_d <= "00000000000000000000000000001001"; -- Beispielwert
                END IF;
            WHEN "111" =>
                IF i_funct7 = "0000000" THEN
                    -- AND Operation
                    o_d <= "00000000000000000000000000001010"; -- Beispielwert
                END IF;
            WHEN OTHERS =>
                o_d <= (OTHERS => '0'); -- Defaultfall
        END CASE;
    END PROCESS;
END ARCHITECTURE rtl;