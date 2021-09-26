library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONDLOGIC is
    port(
        Cond      : in std_logic_vector(3 downto 0);
        Flags     : in std_logic_vector(3 downto 0);
        CondEx_In : out std_logic
        );
end CONDLOGIC;

architecture Behavioral of CONDLOGIC is
begin

process(Cond, Flags) is
    variable negative : std_logic;
    variable zero     : std_logic;
    variable carry    : std_logic;
    variable overflow : std_logic;
begin
    negative := Flags(3);
    zero     := Flags(2);
    carry    := Flags(1);
    overflow := Flags(0);
    case Cond is
        when "0000" => CondEx_In <= zero;
        when "0001" => CondEx_In <= not(zero);
        when "0010" => CondEx_In <= carry;
        when "0011" => CondEx_In <= not(zero);
        when "0100" => CondEx_In <= negative;
        when "0101" => CondEx_In <= not(negative);
        when "0110" => CondEx_In <= overflow;
        when "0111" => CondEx_In <= not(overflow);
        when "1000" => CondEx_In <= zero and carry;
        when "1001" => CondEx_In <= zero or (not(carry));
        when "1010" => CondEx_In <= negative xnor overflow;
        when "1011" => CondEx_In <= not(negative xnor overflow);
        when "1100" => CondEx_In <= not(zero) and (negative xnor overflow);
        when "1101" => CondEx_In <= zero or (not(negative xnor overflow));
        when "1110" => CondEx_In <= '1';
        when "1111" => CondEx_In <= '1';
        when others => CondEx_In <= '-';
    end case;
end process;
end Behavioral;