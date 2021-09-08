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
         A          : in std_logic_vector(N - 1 downto 0);
         B          : in std_logic_vector(N - 1 downto 0);
         S          : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end ADDSUB;

architecture Behavioral of ADDSUB is
begin

ADDSUB: process(A, B)
    variable A_s, B_s, S_s : signed(N + 1 downto 0);
    --variable A_u, B_u, S_u : unsigned(N + 1 downto 0);
begin
    A_s := signed('0' & A(N - 1)& A);
    B_s := signed('0' & B(N - 1)& B);
    --A_u := unsigned('0' & A(N - 1)& A);
    --B_u := unsigned('0' & B(N - 1)& B);
    
    if    ALUControl = "001" then S_s := A_s - B_s;
    elsif ALUControl = "000" then S_s := A_s + B_s;
    end if;
    
    S <= std_logic_vector(S_s(N - 1 downto 0));
    ALUFlags(0) <= S_s(N) xor S_s(N - 1);
    ALUFlags(1) <= S_s(N + 1);
    
    if S_s = 0 then ALUFlags(2) <= '1';
               else ALUFlags(2) <= '0'; end if;

    if S_s < 0 then ALUFlags(3) <= '1';
               else ALUFlags(3) <= '0'; end if;
end process;

end Behavioral;

-- Barrel Shifter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SHIFTER is
    generic(
            N : integer := 32
            );
    port(
        shamt      : in std_logic_vector(4 downto 0);
        bshift_in  : in std_logic_vector(N - 1 downto 0);
        bshift_out : out std_logic_vector(N - 1 downto 0)
        );
end SHIFTER;

architecture Behavioral of SHIFTER is
begin

SHIFTER: process(shamt, bshift_in)
    variable shamt_n : natural range 0 to 4;
    variable X_u     : unsigned(N - 1 downto 0);
    variable X_s     : signed(N - 1 downto 0);
begin
    shamt_n := to_integer(unsigned(shamt));
    X_u := unsigned (bshift_in);
    X_s := signed (bshift_in);
    case bshift_in(6 downto 5) is -- check the "sh" field of the instruction to determine which shifting will take place
        when "00" => bshift_out <= std_logic_vector(shift_left(X_u, shamt_n));   -- LSL
        when "10" => bshift_out <= std_logic_vector(shift_right (X_s, shamt_n)); -- ASR
        when others => bshift_out <= (others => '-');
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
         A          : in std_logic_vector(N - 1 downto 0);
         B          : in std_logic_vector(N - 1 downto 0);
         Result     : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end LOGICAL;

architecture Behavioral of LOGICAL is

signal xorsig : std_logic_vector(N - 1 downto 0);
signal andsig : std_logic_vector(N - 1 downto 0);

begin

logical: for i in 0 to N - 1 generate
    xorsig(i) <= A(i) xor B(i);
    andsig(i) <= A(i) and B(i);
end generate;

Result <= xorsig when ALUControl = "010" else
          andsig when ALUControl = "011";

-- N flag
ALUFlags(3) <= '1' when signed(xorsig) < 0 and ALUControl = "010" else
               '0' when signed(andsig) < 0 and ALUControl = "011";
         
-- Z flag          
ALUFlags(2) <= '1' when signed(xorsig) = 0 and ALUControl = "010" else
               '0' when signed(andsig) = 0 and ALUControl = "011";
        
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
        SrcA       : in std_logic_vector(N - 1 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0)
        );
end MOVER;

architecture Behavioral of MOVER is
begin
    ALUResult <= SrcA when ALUControl = "111";
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
         A          : in std_logic_vector(N - 1 downto 0);
         B          : in std_logic_vector(N - 1 downto 0);
         S          : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end component ADDSUB;

component SHIFTER is
    port(
        shamt      : in std_logic_vector(4 downto 0);
        bshift_in  : in std_logic_vector(N - 1 downto 0);
        bshift_out : out std_logic_vector(N - 1 downto 0)
        );
end component SHIFTER;

component LOGICAL is
    port(
         ALUControl : in std_logic_vector(2 downto 0);
         A          : in std_logic_vector(N - 1 downto 0);
         B          : in std_logic_vector(N - 1 downto 0);
         Result     : out std_logic_vector(N - 1 downto 0);
         ALUFlags   : out std_logic_vector(3 downto 0)
         );
end component LOGICAL;

component MOVER is
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0)
        );
end component MOVER;

signal AddSubResult        : std_logic_vector(N - 1 downto 0);
signal BShiftResult        : std_logic_vector(N - 1 downto 0);
signal LogicalResult       : std_logic_vector(N - 1 downto 0);
signal MovResult           : std_logic_vector(N - 1 downto 0);
signal Carry               : std_logic;
signal Overflow            : std_logic;
signal ALUFlagsSigAddSub   : std_logic_vector(3 downto 0);
signal ALUFlagsSigLogical  : std_logic_vector(3 downto 0);

begin

ADDER_SUBBER  : ADDSUB   port map(ALUControl, SrcA, SrcB, AddSubResult, ALUFlagsSigAddSub);
SHIFTER_COMP  : SHIFTER port map(Shamt, SrcA, BShiftResult);
LOGICAL_UNIT  : LOGICAL  port map(ALUControl, SrcA, SrcB, LogicalResult, ALUFlagsSigLogical);
MOV           : MOVER port map(ALUControl, SrcA, SrcB, MovResult);

process(SrcA, SrcB, ALUControl) is
begin
    if ALUControl = "000" or ALUControl = "001" then -- add or subtract
        ALUResult <= AddSubResult;
        ALUFlags <= ALUFlagsSigAddSub;
    elsif ALUControl = "010" or ALUControl = "011" then -- logical operation
        ALUResult <= LogicalResult;
        ALUFlags  <= ALUFlagsSigLogical;
    elsif ALUControl = "100" or ALUControl = "101" then -- logical or arithmetic shift
        ALUResult <= BShiftResult;
    -- TODO
    elsif ALUControl = "110" then -- comparison
        ALUResult <= AddSubResult;
        ALUFlags(1) <= Carry;
        ALUFlags(0) <= Overflow;
    end if;    
end process;
        
end Behavioral;
