library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIFO_cnt_calc is
    port (
        OP_MODE_CALC       : in std_logic_vector(2 downto 0);
        COUNTER_IN_CALC  : out std_logic_vector(4 downto 0)
    );
end entity FIFO_cnt_calc;

architecture estrutural of FIFO_cnt_calc is
  
    -- tabela para traduzir melhor os modos de operação
    constant M_2_MAN     : std_logic_vector(2 downto 0) := "000";
    constant M_8_MAN     : std_logic_vector(2 downto 0) := "001";
    constant M_16_MAN    : std_logic_vector(2 downto 0) := "010";
    constant M_6_4B6B    : std_logic_vector(2 downto 0) := "011";
    constant M_12_4B6B   : std_logic_vector(2 downto 0) := "100";
    constant M_10_8B10B  : std_logic_vector(2 downto 0) := "101";
    constant M_8_NOCODE  : std_logic_vector(2 downto 0) := "110";
    constant M_INVALID   : std_logic_vector(2 downto 0) := "111";

---------------------------------------------------------------------

begin
    
tabela: process(OP_MODE_CALC)
begin
    
    case OP_MODE_CALC is
        when M_2_MAN    =>  COUNTER_IN_CALC <= "00010";  
        when M_8_MAN    =>  COUNTER_IN_CALC <= "01000";  
        when M_16_MAN   =>  COUNTER_IN_CALC <= "10000";  
        when M_6_4B6B   =>  COUNTER_IN_CALC <= "00110";  
        when M_12_4B6B  =>  COUNTER_IN_CALC <= "01100";  
        when M_10_8B10B =>  COUNTER_IN_CALC <= "01010";  
        when M_8_NOCODE =>  COUNTER_IN_CALC <= "01000";  
        when M_INVALID  =>  COUNTER_IN_CALC <= "00000";  
        when others     =>  COUNTER_IN_CALC <= "00000";  
    end case;

end process tabela;   
    
end architecture estrutural;