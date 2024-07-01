--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--                                --
--    | R   SW     LEDs   |       --
--    | 0  0123  76543210 |       --
--    +-------------------+       --
--      |  ||||  |||| |||         --
--      |  +++|  |||| +++         --
--      |   | |  ||||  |          --
-- r/w -+   | |  ||||  +- rdata   --
--          | |  ||||             --
--          | |  |||+- read mode  --
-- wdata ---+ |  ||+-- rempty     --
--            |  |+--- write mode --
-- r/w mode --+  +---- wfull      --
--                                --
entity scfifo_top is
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

architecture arch of scfifo_top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

    signal btn : std_logic;

    -- Declare a new signal for write enable
    signal we_signal : std_logic;
    signal rack_signal : std_logic;

begin

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    -- Assign the expression to the new signal
    we_signal <= led(6) and btn;
    rack_signal <= led(4) and btn;
    

--    led(3 downto 0) <= sw(3 downto 0);

    e_button : entity work.ex04_button_decoder
    generic map (
        T_SHORT => 12000000 / 40, -- 50 ms
        T_LONG => 12000000 / 4--, -- 500 ms
    )
    port map (
        i_btn => i_reset_n,
        o_single => btn,
        i_clk => i_clk--,
    );

    led(4) <= sw(3); -- read mode
    led(6) <= not sw(3); -- write mode

    e_fifo : entity work.scfifo
    generic map (
        -- 3 bits of data
        g_DATA_WIDTH => 3,
        g_ADDR_WIDTH => 2--,
    )
    port map (
        o_rdata     => led(2 downto 0),
        i_rack      => rack_signal,
        o_rempty    => led(5),

        i_wdata     => sw(2 downto 0),
        -- Use the new signal for i_we

        i_we        => we_signal,
        o_wfull     => led(7),

        i_reset_n   => '1',
        i_clk       => i_clk--,
    );

end architecture;
