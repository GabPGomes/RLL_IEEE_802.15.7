-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_8b10b_controller is
    port (
        -- sinais da interface
        I_RST_CTRL, I_CLK_CTRL  : in std_logic;
        I_VALID_CTRL            : in std_logic;
        I_CONSUME_CTRL          : in std_logic;
        O_VALID_CTRL            : out std_logic;
        O_IN_READY_CTRL         : out std_logic;
        -- comunicaçao com o caminho de dados
        O_ENC_RESET_CTRL        : out std_logic;
        O_CLK_GATE_ON_CTRL      : out std_logic;
        O_REG_IN_LOAD_CTRL      : out std_logic;
        O_REG_OUT_LOAD_CTRL     : out std_logic
    );
end entity enc_8b10b_controller;

architecture comportamental of enc_8b10b_controller is
 
    type t_state is (safe_reset, reset_controller, wait_in, start_encoder, wait_encoder_1, wait_encoder_2, load_out, wait_out);
    signal state, next_state : t_state;    

---------------------------------------------------------------------------------------- 

begin
    
    -- infere registrador de estados
    reg_state: process(I_CLK_CTRL)
    begin
        if rising_edge(I_CLK_CTRL) then
            if I_RST_CTRL = '1' then
                state <= safe_reset;
            else
                state <= next_state;
            end if;
        end if;
    end process reg_state; 

----------------------------------------------------------------------------------------
 
-- logica do proximo estado

comb_fsm: process(state, I_CONSUME_CTRL, I_VALID_CTRL)
begin
    -- atribuicoes de valores default
    O_VALID_CTRL        <= '0';
    O_IN_READY_CTRL     <= '0';
    O_ENC_RESET_CTRL    <= '0';
    O_CLK_GATE_ON_CTRL  <= '0';
    O_REG_IN_LOAD_CTRL  <= '0';
    O_REG_OUT_LOAD_CTRL <= '0';

    case state is

        when safe_reset =>
            next_state <= reset_controller;

        when reset_controller =>
            O_CLK_GATE_ON_CTRL <= '1';
            O_ENC_RESET_CTRL   <= '1';

            next_state <= wait_in;

        when wait_in =>
            O_IN_READY_CTRL <= '1';
            O_REG_IN_LOAD_CTRL  <= '1';

            if I_VALID_CTRL = '1' then
                next_state <= start_encoder;
            else
                next_state <= wait_in;
            end if;

        when start_encoder =>
            O_CLK_GATE_ON_CTRL  <= '1';
    
            next_state <= wait_encoder_1;

        when wait_encoder_1 =>
            O_CLK_GATE_ON_CTRL  <= '1';
    
            next_state <= wait_encoder_2;

        when wait_encoder_2 =>
            O_CLK_GATE_ON_CTRL  <= '1';
    
            next_state <= load_out;

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