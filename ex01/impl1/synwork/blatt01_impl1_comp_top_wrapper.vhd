--
-- Synopsys
-- Vhdl wrapper for top level design, written on Mon May 20 20:27:55 2024
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wrapper_for_ex01_top_adder is
   port (
      o_led_n : out std_logic_vector(7 downto 0);
      i_sw_n : in std_logic_vector(3 downto 0);
      i_clk : in std_logic;
      i_reset_n : in std_logic
   );
end wrapper_for_ex01_top_adder;

architecture arch of wrapper_for_ex01_top_adder is

component ex01_top_adder
 port (
   o_led_n : out std_logic_vector (7 downto 0);
   i_sw_n : in std_logic_vector (3 downto 0);
   i_clk : in std_logic;
   i_reset_n : in std_logic
 );
end component;

signal tmp_o_led_n : std_logic_vector (7 downto 0);
signal tmp_i_sw_n : std_logic_vector (3 downto 0);
signal tmp_i_clk : std_logic;
signal tmp_i_reset_n : std_logic;

begin

o_led_n <= tmp_o_led_n;

tmp_i_sw_n <= i_sw_n;

tmp_i_clk <= i_clk;

tmp_i_reset_n <= i_reset_n;



u1:   ex01_top_adder port map (
		o_led_n => tmp_o_led_n,
		i_sw_n => tmp_i_sw_n,
		i_clk => tmp_i_clk,
		i_reset_n => tmp_i_reset_n
       );
end arch;
