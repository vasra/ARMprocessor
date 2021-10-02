library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

entity PROCESSOR_TB is
--  Port ( );
end PROCESSOR_TB;

architecture Behavioral of PROCESSOR_TB is

component PROCESSOR is
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
end component PROCESSOR;

signal CLK       : std_logic;
signal RESET     : std_logic;
signal PC        : std_logic_vector(31 downto 0);
signal Instr     : std_logic_vector(31 downto 0);
signal ALUResult : std_logic_vector(31 downto 0);
signal WriteData : std_logic_vector(31 downto 0);
signal Result    : std_logic_vector(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

uut : PROCESSOR port map(CLK, RESET, PC, Instr, ALUResult, WriteData, Result);

CLK_process : process is
begin
    CLK <= '0'; wait for CLK_PERIOD;
    CLK <= '1'; wait for CLK_PERIOD;
end process;

ARM : process is
begin
    RESET <= '1'; wait for 100 ns;
    
    wait until(falling_edge(CLK));
    RESET <= '0';

    for I in 0 to 6 loop
        wait until(falling_edge(CLK));
        wait until(rising_edge(CLK));
    end loop;
    
    report "Test completed";
    stop(2);
end process;
end Behavioral;
