library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WELOGIC_TB is
--  Port ( );
end WELOGIC_TB;

architecture Behavioral of WELOGIC_TB is

component WELOGIC is
	port(
		Op            : in std_logic_vector(1 downto 0);
		SL            : in std_logic;
		NoWrite_In    : in std_logic;
		RegWrite_In   : out std_logic;
		FlagsWrite_In : out std_logic;
		MemWrite_In   : out std_logic
		);
end component WELOGIC;

signal Op            : std_logic_vector(1 downto 0);
signal SL            : std_logic;
signal NoWrite_In    : std_logic;
signal RegWrite_In   : std_logic;
signal FlagsWrite_In : std_logic;
signal MemWrite_In   : std_logic;

constant CLK_PERIOD : time := 10 ns;

begin

uut : WELOGIC port map(Op, SL, NoWrite_In, RegWrite_In, FlagsWrite_In, MemWrite_In);

process is
begin
    Op <= "00"; SL <= '0'; NoWrite_In <= '0'; wait for CLK_PERIOD;
                SL <= '1'; NoWrite_In <= '0'; wait for CLK_PERIOD;
                SL <= '1'; NoWrite_In <= '1'; wait for CLK_PERIOD;
    
    Op <= "01"; SL <= '0'; NoWrite_In <= '0'; wait for CLK_PERIOD;
                SL <= '1'; NoWrite_In <= '0'; wait for CLK_PERIOD;
                
    Op <= "10"; wait for CLK_PERIOD;
    
    Op <= "11"; wait for CLK_PERIOD;
end process;
end Behavioral;