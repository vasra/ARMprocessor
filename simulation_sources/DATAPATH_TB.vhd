library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DATAPATH_TB is
--  Port ( );
end DATAPATH_TB;

architecture Behavioral of DATAPATH_TB is
component DATAPATH is
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
        Shamt       : in std_logic_vector(4 downto 0);
        ShiftType   : in std_logic_vector(1 downto 0);
        
        -- outputs
        ALUFlags : out std_logic_vector(3 downto 0);
        
        -- buffers
        PCin      : buffer std_logic_vector(N - 1 downto 0);
        ALUResult : buffer std_logic_vector(N - 1 downto 0);
        WriteData : buffer std_logic_vector(N - 1 downto 0)
        );
end component DATAPATH;

signal CLK         : std_logic;
signal RESET       : std_logic;
signal PCWrite     : std_logic;
signal PCsrc       : std_logic;
signal RegSrc      : std_logic_vector(2 downto 0);
signal ALUSrc      : std_logic;
signal MemtoReg    : std_logic;
signal ALUControl  : std_logic_vector(2 downto 0);
signal ImmSrc      : std_logic;
signal ReadData    : std_logic_vector(31 downto 0);
signal RegWrite    : std_logic;
signal Instruction : std_logic_vector(31 downto 0);
signal FlagsWrite  : std_logic;
signal MemWrite    : std_logic;
signal Shamt       : std_logic_vector(4 downto 0);
signal ShiftType  : std_logic_vector(1 downto 0);

signal ALUFlags : std_logic_vector(3 downto 0);
        
signal PCin      : std_logic_vector(31 downto 0);
signal ALUResult : std_logic_vector(31 downto 0);
signal WriteData : std_logic_vector(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin
uut : DATAPATH port map(CLK, RESET, PCWrite, PCsrc, RegSrc, ALUSrc, MemtoReg, ALUControl, ImmSrc, ReadData, RegWrite, Instruction, FlagsWrite, MemWrite, Shamt, ShiftType, 
                        ALUFlags,
                        PCin, ALUResult, WriteData);

dpath : process is
begin

RESET <= '1';            wait for 10 * CLK_PERIOD;
RESET <= '0'; CLK <='1'; wait for CLK_PERIOD;

PCWrite <= '1';
PCin <= "11100010100100010010000011111111";

PCsrc <= '0'; RegSrc <= "000"; ALUSrc <= '1'; MemtoReg <= '1'; ALUControl <= "000";

ImmSrc <= '1'; ReadData <= x"FFFFFFFF"; RegWrite <= '1';

Instruction <= "11100010100100010010000011111111";

FlagsWrite <= '1';

MemWrite <= '1';

wait for CLK_PERIOD;
end process;
end Behavioral;
