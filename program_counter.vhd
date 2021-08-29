library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
   generic (N : integer := 32);
   port ( CLK         : in std_logic;
          RESET       : in std_logic;
          WE          : in std_logic;
          Command_in  : in std_logic_vector(N - 1 downto 0);
          Command_out : out std_logic_vector(N - 1 downto 0)
          );
end program_counter;

architecture Behavioral of program_counter is

begin

-- fetch the next command
fetch: process(CLK) is
begin

if rising_edge(CLK) then
    if RESET = '1' then
        Command_out <= (others => '0');
    else
        Command_out <= Command_in;
    end if;
end if;

end process fetch;

end Behavioral;
