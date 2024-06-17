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
signal shift_amount : integer := 0;
BEGIN
    PROCESS (i_funct3, i_funct7)
    BEGIN
        CASE i_funct3 IS
            WHEN "000" =>
                IF i_funct7 = "0000000" THEN
                    -- ADD Operation
                    o_d <= STD_LOGIC_VECTOR(signed(i_s1) + signed(i_s2)); 
                ELSIF i_funct7 = "0100000" THEN
                    -- SUB Operation
                    o_d <= STD_LOGIC_VECTOR(signed(i_s1) - signed(i_s2)); 
                END IF;

            WHEN "001" =>
                IF i_funct7 = "0000000" THEN
                    -- SLL Operation
                    shift_amount <= to_integer(unsigned(i_s2(4 downto 0)));
                    o_d <= std_logic_vector(shift_left(unsigned(i_s1), shift_amount));
                END IF;

            WHEN "010" =>
                IF i_funct7 = "0000000" THEN
                    -- SLT Operation
                    IF signed(i_s1) < signed(i_s2) then
                        o_d <= "00000000000000000000000000000001";
                    ELSE 
                        o_d <= "00000000000000000000000000000000";
                    END IF;
                END IF;

            WHEN "011" =>
                IF i_funct7 = "0000000" THEN
                    -- SLTU Operation
                    IF unsigned(i_s1) < unsigned(i_s2) then
                        o_d <= "00000000000000000000000000000001";
                    ELSE 
                        o_d <= "00000000000000000000000000000000";
                    END IF;
                END IF;
            WHEN "100" =>
                IF i_funct7 = "0000000" THEN
                    -- XOR Operation
                    o_d <= i_s1 XOR i_s2;
                END IF;
            WHEN "101" =>
                IF i_funct7 = "0000000" THEN
                    -- SRL Operation
                    shift_amount <= to_integer(unsigned(i_s2(4 downto 0)));
                    o_d <= std_logic_vector(shift_right(unsigned(i_s1), shift_amount));
                ELSIF i_funct7 = "0100000" THEN
                    -- SRA Operation
                    shift_amount <= to_integer(unsigned(i_s2(4 downto 0)));
                    o_d <= std_logic_vector(shift_right(signed(i_s1), shift_amount));
                END IF;
            WHEN "110" =>
                IF i_funct7 = "0000000" THEN
                    -- OR Operation
                    o_d <= i_s1 OR i_s2;
                END IF;
            WHEN "111" =>
                IF i_funct7 = "0000000" THEN
                    -- AND Operation
                    o_d <= i_s1 AND i_s2;
                END IF;
            WHEN OTHERS =>
                o_d <= (OTHERS => '0'); -- Defaultfall
        END CASE;
    END PROCESS;
END ARCHITECTURE rtl;