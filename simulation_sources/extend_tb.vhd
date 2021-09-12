library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EXTEND_TB is
--  Port ( );
end EXTEND_TB;

architecture Behavioral of EXTEND_TB is

component EXTEND is
    port(
        IMMSRC  : in std_logic;
        DATA_IN : in std_logic_vector(23 downto 0);
        EXTIMM  : out std_logic_vector(31 downto 0)
        );
end component EXTEND;

signal IMMSRC  : std_logic;
signal DATA_IN : std_logic_vector(23 downto 0);
signal EXTIMM  : std_logic_vector(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

uut : EXTEND port map(IMMSRC, DATA_IN, EXTIMM);

process is
begin
    -- extend a positive number
    IMMSRC <= '1'; DATA_IN <= ('0', others => '1'); wait for 1 * CLK_PERIOD;
    IMMSRC <= '0'; DATA_IN <= ('0', others => '1'); wait for 1 * CLK_PERIOD;
    
    -- extend a negative number
    IMMSRC <= '1'; DATA_IN <= (others => '1'); wait for 1 * CLK_PERIOD;
    IMMSRC <= '0'; DATA_IN <= (others => '1'); wait for 1 * CLK_PERIOD;
end process;
end Behavioral;
