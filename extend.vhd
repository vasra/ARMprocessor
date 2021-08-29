library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity extend is
    port(
        ImmSrc      : in std_logic;
        instruction : in std_logic_vector(31 downto 0);
        ExtImm      : out std_logic_vector(31 downto 0)
        );
end extend;

architecture Behavioral of extend is

begin

ExtImm <= (31 downto 12 => '0') & instruction(11 downto 0)                    when ImmSrc = '0'  else
          (31 downto 26 => instruction(23)) & instruction(23 downto 0) & "00" when ImmSrc = '1';
          
end Behavioral;
