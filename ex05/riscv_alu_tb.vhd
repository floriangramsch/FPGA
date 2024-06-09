--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_alu_tb is
generic (
    g_CLK_MHZ : real := 12.5--;
);
end entity;

architecture arch of riscv_alu_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal s1 : std_logic_vector(31 downto 0) := X"87654321";
    signal s2 : std_logic_vector(31 downto 0) := X"12345678";
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    signal d : std_logic_vector(31 downto 0);

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    i_riscv_alu : entity work.riscv_alu
    port map(
        i_s1 => s1,
        i_s2 => s2,
        i_funct3 => funct3,
        i_funct7 => funct7,
        o_d => d--,
    );

    process
    begin
        wait until ( reset_n = '1' );

        wait until rising_edge(clk);
        funct3 <= "000"; funct7 <= "0000000"; -- ADD
        wait until falling_edge(clk);
        assert ( d = X"99999999" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "000"; funct7 <= "0100000"; -- SUB
        wait until falling_edge(clk);
        assert ( d = X"7530ECA9" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "001"; funct7 <= "0000000"; -- SLL
        wait until falling_edge(clk);
        assert ( d = X"21000000" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "010"; funct7 <= "0000000"; -- SLT
        wait until falling_edge(clk);
        assert ( d = X"00000001" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "011"; funct7 <= "0000000"; -- SLT
        wait until falling_edge(clk);
        assert ( d = X"00000000" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "100"; funct7 <= "0000000"; -- XOR
        wait until falling_edge(clk);
        assert ( d = X"95511559" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "101"; funct7 <= "0000000"; -- SRL
        wait until falling_edge(clk);
        assert ( d = X"00000087" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "101"; funct7 <= "0100000"; -- SRA
        wait until falling_edge(clk);
        assert ( d = X"FFFFFF87" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "110"; funct7 <= "0000000"; -- OR
        wait until falling_edge(clk);
        assert ( d = X"97755779" ) severity error;

        wait until rising_edge(clk);
        funct3 <= "111"; funct7 <= "0000000"; -- AND
        wait until falling_edge(clk);
        assert ( d = X"02244220" ) severity error;

        wait;
    end process;

end architecture;
