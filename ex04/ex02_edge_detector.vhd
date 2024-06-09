LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ex02_edge_detector IS
	GENERIC (
		-- 0 - rising and falling edges
		-- > 0 - rising edge
		-- < 0 - falling edge
		g_EDGE : INTEGER := + 1--;
	);
	PORT (
		-- input
		i_d : IN STD_LOGIC;
		-- ouput pulse of one clock cycle
		o_q : OUT STD_LOGIC;
		-- clock
		i_clk : IN STD_LOGIC--;
	);
END ENTITY;

ARCHITECTURE arch OF ex02_edge_detector IS

	-- use a register (flip-flop) ...
	SIGNAL ff : STD_LOGIC;

BEGIN

	PROCESS (i_clk)
	BEGIN
		IF rising_edge(i_clk) THEN
			-- ... to save the state of the input
			ff <= i_d;
			--
		END IF;
	END PROCESS;

	-- detect rising edge
	gen_rising_edge : IF g_EDGE > 0 GENERATE
		-- generate a pulse signal when the state transitions
		-- from low at previous clock cycle to high at current clock cycle.
		o_q <= '1' WHEN (ff = '0' AND i_d = '1') ELSE
			'0';
	END GENERATE;

	-- detect both rising and falling edges
	gen : IF g_EDGE = 0 GENERATE
		o_q <= ff XOR i_d;
	END GENERATE;

	-- detect falling edge
	gen_faling_edge : IF g_EDGE < 0 GENERATE
		o_q <= ff AND NOT i_d;
	END GENERATE;

END ARCHITECTURE;