library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex02_debouncer is
generic (
-- number of clock cycles of stable signal
g_N : positive := 4--;
);
port (
-- input
i_d : in std_logic;
-- output debounced signal
o_q : out std_logic;
-- active low reset
i_reset_n : in std_logic;
-- clock
i_clk : in std_logic--;
);
end entity;

architecture deb of ex02_debouncer is

signal counter : integer := 0;
signal last_d : std_logic := '0';

begin 
	process(i_clk, i_reset_n)
	begin 
	if i_reset_n = '0' then 
		o_q <= '0';
		counter <= 0;
	
	elsif rising_edge(i_clk) then
		if (last_d = '1' and i_d = '0') or (last_d = '0' and i_d = '1') then
			counter <= 0;
		elsif counter >= g_N then 
			o_q <= i_d;
		else
			counter <= counter + 1;
		end if;
		last_d <= i_d;
	end if;
	end process;
end architecture deb;	
	
	
	
	
	
	
	
	
	
	
	
	