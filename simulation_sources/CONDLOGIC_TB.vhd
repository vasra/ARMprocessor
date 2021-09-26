library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONDLOGIC_TB is
end CONDLOGIC_TB;

architecture Behavioral of CONDLOGIC_TB is

component CONDLOGIC is
    port(
        Cond      : in std_logic_vector(3 downto 0);
        Flags     : in std_logic_vector(3 downto 0);
        CondEx_In : out std_logic
        );
end component CONDLOGIC;

signal Cond      : std_logic_vector(3 downto 0);
signal Flags     : std_logic_vector(3 downto 0);
signal CondEx_In : std_logic;

constant CLK_PERIOD : time := 10 ns;

begin

uut : CONDLOGIC port map(Cond, Flags, CondEx_In);

test : process is
begin
    Flags <= "0000";
    Cond  <= "0000"; wait for CLK_PERIOD;
    Cond  <= "0001"; wait for CLK_PERIOD;
    Cond  <= "0010"; wait for CLK_PERIOD;
    Cond  <= "0011"; wait for CLK_PERIOD;
    Cond  <= "0100"; wait for CLK_PERIOD;
    Cond  <= "0101"; wait for CLK_PERIOD;
    Cond  <= "0110"; wait for CLK_PERIOD;
    Cond  <= "0111"; wait for CLK_PERIOD;
    Cond  <= "1000"; wait for CLK_PERIOD;
    Cond  <= "1001"; wait for CLK_PERIOD;
    Cond  <= "1010"; wait for CLK_PERIOD;
    Cond  <= "1011"; wait for CLK_PERIOD;
    Cond  <= "1100"; wait for CLK_PERIOD;
    Cond  <= "1101"; wait for CLK_PERIOD;
    Cond  <= "1110"; wait for CLK_PERIOD;
    Cond  <= "1111"; wait for CLK_PERIOD;
end process;
end Behavioral;