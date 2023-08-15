library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Countdown_in_calc_tb is
end entity Countdown_in_calc_tb;

architecture teste of Countdown_in_calc_tb is
    
    component Countdown_in_calc is
        port (
            OP_MODE_CNT       : in std_logic_vector(2 downto 0);
            COUNTDOWN_IN_CNT  : out std_logic_vector(3 downto 0)
        );
    end component Countdown_in_calc;

-------------------------------------------------------------------------

signal OP_MODE_CNT : unsigned(2 downto 0);
signal COUNTDOWN_IN_CNT : std_logic_vector(3 downto 0);

--------------------------------------------------------------------------

begin

    dut : Countdown_in_calc
    port map(
        OP_MODE_CNT       => std_logic_vector(OP_MODE_CNT),
        COUNTDOWN_IN_CNT  => COUNTDOWN_IN_CNT
    );

---------------------------------------------------------------------------

testbench: process
begin

    OP_MODE_CNT <= "000";
    loop
        wait for 10 ns;
        OP_MODE_CNT <= OP_MODE_CNT + 1;
    end loop;

end process;    
    
end architecture teste;