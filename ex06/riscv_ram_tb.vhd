--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_ram_tb is
generic (
    g_CLK_MHZ : real := 20.0--;
);
end entity;

architecture arch of riscv_ram_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal addr : std_logic_vector(9 downto 0);
    signal rdata, wdata : std_logic_vector(31 downto 0);
    signal we : std_logic;

    signal cnt : integer := 0;

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_ram : entity work.riscv_ram
    port map (
        i_addr  => std_logic_vector(addr),
        o_rdata => rdata,
        i_wdata => wdata,
        i_we    => we,
        i_clk   => clk--,
    );

    process(clk)
    begin
    if rising_edge(clk) then
        cnt <= cnt + 1;
        case cnt is

        -- write to ram
        when 1 =>
            -- set address, write data and write enable
            addr <= std_logic_vector(to_unsigned(4, 10));
            wdata <= X"00000001";
            we <= '1';
        when 2 =>
            addr <= std_logic_vector(to_unsigned(8, 10));
            wdata <= X"00000002";
            we <= '1';
        when 3 =>
            addr <= std_logic_vector(to_unsigned(12, 10));
            wdata <= X"00000003";
            we <= '1';
        when 4 =>
            addr <= std_logic_vector(to_unsigned(16, 10));
            wdata <= X"00000004";
            we <= '1';

        when 5 =>
            we <= '0';
            addr <= (others => 'X');

        -- read from ram
        when 6 =>
            -- set the address
            addr <= std_logic_vector(to_unsigned(4, 10));
        when 7 =>
            -- at this clock cycle the ram observes new address
            null;
        when 8 =>
            -- and new data is available
            assert ( rdata = X"00000001" ) severity error;
            addr <= (others => 'X');

        when 9 =>
            addr <= std_logic_vector(to_unsigned(8, 10));
        when 10 =>
            addr <= std_logic_vector(to_unsigned(12, 10));
        when 11 =>
            assert ( rdata = X"00000002" ) severity error;
            addr <= std_logic_vector(to_unsigned(16, 10));
        when 12 =>
            assert ( rdata = X"00000003" ) severity error;
            addr <= (others => 'X');
        when 13 =>
            assert ( rdata = X"00000004" ) severity error;

        when others => null;
        end case;
    end if;
    end process;

end architecture;
