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
--        x"E2800005", -- MAIN_PROGRAM: ADD R0, #5
--        x"E0811000", -- ADD R1, R1, R0
--        X"E3A02006", -- MOVE: MOV R2, #6
--        x"E1A02001", -- MOV R2, R1
--        x"E3E00003", -- MVN R0, #3
--        x"E242200A", -- SUBTRACTIONS: SUB R2, R2, #10
--        x"E0422000", -- SUB R2, R2, R0 
--        x"E1520005", -- CMP R2, R5
--        x"E0033001", -- LOGICAL: AND R3, R3, R1
--        x"E0233001", -- EOR R3, R3, R1
--        x"E1A0600E", -- MOV R6, R14
--        x"E5803010", -- MEMORY: STR R3, [R0, #0x10]
--        x"E5904010", -- LDR R4, [R0, #0x10]
--        x"E3A03004", -- MOV R3, #4
--        x"E3A04004", -- MOV R4, #4
--        x"E1530004", -- CMP R3, R4
--        x"0A000000", -- BRANCH: BEQ BRANCH_AND_LINK
--        x"E1A03004", -- MOV R3, R4
--        x"EBFFFFF6", -- BRANCH_AND_LINK: BL LOGICAL
        x"E3A03004",
        x"E3A04004",
        x"E5843000",
        x"E5945000",
	   -- Dummy values as placeholders
	   others => (others => '0')
      );
begin

-- A[N-1:0] = PC[N+1:2]
RD <= ROM(to_integer(unsigned(PC(N + 1 downto 2))));
  
end Behavioral;
