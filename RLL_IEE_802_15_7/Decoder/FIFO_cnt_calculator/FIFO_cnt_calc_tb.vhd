library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIFO_cnt_calc_tb is
end entity FIFO_cnt_calc_tb;

architecture teste of FIFO_cnt_calc_tb is
    
    component FIFO_cnt_calc is
        port (
            OP_MODE_CALC    : in std_logic_vector(2 downto 0);
            COUNTER_IN_CALC : out std_logic_vector(4 downto 0)
        );
    end component FIFO_cnt_calc;

-------------------------------------------------------------------------

signal OP_MODE_CALC    : unsigned(2 downto 0);
signal COUNTER_IN_CALC : std_logic_vector(4 downto 0);

--------------------------------------------------------------------------

begin

    dut : FIFO_cnt_calc
    port map(
        OP_MODE_CALC    => std_logic_vector(OP_MODE_CALC),
        COUNTER_IN_CALC => COUNTER_IN_CALC
    );

---------------------------------------------------------------------------

testbench: process
begin

    OP_MODE_CALC <= "000";
    loop
        wait for 10 ns;
        OP_MODE_CALC <= OP_MODE_CALC + 1;
    end loop;

end process;    
    
end architecture teste;