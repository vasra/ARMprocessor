library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity extend_tb is
--  Port ( );
end extend_tb;

architecture Behavioral of extend_tb is

component extend is
    port(
        ImmSrc      : in std_logic;
        instruction : in std_logic_vector(31 downto 0);
        ExtImm      : out std_logic_vector(31 downto 0)
        );
end component extend;

signal ImmSrc      : std_logic;
signal instruction : std_logic_vector(31 downto 0);
signal ExtImm      : std_logic_vector(31 downto 0);

begin

uut: extend port map(ImmSrc, instruction, ExtImm);

test: process is
begin
    ImmSrc <= '0'; instruction <= (others => '1'); wait for 20 ns;
    ImmSrc <= '1'; instruction <= (31 downto 26 => '0') & "10101010101010101010101010"; wait for 20 ns;
    ImmSrc <= '1'; instruction <= (31 downto 26 => '0') & "00001010101010101010101010"; wait for 20 ns;
end process;
end Behavioral;
