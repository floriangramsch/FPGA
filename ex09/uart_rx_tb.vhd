--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_tb is
generic (
    g_CLK_MHZ : real := 500.0--;
);
end entity;

architecture arch of uart_rx_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal DONE : std_logic_vector(1 downto 0);

    constant c_DATA_BITS : positive := 4;
    constant c_CpS : positive := 4; -- 4 clocks per symbol
    
    -- serial data line
    signal sdata : std_logic;
    -- tx write
    signal tx_wdata : std_logic_vector(c_DATA_BITS-1 downto 0);
    signal tx_we, tx_wfull : std_logic;
    -- rx read
    signal rx_rdata : std_logic_vector(c_DATA_BITS-1 downto 0);
    signal rx_rack, rx_rempty : std_logic;

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_uart_tx : entity work.uart_tx
    generic map (
        g_DATA_BITS => c_DATA_BITS,
        g_CpS => c_CpS--,
    )
    port map (
        o_sdata     => sdata,

        i_wdata     => tx_wdata,
        i_we        => tx_we,
        o_wfull     => tx_wfull,

        i_reset_n   => reset_n,
        i_clk       => clk--,
    );


    e_uart_rx : entity work.uart_rx
    generic map (
        g_DATA_BITS => c_DATA_BITS,
        g_CpS => c_CpS--,
    )
    port map (
        i_sdata     => sdata,

        o_rempty    => rx_rempty,
        i_rack      => rx_rack,
        o_rdata     => rx_rdata,

        i_reset_n   => reset_n,
        i_clk       => clk--,
    );

    -- generate writes to tx_uart
    process
    begin
        tx_we <= '0';
        wait until rising_edge(reset_n);

        for v in 0 to 2**c_DATA_BITS-1 loop
            wait until rising_edge(clk) and tx_wfull = '0';

            tx_wdata <= std_logic_vector(to_unsigned(v, c_DATA_BITS));
            tx_we <= '1';
            wait until rising_edge(clk);
            tx_wdata <= (others => 'X');
            tx_we <= '0';
        end loop;

        DONE(0) <= '1';
        wait;
    end process;

    -- read from rx_uart
    process
    begin
        rx_rack <= '0';
        wait until rising_edge(reset_n);

        for v in 0 to 2**c_DATA_BITS-1 loop
            wait until rising_edge(clk) and rx_rempty = '0';

            assert (
                rx_rdata = std_logic_vector(to_unsigned(v, c_DATA_BITS))
            ) report "E [tb] rx_rdata /= '" & integer'image(v) & "'" severity error;

            rx_rack <= '1';
            wait until rising_edge(clk);
            rx_rack <= '0';
        end loop;

        DONE(1) <= '1';
        wait;
    end process;

    process
    begin
        wait for 1000 ns;
        assert ( DONE = (DONE'range => '1') )
            report "E [tb] SIMULATION NOT DONE"
            severity error;
        wait;
    end process;

    process
    begin
        wait until ( DONE = (DONE'range => '1') );
        report "I [tb] SIMULATION DONE";
        wait;
    end process;

end architecture;
