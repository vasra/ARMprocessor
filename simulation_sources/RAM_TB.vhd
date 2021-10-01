library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_TB is
--  Port ( );
end RAM_TB;

architecture Behavioral of RAM_TB is

component RAM is
    generic(
        M : integer := 32;
        N : integer := 5
        );        
    port(
        CLK       : in std_logic;
        WE        : in std_logic;
        ALUResult : in std_logic_vector(M - 1 downto 0);
        WriteData : in std_logic_vector(M - 1 downto 0);
        RD        : out std_logic_vector(M - 1 downto 0)
        );
end component RAM;

signal CLK       : std_logic;
signal WE        : std_logic;
signal ALUResult : std_logic_vector(31 downto 0);
signal WriteData : std_logic_vector(31 downto 0);
signal RD        : std_logic_vector(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

uut : RAM port map(CLK, WE, ALUResult, WriteData, RD);

CLK_process : process is
begin
    CLK <= '0'; wait for CLK_PERIOD;
    CLK <= '1'; wait for CLK_PERIOD;
end process;
 test : process is
 begin
    wait until(falling_edge(CLK));
    WE <= '1';
    ALUResult <= x"0000000E";
    WriteData <= x"0000D000";
    
    
end process;
end Behavioral;
