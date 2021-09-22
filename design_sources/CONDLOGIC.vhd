library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONDLogic is
    port(
        Cond  : in std_logic_vector(3 downto 0);
        Flags : in std_logic_vector(3 downto 0);
        CondEx_In : out std_logic
        );
end CONDLogic;

architecture Behavioral of CONDLogic is
begin
    case Cond is
        when "0000" => CondEx_In <= Flags(2);
        when "0001" => CondEx_In <= not(Flags(2));
        when "0010" => CondEx_In <= Flags(1);
        when "0011" => CondEx_In <= not(Flags(2));
        when "0100" => CondEx_In <= Flags(3);
        when "0101" => CondEx_In <= not(Flags(3));
        when "0110" => CondEx_In <= Flags(0);
        when "0111" => CondEx_In <= not(Flags(0));
        when "1000" => CondEx_In <= Flags(2);
        when "0000" => CondEx_In <= Flags(2);
        when "0000" => CondEx_In <= Flags(2);
        when "0000" => CondEx_In <= Flags(2);
        when "0000" => CondEx_In <= Flags(2);
        when "0000" => CondEx_In <= Flags(2);
        when "0000" => CondEx_In <= Flags(2);
        when "0000" => CondEx_In <= Flags(2);
    end case;
end Behavioral;