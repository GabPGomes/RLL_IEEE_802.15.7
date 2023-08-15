library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Countdown_in_calc is
    port (
        OP_MODE_CNT       : in std_logic_vector(2 downto 0);
        COUNTDOWN_IN_CNT  : out std_logic_vector(3 downto 0)
    );
end entity Countdown_in_calc;

architecture estrutural of Countdown_in_calc is
  
    -- tabela para traduzir melhor os modos de operação
    constant M_3MAN     : std_logic_vector(2 downto 0) := "000";
    constant M_4MAN     : std_logic_vector(2 downto 0) := "001";
    constant M_8MAN     : std_logic_vector(2 downto 0) := "010";
    constant M_44B6B    : std_logic_vector(2 downto 0) := "011";
    constant M_84B6B    : std_logic_vector(2 downto 0) := "100";
    constant M_88B10B   : std_logic_vector(2 downto 0) := "101";
    constant M_8NOCODE  : std_logic_vector(2 downto 0) := "110";
    constant M_INVALID  : std_logic_vector(2 downto 0) := "111";

---------------------------------------------------------------------

begin
    
tabela: process(OP_MODE_CNT)
begin
    
    case OP_MODE_CNT is
        when M_3MAN     =>  COUNTDOWN_IN_CNT <= "0011";  
        when M_4MAN     =>  COUNTDOWN_IN_CNT <= "0100";  
        when M_8MAN     =>  COUNTDOWN_IN_CNT <= "1000";  
        when M_44B6B    =>  COUNTDOWN_IN_CNT <= "0100";  
        when M_84B6B    =>  COUNTDOWN_IN_CNT <= "1000";  
        when M_88B10B   =>  COUNTDOWN_IN_CNT <= "1000";  
        when M_8NOCODE  =>  COUNTDOWN_IN_CNT <= "1000";  
        when M_INVALID  =>  COUNTDOWN_IN_CNT <= "0000";  
        when others     =>  COUNTDOWN_IN_CNT <= "0000";  
    end case;

end process tabela;   
    
end architecture estrutural;