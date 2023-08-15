library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_rll_controller_tb2 is
end entity enc_rll_controller_tb2;

architecture teste of enc_rll_controller_tb2 is

    component enc_rll_controller is
        port (
            -- gerais
            CLK_CONTROLLER, RST_CONTROLLER              : in std_logic;
            RST_INTERNAL_CONTROLLER                     : out std_logic;
            -- contador regressivo
            ZERO_DOWNCNT_CONTROLLER                     : in std_logic;
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
            FULL_SIPO_CONTROLLER                        : in  std_logic;
            S_LOAD_SIPO_CONTROLLER                      : out std_logic;
            P_READ_SIPO_CONTROLLER                      : out std_logic;
            -- Codificadores
            O_IN_READY_INTERNAL_ENCS_CONTROLLER         : in std_logic;
            O_VALID_INTERNAL_ENCS_CONTROLLER            : in std_logic;
            I_VALID_INTERNAL_ENCS_CONTROLLER            : out std_logic;
            I_CONSUME_INTERNAL_ENCS_CONTROLLER          : out std_logic;
            -- PISO's
            EMPTY_PISO_CONTROLLER                       : in std_logic;
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
            O_VALID_RLL_ENC_CONTROLLER                  : out std_logic
        );
    end component enc_rll_controller;    

-----------------------------------------------------------------------------------

signal CLK_CONTROLLER                              : std_logic := '1';
signal RST_CONTROLLER                              : std_logic;
signal RST_INTERNAL_CONTROLLER                     : std_logic;
-- contador regressivo
signal ZERO_DOWNCNT_CONTROLLER                     : std_logic;
signal DECR_DOWNCNT_CONTROLLER                     : std_logic;
signal LOAD_DOWNCNT_CONTROLLER                     : std_logic;
-- registrador de entrada
signal P_LOAD_SHIFT_CONTROLLER                     : std_logic;
signal S_READ_SHIFT_CONTROLLER                     : std_logic;
-- registrador e decodificador de MCS ID
signal VALID_MCS_ID_CONTROLLER                     : std_logic;
signal NO_CODE_MCS_ID_CONTROLLER                   : std_logic;
signal LOAD_MCS_ID_CONTROLLER                      : std_logic;
-- SIPO's
signal FULL_SIPO_CONTROLLER                        : std_logic;
signal S_LOAD_SIPO_CONTROLLER                      : std_logic;
signal P_READ_SIPO_CONTROLLER                      : std_logic;
-- Codificadores
signal O_IN_READY_INTERNAL_ENCS_CONTROLLER         : std_logic;
signal O_VALID_INTERNAL_ENCS_CONTROLLER            : std_logic;
signal I_VALID_INTERNAL_ENCS_CONTROLLER            : std_logic;
signal I_CONSUME_INTERNAL_ENCS_CONTROLLER          : std_logic;
-- PISO's
signal EMPTY_PISO_CONTROLLER                       : std_logic;
signal P_LOAD_PISO_CONTROLLER                      : std_logic;
signal S_READ_PISO_CONTROLLER                      : std_logic;
-- FIFO
signal LAST_FIFO_CONTROLLER                        : std_logic;
signal LOAD_FIFO_CONTROLLER                        : std_logic;
signal READ_FIFO_CONTROLLER                        : std_logic;
-- Interface AMBA
signal I_CONSUME_RLL_ENC_CONTROLLER                : std_logic;
signal I_VALID_RLL_ENC_CONTROLLER                  : std_logic;
signal O_IN_READY_RLL_ENC_CONTROLLER               : std_logic;
signal O_LAST_DATA_RLL_ENC_CONTROLLER              : std_logic;
signal O_VALID_RLL_ENC_CONTROLLER                  : std_logic;

begin

--------------------------------------------------------------------------------------


    dut: enc_rll_controller
        port map(
            -- gerais
            CLK_CONTROLLER                              =>  CLK_CONTROLLER,
            RST_CONTROLLER                              =>  RST_CONTROLLER,              
            RST_INTERNAL_CONTROLLER                     =>  RST_INTERNAL_CONTROLLER,                     
            -- contador regressivo
            ZERO_DOWNCNT_CONTROLLER                     =>  ZERO_DOWNCNT_CONTROLLER,                     
            DECR_DOWNCNT_CONTROLLER                     =>  DECR_DOWNCNT_CONTROLLER,                     
            LOAD_DOWNCNT_CONTROLLER                     =>  LOAD_DOWNCNT_CONTROLLER,                     
            -- registrador de entrada
            P_LOAD_SHIFT_CONTROLLER                     =>  P_LOAD_SHIFT_CONTROLLER,                     
            S_READ_SHIFT_CONTROLLER                     =>  S_READ_SHIFT_CONTROLLER,                     
            -- registrador e decodificador de MCS ID
            VALID_MCS_ID_CONTROLLER                     =>  VALID_MCS_ID_CONTROLLER,                     
            NO_CODE_MCS_ID_CONTROLLER                   =>  NO_CODE_MCS_ID_CONTROLLER,                   
            LOAD_MCS_ID_CONTROLLER                      =>  LOAD_MCS_ID_CONTROLLER,                      
            -- SIPO's
            FULL_SIPO_CONTROLLER                        =>  FULL_SIPO_CONTROLLER,                        
            S_LOAD_SIPO_CONTROLLER                      =>  S_LOAD_SIPO_CONTROLLER,                      
            P_READ_SIPO_CONTROLLER                      =>  P_READ_SIPO_CONTROLLER,                      
            -- Codificadores
            O_IN_READY_INTERNAL_ENCS_CONTROLLER         =>  O_IN_READY_INTERNAL_ENCS_CONTROLLER,         
            O_VALID_INTERNAL_ENCS_CONTROLLER            =>  O_VALID_INTERNAL_ENCS_CONTROLLER,            
            I_VALID_INTERNAL_ENCS_CONTROLLER            =>  I_VALID_INTERNAL_ENCS_CONTROLLER,            
            I_CONSUME_INTERNAL_ENCS_CONTROLLER          =>  I_CONSUME_INTERNAL_ENCS_CONTROLLER,          
            -- PISO's
            EMPTY_PISO_CONTROLLER                       =>  EMPTY_PISO_CONTROLLER,                   
            P_LOAD_PISO_CONTROLLER                      =>  P_LOAD_PISO_CONTROLLER,                      
            S_READ_PISO_CONTROLLER                      =>  S_READ_PISO_CONTROLLER,                     
            -- FIFO
            LAST_FIFO_CONTROLLER                        =>  LAST_FIFO_CONTROLLER,                        
            LOAD_FIFO_CONTROLLER                        =>  LOAD_FIFO_CONTROLLER,                        
            READ_FIFO_CONTROLLER                        =>  READ_FIFO_CONTROLLER,                        
            -- Interface AMBA
            I_CONSUME_RLL_ENC_CONTROLLER                =>  I_CONSUME_RLL_ENC_CONTROLLER,                
            I_VALID_RLL_ENC_CONTROLLER                  =>  I_VALID_RLL_ENC_CONTROLLER,                  
            O_IN_READY_RLL_ENC_CONTROLLER               =>  O_IN_READY_RLL_ENC_CONTROLLER,               
            O_LAST_DATA_RLL_ENC_CONTROLLER              =>  O_LAST_DATA_RLL_ENC_CONTROLLER,              
            O_VALID_RLL_ENC_CONTROLLER                  =>  O_VALID_RLL_ENC_CONTROLLER                  
        );
    
    -----------------------------------------------------------------------------------

    CLK_CONTROLLER <= not CLK_CONTROLLER after 5 ns;
    RST_CONTROLLER <= '1', '0' after 100 ns;

    testbench : process
    begin
        -- inicia o caminho de dados
        ZERO_DOWNCNT_CONTROLLER <= '0';
        VALID_MCS_ID_CONTROLLER <= '0';
        NO_CODE_MCS_ID_CONTROLLER   <= '0';
        FULL_SIPO_CONTROLLER    <= '0';
        O_IN_READY_INTERNAL_ENCS_CONTROLLER <= '0';
        O_VALID_INTERNAL_ENCS_CONTROLLER    <= '0';
        EMPTY_PISO_CONTROLLER   <= '0';
        LAST_FIFO_CONTROLLER    <= '0';
        I_CONSUME_RLL_ENC_CONTROLLER    <= '0';
        I_VALID_RLL_ENC_CONTROLLER  <= '0';
        wait for 100 ns;
        -- coloca apenas o I_VALID porque e assim que acontecera na pratica
        I_VALID_RLL_ENC_CONTROLLER  <= '1';
        wait for 10 ns;
        -- agora I_VALID e MCS_ID
        I_VALID_RLL_ENC_CONTROLLER  <= '1';
        VALID_MCS_ID_CONTROLLER  <= '1';
        wait for 10 ns;
        I_VALID_RLL_ENC_CONTROLLER  <= '0';
        VALID_MCS_ID_CONTROLLER  <= '0';
        -- deixa carregando a SIPO imaginaria
        wait for 50 ns;
        -- encheu a SIPO
        FULL_SIPO_CONTROLLER <= '1';
        wait for 10 ns;
        FULL_SIPO_CONTROLLER <= '0';
        -- aguarda um pouco o codificador interno
        wait for 50 ns;
        -- codificador pronto
        O_IN_READY_INTERNAL_ENCS_CONTROLLER <= '1';
        wait for 10 ns;
        O_IN_READY_INTERNAL_ENCS_CONTROLLER <= '0';
        -- aguarda o codificador trabalhar
        wait for 50 ns;
        -- codificador terminou
        O_VALID_INTERNAL_ENCS_CONTROLLER <= '1';
        wait for 10 ns;
        O_VALID_INTERNAL_ENCS_CONTROLLER <= '0';
        -- deixa carregar o registrador de saida
        wait for 10 ns;
        -- carrega a fifo imaginaria
        wait for 50 ns;
        -- PISO esvaziou, mas ainda tem que puxar do registrador de entrada
        EMPTY_PISO_CONTROLLER <= '1';
        wait for 10 ns;
        EMPTY_PISO_CONTROLLER <= '0';
        -- carrega de novo a SIPO imaginaria
        wait for 40 ns;
        -- encheu a SIPO
        FULL_SIPO_CONTROLLER <= '1';
        wait for 10 ns;
        FULL_SIPO_CONTROLLER <= '0';
        -- aguarda um pouco o codificador interno
        wait for 50 ns;
        -- codificador pronto
        O_IN_READY_INTERNAL_ENCS_CONTROLLER <= '1';
        wait for 10 ns;
        O_IN_READY_INTERNAL_ENCS_CONTROLLER <= '0';
        -- aguarda o codificador trabalhar
        wait for 50 ns;
        -- codificador terminou
        O_VALID_INTERNAL_ENCS_CONTROLLER <= '1';
        wait for 10 ns;
        O_VALID_INTERNAL_ENCS_CONTROLLER <= '0';
        -- deixa carregar o registrador de saida
        wait for 10 ns;
        -- carrega a fifo imaginaria
        wait for 50 ns;
        -- PISO esvaziou e nao tem mais nada no registrador de entrada
        EMPTY_PISO_CONTROLLER <= '1';
        ZERO_DOWNCNT_CONTROLLER <= '1';
        wait for 10 ns;
        EMPTY_PISO_CONTROLLER <= '0';
        ZERO_DOWNCNT_CONTROLLER <= '0';
        -- deixa fazer a pre leitura da fifo
        wait for 10 ns;
        -- nao eh o ultimo bit
        wait for 10 ns;
        -- bloco de fora ainda nao esta pronto para ler
        wait for 50 ns;
        -- bloco de fora leu o dado
        I_CONSUME_RLL_ENC_CONTROLLER <= '1';
        wait for 10 ns;
        I_CONSUME_RLL_ENC_CONTROLLER <= '0';
        -- aguarda gerir a fifo
        wait for 10 ns;
        -- agora eh o ultimo
        LAST_FIFO_CONTROLLER <= '1';
        wait for 10 ns;
        LAST_FIFO_CONTROLLER <= '0';
        -- espera o bloco de fora
        wait for 50 ns;
        -- bloco de fora leu
        I_CONSUME_RLL_ENC_CONTROLLER <= '1';
        wait for 10 ns;
        I_CONSUME_RLL_ENC_CONTROLLER <= '0';
        -- aguarda gerir a fifo
        wait;

        
    end process testbench;

end architecture teste;