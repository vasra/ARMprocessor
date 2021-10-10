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
        x"E2800005",
        x"E0811000",
        X"E3A02006",
        x"E1A02001",
        x"E242200A",
        x"E0422000",
        x"E1520005",
        x"E0033001",
        x"E0233001",
        x"E3A00000",
        x"E5803010",
        x"E5904010",
        x"E1530004",
        x"0AFFFFF5",
        x"E1A03004",
        x"EBFFFFF6",
	   -- Dummy values as placeholders
	   others => (others => '0')
      );
begin

-- A[N-1:0] = PC[N+1:2]
RD <= ROM(to_integer(unsigned(PC(N + 1 downto 2))));
  
end Behavioral;
