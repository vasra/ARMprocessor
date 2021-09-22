library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity WELogic is
	port(
		Op            : in std_logic_vector(1 downto 0);
		SL            : in std_logic;
		NoWrite_In    : in std_logic;
		RegWrite_In   : out std_logic;
		FlagsWrite_In : out std_logic;
		MemWrite_In   : out std_logic
		);
end WELogic;

architecture Behavioral of WELogic is
begin

process is
begin
	case Op is
	when "00" =>
		MemWrite_In <= '0';
		if    SL = '0'                      then RegWrite_In <= '1'; FlagsWrite_In <= '0';
		elsif SL = '1' and NoWrite_In = '0' then RegWrite_In <= '1'; FlagsWrite_In <= '1';
		elsif SL = '1' and NoWrite_In = '1' then RegWrite_In <= '0'; FlagsWrite_In <= '1';
		end if;
	when "01" =>
		FlagsWrite_In <= '0';
		if    SL = '0' then RegWrite_In <= '1'; MemWrite_In <= '0';
		elsif SL = '1' then RegWrite_In <= '0'; MemWrite_In <= '1';
	when "10" =>
		RegWrite_In <= '0'; FlagsWrite_In <= '0'; MemWrite_In <= '0';
	when others =>
		RegWrite_In <= '-'; FlagsWrite_In <= '-'; MemWrite_In <= '-';
	end case;
end Behavioral;