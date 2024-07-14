--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
-- FIFO
-- - Single Clock
-- - Fall-Through (Show-Ahead)
--
entity scfifo is
generic (
    g_DATA_WIDTH : positive := 8;
    g_ADDR_WIDTH : positive := 4--;
);
port (
    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_rack      : in    std_logic;
    o_rempty    : out   std_logic;

    i_wdata     : in    std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of scfifo is

    -- define an array (buffer) of appropriate size for FIFO entries
    type buf_t is array (natural range <>) of std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal buf : buf_t(2**g_ADDR_WIDTH-1 downto 0);

    -- and two registers for read and write pointers
    signal rptr, wptr : unsigned(g_ADDR_WIDTH-1 downto 0) := (others => '0');

    signal rempty, wfull : std_logic;

begin

    -- when read and write pointers are equals the FIFO is in empty state
    rempty <=
        '1' when ( rptr = wptr ) else
        '0';
    o_rempty <= rempty;

    -- when write pointer is just behind the read pointer the FIFO is full
    wfull <=
        '1' when ( wptr + 1 = rptr ) else
        '0';
    o_wfull <= wfull;

    -- implement clocked process
    process(i_clk, i_reset_n)
    begin
    -- with appropriate reset logic
    if ( i_reset_n = '0' ) then
        rptr <= (others => '0');
        wptr <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        -- that writes to a buffer and updates read/write pointers
        if ( wfull = '0' and i_we = '1' ) then
            buf(to_integer(wptr)) <= i_wdata;
        end if;

        -- the read and write pointer should be incremented
        -- when read acknowledge and write enable are asserted respectively
        -- (take into account read empty and write full signals)
        if ( rempty = '0' and i_rack = '1' ) then
            rptr <= rptr + 1;
        end if;
        if ( wfull = '0' and i_we = '1' ) then
            wptr <= wptr + 1;
        end if;
        --
    end if; -- rising_edge
    end process;

    -- the assignment to read data port should be performed outside clocked process
    -- such that current oldest value is seen on that port
    o_rdata <= buf(to_integer(rptr));

end architecture;
