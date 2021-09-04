library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALUMUX is
    generic(
        N : integer := 32
        );        
    port(
        ALUSrc : in std_logic;
        A2     : in std_logic_vector(N - 1 downto 0);
        ExtImm : in std_logic_vector(N - 1 downto 0);
        SrcB   : out std_logic_vector(N - 1 downto 0)
        );
end ALUMUX;

architecture Behavioral of ALUMUX is
begin
 
SrcB <= A2 when ALUSrc = '0' else ExtImm when ALUSrc = '1';

end Behavioral;
