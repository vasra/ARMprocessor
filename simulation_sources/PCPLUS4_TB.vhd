library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

entity PCPLUS4_TB is
--  Port ( );
end PCPLUS4_TB;

architecture Behavioral of PCPLUS4_TB is

component PCPLUS4 is
    generic(
           N : integer := 32
           );
    port(
        PC      : in std_logic_vector (N - 1 downto 0);
        PCPlus4 : out std_logic_vector (N - 1 downto 0)
        );
end component PCPLUS4;

signal PC         : std_logic_vector (31 downto 0);
signal PCPlus4sig : std_logic_vector (31 downto 0);
signal CLK        : std_logic;

constant CLK_PERIOD : time := 10 ns;

begin

uut : PCPLUS4 port map(PC, PCPlus4sig);

CLK_process : process is
begin
    CLK <= '0'; wait for CLK_PERIOD / 2;
    CLK <= '1'; wait for CLK_PERIOD / 2;
end process;

plus4 : process is
begin
    PC <= x"00000000";
    
    for I in 0 to 63 loop 
        wait until(falling_edge(CLK));
        PC <= std_logic_vector(unsigned(PC) + 4);
        wait until(rising_edge(CLK));
    end loop;
    
    report "Tests completed";
    stop(2);
end process;
end Behavioral;
