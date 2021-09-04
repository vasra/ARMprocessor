library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DEST_REG is
    generic(
           N : positive := 32
           );
    port(
        RegSrc      : in std_logic_vector(2 downto 0);
        instruction : in std_logic_vector(N - 1 downto 0);
        RegD        : out std_logic_vector(3 downto 0)
        );    
end DEST_REG;

architecture Behavioral of DEST_REG is

begin

-- if RegSrc(2) = 1, pick constant value of 14. Else, pick Rd field of instruction
RegD <= "1110" when RegSrc(2) = '1' else instruction(15 downto 12) when RegSrc(2) = '0';

end Behavioral;
