library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity PC_TB is
--  Port ( );
end PC_TB;

architecture Behavioral of PC_TB is

component PC is
   generic(
          N : positive := 32
          );
   port(
       CLK    : in std_logic;
       RESET  : in std_logic;
       WE     : in std_logic;
       PCN    : in std_logic_vector(N - 1 downto 0) := (others => '0');
       PC_out : buffer std_logic_vector(N - 1 downto 0)
       );
end component PC;

signal CLK    : std_logic;
signal RESET  : std_logic;
signal WE     : std_logic;
signal PCN    : std_logic_vector(31 downto 0) := (others => '0');
signal PC_out : std_logic_vector(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

uut : PC port map(CLK, RESET, WE, PCN, PC_out);

CLK_process : process is
begin
    CLK <= '0';
    wait for CLK_PERIOD / 2;
    CLK <= '1';
    wait for CLK_PERIOD / 2;
end process;

test : process is
begin
    RESET <= '1'; wait for 10 ns;
    RESET <= '0';
    WE <= '1';
    
    PCN <= x"0000000A";
    wait until(rising_edge(CLK));
    
    PCN <= x"000000FF";
    wait for 2 * CLK_PERIOD;
    
    report "Tests completed";
    stop(2);
end process;
end Behavioral;
