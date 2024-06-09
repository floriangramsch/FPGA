library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ex03_lfsr8 is
generic (
-- LFSR reset value
g_SEED : std_logic_vector(7 downto 0) := (others => '0')
);
port (
-- output LFSR value
o_lfsr : out std_logic_vector(7 downto 0);
-- output period of this LFSR
o_period : out std_logic_vector(7 downto 0);
-- input reset (active low)
i_reset_n : in std_logic;
-- input clock
i_clk : in std_logic
);
end entity;

architecture lsfr8 of ex03_lfsr8 is

signal lfsr : std_logic_vector(7 downto 0) := g_SEED;
signal feedback : std_logic := '0';
signal period_cntr : std_logic_vector(7 downto 0) := (others => '0');


begin
feedback <= lfsr(7) XNOR lfsr(5) XNOR lfsr(4) XNOR lfsr(3);
o_lfsr <= lfsr;

	-- lfsr bearbeiten
	process(i_clk, i_reset_n)
	begin
	if i_reset_n = '0' then 
		lfsr <= g_SEED;
	
	elsif rising_edge(i_clk) then
		lfsr(7 downto 1) <= lfsr(6 downto 0);
		lfsr(0) <= feedback;
	
	end if;
	end process;
	
	--periode messen
	process(i_clk)
	begin
	if rising_edge(i_clk) then
		if lfsr = g_SEED then 
			o_period <= period_cntr;
			period_cntr <= (others => '0');
		else 
			period_cntr <= std_logic_vector(unsigned(period_cntr) + 1);
		end if;
	end if;
	end process;
	
end architecture lsfr8;






