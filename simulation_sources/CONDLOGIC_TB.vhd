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

test : process is
begin
end process;
end Behavioral;