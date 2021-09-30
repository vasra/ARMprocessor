library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PROCESSOR is
    generic(
            N : positive := 32
    );
    port(
        -- inputs
        CLK       : in std_logic;
        RESET     : in std_logic;

        -- outputs
        PC        : buffer std_logic_vector(N - 1 downto 0);
        Instr     : buffer std_logic_vector(N - 1 downto 0);
        ALUResult : buffer std_logic_vector(N - 1 downto 0);
        WriteData : out std_logic_vector(N - 1 downto 0);
        Result    : out std_logic_vector(N - 1 downto 0)
    );
end PROCESSOR;

architecture Structural of PROCESSOR is

component CONTROLUNIT is
    port(
        -- inputs
        Instr      : in std_logic_vector(N - 1 downto 0);
        Flags      : in std_logic_vector(3 downto 0);

        -- outputs
        RegSrc     : out std_logic_vector(2 downto 0);
        ALUSrc     : out std_logic;
        ImmSrc     : out std_logic;
        ALUControl : out std_logic_vector(2 downto 0);
        MemToReg   : out std_logic;
        MemWrite   : out std_logic;
        FlagsWrite : out std_logic;
        RegWrite   : out std_logic;
        PCSrc      : out std_logic;
        Shamt      : out std_logic_vector(4 downto 0)
        );
end component CONTROLUNIT;

component DATAPATH is
    port(
        -- inputs
        CLK         : in std_logic;
        RESET       : in std_logic;
        PCWrite     : in std_logic;
        PCSrc       : in std_logic;
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
        
        -- outputs
        ALUFlags  : out std_logic_vector(3 downto 0);
        WriteData : out std_logic_vector(N - 1 downto 0);
        Result    : out std_logic_vector(N - 1 downto 0);
        
        -- buffers
        PCbuf     : buffer std_logic_vector(N - 1 downto 0);
        Instr     : buffer std_logic_vector(N - 1 downto 0);
        ALUResult : buffer std_logic_vector(N - 1 downto 0)
        );
end component DATAPATH;

signal PCWrite     : std_logic;
signal PCSrc       : std_logic;
signal RegSrc      : std_logic_vector(2 downto 0);
signal ALUSrc      : std_logic;
signal MemtoReg    : std_logic;
signal ALUControl  : std_logic_vector(2 downto 0);
signal ImmSrc      : std_logic;
signal ReadData    : std_logic_vector(31 downto 0);
signal RegWrite    : std_logic;
signal FlagsWrite  : std_logic;
signal MemWrite    : std_logic;
signal Shamt       : std_logic_vector(4 downto 0);

-- outputs
signal ALUFlags  : std_logic_vector(3 downto 0);

-- buffers
signal PCbuf     : std_logic_vector(31 downto 0);

begin

CU    : CONTROLUNIT port map(Instr, ALUFlags, RegSrc, ALUSrc, ImmSrc, ALUControl, MemToReg, 
                             MemWrite, FlagsWrite, RegWrite, PCSrc, Shamt);
                             
DPATH : DATAPATH    port map(CLK, RESET, RegWrite, PCsrc, RegSrc, ALUSrc, MemtoReg, ALUControl, ImmSrc, ReadData, RegWrite, FlagsWrite, MemWrite, Shamt, 
                             ALUFlags, WriteData, Result,
                             PC, Instr, ALUResult); 
end Structural;