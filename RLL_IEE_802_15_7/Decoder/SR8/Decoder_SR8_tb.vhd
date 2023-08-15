library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder_SR8_tb is
end entity Decoder_SR8_tb;

architecture teste of Decoder_SR8_tb is
    component Decoder_SR8 is
        port (
            CLK_SR8, RST_SR8  : in std_logic;
            S_IN_SR8   : in std_logic;
            S_LOAD_SR8 : in std_logic;
            P_OUT_SR8  : out std_logic_vector(7 downto 0)
        );
    end component Decoder_SR8;

---------------------------------------------------------------------

signal CLK_SR8, RST_SR8  : std_logic := '1';
signal S_IN_SR8   : std_logic;
signal S_LOAD_SR8 : std_logic;
signal P_OUT_SR8  : std_logic_vector(7 downto 0);

----------------------------------------------------------------------

begin

    dut: Decoder_SR8
        port map(
            CLK_SR8     => CLK_SR8,
            RST_SR8     => RST_SR8,
            S_IN_SR8    => S_IN_SR8,
            S_LOAD_SR8  => S_LOAD_SR8,
            P_OUT_SR8   => P_OUT_SR8
        );
        
CLK_SR8 <= not CLK_SR8 after 5 ns;

RST_SR8 <= '1', '0' after 100 ns, '1' after 500 ns, '0' after 510 ns;

testbench: process
begin
    -- estado inicial, aguardando o reset
    S_IN_SR8    <= '0';
    S_LOAD_SR8  <= '0';
    wait for 100 ns;
    -- carga inicial com os dados
    S_IN_SR8    <= '1';
    S_LOAD_SR8  <= '1';
    wait for 40 ns;
    --
    S_IN_SR8    <= '0';
    S_LOAD_SR8  <= '1';
    wait for 40 ns;
    -- segunda carga para testar
    S_IN_SR8    <= '1';
    S_LOAD_SR8  <= '1';
    wait for 20 ns;
    -- finalizando
    S_IN_SR8    <= '0';
    S_LOAD_SR8  <= '0';
    wait;

end process;
    
end architecture teste;