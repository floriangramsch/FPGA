--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex00_and is
port (
    i_a     : in    std_logic;
    i_b     : in    std_logic;
    o_and   : out   std_logic
);
end entity;

architecture arch0 of ex00_and is
begin

    -- use logic operator
    o_and <= i_a and i_b;

end architecture;

architecture arch1 of ex00_and is
begin

    -- use when/else
    o_and <= '1' when ( i_a = '1' and i_b = '1' ) else '0';

end architecture;

architecture arch2 of ex00_and is
begin

    -- this implementation uses process

    -- combinational process, i.e not clocked process,
    -- must have sensitivity list containing all signals that are used as inputs
    process(i_a, i_b)
    begin
        o_and <= '0';
        -- note that if/else can only be used inside process block
        if ( i_a = '1' and i_b = '1' ) then
            o_and <= '1';
        else
            o_and <= '0';
        end if;
    end process;

end architecture;
