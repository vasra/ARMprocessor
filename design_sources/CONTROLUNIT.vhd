library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONTROLUNIT is
    generic(
           N : positive := 32
           );
    port(
        Instr : in std_logic_vector(N - 1 downto 0);
        Flags : in std_logic_vector(3 downto 0)
        );
end CONTROLUNIT;

architecture Structural of CONTROLUNIT is

component INSTRDEC is
    port(
        Op         : in std_logic_vector(1 downto 0);
        Funct      : in std_logic_vector(5 downto 0);
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
        Op          : in std_logic;
        RegWrite_In : in std_logic;
        --CondEx_In   : in std_logic;
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

signal RegSrcSig        : std_logic_vector(1 downto 0);
signal ALUSrcSig        : std_logic;
signal ImmSrcSig        : std_logic;
signal ALUControlSig    : std_logic_vector(1 downto 0);
signal MemToRegSig      : std_logic;
signal NoWrite_InSig    : std_logic;
signal CondEx_InSig     : std_logic;
signal FlagsWrite_InSig : std_logic;
signal MemWrite_InSig   : std_logic;
signal PCSrc_InSig      : std_logic;

begin

DECODER     : INSTRDEC port map(Instr(27 downto 26), Instr(25 downto 20), RegSrcSig, ALUSrcSig, ImmSrcSig, ALUControlSig, MemToRegSig, NoWrite_InSig);
WLOGIC      : WELOGIC port map(Instr(27 downto 26), Instr(20), NoWrite_InSig, FlagsWrite_InSig, MemWrite_InSig);
PC          : PCLOGIC port map(Instr(15 downto 12), instr(27), MemWrite_InSig, PCSrc_InSig);
CONDITIONAL : CONDLOGIC port map(Instr(31 downto 28), Flags, CondEx_InSig);
end Structural;
