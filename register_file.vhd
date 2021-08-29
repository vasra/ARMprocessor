library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    generic(
        N : integer := 4;
        M : integer := 32
        );
    port(
        CLK : in std_logic;
        WE3 : in std_logic;
        A1  : in std_logic_vector(N - 1 downto 0);
        A2  : in std_logic_vector(N - 1 downto 0);
        A3  : in std_logic_vector(N - 1 downto 0);
        WD3 : in std_logic_vector(M - 1 downto 0);
        R15 : in std_logic_vector(M - 1 downto 0);
        RD1 : out std_logic_vector(M - 1 downto 0);
        RD2 : out std_logic_vector(M - 1 downto 0)
        );
end register_file;

architecture Behavioral of register_file is

type registers is array(0 to 2 ** N - 1) of std_logic_vector(M - 1 downto 0);
signal RF : registers := (others=>(others => '0'));

begin

process(CLK) is
begin
    if rising_edge(CLK) then
        if WE3 = '1' then
            RF(to_integer(unsigned(A3))) <= WD3;
        end if;
    end if;
end process;

RD1 <= R15 when A1 = "1111" else RF(to_integer(unsigned(A1)));
RD2 <= R15 when A2 = "1111" else RF(to_integer(unsigned(A2)));

end Behavioral;
