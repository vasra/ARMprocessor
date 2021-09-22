library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PCLogic is
    port(
        Rd          : in std_logic_vector(3 downto 0);
        Op          : in std_logic_vector(1 downto 0);
        RegWrite_In : in std_logic;
        --CondEx_In   : in std_logic;
        PCSrc_in    : out std_logic
        );
end PCLogic;

architecture Behavioral of PCLogic is
begin
    PCSrc_in <= '1' when Rd = "1111" and RegWrite_In = '1' else
    PCSrc_in <= '0';
end Behavioral;