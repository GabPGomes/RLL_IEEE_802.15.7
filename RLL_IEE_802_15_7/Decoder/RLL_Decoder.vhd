library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RLL_Decoder is
    port (
        CLK_RLL_DEC, RST_RLL_DEC    : in std_logic;
        I_MCS_ID_RLL_DEC            : in std_logic_vector(5 downto 0);
        I_VALID_RLL_DEC             : in std_logic;  
        I_DATA_RLL_DEC              : in std_logic;
        I_CONSUME_RLL_DEC           : in std_logic;
        I_LAST_DATA_RLL_DEC         : in std_logic;
        O_VALID_RLL_DEC             : out std_logic;
        O_LAST_DATA_RLL_DEC         : out std_logic;
        O_DATA_RLL_DEC              : out std_logic_vector(7 downto 0);
        O_IN_READY_RLL_DEC          : out std_logic;
        O_ERR_RLL_DEC               : out std_logic
);
end entity RLL_Decoder;

architecture estructural of RLL_Decoder is

    -- tabela para traduzir melhor os modos de operação
    constant M_2_MAN    : std_logic_vector(2 downto 0) := "000";
    constant M_8_MAN    : std_logic_vector(2 downto 0) := "001";
    constant M_16_MAN   : std_logic_vector(2 downto 0) := "010";
    constant M_6_4B6B   : std_logic_vector(2 downto 0) := "011";
    constant M_12_4B6B  : std_logic_vector(2 downto 0) := "100";
    constant M_10_8B10B : std_logic_vector(2 downto 0) := "101";
    constant M_8_NOCODE : std_logic_vector(2 downto 0) := "110";
    constant M_INVALID  : std_logic_vector(2 downto 0) := "111";

--====================================================================================================
--==============
-- COMPONENTES =
--==============

component Decoder_Decod_MCS_ID is -- RLL decoder component
    port (
        MCS_ID          : in  std_logic_vector(5 downto 0);
        OP_MODE         : out std_logic_vector(2 downto 0);
        VALID_MCS_ID    : out std_logic;
        NO_CODE_MCS_ID  : out std_logic 
    );
end component Decoder_Decod_MCS_ID;

component Decoder_FIFO is
	port (
		CLK_FIFO, RST_FIFO	: in std_logic;
		INPUT_FIFO			: in std_logic;
		LOAD_FIFO			: in std_logic;
		READ_FIFO			: in std_logic;
		LAST_BIT_FIFO		: out std_logic;
		OUTPUT_FIFO			: out std_logic
	);
end component Decoder_FIFO;

component FIFO_cnt_calc is
    port (
        OP_MODE_CALC       : in std_logic_vector(2 downto 0);
        COUNTER_IN_CALC  : out std_logic_vector(4 downto 0)
    );
end component FIFO_cnt_calc;

component UpDownCounter is
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
end component UpDownCounter;

component SIPO is
    generic(OUTPUT_WIDTH   	: natural 	:= 8;
			DIRECTION 		: string	:= "RIGHT"
	);
    port (
            CLK_SIPO, RST_SIPO 	: in std_logic;
            S_IN_SIPO   		:   in std_logic;
            S_LOAD_SIPO 		:   in std_logic;
            P_READ_SIPO 		:   in std_logic;
            P_OUT_SIPO  		:   out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
			ALM_FULL_SIPO   	:   out std_logic;
            FULL_SIPO   		:   out std_logic
    );
end component SIPO;

component dec_manchester_top is
    port (
        I_RST_MAN, I_CLK_MAN    : in std_logic;
        I_DATA_MAN              : in std_logic_vector(1 downto 0);
        I_VALID_MAN             : in std_logic;
        I_CONSUME_MAN           : in std_logic;
        O_DATA_MAN              : out std_logic_vector(0 downto 0);
        O_VALID_MAN             : out std_logic;
        O_IN_READY_MAN          : out std_logic;
        O_ERR_MAN               : out std_logic
        -- nao usados
        -- I_LAST_DATA_MAN
        -- O_LAST_DATA_MAN
    );
end component dec_manchester_top;

component dec_4b6b_top is
    port (
        I_RST_4B6B, I_CLK_4B6B  : in std_logic;
        I_DATA_4B6B             : in std_logic_vector(5 downto 0);
        I_VALID_4B6B            : in std_logic;
        I_CONSUME_4B6B          : in std_logic;
        O_DATA_4B6B             : out std_logic_vector(3 downto 0);
        O_VALID_4B6B            : out std_logic;
        O_IN_READY_4B6B         : out std_logic;
        O_ERR_4B6B              : out std_logic
        -- nao usados
        -- I_LAST_DATA_4B6B
        -- O_LAST_DATA_4B6B 
    );
end component dec_4b6b_top;

component dec_8b10b_top is
    port (
        I_RST_8B10B, I_CLK_8B10B    :   in std_logic;
        I_DATA_8B10B                :   in std_logic_vector(9 downto 0);
        I_CONSUME_8B10B             :   in std_logic;
        I_VALID_8B10B               :   in std_logic;
        O_DATA_8B10B                :   out std_logic_vector(7 downto 0);
        O_IN_READY_8B10B            :   out std_logic;
        O_VALID_8B10B               :   out std_logic;
        O_ERR_8B10B                 :   out std_logic
        -- nao usados
        -- I_LAST_DATA_8B10B
        -- O_LAST_DATA_8B10B           
    );
end component dec_8b10b_top;

component dec_nocode is
    port (
        I_DATA_NOCODE              : in std_logic_vector(7 downto 0);
        O_DATA_NOCODE              : out std_logic_vector(7 downto 0);
        O_VALID_NOCODE             : out std_logic;
        O_IN_READY_NOCODE          : out std_logic
    );  
end component dec_nocode;

component PISO is
    generic(INPUT_WIDTH : natural 	:= 8;
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

component Decoder_SR8 is
    port (
        CLK_SR8, RST_SR8  : in std_logic;
        S_IN_SR8   : in std_logic;
        S_LOAD_SR8 : in std_logic;
        P_OUT_SR8  : out std_logic_vector(7 downto 0)
    );
end component Decoder_SR8;

component dec_rll_controller is
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
end component dec_rll_controller;

--====================================================================================================
--=========
-- SINAIS =
--=========

-- Sinais com o sufixo _NC (Not Connected) nao sao conectados a lugar nenhum no caminho de dados.
-- Isso e necessario para uso do ModelSim.

-- gerais
signal rst_internal : std_logic;

-- last data
signal r_last_data      : std_logic;
signal load_last_data   : std_logic;

-- mcs_id
signal load_mcs_id      : std_logic;
signal r_mcs_id         : std_logic_vector(5 downto 0);
signal op_mode          : std_logic_vector(2 downto 0);
signal valid_mcs_id     : std_logic;
signal no_code_mcs_id_NC: std_logic;

-- contador de bits na entrada
signal counter_in       : std_logic_vector(4 downto 0);
signal load_counter     : std_logic;
signal dwn_cnt_counter  : std_logic;
signal up_cnt_counter   : std_logic;
signal zero_counter     : std_logic;
signal alm_full_counter : std_logic;
signal alm_zero_counter_NC : std_logic;

-- fifo de entrada
signal load_fifo    : std_logic;
signal read_fifo    : std_logic;
signal output_fifo  : std_logic;    
signal last_fifo_NC	: std_logic;

-- SIPOs
signal s_load_sipo_man      : std_logic;
signal p_read_sipo_man      : std_logic;
signal alm_full_sipo_man    : std_logic;
signal full_sipo_man_NC     : std_logic;
--
signal s_load_sipo_4b6b     : std_logic;
signal p_read_sipo_4b6b     : std_logic;
signal alm_full_sipo_4b6b   : std_logic;
signal full_sipo_4b6b_NC    : std_logic;
--
signal s_load_sipo_8b10b    : std_logic;      
signal p_read_sipo_8b10b    : std_logic;
signal alm_full_sipo_8b10b  : std_logic;
signal full_sipo_8b10b_NC   : std_logic;
--
signal s_load_sipo_nocode   : std_logic;
signal p_read_sipo_nocode   : std_logic;
signal alm_full_sipo_nocode : std_logic;
signal full_sipo_nocode_NC  : std_logic;

-- PISOs
signal s_read_piso_man          : std_logic;
signal p_load_piso_man          : std_logic;
signal s_out_piso_man           : std_logic;
signal alm_empty_piso_man       : std_logic;
signal empty_piso_man_NC        : std_logic;
--
signal s_read_piso_4b6b         : std_logic;
signal p_load_piso_4b6b         : std_logic;
signal s_out_piso_4b6b          : std_logic;
signal alm_empty_piso_4b6b      : std_logic;
signal empty_piso_4b6b_NC       : std_logic;
--
signal s_read_piso_8b10b        : std_logic;
signal p_load_piso_8b10b        : std_logic;
signal s_out_piso_8b10b         : std_logic;
signal alm_empty_piso_8b10b     : std_logic;
signal empty_piso_8b10b_NC      : std_logic;

signal p_load_piso_nocode       : std_logic; 
signal s_read_piso_nocode       : std_logic; 
signal alm_empty_piso_nocode    : std_logic;
signal s_out_piso_nocode        : std_logic; 
signal empty_piso_nocode_NC     : std_logic;

-- Decodificadores --
-- entradas
signal i_data_8b10b     : std_logic_vector(9 downto 0);
signal i_valid_8b10b    : std_logic;  
signal i_consume_8b10b  : std_logic;
-- 
signal i_data_4b6b      : std_logic_vector(5 downto 0); 
signal i_valid_4b6b     : std_logic;
signal i_consume_4b6b   : std_logic;
--
signal i_data_man       : std_logic_vector(1 downto 0);
signal i_valid_man      : std_logic;
signal i_consume_man    : std_logic; 
--
signal i_data_nocode    : std_logic_vector(7 downto 0);
-- saidas
signal o_data_man       : std_logic_vector(0 downto 0);
signal o_valid_man      : std_logic;
signal o_in_ready_man   : std_logic;
signal o_err_man        : std_logic;
--
signal o_data_4b6b      : std_logic_vector(3 downto 0);     
signal o_valid_4b6b     : std_logic; 
signal o_in_ready_4b6b  : std_logic;
signal o_err_4b6b       : std_logic;
--
signal o_data_8b10b     : std_logic_vector(7 downto 0);        
signal o_valid_8b10b    : std_logic;
signal o_in_ready_8b10b : std_logic;    
signal o_err_8b10b      : std_logic;
--
signal o_data_nocode    : std_logic_vector(7 downto 0);
signal o_in_ready_nocode: std_logic;
signal o_valid_nocode   : std_logic;

-- Reg de deslocamento de saida
signal s_load_sr8 : std_logic;

-- Controladora
signal err_last_controller  : std_logic;
signal err_mcs_id_controller: std_logic;

-- Sinais multiplexados (big_mux) que sao aglutinados e vao para a controladora --
-- Decodificadores
signal o_in_ready_internal_decs_controller  : std_logic;
signal o_valid_internal_decs_controller     : std_logic;
-- SIPOs
signal alm_full_sipo_controller : std_logic;
-- PISOs
signal alm_empty_piso_controller    : std_logic;
-- registrador de deslocamento de saida
signal s_in_sr8 : std_logic;

-- Sinais demultiplexados (big demux) que espalham os sinais da controladora --
-- Decodificadores
signal i_valid_internal_decs_controller     : std_logic;
signal i_consume_internal_decs_controller   : std_logic;
-- SIPOs
signal s_load_sipo_controller   : std_logic;
signal p_read_sipo_controller   : std_logic;
-- PISOs
signal p_load_piso_controller : std_logic;
signal s_read_piso_controller : std_logic;

--====================================================================================================

begin
    
--==============================
-- INSTANCIACAO DE COMPONENTES =
--==============================    

-- DECOD MCS_ID
only_decod_mcs_id : Decoder_Decod_MCS_ID
    port map (
        MCS_ID          =>  r_mcs_id,
        OP_MODE         =>  op_mode,
        VALID_MCS_ID    =>  valid_mcs_id,
        NO_CODE_MCS_ID  =>  no_code_mcs_id_NC
    );

-- FIFO
only_fifo: Decoder_FIFO
	port map(
		CLK_FIFO        =>  CLK_RLL_DEC,
        RST_FIFO        =>  rst_internal,
		INPUT_FIFO	    =>	I_DATA_RLL_DEC,
		LOAD_FIFO	    =>	load_fifo,
		READ_FIFO	    =>	read_fifo,
		LAST_BIT_FIFO   =>	last_fifo_NC,
		OUTPUT_FIFO	    =>	output_fifo
	);

only_fifo_cnt_calc: FIFO_cnt_calc
    port map(
        OP_MODE_CALC    => op_mode,
        COUNTER_IN_CALC => counter_in
    );

only_counter: UpDownCounter
    port map(
        CLK_COUNTER         => CLK_RLL_DEC,
        RST_COUNTER         => rst_internal,
        LOAD_COUNTER        => load_counter,
        DWN_CNT_COUNTER     => dwn_cnt_counter,
        UP_CNT_COUNTER      => up_cnt_counter,
        PARALLEL_IN_COUNTER => counter_in,
        ZERO_COUNTER        => zero_counter,
        ALM_ZERO_COUNTER    => alm_zero_counter_NC,
        ALM_FULL_COUNTER    => alm_full_counter
    );

-- SIPO MAN
sipo_man: SIPO
    generic map (   OUTPUT_WIDTH   => 2,
                    DIRECTION => "RIGHT")
    port map(
            CLK_SIPO    =>  CLK_RLL_DEC,
            RST_SIPO    =>  rst_internal,
            S_IN_SIPO   =>  output_fifo,
            S_LOAD_SIPO =>  s_load_sipo_man,
            P_READ_SIPO =>  p_read_sipo_man,
            FULL_SIPO   =>  full_sipo_man_NC,
            ALM_FULL_SIPO   	=> alm_full_sipo_man,
            P_OUT_SIPO  =>  i_data_man
    );

-- SIPO 4B6B
sipo_4b6b: SIPO
    generic map (   OUTPUT_WIDTH   => 6,
                    DIRECTION => "RIGHT")
    port map(
            CLK_SIPO    =>  CLK_RLL_DEC,
            RST_SIPO    =>  rst_internal,
            S_IN_SIPO   =>  output_fifo, 
            S_LOAD_SIPO =>  s_load_sipo_4b6b,
            P_READ_SIPO =>  p_read_sipo_4b6b,
            FULL_SIPO   =>  full_sipo_4b6b_NC,
            ALM_FULL_SIPO   	=> alm_full_sipo_4b6b,
            P_OUT_SIPO  =>  i_data_4b6b  
    );

-- SIPO 8B10B
sipo_8b10b: SIPO
    generic map (   OUTPUT_WIDTH   => 10,
                    DIRECTION => "RIGHT")
    port map(
            CLK_SIPO    =>  CLK_RLL_DEC,
            RST_SIPO    =>  rst_internal,
            S_IN_SIPO   =>  output_fifo,
            S_LOAD_SIPO =>  s_load_sipo_8b10b,
            P_READ_SIPO =>  p_read_sipo_8b10b,
            FULL_SIPO   =>  full_sipo_8b10b_NC,
            ALM_FULL_SIPO   	=> alm_full_sipo_8b10b,
            P_OUT_SIPO  =>  i_data_8b10b
    );

-- SIPO NOCODE
sipo_nocode: SIPO
    generic map (   OUTPUT_WIDTH   => 8,
                    DIRECTION => "RIGHT")
    port map(
            CLK_SIPO    =>  CLK_RLL_DEC,
            RST_SIPO    =>  rst_internal,
            S_IN_SIPO   =>  output_fifo,
            S_LOAD_SIPO =>  s_load_sipo_nocode,
            P_READ_SIPO =>  p_read_sipo_nocode,
            FULL_SIPO   =>  full_sipo_nocode_NC,
            ALM_FULL_SIPO   	=> alm_full_sipo_nocode,
            P_OUT_SIPO  =>  i_data_nocode
    );

-- DECOD MANCHESTER
only_man: dec_manchester_top
    port map(
        I_RST_MAN       =>  rst_internal,
        I_CLK_MAN       =>  CLK_RLL_DEC,        
        I_DATA_MAN      =>  i_data_man,                
        I_VALID_MAN     =>  i_valid_man,               
        I_CONSUME_MAN   =>  i_consume_man,             
        O_DATA_MAN      =>  o_data_man,              
        O_VALID_MAN     =>  o_valid_man,             
        O_IN_READY_MAN  =>  o_in_ready_man,
        O_ERR_MAN       =>  o_err_man          
    );

-- DECOD 4B6B
only_4b6b: dec_4b6b_top
    port map(
        I_RST_4B6B      =>  rst_internal,
        I_CLK_4B6B      =>  CLK_RLL_DEC,
        I_DATA_4B6B     =>  i_data_4b6b,     
        I_VALID_4B6B    =>  i_valid_4b6b,    
        I_CONSUME_4B6B  =>  i_consume_4b6b,  
        O_DATA_4B6B     =>  o_data_4b6b,     
        O_VALID_4B6B    =>  o_valid_4b6b,    
        O_IN_READY_4B6B =>  o_in_ready_4b6b,
        O_ERR_4B6B      =>  o_err_4b6b 
    );

-- DECOD 8B10B
only_8b10b: dec_8b10b_top
    port map(
        I_RST_8B10B         =>  rst_internal,
        I_CLK_8B10B         =>  CLK_RLL_DEC,
        I_DATA_8B10B        =>  i_data_8b10b,   
        I_CONSUME_8B10B     =>  i_consume_8b10b,
        I_VALID_8B10B       =>  i_valid_8b10b,  
        O_DATA_8B10B        =>  o_data_8b10b,        
        O_IN_READY_8B10B    =>  o_in_ready_8b10b,    
        O_VALID_8B10B       =>  o_valid_8b10b,
        O_ERR_8B10B         =>  o_err_8b10b                  
    );

-- DECOD NOCODE
only_nocode: dec_nocode
    port map(
        I_DATA_NOCODE       =>  i_data_nocode,
        O_DATA_NOCODE       =>  o_data_nocode,
        O_VALID_NOCODE      =>  o_valid_nocode,
        O_IN_READY_NOCODE   =>  o_in_ready_nocode
    ); 

-- PISO MAN
piso_man : PISO
    generic map(INPUT_WIDTH => 1,
                DIRECTION => "LEFT")
    port map(
        CLK_PISO            =>  CLK_RLL_DEC, 
        RST_PISO            =>  rst_internal,
        P_IN_PISO           =>  o_data_man, 
        P_LOAD_PISO         =>  p_load_piso_man, 
        S_READ_PISO         =>  s_read_piso_man, 
        EMPTY_PISO          =>  empty_piso_man_NC,
        ALM_EMPTY_PISO   	 => alm_empty_piso_man,
        S_OUT_PISO          =>  s_out_piso_man 
    );

-- PISO 4B6B
piso_4b6b : PISO
    generic map(INPUT_WIDTH => 4,
                DIRECTION => "LEFT")
    port map(
        CLK_PISO    =>  CLK_RLL_DEC, 
        RST_PISO    =>  rst_internal, 
        P_IN_PISO   =>  o_data_4b6b, 
        P_LOAD_PISO =>  p_load_piso_4b6b, 
        S_READ_PISO =>  s_read_piso_4b6b, 
        EMPTY_PISO  =>  empty_piso_4b6b_NC,
        ALM_EMPTY_PISO   => alm_empty_piso_4b6b,
        S_OUT_PISO  =>  s_out_piso_4b6b   
    );

-- PISO 8B10B
piso_8b10b : PISO
    generic map(INPUT_WIDTH => 8,
                DIRECTION => "LEFT")
    port map(
        CLK_PISO    =>  CLK_RLL_DEC, 
        RST_PISO    =>  rst_internal, 
        P_IN_PISO   =>  o_data_8b10b, 
        P_LOAD_PISO =>  p_load_piso_8b10b, 
        S_READ_PISO =>  s_read_piso_8b10b, 
        EMPTY_PISO  =>  empty_piso_8b10b_NC,
        ALM_EMPTY_PISO   => alm_empty_piso_8b10b,
        S_OUT_PISO  =>  s_out_piso_8b10b 
    );

-- PISO NOCODE
piso_nocode : PISO
    generic map(INPUT_WIDTH => 8,
                DIRECTION => "LEFT")
    port map(
        CLK_PISO    =>  CLK_RLL_DEC, 
        RST_PISO    =>  rst_internal, 
        P_IN_PISO   =>  o_data_nocode, 
        P_LOAD_PISO =>  p_load_piso_nocode, 
        S_READ_PISO =>  s_read_piso_nocode, 
        EMPTY_PISO  =>  empty_piso_nocode_NC,
        ALM_EMPTY_PISO   => alm_empty_piso_nocode,
        S_OUT_PISO  =>  s_out_piso_nocode
    );
    
only_sr8: Decoder_SR8
    port map (
        CLK_SR8     => CLK_RLL_DEC,
        RST_SR8     => rst_internal,
        S_IN_SR8    => s_in_sr8,  
        S_LOAD_SR8  => s_load_sr8,
        P_OUT_SR8   => O_DATA_RLL_DEC
    );

only_controller: dec_rll_controller
    port map(
        -- gerais
        CLK_CONTROLLER          => CLK_RLL_DEC,
        RST_CONTROLLER          => RST_RLL_DEC,            
        RST_INTERNAL_CONTROLLER => rst_internal,                   
        -- contador progressivo/regressivo
        ZERO_COUNTER_CONTROLLER     => zero_counter,                                   
        ALM_FULL_COUNTER_CONTROLLER => alm_full_counter,
        LOAD_COUNTER_CONTROLLER     => load_counter,                   
        DWN_CNT_COUNTER_CONTROLLER  => dwn_cnt_counter,          
        UP_CNT_COUNTER_CONTROLLER   => up_cnt_counter,                 
        -- FIFO de entrada
        LOAD_FIFO_CONTROLLER        => load_fifo,                     
        READ_FIFO_CONTROLLER        => read_fifo,                    
        -- registrador e decodificador de MCS ID
        VALID_MCS_ID_CONTROLLER     => valid_mcs_id,                                    
        LOAD_MCS_ID_CONTROLLER      => load_mcs_id,                    
        -- SIPO's
        ALM_FULL_SIPO_CONTROLLER    => alm_full_sipo_controller,                  
        S_LOAD_SIPO_CONTROLLER      => s_load_sipo_controller,                    
        P_READ_SIPO_CONTROLLER      => p_read_sipo_controller,                    
        -- Codificadores
        -- colocar os sinais de erro aqui dentro se possivel
        O_IN_READY_INTERNAL_DECS_CONTROLLER => o_in_ready_internal_decs_controller,      
        O_VALID_INTERNAL_DECS_CONTROLLER    => o_valid_internal_decs_controller,
        I_VALID_INTERNAL_DECS_CONTROLLER    => i_valid_internal_decs_controller,          
        I_CONSUME_INTERNAL_DECS_CONTROLLER  => i_consume_internal_decs_controller,        
        -- PISO's
        ALM_EMPTY_PISO_CONTROLLER   => alm_empty_piso_controller,                
        P_LOAD_PISO_CONTROLLER      => p_load_piso_controller,                    
        S_READ_PISO_CONTROLLER      => s_read_piso_controller,                    
        -- registrador de saida
        S_LOAD_SHIFT_CONTROLLER     => s_load_sr8,                   
        -- gerenciamento de ultimo bit
        REG_LAST_CONTROLLER     => r_last_data,                      
        LOAD_LAST_CONTROLLER    => load_last_data,                      
        -- Interface pseudo AMBA
        I_CONSUME_RLL_DEC_CONTROLLER    => I_CONSUME_RLL_DEC,             
        I_VALID_RLL_DEC_CONTROLLER      => I_VALID_RLL_DEC,               
        I_LAST_DATA_RLL_DEC             => I_LAST_DATA_RLL_DEC,                       
        O_IN_READY_RLL_DEC_CONTROLLER   => O_IN_READY_RLL_DEC,             
        O_LAST_DATA_RLL_DEC_CONTROLLER  => O_LAST_DATA_RLL_DEC,            
        O_VALID_RLL_DEC_CONTROLLER      => O_VALID_RLL_DEC,                
        -- Tratamento de erro
        ERR_LAST_CONTROLLER     => err_last_controller,                        
        ERR_MCS_ID_CONTROLLER   => err_mcs_id_controller
    );

--====================================================================================================    
--=================
-- LOGICA EXTERNA =
--=================

-- mux dos sinais
big_mux : process(op_mode,
    o_in_ready_man, o_valid_man, alm_full_sipo_man, alm_empty_piso_man, s_out_piso_man,
    o_in_ready_4b6b, o_valid_4b6b, alm_full_sipo_4b6b, alm_empty_piso_4b6b, s_out_piso_4b6b,
    o_in_ready_8b10b, o_valid_8b10b, alm_full_sipo_8b10b, alm_empty_piso_8b10b, s_out_piso_8b10b,
    o_in_ready_nocode, o_valid_nocode, alm_full_sipo_nocode, alm_empty_piso_nocode, s_out_piso_nocode,
    output_fifo)
begin
    case op_mode is
        when M_2_MAN     =>
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= o_in_ready_man;
        o_valid_internal_decs_controller    <= o_valid_man;
        -- dos SIPOs
        alm_full_sipo_controller     <= alm_full_sipo_man;
        -- dos PISOs
        alm_empty_piso_controller    <= alm_empty_piso_man;
        -- da FIFO
        s_in_sr8    <= s_out_piso_man;  

        when M_8_MAN     => 
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= o_in_ready_man;
        o_valid_internal_decs_controller    <= o_valid_man;
        -- dos SIPOs
        alm_full_sipo_controller     <= alm_full_sipo_man;
        -- dos PISOs
        alm_empty_piso_controller    <= alm_empty_piso_man;
        -- da FIFO
        s_in_sr8    <= s_out_piso_man;  

        when M_16_MAN     => 
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= o_in_ready_man;
        o_valid_internal_decs_controller    <= o_valid_man;
        -- dos SIPOs
        alm_full_sipo_controller     <= alm_full_sipo_man;
        -- dos PISOs
        alm_empty_piso_controller    <= alm_empty_piso_man;
        -- da FIFO
        s_in_sr8    <= s_out_piso_man;   

        when M_6_4B6B    => 
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= o_in_ready_4b6b;
        o_valid_internal_decs_controller    <= o_valid_4b6b;
        -- dos SIPOs
        alm_full_sipo_controller     <= alm_full_sipo_4b6b;
        -- dos PISOs
        alm_empty_piso_controller    <= alm_empty_piso_4b6b;
        -- da FIFO
        s_in_sr8    <= s_out_piso_4b6b;  

        when M_12_4B6B    => 
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= o_in_ready_4b6b;
        o_valid_internal_decs_controller    <= o_valid_4b6b;
        -- dos SIPOs
        alm_full_sipo_controller     <= alm_full_sipo_4b6b;
        -- dos PISOs
        alm_empty_piso_controller    <= alm_empty_piso_4b6b;
        -- da FIFO
        s_in_sr8    <= s_out_piso_4b6b;  

        when M_10_8B10B   =>
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= o_in_ready_8b10b;
        o_valid_internal_decs_controller    <= o_valid_8b10b;
        -- dos SIPOs
        alm_full_sipo_controller     <= alm_full_sipo_8b10b;
        -- dos PISOs
        alm_empty_piso_controller    <= alm_empty_piso_8b10b;
        -- da FIFO
        s_in_sr8    <= s_out_piso_8b10b; 

        when M_8_NOCODE  =>
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= o_in_ready_nocode;
        o_valid_internal_decs_controller    <= o_valid_nocode;
        -- dos SIPOs
        alm_full_sipo_controller <= alm_full_sipo_nocode;
        -- dos PISOs
        alm_empty_piso_controller<= alm_empty_piso_nocode;
        -- da FIFO
        s_in_sr8    <= s_out_piso_nocode;

        when M_INVALID  =>
        -- dos Decodificadores
        o_in_ready_internal_decs_controller <= '0';
        o_valid_internal_decs_controller    <= '0';
        -- dos SIPOs
        alm_full_sipo_controller <= '0';
        -- dos PISOs
        alm_empty_piso_controller<= '0';
        -- da FIFO
        s_in_sr8    <= '0'; 

        when others     =>
        -- dos decdificadores
        o_in_ready_internal_decs_controller <= '0';
        o_valid_internal_decs_controller    <= '0';
        -- dos SIPOs
        alm_full_sipo_controller <= '0';
        -- dos PISOs
        alm_empty_piso_controller<= '0';
        -- da FIFO
        s_in_sr8    <= '0';  

    end case;
end process big_mux;

-- demux para que os blocos Decodificadores e os SIPOs/PISOs sejam acionados apenas no momento correto
big_demux: process( op_mode,
                    i_valid_internal_decs_controller, i_consume_internal_decs_controller,
                    s_load_sipo_controller, p_read_sipo_controller,
                    s_read_piso_controller, p_load_piso_controller
                )
begin
    case op_mode is
    when M_2_MAN     =>
        -- decodificadores
        i_valid_man     <=  i_valid_internal_decs_controller;
        i_consume_man   <=  i_consume_internal_decs_controller;
        --
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= s_load_sipo_controller;
        p_read_sipo_man <= p_read_sipo_controller;
        --
        s_load_sipo_4b6b <= '0';
        p_read_sipo_4b6b <= '0';
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= s_read_piso_controller;
        p_load_piso_man <= p_load_piso_controller;
        --
        s_read_piso_4b6b <= '0';
        p_load_piso_4b6b <= '0';
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0';

    when M_8_MAN     =>
        -- decodificadores
        i_valid_man     <=  i_valid_internal_decs_controller;
        i_consume_man   <=  i_consume_internal_decs_controller;
        --
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= s_load_sipo_controller;
        p_read_sipo_man <= p_read_sipo_controller;
        --
        s_load_sipo_4b6b <= '0';
        p_read_sipo_4b6b <= '0';
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= s_read_piso_controller;
        p_load_piso_man <= p_load_piso_controller;
        --
        s_read_piso_4b6b <= '0';
        p_load_piso_4b6b <= '0';
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0'; 

    when M_16_MAN     =>
        -- decodificadores
        i_valid_man     <=  i_valid_internal_decs_controller;
        i_consume_man   <=  i_consume_internal_decs_controller;
        --
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= s_load_sipo_controller;
        p_read_sipo_man <= p_read_sipo_controller;
        --
        s_load_sipo_4b6b <= '0';
        p_read_sipo_4b6b <= '0';
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= s_read_piso_controller;
        p_load_piso_man <= p_load_piso_controller;
        --
        s_read_piso_4b6b <= '0';
        p_load_piso_4b6b <= '0';
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0';

    when M_6_4B6B    =>
        -- decodifcadores
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        --
        i_valid_4b6b    <=  i_valid_internal_decs_controller;
        i_consume_4b6b  <=  i_consume_internal_decs_controller;
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= '0';
        p_read_sipo_man <= '0';
        --
        s_load_sipo_4b6b <= s_load_sipo_controller;
        p_read_sipo_4b6b <= p_read_sipo_controller;
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= '0';
        p_load_piso_man <= '0';
        --
        s_read_piso_4b6b <= s_read_piso_controller;
        p_load_piso_4b6b <= p_load_piso_controller;
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0';

    when M_12_4B6B    =>
        -- decodifcadores
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        --
        i_valid_4b6b    <=  i_valid_internal_decs_controller;
        i_consume_4b6b  <=  i_consume_internal_decs_controller;
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= '0';
        p_read_sipo_man <= '0';
        --
        s_load_sipo_4b6b <= s_load_sipo_controller;
        p_read_sipo_4b6b <= p_read_sipo_controller;
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= '0';
        p_load_piso_man <= '0';
        --
        s_read_piso_4b6b <= s_read_piso_controller;
        p_load_piso_4b6b <= p_load_piso_controller;
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0';

    when M_10_8B10B   =>
        -- decodifcadores
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        --
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        --
        i_valid_8b10b   <=  i_valid_internal_decs_controller;
        i_consume_8b10b <=  i_consume_internal_decs_controller;
        -- SIPOs
        s_load_sipo_man <= '0';
        p_read_sipo_man <= '0';
        --
        s_load_sipo_4b6b <= '0';
        p_read_sipo_4b6b <= '0';
        --
        s_load_sipo_8b10b <= s_load_sipo_controller;
        p_read_sipo_8b10b <= p_read_sipo_controller;
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= '0';
        p_load_piso_man <= '0';
        --
        s_read_piso_4b6b <= '0';
        p_load_piso_4b6b <= '0';
        --
        s_read_piso_8b10b <= s_read_piso_controller;
        p_load_piso_8b10b <= p_load_piso_controller;
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0';

    when M_8_NOCODE  =>
        -- decodifcadores
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        --
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= '0';
        p_read_sipo_man <= '0';
        --
        s_load_sipo_4b6b <= '0';
        p_read_sipo_4b6b <= '0';
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= s_load_sipo_controller;
        p_read_sipo_nocode <= p_read_sipo_controller;
        -- PISOs
        s_read_piso_man <= '0';
        p_load_piso_man <= '0';
        --
        s_read_piso_4b6b <= '0';
        p_load_piso_4b6b <= '0';
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= p_load_piso_controller;
        s_read_piso_nocode <= s_read_piso_controller;

    when M_INVALID  =>
        -- decodifcadores
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        --
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= '0';
        p_read_sipo_man <= '0';
        --
        s_load_sipo_4b6b <= '0';
        p_read_sipo_4b6b <= '0';
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= '0';
        p_load_piso_man <= '0';
        --
        s_read_piso_4b6b <= '0';
        p_load_piso_4b6b <= '0';
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0';

    when others =>
        -- decodifcadores
        i_valid_man     <=  '0';
        i_consume_man   <=  '0';
        --
        i_valid_4b6b    <=  '0';
        i_consume_4b6b  <=  '0';
        --
        i_valid_8b10b   <=  '0';
        i_consume_8b10b <=  '0';
        -- SIPOs
        s_load_sipo_man <= '0';
        p_read_sipo_man <= '0';
        --
        s_load_sipo_4b6b <= '0';
        p_read_sipo_4b6b <= '0';
        --
        s_load_sipo_8b10b <= '0';
        p_read_sipo_8b10b <= '0';
        --
        s_load_sipo_nocode <= '0';
        p_read_sipo_nocode <= '0';
        -- PISOs
        s_read_piso_man <= '0';
        p_load_piso_man <= '0';
        --
        s_read_piso_4b6b <= '0';
        p_load_piso_4b6b <= '0';
        --
        s_read_piso_8b10b <= '0';
        p_load_piso_8b10b <= '0';
        --
        p_load_piso_nocode <= '0';
        s_read_piso_nocode <= '0';

    end case;
end process;

-- registrador de mcs id e de last_data
reg_mcs_id: process(CLK_RLL_DEC)
begin
    if rising_edge(CLK_RLL_DEC) then
        if(RST_RLL_DEC = '1') then -- note que nao e o reset interno
            r_mcs_id    <= (others => '0');
        else
            if(load_mcs_id = '1') then
                r_mcs_id <= I_MCS_ID_RLL_DEC;
            end if;
        end if;
    end if;
end process reg_mcs_id;

reg_last_data: process(CLK_RLL_DEC)
begin
    if rising_edge(CLK_RLL_DEC) then
        if(rst_internal = '1') then
            r_last_data <= '0';
        else
            if(load_last_data = '1') then
                r_last_data <= I_LAST_DATA_RLL_DEC;
            end if;
        end if;
    end if;
end process reg_last_data;

-- unindo os sinais de erro
O_ERR_RLL_DEC <=    (err_last_controller or err_mcs_id_controller) or -- erros vindos da controladora
                    (o_err_man or o_err_4b6b or o_err_8b10b); -- erros vindo diretamente do caminho de dados

end architecture estructural;