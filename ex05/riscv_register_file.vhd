--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY riscv_register_file IS
    PORT (
        -- read port 1
        i_raddr1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        o_rdata1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- read port 2
        i_raddr2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        o_rdata2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- write port
        i_waddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        i_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- write enable
        i_we : IN STD_LOGIC;
        i_clk : IN STD_LOGIC--;
    );
END ENTITY;

architecture rtl of riscv_register_file is
    
begin
    
    
    
end architecture rtl;