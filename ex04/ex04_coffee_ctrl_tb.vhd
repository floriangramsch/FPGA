--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex04_coffee_ctrl_tb is
generic (
    g_CLK_MHZ : real := 100.0--;
);
end entity;

architecture arch of ex04_coffee_ctrl_tb is

    signal clk : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal cycle : integer := 0;

    --                                                                                                       +- abort               --
    --                                                                                                       |         +- coffee    --
    --                                            +- coffee            +- espresso      +- cappuccino        |         | +- abort   --
    --                                            |                    |                |                    |         | |          --
    -- test vectors                     cycle: 0123456789012345678901234567890123456789012345678901234567890123456789012345678901   --
    constant test_btn0    : std_logic_vector := "00000000000000000000000000000000000000000000000000000000000010000000000010000000"; -- abort
    constant test_btn1    : std_logic_vector := "01000000000000000000000000000000000000000000000000000000000000000000001000000000"; -- coffee
    constant test_btn2    : std_logic_vector := "00000000000000000000001000000000000000000000000000000000000000000000000000000000"; -- espresso
    constant test_btn3    : std_logic_vector := "00000000000000000000000000000000000000010000000000000000000000000000000000000000"; -- cappuccino
    constant test_state0  : std_logic_vector := "11000000000000000111111000000000001111110000000000000001111110000111111000000111"; -- IDLE
    constant test_state1  : std_logic_vector := "00111000000000000000000111110000000000001110000000000000000000000000000110000000"; -- BEAN_GRINDER
    constant test_state2  : std_logic_vector := "00000111111110000000000000001100000000000001111000000000000000000000000000000000"; -- WATER_PUMP
    constant test_state3  : std_logic_vector := "00000000000000000000000000000000000000000000000111100000000000000000000000000000"; -- MILK_PUMP
    constant test_state4  : std_logic_vector := "00000000000001111000000000000011110000000000000000011110000001111000000001111000"; -- CLEANING

    signal btn : std_logic_vector(3 downto 0);
    signal state : std_logic_vector(4 downto 0);

begin

    clk <= not clk after (0.5 us / g_CLK_MHZ);
    reset_n <= '0', '1' after (2.0 us / g_CLK_MHZ);
    cycle <= cycle + 1 after (1 us / g_CLK_MHZ);

    e_coffee_ctrl : entity work.ex04_coffee_ctrl
    port map (
        i_btn => btn,
        o_state => state,
        i_reset_n => reset_n,
        i_clk => clk--,
    );

    process
    begin
        btn <= (others => '0');
        wait until ( reset_n = '1' );

        for i in test_btn0'range loop
            wait until rising_edge(clk);
            -- set input from `ds` test vector
            btn(0) <= test_btn0(i);
            btn(1) <= test_btn1(i);
            btn(2) <= test_btn2(i);
            btn(3) <= test_btn3(i);
            wait until falling_edge(clk);
            -- check output to `qs` test vector
            assert ( state(0) = test_state0(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
            assert ( state(1) = test_state1(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
            assert ( state(2) = test_state2(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
            assert ( state(3) = test_state3(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
            assert ( state(4) = test_state4(i) ) report "error at clock cycle " & integer'image(cycle) severity error;
        end loop;

        wait;
    end process;

end architecture;
