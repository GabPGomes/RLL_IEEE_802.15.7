library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DOWNCOUNTER is
    port (
        CLK_DOWNCOUNTER, RST_DOWNCOUNTER    : in std_logic;
        LOAD_DOWNCOUNTER                    : in std_logic;   
        CNT_DOWNCOUNTER                     : in std_logic;
        PARALLEL_IN_DOWNCOUNTER             : in std_logic_vector(3 downto 0);
        ZERO_DOWNCOUNTER                    : out std_logic;
        ONE_DOWNCOUNTER                     : out std_logic 
    );
end entity DOWNCOUNTER;

architecture comportamental of DOWNCOUNTER is
    
    signal zero, one : std_logic;
    signal reg, next_reg  : unsigned(3 downto 0);   

-----------------------------------------------------------------------------------------------

begin
    
   infere_reg: process(CLK_DOWNCOUNTER)
    begin
        if rising_edge(CLK_DOWNCOUNTER) then
            reg <= next_reg;
        end if;
   end process infere_reg;

----------------------------------------------------------------------------------------------

    next_reg <=     "0000"                              when RST_DOWNCOUNTER = '1'                  else
                    unsigned(PARALLEL_IN_DOWNCOUNTER)   when LOAD_DOWNCOUNTER = '1' and zero = '1'  else
                    reg - 1                             when CNT_DOWNCOUNTER = '1' and zero = '0'   else
                    reg;
            
    zero <= '1' when reg = "0000" else '0';
    ZERO_DOWNCOUNTER <= zero;

    one <= '1' when reg = "0001" else '0';
    ONE_DOWNCOUNTER <= one;
    
end architecture comportamental;