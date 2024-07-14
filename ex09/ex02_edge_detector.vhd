library ieee;
use ieee.std_logic_1164.all;

entity ex02_edge_detector is
generic (
    -- 0 - rising and falling edges
    -- > 0 - rising edge
    -- < 0 - falling edge
    g_EDGE : integer := +1--;
);
port (
    -- input
    i_d     : in    std_logic;
    -- ouput pulse of one clock cycle
    o_q     : out   std_logic;
    -- clock
    i_clk   : in    std_logic--;
);
end entity;

architecture arch of ex02_edge_detector is

    -- use a register (flip-flop) ...
    signal ff : std_logic;

begin

    process(i_clk)
    begin
    if rising_edge(i_clk) then
        -- ... to save the state of the input
        ff <= i_d;
        --
    end if;
    end process;

    -- detect rising edge
    gen_rising_edge : if g_EDGE > 0 generate
        -- generate a pulse signal when the state transitions
        -- from low at previous clock cycle to high at current clock cycle.
        o_q <= '1' when ( ff = '0' and i_d = '1' ) else '0';
    end generate;

    -- detect both rising and falling edges
    gen : if g_EDGE = 0 generate
        o_q <= ff xor i_d;
    end generate;

    -- detect falling edge
    gen_faling_edge : if g_EDGE < 0 generate
        o_q <= ff and not i_d;
    end generate;

end architecture;
