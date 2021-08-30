library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic(
        N : integer := 32
        );
    port(
        ALUSrc     : in std_logic;
        ALUControl : in std_logic_vector(3 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0);
        ALUFlags   : out std_logic_vector(3 downto 0)
        );
end ALU;

architecture Behavioral of ALU is

begin

process(SrcA, SrcB, ALUControl) is
    case(ALUControl) is
    when "0000" =>
        ALUResult <= std_logic_vector(signed(SrcA) + signed(SrcB));
    when "0001" =>
        ALUResult <= std_logic_vector(signed(SrcA) - signed(SrcB));
    when "0010" =>
        if signed(SrcA) > signed(SrcB) then
            ALUResult <= "00000001";
        else
            ALUResult <= "00000000";
        end if;
    when "0011" =>
        ALUResult <= SrcA and SrcB;
    when "0100" =>
        ALUResult <= SrcA xor SrcB;
    end case;
end process;
        
end Behavioral;
