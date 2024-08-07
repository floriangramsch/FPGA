--
-- author : Alexandr Kozlinskiy
-- date : 2019-11-25
--

library ieee;
use ieee.std_logic_1164.all;

entity uart_tx is
generic (
    g_DATA_BITS : positive := 8;
    -- PARITY = 0 - none
    -- PARITY = 1 - odd
    -- PARITY = 2 - even
    g_PARITY : integer := 0;
    g_STOP_BITS : positive := 1;
    g_FIFO_ADDR_WIDTH : positive := 2;
    -- clocks per symbol = positive(1000000.0*CLK_MHZ)/BAUD_RATE
    g_CpS : positive--;
);
port (
    -- serial data
    -- - idle is logic high (pull up)
    -- - start bit is logic low
    -- - least significant bit first
    -- - stop bits are logic high
    o_sdata     : out   std_logic;
    -- output enable
    o_data_oe   : out   std_logic;

    i_wdata     : in    std_logic_vector(g_DATA_BITS-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of uart_tx is

    signal rdata : std_logic_vector(g_DATA_BITS-1 downto 0);
    signal rack, rempty : std_logic;

    signal cnt : integer range 0 to g_CpS-1;

    type state_t is (
        STATE_START,
        STATE_DATA,
        STATE_PARITY,
        STATE_STOP,
        STATE_IDLE--,
    );
    signal state : state_t;

    signal data_bit : integer range 0 to g_DATA_BITS-1;
    signal parity : std_logic;
    signal stop_bit : integer range 0 to g_STOP_BITS-1;

    function xor_reduce (
        v : std_logic_vector--;
    ) return std_logic is
        variable r : std_logic;
    begin
        r := '0';
        for i in v'range loop
            r := r xor v(i);
        end loop;
        return r;
    end function;

begin

    o_sdata <=
        -- start bit
        '0' when ( state = STATE_START ) else
        -- data bits
        rdata(data_bit) when ( state = STATE_DATA ) else
        -- parity bit
        parity when ( state = STATE_PARITY) else
        -- stop bit
        '1' when ( state = STATE_STOP ) else
        -- idle is logic high
        '1';
    o_data_oe <=
        '1' when ( state /= STATE_IDLE ) else
        '0';

    -- use fifo to buffer input data
    e_fifo : entity work.scfifo
    generic map (
        g_DATA_WIDTH => g_DATA_BITS,
        g_ADDR_WIDTH => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_rdata         => rdata,
        i_rack          => rack,
        o_rempty        => rempty,

        i_wdata         => i_wdata,
        i_we            => i_we,
        o_wfull         => o_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );

    parity <=
        -- total parity odd
        '1' xor xor_reduce(rdata) when ( g_PARITY = 1 ) else
        -- total parity even
        '0' xor xor_reduce(rdata) when ( g_PARITY = 2 ) else
        '-';

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n /= '1' ) then
        rack <= '0';
        cnt <= 0;
        state <= STATE_IDLE;
        --
    elsif rising_edge(i_clk) then
        rack <= '0';

        -- change state at symbol boundary
        if ( cnt = g_CpS-1 ) then
            case state is
            when STATE_START =>
                data_bit <= 0;
                stop_bit <= 0;
                state <= STATE_DATA;
                --
            when STATE_DATA =>
                if ( data_bit /= g_DATA_BITS-1) then
                    data_bit <= data_bit + 1;
                elsif ( g_PARITY /= 0 ) then
                    state <= STATE_PARITY;
                else
                    rack <= '1';
                    state <= STATE_STOP;
                end if;
                --
            when STATE_PARITY =>
                rack <= '1';
                state <= STATE_STOP;
                --
            when STATE_STOP =>
                if ( stop_bit /= g_STOP_BITS-1) then
                    stop_bit <= stop_bit + 1;
                elsif ( rempty = '0' ) then
                    -- continue transmission
                    state <= STATE_START;
                else
                    -- TODO : underrun error
                    state <= STATE_IDLE;
                end if;
                --
            when STATE_IDLE =>
                if ( rempty = '0' ) then
                    -- start transmission
                    state <= STATE_START;
                end if;
                --
            when others =>
                null;
            end case;

            cnt <= 0;
        else
            cnt <= cnt + 1;
        end if;
        --
    end if;
    end process;

end architecture;
