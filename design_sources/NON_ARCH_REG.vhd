library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NON_ARCH_REG is
    generic(
           N : positive := 32
           );
    port(
        CLK     : in std_logic;
        RESET   : in std_logic;
        WE      : in std_logic;
        DataIn  : in std_logic_vector(N - 1 downto 0);
        DataOut : buffer std_logic_vector(N - 1 downto 0)
        );
end NON_ARCH_REG;

architecture Behavioral of NON_ARCH_REG is

begin

reg : process(CLK, RESET) is
begin
    if RESET = '1' then
        DataOut <= (others => '0');
    elsif rising_edge(CLK) then
        DataOut <= DataIn;
    end if;
end process;
end Behavioral;
