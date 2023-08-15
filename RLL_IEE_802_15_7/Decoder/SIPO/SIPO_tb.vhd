library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SIPO_tb is
end entity SIPO_tb;

architecture teste of SIPO_tb is
    
    component SIPO is
        generic(OUTPUT_WIDTH   :   natural := 8);
        port (
                CLK_SIPO, RST_SIPO : in std_logic;
                S_IN_SIPO   :   in std_logic;
                S_LOAD_SIPO :   in std_logic;
                P_READ_SIPO :   in std_logic;
                FULL_SIPO   :   out std_logic;
                P_OUT_SIPO  :   out std_logic_vector(OUTPUT_WIDTH-1 downto 0)       
        );
    end component SIPO;

---------------------------------------------------------------------------------------
    
    constant OUTPUT_WIDTH : natural := 4;

    signal CLK_SIPO     :   std_logic := '1';
    signal RST_SIPO     :   std_logic;
    signal S_IN_SIPO    :   std_logic;
    signal S_LOAD_SIPO  :   std_logic;
    signal P_READ_SIPO  :   std_logic;
    signal FULL_SIPO    :   std_logic;
    signal P_OUT_SIPO   :   std_logic_vector(OUTPUT_WIDTH-1 downto 0);

-----------------------------------------------------------------------------------------

begin
   
    dut: SIPO 
        generic map(OUTPUT_WIDTH => OUTPUT_WIDTH)
        port map(
                CLK_SIPO    =>  CLK_SIPO,     
                RST_SIPO    =>  RST_SIPO,     
                S_IN_SIPO   =>  S_IN_SIPO,        
                S_LOAD_SIPO =>  S_LOAD_SIPO,          
                P_READ_SIPO =>  P_READ_SIPO,          
                FULL_SIPO   =>  FULL_SIPO,            
                P_OUT_SIPO  =>  P_OUT_SIPO                
        );  

----------------------------------------------------------------------------------------------

CLK_SIPO <= not CLK_SIPO after 5 ns;
RST_SIPO <= '1', '0' after 100 ns;

simu_proc: process
begin
	-- estado inicial
	S_IN_SIPO	<= '0';
	S_LOAD_SIPO	<=	'0';
	P_READ_SIPO	<=	'0';
	wait for 105 ns;
	-- faz carga parcial
	S_IN_SIPO	<= '0';
	S_LOAD_SIPO	<=	'1';
	P_READ_SIPO	<=	'0';
	wait for 10 ns;
	S_IN_SIPO	<= '1';
	S_LOAD_SIPO	<=	'1';
	P_READ_SIPO	<=	'0';
	wait for 10 ns;
	S_IN_SIPO	<= '0';
	S_LOAD_SIPO	<=	'1';
	P_READ_SIPO	<=	'0';
	wait for 10 ns;
	S_IN_SIPO	<= '1';
	S_LOAD_SIPO	<=	'1';
	P_READ_SIPO	<=	'0';
	wait for 10 ns;
	-- faz uma tentativa de leitura com nao cheio
	S_IN_SIPO 	<= '0';
	S_LOAD_SIPO <= '0';
	P_READ_SIPO	<= '0';
	wait for 30 ns;
	S_IN_SIPO	<= '0';
	S_LOAD_SIPO	<=	'0';
	P_READ_SIPO	<=	'1';
	wait for 10 ns;
	-- termina de fazer a carga
	--S_IN_SIPO	<= '0';
	--S_LOAD_SIPO	<=	'1';
	--P_READ_SIPO	<=	'0';
	--wait for 10ns;
	--S_IN_SIPO	<= '1';
	--S_LOAD_SIPO	<=	'1';
	--P_READ_SIPO	<=	'0';
	--wait for 10ns;
	--S_IN_SIPO	<= '0';
	--S_LOAD_SIPO	<=	'1';
	--P_READ_SIPO	<=	'0';
	--wait for 10ns;
	--S_IN_SIPO	<= '1';
	--S_LOAD_SIPO	<=	'1';
	--P_READ_SIPO	<=	'0';
	--wait for 10ns;
	-- aguarda um pouco
	--S_IN_SIPO 	<= '0';
	--S_LOAD_SIPO <= '0';
	--P_READ_SIPO	<= '0';
	--wait for 30ns;
	-- faz uma tentativa de escrita com cheio
	--S_IN_SIPO 	<= '1';
	--S_LOAD_SIPO <= '1';
	--P_READ_SIPO	<= '0';
	--wait for 10ns;
	-- faz a leitura dos dados
	--S_IN_SIPO 	<= '0';
	--S_LOAD_SIPO <= '0';
	--P_READ_SIPO	<= '1';
	--wait for 10ns;
	-- finaliza
	S_IN_SIPO 	<= '0';
	S_LOAD_SIPO <= '0';
	P_READ_SIPO	<= '0';
	wait;
end process;

end architecture teste;