library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONTROLUNIT is
    generic(
           N : positive := 32
           );
    port(
        -- inputs
        CLK   : in std_logic;
        RESET : in std_logic;    
        Instr : in std_logic_vector(N - 1 downto 0);
        Flags : in std_logic_vector(3 downto 0);

        -- InstrDec outputs
        RegSrc     : out std_logic_vector(1 downto 0);
        ALUSrc     : out std_logic;
        ImmSrc     : out std_logic;
        ALUControl : out std_logic_vector(2 downto 0);
        MemToReg   : out std_logic;
        Shamt      : out std_logic_vector(4 downto 0);
        
        -- FSM outputs
        IRWrite    : out std_logic;
        RegWrite   : out std_logic;
        MAWrite    : out std_logic;
        MemWrite   : out std_logic;
        FlagsWrite : out std_logic;
        PCSrc      : out std_logic_vector(1 downto 0);
        PCWrite    : out std_logic
        );
end CONTROLUNIT;

architecture Structural of CONTROLUNIT is

component INSTRDEC is
    port(
        Op         : in std_logic_vector(1 downto 0);
        Funct      : in std_logic_vector(5 downto 0);
        Instr11to4 : in std_logic_vector(7 downto 0);
        RegSrc     : out std_logic_vector(1 downto 0);
        ALUSrc     : out std_logic;
        ImmSrc     : out std_logic;
        ALUControl : out std_logic_vector(2 downto 0);
        MemToReg   : out std_logic;
        NoWrite_In : out std_logic;
        Shamt      : out std_logic_vector(4 downto 0)
        );
end component INSTRDEC;

component FSM_MOORE is
    port(
        CLK        : in std_logic;
        RESET      : in std_logic;
        Op         : in std_logic_vector(1 downto 0);
        SL         : in std_logic;
        Rd         : in std_logic_vector(3 downto 0);
        NoWrite_In : in std_logic;
        CondEx_In  : in std_logic;
        Funct      : in std_logic_vector(1 downto 0); -- The Instr[25:24] field, used to differentiate between the B and BL instructions
        PCWrite    : out std_logic;
        IRWrite    : out std_logic;
        RegWrite   : out std_logic;
        FlagsWrite : out std_logic;
        MAWrite    : out std_logic;
        MemWrite   : out std_logic;
        PCSrc      : out std_logic_vector(1 downto 0)
        );
end component FSM_MOORE;

component CONDLOGIC is
    port(
        Cond  : in std_logic_vector(3 downto 0);
        Flags : in std_logic_vector(3 downto 0);
        CondEx_In : out std_logic
        );
end component CONDLOGIC;

signal NoWrite_InSig : std_logic;
signal CondEx_InSig  : std_logic;

begin

DECODER     : INSTRDEC  port map(Instr(27 downto 26), Instr(25 downto 20), Instr(11 downto 4), 
                                 RegSrc, ALUSrc, ImmSrc, ALUControl, MemToReg, NoWrite_InSig, Shamt);
FSM         : FSM_MOORE port map(CLK, RESET, Instr(27 downto 26), Instr(20), Instr(15 downto 12), NoWrite_InSig, CondEx_InSig, Instr(25 downto 24),
                                 PCWrite, IRWrite, RegWrite, FlagsWrite, MAWrite, MemWrite, PCSrc);
CONDITIONAL : CONDLOGIC port map(Instr(31 downto 28), Flags, CondEx_InSig);

end Structural;
