-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_4b6b_controller is
    port (
        -- interface externa
        I_RST_CTRL, I_CLK_CTRL  : in std_logic;
        I_VALID_CTRL            : in std_logic;
        I_CONSUME_CTRL          : in std_logic;
        O_VALID_CTRL            : out std_logic;
        O_IN_READY_CTRL         : out std_logic;
        -- interface com o datapath
        O_REG_IN_LOAD_CTRL      : out std_logic;
        O_REG_OUT_LOAD_CTRL     : out std_logic
    );
end entity enc_4b6b_controller;

architecture comportamental of enc_4b6b_controller is
 
    type t_state is (wait_in, load_out, wait_out);
    signal state, next_state : t_state;

----------------------------------------------------------------------------------------     

begin
    
    -- infere registrador de estados
    reg_state: process(I_CLK_CTRL)
    begin
        if rising_edge(I_CLK_CTRL) then
            if I_RST_CTRL = '1' then
                state <= wait_in;
            else
                state <= next_state;
            end if;
        end if;
    end process reg_state;

------------------------------------------------------------------------------------------

-- logica do proximo estado

comb_fsm: process(state, I_CONSUME_CTRL, I_VALID_CTRL)
begin
    -- atribuicoes de valores default
    O_VALID_CTRL        <= '0';
    O_IN_READY_CTRL     <= '0';
    O_REG_IN_LOAD_CTRL  <= '0';
    O_REG_OUT_LOAD_CTRL <= '0';

    case state is
        when wait_in =>
            O_IN_READY_CTRL <= '1';
            O_REG_IN_LOAD_CTRL  <= '1';

            if I_VALID_CTRL = '1' then
                next_state <= load_out;
            else
                next_state <= wait_in;
            end if;

        when load_out =>
            O_REG_OUT_LOAD_CTRL <= '1';

            next_state <= wait_out;

        when wait_out =>
            O_VALID_CTRL <= '1';

            if I_CONSUME_CTRL = '1' then
                next_state <= wait_in;
            else
                next_state <= wait_out;
            end if;            
    
        when others =>
            next_state <= wait_in;
    
    end case;
end process comb_fsm;
    
end architecture comportamental;