library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SHIFTER_TB is
--  Port ( );
end SHIFTER_TB;

architecture Behavioral of SHIFTER_TB is

component SHIFTER is
    generic(
            N : integer := 32
            );
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        Shamt      : in std_logic_vector(4 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0)
        );
end component SHIFTER;

signal ALUControl : std_logic_vector(2 downto 0);
signal Shamt      : std_logic_vector(4 downto 0);
signal SrcA       : std_logic_vector(31 downto 0);
signal ALUResult  : std_logic_vector(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

uut : SHIFTER port map (ALUControl, Shamt, SrcA, ALUResult);

test : process is
begin
    ALUControl <= "110"; Shamt <= "00010"; SrcA <= x"0000000F"; wait for 1 * CLK_PERIOD;
    ALUControl <= "111"; Shamt <= "00010"; SrcA <= x"0000000F"; wait for 1 * CLK_PERIOD;
end process;
end Behavioral;
