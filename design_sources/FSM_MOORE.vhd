library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_MOORE is
    port(
        CLK        : in std_logic;
        RESET      : in std_logic;
        Op         : in std_logic_vector(1 downto 0);
        SL         : in std_logic;
        Rd         : in std_logic_vector(3 downto 0);
        NoWrite_In : in std_logic;
        CondEx_In  : in std_logic;
        Funct      : in std_logic_vector(1 downto 0); -- The Instr[25:24] field, used to differentiate between the B and BL instructions
        PCWrite    : out std_logic;
        IRWrite    : out std_logic;
        RegWrite   : out std_logic;
        FlagsWrite : out std_logic;
        MAWrite    : out std_logic;
        MemWrite   : out std_logic;
        PCSrc      : out std_logic_vector(1 downto 0)
        );
end FSM_MOORE;

architecture Behavioral of FSM_MOORE is

    subtype FSM_states is std_logic_vector(12 downto 0);
    
    constant S0  : FSM_states := "0000000000001";
    constant S1  : FSM_states := "0000000000010";
    constant S2a : FSM_states := "0000000000100";
    constant S2b : FSM_states := "0000000001000";
    constant S3  : FSM_states := "0000000010000";
    constant S4a : FSM_states := "0000000100000";
    constant S4b : FSM_states := "0000001000000";
    constant S4c : FSM_states := "0000010000000";
    constant S4d : FSM_states := "0000100000000";
    constant S4e : FSM_states := "0001000000000";
    constant S4f : FSM_states := "0010000000000";
    constant S4g : FSM_states := "0100000000000";
    constant S4h : FSM_states := "1000000000000";
    
    signal current_state : FSM_states;
    signal next_state    : FSM_states;
begin

SYNC : process(CLK) is
begin
    if rising_edge(CLK) then
        if RESET = '1' then
            current_state <= S0;
        else
            current_state <= next_state;
        end if;
    end if;
end process;

ASYNC : process(current_state) is
begin
    -- initialize next state to S0
    next_state <= S0; PCWrite <= '0'; IRWrite <= '1'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
    case current_state is
        when S0 =>
            next_state <= S1; PCWrite <= '0'; IRWrite <= '1'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
        when S1 =>
            PCWrite <= '0'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
            if    Op = "01" and CondEx_In = '1' then next_state <= S2a;
            elsif Op = "00" and CondEx_In = '1' and NoWrite_In = '0' then next_state <= S2b;
            elsif Op = "00" and CondEx_In = '1' and NoWrite_In = '1' then next_state <= S4g;
            elsif               CondEx_In = '0' then next_state <= S4c;
            elsif Op = "10" and CondEx_In = '1' then next_state <= S4h;
            end if;
        when S2a =>
            PCWrite <= '0'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '1'; MemWrite <= '0'; PCSrc <= "00";
            if SL = '1' then
                next_state <= S3;
            elsif SL = '0' then
                next_state <= S4d;
            end if;
        when S2b =>
            PCWrite <= '0'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
            if SL ='0' then
                if Rd /= "1111" then
                    next_state <= S4a;
                else
                    next_state <= S4b;
                end if;
            elsif SL = '1' then
                if Rd /= "1111" then
                    next_state <= S4e;
                else
                    next_state <= S4f;
                end if;
            end if;
        when S3 =>
            PCWrite <= '0'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
            if Rd /= "1111" then
                next_state <= S4a;
            else
                next_state <= S4b;
            end if;
        when S4a =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; RegWrite <= '1'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
        when S4b =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "10";
        when S4c =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
        when S4d =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '1'; PCSrc <= "00";
        when S4e =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '1'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
        when S4f =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '1'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "10";
        when S4g =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; RegWrite <= '0'; FlagsWrite <= '1'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
        when S4h =>
            next_state <= S0; PCWrite <= '1'; IRWrite <= '0'; FlagsWrite <= '1'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "11";
            if Funct = "10" then -- B
                RegWrite <= '0';
            elsif Funct = "11" then -- BL
                RegWrite <= '1';
            end if; 
        when others =>
            next_state <= S0; PCWrite <= '0'; IRWrite <= '1'; RegWrite <= '0'; FlagsWrite <= '0'; MAWrite <= '0'; MemWrite <= '0'; PCSrc <= "00";
    end case;
end process;
end Behavioral;
