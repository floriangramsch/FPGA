LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex08_riscv_cpu IS
    PORT (
        -- ROM port (code)
        o_rom_raddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        i_rom_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        o_rf_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- active low reset
        i_reset_n : IN STD_LOGIC;
        -- clock
        i_clk : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE rtl OF ex08_riscv_cpu IS
    SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pc_next : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rf_wdata_internal : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- ALU
    SIGNAL i_s1, i_s2, o_d : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Instruction Decoder
    SIGNAL opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rd, rs1, rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL funct3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL funct7 : STD_LOGIC_VECTOR(6 DOWNTO 0);

    -- Register File
    SIGNAL rdata1, rdata2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL we : STD_LOGIC;

BEGIN
    o_rom_raddr <= PC;
    o_rf_wdata <= rf_wdata_internal;

    -- PC update process
    PROCESS (i_clk)
    BEGIN
        IF i_reset_n = '0' THEN
            PC <= X"FFFFFFFC";
        ELSIF rising_edge(i_clk) THEN
            PC <= pc_next;
        END IF;
    END PROCESS;

    pc_next <= STD_LOGIC_VECTOR(unsigned(PC) + 4);

    -- Instruction Decoder
    ir : ENTITY work.riscv_instruction_decoder
        PORT MAP(
            o_opcode => opcode,
            o_funct3 => funct3,
            o_funct7 => funct7,
            o_rs1 => rs1,
            o_rs2 => rs2,
            o_rd => rd,
            o_imm => imm,
            i_inst => i_rom_rdata
        );

    -- Register File
    rf : ENTITY work.riscv_register_file
        PORT MAP(
            i_raddr1 => rs1,
            o_rdata1 => rdata1,
            i_raddr2 => rs2,
            o_rdata2 => rdata2,
            i_waddr => rd,
            i_wdata => rf_wdata_internal,
            i_we => we,
            i_clk => i_clk
        );

    -- ALU
    alu : ENTITY work.riscv_alu
        PORT MAP(
            i_s1 => i_s1,
            i_s2 => i_s2,
            i_funct3 => funct3,
            i_funct7 => funct7,
            o_d => o_d
        );

    -- Control Logic Process
    PROCESS (opcode, funct3, funct7, rdata1, rdata2, imm, PC)
    BEGIN
        CASE opcode IS
            WHEN "0110011" => -- R-type
                i_s1 <= rdata1;
                i_s2 <= rdata2;
                we <= '1';
                rf_wdata_internal <= o_d;

            WHEN "0010011" => -- I-type
                i_s1 <= rdata1;
                i_s2 <= imm;
                we <= '1';
                rf_wdata_internal <= o_d;

            WHEN "0110111" => -- LUI
                rf_wdata_internal <= imm;
                we <= '1';

            WHEN "0010111" => -- AUIPC
                rf_wdata_internal <= STD_LOGIC_VECTOR(unsigned(PC) + unsigned(imm));
                we <= '1';

            WHEN OTHERS =>
                we <= '0';
                rf_wdata_internal <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END ARCHITECTURE rtl;