library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SR is
    generic(
        N : integer := 4
        );        
    port(
        CLK       : in std_logic;
        ALUFlags  : in std_logic_vector(N - 1 downto 0);
        Flags     : out std_logic_vector(N - 1 downto 0)
        );
end SR;

architecture Behavioral of SR is
begin

process(CLK) is
begin
    if rising_edge(CLK) then
        Flags <= ALUFlags;
    end if;
end process;
end Behavioral;
