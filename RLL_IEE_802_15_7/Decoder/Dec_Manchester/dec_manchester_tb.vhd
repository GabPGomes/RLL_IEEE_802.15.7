library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_manchester_tb is
end entity dec_manchester_tb;

architecture teste of dec_manchester_tb is
    
    component dec_manchester_top is
        port (
            I_RST_MAN, I_CLK_MAN    : in std_logic;
            I_DATA_MAN              : in std_logic_vector(1 downto 0);
            I_VALID_MAN             : in std_logic;
            I_CONSUME_MAN           : in std_logic;
            O_DATA_MAN              : out std_logic;
            O_VALID_MAN             : out std_logic;
            O_IN_READY_MAN          : out std_logic;
            O_ERR_MAN               : out std_logic   
        );
    end component dec_manchester_top;

----------------------------------------------------------------------------------------

signal I_RST_MAN        : std_logic;
signal I_CLK_MAN        : std_logic := '1';
signal I_DATA_MAN       : std_logic_vector(1 downto 0);   
signal I_VALID_MAN      : std_logic;   
signal I_CONSUME_MAN    : std_logic;   
signal O_DATA_MAN       : std_logic;   
signal O_VALID_MAN      : std_logic;   
signal O_IN_READY_MAN   : std_logic;
signal O_ERR_MAN        : std_logic;
      

begin
 
    
my_manchester_top: dec_manchester_top
    port map(
        I_RST_MAN       =>  I_RST_MAN,     
        I_CLK_MAN       =>  I_CLK_MAN,     
        I_DATA_MAN      =>  I_DATA_MAN,        
        I_VALID_MAN     =>  I_VALID_MAN,       
        I_CONSUME_MAN   =>  I_CONSUME_MAN,     
        O_DATA_MAN      =>  O_DATA_MAN,        
        O_VALID_MAN     =>  O_VALID_MAN,       
        O_IN_READY_MAN  =>  O_IN_READY_MAN,
        O_ERR_MAN       =>  O_ERR_MAN      
    ); 
    
------------------------------------------------------------------------------

-- faz a codificacao dos dados duas vezes, uma vez com '1' e outra com '0'active
-- sinal de valido e de consumo sao ligados quando o bloco esta esperando esses sinais
-- mas, tambem ligados em momentos errados

I_RST_MAN <= '1', '0' after 100 ns;
I_CLK_MAN <= not I_CLK_MAN after 5 ns; -- 100MHz

I_DATA_MAN <= "00", "01" after 200 ns, "10" after 300 ns, "11" after 400 ns;

I_VALID_MAN <= '1', '0' after 110 ns, '1' after 200 ns, '0' after 210 ns, '1' after 300 ns, '0' after 310 ns, '1' after 400 ns, '0' after 410 ns;

I_CONSUME_MAN <= '0', '1' after 250 ns, '0' after 260 ns, '1' after 350 ns, '0' after 360 ns, '1' after 450 ns, '0' after 460 ns;
    
    
end architecture teste;