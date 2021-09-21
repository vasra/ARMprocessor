library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRDEC is
    port(
        Op         : in std_logic_vector(1 downto 0);
        Funct      : in std_logic_vector(5 downto 0);
        RegSrc     : out std_logic_vector(1 downto 0);
        ALUSrc     : out std_logic;
        ImmSrc     : out std_logic;
        ALUControl : out std_logic_vector(1 downto 0);
        MemToReg   : out std_logic;
        NoWrite_In : out std_logic
        );
end INSTRDEC;

architecture Behavioral of INSTRDEC is

begin

Decode : process is
begin
    case Op is
        when "01" =>
            case Funct is
                when "011001" => RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "00"; MemToReg <= '1'; NoWrite_In <= '0';
                when "001001" => RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "01"; MemToReg <= '1'; NoWrite_In <= '0';
                when "011000" => RegSrc <= "10"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "00"; MemToReg <= '-'; NoWrite_In <= '0';
                when "010000" => RegSrc <= "10"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "01"; MemToReg <= '-'; NoWrite_In <= '0';
            end case;
        when "10" =>
            case Funct is
                when "10----" => RegSrc <= "-1"; ALUSrc <= '1'; ImmSrc <= '1'; ALUControl <= "00"; MemToReg <= '0'; NoWrite_In <= '0';
            end case;

--            case Funct is
--                when "10110-" | "10010-" | "110101" | "10000-" | "11100-" =>
--                    RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "00"; MemToReg   <= '0'; NoWrite_In <= '0';
--            end case;
    end case;
end process;
end Behavioral;
