library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic(N : integer := 32);
    port(
        ALUSrc : in std_logic;
        ALUControl : in std_logic_vector(1 downto 0);
        SrcA: in std_logic_vector(N - 1 downto 0);
        SrcB: in std_logic_vector(N - 1 downto 0)
        );
end ALU;

architecture Behavioral of ALU is

begin


end Behavioral;
