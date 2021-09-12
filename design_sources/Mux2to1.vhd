library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2TO1 is
    generic(
           N : positive := 32
           );
    port(
        Src    : in std_logic;
        A      : in std_logic_vector(N - 1 downto 0);
        B      : in std_logic_vector(N - 1 downto 0);
        Result : out std_logic_vector(N - 1 downto 0)
        );
end MUX2TO1;

architecture Behavioral of MUX2TO1 is

begin

Result <= A when Src = '0' else B when Src = '1';

end Behavioral;
