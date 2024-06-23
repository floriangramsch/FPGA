--

library ieee;
use ieee.std_logic_1164.all;

package rv32i_pkg is

    -- see riscv-spec-v2.2.pdf table "RV32I Base Instruction Set"

    -- R-type
    constant OP_c       : std_logic_vector(6 downto 0) := "0110011";

    -- I-type
    constant OP_IMM_c   : std_logic_vector(6 downto 0) := "0010011";
    constant JALR_c     : std_logic_vector(6 downto 0) := "1100111";
    constant LOAD_c     : std_logic_vector(6 downto 0) := "0000011";

    -- S-type
    constant STORE_c    : std_logic_vector(6 downto 0) := "0100011";

    -- B-type
    constant BRANCH_c   : std_logic_vector(6 downto 0) := "1100011";

    -- U-type
    constant LUI_c      : std_logic_vector(6 downto 0) := "0110111";
    constant AUIPC_c    : std_logic_vector(6 downto 0) := "0010111";

    -- J-type
    constant JAL_c      : std_logic_vector(6 downto 0) := "1101111";

end package;
