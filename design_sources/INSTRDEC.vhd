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
		-- DP instructions
		when "00" =>
		case Funct is
		-- All DP Imm instructions, besides CMP
			when "10100-" | "10010-" | "10000-" | "11100-" =>
				RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; MemToReg <= '0'; NoWrite_In <= '0';
				if    Funct = "10100-" then ALUControl <= "00";
				elsif Funct = "10010-" then ALUControl <= "01";
				elsif Funct = "10000-" then ALUControl <= "10";
				elsif Funct = "11100-" then ALUControl <= "11";
				else ALUControl <= "--";
				end if;
			-- CMP Imm
			when "110101" =>
				RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "01"; MemToReg <= '-'; NoWrite_In <= '1';
			-- All DP Reg instructions, besides CMP
			when "00100-" | "00010-" | "00000-" | "01100-" =>
				RegSrc <= "00"; ALUSrc <= '0'; ImmSrc <= '-'; MemToReg <= '0'; NoWrite_In <= '0';
				if    Funct = "00100-" then ALUControl <= "00";
				elsif Funct = "00010-" then ALUControl <= "01";
				elsif Funct = "00000-" then ALUControl <= "10";
				elsif Funct = "01100-" then ALUControl <= "11";
				else ALUControl <= "--";
				end if;
			-- CMP Reg
			when "010101" =>
				RegSrc <= "00"; ALUSrc <= '0'; ImmSrc <= '-'; ALUControl <= "01"; MemToReg <= '-'; NoWrite_In <= '1';
			when others =>
			    RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "--"; MemToReg <= '-'; NoWrite_In <= '-';
		end case;
		-- Mem Imm instructions
		when "01" =>
		case Funct is
			when "011001" => RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "00"; MemToReg <= '1'; NoWrite_In <= '0';
			when "001001" => RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "01"; MemToReg <= '1'; NoWrite_In <= '0';
			when "011000" => RegSrc <= "10"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "00"; MemToReg <= '-'; NoWrite_In <= '0';
			when "010000" => RegSrc <= "10"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "01"; MemToReg <= '-'; NoWrite_In <= '0';
			when others   => RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "--"; MemToReg <= '-'; NoWrite_In <= '-';
		end case;
		-- Branching instructions
		when "10" =>
		case Funct is
			when "10----" => RegSrc <= "-1"; ALUSrc <= '1'; ImmSrc <= '1'; ALUControl <= "00"; MemToReg <= '0'; NoWrite_In <= '0';
			when others   => RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "--"; MemToReg <= '-'; NoWrite_In <= '-';
		end case;
		-- Other cases
		when others =>
			RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "--"; MemToReg <= '-'; NoWrite_In <= '-';
	end case;
end process;
end Behavioral;
