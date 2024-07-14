--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--                                 --
--    | R   SW     LEDs   |        --
--    | 0  0123  76543210 |        --
--    +-------------------+        --
--      |  ||||  |||-||||          --
--      |  ++++  |||-++++          --
--      |   |    |||-  |           --
-- we --+   |    |||-  +- rdata    --
--          |    |||+---- rvalid   --
--          |    ||+----- sdata    --
-- wdata ---+    |+------ we       --
--               +------- clock    --
--                                 --
entity uart_rx_top is
port (
    -- 8 light diods (active low)
    o_led_n     : out   std_logic_vector(7 downto 0) := (others => '1');
    -- 4 switches
    i_sw_n      : in    std_logic_vector(3 downto 0);

    -- external clock (12 MHz)
    i_clk       : in    std_logic;
    -- reset button (active low)
    i_reset_n   : in    std_logic--;
);
end entity;

architecture arch of uart_rx_top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

    signal clk : std_logic;

    constant c_DATA_BITS : integer := 4;
    -- serial data line
    signal sdata : std_logic;
    -- tx write
    signal tx_wdata : std_logic_vector(c_DATA_BITS-1 downto 0);
    signal tx_we, tx_wfull : std_logic;
    -- rx read
    signal rx_rdata : std_logic_vector(c_DATA_BITS-1 downto 0);
    signal rx_rack, rx_rempty : std_logic;

    signal btn : std_logic;

begin

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    -- generate slow clock
    e_clkdiv : entity work.ex03_clkdiv
    generic map (
        N => 12000000/8--, -- 250 ms
    )
    port map (
        o_clk => clk,
        i_reset_n => '1',
        i_clk => i_clk--,
    );

    e_uart_tx : entity work.uart_tx
    generic map (
        g_DATA_BITS => c_DATA_BITS,
        g_CpS => 4--, -- 4 clocks per symbol
    )
    port map (
        o_sdata     => sdata,

        i_wdata     => tx_wdata,
        i_we        => tx_we,
        o_wfull     => tx_wfull,

        i_reset_n   => '1',
        i_clk       => clk--,
    );

    e_uart_rx : entity work.uart_rx
    generic map (
        g_DATA_BITS => c_DATA_BITS,
        g_CpS => 4--, -- 4 clocks per symbol
    )
    port map (
        i_sdata     => sdata,

        o_rempty    => rx_rempty,
        i_rack      => rx_rack,
        o_rdata     => rx_rdata,

        i_reset_n   => '1',
        i_clk       => clk--,
    );

    led(7) <= clk;
    led(6) <= tx_we;
    led(5) <= sdata;
    led(4) <= not rx_rempty;

    -- use reset button as write enable
    e_edge_detector : entity work.ex02_edge_detector
    port map (
        i_d => i_reset_n,
        o_q => btn,
        i_clk => clk--,
    );

    process(clk)
    begin
    if rising_edge(clk) then
        -- write data from switches to tx_uart
        tx_wdata <= (others => '0');
        tx_we <= '0';
        if btn = '1' then
            tx_wdata <= sw(c_DATA_BITS-1 downto 0);
            tx_we <= '1';
            led(c_DATA_BITS-1 downto 0) <= (others => '0');
        end if;

        -- read from rx_uart to leds
        rx_rack <= '0';
        if ( rx_rempty = '0' ) then
            led(c_DATA_BITS-1 downto 0) <= rx_rdata;
            rx_rack <= '1';
        end if;

    end if;
    end process;

end architecture;
