library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_4b6b_tb is
end entity enc_4b6b_tb;

architecture teste of enc_4b6b_tb is
   
    component enc_4b6b_top is
        port (
            I_RST_4B6B, I_CLK_4B6B  : in std_logic;
            I_DATA_4B6B             : in std_logic_vector(3 downto 0);
            I_VALID_4B6B            : in std_logic;
            I_CONSUME_4B6B          : in std_logic;
            O_DATA_4B6B             : out std_logic_vector(5 downto 0);
            O_VALID_4B6B            : out std_logic;
            O_IN_READY_4B6B         : out std_logic
            -- nao usados
            -- I_LAST_DATA_4B6B
            -- O_LAST_DATA_4B6B 
        );
    end component enc_4b6b_top;   

----------------------------------------------------------------------------------------------------------
signal I_RST_4B6B        : std_logic;
signal I_CLK_4B6B        : std_logic := '1';
signal I_DATA_4B6B       : std_logic_vector(3 downto 0);   
signal I_VALID_4B6B      : std_logic;   
signal I_CONSUME_4B6B    : std_logic;   
signal O_DATA_4B6B       : std_logic_vector(5 downto 0);   
signal O_VALID_4B6B      : std_logic;   
signal O_IN_READY_4B6B   : std_logic;      

begin
 
    
my_4b6b_top: enc_4b6b_top
    port map(
        I_RST_4B6B       =>  I_RST_4B6B,     
        I_CLK_4B6B       =>  I_CLK_4B6B,     
        I_DATA_4B6B      =>  I_DATA_4B6B,        
        I_VALID_4B6B     =>  I_VALID_4B6B,       
        I_CONSUME_4B6B   =>  I_CONSUME_4B6B,     
        O_DATA_4B6B      =>  O_DATA_4B6B,        
        O_VALID_4B6B     =>  O_VALID_4B6B,       
        O_IN_READY_4B6B  =>  O_IN_READY_4B6B      
    );    

------------------------------------------------------------------------------

-- faz a codificacao dos dados duas vezes, uma vez com '1' e outra com '0'active
-- sinal de valido e de consumo sao ligados quando o bloco esta esperando esses sinais

I_RST_4B6B <= '1', '0' after 100 ns;
I_CLK_4B6B <= not I_CLK_4B6B after 5 ns; -- 100MHz

I_DATA_4B6B <= "0000", "1111" after 500 ns;

I_VALID_4B6B <= '0', '1' after 200 ns, '0' after 210 ns, '1' after 220 ns, '0' after 230 ns, '1' after 600 ns, '0' after 610 ns;

I_CONSUME_4B6B <= '0', '1' after 210 ns, '0' after 220 ns, '1' after 300 ns, '0' after 310 ns, '1' after 700 ns, '0' after 710 ns;   
    
    
end architecture teste;