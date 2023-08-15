library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UpDownCounter_tb is
end entity UpDownCounter_tb;

architecture teste of UpDownCounter_tb is

    component UpDownCounter is
        port (
            CLK_COUNTER, RST_COUNTER        : in std_logic;
            LOAD_COUNTER                    : in std_logic;   
            DWN_CNT_COUNTER                 : in std_logic;
				UP_CNT_COUNTER                  : in std_logic;
            PARALLEL_IN_COUNTER             : in std_logic_vector(4 downto 0);
            ZERO_COUNTER                    : out std_logic;
            ALM_ZERO_COUNTER                : out std_logic; 
            ALM_FULL_COUNTER                : out std_logic 
        );
    end component UpDownCounter;

-----------------------------------------------------------------------------------------------

signal CLK_COUNTER          : std_logic := '1';
signal RST_COUNTER          : std_logic;
signal LOAD_COUNTER         : std_logic;   
signal DWN_CNT_COUNTER      : std_logic;
signal UP_CNT_COUNTER       : std_logic;
signal PARALLEL_IN_COUNTER  : std_logic_vector(4 downto 0);
signal ZERO_COUNTER         : std_logic;
signal ALM_ZERO_COUNTER     : std_logic;
signal ALM_FULL_COUNTER     : std_logic;

------------------------------------------------------------------------------------------------

begin
 
    dut: UpDownCounter
        port map (
            CLK_COUNTER         =>  CLK_COUNTER,
            RST_COUNTER         =>  RST_COUNTER,
            LOAD_COUNTER        =>  LOAD_COUNTER,
            DWN_CNT_COUNTER     =>  DWN_CNT_COUNTER,
            UP_CNT_COUNTER      =>  UP_CNT_COUNTER,
            PARALLEL_IN_COUNTER =>  PARALLEL_IN_COUNTER,
            ZERO_COUNTER        =>  ZERO_COUNTER,  
            ALM_ZERO_COUNTER    =>  ALM_ZERO_COUNTER,
            ALM_FULL_COUNTER    =>  ALM_FULL_COUNTER
        );    

CLK_COUNTER <= not CLK_COUNTER after 5 ns;

RST_COUNTER <= '1', '0' after 100 ns;

testbench: process
begin

    -- inicia
    PARALLEL_IN_COUNTER <= "00000";
    LOAD_COUNTER        <= '0';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '0';
    wait for 100 ns;
    -- carga com 8
    PARALLEL_IN_COUNTER <= "01000";
    LOAD_COUNTER        <= '1';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '0';
    wait for 10 ns;
    -- aguarda um pouco
    PARALLEL_IN_COUNTER <= "00000";
    LOAD_COUNTER        <= '0';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '0';
    wait for 50 ns;
    -- carrega metade
    PARALLEL_IN_COUNTER <= "00000";
    LOAD_COUNTER        <= '0';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '1';
    wait for 40 ns;
    -- tenta dar carga mesmo nao estando em zero
    PARALLEL_IN_COUNTER <= "10000";
    LOAD_COUNTER        <= '1';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '0';
    wait for 10 ns;
    -- termina de carregar, tenta carregar depois de cheio
    PARALLEL_IN_COUNTER <= "00000";
    LOAD_COUNTER        <= '0';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '1';
    wait for 50 ns;
    -- aguarda
    PARALLEL_IN_COUNTER <= "00000";
    LOAD_COUNTER        <= '0';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '0';
    wait for 50 ns;
    -- decrementa, mesmo depois de vazio
    PARALLEL_IN_COUNTER <= "00000";
    LOAD_COUNTER        <= '0';
    DWN_CNT_COUNTER     <= '1';
    UP_CNT_COUNTER      <= '0';
    wait for 90 ns;
    -- fim
    PARALLEL_IN_COUNTER <= "00000";
    LOAD_COUNTER        <= '0';
    DWN_CNT_COUNTER     <= '0';
    UP_CNT_COUNTER      <= '0';
    wait;

end process;    
    
end architecture teste;