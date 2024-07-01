
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ex02_edge_detector IS
	GENERIC (
		g_EDGE : POSITIVE := 1
	);
	PORT (
		-- input
		i_d : IN STD_LOGIC;
		-- output pulse of one clock cycle
		o_q : OUT STD_LOGIC;
		-- clock
		i_clk : IN STD_LOGIC--;
	);
END ENTITY;

ARCHITECTURE det OF ex02_edge_detector IS

	SIGNAL last_d : STD_LOGIC := '0';

BEGIN
	PROCESS (i_clk)
	BEGIN
		IF rising_edge(i_clk) THEN
			IF i_d = '1' AND last_d = '0' THEN
				o_q <= '1';
			ELSE
				o_q <= '0';
			END IF;
			last_d <= i_d;
		END IF;
	END PROCESS;
END ARCHITECTURE det;