-- Signed Adder/Subtracter with Carry and Overflow
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDSUB is
    generic(
            N : integer := 32
            );
    port(
         ALUControl : in std_logic_vector(2 downto 0);
         SrcA       : in std_logic_vector(N - 1 downto 0);
         SrcB       : in std_logic_vector(N - 1 downto 0);
         ALUResult  : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end ADDSUB;

architecture Behavioral of ADDSUB is
begin

ADDSUB: process(SrcA, SrcB)
    variable A_s, B_s, S_s : signed(N + 1 downto 0);
begin
    A_s := signed('0' & SrcA(N - 1)& SrcA);
    B_s := signed('0' & SrcB(N - 1)& SrcB);
    
    if    ALUControl = "001" or ALUControl = "111" then S_s := A_s - B_s;
    elsif ALUControl = "000" then S_s := A_s + B_s;
    end if;
    
    ALUResult <= std_logic_vector(S_s(N - 1 downto 0));
    
    -- update the ALU flags
    ALUFlags(0) <= S_s(N) xor S_s(N - 1); -- V flag
    ALUFlags(1) <= S_s(N + 1);            -- C flag
    
    if S_s = 0 then ALUFlags(2) <= '1';   -- Z flag
               else ALUFlags(2) <= '0'; end if;

    if S_s < 0 then ALUFlags(3) <= '1';   -- N flag
               else ALUFlags(3) <= '0'; end if;
end process;

end Behavioral;

-- Shifter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SHIFTER is
    generic(
            N : integer := 32
            );
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        Shamt      : in std_logic_vector(4 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0)
        );
end SHIFTER;

architecture Behavioral of SHIFTER is

begin

SHIFTER: process(ALUControl, Shamt, SrcA)
    variable shamt_n : natural range 0 to N - 1;
    variable X_u     : unsigned(N - 1 downto 0);
    variable X_s     : signed(N - 1 downto 0);
begin
    shamt_n := to_integer(unsigned(Shamt));
    X_u := unsigned(SrcA);
    X_s := signed(SrcA);
    case ALUControl is
        when "110" =>
            ALUResult <= std_logic_vector(shift_left(X_u, shamt_n));   -- LSL
        when "111" =>
            ALUResult <= std_logic_vector(shift_right (X_s, shamt_n)); -- ASR
        when others =>
            ALUResult <= (others => '-');
    end case;
end process;

end Behavioral;

-- Unit that performs logical operations
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LOGICAL is
    generic(
            N : integer := 32
            );
    port(
         ALUControl : in std_logic_vector(2 downto 0);
         SrcA       : in std_logic_vector(N - 1 downto 0);
         SrcB       : in std_logic_vector(N - 1 downto 0);
         ALUResult  : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end LOGICAL;

architecture Behavioral of LOGICAL is

signal xorsig : std_logic_vector(N - 1 downto 0);
signal andsig : std_logic_vector(N - 1 downto 0);

begin

logical: for i in 0 to N - 1 generate
    xorsig(i) <= SrcA(i) xor SrcB(i);
    andsig(i) <= SrcA(i) and SrcB(i);
end generate;

ALUResult <= xorsig when ALUControl = "010" else
             andsig when ALUControl = "011";

-- N flag
ALUFlags(3) <= '1' when signed(xorsig) < 0  and ALUControl = "010" else
               '0' when signed(xorsig) >= 0 and ALUControl = "010" else
               '1' when signed(andsig) < 0  and ALUControl = "011" else
               '0' when signed(andsig) >= 0 and ALUControl = "011";
         
-- Z flag          
ALUFlags(2) <= '1' when signed(xorsig) = 0  and ALUControl = "010" else
               '0' when signed(xorsig) /= 0 and ALUControl = "010" else
               '1' when signed(andsig) = 0  and ALUControl = "011" else
               '0' when signed(andsig) /= 0 and ALUControl = "011";
        
-- C, V flags are always zero when performing logical operations
ALUFlags(1) <= '0';
ALUFlags(0) <= '0';
 
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MOVER is
    generic(
           N : positive := 32
           );
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0)
        );
end MOVER;

architecture Behavioral of MOVER is
begin
    ALUResult <= SrcB when ALUControl = "100" else not(SrcB) when ALUControl = "101";
end Behavioral;
    
-- The ALU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic(
            N : integer := 32
            );
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        Shamt      : in std_logic_vector(4 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0);
        ALUFlags   : out std_logic_vector(3 downto 0)
        );
end ALU;

architecture Behavioral of ALU is

component ADDSUB is
    port(
         ALUControl : in std_logic_vector(2 downto 0);
         SrcA       : in std_logic_vector(N - 1 downto 0);
         SrcB       : in std_logic_vector(N - 1 downto 0);
         ALUResult  : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end component ADDSUB;

component SHIFTER is
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        Shamt      : in std_logic_vector(4 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0)
        );
end component SHIFTER;

component LOGICAL is
    port(
         ALUControl : in std_logic_vector(2 downto 0);
         SrcA       : in std_logic_vector(N - 1 downto 0);
         SrcB       : in std_logic_vector(N - 1 downto 0);
         ALUResult  : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end component LOGICAL;

component MOVER is
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0)
        );
end component MOVER;
 
signal AddSubResult       : std_logic_vector(N - 1 downto 0);
signal ShiftResult        : std_logic_vector(N - 1 downto 0);
signal LogicalResult      : std_logic_vector(N - 1 downto 0);
signal MovResult          : std_logic_vector(N - 1 downto 0);
signal ALUFlagsSigAddSub  : std_logic_vector(3 downto 0);
signal ALUFlagsSigLogical : std_logic_vector(3 downto 0);

begin

ADDER_SUBBER  : ADDSUB   port map(ALUControl, SrcA, SrcB, AddSubResult, ALUFlagsSigAddSub);
SHIFT         : SHIFTER  port map(ALUControl, Shamt, SrcA, ShiftResult);
LOGIC         : LOGICAL  port map(ALUControl, SrcA, SrcB, LogicalResult, ALUFlagsSigLogical);
MOVE          : MOVER    port map(ALUControl, SrcB, MovResult);

process(SrcA, SrcB, ALUControl) is
begin
    if ALUControl = "000" or ALUControl = "001" then -- ADD/SUB
        ALUResult <= AddSubResult;
        ALUFlags  <= ALUFlagsSigAddSub;
    elsif ALUControl = "010" or ALUControl = "011" then -- AND/EOR
        ALUResult <= LogicalResult;
        ALUFlags  <= ALUFlagsSigLogical;
	elsif ALUControl = "100" then -- MOV
		ALUResult <= SrcB;
	elsif ALUControl = "101" then -- MVN
		ALUResult <= not(SrcB);
    elsif ALUControl = "110" or ALUControl = "111" then -- LSL/ASR
        ALUResult <= ShiftResult;
    end if;    
end process;
        
end Behavioral;
