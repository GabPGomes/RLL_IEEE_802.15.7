library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UpDownCounter is
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
end entity UpDownCounter;

architecture comportamental of UpDownCounter is
    
    signal zero, alm_zero : std_logic;
    signal full, alm_full : std_logic;
    signal cnt_reg, next_cnt_reg  : unsigned(4 downto 0);
    signal parallel_in_reg, next_parallel_in_reg  : unsigned(4 downto 0);   

-----------------------------------------------------------------------------------------------

begin
    
   infere_reg: process(CLK_COUNTER)
    begin
        if rising_edge(CLK_COUNTER) then
            cnt_reg         <= next_cnt_reg;
            parallel_in_reg <= next_parallel_in_reg; 
        end if;
   end process infere_reg;

----------------------------------------------------------------------------------------------
 
-- controle dos registradores

    next_parallel_in_reg <= "00000"                         when RST_COUNTER = '1'                      else
                            unsigned(PARALLEL_IN_COUNTER)   when LOAD_COUNTER = '1' and zero = '1'      else
                            parallel_in_reg;


    next_cnt_reg <= "00000"     when RST_COUNTER = '1'  else
                    cnt_reg - 1 when UP_CNT_COUNTER = '0' and DWN_CNT_COUNTER = '1' and zero = '0'   else
                    cnt_reg + 1 when UP_CNT_COUNTER = '1' and DWN_CNT_COUNTER = '0' and full = '0'   else
                    cnt_reg;

-- controle dos sinais de saida                    

    zero <= '1' when cnt_reg = "00000" else '0';
    ZERO_COUNTER <= zero;

    alm_zero <= '1' when cnt_reg = "00001" else '0';
    ALM_ZERO_COUNTER <= alm_zero;

    full <= '1' when cnt_reg = parallel_in_reg else '0';

    alm_full <= '1' when cnt_reg = (parallel_in_reg - 1) else '0';
    ALM_FULL_COUNTER <= alm_full;
    
end architecture comportamental;