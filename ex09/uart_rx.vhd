library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
generic (
g_DATA_BITS : positive := 8;
-- clocks per symbol = positive(1000000.0*CLK_MHZ)/BAUD_RATE
g_CpS : positive := 4--;
);
port (
-- serial data
-- - idle is logic high
-- - start bit is logic low
-- - least significant bit first
-- - stop bit is logic high
i_sdata : in std_logic;
-- parallel data interface
o_rdata : out std_logic_vector(g_DATA_BITS-1 downto 0);
i_rack : in std_logic;
o_rempty : out std_logic;
i_reset_n : in std_logic;
i_clk : in std_logic--;
);
end entity;

architecture arch0 of uart_rx is
type states is (IDLE, START, DATA, STOP);
signal state : states;

signal wdata : std_logic_vector(g_DATA_BITS-1 downto 0);
signal buf_vec : unsigned(g_DATA_BITS-1 downto 0) := (others => '0');
signal we, wfull : std_logic;
signal counter : integer range 0 to g_CpS;
signal l_counter : integer range 0 to g_DATA_BITS;
constant samplelength : integer := g_CpS/2;

begin

e_fifo : entity work.scfifo
    generic map (
        g_DATA_WIDTH => g_DATA_BITS,
        g_ADDR_WIDTH => g_DATA_BITS--,
    )
    port map (
        o_rdata         => o_rdata,
        i_rack          => i_rack,
        o_rempty        => o_rempty,

        i_wdata         => wdata,
        i_we            => we,
        o_wfull         => wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );

		
process(i_clk)

begin
	if(i_reset_n = '0') then
		state <= IDLE;
		we <= '0';
		counter <= 0;
	end if;
	

	if(rising_edge(i_clk)) then
		case state is
			when IDLE =>
				if(i_sdata = '0') then
					counter <= g_CpS - 1;
					l_counter <= g_DATA_BITS;
					buf_vec <= (others => '0');
					state <= START;
				end if;
			
			when START =>
				if(counter > 0) then
					counter <= counter - 1;
				else
					counter <= g_CpS;
					state <= DATA;
				end if;
			
			when DATA =>
				if(counter > 0) then
					counter <= counter - 1;
					if(counter = samplelength) then
						buf_vec(0) <= i_sdata;
					end if;
				else
					counter <= g_CpS;
					buf_vec <= buf_vec(0) & buf_vec(g_DATA_BITS-1 downto 1);
					if(l_counter > 0) then
						l_counter <= l_counter - 1;
					else
						state <= STOP;
					end if;
				end if;
				
			when STOP =>
				if(counter /= 0) then
					counter <= counter - 1;
				else
					counter <= g_CpS;
					we <= '1';
					wdata <= std_logic_vector(buf_vec);
					state <= IDLE;
				end if;	
			
			when others => 
					state <= IDLE;
			end case;
	end if;
end process;
end architecture;