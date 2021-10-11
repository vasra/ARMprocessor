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
        x"E2800005", -- ADD R0, #5
        x"E0811000", -- ADD R1, R1, R0
        X"E3A02006", -- MOV R2, #6
        x"E1A02001", -- MOV R2, R1
        x"E242200A", -- SUB R2, R2, #10
        x"E0422000", -- SUB R2, R2, R0 
        x"E1520005", -- CMP R2, R5
        x"E0033001", -- AND R3, R3, R1
        x"E0233001", -- EOR R3, R3, R1
        x"E3A00000", -- MOV R0, #0
        x"E5803010", -- STR R3, [R0, #0x10]
        x"E5904010", -- LDR R4, [R0, #0x10]
        x"E1530004", -- CMP R3, R4
        x"0AFFFFF5", -- BEQ SUBTRACTIONS
        x"E1A03004", -- MOV R3, R4
        x"EBFFFFF6", -- BL LOGICAL
	   -- Dummy values as placeholders
	   others => (others => '0')
      );
begin

-- A[N-1:0] = PC[N+1:2]
RD <= ROM(to_integer(unsigned(PC(N + 1 downto 2))));
  
end Behavioral;
