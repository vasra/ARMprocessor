library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity four_byte_adder is
    generic (N : integer := 32;
             offset : integer := 4
             );
    port ( CLK         : in std_logic;
           RESET       : in std_logic;
           address_in  : in std_logic_vector (N - 1 downto 0);
           PCPlus4     : out std_logic_vector (N - 1 downto 0)
           );
end four_byte_adder;

architecture Behavioral of four_byte_adder is

begin

add: process(CLK) is
    variable temp : unsigned(N - 1 downto 0); 
begin

if rising_edge(CLK) then
    if RESET = '1' then
        PCPlus4 <= (others => '0');
    else
        temp := unsigned(address_in) + 4;
        PCPlus4 <= std_logic_vector(temp);
    end if;
end if;

end process add;

end Behavioral;
