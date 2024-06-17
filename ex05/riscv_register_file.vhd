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
    type Registers is array (0 to 31) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal register1 :Registers := (others => "00000000000000000000000000000000");
    signal output1 : std_logic_vector(31 downto 0);
    signal output2 : std_logic_vector(31 downto 0);
begin
o_rdata1 <= output1;
o_rdata2 <= output2;
    Process(i_clk)
    Begin 
    if rising_edge(i_clk) then
        --schreiben
        IF i_we = '1' and to_integer(unsigned(i_waddr)) /= 0 then
            register1(to_integer(unsigned(i_waddr))) <= i_wdata;
        END IF;

        -- lesen
        output1 <= register1(to_integer(unsigned(i_raddr1)));
        output2 <= register1(to_integer(unsigned(i_raddr2)));
    END IF;
    END Process;
    
    
    
end architecture rtl;