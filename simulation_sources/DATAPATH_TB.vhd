library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

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

signal CLK         : std_logic;
signal RESET       : std_logic;
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
signal WriteData : std_logic_vector(31 downto 0);
signal Result    : std_logic_vector(31 downto 0);

-- buffers
signal PCbuf     : std_logic_vector(31 downto 0);
signal Instr     : std_logic_vector(31 downto 0);
signal ALUResult : std_logic_vector(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin
uut : DATAPATH port map(CLK, RESET, PCWrite, PCsrc, RegSrc, ALUSrc, MemtoReg, ALUControl, ImmSrc, ReadData, RegWrite, FlagsWrite, MemWrite, Shamt, 
                        ALUFlags, WriteData, Result,
                        PCbuf, Instr, ALUResult);

CLK_process : process is
begin
    CLK <='0'; wait for CLK_PERIOD;
    CLK <='1'; wait for CLK_PERIOD;
end process;

dpath : process is
begin
    RESET <= '1';
    wait for 100 ns;

    wait until(falling_edge(CLK));
    RESET <= '0';
    ImmSrc <= '0'; ALUSrc <= '1'; MemWrite <='0'; FlagsWrite <= '1'; MemToReg <= '0'; PcSrc <= '1'; PCWrite <= '1'; RegSrc <= "000";
    ALUControl <= "000"; RegWrite <= '1'; Shamt <= "00000"; PCbuf <= x"00000000";
    wait until(rising_edge(CLK));
    
    for I in 0 to 3 loop
        wait until(CLK'event);
    end loop;
    
    report "Tests completed";
    stop(2);
end process;
end Behavioral;
