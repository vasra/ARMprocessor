library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SECOND_SRC_REG is
    generic(
           N : positive := 32
           );
    port(
        RegSrc       : in std_logic_vector(2 downto 0);
        instruction1 : in std_logic_vector(N - 1 downto 0);
        instruction2 : in std_logic_vector(N - 1 downto 0);
        RegS         : out std_logic_vector(3 downto 0)
        );    
end SECOND_SRC_REG;

architecture Behavioral of SECOND_SRC_REG is

begin

-- if RegSrc(1) = 0, pick Rm field of instruction. Else, pick Rd field
RegS <=  instruction1(3 downto 0) when RegSrc(1) = '0' else instruction2(15 downto 12) when RegSrc(1) = '1';

end Behavioral;
