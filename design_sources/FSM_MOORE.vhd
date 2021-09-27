library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_MOORE is
    port(
        RESET      : in std_logic;
        Op         : in std_logic_vector(1 downto 0);
        SL         : in std_logic;
        Rd         : in std_logic_vector(3 downto 0);
        NoWrite_In : in std_logic;
        CondEx_In  : in std_logic;
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


end Behavioral;
