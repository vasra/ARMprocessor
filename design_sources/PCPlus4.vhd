library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PCPLUS4 is
    generic(
           N : integer := 32
           );
    port(
        PC      : in std_logic_vector (N - 1 downto 0);
        PCPlus4 : out std_logic_vector (N - 1 downto 0)
        );
end PCPLUS4;

architecture Behavioral of PCPLUS4 is

begin

--PCPlus4 <= std_logic_vector(unsigned(PC) + 4);
PCPlus4 <= std_logic_vector(unsigned(PC) + x"00000004");
end Behavioral;
