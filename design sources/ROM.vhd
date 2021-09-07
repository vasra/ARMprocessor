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
        RD : out std_logic_vector(M - 1 downto 0)
        );
end ROM;

architecture Behavioral of ROM is
    type ROM_array is array (0 to 21) of std_logic_vector(M - 1 downto 0);
     constant ROM : ROM_array := (
       -- ALU immediate instructions
       "111000101001--------0000--------", -- ADD(S)-I
       "111000100101--------0000--------", -- SUB(S)-I
       "111000100001--------0000--------", -- AND(S)-I
       "111000111001--------0000--------", -- OR(S)-I
       "111000100011--------0000--------", -- XOR(S)-I
       "111000110101--------0000--------", -- CMP Rn, #imm8
       "1110001110100000----0000--------", -- MOV Rd, #imm8
       "1110001111100000----00000000----", -- MVN Rd, #imm8 
       "1110000110100000---------000----", -- LSL Rd, Rm, #shamt5
       "1110000110100000---------100----", -- ASR Rd, Rm, #shamt5
       
       -- ALU register instructions
       "111000001001--------00000000----", -- ADD(S)-R
       "111000000101--------00000000----", -- SUB(S)-R
       "111000000001--------00000000----", -- AND(S)-R
       "111000011001--------00000000----", -- OR(S)-R
       "111000000011--------00000000----", -- XOR(S)-R
       "111000010101--------00000000----", -- CMP Rn, Rm
       
       -- Memory instructions
       "111001011001--------------------", -- LDR Rd, [Rn, #imm12]
       "111001010001--------------------", -- LDR Rd, [Rn, #-imm12]
       
       "111001011000--------------------", -- STR Rd, [Rn, #imm12]
       "111001010000--------------------", -- STR Rd, [Rn, #-imm12]
       
       -- Branching instructions
       "11101010------------------------", -- B label
       "11101011------------------------"  -- BL label
      );
begin

-- A[N-1:0] = PC[N+1:2]
RD <= ROM(to_integer(unsigned(PC(N + 1 downto 2))));
  
end Behavioral;
