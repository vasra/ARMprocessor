library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM is
    generic(
        M : integer := 32;
        N : integer := 6
        );
    port(
        PC : in std_logic_vector(M - 1 downto 0);
        RD : out std_logic_vector(M - 1 downto 0)
        );
end ROM;

architecture Behavioral of ROM is

signal A : std_logic_vector(N - 1 downto 0);

type ROM_type is array (0 to 2 ** N - 1) of std_logic_vector(M - 1 downto 0);
 constant instructions : ROM_type:=(
   "10000001100000001000000110000000", -- ADD
   "00000000000000001000000110000000", -- SUB
   "00000101001000000000000000000000", -- LDR
   "00000101000000000000000000000000", -- STR
   "00001010000000001000000000000000", -- B
   "00001011000000001000000000000000"  -- BL
  );
  
begin

-- A[N-1:0] = PC[N+1:2]
A(N - 1 downto 0) <= PC(N + 1 downto 2);
RD <= instructions(to_integer(unsigned(A)));
  
end Behavioral;
