--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_instruction_decoder_tb is
generic (
    g_CLK_MHZ : real := 20.0--;
);
end entity;

architecture arch of riscv_instruction_decoder_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal cnt : integer := 0;

    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    signal rs1, rs2, rd : std_logic_vector(4 downto 0);
    signal imm : std_logic_vector(31 downto 0);
    signal inst : std_logic_vector(31 downto 0);

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_instruction_decoder : entity work.riscv_instruction_decoder
    port map (
        o_opcode => opcode,

        o_funct3 => funct3,
        o_funct7 => funct7,

        o_rs1 => rs1,
        o_rs2 => rs2,
        o_rd => rd,

        o_imm => imm,

        i_inst => inst--,
    );

    process(clk)
    begin
    if rising_edge(clk) then
        cnt <= cnt + 1;
        case cnt is
        -- invalid instruction
        when 1 => inst <= (others => '1');
        when 2 =>
            assert ( opcode = "1111111" ) severity error;
            assert ( funct3 = "000" and funct7 = "0000000" and rs1 = "00000" and rs2 = "00000" and rd = "00000" and imm = X"00000000" )
                report "invalid default values" severity error;

        -- Register-Immediate (I-type)
        when 3 => inst <= X"812" & "10000" & "111" & "00001" & "0010011";
        when 4 =>
            assert ( opcode = "0010011" ) severity error;
            assert ( funct3 = "111" and funct7 = "0000000" )
                  report "invalid funct3 or funct7" severity error;
            assert ( rs1 = "10000" and rs2 = "00000" and rd = "00001" )
                  report "invalid registers" severity error;
            assert ( imm = X"FFFFF812" )
                  report "invalid immediate" severity error;

        -- Register-Register (R-type)
        when 5 => inst <= "0000000" & "00100" & "11000" & "101" & "00011" & "0110011";
        when 6 =>
            assert ( opcode = "0110011" ) severity error;
            assert ( funct3 = "101" and funct7 = "0000000" )
                  report "invalid funct3 or funct7" severity error;
            assert ( rs1 = "11000" and rs2 = "00100" and rd = "00011" )
                  report "invalid registers" severity error;
            assert ( imm = X"00000000" )
                  report "invalid immediate" severity error;

        -- LUI (U-type)
        when 7 => inst <= X"81234" & "11011" & "0110111";
        when 8 =>
            assert ( opcode = "0110111" ) severity error;
            assert ( funct3 = "000" and funct7 = "0000000" )
                  report "invalid funct3 or funct7" severity error;
            assert ( rs1 = "00000" and rs2 = "00000" and rd = "11011" )
                  report "invalid registers" severity error;
            assert ( imm = X"81234000" )
                  report "invalid immediate" severity error;

        -- (S-type)
        when 9 => inst <= "1111111" & "01110" & "10001" & "010" & "10000" & "0100011";
        when 10 =>
            assert ( opcode = "0100011" ) severity error;
            assert ( funct3 = "010" and funct7 = "0000000" )
                  report "invalid funct3 or funct7" severity error;
            assert ( rs1 = "10001" and rs2 = "01110" and rd = "00000" )
                  report "invalid registers" severity error;
            assert ( imm = X"FFFFFFF0" )
                  report "invalid immediate" severity error;

        -- (B-type)
        when 11 => inst <= "1010101" & "01010" & "10101" & "111" & "11111" & "1100011";
        when 12 =>
            assert ( opcode = "1100011" ) severity error;
            assert ( funct3 = "111" and funct7 = "0000000" )
                  report "invalid funct3 or funct7" severity error;
            assert ( rs1 = "10101" and rs2 = "01010" and rd = "00000" )
                  report "invalid registers" severity error;
            assert ( imm = X"FFFFF" & "1" & "010101" & "1111" & '0' )
                  report "invalid immediate" severity error;

        -- (J-type)
        when 13 => inst <= "10101010101010101010" & "01110" & "1101111";
        when 14 =>
            assert ( opcode = "1101111" ) severity error;
            assert ( funct3 = "000" and funct7 = "0000000" )
                  report "invalid funct3 or funct7" severity error;
            assert ( rs1 = "00000" and rs2 = "00000" and rd = "01110" )
                  report "invalid registers" severity error;
            assert ( imm = X"FFF" & "10101010" & "0" & "0101010101" & '0' )
                  report "invalid immediate" severity error;

        -- TODO: check positive immediate values

        when others => null;
        end case;
    end if;
    end process;

end architecture;
