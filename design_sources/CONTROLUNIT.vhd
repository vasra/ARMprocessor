library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONTROLUNIT is
    generic(
           N : positive := 32
           );
    port(
        -- inputs
        CLK        : in std_logic;
        RESET      : in std_logic;
        Instr      : in std_logic_vector(N - 1 downto 0);
        Flags      : in std_logic_vector(3 downto 0);

        -- outputs
        RegSrc     : out std_logic_vector(1 downto 0);
        ALUSrc     : out std_logic;
        ImmSrc     : out std_logic;
        ALUControl : out std_logic_vector(1 downto 0);
        MemToReg   : out std_logic;
        MemWrite   : out std_logic;
        FlagsWrite : out std_logic;
        RegWrite   : out std_logic;
        PCSrc      : out std_logic
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
            ALUControl : out std_logic_vector(1 downto 0);
            MemToReg   : out std_logic;
            NoWrite_In : out std_logic
            );
    end component INSTRDEC;
    
    component WELOGIC is
        port(
            Op            : in std_logic_vector(1 downto 0);
            SL            : in std_logic;
            NoWrite_In    : in std_logic;
            RegWrite_In   : out std_logic;
            FlagsWrite_In : out std_logic;
            MemWrite_In   : out std_logic
            );
    end component WELOGIC;
    
    component PCLOGIC is
        port(
            Rd          : in std_logic_vector(3 downto 0);
            Op1         : in std_logic;
            RegWrite_In : in std_logic;
            PCSrc_In    : out std_logic
            );
    end component PCLOGIC;
    
    component CONDLOGIC is
        port(
            Cond  : in std_logic_vector(3 downto 0);
            Flags : in std_logic_vector(3 downto 0);
            CondEx_In : out std_logic
            );
    end component CONDLOGIC;
    
    signal NoWrite_InSig    : std_logic;
    signal CondEx_InSig     : std_logic;
    signal FlagsWrite_InSig : std_logic;
    signal MemWrite_InSig   : std_logic;
    signal PCSrc_InSig      : std_logic;
    signal RegWrite_InSig   : std_logic;

begin

DECODER     : INSTRDEC  port map(Instr(27 downto 26), Instr(25 downto 20), Instr(11 downto 4), RegSrc, ALUSrc, ImmSrc, ALUControl, MemToReg, NoWrite_InSig);
WLOGIC      : WELOGIC   port map(Instr(27 downto 26), Instr(20), NoWrite_InSig, RegWrite_InSig, FlagsWrite_InSig, MemWrite_InSig);
PC          : PCLOGIC   port map(Instr(15 downto 12), Instr(27), RegWrite_InSig, PCSrc_InSig);
CONDITIONAL : CONDLOGIC port map(Instr(31 downto 28), Flags, CondEx_InSig);

MemWrite   <= CondEx_InSig and MemWrite_InSig;
FlagsWrite <= CondEx_InSig and FlagsWrite_InSig;
RegWrite   <= CondEx_InSig and RegWrite_InSig;
PCSrc      <= CondEx_InSig and PCSrc_InSig;

end Structural;
