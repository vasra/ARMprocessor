library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_TB is
--  Port ( );
end ALU_TB;

architecture Behavioral of ALU_TB is

component ALU is
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        SrcA       : in std_logic_vector(31 downto 0);
        SrcB       : in std_logic_vector(31 downto 0);
        Shamt      : in std_logic_vector(4 downto 0);
        ALUResult  : out std_logic_vector(31 downto 0);
        ALUFlags   : out std_logic_vector(3 downto 0)
        );
end component ALU;

signal ALUControl : std_logic_vector(2 downto 0);
signal SrcA       : std_logic_vector(31 downto 0);
signal SrcB       : std_logic_vector(31 downto 0);
signal Shamt      : std_logic_vector(4 downto 0);
signal ALUResult  : std_logic_vector(31 downto 0);
signal ALUFlags   : std_logic_vector(3 downto 0);
        
constant CLK_PERIOD : time := 10 ns;

begin

uut : ALU port map(ALUControl, SrcA, SrcB, Shamt, ALUResult, ALUFlags);

ALUTest : process is
begin

end process;  
end Behavioral;
