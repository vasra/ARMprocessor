library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIRST_SRC_REG is
    generic(
           N : positive := 32
           );
    port(
        RegSrc      : in std_logic_vector(2 downto 0);
        instruction : in std_logic_vector(N - 1 downto 0);
        RegS        : out std_logic_vector(3 downto 0)
        );    
end FIRST_SRC_REG;

architecture Behavioral of FIRST_SRC_REG is

begin

-- if RegSrc(0) = 1, pick constant value of 15. Else, pick Rn field of instruction
RegS <= "1111" when RegSrc(0) = '1' else instruction(19 downto 16) when RegSrc(1) = '0';

end Behavioral;
