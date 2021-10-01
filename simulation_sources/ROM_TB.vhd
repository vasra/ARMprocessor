library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

entity ROM_TB is
--  Port ( );
end ROM_TB;

architecture Behavioral of ROM_TB is

component ROM is
    generic(
        M : positive := 32;
        N : positive := 6
        );
    port(
        PC : in std_logic_vector(M - 1 downto 0);
        RD : buffer std_logic_vector(M - 1 downto 0)
        );
end component ROM;

signal  PC : std_logic_vector(31 downto 0);
signal  RD : std_logic_vector(31 downto 0);
signal CLK : std_logic;

constant CLK_PERIOD : time := 10 ns;

begin

uut : ROM port map(PC, RD);

CLK_process : process is
begin
    CLK <='0'; wait for CLK_PERIOD / 2;
    CLK <='1'; wait for CLK_PERIOD / 2;
end process;

test : process is
begin
    PC <= x"00000000";
    wait until(falling_edge(CLK));
    
    for I in 0 to 3 loop
        PC <= std_logic_vector(unsigned(PC) + 4);
        wait until(falling_edge(CLK));
    end loop;
    stop(2);
end process;
end Behavioral;
