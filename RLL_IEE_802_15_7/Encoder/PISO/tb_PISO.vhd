library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_PISO is
end entity tb_PISO;

architecture teste of tb_PISO is
   
    constant INPUT_WIDTH    : natural := 4;

    component PISO is
        generic(INPUT_WIDTH : natural := 8);
        port (
            CLK_PISO, RST_PISO  : in std_logic;
            P_IN_PISO   : in std_logic_vector(INPUT_WIDTH-1 downto 0);
            P_LOAD_PISO : in std_logic;
            S_READ_PISO : in std_logic;
            EMPTY_PISO  : out std_logic;
            S_OUT_PISO  : out std_logic
        );
    end component PISO;

-----------------------------------------------------------------------------------------

signal CLK_PISO    : std_logic := '1';
signal RST_PISO    : std_logic;
signal P_IN_PISO   : std_logic_vector(INPUT_WIDTH-1 downto 0);
signal P_LOAD_PISO : std_logic;
signal S_READ_PISO : std_logic;
signal EMPTY_PISO  : std_logic;
signal S_OUT_PISO  : std_logic;

------------------------------------------------------------------------------------------

begin
    
    dut: PISO
        generic map (INPUT_WIDTH => INPUT_WIDTH)
        port map(
            CLK_PISO    =>  CLK_PISO,        
            RST_PISO    =>  RST_PISO,        
            P_IN_PISO   =>  P_IN_PISO,       
            P_LOAD_PISO =>  P_LOAD_PISO,      
            S_READ_PISO =>  S_READ_PISO,      
            EMPTY_PISO  =>  EMPTY_PISO,        
            S_OUT_PISO  =>  S_OUT_PISO        
        );    
 
---------------------------------------------------------------------------------------------        
CLK_PISO <= not CLK_PISO after 5 ns;
RST_PISO <= '1', '0' after 99 ns;

teste_proc : process
begin
    -- iniciar
    P_IN_PISO <= "0000";
    P_LOAD_PISO <= '0';
    S_READ_PISO <= '0';
    wait for 100 ns;
	 
	 -- teste de leitura a vazio
	 S_READ_PISO <= '1';
	 wait for 10 ns;
	 S_READ_PISO <= '0';
	 wait for 10 ns;
    
	 -- carga inicial
    P_IN_PISO <= "0101";
    P_LOAD_PISO <= '1';
    S_READ_PISO <= '0';
    wait for 10 ns;
    
	 -- aguarda um pouco
    P_IN_PISO <= "0000";
    P_LOAD_PISO <= '0';
    S_READ_PISO <= '0';
    wait for 20 ns;
	 
	 --carga com ele cheio
	 P_LOAD_PISO <= '1';
	 wait for 10 ns;
	 P_LOAD_PISO <= '0';
	 wait for 10 ns;
    
	 -- leitura continua dos dados
    P_IN_PISO <= "0000";
    P_LOAD_PISO <= '0';
    S_READ_PISO <= '1';
    wait for 40 ns;
    
	 -- fim
    P_IN_PISO <= "0000";
    P_LOAD_PISO <= '0';
    S_READ_PISO <= '0';

end process teste_proc;

end architecture teste;