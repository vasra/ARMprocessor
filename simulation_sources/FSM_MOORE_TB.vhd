library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_MOORE_TB is
--  Port ( );
end FSM_MOORE_TB;

architecture Behavioral of FSM_MOORE_TB is

component FSM_MOORE is
    port(
        CLK        : in std_logic;
        RESET      : in std_logic;
        Op         : in std_logic_vector(1 downto 0);
        SL         : in std_logic;
        Rd         : in std_logic_vector(3 downto 0);
        NoWrite_In : in std_logic;
        CondEx_In  : in std_logic;
        PCWrite    : out std_logic;
        IRWrite    : out std_logic;
        RegWrite   : out std_logic;
        FlagsWrite : out std_logic;
        MAWrite    : out std_logic;
        MemWrite   : out std_logic;
        PCSrc      : out std_logic_vector(1 downto 0)
        );
end component FSM_MOORE;

signal CLK        : std_logic;
signal RESET      : std_logic;
signal Op         : std_logic_vector(1 downto 0);
signal SL         : std_logic;
signal Rd         : std_logic_vector(3 downto 0);
signal NoWrite_In : std_logic;
signal CondEx_In  : std_logic;
signal PCWrite    : std_logic;
signal IRWrite    : std_logic;
signal RegWrite   : std_logic;
signal FlagsWrite : std_logic;
signal MAWrite    : std_logic;
signal MemWrite   : std_logic;
signal PCSrc      : std_logic_vector(1 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

uut: FSM_MOORE port map(CLK, RESET, Op, SL, Rd, NoWrite_In, CondEx_In,
                        PCWrite, IRWrite, RegWrite,FlagsWrite, MAWrite, MemWrite, PCSrc);
                        
CLK_process : process is
begin
    CLK <= '0'; wait for CLK_PERIOD / 2;
    CLK <= '1'; wait for CLK_PERIOD / 2;
end process;

Moore: process is
begin
    
end process;
end Behavioral;
