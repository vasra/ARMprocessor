library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FOUR_BYTE_ADDER is
    generic(
           N : integer := 32
           );
    port(
        PC      : in std_logic_vector (N - 1 downto 0);
        PCPlus4 : out std_logic_vector (N - 1 downto 0)
        );
end FOUR_BYTE_ADDER;

architecture Behavioral of FOUR_BYTE_ADDER is

begin

PCPlus4 <= std_logic_vector(unsigned(PC) + 4);

end Behavioral;
