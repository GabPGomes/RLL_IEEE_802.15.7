library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RLL_ENCODER is
    port (
            CLK_RLL_ENC, RST_RLL_ENC    : in std_logic;
            I_MCS_ID_RLL_ENC            : in std_logic_vector(5 downto 0);
            I_VALID_RLL_ENC             : in std_logic;  
            I_DATA_RLL_ENC              : in std_logic_vector(7 downto 0);
            I_CONSUME_RLL_ENC           : in std_logic;
            I_LAST_DATA_RLL_ENC         : in std_logic;
            O_VALID_RLL_ENC             : out std_logic;
            O_LAST_DATA_RLL_ENC         : out std_logic;
            O_DATA_RLL_ENC              : out std_logic;
            O_IN_READY_RLL_ENC          : out std_logic;
            O_ERR_RLL_ENC               : out std_logic
    );
end entity RLL_ENCODER;

architecture estrutural of RLL_ENCODER is

-- tabela para traduzir melhor os modos de operação
constant M_3MAN     : std_logic_vector(2 downto 0) := "000";
constant M_4MAN     : std_logic_vector(2 downto 0) := "001";
constant M_8MAN     : std_logic_vector(2 downto 0) := "010";
constant M_44B6B    : std_logic_vector(2 downto 0) := "011";
constant M_84B6B    : std_logic_vector(2 downto 0) := "100";
constant M_88B10B   : std_logic_vector(2 downto 0) := "101";
constant M_8NOCODE  : std_logic_vector(2 downto 0) := "110";
constant M_INVALID  : std_logic_vector(2 downto 0) := "111";

--====================================================================================================
--==============
-- COMPONENTES =
--==============

-- DECOD MCS_ID
    component Encoder_DECOD_MCS_ID is
        port (
            MCS_ID          : in  std_logic_vector(5 downto 0);
            OP_MODE         : out std_logic_vector(2 downto 0);
            VALID_MCS_ID    : out std_logic;
            NO_CODE_MCS_ID  : out std_logic 
        );
    end component Encoder_DECOD_MCS_ID;

-- CNTDOWN_IN_CALCULATOR
component Countdown_in_calc is
    port (
        OP_MODE_CNT       : in std_logic_vector(2 downto 0);
        COUNTDOWN_IN_CNT  : out std_logic_vector(3 downto 0)
    );
end component Countdown_in_calc;

-- DOWN COUNTER
component DOWNCOUNTER is
    port (
        CLK_DOWNCOUNTER, RST_DOWNCOUNTER    : in std_logic;
        LOAD_DOWNCOUNTER                    : in std_logic;   
        CNT_DOWNCOUNTER                     : in std_logic;
        PARALLEL_IN_DOWNCOUNTER             : in std_logic_vector(3 downto 0);
        ZERO_DOWNCOUNTER                    : out std_logic;
        ONE_DOWNCOUNTER                     : out std_logic
    );
end component DOWNCOUNTER;

-- SHIFT REGISTER 8 BITS
component Encoder_SR8 is
    port (
        CLK_SR8, RST_SR8  : in std_logic;
        P_IN_SR8   : in std_logic_vector(7 downto 0);
        P_LOAD_SR8 : in std_logic;
        S_READ_SR8 : in std_logic;
        S_OUT_SR8  : out std_logic
    );
end component Encoder_SR8;

-- SIPO
component SIPO is
    generic(OUTPUT_WIDTH    : natural   := 8;
            DIRECTION 		: string	:= "RIGHT"
    );
    port (
            CLK_SIPO, RST_SIPO : in std_logic;
            S_IN_SIPO   :   in std_logic;
            S_LOAD_SIPO :   in std_logic;
            P_READ_SIPO :   in std_logic;
            FULL_SIPO   :   out std_logic;
            ALM_FULL_SIPO   :   out std_logic;
            P_OUT_SIPO  :   out std_logic_vector(OUTPUT_WIDTH-1 downto 0)       
    );
end component SIPO;

-- COD MANCHESTER
component enc_manchester_top is
    port (
        I_RST_MAN, I_CLK_MAN    : in std_logic;
        I_DATA_MAN              : in std_logic;
        I_VALID_MAN             : in std_logic;
        I_CONSUME_MAN           : in std_logic;
        O_DATA_MAN              : out std_logic_vector(1 downto 0);
        O_VALID_MAN             : out std_logic;
        O_IN_READY_MAN          : out std_logic
        -- nao usados
        -- I_LAST_DATA_MAN
        -- O_LAST_DATA_MAN
    );
end component enc_manchester_top;

-- COD 4B6B
component enc_4b6b_top is
    port (
        I_RST_4B6B, I_CLK_4B6B  : in std_logic;
        I_DATA_4B6B             : in std_logic_vector(3 downto 0);
        I_VALID_4B6B            : in std_logic;
        I_CONSUME_4B6B          : in std_logic;
        O_DATA_4B6B             : out std_logic_vector(5 downto 0);
        O_VALID_4B6B            : out std_logic;
        O_IN_READY_4B6B         : out std_logic
        -- nao usados
        -- I_LAST_DATA_4B6B
        -- O_LAST_DATA_4B6B 
    );
end component enc_4b6b_top;

-- COD 8B10B
component enc_8b10b_top is
    port (
        I_RST_8B10B, I_CLK_8B10B    :   in std_logic;
        I_DATA_8B10B                :   in std_logic_vector(7 downto 0);
        I_CONSUME_8B10B             :   in std_logic;
        I_VALID_8B10B               :   in std_logic;
        O_DATA_8B10B                :   out std_logic_vector(9 downto 0);
        O_IN_READY_8B10B            :   out std_logic;
        O_VALID_8B10B               :   out std_logic
        -- nao usados
        -- I_LAST_DATA_8B10B
        -- O_LAST_DATA_8B10B           
    );
end component enc_8b10b_top;

-- PISO
component PISO is
    generic(INPUT_WIDTH : natural := 8;
            DIRECTION   : string 	:= "LEFT"
        );
    port (
        CLK_PISO, RST_PISO  : in std_logic;
        P_IN_PISO   : in std_logic_vector(INPUT_WIDTH-1 downto 0);
        P_LOAD_PISO : in std_logic;
        S_READ_PISO : in std_logic;
        EMPTY_PISO  : out std_logic;
        ALM_EMPTY_PISO  : out std_logic;
        S_OUT_PISO  : out std_logic
    );
end component PISO;

-- FIFO
component Encoder_FIFO is
	port (
		CLK_FIFO, RST_FIFO	: in std_logic;
		INPUT_FIFO			: in std_logic;
		LOAD_FIFO			: in std_logic;
		READ_FIFO			: in std_logic;
		LAST_BIT_FIFO		: out std_logic;
		OUTPUT_FIFO			: out std_logic
	);
end component Encoder_FIFO;

-- CONTROLLER
component enc_rll_controller is
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
end component enc_rll_controller;

--====================================================================================================
--=========
-- SINAIS =
--=========

-- gerais
signal rst_internal : std_logic;

-- mcs_id
signal r_mcs_id         : std_logic_vector(5 downto 0);
signal op_mode          : std_logic_vector(2 downto 0);
signal valid_mcs_id     : std_logic;
signal no_code_mcs_id   : std_logic;
signal load_mcs_id      : std_logic;

-- contador de bits na entrada
signal parallel_in_downcounter  : std_logic_vector(3 downto 0);
signal load_downcounter         : std_logic;
signal cnt_downcounter          : std_logic;
signal zero_downcounter         : std_logic;
signal one_downcounter          : std_logic;


-- registrador de deslocamento de entrada
signal p_load_shift : std_logic;
signal s_read_shift : std_logic;
signal s_out_shift  : std_logic;

-- SIPOs
signal full_sipo_man_NC         : std_logic;
signal almost_full_sipo_man    : std_logic;
--
signal full_sipo_4b6b_NC        : std_logic;
signal almost_full_sipo_4b6b   : std_logic;
--
signal full_sipo_8b10b_NC       : std_logic;
signal almost_full_sipo_8b10b  : std_logic;

-- PISOs
signal empty_piso_man_NC        : std_logic;
signal almost_empty_piso_man    : std_logic;
signal s_out_piso_man           : std_logic;
--
signal empty_piso_4b6b_NC       : std_logic;
signal almost_empty_piso_4b6b   : std_logic;
signal s_out_piso_4b6b          : std_logic;
--
signal empty_piso_8b10b_NC      : std_logic;
signal almost_empty_piso_8b10b  : std_logic;
signal s_out_piso_8b10b         : std_logic;

-- saidas dos codificadores
signal o_data_8b10b     : std_logic_vector(9 downto 0);        
signal o_in_ready_8b10b : std_logic;    
signal o_valid_8b10b    : std_logic;

signal o_data_4b6b      : std_logic_vector(5 downto 0);     
signal o_valid_4b6b     : std_logic; 
signal o_in_ready_4b6b  : std_logic;
 
signal o_data_man       : std_logic_vector(1 downto 0);
signal o_valid_man      : std_logic;
signal o_in_ready_man   : std_logic;

-- entradas dos codificadores
signal i_data_8b10b     : std_logic_vector(7 downto 0);
signal i_valid_8b10b    : std_logic;  
signal i_consume_8b10b  : std_logic; 
signal i_data_4b6b      : std_logic_vector(3 downto 0); 
signal i_valid_4b6b     : std_logic;
signal i_consume_4b6b   : std_logic;
signal i_data_man       : std_logic;
signal i_valid_man      : std_logic;
signal i_consume_man    : std_logic;

-- fifo
signal input_fifo : std_logic;
signal load_fifo  : std_logic;
signal read_fifo  : std_logic;
signal last_fifo	: std_logic;

-- sinalizacao de ultimo dado
signal load_last    : std_logic;
signal r_last     : std_logic;

-- Saidas da Controladora que devem ser espalhadas
-- dos codificadores
signal i_valid_internal_encs_controller     : std_logic; 
signal i_consume_internal_encs_controller   : std_logic;
-- dos SIPOs
signal s_load_sipo_controller   : std_logic;
signal p_read_sipo_controller   : std_logic;
-- dos PISOs
signal p_load_piso_controller   : std_logic;
signal s_read_piso_controller   : std_logic;

-- entradas da controladora que recebe sinais de mux
-- dos codificadores
signal o_in_ready_internal_encs_controller  : std_logic;
signal o_valid_internal_encs_controller     : std_logic;
-- dos SIPOs
signal almost_full_sipo_controller          : std_logic;
-- dos PISOs
signal almost_empty_piso_controller         : std_logic;

--====================================================================================================

begin

--==============================
-- INSTANCIACAO DE COMPONENTES =
--==============================

-- DECOD MCS_ID
only_decod_mcs_id : Encoder_DECOD_MCS_ID
    port map (
        MCS_ID          =>  r_mcs_id,
        OP_MODE         =>  op_mode,
        VALID_MCS_ID    =>  valid_mcs_id,
        NO_CODE_MCS_ID  =>  no_code_mcs_id
    );

-- CNTDOWN_IN_CALCULATOR
only_Countdown_in_calc : Countdown_in_calc
    port map(
        OP_MODE_CNT       => op_mode,
        COUNTDOWN_IN_CNT  => parallel_in_downcounter
    );

-- DOWN COUNTER
only_dwncounter : DOWNCOUNTER
    port map(
        CLK_DOWNCOUNTER                     =>  CLK_RLL_ENC, 
        RST_DOWNCOUNTER                     =>  rst_internal,
        LOAD_DOWNCOUNTER                    =>  load_downcounter,
        CNT_DOWNCOUNTER                     =>  cnt_downcounter,
        PARALLEL_IN_DOWNCOUNTER             =>  parallel_in_downcounter,
        ZERO_DOWNCOUNTER                    =>  zero_downcounter,
        ONE_DOWNCOUNTER                     =>  one_downcounter
    );

-- SHIFT REGISTER 8 BITS
only_SR8 : Encoder_SR8
    port map (
        CLK_SR8     =>  CLK_RLL_ENC,
        RST_SR8     =>  rst_internal,
        P_IN_SR8    =>  I_DATA_RLL_ENC,   
        P_LOAD_SR8  =>  p_load_shift,
        S_READ_SR8  =>  s_read_shift,
        S_OUT_SR8   =>  s_out_shift
    );

-- SIPO MAN
sipo_man: SIPO
    generic map (OUTPUT_WIDTH   => 1)
    port map(
            CLK_SIPO    =>  CLK_RLL_ENC,
            RST_SIPO    =>  rst_internal,
            S_IN_SIPO   =>  s_out_shift,
            S_LOAD_SIPO =>  s_load_sipo_controller,
            P_READ_SIPO =>  p_read_sipo_controller,
            FULL_SIPO   =>  full_sipo_man_NC,
            ALM_FULL_SIPO   	=> almost_full_sipo_man,
            P_OUT_SIPO(0)  =>  i_data_man
    );

-- SIPO 4B6B
sipo_4b6b: SIPO
    generic map (OUTPUT_WIDTH   => 4)
    port map(
            CLK_SIPO    =>  CLK_RLL_ENC,
            RST_SIPO    =>  rst_internal,
            S_IN_SIPO   =>  s_out_shift, 
            S_LOAD_SIPO =>  s_load_sipo_controller,
            P_READ_SIPO =>  p_read_sipo_controller,
            FULL_SIPO   =>  full_sipo_4b6b_NC,
            ALM_FULL_SIPO   	=> almost_full_sipo_4b6b,
            P_OUT_SIPO  =>  i_data_4b6b  
    );

-- SIPO 8B10B
sipo_8b10b: SIPO
    generic map (OUTPUT_WIDTH   => 8)
    port map(
            CLK_SIPO    =>  CLK_RLL_ENC,
            RST_SIPO    =>  rst_internal,
            S_IN_SIPO   =>  s_out_shift,
            S_LOAD_SIPO =>  s_load_sipo_controller,
            P_READ_SIPO =>  p_read_sipo_controller,
            FULL_SIPO   =>  full_sipo_8b10b_NC,
            ALM_FULL_SIPO   	=> almost_full_sipo_8b10b,
            P_OUT_SIPO  =>  i_data_8b10b
    );

-- COD MANCHESTER
only_man: enc_manchester_top
    port map(
        I_RST_MAN       =>  rst_internal,
        I_CLK_MAN       =>  CLK_RLL_ENC,        
        I_DATA_MAN      =>  i_data_man,                
        I_VALID_MAN     =>  i_valid_man,               
        I_CONSUME_MAN   =>  i_consume_man,             
        O_DATA_MAN      =>  o_data_man,              
        O_VALID_MAN     =>  o_valid_man,             
        O_IN_READY_MAN  =>  o_in_ready_man          
    );

-- COD 4B6B
only_4b6b: enc_4b6b_top
    port map(
        I_RST_4B6B      =>  rst_internal,
        I_CLK_4B6B      =>  CLK_RLL_ENC,
        I_DATA_4B6B     =>  i_data_4b6b,     
        I_VALID_4B6B    =>  i_valid_4b6b,    
        I_CONSUME_4B6B  =>  i_consume_4b6b,  
        O_DATA_4B6B     =>  o_data_4b6b,     
        O_VALID_4B6B    =>  o_valid_4b6b,    
        O_IN_READY_4B6B =>  o_in_ready_4b6b 
    );

-- COD 8B10B
only_8b10b: enc_8b10b_top
    port map(
        I_RST_8B10B         =>  RST_RLL_ENC, -- ele nao pode ser resetado pela fsm pq precisa manter o running disparity
        I_CLK_8B10B         =>  CLK_RLL_ENC,
        I_DATA_8B10B        =>  i_data_8b10b,   
        I_CONSUME_8B10B     =>  i_consume_8b10b,
        I_VALID_8B10B       =>  i_valid_8b10b,  
        O_DATA_8B10B        =>  o_data_8b10b,        
        O_IN_READY_8B10B    =>  o_in_ready_8b10b,    
        O_VALID_8B10B       =>  o_valid_8b10b                  
    );

-- PISO MAN
piso_man : PISO
    generic map(INPUT_WIDTH => 2,
                DIRECTION => "RIGHT"
            )
    port map(
        CLK_PISO    =>  CLK_RLL_ENC, 
        RST_PISO    =>  rst_internal,
        P_IN_PISO   =>  o_data_man, 
        P_LOAD_PISO =>  p_load_piso_controller, 
        S_READ_PISO =>  s_read_piso_controller, 
        EMPTY_PISO  =>  empty_piso_man_NC,
        ALM_EMPTY_PISO   => almost_empty_piso_man,
        S_OUT_PISO  =>  s_out_piso_man 
    );

-- PISO 4B6B
piso_4b6b : PISO
    generic map(INPUT_WIDTH => 6,
                DIRECTION => "RIGHT"
            )
    port map(
        CLK_PISO    =>  CLK_RLL_ENC, 
        RST_PISO    =>  rst_internal, 
        P_IN_PISO   =>  o_data_4b6b, 
        P_LOAD_PISO =>  p_load_piso_controller, 
        S_READ_PISO =>  s_read_piso_controller, 
        EMPTY_PISO  =>  empty_piso_4b6b_NC,
        ALM_EMPTY_PISO   => almost_empty_piso_4b6b,
        S_OUT_PISO  =>  s_out_piso_4b6b   
    );

-- PISO 8B10B
piso_8b10b : PISO
    generic map(INPUT_WIDTH => 10,
                DIRECTION => "RIGHT"
            )
    port map(
        CLK_PISO    =>  CLK_RLL_ENC, 
        RST_PISO    =>  rst_internal, 
        P_IN_PISO   =>  o_data_8b10b, 
        P_LOAD_PISO =>  p_load_piso_controller, 
        S_READ_PISO =>  s_read_piso_controller, 
        EMPTY_PISO  =>  empty_piso_8b10b_NC,
        ALM_EMPTY_PISO   => almost_empty_piso_8b10b,
        S_OUT_PISO  =>  s_out_piso_8b10b 
    );

-- FIFO
only_fifo: Encoder_FIFO
	port map(
		CLK_FIFO        =>  CLK_RLL_ENC,
        RST_FIFO        =>  rst_internal,
		INPUT_FIFO	    =>	input_fifo,
		LOAD_FIFO	    =>	load_fifo,
		READ_FIFO	    =>	read_fifo,
		LAST_BIT_FIFO   =>	last_fifo,
		OUTPUT_FIFO	    =>	O_DATA_RLL_ENC
	);

-- CONTROLLER
only_controller: enc_rll_controller
    port map(
        -- gerais
        CLK_CONTROLLER                      =>  CLK_RLL_ENC,
        RST_CONTROLLER                      =>  RST_RLL_ENC,
        RST_INTERNAL_CONTROLLER             =>  rst_internal,
        -- contador regressivo
        ZERO_DOWNCNT_CONTROLLER             => zero_downcounter,
        ONE_DOWNCNT_CONTROLLER              => one_downcounter,
        DECR_DOWNCNT_CONTROLLER             => cnt_downcounter,
        LOAD_DOWNCNT_CONTROLLER             => load_downcounter,
        -- registrador de entrada
        P_LOAD_SHIFT_CONTROLLER             =>  p_load_shift,
        S_READ_SHIFT_CONTROLLER             =>  s_read_shift,
        -- registrador e decodificador de MCS ID
        VALID_MCS_ID_CONTROLLER             => valid_mcs_id,
        NO_CODE_MCS_ID_CONTROLLER           => no_code_mcs_id,
        LOAD_MCS_ID_CONTROLLER              => load_mcs_id,
        -- SIPO's
        ALM_FULL_SIPO_CONTROLLER            =>  almost_full_sipo_controller,
        S_LOAD_SIPO_CONTROLLER              =>  s_load_sipo_controller,
        P_READ_SIPO_CONTROLLER              =>  p_read_sipo_controller,
        -- Codificadores
        O_IN_READY_INTERNAL_ENCS_CONTROLLER =>  o_in_ready_internal_encs_controller,
        O_VALID_INTERNAL_ENCS_CONTROLLER    =>  o_valid_internal_encs_controller,   
        I_VALID_INTERNAL_ENCS_CONTROLLER    =>  i_valid_internal_encs_controller,  
        I_CONSUME_INTERNAL_ENCS_CONTROLLER  =>  i_consume_internal_encs_controller,
        -- PISO's
        ALM_EMPTY_PISO_CONTROLLER           =>  almost_empty_piso_controller,               
        P_LOAD_PISO_CONTROLLER              =>  p_load_piso_controller,              
        S_READ_PISO_CONTROLLER              =>  s_read_piso_controller,              
        -- FIFO
        LAST_FIFO_CONTROLLER                =>  last_fifo,
        LOAD_FIFO_CONTROLLER                =>  load_fifo,
        READ_FIFO_CONTROLLER                =>  read_fifo,
        -- Interface AMBA
        I_CONSUME_RLL_ENC_CONTROLLER        =>  I_CONSUME_RLL_ENC,     
        I_VALID_RLL_ENC_CONTROLLER          =>  I_VALID_RLL_ENC,      
        O_IN_READY_RLL_ENC_CONTROLLER       =>  O_IN_READY_RLL_ENC,      
        O_LAST_DATA_RLL_ENC_CONTROLLER      =>  O_LAST_DATA_RLL_ENC,
        O_VALID_RLL_ENC_CONTROLLER          =>  O_VALID_RLL_ENC,
        -- Ultimo dado do pacote
        LOAD_LAST                           => load_last, 
        REG_LAST                            => r_last,
        -- Sinalizacao de erro                  
        O_ERR_MCS_ID                        => O_ERR_RLL_ENC      
    );

--====================================================================================================    
--=================
-- LOGICA EXTERNA =
--=================

-- mux dos sinais
big_mux : process(op_mode,
                    o_in_ready_man, o_valid_man, almost_full_sipo_man, almost_empty_piso_man, s_out_piso_man,
                    o_in_ready_4b6b, o_valid_4b6b, almost_full_sipo_4b6b, almost_empty_piso_4b6b, s_out_piso_4b6b,
                    o_in_ready_8b10b, o_valid_8b10b, almost_full_sipo_8b10b, almost_empty_piso_8b10b, s_out_piso_8b10b,
                    s_out_shift)
begin
case op_mode is
    when M_3MAN     =>
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= o_in_ready_man;
        o_valid_internal_encs_controller    <= o_valid_man;
        -- dos SIPOs
        almost_full_sipo_controller     <= almost_full_sipo_man;
        -- dos PISOs
        almost_empty_piso_controller    <= almost_empty_piso_man;
        -- da FIFO
        input_fifo              <= s_out_piso_man;  

    when M_4MAN     => 
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= o_in_ready_man;
        o_valid_internal_encs_controller    <= o_valid_man;
        -- dos SIPOs
        almost_full_sipo_controller     <= almost_full_sipo_man;
        -- dos PISOs
        almost_empty_piso_controller    <= almost_empty_piso_man;
        -- da FIFO
        input_fifo              <= s_out_piso_man;  

    when M_8MAN     => 
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= o_in_ready_man;
        o_valid_internal_encs_controller    <= o_valid_man;
        -- dos SIPOs
        almost_full_sipo_controller     <= almost_full_sipo_man;
        -- dos PISOs
        almost_empty_piso_controller    <= almost_empty_piso_man;
        -- da FIFO
        input_fifo              <= s_out_piso_man;   

    when M_44B6B    => 
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= o_in_ready_4b6b;
        o_valid_internal_encs_controller    <= o_valid_4b6b;
        -- dos SIPOs
        almost_full_sipo_controller     <= almost_full_sipo_4b6b;
        -- dos PISOs
        almost_empty_piso_controller    <= almost_empty_piso_4b6b;
        -- da FIFO
        input_fifo              <= s_out_piso_4b6b;  

    when M_84B6B    => 
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= o_in_ready_4b6b;
        o_valid_internal_encs_controller    <= o_valid_4b6b;
        -- dos SIPOs
        almost_full_sipo_controller     <= almost_full_sipo_4b6b;
        -- dos PISOs
        almost_empty_piso_controller    <= almost_empty_piso_4b6b;
        -- da FIFO
        input_fifo              <= s_out_piso_4b6b;  

    when M_88B10B   =>
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= o_in_ready_8b10b;
        o_valid_internal_encs_controller    <= o_valid_8b10b;
        -- dos SIPOs
        almost_full_sipo_controller     <= almost_full_sipo_8b10b;
        -- dos PISOs
        almost_empty_piso_controller    <= almost_empty_piso_8b10b;
        -- da FIFO
        input_fifo              <= s_out_piso_8b10b; 

    when M_8NOCODE  =>
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= '0';
        o_valid_internal_encs_controller    <= '0';
        -- dos SIPOs
        almost_full_sipo_controller <= '0';
        -- dos PISOs
        almost_empty_piso_controller<= '0';
        -- da FIFO
        input_fifo              <= s_out_shift;  

    when M_INVALID  =>
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= '0';
        o_valid_internal_encs_controller    <= '0';
        -- dos SIPOs
        almost_full_sipo_controller <= '0';
        -- dos PISOs
        almost_empty_piso_controller<= '0';
        -- da FIFO
        input_fifo              <= '0'; 

    when others     =>
        -- dos Codificadores
        o_in_ready_internal_encs_controller <= '0';
        o_valid_internal_encs_controller    <= '0';
        -- dos SIPOs
        almost_full_sipo_controller <= '0';
        -- dos PISOs
        almost_empty_piso_controller<= '0';
        -- da FIFO
        input_fifo                          <= '0';  

end case;
end process big_mux;




-- demux para que os blocos codificadores sejam acionados apenas no momento correto
big_demux: process(op_mode, i_valid_internal_encs_controller, i_consume_internal_encs_controller)
begin
    case op_mode is
    when M_3MAN     =>
        i_valid_man     <=  i_valid_internal_encs_controller;
        i_consume_man   <=  i_consume_internal_encs_controller;
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';

    when M_4MAN     =>
        i_valid_man     <=  i_valid_internal_encs_controller;
        i_consume_man   <=  i_consume_internal_encs_controller;
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0'; 

    when M_8MAN     =>
        i_valid_man     <=  i_valid_internal_encs_controller;
        i_consume_man   <=  i_consume_internal_encs_controller;
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';

    when M_44B6B    =>
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        i_valid_4b6b    <=  i_valid_internal_encs_controller;
        i_consume_4b6b  <=  i_consume_internal_encs_controller;
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';

    when M_84B6B    =>
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        i_valid_4b6b    <=  i_valid_internal_encs_controller;
        i_consume_4b6b  <=  i_consume_internal_encs_controller;
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';

    when M_88B10B   =>
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        i_valid_8b10b   <=  i_valid_internal_encs_controller;
        i_consume_8b10b <=  i_consume_internal_encs_controller;

    when M_8NOCODE  =>
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';

    when M_INVALID  =>
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';

    when others =>
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';

    end case;

end process;




-- registrador de mcs id
reg_mcs_id: process(CLK_RLL_ENC)
begin
    if rising_edge(CLK_RLL_ENC) then
        if RST_RLL_ENC = '1' then
            r_mcs_id <= (others => '0');
        else
            if(load_mcs_id = '1') then
                r_mcs_id <= I_MCS_ID_RLL_ENC;
            end if;
    end if;
    end if;
end process reg_mcs_id; 

reg_last: process(CLK_RLL_ENC)
begin
    if rising_edge(CLK_RLL_ENC) then
        if RST_RLL_ENC = '1' then
            r_last <= '0';
        else
            if(load_last = '1') then
                r_last <= I_LAST_DATA_RLL_ENC;
            end if;
        end if;
    end if;
end process reg_last; 

end architecture estrutural;