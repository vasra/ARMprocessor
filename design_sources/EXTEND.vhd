library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EXTEND is
    generic(
           WIDTH_IN_z : positive := 12;
           WIDTH_IN_s : positive := 24;
           WIDTH_OUT  : positive := 32
           );
    port(
        IMMSRC  : in std_logic;
        DATA_IN : in std_logic_vector(WIDTH_IN_s - 1 downto 0);
        EXTIMM  : out std_logic_vector(WIDTH_OUT - 1 downto 0)
        );
end EXTEND;

architecture Behavioral of EXTEND is

begin

EXTEND : process(IMMSRC, DATA_IN) is
    variable DATA_IN_U    : unsigned(WIDTH_IN_z - 1 downto 0);
    variable DATA_IN_S    : signed(WIDTH_IN_s + 1 downto 0);
    variable EXTIMM_OUT_U : unsigned(WIDTH_OUT - 1 downto 0);
    variable EXTIMM_OUT_S : signed(WIDTH_OUT - 1 downto 0);
begin
    DATA_IN_U := unsigned(DATA_IN(WIDTH_IN_z - 1 downto 0));
    DATA_IN_S := signed(DATA_IN & "00"); 
    
    if IMMSRC = '1' then
        EXTIMM_OUT_S := resize(DATA_IN_S, WIDTH_OUT);
        EXTIMM <= std_logic_vector(EXTIMM_OUT_S);
    elsif IMMSRC = '0' then
        EXTIMM_OUT_U := resize(DATA_IN_U, WIDTH_OUT);
        EXTIMM <= std_logic_vector(EXTIMM_OUT_U);
    end if;
end process;

end Behavioral;
