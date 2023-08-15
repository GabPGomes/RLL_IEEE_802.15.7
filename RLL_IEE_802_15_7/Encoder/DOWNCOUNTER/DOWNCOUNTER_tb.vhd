library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DOWNCOUNTER_tb is
end entity DOWNCOUNTER_tb;

architecture teste of DOWNCOUNTER_tb is

    component DOWNCOUNTER is
        port (
            CLK_DOWNCOUNTER, RST_DOWNCOUNTER    : in std_logic;
            LOAD_DOWNCOUNTER                    : in std_logic;   
            CNT_DOWNCOUNTER                     : in std_logic;
            PARALLEL_IN_DOWNCOUNTER             : in std_logic_vector(3 downto 0);
            ZERO_DOWNCOUNTER                    : out std_logic
        );
    end component DOWNCOUNTER;

-----------------------------------------------------------------------------------------------

signal CLK_DOWNCOUNTER          : std_logic := '1';
signal RST_DOWNCOUNTER          : std_logic;
signal LOAD_DOWNCOUNTER         : std_logic;   
signal CNT_DOWNCOUNTER          : std_logic;
signal PARALLEL_IN_DOWNCOUNTER  : std_logic_vector(3 downto 0);
signal ZERO_DOWNCOUNTER         : std_logic;

------------------------------------------------------------------------------------------------

begin
 
    dut: DOWNCOUNTER
        port map (
            CLK_DOWNCOUNTER         =>  CLK_DOWNCOUNTER,         
            RST_DOWNCOUNTER         =>  RST_DOWNCOUNTER,         
            LOAD_DOWNCOUNTER        =>  LOAD_DOWNCOUNTER,                     
            CNT_DOWNCOUNTER         =>  CNT_DOWNCOUNTER,                      
            PARALLEL_IN_DOWNCOUNTER =>  PARALLEL_IN_DOWNCOUNTER,              
            ZERO_DOWNCOUNTER        =>  ZERO_DOWNCOUNTER                     
        );    

CLK_DOWNCOUNTER <= not CLK_DOWNCOUNTER after 5 ns;

RST_DOWNCOUNTER <= '1', '0' after 100 ns;

testbench: process
begin

    -- inicia
    PARALLEL_IN_DOWNCOUNTER <= "0000";
    LOAD_DOWNCOUNTER        <= '0';
    CNT_DOWNCOUNTER         <= '0';
    wait for 100 ns;
    -- carga com 4
    PARALLEL_IN_DOWNCOUNTER <= "0100";
    LOAD_DOWNCOUNTER        <= '1';
    CNT_DOWNCOUNTER         <= '0';
    wait for 10 ns;
    -- aguarda um pouco
    PARALLEL_IN_DOWNCOUNTER <= "0000";
    LOAD_DOWNCOUNTER        <= '0';
    CNT_DOWNCOUNTER         <= '0';
    wait for 50 ns;
    -- descarrega metade
    PARALLEL_IN_DOWNCOUNTER <= "0000";
    LOAD_DOWNCOUNTER        <= '0';
    CNT_DOWNCOUNTER         <= '1';
    wait for 20 ns;
    -- tenta dar carga mesmo nao estando em zero
    PARALLEL_IN_DOWNCOUNTER <= "1000";
    LOAD_DOWNCOUNTER        <= '1';
    CNT_DOWNCOUNTER         <= '0';
    wait for 10 ns;
    -- termina de contar
    PARALLEL_IN_DOWNCOUNTER <= "0000";
    LOAD_DOWNCOUNTER        <= '0';
    CNT_DOWNCOUNTER         <= '1';
    wait for 20 ns;
    -- aguarda
    PARALLEL_IN_DOWNCOUNTER <= "0000";
    LOAD_DOWNCOUNTER        <= '0';
    CNT_DOWNCOUNTER         <= '0';
    wait for 50 ns;
    -- nova carga
    PARALLEL_IN_DOWNCOUNTER <= "1000";
    LOAD_DOWNCOUNTER        <= '1';
    CNT_DOWNCOUNTER         <= '0';
    wait for 10 ns;
    -- conta ate o fim e mesmo depois de zerar
    PARALLEL_IN_DOWNCOUNTER <= "0000";
    LOAD_DOWNCOUNTER        <= '0';
    CNT_DOWNCOUNTER         <= '1';
    wait;

end process;    
    
end architecture teste;