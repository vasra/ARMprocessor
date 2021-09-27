library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INSTRDEC_TB is
--  Port ( );
end INSTRDEC_TB;

architecture Behavioral of INSTRDEC_TB is

component INSTRDEC is
    port(
        Op         : in std_logic_vector(1 downto 0);
        Funct      : in std_logic_vector(5 downto 0);
        Instr11to4 : in std_logic_vector(7 downto 0); -- This input is necessary to differentiate between the MOV and LSL/ASR instructions
        RegSrc     : out std_logic_vector(1 downto 0);
        ALUSrc     : out std_logic;
        ImmSrc     : out std_logic;
        ALUControl : out std_logic_vector(2 downto 0);
        MemToReg   : out std_logic;
        NoWrite_In : out std_logic
        );
end component INSTRDEC;

signal Op         : std_logic_vector(1 downto 0);
signal Funct      : std_logic_vector(5 downto 0);
signal Instr11to4 : std_logic_vector(7 downto 0);
signal RegSrc     : std_logic_vector(1 downto 0);
signal ALUSrc     : std_logic;
signal ImmSrc     : std_logic;
signal ALUControl : std_logic_vector(2 downto 0);
signal MemToReg   : std_logic;
signal NoWrite_In : std_logic;

constant CLK_PERIOD : time := 10 ns;

begin

uut : INSTRDEC port map(Op, Funct, Instr11to4, RegSrc, ALUSrc, ImmSrc, ALUControl, MemToReg, NoWrite_In);

process is
begin
    -- Data processing instructions
    Op <= "00";
    -- Immediate instructions
    Funct <= "101000"; wait for CLK_PERIOD; -- ADD(S)-I
    Funct <= "101001"; wait for CLK_PERIOD; -- ADD(S)-I
    Funct <= "100100"; wait for CLK_PERIOD; -- SUB(S)-I
    Funct <= "100101"; wait for CLK_PERIOD; -- SUB(S)-I
    Funct <= "100000"; wait for CLK_PERIOD; -- AND(S)-I
    Funct <= "100001"; wait for CLK_PERIOD; -- AND(S)-I
    Funct <= "111000"; wait for CLK_PERIOD; -- OR(S)-I
    Funct <= "111001"; wait for CLK_PERIOD; -- OR(S)-I
    Funct <= "100010"; wait for CLK_PERIOD; -- EOR(S)-I
    Funct <= "100011"; wait for CLK_PERIOD; -- EOR(S)-I
    Funct <= "110101"; wait for CLK_PERIOD; -- CMP-I
    Funct <= "111010"; wait for CLK_PERIOD; -- MOV
    Funct <= "111011"; wait for CLK_PERIOD; -- MOV
    Funct <= "111110"; wait for CLK_PERIOD; -- MVN
    Funct <= "111110"; wait for CLK_PERIOD; -- MVN
    
    -- Register instructions
    Funct <= "001000"; wait for CLK_PERIOD; -- ADD(S)
    Funct <= "001001"; wait for CLK_PERIOD; -- ADD(S)
    Funct <= "000100"; wait for CLK_PERIOD; -- SUB(S)
    Funct <= "000101"; wait for CLK_PERIOD; -- SUB(S)
    Funct <= "000000"; wait for CLK_PERIOD; -- AND(S)
    Funct <= "000001"; wait for CLK_PERIOD; -- AND(S)
    Funct <= "011000"; wait for CLK_PERIOD; -- OR(S) 
    Funct <= "011001"; wait for CLK_PERIOD; -- OR(S) 
    Funct <= "000010"; wait for CLK_PERIOD; -- EOR(S)
    Funct <= "000011"; wait for CLK_PERIOD; -- EOR(S)
    Funct <= "010101"; wait for CLK_PERIOD; -- CMP
    Funct <= "011010";                      -- MOV
    Instr11to4 <= (others => '0'); wait for CLK_PERIOD;
    
    Instr11to4 <= "00001000"; wait for CLK_PERIOD; -- LSL
    Instr11to4 <= "00001100"; wait for CLK_PERIOD; -- ASR
    
    -- Memory instructions
    Op <= "01";
    Funct <= "011001"; wait for CLK_PERIOD; -- LDR
    Funct <= "001001"; wait for CLK_PERIOD; -- LDR
    Funct <= "011000"; wait for CLK_PERIOD; -- STR
    Funct <= "010000"; wait for CLK_PERIOD; -- STR
    
    -- Branch instructions
    Op <= "10";
    Funct <= "100000"; wait for CLK_PERIOD; -- B
    Funct <= "100001"; wait for CLK_PERIOD;
    Funct <= "100010"; wait for CLK_PERIOD;
    Funct <= "100011"; wait for CLK_PERIOD;
    Funct <= "100100"; wait for CLK_PERIOD;
    Funct <= "100101"; wait for CLK_PERIOD;
    Funct <= "100110"; wait for CLK_PERIOD;
    Funct <= "100111"; wait for CLK_PERIOD;
    Funct <= "101000"; wait for CLK_PERIOD;
    Funct <= "101001"; wait for CLK_PERIOD;
    Funct <= "101010"; wait for CLK_PERIOD;
    Funct <= "101010"; wait for CLK_PERIOD;
    Funct <= "101011"; wait for CLK_PERIOD;
    Funct <= "101100"; wait for CLK_PERIOD;
    Funct <= "101101"; wait for CLK_PERIOD;
    Funct <= "101111"; wait for CLK_PERIOD;
    Funct <= "000000"; wait for CLK_PERIOD;

end process;
end Behavioral;
