library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
   generic(
          N : positive := 32
          );
   port(
       CLK    : in std_logic;
       RESET  : in std_logic;
       WE     : in std_logic;
       PCN    : in std_logic_vector(N - 1 downto 0);
       PC_out : buffer std_logic_vector(N - 1 downto 0)
       );
end PC;

architecture Behavioral of PC is

begin
    
-- fetch the next command
fetch: process(CLK, RESET) is
begin
    if RESET = '1' then
        PC_out <= (others => '0');   
    elsif rising_edge(CLK) then
        if WE = '1' then
            PC_out <= PCN;
        end if;
    end if;
end process fetch;

end Behavioral;
