--------------------------------
-- "Testbench do caso normal" --
--------------------------------
-- Testbench que exercita a controladora da seguinte maneira:
-- Manda um MCS_ID valido
-- Fica um tempo no loop recebendo dados
-- Manda para o codificador, faz um loop
-- Entrega o dado na saida
-- Termina a teste

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_rll_controller_tb2 is
end entity dec_rll_controller_tb2;

architecture teste of dec_rll_controller_tb2 is
    
    component dec_rll_controller is
        port (
            -- gerais
            CLK_CONTROLLER, RST_CONTROLLER              : in std_logic;
            RST_INTERNAL_CONTROLLER                     : out std_logic;
            -- contador progressivo/regressivo
            ZERO_COUNTER_CONTROLLER                     : in std_logic;
            ALM_ZERO_COUNTER_CONTROLLER                 : in std_logic;
            ALM_FULL_COUNTER_CONTROLLER                 : in std_logic;
            LOAD_COUNTER_CONTROLLER                     : out std_logic;
            DWN_CNT_COUNTER_CONTROLLER                  : out std_logic;
            UP_CNT_COUNTER_CONTROLLER                   : out std_logic;
            -- FIFO de entrada
            LOAD_FIFO_CONTROLLER                        : out std_logic;
            READ_FIFO_CONTROLLER                        : out std_logic;
            -- registrador e decodificador de MCS ID
            VALID_MCS_ID_CONTROLLER                     : in std_logic;
            NO_CODE_MCS_ID_CONTROLLER                   : in std_logic;
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
    end component dec_rll_controller;

---------------------------------------------------------------------------------------

signal CLK_CONTROLLER                       : std_logic := '1';
signal RST_CONTROLLER                       : std_logic;
signal RST_INTERNAL_CONTROLLER              : std_logic;
-- contador progressivo/regressivo
signal ZERO_COUNTER_CONTROLLER              : std_logic;
signal ALM_ZERO_COUNTER_CONTROLLER          : std_logic;
signal ALM_FULL_COUNTER_CONTROLLER          : std_logic;
signal LOAD_COUNTER_CONTROLLER              : std_logic;
signal DWN_CNT_COUNTER_CONTROLLER           : std_logic;
signal UP_CNT_COUNTER_CONTROLLER            : std_logic;
-- FIFO de entr
signal LOAD_FIFO_CONTROLLER                 : std_logic;
signal READ_FIFO_CONTROLLER                 : std_logic;
-- registrador e decodificador de MCS_ID
signal VALID_MCS_ID_CONTROLLER              : std_logic;
signal NO_CODE_MCS_ID_CONTROLLER            : std_logic;
signal LOAD_MCS_ID_CONTROLLER               : std_logic;
-- SIPO's
signal ALM_FULL_SIPO_CONTROLLER             : std_logic;
signal S_LOAD_SIPO_CONTROLLER               : std_logic;
signal P_READ_SIPO_CONTROLLER               : std_logic;
-- Codificado
signal O_IN_READY_INTERNAL_DECS_CONTROLLER  : std_logic;
signal O_VALID_INTERNAL_DECS_CONTROLLER     : std_logic;
signal I_VALID_INTERNAL_DECS_CONTROLLER     : std_logic;
signal I_CONSUME_INTERNAL_DECS_CONTROLLER   : std_logic;
-- PISO's
signal ALM_EMPTY_PISO_CONTROLLER            : std_logic;
signal P_LOAD_PISO_CONTROLLER               : std_logic;
signal S_READ_PISO_CONTROLLER               : std_logic;
-- registrador de saida
signal S_LOAD_SHIFT_CONTROLLER              : std_logic;
-- gerenciamento de ultimo bit
signal REG_LAST_CONTROLLER                  : std_logic;
signal LOAD_LAST_CONTROLLER                 : std_logic;
-- Interface pseudo AMBA
signal I_CONSUME_RLL_DEC_CONTROLLER         : std_logic;
signal I_VALID_RLL_DEC_CONTROLLER           : std_logic;
signal I_LAST_DATA_RLL_DEC                  : std_logic;
signal O_IN_READY_RLL_DEC_CONTROLLER        : std_logic;
signal O_LAST_DATA_RLL_DEC_CONTROLLER       : std_logic;
signal O_VALID_RLL_DEC_CONTROLLER           : std_logic;
-- Tratamento de erro
signal ERR_LAST_CONTROLLER                  : std_logic;
signal ERR_MCS_ID_CONTROLLER                : std_logic;

-------------------------------------------------------------------------------------------------

begin
    
    dut: dec_rll_controller
        port map(
            -- gerais
            CLK_CONTROLLER          => CLK_CONTROLLER, 
            RST_CONTROLLER          => RST_CONTROLLER,              
            RST_INTERNAL_CONTROLLER => RST_INTERNAL_CONTROLLER,                     
            -- contador progressivo/regressivo
            ZERO_COUNTER_CONTROLLER     => ZERO_COUNTER_CONTROLLER,
            ALM_ZERO_COUNTER_CONTROLLER => ALM_ZERO_COUNTER_CONTROLLER,
            ALM_FULL_COUNTER_CONTROLLER => ALM_FULL_COUNTER_CONTROLLER,
            LOAD_COUNTER_CONTROLLER     => LOAD_COUNTER_CONTROLLER,
            DWN_CNT_COUNTER_CONTROLLER  => DWN_CNT_COUNTER_CONTROLLER,
            UP_CNT_COUNTER_CONTROLLER   => UP_CNT_COUNTER_CONTROLLER,
            -- FIFO de entrada
            LOAD_FIFO_CONTROLLER    => LOAD_FIFO_CONTROLLER,
            READ_FIFO_CONTROLLER    => READ_FIFO_CONTROLLER,
            -- registrador e decodificador de MCS ID
            VALID_MCS_ID_CONTROLLER     => VALID_MCS_ID_CONTROLLER,
            NO_CODE_MCS_ID_CONTROLLER   => NO_CODE_MCS_ID_CONTROLLER,
            LOAD_MCS_ID_CONTROLLER      => LOAD_MCS_ID_CONTROLLER,
            -- SIPO's
            ALM_FULL_SIPO_CONTROLLER    => ALM_FULL_SIPO_CONTROLLER,                    
            S_LOAD_SIPO_CONTROLLER      => S_LOAD_SIPO_CONTROLLER,                    
            P_READ_SIPO_CONTROLLER      => P_READ_SIPO_CONTROLLER,                    
            -- Codificadores
            O_IN_READY_INTERNAL_DECS_CONTROLLER => O_IN_READY_INTERNAL_DECS_CONTROLLER,
            O_VALID_INTERNAL_DECS_CONTROLLER    => O_VALID_INTERNAL_DECS_CONTROLLER,
            I_VALID_INTERNAL_DECS_CONTROLLER    => I_VALID_INTERNAL_DECS_CONTROLLER,
            I_CONSUME_INTERNAL_DECS_CONTROLLER  => I_CONSUME_INTERNAL_DECS_CONTROLLER,
            -- PISO's
            ALM_EMPTY_PISO_CONTROLLER   => ALM_EMPTY_PISO_CONTROLLER,
            P_LOAD_PISO_CONTROLLER      => P_LOAD_PISO_CONTROLLER,
            S_READ_PISO_CONTROLLER      => S_READ_PISO_CONTROLLER,
            -- registrador de saida
            S_LOAD_SHIFT_CONTROLLER => S_LOAD_SHIFT_CONTROLLER,                     
            -- gerenciamento de ultimo bit
            REG_LAST_CONTROLLER     => REG_LAST_CONTROLLER,                        
            LOAD_LAST_CONTROLLER    => LOAD_LAST_CONTROLLER,                        
            -- Interface pseudo AMBA
            I_CONSUME_RLL_DEC_CONTROLLER    => I_CONSUME_RLL_DEC_CONTROLLER,                
            I_VALID_RLL_DEC_CONTROLLER      => I_VALID_RLL_DEC_CONTROLLER,                  
            I_LAST_DATA_RLL_DEC             => I_LAST_DATA_RLL_DEC,                         
            O_IN_READY_RLL_DEC_CONTROLLER   => O_IN_READY_RLL_DEC_CONTROLLER,               
            O_LAST_DATA_RLL_DEC_CONTROLLER  => O_LAST_DATA_RLL_DEC_CONTROLLER,              
            O_VALID_RLL_DEC_CONTROLLER      => O_VALID_RLL_DEC_CONTROLLER,                  
            -- Tratamento de erro
            ERR_LAST_CONTROLLER     => ERR_LAST_CONTROLLER,                         
            ERR_MCS_ID_CONTROLLER   => ERR_MCS_ID_CONTROLLER                       
        );

--------------------------------------------------------------------------------------------------------------
   
CLK_CONTROLLER <= not CLK_CONTROLLER after 5 ns;
RST_CONTROLLER <= '1', '0' after 100 ns;

testbench: process
begin
    -- inicia o caminho de dados
    ZERO_COUNTER_CONTROLLER     <= '0'; 
    ALM_ZERO_COUNTER_CONTROLLER <= '0';
    ALM_FULL_COUNTER_CONTROLLER <= '0';
    VALID_MCS_ID_CONTROLLER     <= '0';
    NO_CODE_MCS_ID_CONTROLLER   <= '0';
    ALM_FULL_SIPO_CONTROLLER    <= '0';
    O_IN_READY_INTERNAL_DECS_CONTROLLER <= '0';
    O_VALID_INTERNAL_DECS_CONTROLLER    <= '0';
    ALM_EMPTY_PISO_CONTROLLER   <= '0';
    REG_LAST_CONTROLLER <= '0';
    I_CONSUME_RLL_DEC_CONTROLLER    <= '0';
    I_VALID_RLL_DEC_CONTROLLER      <= '0';
    I_LAST_DATA_RLL_DEC             <= '0';
    wait for 100 ns;
    -- pulsa I_VALID
    -- WAIT_IN -> CHECK_MCS_ID
    I_VALID_RLL_DEC_CONTROLLER <= '1';
    wait for 10 ns;
    I_VALID_RLL_DEC_CONTROLLER <= '0';
    -- MCS_ID e valido
    -- CHECK_MCS_ID -> CHECK_VALID_LAST
    VALID_MCS_ID_CONTROLLER <= '1';
    wait for 10 ns;
    VALID_MCS_ID_CONTROLLER <= '0';
    -- espera um pouco em CHECK_VALID_LAST
    wait for 20 ns;
    -- pulsa I_VALID
    -- CHECK_VALID_LAST -> LOAD_IN
    I_VALID_RLL_DEC_CONTROLLER  <= '1';
    wait for 10 ns;
    I_VALID_RLL_DEC_CONTROLLER  <= '0';
    -- LOAD_IN -> CHECK_VALID_LAST
    wait for 10 ns;
    -- CHECK_VALID_LAST -> LOAD_IN
    I_VALID_RLL_DEC_CONTROLLER <= '1';
    wait for 10 ns;
    I_VALID_RLL_DEC_CONTROLLER <= '0';
    -- LOAD_IN -> CHECK_NO_CODE
    ALM_FULL_COUNTER_CONTROLLER <= '1';
    wait for 10 ns;
    ALM_FULL_COUNTER_CONTROLLER <= '0';
    -- CHECK_NO_CODE -> LOAD_SEC_IN
    wait for 10 ns;
    -- aguarda um pouco em LOAD_SEC_IN
    wait for 20 ns;
    -- LOAD_SEC_IN -> WAIT_DEC_READY
    ALM_FULL_SIPO_CONTROLLER <= '1';
    wait for 10 ns;
    ALM_FULL_SIPO_CONTROLLER <= '0';
    -- aguarda um pouco em WAIT_DEC_READY
    wait for 10 ns;
    -- WAIT_DEC_READY -> WAIT_DEC_DONE
    O_IN_READY_INTERNAL_DECS_CONTROLLER <= '1';
    wait for 10 ns;
    O_IN_READY_INTERNAL_DECS_CONTROLLER <= '0';
    -- aguarda um pouco em WAIT_ENC_DONE
    wait for 20 ns;
    -- WAIT_DEC_DONE -> LOAD_OUT
    O_VALID_INTERNAL_DECS_CONTROLLER <= '1';
    wait for 10 ns;
    O_VALID_INTERNAL_DECS_CONTROLLER <= '0';
    -- aguarda um pouco em LOAD_OUT
    wait for 20 ns;
    -- mais um loop de codificacao
    -- LOAD_OUT -> LOAD_SEC_IN
    ALM_EMPTY_PISO_CONTROLLER <= '1';
    wait for 10 ns;
    ALM_EMPTY_PISO_CONTROLLER <= '0';
    -- LOAD_SEC_IN -> WAIT_DEC_READY
    ALM_FULL_SIPO_CONTROLLER <= '1';
    wait for 10 ns;
    ALM_FULL_SIPO_CONTROLLER <= '0';
    -- aguarda um pouco em WAIT_DEC_READY
    wait for 10 ns;
    -- WAIT_DEC_READY -> WAIT_DEC_DONE
    O_IN_READY_INTERNAL_DECS_CONTROLLER <= '1';
    wait for 10 ns;
    O_IN_READY_INTERNAL_DECS_CONTROLLER <= '0';
    -- aguarda um pouco em WAIT_DEC_DONE
    wait for 20 ns;
    -- WAIT_DEC_DONE -> LOAD_OUT
    O_VALID_INTERNAL_DECS_CONTROLLER <= '1';
    wait for 10 ns;
    O_VALID_INTERNAL_DECS_CONTROLLER <= '0';
    -- aguarda um pouco em LOAD_OUT
    wait for 20 ns;
    -- LOAD_OUT -> CHECK_LAST
    ALM_EMPTY_PISO_CONTROLLER   <= '1';
    ZERO_COUNTER_CONTROLLER     <= '1';
    wait for 10 ns;
    ALM_EMPTY_PISO_CONTROLLER   <= '0';
    ZERO_COUNTER_CONTROLLER     <= '0';
    -- CHECK_LAST -> WAIT_OUT
    wait for 10 ns;
    -- aguarda um pouco em WAIT_OUT
    wait for 20 ns;
    -- WAIT_OUT -> RESET_DEC
    I_CONSUME_RLL_DEC_CONTROLLER <= '1';
    wait for 10 ns;
    I_CONSUME_RLL_DEC_CONTROLLER <= '0';

end process;

end architecture teste;