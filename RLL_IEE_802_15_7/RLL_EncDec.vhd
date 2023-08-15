library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RLL_EncDec is
    port (
        -- interface com o sistema
        CLK, RST                    : in std_logic;
        -- interface com a controladora
        I_MCS_ID                    : in std_logic_vector(5 downto 0);
        -- interfaces do codificador
        -- entrada
        I_VALID_RLL_ENC             : in std_logic;  
        I_DATA_RLL_ENC              : in std_logic_vector(7 downto 0);
        I_CONSUME_RLL_ENC           : in std_logic;
        I_LAST_DATA_RLL_ENC         : in std_logic;
        -- saida
        O_VALID_RLL_ENC             : out std_logic;
        O_LAST_DATA_RLL_ENC         : out std_logic;
        O_DATA_RLL_ENC              : out std_logic;
        O_IN_READY_RLL_ENC          : out std_logic;
        -- interfaces do decodificador
        -- entrada
        I_MCS_ID_RLL_DEC            : in std_logic_vector(5 downto 0);
        I_VALID_RLL_DEC             : in std_logic;  
        I_DATA_RLL_DEC              : in std_logic;
        I_CONSUME_RLL_DEC           : in std_logic;
        I_LAST_DATA_RLL_DEC         : in std_logic;
        -- saida
        O_VALID_RLL_DEC             : out std_logic;
        O_LAST_DATA_RLL_DEC         : out std_logic;
        O_DATA_RLL_DEC              : out std_logic_vector(7 downto 0);
        O_IN_READY_RLL_DEC          : out std_logic
    );
end entity RLL_EncDec;

architecture estrutural of RLL_EncDec is
    
    component RLL_ENCODER is
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
    end component RLL_ENCODER;

    component RLL_Decoder is
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
    end component RLL_Decoder;

--------------------------------------------------------------------------------------------------------

signal o_err_rll_enc_NC : std_logic;
signal o_err_rll_dec_NC : std_logic;

--------------------------------------------------------------------------------------------------------

begin
    
    only_enc: RLL_ENCODER
        port map(
                CLK_RLL_ENC         =>  CLK,
                RST_RLL_ENC         =>  RST,
                I_MCS_ID_RLL_ENC    =>  I_MCS_ID,
                I_VALID_RLL_ENC     =>  I_VALID_RLL_ENC,     
                I_DATA_RLL_ENC      =>  I_DATA_RLL_ENC,      
                I_CONSUME_RLL_ENC   =>  I_CONSUME_RLL_ENC,   
                I_LAST_DATA_RLL_ENC =>  I_LAST_DATA_RLL_ENC, 
                O_VALID_RLL_ENC     =>  O_VALID_RLL_ENC,     
                O_LAST_DATA_RLL_ENC =>  O_LAST_DATA_RLL_ENC, 
                O_DATA_RLL_ENC      =>  O_DATA_RLL_ENC,      
                O_IN_READY_RLL_ENC  =>  O_IN_READY_RLL_ENC,  
                O_ERR_RLL_ENC       =>  o_err_rll_enc_NC       
        );

    only_dec: RLL_Decoder
        port map(
            CLK_RLL_DEC         =>  CLK,  
            RST_RLL_DEC         =>  RST,  
            I_MCS_ID_RLL_DEC    =>  I_MCS_ID_RLL_DEC,  
            I_VALID_RLL_DEC     =>  I_VALID_RLL_DEC,  
            I_DATA_RLL_DEC      =>  I_DATA_RLL_DEC,  
            I_CONSUME_RLL_DEC   =>  I_CONSUME_RLL_DEC,  
            I_LAST_DATA_RLL_DEC =>  I_LAST_DATA_RLL_DEC,  
            O_VALID_RLL_DEC     =>  O_VALID_RLL_DEC,  
            O_LAST_DATA_RLL_DEC =>  O_LAST_DATA_RLL_DEC,  
            O_DATA_RLL_DEC      =>  O_DATA_RLL_DEC,  
            O_IN_READY_RLL_DEC  =>  O_IN_READY_RLL_DEC,  
            O_ERR_RLL_DEC       =>  o_err_rll_dec_NC  
    );   
    
end architecture estrutural;