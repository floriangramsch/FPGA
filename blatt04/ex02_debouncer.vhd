LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ex02_debouncer IS
	GENERIC (
		-- number of clock cycles of stable signal
		g_N : POSITIVE := 4--;
	);
	PORT (
		-- input
		i_d : IN STD_LOGIC;
		-- output debounced signal
		o_q : OUT STD_LOGIC;
		-- active low reset
		i_reset_n : IN STD_LOGIC;
		-- clock
		i_clk : IN STD_LOGIC--;
	);
END ENTITY;

ARCHITECTURE arch OF ex02_debouncer IS

	-- previous state of the input
	SIGNAL ff : STD_LOGIC;

	-- use a counter to measure the time during which the input is stable
	SIGNAL cnt : INTEGER RANGE 0 TO g_N - 1;

BEGIN

	PROCESS (i_clk, i_reset_n)
	BEGIN
		IF (i_reset_n = '0') THEN
			-- implement reset logic
			o_q <= '0';
			ff <= '0';
			cnt <= 0;
			--
		ELSIF rising_edge(i_clk) THEN
			ff <= i_d;

			IF (i_d /= ff) THEN
				-- reset the counter when the input changes
				cnt <= 0;
			ELSIF (cnt = g_N - 1) THEN
				-- if the signal is stable and counter reached required number of cycles,
				-- copy the input to the output
				o_q <= i_d;
				--
			ELSE
				-- otherwise increment the counter
				cnt <= cnt + 1;
			END IF;

			--
		END IF; -- rising_edge
	END PROCESS;

END ARCHITECTURE;