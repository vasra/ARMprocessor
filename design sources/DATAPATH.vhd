library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DATAPATH is
    generic(
           M : positive := 4;
           N : positive := 32
           );
    port(
        -- inputs
        CLK         : in std_logic;
        RESET       : in std_logic;
        PCWrite     : in std_logic;
        PCsrc       : in std_logic;
        RegSrc      : in std_logic_vector(2 downto 0);
        ALUSrc      : in std_logic;
        MemtoReg    : in std_logic;
        ALUControl  : in std_logic_vector(2 downto 0);
        ImmSrc      : in std_logic;
        ReadData    : in STD_LOGIC_VECTOR(N - 1 downto 0);
        RegWrite    : in std_logic;
        Instruction : in std_logic_vector(N - 1 downto 0);
        FlagsWrite  : in std_logic;
        MemWrite    : in std_logic;
        
        -- outputs
        ALUFlags : out std_logic_vector(3 downto 0);
        
        -- buffers
        PCWE      : buffer std_logic;
        PCin      : buffer std_logic_vector(N - 1 downto 0);
        ALUResult : buffer std_logic_vector(N - 1 downto 0);
        WriteData : buffer std_logic_vector(N - 1 downto 0)
        );
end DATAPATH;

architecture Structural of DATAPATH is

component PC is
   port(
       CLK    : in std_logic;
       RESET  : in std_logic;
       WE     : in std_logic;
       PCN    : in std_logic_vector(N - 1 downto 0);
       PC_out : out std_logic_vector(N - 1 downto 0)
       );
end component PC;

component ROM is
    port(
        PC : in std_logic_vector(N - 1 downto 0);
        RD : out std_logic_vector(N - 1 downto 0)
        );
end component ROM;

-- Step 2 components
component REGFILE is
    port(
        CLK       : in std_logic;
        WE        : in std_logic;
        ADDR_R1   : in std_logic_vector(M - 1 downto 0);
        ADDR_R2   : in std_logic_vector(M - 1 downto 0);
        ADDR_W    : in std_logic_vector(M - 1 downto 0);
        DATA_IN   : in std_logic_vector(N - 1 downto 0);
        R15       : in std_logic_vector(N - 1 downto 0);
        DATA_OUT1 : out std_logic_vector(N - 1 downto 0);
        DATA_OUT2 : out std_logic_vector(N - 1 downto 0)
        );
end component REGFILE;

component PCPLUS4 is
    port(
        PC      : in std_logic_vector (N - 1 downto 0);
        PCPlus4 : out std_logic_vector (N - 1 downto 0)
        );
end component PCPLUS4;

component EXTEND is
    generic(
           WIDTH_IN  : positive := 24;
           WIDTH_OUT : positive := 32
           );
    port(
        IMMSRC  : in std_logic;
        DATA_IN : in std_logic_vector(WIDTH_IN - 1 downto 0);
        EXTIMM  : out std_logic_vector(WIDTH_OUT - 1 downto 0)
        );
end component EXTEND;

-- Step 3 components
component ALU is
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0);
        ALUFlags   : out std_logic_vector(3 downto 0)
        );
end component ALU;

component SR is
    port(
        CLK       : in std_logic;
        RESET      : in std_logic;
        FlagsWrite : in std_logic;
        ALUFlags  : in std_logic_vector(3 downto 0);
        Flags     : out std_logic_vector(3 downto 0)
        );
end component SR;

-- Step 4 components
component RAM is
    port(
        CLK       : in std_logic;
        WE        : in std_logic;
        ALUResult : in std_logic_vector(N - 1 downto 0);
        WriteData : in std_logic_vector(N - 1 downto 0);
        RD        : out std_logic_vector(N - 1 downto 0)
        );
end component RAM;

component MUX2TO1 is
    generic(
           N : positive := 32
           );
    port(
        Src    : in std_logic;
        A      : in std_logic_vector(N - 1 downto 0);
        B      : in std_logic_vector(N - 1 downto 0);
        Result : out std_logic_vector(N - 1 downto 0)
        );
end component MUX2TO1;

signal PCN          : std_logic_vector(N - 1 downto 0);
signal PC_signal    : std_logic_vector(N - 1 downto 0);
signal PCPlus4Sig   : std_logic_vector(N - 1 downto 0);
signal Instr        : std_logic_vector(N - 1 downto 0);
signal RA1          : std_logic_vector(M - 1 downto 0);
signal RA2          : std_logic_vector(M - 1 downto 0);
signal WA           : std_logic_vector(M - 1 downto 0);
signal PCPlus8Sig   : std_logic_vector(N - 1 downto 0);
signal RD1          : std_logic_vector(N - 1 downto 0);
signal RD2          : std_logic_vector(N - 1 downto 0);
signal WD3          : std_logic_vector(N - 1 downto 0);
signal ExtImm       : std_logic_vector(N - 1 downto 0);
signal SrcB         : std_logic_vector(N - 1 downto 0);
signal ALUResultSig : std_logic_vector(N - 1 downto 0);
signal ALUFlagsSig  : std_logic_vector(3 downto 0);
signal RD           : std_logic_vector(N - 1 downto 0);
signal MemMuxResult : std_logic_vector(N - 1 downto 0);

begin

-- step 1
PROGRAM_COUNTER    : PC port map(CLK, RESET, PCWE, PCN, PC_signal);
INSTRUCTION_MEMORY : ROM port map(PC_signal, Instr);
INC4               : PCPLUS4 port map(PC_signal, PCPlus4Sig);

-- step 2
FIRST_ALU_SRC   : MUX2TO1 generic map(N => 4) 
                          port map(RegSrc(0), Instr(19 downto 16), "1111", RA1);
SECOND_ALU_SRC  : MUX2TO1 generic map(N => 4) 
                          port map(RegSrc(1), Instr(3 downto 0), Instr(15 downto 12), RA2);
ALU_DEST        : MUX2TO1 generic map(N => 4)
                          port map(RegSrc(2), Instr(15 downto 12), "1110", WA);
INC8            : PCPLUS4 port map(PCPlus4Sig, PCPlus8Sig);
REGISTER_FILE   : REGFILE port map(CLK, RegWrite, RA1, RA2, WA, WD3, PCPlus8Sig, RD1, RD2);
EXTEND_UNIT     : EXTEND port map(ImmSrc, Instr(23 downto 0), ExtImm);

-- step 3
ALUMUX   : MUX2TO1 port map(ALUSrc, RD2, ExtImm, SrcB);
ALU_COMP : ALU port map(ALUControl, RD1, SrcB, ALUResultSig, ALUFlagsSig);
STATUS   : SR port map(CLK, RESET, FlagsWrite, ALUFlagsSig, ALUFlags);

-- step 4
DATA_MEM : RAM port map(CLK, MemWrite, ALUResultSig, RD2, RD);

-- step 5
MEMMUX : MUX2TO1 port map(MemToReg, ALUResultSig, RD, MemMuxResult);
MUX    : MUX2TO1 port map(PCSrc, PCPlus4Sig, MemMuxResult, PCN);
MUX2   : MUX2TO1 port map(RegSrc(2), MemMuxResult, PCPlus4Sig, WD3);

end Structural;
