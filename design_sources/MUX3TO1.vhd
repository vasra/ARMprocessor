library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX3TO1 is
    generic(
           N : positive := 32
           );
    port(
        Src     : in std_logic_vector(1 downto 0);
        SrcA    : in std_logic_vector(N - 1 downto 0);
        SrcB    : in std_logic_vector(N - 1 downto 0);
        SrcC    : in std_logic_vector(N - 1 downto 0);
        DataOut : out std_logic_vector(N - 1 downto 0)
        );
end MUX3TO1;

architecture Behavioral of MUX3TO1 is

begin

DataOut <= SrcA when Src = "00" else
           SrcB when Src = "11" else
           SrcC when Src = "10";
           
end Behavioral;
