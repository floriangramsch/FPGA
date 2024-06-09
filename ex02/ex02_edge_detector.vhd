
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex02_edge_detector is
port (
	-- input
	i_d : in std_logic; 
	-- output pulse of one clock cycle
	o_q : out std_logic;
	-- clock
	i_clk : in std_logic--;
	);
end entity;

architecture det of ex02_edge_detector is

signal last_d :std_logic := '0';

begin
	process(i_clk)
	begin
	if rising_edge(i_clk) then
		if i_d = '1' and last_d = '0' then
			o_q <= '1';
		else 
			o_q <= '0';
		end if;
	last_d <= i_d;
	end if;
	end process;
end architecture det;
		