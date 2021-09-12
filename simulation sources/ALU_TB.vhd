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
        Shift_type : in std_logic_vector(1 downto 0);
        ALUResult  : out std_logic_vector(31 downto 0);
        ALUFlags   : out std_logic_vector(3 downto 0)
        );
end component ALU;

signal ALUControl : std_logic_vector(2 downto 0);
signal SrcA       : std_logic_vector(31 downto 0);
signal SrcB       : std_logic_vector(31 downto 0);
signal Shamt      : std_logic_vector(4 downto 0);
signal Shift_type : std_logic_vector(1 downto 0);
signal ALUResult  : std_logic_vector(31 downto 0);
signal ALUFlags   : std_logic_vector(3 downto 0);
        
constant CLK_PERIOD : time := 10 ns;

begin

uut : ALU port map(ALUControl, SrcA, SrcB, Shamt, Shift_type, ALUResult, ALUFlags);

ALUTest : process is
begin
	-- addition test
--	ALUControl <= "000"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
--	                     SrcA <= x"00FFFFFF"; SrcB <= x"00ABCD11"; wait for 1 * CLK_PERIOD;
						 
--	-- subtraction test
--	ALUControl <= "001"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
--	                     SrcA <= x"00FFFFFF"; SrcB <= x"00ABCD11"; wait for 1 * CLK_PERIOD;
--						 SrcA <= x"FFFFFFFF"; SrcB <= x"0FFFFFFF"; wait for 1 * CLK_PERIOD;
			
--	-- XOR test
--	ALUControl <= "010"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
--						 SrcA <= x"00000000"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
--						 SrcA <= x"F0F0F0F0"; SrcB <= x"0F0F0F0F"; wait for 1 * CLK_PERIOD;
	
    -- AND test	
--	ALUControl <= "011"; SrcA <= x"FFFFFFFF"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
--						 SrcA <= x"00000000"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
--						 SrcA <= x"F0F0F0F0"; SrcB <= x"0F0F0F0F"; wait for 1 * CLK_PERIOD;
						 
--    -- LSL test	
	ALUControl <= "100"; Shift_type <= "10"; Shamt <= "00010"; SrcA <= x"0000000F"; wait for 1 * CLK_PERIOD;
	
--	-- MOV test
--	ALUControl <= "101"; SrcA <= x"000000FF"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
	
--	-- MVN test
--	ALUControl <= "110"; SrcA <= x"000000FF"; SrcB <= x"FFFFFFFF"; wait for 1 * CLK_PERIOD;
	
--	-- CMP test
--	ALUControl <= "111"; SrcA <= x"000000F0"; SrcB <= x"0000000F"; wait for 1 * CLK_PERIOD;
--						 SrcA <= x"0000000F"; SrcB <= x"000000F0"; wait for 1 * CLK_PERIOD;
--						 SrcA <= x"0000000F"; SrcB <= x"0000000F"; wait for 1 * CLK_PERIOD;
end process;  
end Behavioral;
