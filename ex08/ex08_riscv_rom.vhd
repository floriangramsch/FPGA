--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-06-04
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex08_riscv_rom is
port (
    i_raddr : in    std_logic_vector(6 downto 0);
    o_rdata : out   std_logic_vector(31 downto 0);

    i_clk   : in    std_logic--;
);
end entity;

architecture arch of ex08_riscv_rom is

    type array_t is array (natural range <>) of std_logic_vector(31 downto 0);

    signal data : array_t(0 to 31) := (
        std_logic_vector'(X"a31b0" & "01011" & "0110111"),
        std_logic_vector'(X"70f" & "01011" & "000" & "01011" & "0010011"),
        std_logic_vector'(X"b9b50" & "01100" & "0110111"),
        std_logic_vector'(X"757" & "01100" & "000" & "01100" & "0010011"),
        std_logic_vector'(X"a5eb9" & "01101" & "0110111"),
        std_logic_vector'(X"ec2" & "01101" & "000" & "01101" & "0010011"),
        std_logic_vector'(X"101b6" & "01110" & "0110111"),
        std_logic_vector'(X"f44" & "01110" & "000" & "01110" & "0010011"),
        std_logic_vector'(X"1e0e8" & "01111" & "0110111"),
        std_logic_vector'(X"308" & "01111" & "000" & "01111" & "0010011"),

        std_logic_vector'("0000000" & "01100" & "01011" & "111" & "01100" & "0110011"),
        std_logic_vector'("0100000" & "01111" & "01110" & "000" & "01110" & "0110011"),
        std_logic_vector'("0000000" & "01110" & "01101" & "100" & "01101" & "0110011"),
        std_logic_vector'("0000000" & "01101" & "01100" & "000" & "01010" & "0110011"),

        others => (others => '0')--,
    );

begin

    process(i_clk)
    begin
    if rising_edge(i_clk) then
        -- ROM is byte addressable
        -- however address should be word (32-bit) aligned
        if ( i_raddr(1 downto 0) /= "00" ) then
            -- otherwise output invalid result
            o_rdata <= (others => 'X');
        else
            -- ignore 2 bits to get array index
            o_rdata <= data(to_integer(unsigned(i_raddr(6 downto 2))));
        end if;
        --
    end if; -- rising_edge
    end process;

end architecture;
