library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ONE_BIT_ADDER is  
    port(
        CIN   : in std_logic;
        A     : in std_logic;
        B     : in std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
        );
end ONE_BIT_ADDER;

architecture Behavioral of ONE_BIT_ADDER is
begin

SUM <= A xor B xor CIN;
CARRY <= (A and B) or (A and CIN) or (B and CIN);

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ADDER is
    generic(
        N : integer := 32
        );        
    port(
        CIN  : in std_logic_vector(N - 1 downto 0);
        A    : in std_logic_vector(N - 1 downto 0);
        B    : in std_logic_vector(N - 1 downto 0);
        S    : out std_logic_vector(N - 1 downto 0);
        Cout : out std_logic
        );
end ADDER;

architecture Behavioral of ADDER is

signal C : std_logic_vector(N - 1 downto 0);

component ONE_BIT_ADDER is
    port(
        CIN   : in std_logic;
        A     : in std_logic;
        B     : in std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
        );
end component;
    
begin

C(0) <= CIN;
G1: for I in 0 to N - 1 generate
    U1: ONE_BIT_ADDER port map(A(I), B(I), C(I), S(I), C(I + 1));
    end generate G1;
Cout <= C(4);

end Behavioral;