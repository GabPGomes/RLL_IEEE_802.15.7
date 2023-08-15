library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Encoder_FIFO_tb is
end entity Encoder_FIFO_tb;

architecture teste of Encoder_FIFO_tb is
   
    component Encoder_FIFO is
        port (
            CLK_FIFO, RST_FIFO	: in std_logic;
            INPUT_FIFO			: in std_logic;
            LOAD_FIFO			: in std_logic;
            READ_FIFO			: in std_logic;
            LAST_BIT_FIFO		: out std_logic;
            OUTPUT_FIFO			: out std_logic
        );
    end component Encoder_FIFO;

---------------------------------------------------------------------

signal CLK_FIFO             : std_logic := '1';
signal RST_FIFO	            : std_logic;
signal INPUT_FIFO			: std_logic;
signal LOAD_FIFO			: std_logic;
signal READ_FIFO			: std_logic;
signal LAST_BIT_FIFO		: std_logic;
signal OUTPUT_FIFO			: std_logic;

--------------------------------------------------------------------------

begin

    dut: Encoder_FIFO
        port map(
            CLK_FIFO        =>  CLK_FIFO,               
            RST_FIFO        =>  RST_FIFO,               
            INPUT_FIFO	    =>  INPUT_FIFO,	    	    
            LOAD_FIFO	    =>  LOAD_FIFO,	    	
            READ_FIFO	    =>  READ_FIFO,	    	
            LAST_BIT_FIFO   =>  LAST_BIT_FIFO,   	
            OUTPUT_FIFO	    =>  OUTPUT_FIFO	           	
        );

--------------------------------------------------------------------------

 CLK_FIFO <= not CLK_FIFO after 5 ns;
 
 RST_FIFO <= '1', '0' after 100 ns;
    
testbench: process
begin
    -- inicia as portas
    INPUT_FIFO  <= '0';
    READ_FIFO   <= '0';
    LOAD_FIFO   <= '0';
    wait for 100 ns;
    -- escreve os primeiros 8 bit '1'
    INPUT_FIFO  <= '1';
    READ_FIFO   <= '0';
    LOAD_FIFO   <= '1';
    wait for 80 ns;
    -- escreve os ultimos 8 bits '0'
    INPUT_FIFO  <= '0';
    READ_FIFO   <= '0';
    LOAD_FIFO   <= '1';
    wait for 80 ns;
    -- aguarda um pouco
    INPUT_FIFO  <= '0';
    READ_FIFO   <= '0';
    LOAD_FIFO   <= '0';
    wait for 50 ns;
    -- escreve com a FIFO cheia
    INPUT_FIFO  <= '1';
    READ_FIFO   <= '0';
    LOAD_FIFO   <= '1';
    wait for 80 ns;
    -- aguarda um pouco
    INPUT_FIFO  <= '0';
    READ_FIFO   <= '0';
    LOAD_FIFO   <= '0';
    wait for 50 ns;
    -- le a FIFO até depois de esvaziar
    INPUT_FIFO  <= '0';
    READ_FIFO   <= '1';
    LOAD_FIFO   <= '0';
    wait for 200 ns;
    -- finaliza
    INPUT_FIFO  <= '0';
    READ_FIFO   <= '0';
    LOAD_FIFO   <= '0';
    wait;

end process;

end architecture teste;