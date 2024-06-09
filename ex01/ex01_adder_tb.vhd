--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex01_adder_tb is
generic (
    g_CLK_MHZ : real := 1000.0--;
);
end entity;

architecture arch of ex01_adder_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    constant W : positive := 4;
    signal a, b, s : std_logic_vector(W-1 downto 0);
    signal ci, co : std_logic;

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_adder : entity work.ex01_adder
    generic map (
        g_W => W--,
    )
    port map (
        i_a => a,
        i_b => b,
        i_c => ci,
        o_s => s,
        o_c => co--,
    );

    process
    begin
        wait until ( reset_n = '1' );

        for i in 0 to 2**(2*W+1)-1 loop
            wait until rising_edge(clk);
            -- on rising edge generate inputs
            a <= std_logic_vector(to_unsigned(i mod 2**W, W));
            b <= std_logic_vector(to_unsigned((i / 2**W) mod 2**W, W));
            ci <= to_unsigned(i / 2**(2*W), 1)(0);

            wait until falling_edge(clk);
            -- on falling edge check outputs
            assert ( unsigned(co & s) = unsigned('0' & a) + unsigned(b) + ("" & ci) ) severity error;
        end loop;

        report "Simulation DONE";
        wait;
    end process;

end architecture;
