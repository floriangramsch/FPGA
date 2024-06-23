--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.rv32i_pkg.ALL;

ENTITY riscv_instruction_decoder IS
    PORT (
        -- instruction opcode
        o_opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        -- functions
        o_funct3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        o_funct7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        -- source register addresses
        o_rs1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        o_rs2 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        -- destination register address
        o_rd : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        -- immediate value
        o_imm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- input 32-bit instruction
        i_inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0)--;
    );
END ENTITY;

ARCHITECTURE rtl OF riscv_instruction_decoder IS

BEGIN
    PROCESS (i_inst)
    BEGIN

        o_opcode <= (OTHERS => '0');
        o_funct3 <= (OTHERS => '0');
        o_funct7 <= (OTHERS => '0');
        o_rs1 <= (OTHERS => '0');
        o_rs2 <= (OTHERS => '0');
        o_rd <= (OTHERS => '0');
        o_imm <= (OTHERS => '0');

        -- R-Type
        IF i_inst(6 DOWNTO 0) = OP_c THEN
            o_funct7 <= i_inst(31 DOWNTO 25);
            o_rs2 <= i_inst(24 DOWNTO 20);
            o_rs1 <= i_inst(19 DOWNTO 15);
            o_funct3 <= i_inst(14 DOWNTO 12);
            o_rd <= i_inst(11 DOWNTO 7);
            o_opcode <= i_inst(6 DOWNTO 0);

            -- I-type
        ELSIF i_inst(6 DOWNTO 0) = OP_IMM_c OR i_inst(6 DOWNTO 0) = JALR_c OR i_inst(6 DOWNTO 0) = LOAD_c THEN
            o_imm(11 DOWNTO 0) <= i_inst(31 DOWNTO 20);
            o_rs1 <= i_inst(19 DOWNTO 15);
            o_funct3 <= i_inst(14 DOWNTO 12);
            o_rd <= i_inst(11 DOWNTO 7);
            o_opcode <= i_inst(6 downto 0);

            -- S-type
        ELSIF i_inst(6 DOWNTO 0) = STORE_c THEN
            o_imm(11 DOWNTO 5) <= i_inst(31 DOWNTO 25);
            o_rs2 <= i_inst(24 DOWNTO 20);
            o_rs1 <= i_inst(19 DOWNTO 15);
            o_funct3 <= i_inst(14 DOWNTO 12);
            o_imm(4 DOWNTO 0) <= i_inst(11 DOWNTO 7);
            o_opcode <= i_inst(6 DOWNTO 0);

            -- B-type
        ELSIF i_inst(6 DOWNTO 0) = BRANCH_c THEN
            o_imm(12) <= i_inst(31);
            o_imm(10 DOWNTO 5) <= i_inst(30 DOWNTO 25);
            o_rs2 <= i_inst(24 DOWNTO 20);
            o_rs1 <= i_inst(19 DOWNTO 15);
            o_funct3 <= i_inst(14 DOWNTO 12);
            o_imm(4 DOWNTO 1) <= i_inst(11 DOWNTO 8);
            o_imm(11) <= i_inst(7);
            o_opcode <= i_inst(6 DOWNTO 0);

            -- U-type
        ELSIF i_inst(6 DOWNTO 0) = LUI_c OR i_inst(6 DOWNTO 0) = AUIPC_c THEN
            o_imm(31 DOWNTO 12) <= i_inst(31 DOWNTO 12);
            o_rd <= i_inst(11 DOWNTO 7);
            o_opcode <= i_inst(6 DOWNTO 0);

            -- J-type
        ELSIF i_inst(6 DOWNTO 0) = JAL_c THEN
            o_imm(20) <= i_inst(31);
            o_imm(10 DOWNTO 1) <= i_inst(30 DOWNTO 21);
            o_imm(1) <= i_inst(20);
            o_imm(19 DOWNTO 12) <= i_inst(19 DOWNTO 12);
            o_rd <= i_inst(11 DOWNTO 7);
            o_opcode <= i_inst(6 DOWNTO 0);

        END IF;

    END PROCESS;
END ARCHITECTURE rtl;