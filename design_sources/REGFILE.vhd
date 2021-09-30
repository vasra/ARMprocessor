library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REGFILE is
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
end REGFILE;

architecture Behavioral of REGFILE is
    type RF_array is array(0 to 2 ** N - 1) of 
        std_logic_vector(M - 1 downto 0);
    signal RF : RF_array := (others => (others => '0'));
begin

REG_FILE: process(CLK) is
begin
    if rising_edge(CLK) then
        if WE = '1' then
            RF(to_integer(unsigned(ADDR_W))) <= DATA_IN;
        end if;
    end if;
end process;

DATA_OUT1 <= R15 when ADDR_R1 = "1111" else RF(to_integer(unsigned(ADDR_R1)));
DATA_OUT2 <= R15 when ADDR_R2 = "1111" else RF(to_integer(unsigned(ADDR_R2)));

end Behavioral;
