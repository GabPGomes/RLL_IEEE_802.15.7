library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DECOD_MCS_ID_tb is
end entity DECOD_MCS_ID_tb;

architecture teste of DECOD_MCS_ID_tb is
    
    component DECOD_MCS_ID is
        port (
            MCS_ID          : in  std_logic_vector(5 downto 0);
            OP_MODE         : out std_logic_vector(2 downto 0);
            VALID_MCS_ID    : out std_logic;
            NO_CODE_MCS_ID  : out std_logic
        );
    end component DECOD_MCS_ID;

------------------------------------------------------------------------

signal MCS_ID          : std_logic_vector(5 downto 0);
signal OP_MODE         : std_logic_vector(2 downto 0);
signal VALID_MCS_ID    : std_logic;
signal NO_CODE_MCS_ID  : std_logic;

-------------------------------------------------------------------------


begin
  
    dut: DECOD_MCS_ID
        port map(
            MCS_ID          =>  MCS_ID,          
            OP_MODE         =>  OP_MODE,         
            VALID_MCS_ID    =>  VALID_MCS_ID,    
            NO_CODE_MCS_ID  =>  NO_CODE_MCS_ID  
        );

   gera_mcs_id: process
   begin
    MCS_ID <= "000000";
    wait for 100 ns;

    loop
        wait for 10 ns;
        MCS_ID <= std_logic_vector(unsigned(MCS_ID) + 1);
    end loop;
    
   end process gera_mcs_id;
    
    
end architecture teste;