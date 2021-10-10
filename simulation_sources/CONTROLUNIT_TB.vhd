library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

entity CONTROLUNIT_TB is
--  Port ( );
end CONTROLUNIT_TB;

architecture Behavioral of CONTROLUNIT_TB is

component CONTROLUNIT is
    port(
        -- inputs
        CLK   : in std_logic;
        RESET : in std_logic;    
        Instr : in std_logic_vector(31 downto 0);
        Flags : in std_logic_vector(3 downto 0);

        -- InstrDec outputs
        RegSrc     : out std_logic_vector(2 downto 0);
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
end component CONTROLUNIT;

signal CLK        : std_logic;
signal RESET      : std_logic;
signal Instr      : std_logic_vector(31 downto 0);
signal Flags      : std_logic_vector(3 downto 0);
signal RegSrc     : std_logic_vector(2 downto 0);
signal ALUSrc     : std_logic;
signal ImmSrc     : std_logic;
signal ALUControl : std_logic_vector(2 downto 0);
signal MemToReg   : std_logic;
signal Shamt      : std_logic_vector(4 downto 0);                                      
signal IRWrite    : std_logic;
signal RegWrite   : std_logic;
signal MAWrite    : std_logic;
signal MemWrite   : std_logic;
signal FlagsWrite : std_logic;
signal PCSrc      : std_logic_vector(1 downto 0);
signal PCWrite    : std_logic;

constant CLK_PERIOD : time := 10 ns;

begin

uut : CONTROLUNIT port map(CLK, RESET, Instr, Flags,
                           RegSrc, ALUSrc, ImmSrc, ALUControl, MemToReg, Shamt,
                           IRWrite, RegWrite, MAWrite, MemWrite, FlagsWrite, PCSrc, PCWrite);
                              
CLK_process : process is
begin
    CLK <= '0'; wait for CLK_PERIOD / 2;
    CLK <= '1'; wait for CLK_PERIOD / 2;
end process;

CU : process is
begin
    RESET <= '1'; wait for 100 ns;
    
    -- sample program to test
    -- MAIN_PROGRAM:  
    -- MOV R0, #5
    -- TEST:
    -- STR R0, [R1, #0x10]
    -- ADD R1, R0, #5
    -- SUB R1, R0, #-1
    -- ADD R8, #9
    -- B TEST
     
    wait until(falling_edge(CLK));
    RESET <= '0';
    Instr <= x"E3A00005"; -- MOV R0, #5
    Flags <= "1110";
    wait for 5 * CLK_PERIOD;
    
    wait until(falling_edge(CLK));
    Instr <= x"E5810010"; -- STR R0, [R1, #0x10]
    Flags <= "1110";
    wait for 4 * CLK_PERIOD;
    
    wait until(falling_edge(CLK));
    Instr <= x"E2801005"; -- ADD R1, R0, #5
    Flags <= "1110";
    wait for 4 * CLK_PERIOD;
    
    wait until(falling_edge(CLK));
    Instr <= x"E2801001"; -- SUB R1, R0, #-1
    Flags <= "1110";
    wait for 4 * CLK_PERIOD;

    wait until(falling_edge(CLK));
    Instr <= x"E2888009"; -- ADD R8, #9
    Flags <= "1110";
    wait for 4 * CLK_PERIOD;
    
    wait until(falling_edge(CLK));
    Instr <= x"EAFFFFFA"; -- B TEST
    Flags <= "1110";
    wait for 3 * CLK_PERIOD;
    
    report "Tests completed";
    stop(2);
end process;
end Behavioral;
