library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

entity REGFILE_TB is
--  Port ( );
end REGFILE_TB;

architecture Behavioral of REGFILE_TB is

component REGFILE is
    port(
        CLK       : in std_logic;
        WE        : in std_logic;
        ADDR_R1   : in std_logic_vector(3 downto 0);
        ADDR_R2   : in std_logic_vector(3 downto 0);
        ADDR_W    : in std_logic_vector(3 downto 0);
        DATA_IN   : in std_logic_vector(31 downto 0);
        R15       : in std_logic_vector(31 downto 0);
        DATA_OUT1 : out std_logic_vector(31 downto 0);
        DATA_OUT2 : out std_logic_vector(31 downto 0)
        );
end component REGFILE;

signal CLK       : std_logic;
signal WE        : std_logic;
signal ADDR_R1   : std_logic_vector(3 downto 0);
signal ADDR_R2   : std_logic_vector(3 downto 0);
signal ADDR_W    : std_logic_vector(3 downto 0);
signal DATA_IN   : std_logic_vector(31 downto 0);
signal R15       : std_logic_vector(31 downto 0);
signal DATA_OUT1 : std_logic_vector(31 downto 0);
signal DATA_OUT2 : std_logic_vector(31 downto 0);

constant CLK_PERIOD: time := 10 ns;

begin

uut : REGFILE port map(CLK, WE, ADDR_R1, ADDR_R2, ADDR_W, DATA_IN, R15, DATA_OUT1, DATA_OUT2);

CLK_process : process is
begin
    CLK <= '0'; wait for CLK_PERIOD / 2;
    CLK <= '1'; wait for CLK_PERIOD / 2;
end process;

test : process is
begin

WE <= '0'; wait for 100 ns;

wait until(falling_edge(CLK));
ADDR_W <= "1110"; DATA_IN <= x"0000FFFF"; -- write to register R14 (shouldn't happen since now WE = '1')
ADDR_R1 <= "1111"; R15 <= x"00000008";    -- read from register R15 (PC)
ADDR_R2 <= "1110";                        -- read from register 14 (should be zero)
-- wait until(rising_edge(CLK));
wait for CLK_PERIOD;

wait until(falling_edge(CLK));
WE <= '1'; ADDR_W <= "1110"; DATA_IN <= x"0000FFFF"; -- try again
ADDR_R1 <= "0011";                                   -- read from register R3 (should be zero)
ADDR_R2 <= "1110";                                   -- read from register 14
-- wait until(falling_edge(CLK));
wait for 2 * CLK_PERIOD;

report("Tests completed");
stop(2);
end process;
end Behavioral;
