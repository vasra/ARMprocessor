-- Signed Adder/Subtracter with Carry and Overflow
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDSUB is
    generic(
            N : integer := 32
            );
    port(
         SUBorADD : in std_logic;
         A        : in std_logic_vector(N - 1 downto 0);
         B        : in std_logic_vector(N - 1 downto 0);
         S        : out std_logic_vector(N - 1 downto 0);
         Cout     : out std_logic;
         OV       : out std_logic
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
    
    -- Check the last bit of ALUControl. If it is '1', then do subtraction. Else, do addition.
    if (SUBorADD = '1') then S_s := A_s - B_s;
    else S_s := A_s + B_s;
    end if;
    
    S <= std_logic_vector(S_s(N - 1 downto 0));
    OV <= S_s(N) xor S_s(N - 1);
    Cout <= S_s(N + 1);
end process;

end Behavioral;

-- Barrel Shifter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BSHIFTER is
    generic(
            N : integer := 32
            );
    port(
        S          : in std_logic;
        shamt      : in std_logic_vector(4 downto 0);
        bshift_in  : in std_logic_vector(N - 1 downto 0);
        bshift_out : out std_logic_vector(N - 1 downto 0)
        );
end BSHIFTER;

architecture Behavioral of BSHIFTER is
begin

BSHIFTER: process(S, shamt, bshift_in)
    variable shamt_n : natural range 0 to 4;
    variable X_u     : unsigned(N - 1 downto 0);
    variable X_s     : signed(N - 1 downto 0);
begin
    shamt_n := to_integer(unsigned(shamt));
    X_u := unsigned (bshift_in);
    X_s := signed (bshift_in);
    case S is
        when '0' => bshift_out <= std_logic_vector(shift_left(X_u, shamt_n));   -- LSL
        when '1' => bshift_out <= std_logic_vector(shift_right (X_s, shamt_n)); -- ASR
        when others => bshift_out <= "----";
    end case;
end process;

end Behavioral;

-- Unit that performs comparisons
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity COMP is
    generic(
           N : positive := 32
           );
    port(
        A      : in std_logic_vector(N - 1 downto 0);
        B      : in std_logic_vector(N - 1 downto 0);
        EQorNE : out std_logic;
        GTorLE : out std_logic;
        LTorGE : out std_logic
        );
end COMP;

architecture Behavioral of COMP is
begin

COMP: process (A, B)
    variable A_s : signed(N - 1 downto 0);
    variable B_s : signed(N - 1 downto 0);
begin
    A_s := signed(A);
    B_s := signed(B);
    if (A_s = B_s) then EQorNE <= '1';
                   else EQorNE <= '0'; end if;
    if (A_s > B_s) then GTorLE <= '1';
                   else GTorLE <= '0'; end if;
    if (A_s < B_s) then LTorGE <= '1';
                   else LTorGE <= '0'; end if;
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
         OP     : in std_logic;
         A      : in std_logic_vector(N - 1 downto 0);
         B      : in std_logic_vector(N - 1 downto 0);
         Result : out std_logic_vector(N - 1 downto 0)
         );
end LOGICAL;

architecture Behavioral of LOGICAL is
begin

LOGICAL: process(A, B) is
begin
    case OP is
        when '0' => Result <= A and B; 
        when '1' => Result <= A xor B;
    end case;
end process;

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
         SUBorADD : in std_logic;
         A        : in std_logic_vector(N - 1 downto 0);
         B        : in std_logic_vector(N - 1 downto 0);
         S        : out std_logic_vector(N - 1 downto 0);
         Cout     : out std_logic;
         OV       : out std_logic
         );
end component ADDSUB;

component BSHIFTER is
    port(
        S          : in std_logic;
        shamt      : in std_logic_vector(4 downto 0);
        bshift_in  : in std_logic_vector(N - 1 downto 0);
        bshift_out : out std_logic_vector(N - 1 downto 0)
        );
end component BSHIFTER;

component COMP is
    port(
        A      : in std_logic_vector(N - 1 downto 0);
        B      : in std_logic_vector(N - 1 downto 0);
        EQorNE : out std_logic;
        GTorLE : out std_logic;
        LTorGE : out std_logic
        );
end component COMP;

component LOGICAL is
    port(
         OP     : in std_logic;
         A      : in std_logic_vector(N - 1 downto 0);
         B      : in std_logic_vector(N - 1 downto 0);
         Result : out std_logic_vector(N - 1 downto 0)
         );
end component LOGICAL;

signal AddSubResult  : std_logic_vector(N - 1 downto 0);
signal BShiftResult  : std_logic_vector(N - 1 downto 0);
signal LogicalResult : std_logic_vector(N - 1 downto 0);
signal Carry         : std_logic;
signal Overflow      : std_logic;
signal EQorNESig     : std_logic;
signal GTorLESig     : std_logic;
signal LTorGESig     : std_logic;

begin

ADDER_SUBBER  : ADDSUB   port map(ALUControl(0), SrcA, SrcB, AddSubResult, Carry, Overflow);
BARRELSHIFTER : BSHIFTER port map(ALUControl(0), Shamt, SrcA, BShiftResult);
COMPARATOR    : COMP     port map(SrcA, SrcB, EQorNESig, GTorLESig, LTorGESig);
LOGICAL_UNIT  : LOGICAL  port map(ALUControl(0), SrcA, SrcB, LogicalResult);


process(SrcA, SrcB, ALUControl) is
begin
    if ALUControl = "000" or ALUControl = "001" then -- add or subtract
        ALUResult <= AddSubResult;
        ALUFlags(1) <= Carry;
        ALUFlags(0) <= Overflow; 
    elsif ALUControl = "010" or ALUControl = "011" then -- logical operation
        ALUResult <= LogicalResult;
        ALUFlags(0) <= '0';
        ALUFlags(1) <= '0';
    elsif ALUControl = "100" or ALUControl = "101" then -- logical or arithmetic shift
        ALUResult <= BShiftResult;
    end if;    
end process;
        
end Behavioral;
