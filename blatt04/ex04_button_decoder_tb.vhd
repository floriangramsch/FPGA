--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex04_button_decoder_tb is
generic (
    g_CLK_MHZ : real := 100.0--;
);
end entity;

architecture arch of ex04_button_decoder_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    -- test vectors                     cycle: 0123456789012345678901234567890123456789012345678901234567890123
    constant test_btn     : std_logic_vector := "00011000000110110000001101101100000011111111111000000000000000";
    constant test_single  : std_logic_vector := "00000000100000000000000000000000000000000100000000000000000000";
    constant test_double  : std_logic_vector := "00000000000000000001000000000000000000000000000000000000000000";
    constant test_triple  : std_logic_vector := "00000000000000000000000000000000010000000000000000000000000000";
    constant test_long    : std_logic_vector := "00000000000000000000000000000000000000000000000010000000000000";

    signal btn : std_logic;
    signal single, double, triple, long : std_logic;

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_button_decoder : entity work.ex04_button_decoder
    generic map (
        T_SHORT => 4,
        T_LONG => 8--,
    )
    port map (
        i_btn => btn,
        o_single => single,
        o_double => double,
        o_triple => triple,
        o_long => long,
        i_reset_n => reset_n,
        i_clk => clk--,
    );

    process
    begin
        btn <= '0';
        wait until ( reset_n = '1' );

        for i in test_btn'range loop
            wait until rising_edge(clk);
            -- set input from `ds` test vector
            btn <= test_btn(i);
            wait until falling_edge(clk);
            -- check output to `qs` test vector
            assert ( single = test_single(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
            assert ( double = test_double(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
            assert ( triple = test_triple(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
            assert ( long = test_long(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
        end loop;

        wait;
    end process;

end architecture;
