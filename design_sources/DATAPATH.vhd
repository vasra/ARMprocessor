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
        PCSrc       : in std_logic_vector(1 downto 0);
        RegSrc      : in std_logic_vector(2 downto 0);
        ALUSrc      : in std_logic;
        MemtoReg    : in std_logic;
        ALUControl  : in std_logic_vector(2 downto 0);
        ImmSrc      : in std_logic;
        ReadData    : in std_logic_vector(N - 1 downto 0);
        RegWrite    : in std_logic;
        FlagsWrite  : in std_logic;
        MemWrite    : in std_logic;
        Shamt       : in std_logic_vector(4 downto 0);
        IRWrite     : in std_logic;
        MAWrite     : in std_logic;
        
        -- outputs
        ALUFlags  : out std_logic_vector(3 downto 0);
        WriteData : out std_logic_vector(N - 1 downto 0);
        Result    : out std_logic_vector(N - 1 downto 0);
        
        -- buffers
        PCbuf     : buffer std_logic_vector(N - 1 downto 0);
        Instr     : buffer std_logic_vector(N - 1 downto 0);
        ALUResult : buffer std_logic_vector(N - 1 downto 0)
        );
end DATAPATH;

architecture Structural of DATAPATH is

component PC is
   port(
       CLK    : in std_logic;
       RESET  : in std_logic;
       WE     : in std_logic;
       PCN    : in std_logic_vector(N - 1 downto 0);
       PC_out : buffer std_logic_vector(N - 1 downto 0)
       );
end component PC;

component ROM is
    port(
        PC : in std_logic_vector(N - 1 downto 0);
        RD : buffer std_logic_vector(N - 1 downto 0)
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
           WIDTH_IN_z : positive := 12;
           WIDTH_IN_s : positive := 24;
           WIDTH_OUT  : positive := 32
           );
    port(
        IMMSRC  : in std_logic;
        DATA_IN : in std_logic_vector(WIDTH_IN_s - 1 downto 0);
        EXTIMM  : out std_logic_vector(WIDTH_OUT - 1 downto 0)
        );
end component EXTEND;

-- Step 3 components
component ALU is
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        Shamt      : in std_logic_vector(4 downto 0);
        ALUResult  : buffer std_logic_vector(N - 1 downto 0);
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

component MUX3TO1 is
    generic(
           N : positive := 32
           );
    port(
        Src     : in std_logic_vector(1 downto 0);
        SrcA    : in std_logic_vector(N - 1 downto 0);
        SrcB    : in std_logic_vector(N - 1 downto 0);
        SrcC    : in std_logic_vector(N - 1 downto 0);
        DataOut : out std_logic_vector(N - 1 downto 0)
        );
end component MUX3TO1;

component NON_ARCH_REG is
    port(
        CLK     : in std_logic;
        RESET   : in std_logic;
        WE      : in std_logic;
        DataIn  : in std_logic_vector(N - 1 downto 0);
        DataOut : out std_logic_vector(N - 1 downto 0)
        );
end component NON_ARCH_REG;

signal PCN          : std_logic_vector(N - 1 downto 0);
signal PCPlus4Sig   : std_logic_vector(N - 1 downto 0);
signal PCPlus4Sig2  : std_logic_vector(N - 1 downto 0);
signal RA1          : std_logic_vector(M - 1 downto 0);
signal RA2          : std_logic_vector(M - 1 downto 0);
signal WA           : std_logic_vector(M - 1 downto 0);
signal PCPlus8Sig   : std_logic_vector(N - 1 downto 0);
signal RD1          : std_logic_vector(N - 1 downto 0);
signal RD2          : std_logic_vector(N - 1 downto 0);
signal WD3          : std_logic_vector(N - 1 downto 0);
signal ExtImm       : std_logic_vector(N - 1 downto 0);
signal ExtImmSig    : std_logic_vector(N - 1 downto 0);
signal SrcA         : std_logic_vector(N - 1 downto 0);
signal SrcB         : std_logic_vector(N - 1 downto 0);
signal SrcBSig      : std_logic_vector(N - 1 downto 0);
signal ALUFlagsSig  : std_logic_vector(3 downto 0);
signal RD           : std_logic_vector(N - 1 downto 0);
signal MemMuxResult : std_logic_vector(N - 1 downto 0);
signal InstrSig     : std_logic_vector(N - 1 downto 0);
signal DataMemAddr  : std_logic_vector(N - 1 downto 0);
signal DataMemData  : std_logic_vector(N - 1 downto 0);
signal RegSSig      : std_logic_vector(N - 1 downto 0);
signal RDSig        : std_logic_vector(N - 1 downto 0);

begin

-- step 1
PROGRAM_COUNTER    : PC port map(CLK, RESET, PCWrite, PCN, PCbuf);
INSTRUCTION_MEMORY : ROM port map(PCbuf, Instr);
INC4               : PCPLUS4 port map(PCbuf, PCPlus4Sig);

-- registers between steps 1 and 2
-- 1) Instruction register
-- 2) Program Counter plus 4 register

INSTR_REG   : NON_ARCH_REG port map(CLK, RESET, IRWrite, Instr, InstrSig);
PCPLUS4_REG : NON_ARCH_REG port map(CLK, RESET, '1', PCPlus4Sig, PCPlus4Sig2);
 
-- step 2
FIRST_ALU_SRC  : MUX2TO1 generic map(N => 4) 
                         port map(RegSrc(0), InstrSig(19 downto 16), "1111", RA1);
SECOND_ALU_SRC : MUX2TO1 generic map(N => 4) 
                         port map(RegSrc(1), InstrSig(3 downto 0), InstrSig(15 downto 12), RA2);                         
WAMUX         : MUX2TO1 generic map(N => 4)
                        port map(RegSrc(2), InstrSig(15 downto 12), "1110", WA);
WDMUX         : MUX2TO1 port map(RegSrc(2), MemMuxResult, PCPlus4Sig2, WD3);
INC8          : PCPLUS4 port map(PCPlus4Sig2, PCPlus8Sig);
REGISTER_FILE : REGFILE port map(CLK, RegWrite, RA1, RA2, WA, WD3, PCPlus8Sig, RD1, RD2);
EXTEND_UNIT   : EXTEND  port map(ImmSrc, InstrSig(23 downto 0), ExtImm);

-- registers between step 2 and 3
-- 1) Register to hold RD1 value from the output of the register file
-- 2) Register to hold RD2 value from the output of the register file
-- 3) Register to hold immediate value from the immediate extension unit

REG_A : NON_ARCH_REG port map(CLK, RESET, '1', RD1, SrcA);
REG_B : NON_ARCH_REG port map(CLK, RESET, '1', RD2, SrcBSig);
REG_I : NON_ARCH_REG port map(CLK, RESET, '1', ExtImm, ExtImmSig);

-- step 3
ALUMUX   : MUX2TO1 port map(ALUSrc, SrcBSig, ExtImmSig, SrcB);
ALU_COMP : ALU port map(ALUControl, SrcA, SrcB, Shamt, ALUResult, ALUFlagsSig);
STATUS   : SR port map(CLK, RESET, FlagsWrite, ALUFlagsSig, ALUFlags);

-- registers between step 3 and 4
-- 1) Register to hold the data memory address produced by the ALU
-- 2) Register to hold the data to be written to the data memory
-- 3) Register to hold the ALUResult
REG_MA : NON_ARCH_REG port map(CLK, RESET, MAWrite, ALUResult, DataMemAddr);
REG_WD : NON_ARCH_REG port map(CLK, RESET, '1', SrcBSig, DataMemData);
REG_S  : NON_ARCH_REG port map(CLK, RESET, '1', ALUResult, RegSSig);

-- step 4
DATA_MEM : RAM port map(CLK, MemWrite, DataMemAddr, DataMemData, RD);

-- registers between step 4 and 5
-- 1) Register to hold the data read from the data memory
REG_RD : NON_ARCH_REG port map(CLK, RESET, '1', RD, RDSig);

-- step 5
MEMMUX : MUX2TO1 port map(MemToReg, RegSSig, RDSig, MemMuxResult);
PCMUX  : MUX3TO1 port map(PCSrc, PCPlus4Sig2, ALUResult, MemMuxResult, PCN);

end Structural;
