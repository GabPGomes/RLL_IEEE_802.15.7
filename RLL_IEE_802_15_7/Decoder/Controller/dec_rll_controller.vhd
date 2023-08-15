library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_rll_controller is
    port (
        -- gerais
        CLK_CONTROLLER, RST_CONTROLLER              : in std_logic;
        RST_INTERNAL_CONTROLLER                     : out std_logic;
        -- contador progressivo/regressivo
        ZERO_COUNTER_CONTROLLER                     : in std_logic;
        ALM_FULL_COUNTER_CONTROLLER                 : in std_logic;
        LOAD_COUNTER_CONTROLLER                     : out std_logic;
        DWN_CNT_COUNTER_CONTROLLER                  : out std_logic;
        UP_CNT_COUNTER_CONTROLLER                   : out std_logic;
        -- FIFO de entrada
        LOAD_FIFO_CONTROLLER                        : out std_logic;
        READ_FIFO_CONTROLLER                        : out std_logic;
        -- registrador e decodificador de MCS ID
        VALID_MCS_ID_CONTROLLER                     : in std_logic;
        LOAD_MCS_ID_CONTROLLER                      : out std_logic;
        -- SIPO's
        ALM_FULL_SIPO_CONTROLLER                    : in  std_logic;
        S_LOAD_SIPO_CONTROLLER                      : out std_logic;
        P_READ_SIPO_CONTROLLER                      : out std_logic;
        -- Codificadores
        -- colocar os sinais de erro aqui dentro se possivel
        O_IN_READY_INTERNAL_DECS_CONTROLLER         : in std_logic;
        O_VALID_INTERNAL_DECS_CONTROLLER            : in std_logic;
        I_VALID_INTERNAL_DECS_CONTROLLER            : out std_logic;
        I_CONSUME_INTERNAL_DECS_CONTROLLER          : out std_logic;
        -- PISO's
        ALM_EMPTY_PISO_CONTROLLER                   : in std_logic;
        P_LOAD_PISO_CONTROLLER                      : out std_logic;
        S_READ_PISO_CONTROLLER                      : out std_logic;
        -- registrador de saida
        S_LOAD_SHIFT_CONTROLLER                     : out std_logic;
        -- gerenciamento de ultimo bit
        REG_LAST_CONTROLLER                         : in std_logic;
        LOAD_LAST_CONTROLLER                        : out std_logic;
        -- Interface pseudo AMBA
        I_CONSUME_RLL_DEC_CONTROLLER                : in std_logic;
        I_VALID_RLL_DEC_CONTROLLER                  : in std_logic;
        I_LAST_DATA_RLL_DEC                         : in std_logic;
        O_IN_READY_RLL_DEC_CONTROLLER               : out std_logic;
        O_LAST_DATA_RLL_DEC_CONTROLLER              : out std_logic;
        O_VALID_RLL_DEC_CONTROLLER                  : out std_logic;
        -- Tratamento de erro
        ERR_LAST_CONTROLLER                         : out std_logic;
        ERR_MCS_ID_CONTROLLER                       : out std_logic
    );
end entity dec_rll_controller;

architecture behaviour of dec_rll_controller is
 
-- 18 estados no total, 5 em cada linha
type state_t is (   RESET_DEC_LAST,     WAIT_IN,        CHECK_MCS_ID,   ERR_MCS_ID,     CHECK_VALID_LAST,
                    LOAD_IN,            LOAD_LAST,      FILL_LAST,      PRE_READ_FIFO,  LOAD_SEC_IN,
                    WAIT_DEC_READY,     WAIT_DEC_DONE,  LOAD_OUT,       CHECK_LAST,     WAIT_OUT,
                    WAIT_LAST_OUT,      RESET_DEC,      SET_COUNTER
                );

signal state, next_state : state_t;

-------------------------------------------------------------------------------------------------------------

begin
    
state_reg: process(CLK_CONTROLLER)
begin
    if(rising_edge(CLK_CONTROLLER)) then
        if(RST_CONTROLLER = '1') then
            state <= RESET_DEC_LAST;
        else
            state <= next_state;
        end if;
    end if;
end process state_reg;    
 
-------------------------------------------------------------------------------------------------------------

comb_fsm : process  (   state,
                        -- contador progressivo/regressivo
                        ZERO_COUNTER_CONTROLLER, ALM_FULL_COUNTER_CONTROLLER,
                        -- registrador e decodificador de MCS ID
                        VALID_MCS_ID_CONTROLLER,
                        -- SIPO's
                        ALM_FULL_SIPO_CONTROLLER,
                        -- Codificadores
                        O_IN_READY_INTERNAL_DECS_CONTROLLER, O_VALID_INTERNAL_DECS_CONTROLLER,
                        -- PISO's
                        ALM_EMPTY_PISO_CONTROLLER,
                        -- gerenciamento de ultimo bit
                        REG_LAST_CONTROLLER,
                        -- Interface pseudo AMBA
                        I_CONSUME_RLL_DEC_CONTROLLER, I_VALID_RLL_DEC_CONTROLLER, I_LAST_DATA_RLL_DEC
                    )

begin

    -- valor default para as saidas
    
    -- gerais
    RST_INTERNAL_CONTROLLER <= '0';
    -- contador progressivo/regressivo
    LOAD_COUNTER_CONTROLLER     <= '0';
    DWN_CNT_COUNTER_CONTROLLER  <= '0';
    UP_CNT_COUNTER_CONTROLLER   <= '0';
    -- FIFO           
    LOAD_FIFO_CONTROLLER   <= '0';              
    READ_FIFO_CONTROLLER   <= '0';
    -- registrador e decodificador de MCS_ID           
    LOAD_MCS_ID_CONTROLLER <= '0';
    -- SIPO's            
    S_LOAD_SIPO_CONTROLLER  <= '0';            
    P_READ_SIPO_CONTROLLER  <= '0';
    -- Codificadores            
    I_VALID_INTERNAL_DECS_CONTROLLER   <= '0';  
    I_CONSUME_INTERNAL_DECS_CONTROLLER <= '0';
    -- PISO's
    P_LOAD_PISO_CONTROLLER <= '0';            
    S_READ_PISO_CONTROLLER <= '0';
    -- gerenciamennto de ultimo bit
    LOAD_LAST_CONTROLLER <= '0';
    -- registrador de saida
    S_LOAD_SHIFT_CONTROLLER <= '0';
    -- Interface AMBA             
    O_IN_READY_RLL_DEC_CONTROLLER   <= '0';     
    O_LAST_DATA_RLL_DEC_CONTROLLER  <= '0';    
    O_VALID_RLL_DEC_CONTROLLER      <= '0';
    -- Tratamento de erro
    ERR_LAST_CONTROLLER		<= '0';
    ERR_MCS_ID_CONTROLLER  <= '0';

    case state is
        when RESET_DEC_LAST  =>
            RST_INTERNAL_CONTROLLER <= '1';

            next_state <= WAIT_IN;

        when WAIT_IN  =>
            LOAD_MCS_ID_CONTROLLER <= '1';

            if I_VALID_RLL_DEC_CONTROLLER = '1' then
                next_state <= CHECK_MCS_ID;
            else
                next_state <= state;
            end if;

        when CHECK_MCS_ID  =>
            LOAD_COUNTER_CONTROLLER <= '1';

            if VALID_MCS_ID_CONTROLLER = '1' then
                next_state <= CHECK_VALID_LAST;
            else
                next_state <= ERR_MCS_ID;
            end if;

        when ERR_MCS_ID  =>
            ERR_MCS_ID_CONTROLLER <= '1';
            O_IN_READY_RLL_DEC_CONTROLLER <= '1';

            next_state <= WAIT_IN;

        when CHECK_VALID_LAST  =>
            
            -- se o dado for valido, confere se foi o ultimo
            if I_VALID_RLL_DEC_CONTROLLER = '0' then
                next_state <= state;
            elsif I_LAST_DATA_RLL_DEC = '0' then
                next_state <= LOAD_IN;
            else
                next_state <= LOAD_LAST;
            end if;
            
        when LOAD_IN  =>
            UP_CNT_COUNTER_CONTROLLER       <= '1';
            O_IN_READY_RLL_DEC_CONTROLLER   <= '1';
            LOAD_FIFO_CONTROLLER            <= '1';

            if ALM_FULL_COUNTER_CONTROLLER = '1' then
                next_state <= PRE_READ_FIFO;
            else
                next_state <= CHECK_VALID_LAST;
            end if;
            
        when LOAD_LAST  =>
            UP_CNT_COUNTER_CONTROLLER       <= '1';
            O_IN_READY_RLL_DEC_CONTROLLER   <= '1';
            LOAD_FIFO_CONTROLLER            <= '1';
            LOAD_LAST_CONTROLLER            <= '1';

            if ALM_FULL_COUNTER_CONTROLLER = '1' then
                next_state <= PRE_READ_FIFO;
            else
                next_state <= FILL_LAST;
            end if;

        when FILL_LAST  =>
            UP_CNT_COUNTER_CONTROLLER       <= '1';
            LOAD_FIFO_CONTROLLER            <= '1';
            ERR_LAST_CONTROLLER             <= '1';

            if ALM_FULL_COUNTER_CONTROLLER = '1' then
                next_state <= PRE_READ_FIFO;
            else
                next_state <= state;
            end if;

        when PRE_READ_FIFO =>
            READ_FIFO_CONTROLLER <= '1';

            next_state <= LOAD_SEC_IN;


        when LOAD_SEC_IN  =>
            READ_FIFO_CONTROLLER        <= '1';
            S_LOAD_SIPO_CONTROLLER      <= '1';
            DWN_CNT_COUNTER_CONTROLLER  <= '1';

            if ALM_FULL_SIPO_CONTROLLER = '1' then
                next_state <= WAIT_DEC_READY;
            else
                next_state <= state;
            end if;

        when WAIT_DEC_READY  =>
            I_VALID_INTERNAL_DECS_CONTROLLER <= '1';

            if O_IN_READY_INTERNAL_DECS_CONTROLLER = '1' then
                next_state <= WAIT_DEC_DONE;
            else
                next_state <= state;
            end if;

        when WAIT_DEC_DONE  =>
            P_READ_SIPO_CONTROLLER  <= '1';
            P_LOAD_PISO_CONTROLLER  <= '1';
            I_CONSUME_INTERNAL_DECS_CONTROLLER <= '1';

            if O_VALID_INTERNAL_DECS_CONTROLLER = '1' then
                next_state <= LOAD_OUT;
            else
                next_state <= state;
            end if;

        when LOAD_OUT  =>
            S_READ_PISO_CONTROLLER  <= '1';
            S_LOAD_SHIFT_CONTROLLER <= '1';

            -- se a piso esvaziou, confere se a fifo zerou tambem
            if ALM_EMPTY_PISO_CONTROLLER = '0' then
                next_state <= state;
            elsif ZERO_COUNTER_CONTROLLER = '0' then
                next_state <= LOAD_SEC_IN; 
            else
                next_state <= CHECK_LAST;
            end if;

        when CHECK_LAST  =>
            
            if REG_LAST_CONTROLLER = '1' then
                next_state <= WAIT_LAST_OUT; 
            else
                next_state <= WAIT_OUT;
            end if;

        when WAIT_OUT  =>
            O_VALID_RLL_DEC_CONTROLLER <= '1';

            if I_CONSUME_RLL_DEC_CONTROLLER = '1' then
                next_state <= RESET_DEC; 
            else
                next_state <= state;
            end if;

        when RESET_DEC  =>
            RST_INTERNAL_CONTROLLER <= '1';

            next_state <= SET_COUNTER;
        
        when SET_COUNTER  =>
            LOAD_COUNTER_CONTROLLER <= '1';

            next_state <= CHECK_VALID_LAST;

        when WAIT_LAST_OUT  =>
            O_VALID_RLL_DEC_CONTROLLER      <= '1';
            O_LAST_DATA_RLL_DEC_CONTROLLER  <= '1';

            if I_CONSUME_RLL_DEC_CONTROLLER = '1' then
                next_state <= RESET_DEC_LAST; 
            else
                next_state <= state;
            end if;
        
        when others =>
            next_state <= RESET_DEC_LAST;
    end case;
    
end process;

end architecture behaviour;