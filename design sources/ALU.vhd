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

signal result : std_logic_vector(N - 1 downto 0);
begin

process(SrcA, SrcB, ALUControl) is
begin
    case ALUControl is
    when "0000" => -- ADD
        result <= std_logic_vector(signed(SrcA) + signed(SrcB));
        if (SrcA(N - 1) xor result(N - 1) = '1') and (SrcA(N - 1) xnor SrcB(N - 1) = '1') then
            ALUFlags(0) = '1';
        end if;
        ALUResult <= result;
    when "0001" => -- SUB
        result <= std_logic_vector(signed(SrcA) - signed(SrcB));
        if (SrcA(N - 1) xor result(N - 1) = '1') and (SrcA(N - 1) xnor SrcB(N - 1) = '0') then
            ALUFlags(0) = '1';
        end if;
        ALUResult <= result;
    when "0010" => -- CMP
        if signed(SrcA) - signed(SrcB) > 0 then
            ALUResult <= (others => '0');
            ALUResult(0) <= '1';
        else
            ALUResult <= (others => '0');
        end if;
    when "0011" => -- AND
        ALUResult <= SrcA and SrcB;
    when "0100" => -- XOR
        ALUResult <= SrcA xor SrcB;
    end case;
        
    if ALUResult(N - 1) = '1' then
        ALUFlags(3) <= '1';
    end if;
    if nor ALUResult = '1' then
        ALUFlags(2) <= '1';
    end if;
   
end process;
        
end Behavioral;
