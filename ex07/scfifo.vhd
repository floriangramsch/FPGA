LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY scfifo IS
    GENERIC (
        g_DATA_WIDTH : POSITIVE := 8;
        g_ADDR_WIDTH : POSITIVE := 4
    );
    PORT (
        o_rdata : OUT STD_LOGIC_VECTOR(g_DATA_WIDTH - 1 DOWNTO 0);
        i_rack : IN STD_LOGIC;
        o_rempty : OUT STD_LOGIC;
        i_wdata : IN STD_LOGIC_VECTOR(g_DATA_WIDTH - 1 DOWNTO 0);
        i_we : IN STD_LOGIC;
        o_wfull : OUT STD_LOGIC;
        i_reset_n : IN STD_LOGIC;
        i_clk : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE rtl OF scfifo IS
    CONSTANT DEPTH : INTEGER := 2 ** g_ADDR_WIDTH;
    TYPE fifo_array IS ARRAY (0 TO DEPTH - 1) OF STD_LOGIC_VECTOR(g_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL fifo_buffer : fifo_array;
    SIGNAL read_ptr, write_ptr : UNSIGNED(g_ADDR_WIDTH - 1 DOWNTO 0);
    SIGNAL fifo_count : UNSIGNED(g_ADDR_WIDTH DOWNTO 0);
    SIGNAL internal_rempty : STD_LOGIC; -- Internal signal for read empty
    SIGNAL internal_wfull : STD_LOGIC; -- Internal signal for write full
BEGIN
    o_rempty <= internal_rempty;
    o_wfull <= internal_wfull;

    internal_rempty <= '1' WHEN fifo_count = 0 ELSE
        '0';
    internal_wfull <= '1' WHEN fifo_count = DEPTH ELSE
        '0';

    PROCESS (i_clk)
    BEGIN
        IF rising_edge(i_clk) THEN
            IF i_reset_n = '0' THEN
                read_ptr <= (OTHERS => '0');
                write_ptr <= (OTHERS => '0');
                fifo_count <= (OTHERS => '0');
            ELSE
                -- Write operation
                IF i_we = '1' AND internal_wfull = '0' THEN
                    fifo_buffer(to_integer(write_ptr)) <= i_wdata;
                    write_ptr <= write_ptr + 1;
                    fifo_count <= fifo_count + 1;
                END IF;

                -- Read operation
                IF i_rack = '1' AND internal_rempty = '0' THEN
                    o_rdata <= fifo_buffer(to_integer(read_ptr));
                    read_ptr <= read_ptr + 1;
                    fifo_count <= fifo_count - 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;