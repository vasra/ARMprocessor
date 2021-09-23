library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PCLOGIC is
    port(
        Rd          : in std_logic_vector(3 downto 0);
        Op          : in std_logic;
        RegWrite_In : in std_logic;
        --CondEx_In   : in std_logic;
        PCSrc_In    : out std_logic
        );
end PCLOGIC;

architecture Behavioral of PCLOGIC is
begin
    PCSrc_In <= '1' when Rd = "1111" and RegWrite_In = '1' else '0';
end Behavioral;