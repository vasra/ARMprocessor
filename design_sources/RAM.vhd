library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
    generic(
        M : integer := 32;
        N : integer := 5
        );        
    port(
        CLK       : in std_logic;
        WE        : in std_logic;
        ALUResult : in std_logic_vector(M - 1 downto 0);
        WriteData : in std_logic_vector(M - 1 downto 0);
        RD        : out std_logic_vector(M - 1 downto 0)
        );
end RAM;

architecture Behavioral of RAM is

type RAM_array is array (2 ** N - 1 downto 0)
    of std_logic_vector(M - 1 downto 0);
    
signal RAM : RAM_array; 

begin


Block_RAM: process(CLK) is
begin
    if rising_edge(CLK) then
        if WE = '1' then
            -- A[N-1:0] = ALUResult[N+1:2]
            RAM(to_integer(unsigned(ALUResult(N + 1 downto 2)))) <= WriteData;
        end if;
    end if;
end process;

-- A[N-1:0] = ALUResult[N+1:2]
RD <= RAM(to_integer(unsigned(ALUResult(N + 1 downto 2))));

end Behavioral;
