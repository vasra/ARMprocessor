library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

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
        ALUResult  : buffer std_logic_vector(31 downto 0);
        ALUFlags   : out std_logic_vector(3 downto 0)
        );
end component ALU;

signal CLK        : std_logic;
signal ALUControl : std_logic_vector(2 downto 0);
signal SrcA       : std_logic_vector(31 downto 0);
signal SrcB       : std_logic_vector(31 downto 0);
signal Shamt      : std_logic_vector(4 downto 0);
signal ALUResult  : std_logic_vector(31 downto 0);
signal ALUFlags   : std_logic_vector(3 downto 0);
        
constant CLK_PERIOD : time := 10 ns;

begin

CLK_process : process is
begin
    CLK <= '0'; wait for CLK_PERIOD;
    CLK <= '1'; wait for CLK_PERIOD;
end process;
 
uut : ALU port map(ALUControl, SrcA, SrcB, Shamt, ALUResult, ALUFlags);

ALUTest : process is
begin
    wait for 100 ns;
    wait until(falling_edge(CLK));
    
	-- ADD
	ALUControl <= "000"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait until(falling_edge(CLK));
                         SrcA <= x"00FFFFFF"; SrcB <= x"00ABCD11"; wait until(falling_edge(CLK));
						 
	-- SUB
	ALUControl <= "001"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait until(falling_edge(CLK)); 
	                     SrcA <= x"00FFFFFF"; SrcB <= x"00ABCD11"; wait until(falling_edge(CLK));
                         SrcA <= x"FFFFFFFF"; SrcB <= x"0FFFFFFF"; wait until(falling_edge(CLK));
			
    -- EOR
	ALUControl <= "010"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait until(falling_edge(CLK)); 
						 SrcA <= x"00000000"; SrcB <= x"FFFFFFFF"; wait until(falling_edge(CLK));
						 SrcA <= x"F0F0F0F0"; SrcB <= x"0F0F0F0F"; wait until(falling_edge(CLK));
	
    -- AND
	ALUControl <= "011"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait until(falling_edge(CLK)); 
						 SrcA <= x"00000000"; SrcB <= x"FFFFFFFF"; wait until(falling_edge(CLK)); 
						 SrcA <= x"F0F0F0F0"; SrcB <= x"0F0F0F0F"; wait until(falling_edge(CLK));
						 
    -- LSL
    ALUControl <= "110"; Shamt <= "00010"; SrcA <= x"0000000F"; wait until(falling_edge(CLK));
    
    -- ASR
    ALUControl <= "111"; Shamt <= "00010"; SrcA <= x"0000000F"; wait until(falling_edge(CLK));
	
	-- MOV test
	ALUControl <= "100"; SrcB <= x"FFFFFFFF"; wait until(falling_edge(CLK));
	
	-- MVN test
	ALUControl <= "101"; wait until(falling_edge(CLK));

	-- CMP test
	ALUControl <= "001"; SrcA <= x"000000F0"; SrcB <= x"0000000F"; wait until(falling_edge(CLK));
						 SrcA <= x"0000000F"; SrcB <= x"000000F0"; wait until(falling_edge(CLK));
						 SrcA <= x"0000000F"; SrcB <= x"0000000F"; wait until(falling_edge(CLK));
						 
	report("Tests completed");
	stop(2);
end process;  
end Behavioral;
