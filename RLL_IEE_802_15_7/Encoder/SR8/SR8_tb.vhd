library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SR8_tb is
end entity SR8_tb;

architecture teste of SR8_tb is
    component SR8 is
        port (
            CLK_SR8, RST_SR8  : in std_logic;
            P_IN_SR8   : in std_logic_vector(7 downto 0);
            P_LOAD_SR8 : in std_logic;
            S_READ_SR8 : in std_logic;
            S_OUT_SR8  : out std_logic
        );
    end component SR8;

---------------------------------------------------------------------

signal CLK_SR8, RST_SR8  : std_logic := '1';
signal P_IN_SR8   : std_logic_vector(7 downto 0);
signal P_LOAD_SR8 : std_logic;
signal S_READ_SR8 : std_logic;
signal S_OUT_SR8  : std_logic;

----------------------------------------------------------------------

begin
    
    dut: SR8
        port map(
            CLK_SR8    =>   CLK_SR8,    
            RST_SR8    =>   RST_SR8,    
            P_IN_SR8   =>   P_IN_SR8,   
            P_LOAD_SR8 =>   P_LOAD_SR8, 
            S_READ_SR8 =>   S_READ_SR8, 
            S_OUT_SR8  =>   S_OUT_SR8  
        );
        
CLK_SR8 <= not CLK_SR8 after 5 ns;

RST_SR8 <= '1', '0' after 100 ns;

testbench: process
begin
    -- estado inicial, aguardando o reset
    P_IN_SR8    <= (others => '0');
    P_LOAD_SR8  <= '0';
    S_READ_SR8  <= '0';
    wait for 100 ns;
    -- carga inicial com os dados
    P_IN_SR8    <= "10101010";
    P_LOAD_SR8  <= '1';
    S_READ_SR8  <= '0';
    wait for 10 ns;
    -- segunda carga para testar
    P_IN_SR8    <= (others => '0');
    P_LOAD_SR8  <= '1';
    S_READ_SR8  <= '0';
    wait for 20 ns;
    -- carga inicial com os dados
    P_IN_SR8    <= (others => '0');
    P_LOAD_SR8  <= '0';
    S_READ_SR8  <= '1';
    wait for 80 ns;
    -- aguarda um pouco
    P_IN_SR8    <= (others => '0');
    P_LOAD_SR8  <= '0';
    S_READ_SR8  <= '0';
    wait for 20 ns;
    -- tentativa de ler e escrever ao mesmo tempo
    P_IN_SR8    <= "11110000";
    P_LOAD_SR8  <= '1';
    S_READ_SR8  <= '1';
    wait for 10 ns;
    -- finalizando
    P_IN_SR8    <= (others => '0');
    P_LOAD_SR8  <= '0';
    S_READ_SR8  <= '0';
    wait;

end process;
    
end architecture teste;