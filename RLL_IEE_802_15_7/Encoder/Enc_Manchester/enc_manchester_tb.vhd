library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_manchester_tb is
end entity enc_manchester_tb;

architecture teste of enc_manchester_tb is
    
    component enc_manchester_top is
        port (
            I_RST_MAN, I_CLK_MAN    : in std_logic;
            I_DATA_MAN              : in std_logic;
            I_VALID_MAN             : in std_logic;
            I_CONSUME_MAN           : in std_logic;
            O_DATA_MAN              : out std_logic_vector(1 downto 0);
            O_VALID_MAN             : out std_logic;
            O_IN_READY_MAN          : out std_logic
        );
    end component enc_manchester_top;

----------------------------------------------------------------------------------------

signal I_RST_MAN        : std_logic;
signal I_CLK_MAN        : std_logic := '1';
signal I_DATA_MAN       : std_logic;   
signal I_VALID_MAN      : std_logic;   
signal I_CONSUME_MAN    : std_logic;   
signal O_DATA_MAN       : std_logic_vector(1 downto 0);   
signal O_VALID_MAN      : std_logic;   
signal O_IN_READY_MAN   : std_logic;      

begin
 
    
my_manchester_top: enc_manchester_top
    port map(
        I_RST_MAN       =>  I_RST_MAN,     
        I_CLK_MAN       =>  I_CLK_MAN,     
        I_DATA_MAN      =>  I_DATA_MAN,        
        I_VALID_MAN     =>  I_VALID_MAN,       
        I_CONSUME_MAN   =>  I_CONSUME_MAN,     
        O_DATA_MAN      =>  O_DATA_MAN,        
        O_VALID_MAN     =>  O_VALID_MAN,       
        O_IN_READY_MAN  =>  O_IN_READY_MAN      
    ); 
    
------------------------------------------------------------------------------

-- faz a codificacao dos dados duas vezes, uma vez com '1' e outra com '0'active
-- sinal de valido e de consumo sao ligados quando o bloco esta esperando esses sinais
-- mas, tambem ligados em momentos errados

I_RST_MAN <= '1', '0' after 100 ns;
I_CLK_MAN <= not I_CLK_MAN after 5 ns; -- 100MHz

I_DATA_MAN <= '1', '0' after 500 ns;

I_VALID_MAN <= '0', '1' after 200 ns, '0' after 210 ns, '1' after 250 ns, '0' after 260 ns, '1' after 600 ns, '0' after 610 ns;

I_CONSUME_MAN <= '0', '1' after 150 ns, '0' after 160 ns, '1' after 300 ns, '0' after 310 ns, '1' after 700 ns, '0' after 710 ns;
    
    
end architecture teste;