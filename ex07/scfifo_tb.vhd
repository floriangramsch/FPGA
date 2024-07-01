--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scfifo_tb is
generic (
    g_CLK_MHZ : real := 200.0--;
);
end entity;

architecture arch of scfifo_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    signal wdata, rdata : std_logic_vector(4 downto 0) := (others => '0');
    signal wfull, rempty, we, rack : std_logic := '0';

    signal DONE : std_logic_vector(1 downto 0) := (others => '0');

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_scfifo : entity work.scfifo
    generic map (
        g_DATA_WIDTH => wdata'length,
        g_ADDR_WIDTH => 3--,
    )
    port map (
        o_wfull     => wfull,
        i_we        => we,
        i_wdata     => wdata,

        o_rempty    => rempty,
        i_rack      => rack,
        o_rdata     => rdata,

        i_reset_n   => reset_n,
        i_clk       => clk--,
    );

    process
    begin
        we <= '0';
        wait until rising_edge(reset_n);

        -- write every 2nd cycle
        for i in 0 to 2**wdata'length-1 loop
            wait until rising_edge(clk) and wfull = '0';
            we <= '1';
            wdata <= std_logic_vector(to_unsigned(i, wdata'length));
--            report "write: i = " & integer'image(i);

            wait until rising_edge(clk);
            we <= '0';
        end loop;

        -- write every 3rd cycle
        for i in 0 to 2**wdata'length-1 loop
            wait until rising_edge(clk) and wfull = '0';
            we <= '1';
            wdata <= std_logic_vector(to_unsigned(i, wdata'length));
--            report "write: i = " & integer'image(i);

            wait until rising_edge(clk);
            we <= '0';

            -- delay write
            wait until rising_edge(clk);
        end loop;

        DONE(0) <= '1';
        wait;
    end process;

    process
    begin
        rack <= '0';
        wait until rising_edge(reset_n);

        -- read every 3rd cycle
        for i in 0 to 2**rdata'length-1 loop
            wait until rising_edge(clk) and rempty = '0';
            rack <= '1';

--            report "read: i = " & integer'image(to_integer(unsigned(rdata)));
            assert ( rdata = std_logic_vector(to_unsigned(i, wdata'length)) )
                report "E [tb] expected i = " & integer'image(i) & " @ cycle " & integer'image(cycle)
                severity error;

            wait until rising_edge(clk);
            rack <= '0';

            -- delay read
            wait until rising_edge(clk);
        end loop;

        -- read every 2nd cycle
        for i in 0 to 2**rdata'length-1 loop
            wait until rising_edge(clk) and rempty = '0';
            rack <= '1';

--            report "read: i = " & integer'image(to_integer(unsigned(rdata)));
            assert ( rdata = std_logic_vector(to_unsigned(i, wdata'length)) )
                report "E [tb] expected i = " & integer'image(i) & " @ cycle " & integer'image(cycle)
                severity error;

            wait until rising_edge(clk);
            rack <= '0';
        end loop;

        DONE(1) <= '1';
        wait;
    end process;

    process
    begin
        wait for 1000 ns;
        assert ( DONE = (DONE'range => '1') )
            report "SIMULATION NOT DONE"
            severity error;
        wait;
    end process;

    process
    begin
        wait until ( DONE = (DONE'range => '1') );
        report "SIMULATION DONE";
        wait;
    end process;

end architecture;
