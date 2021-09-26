library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PCLOGIC_TB is
--  Port ( );
end PCLOGIC_TB;

architecture Behavioral of PCLOGIC_TB is

component PCLOGIC is
    port(
        Rd          : in std_logic_vector(3 downto 0);
        Op1         : in std_logic;
        RegWrite_In : in std_logic;
        PCSrc_In    : out std_logic
        );
end component PCLOGIC;

signal Rd          : std_logic_vector(3 downto 0);
signal Op1         : std_logic;
signal RegWrite_In : std_logic;
signal PCSrc_In    : std_logic;

constant CLK_PERIOD : time := 10 ns;

begin

uut : PCLOGIC port map(Rd, Op1, RegWrite_In, PCSrc_In);

process is
begin
    Rd <= "1111"; RegWrite_In <= '0'; Op1 <= '0'; wait for CLK_PERIOD;
    Rd <= "1111"; RegWrite_In <= '1'; Op1 <= '0'; wait for CLK_PERIOD;
    Rd <= "1111"; RegWrite_In <= '1'; Op1 <= '1'; wait for CLK_PERIOD;
    Rd <= "1110"; RegWrite_In <= '1'; Op1 <= '0'; wait for CLK_PERIOD;
    Rd <= "1110"; RegWrite_In <= '0'; Op1 <= '0'; wait for CLK_PERIOD;
    Rd <= "1110"; RegWrite_In <= '0'; Op1 <= '1'; wait for CLK_PERIOD;
end process; 
end Behavioral;
