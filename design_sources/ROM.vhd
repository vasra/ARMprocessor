library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM is
    generic(
        M : positive := 32;
        N : positive := 6
        );
    port(
        PC : in std_logic_vector(M - 1 downto 0);
        RD : buffer std_logic_vector(M - 1 downto 0)
        );
end ROM;

architecture Behavioral of ROM is
    type ROM_array is array (0 to 2 ** N - 1) of std_logic_vector(M - 1 downto 0);
     constant ROM : ROM_array := (
        x"E3A00000",
        x"E3E01000",
        x"E0812000",
        x"E24230FF",
        x"EAFFFFF9",
        "00000000100001010100000000000011", -- ADDEQ R4, R5, R3
	   -- Dummy values as placeholders
	   others => (others => '0')
      );
begin

-- A[N-1:0] = PC[N+1:2]
RD <= ROM(to_integer(unsigned(PC(N + 1 downto 2))));
  
end Behavioral;
