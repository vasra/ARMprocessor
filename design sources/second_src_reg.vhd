library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity second_src_reg is
    generic(N : integer := 32);
    port(
        RegSrc          : in std_logic_vector(N - 1 downto 0);
        instruction     : in std_logic_vector(N - 1 downto 0);
        RegS            : out std_logic_vector(3 downto 0)
        );    
end second_src_reg;

architecture Behavioral of second_src_reg is

begin

-- if RegSrc(1) = 0, pick Rm field of instruction. Else, pick Rd field
RegS <=  instruction(3 downto 0) when RegSrc(1) = '0' else instruction(15 downto 12) when RegSrc(1) = '1';

end Behavioral;
