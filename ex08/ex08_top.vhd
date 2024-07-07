--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex08_top is
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

architecture arch of ex08_top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');
    signal sw : std_logic_vector(i_sw_n'range);

    signal clk : std_logic;

    signal rom_raddr : std_logic_vector(31 downto 0);
    signal rom_rdata : std_logic_vector(31 downto 0);
    signal ram_addr, ram_rdata, ram_wdata : std_logic_vector(31 downto 0);
    signal ram_we : std_logic;
    signal rf_wdata : std_logic_vector(31 downto 0);

begin

    -- output led's are active low
    o_led_n <= not led;
    -- input switches are active low
    sw <= not i_sw_n;

    e_clkdiv : entity work.ex03_clkdiv
    generic map (
        N => 12000000/4--, -- 500 ms
    )
    port map (
        o_clk => clk,
        i_reset_n => i_reset_n,
        i_clk => i_clk--,
    );

    e_rom : entity work.ex08_riscv_rom
    port map (
        i_raddr => rom_raddr(6 downto 0),
        o_rdata => rom_rdata,
        i_clk => clk--,
    );

    e_cpu : entity work.ex08_riscv_cpu
    port map (
        o_rom_raddr => rom_raddr,
        i_rom_rdata => rom_rdata,

        o_rf_wdata => rf_wdata,

        i_reset_n => i_reset_n,
        i_clk => clk--,
    );

    led <= rf_wdata(led'range);

end architecture;
