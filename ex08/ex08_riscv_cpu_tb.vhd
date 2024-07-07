--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex08_riscv_cpu_tb is
generic (
    g_CLK_MHZ : real := 25.0--;
);
end entity;

architecture arch of ex08_riscv_cpu_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal rom_raddr : std_logic_vector(31 downto 0);
    signal rom_rdata : std_logic_vector(31 downto 0);
    signal rf_wdata : std_logic_vector(31 downto 0);

    type slv32_array_t is array (natural range <>) of std_logic_vector(31 downto 0);
    signal test_rf_wdata : slv32_array_t(2 to 31) := (
        X"A31B0000", X"A31B070F", X"B9B50000", X"B9B50757", X"A5EB9000", X"A5EB8EC2", X"101B6000", X"101B5F44", X"1E0E8000", X"1E0E8308", X"A1110707", X"F20CDC3C", X"57E752FE", X"F8F85A05",
        others => (others => 'X')
    );

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_rom : entity work.ex08_riscv_rom
    port map (
        i_raddr => rom_raddr(6 downto 0),
        o_rdata => rom_rdata,
        i_clk => clk--,
    );

    e_cpu : entity work.ex08_riscv_cpu
    port map (
        o_rom_raddr => rom_raddr,
        i_rom_rdata => rom_rdata,

        o_rf_wdata => rf_wdata,

        i_reset_n => reset_n,
        i_clk => clk--,
    );

    process(clk)
    begin
    if falling_edge(clk) then
        if ( test_rf_wdata'left <= cycle and cycle <= test_rf_wdata'right and not is_X(test_rf_wdata(cycle))) then
            assert ( rf_wdata = test_rf_wdata(cycle) )
                report "E [tb@cycle=" & integer'image(cycle) & "] "
                & "rf_wdata /= test_rf_wdata(cycle)"
                severity error;
        end if;
        --
    end if;
    end process;

end architecture;
