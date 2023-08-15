-- controladora do codificador RLL
-- detalhes do projeto na pasta do google drive do TCC
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_rll_controller is
    port (
        -- gerais
        CLK_CONTROLLER, RST_CONTROLLER              : in std_logic;
        RST_INTERNAL_CONTROLLER                     : out std_logic;
        -- contador regressivo
        ZERO_DOWNCNT_CONTROLLER                     : in std_logic;
        ONE_DOWNCNT_CONTROLLER                      : in std_logic;
        DECR_DOWNCNT_CONTROLLER                     : out std_logic;
        LOAD_DOWNCNT_CONTROLLER                     : out std_logic;
        -- registrador de entrada
        P_LOAD_SHIFT_CONTROLLER                     : out std_logic;
        S_READ_SHIFT_CONTROLLER                     : out std_logic;
        -- registrador e decodificador de MCS ID
        VALID_MCS_ID_CONTROLLER                     : in std_logic;
        NO_CODE_MCS_ID_CONTROLLER                   : in std_logic;
        LOAD_MCS_ID_CONTROLLER                      : out std_logic;
        -- SIPO's
        ALM_FULL_SIPO_CONTROLLER                    : in  std_logic;
        S_LOAD_SIPO_CONTROLLER                      : out std_logic;
        P_READ_SIPO_CONTROLLER                      : out std_logic;
        -- Codificadores
        O_IN_READY_INTERNAL_ENCS_CONTROLLER         : in std_logic;
        O_VALID_INTERNAL_ENCS_CONTROLLER            : in std_logic;
        I_VALID_INTERNAL_ENCS_CONTROLLER            : out std_logic;
        I_CONSUME_INTERNAL_ENCS_CONTROLLER          : out std_logic;
        -- PISO's
        ALM_EMPTY_PISO_CONTROLLER                   : in std_logic;
        P_LOAD_PISO_CONTROLLER                      : out std_logic;
        S_READ_PISO_CONTROLLER                      : out std_logic;
        -- FIFO
        LAST_FIFO_CONTROLLER                        : in std_logic;
        LOAD_FIFO_CONTROLLER                        : out std_logic;
        READ_FIFO_CONTROLLER                        : out std_logic;
        -- Interface AMBA
        I_CONSUME_RLL_ENC_CONTROLLER                : in std_logic;
        I_VALID_RLL_ENC_CONTROLLER                  : in std_logic;
        O_IN_READY_RLL_ENC_CONTROLLER               : out std_logic;
        O_LAST_DATA_RLL_ENC_CONTROLLER              : out std_logic;
        O_VALID_RLL_ENC_CONTROLLER                  : out std_logic;
        -- Ultimo dado do pacote
        LOAD_LAST                                   : out std_logic;
        REG_LAST                                    : in std_logic;
        -- Sinalizacao de erro                  
        O_ERR_MCS_ID                                : out std_logic
    );
end entity enc_rll_controller;

architecture comportamental of enc_rll_controller is

    -- 16 estados no total, 5 em cada linha
type state_t is (RESET_ENC_FINISH_PACKET,   WAIT_IN,                    CHECK_MCS_ID,               ERR_MCS_ID,             CHECK_VALID,
                LOAD_IN,                    LOAD_SEC_IN,                WAIT_ENC_READY,             WAIT_ENC_DONE,          LOAD_OUT,
                READ_CHECK_FIFO,            WAIT_OUT_CONTINUE,          WAIT_OUT_FINISH_PACKET,     WAIT_OUT_FINISH_WORD,   RESET_ENC_FINISH_WORD,
                LOAD_DIRECT
                );

signal state, next_state : state_t;

------------------------------------------------------------------------------------------

-- inicio da arquitetura
begin

-------------------------------------------------------------------------------------------
    
state_reg: process(CLK_CONTROLLER)
begin
    if(rising_edge(CLK_CONTROLLER)) then
        if(RST_CONTROLLER = '1') then
            state <= RESET_ENC_FINISH_PACKET;
        else
            state <= next_state;
        end if;
    end if;
end process state_reg;

--------------------------------------------------------------------------------------------

comb_fsm : process(state,
                    -- contador
                    ZERO_DOWNCNT_CONTROLLER, ONE_DOWNCNT_CONTROLLER, 
                    -- MCS_ID
                    VALID_MCS_ID_CONTROLLER, NO_CODE_MCS_ID_CONTROLLER,
                    -- SIPOs
                    ALM_FULL_SIPO_CONTROLLER,
                    -- codificadores
                    O_IN_READY_INTERNAL_ENCS_CONTROLLER, O_VALID_INTERNAL_ENCS_CONTROLLER,
                    -- PISOs
                    ALM_EMPTY_PISO_CONTROLLER,
                    -- FIFO
                    LAST_FIFO_CONTROLLER,
                    -- interface externa
                    I_CONSUME_RLL_ENC_CONTROLLER, I_VALID_RLL_ENC_CONTROLLER,
                    -- ultimo dado do pacote
                    REG_LAST
                )
begin
    -- valor default para as saídas
    
    -- gerais
    RST_INTERNAL_CONTROLLER <= '0';
    -- contador regressivo
    DECR_DOWNCNT_CONTROLLER <= '0';
    LOAD_DOWNCNT_CONTROLLER <= '0';
    -- registrador de entrada
    P_LOAD_SHIFT_CONTROLLER    <= '0';           
    S_READ_SHIFT_CONTROLLER    <= '0';
    -- registrador e decodificador de MCS_ID           
    LOAD_MCS_ID_CONTROLLER <= '0';
    -- SIPO's            
    S_LOAD_SIPO_CONTROLLER  <= '0';            
    P_READ_SIPO_CONTROLLER  <= '0';
    -- Codificadores            
    I_VALID_INTERNAL_ENCS_CONTROLLER   <= '0';  
    I_CONSUME_INTERNAL_ENCS_CONTROLLER <= '0';
    -- PISO's
    P_LOAD_PISO_CONTROLLER <= '0';            
    S_READ_PISO_CONTROLLER <= '0';
    -- FIFO           
    LOAD_FIFO_CONTROLLER   <= '0';              
    READ_FIFO_CONTROLLER   <= '0';
    -- Interface AMBA             
    O_IN_READY_RLL_ENC_CONTROLLER  <= '0';     
    O_LAST_DATA_RLL_ENC_CONTROLLER <= '0';    
    O_VALID_RLL_ENC_CONTROLLER <= '0';
    -- ultimo dado
    LOAD_LAST   <= '0';
    -- erro
    O_ERR_MCS_ID <= '0';
    
    
    case state is
        when RESET_ENC_FINISH_PACKET       =>
            RST_INTERNAL_CONTROLLER <= '1';

            next_state <= WAIT_IN;
        
        when WAIT_IN        =>
            LOAD_MCS_ID_CONTROLLER <= '1';

            if(I_VALID_RLL_ENC_CONTROLLER = '1') then
                next_state <= CHECK_MCS_ID;
            else
                next_state <= state;
            end if;

        when CHECK_MCS_ID =>
            if(VALID_MCS_ID_CONTROLLER = '1') then
                next_state <= CHECK_VALID;
            else
                next_state <= ERR_MCS_ID;
            end if;

        when ERR_MCS_ID =>
            O_ERR_MCS_ID <= '1';
            O_IN_READY_RLL_ENC_CONTROLLER <= '1';

            next_state <= WAIT_IN;

            when CHECK_VALID =>
            if(I_VALID_RLL_ENC_CONTROLLER = '1') then
                next_state <= LOAD_IN;
            else
                next_state <= state;
            end if;

        when LOAD_IN        =>
            O_IN_READY_RLL_ENC_CONTROLLER   <= '1';
            LOAD_DOWNCNT_CONTROLLER         <= '1';
            P_LOAD_SHIFT_CONTROLLER         <= '1';
            LOAD_LAST                       <= '1';

            if(NO_CODE_MCS_ID_CONTROLLER = '1') then
                next_state <= LOAD_DIRECT;					 
            else
                next_state <= LOAD_SEC_IN;
            end if;

        when LOAD_SEC_IN    =>
            S_READ_SHIFT_CONTROLLER <= '1';
            S_LOAD_SIPO_CONTROLLER  <= '1';
            DECR_DOWNCNT_CONTROLLER <= '1';

            if(ALM_FULL_SIPO_CONTROLLER = '1') then
                next_state <= WAIT_ENC_READY;
            else
                next_state <= state;
            end if;

        when WAIT_ENC_READY =>
            I_VALID_INTERNAL_ENCS_CONTROLLER <= '1';

            if(O_IN_READY_INTERNAL_ENCS_CONTROLLER = '1') then
                next_state <= WAIT_ENC_DONE;
            else
                next_state <= state;
            end if;

        when WAIT_ENC_DONE  =>
            -- limpa o sipo que ja foi lido
            P_READ_SIPO_CONTROLLER <= '1';
            -- ja se adianta e fica lendo a saida do codificador
            P_LOAD_PISO_CONTROLLER <= '1';
            I_CONSUME_INTERNAL_ENCS_CONTROLLER <= '1';
        
            if(O_VALID_INTERNAL_ENCS_CONTROLLER = '1') then
                next_state <= LOAD_OUT;
            else
                next_state <= state;
            end if;

        when LOAD_OUT       =>
            S_READ_PISO_CONTROLLER <= '1';
            LOAD_FIFO_CONTROLLER <= '1';

            if ALM_EMPTY_PISO_CONTROLLER = '0' then
                next_state <= state;
            elsif (ALM_EMPTY_PISO_CONTROLLER = '1' and ZERO_DOWNCNT_CONTROLLER = '1') then
                next_state <= READ_CHECK_FIFO;
            elsif (ALM_EMPTY_PISO_CONTROLLER = '1' and ZERO_DOWNCNT_CONTROLLER = '0') then
                next_state <= LOAD_SEC_IN;
            else
                next_state <= state;
            end if;

        when READ_CHECK_FIFO  =>
            READ_FIFO_CONTROLLER <= '1';

            -- se for o ultimo dado da fifo, confere se e o ultimo do pacote
            if LAST_FIFO_CONTROLLER = '0' then
                next_state <= WAIT_OUT_CONTINUE;
            elsif REG_LAST = '1' then
                next_state <= WAIT_OUT_FINISH_PACKET;
            else
                next_state <= WAIT_OUT_FINISH_WORD;
            end if;

        when WAIT_OUT_CONTINUE =>
            O_VALID_RLL_ENC_CONTROLLER <= '1';

            if I_CONSUME_RLL_ENC_CONTROLLER = '1' then
                next_state <= READ_CHECK_FIFO;
            else
                next_state <= state;
            end if;

        when WAIT_OUT_FINISH_PACKET       =>
            O_VALID_RLL_ENC_CONTROLLER <= '1';
            O_LAST_DATA_RLL_ENC_CONTROLLER <= '1';

            if(I_CONSUME_RLL_ENC_CONTROLLER = '1') then
                next_state <= RESET_ENC_FINISH_PACKET;
            else
                next_state <= state;
            end if;

        when WAIT_OUT_FINISH_WORD       =>
            O_VALID_RLL_ENC_CONTROLLER <= '1';

            if(I_CONSUME_RLL_ENC_CONTROLLER = '1') then
                next_state <= RESET_ENC_FINISH_WORD;
            else
                next_state <= state;
            end if;

        when RESET_ENC_FINISH_WORD =>
            RST_INTERNAL_CONTROLLER <= '1';

            next_state <= CHECK_VALID;

        when LOAD_DIRECT    =>
            S_READ_SHIFT_CONTROLLER <= '1';
            LOAD_FIFO_CONTROLLER <= '1';
            DECR_DOWNCNT_CONTROLLER <= '1';

            if(ONE_DOWNCNT_CONTROLLER = '1') then
                next_state <= READ_CHECK_FIFO;
            else
                next_state <= state;
            end if;

        when others         =>
            next_state <= RESET_ENC_FINISH_PACKET;
    end case;

end process comb_fsm;
    
end architecture comportamental;