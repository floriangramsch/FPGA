--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_register_file_tb is
generic (
    g_CLK_MHZ : real := 50.0--;
);
end entity;

architecture arch of riscv_register_file_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal raddr1, raddr2, waddr : std_logic_vector(4 downto 0) := (others => '0');
    signal rdata1, rdata2, wdata : std_logic_vector(31 downto 0);
    signal we : std_logic := '0';

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_register_file : entity work.riscv_register_file
    port map (
        i_raddr1 => raddr1,
        o_rdata1 => rdata1,

        i_raddr2 => raddr2,
        o_rdata2 => rdata2,

        i_waddr => waddr,
        i_wdata => wdata,
        i_we => we,

        i_clk => clk--,
    );

    process
    begin
        wait until ( reset_n = '1' );

        for i in 0 to 31 loop
            -- write
            wait until rising_edge(clk);
            waddr <= std_logic_vector(to_unsigned(i, 5));
            wdata <= std_logic_vector(to_unsigned(i+1, 32));
            we <= '1';
            wait until rising_edge(clk);
            we <= '0';
            raddr1 <= std_logic_vector(to_unsigned(i, 5));
            wait until falling_edge(clk);
            if ( i = 0 ) then
                assert ( rdata1 = X"00000000" ) severity error;
            else
                assert ( rdata1 = std_logic_vector(to_unsigned(i+1, 32)) ) severity error;
            end if;
        end loop;

        wait;
    end process;

end architecture;
