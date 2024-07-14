library ieee;
use ieee.std_logic_1164.all;

entity uart_rx is
    generic (
    g_DATA_BITS : positive := 8;
    -- clocks per symbol = positive(1000000.0*CLK_MHZ)/BAUD_RATE
    g_CpS : positive--;
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

    architecture RTL of uart_rx is 
    TYPE state_type is ( idle , start, data, stop);
    Signal state : State_type;

    Begin

    Process(i_clk, i_reset_n)
    Begin
    if (i_reset_n = '1') THEN
        --reset
    
    ELSIF rising_edge(i_clk) THEN
        CASE state IS 
        When idle =>
            If i_sdata = '1' then 
                state <= idle;

            ElSIF i_sdata = '0' then  
                state <= start;
            END IF;
        When start => 

        When data => 

        When stop =>
            state <= idle;
        When others => 

        END CASE;
    END IF;
    END Process;
    END RTL;