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
        PC        : out std_logic_vector(N - 1 downto 0);
        Instr     : out std_logic_vector(N - 1 downto 0);
        ALUResult : out std_logic_vector(N - 1 downto 0);
        WriteData : out std_logic_vector(N - 1 downto 0);
        Result    : out std_logic_vector(N - 1 downto 0)
    );

architecture Structural of PROCESSOR is

component CONTROLUNIT is
    port(
        -- inputs
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
end component CONTROLUNIT;

component DATAPATH is
    generic(
            M : positive := 4
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
        ReadData    : in std_logic_vector(N - 1 downto 0);
        RegWrite    : in std_logic;
        Instruction : in std_logic_vector(N - 1 downto 0);
        FlagsWrite  : in std_logic;
        MemWrite    : in std_logic;
        Shamt       : in std_logic_vector(4 downto 0);
        ShiftType   : in std_logic_vector(1 downto 0);
        
        -- outputs        
        ALUFlags  : out std_logic_vector(3 downto 0);
        PC        : out std_logic_vector(N - 1 downto 0);
        Instr     : out std_logic_vector(N - 1 downto 0);
        ALUResult : out std_logic_vector(N - 1 downto 0);
        WriteData : out std_logic_vector(N - 1 downto 0);
        Result    : out std_logic_vector(N - 1 downto 0)
        );
end component DATAPATH;

signal InstrSig      : std_logic_vector(N - 1 downto 0);
signal FlagsSig      : std_logic_vector(3 downto 0);
signal RegSrcSig     : std_logic_vector(1 downto 0);
signal ALUSrcSig     : std_logic;
signal ImmSrcSig     : std_logic;
signal ALUControlSig : std_logic_vector(1 downto 0);
signal MemToRegSig   : std_logic;
signal MemWriteSig   : std_logic;
signal FlagsWriteSig : std_logic;
signal RegWriteSig   : std_logic;
signal PCSrcSig      : std_logic;

begin

CU    : CONTROLUNIT port map(InstrSig, FlagsSig, RegSrcSig, ALUSrcSig, ImmSrcSig, ALUControlSig, MemToRegSig, MemWriteSig, FlagsWriteSig, RegWriteSig, PCSrcSig);
DPATH : DATAPATH    port map(CLK, RESET, PCWrite, PCSrcSig, RegSrcSig, ALUSrcSig, MemToRegSig, ALUControlSig, ImmSrcSig, ReadData, RegWrite, Instruction, FlagsWriteSig, MemWriteSig, 
                             Shamt, ShiftType, FlagsSig, PC, ALUResult, WriteData, Result);
end Structural;