library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REGFILE_TB is
--  Port ( );
end REGFILE_TB;

architecture Behavioral of REGFILE_TB is

component REGFILE is
    generic(
        N : positive := 4;
        M : positive := 32
        );
    port(
        CLK       : in std_logic;
        WE        : in std_logic;
        ADDR_R1   : in std_logic_vector(N - 1 downto 0);
        ADDR_R2   : in std_logic_vector(N - 1 downto 0);
        ADDR_W    : in std_logic_vector(N - 1 downto 0);
        DATA_IN   : in std_logic_vector(M - 1 downto 0);
        R15       : in std_logic_vector(M - 1 downto 0);
        DATA_OUT1 : out std_logic_vector(M - 1 downto 0);
        DATA_OUT2 : out std_logic_vector(M - 1 downto 0)
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

test : process is
begin

CLK <= '1'; WE <= '1';
ADDR_W <= "1101"; DATA_IN <= x"0000FFFF"; ADDR_R1 <= "1111"; ADDR_R2 <= "1101"; R15 <= x"0F0F0F0F"; wait for CLK_PERIOD;
CLK <= '0'; WE <= '0'; ADDR_R2 <= "0011"; wait for CLK_PERIOD;

end process;
end Behavioral;
