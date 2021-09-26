library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRDEC is
    port(
        Op         : in std_logic_vector(1 downto 0);
        Funct      : in std_logic_vector(5 downto 0);
        Instr11to4 : in std_logic_vector(7 downto 0); -- This input is necessary to differentiate between the MOV and LSL/ASR instructions
        RegSrc     : out std_logic_vector(1 downto 0);
        ALUSrc     : out std_logic;
        ImmSrc     : out std_logic;
        ALUControl : out std_logic_vector(2 downto 0);
        MemToReg   : out std_logic;
        NoWrite_In : out std_logic;
        Shamt      : out std_logic_vector(4 downto 0)
        );
end INSTRDEC;

architecture Behavioral of INSTRDEC is
begin

Decode : process(Op, Funct) is
    variable cmd : std_logic_vector(3 downto 0); -- the CMD field of the instruction
    variable sh  : std_logic_vector(1 downto 0); -- the SH field of the instruction
begin
    cmd := Funct(4 downto 1);
    sh  := Instr11to4(2 downto 1);
    case Op is
		-- DP instructions
		when "00" =>
		case Funct(5 downto 1) is
		-- All DP Imm instructions, besides CMP
			when "10100" | "10010" | "10000" | "11100" | "11101" | "11111" => 
				RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; MemToReg <= '0'; NoWrite_In <= '0'; Shamt <= (others => '-');
				if    cmd = "0100" then ALUControl <= "000"; -- ADD(S)-I
				elsif cmd = "0010" then ALUControl <= "001"; -- SUB(S)-I
				elsif cmd = "0000" then ALUControl <= "010"; -- AND
				elsif cmd = "0001" then ALUControl <= "011"; -- EOR
				elsif cmd = "1101" then ALUControl <= "100"; -- MOV
				elsif cmd = "1111" then ALUControl <= "101"; -- MVN
				else ALUControl <= "---";
				end if;
			-- CMP Imm
			when "11010" =>
				RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "001"; MemToReg <= '-'; NoWrite_In <= '1'; Shamt <= (others => '-');
			-- All DP Reg instructions, besides CMP
			when "00100" | "00010" | "00000" | "01100" | "01101" =>
				RegSrc <= "00"; ALUSrc <= '0'; ImmSrc <= '-'; MemToReg <= '0'; NoWrite_In <= '0'; Shamt <= (others => '-');
				if    cmd = "0100" then ALUControl <= "000"; -- ADD(S)-I
				elsif cmd = "0010" then ALUControl <= "001"; -- SUB(S)-I
				elsif cmd = "0000" then ALUControl <= "010"; -- AND
				elsif cmd = "0001" then ALUControl <= "011"; -- EOR
				elsif cmd = "1101" then
				    if Instr11to4 = "00000000" then ALUControl <= "100"; -- MOV
				    elsif sh = "00" and Instr11to4 /= "00000000" then ALUControl <= "110"; Shamt <= Instr11to4(7 downto 3); -- LSL
				    elsif sh = "10"  then ALUControl <= "111"; Shamt <= Instr11to4(7 downto 3); -- ASR
				    else ALUControl <= "---";
				    end if;
				elsif cmd = "1111" then ALUControl <= "101"; -- MVN
				else ALUControl <= "---";
				end if;
			-- CMP Reg
			when "01010" =>
				RegSrc <= "00"; ALUSrc <= '0'; ImmSrc <= '-'; ALUControl <= "001"; MemToReg <= '-'; NoWrite_In <= '1'; Shamt <= (others => '-');
			when others =>
			    RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "---"; MemToReg <= '-'; NoWrite_In <= '-'; Shamt <= (others => '-');
		end case;
		-- Mem Imm instructions
		when "01" =>
		case Funct is
			when "011001" => RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "000"; MemToReg <= '1'; NoWrite_In <= '0'; Shamt <= (others => '-');
			when "001001" => RegSrc <= "-0"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "001"; MemToReg <= '1'; NoWrite_In <= '0'; Shamt <= (others => '-');
			when "011000" => RegSrc <= "10"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "000"; MemToReg <= '-'; NoWrite_In <= '0'; Shamt <= (others => '-');
			when "010000" => RegSrc <= "10"; ALUSrc <= '1'; ImmSrc <= '0'; ALUControl <= "001"; MemToReg <= '-'; NoWrite_In <= '0'; Shamt <= (others => '-');
			when others   => RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "---"; MemToReg <= '-'; NoWrite_In <= '-'; Shamt <= (others => '-');
		end case;
		-- Branching instructions
		when "10" =>
		case Funct(5 downto 4) is
			when "10"   => RegSrc <= "-1"; ALUSrc <= '1'; ImmSrc <= '1'; ALUControl <= "000"; MemToReg <= '0'; NoWrite_In <= '0'; Shamt <= (others => '-');
			when others => RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "---"; MemToReg <= '-'; NoWrite_In <= '-'; Shamt <= (others => '-');
		end case;
		-- Other cases
		when others =>
			RegSrc <= "--"; ALUSrc <= '-'; ImmSrc <= '-'; ALUControl <= "---"; MemToReg <= '-'; NoWrite_In <= '-'; Shamt <= (others => '-');
	end case;
end process;
end Behavioral;
