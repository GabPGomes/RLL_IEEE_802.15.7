-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_8b10b_tb is
end entity dec_8b10b_tb;

architecture teste of dec_8b10b_tb is

    component dec_8b10b_top is
        port (
            I_RST_8B10B, I_CLK_8B10B    :   in std_logic;
            I_DATA_8B10B                :   in std_logic_vector(9 downto 0);
            I_CONSUME_8B10B             :   in std_logic;
            I_VALID_8B10B               :   in std_logic;
            O_DATA_8B10B                :   out std_logic_vector(7 downto 0);
            O_IN_READY_8B10B            :   out std_logic;
            O_VALID_8B10B               :   out std_logic;
            O_ERR_8B10B                 :   out std_logic   
        );
    end component dec_8b10b_top;    

----------------------------------------------------------------------------------------------

signal I_RST_8B10B      :   std_logic;
signal I_CLK_8B10B      :   std_logic := '1';
signal I_DATA_8B10B     :   std_logic_vector(9 downto 0);
signal I_CONSUME_8B10B  :   std_logic;
signal I_VALID_8B10B    :   std_logic;
signal O_DATA_8B10B     :   std_logic_vector(7 downto 0);
signal O_IN_READY_8B10B :   std_logic;
signal O_VALID_8B10B    :   std_logic;
signal O_ERR_8B10B      :   std_logic; 

-----------------------------------------------------------------------------------------------

begin
    
    my_8b10b: dec_8b10b_top
        port map (
            I_RST_8B10B         =>  I_RST_8B10B,     
            I_CLK_8B10B         =>  I_CLK_8B10B,     
            I_DATA_8B10B        =>  I_DATA_8B10B,                
            I_CONSUME_8B10B     =>  I_CONSUME_8B10B,             
            I_VALID_8B10B       =>  I_VALID_8B10B,               
            O_DATA_8B10B        =>  O_DATA_8B10B,                
            O_IN_READY_8B10B    =>  O_IN_READY_8B10B,            
            O_VALID_8B10B       =>  O_VALID_8B10B,
            O_ERR_8B10B         =>  O_ERR_8B10B
        ); 
    
------------------------------------------------------------------------------

-- faz a decodificacao dos dados duas vezes, uma vez com '1' e outra com '0'active
-- sinal de valido e de consumo sao ligados depois que o bloco ja esta esperando esses sinais

I_RST_8B10B <= '1', '0' after 100 ns;
I_CLK_8B10B <= not I_CLK_8B10B after 5 ns; -- 100MHz

I_DATA_8B10B <= "0010111001", "0010101110" after 500 ns; -- D0.0 e D1.0

I_VALID_8B10B <= '0', '1' after 200 ns, '0' after 210 ns, '1' after 230 ns, '0' after 260 ns, '1' after 600 ns, '0' after 610 ns;

I_CONSUME_8B10B <= '0', '1' after 210 ns, '0' after 260 ns, '1' after 300 ns, '0' after 310 ns, '1' after 700 ns, '0' after 710 ns;

end architecture teste;