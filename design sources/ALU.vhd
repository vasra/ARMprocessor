-- Signed Adder/Subtracter with Carry and Overflow
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDSUB is
    generic(
            N : integer := 32
            );
    port(
         SUBorADD : in std_logic;
         A        : in std_logic_vector(N - 1 downto 0);
         B        : in std_logic_vector(N - 1 downto 0);
         S        : out std_logic_vector(N - 1 downto 0);
         Cout     : out std_logic;
         OV       : out std_logic
         );
end ADDSUB;

architecture Behavioral of ADDSUB is
begin

ADDSUB: process(A, B)
    variable A_s, B_s, S_s: signed(N + 1 downto 0);
begin
    A_s := signed('0' & A(N - 1)& A);
    B_s := signed('0' & B(N - 1)& B);
    
    if (SUBorADD = '1') then S_s := A_s - B_s;
    else S_s := A_s + B_s;
    end if;
    
    S <= std_logic_vector(S_s(N - 1 downto 0));
    OV <= S_s(N) xor S_s(N - 1);
    Cout <= S_s(N + 1);
end process;

end Behavioral;

-- Barrel Shifter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BSHIFTER is -- barrel shifter
    generic(
            N : integer := 32
            );
    port(
        S          : in std_logic_vector(1 downto 0);
        shamt      : in std_logic_vector(1 downto 0);
        bshift_in  : in std_logic_vector(3 downto 0);
        bshift_out : out std_logic_vector(3 downto 0)
        );
end BSHIFTER;

architecture Behavioral of BSHIFTER is
begin

BSHIFTER: process(S, shamt, bshift_in)
    variable shamt_n : natural range 0 to 3;
    variable X_u     : unsigned(3 downto 0);
    variable X_s     : signed(3 downto 0);
begin
    shamt_n := to_integer(unsigned(shamt));
    X_u := unsigned (bshift_in);
    X_s := signed (bshift_in);
    case S is
    when "00" => bshift_out <= std_logic_vector(SHIFT_LEFT (X_u, shamt_n));
    when "01" => bshift_out <= std_logic_vector(SHIFT_RIGHT (X_u, shamt_n));
    when "10" => bshift_out <= std_logic_vector(SHIFT_RIGHT (X_s, shamt_n));
    when "11" => bshift_out <= std_logic_vector(ROTATE_RIGHT (X_s, shamt_n));
    when others => bshift_out <= "----";
    end case;
end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LOGICAL is
    generic(
            N : integer := 32
            );
    port(
         OP     : in std_logic;
         A      : in std_logic_vector(N - 1 downto 0);
         B      : in std_logic_vector(N - 1 downto 0);
         Result : out std_logic_vector(N - 1 downto 0)
         );
end LOGICAL;

architecture Behavioral of LOGICAL is
begin

LOGICAL: process(A, B) is
begin
    case OP is
    when '0' => Result <= A and B; 
    when '1' => Result <= A xor B;
    end case;
end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic(
            N : integer := 32
            );
    port(
        ALUSrc     : in std_logic;
        ALUControl : in std_logic_vector(2 downto 0);
        SrcA       : in std_logic_vector(N - 1 downto 0);
        SrcB       : in std_logic_vector(N - 1 downto 0);
        ALUResult  : out std_logic_vector(N - 1 downto 0);
        ALUFlags   : out std_logic_vector(3 downto 0)
        );
end ALU;

architecture Behavioral of ALU is

signal result : std_logic_vector(N - 1 downto 0);
begin

--process(SrcA, SrcB, ALUControl) is
--begin
--    case ALUControl is
--    when "0000" => -- ADD
--        result <= std_logic_vector(signed(SrcA) + signed(SrcB));
--        ALUResult <= result;
--    when "0001" => -- SUB
--        result <= std_logic_vector(signed(SrcA) - signed(SrcB));
--        ALUResult <= result;
--    when "0010" => -- CMP
--        if signed(SrcA) - signed(SrcB) > 0 then
--            ALUResult <= (others => '0');
--            ALUResult(0) <= '1';
--        else
--            ALUResult <= (others => '0');
--        end if;
--    when "0011" => -- AND
--        ALUResult <= SrcA and SrcB;
--    when "0100" => -- XOR
--        ALUResult <= SrcA xor SrcB;
--    end case;
        
--    if result(N - 1) = '1' then
--        ALUFlags(3) <= '1';
--    end if;
   
--end process;
        
end Behavioral;
