-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_8b10b_top is
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
end entity enc_8b10b_top;

architecture estrutural of enc_8b10b_top is

    component enc_8b10b_datapath is
        port (
            -- sinais da interface
            I_RST_DATAPATH, I_CLK_DATAPATH  :   in std_logic;
            I_DATA_DATAPATH                 :   in std_logic_vector(7 downto 0);
            O_DATA_DATAPATH                 :   out std_logic_vector(9 downto 0);
            -- comunicaçao com a controladora
            I_ENC_RESET_DATAPATH            :   in std_logic; 
            I_CLK_GATE_ON_DATAPATH          :   in std_logic;
            I_REG_IN_LOAD_DATAPATH          :   in std_logic;
            I_REG_OUT_LOAD_DATAPATH         :   in std_logic
        );
    end component enc_8b10b_datapath;
    
    component enc_8b10b_controller is
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
    end component enc_8b10b_controller;

------------------------------------------------------------------------------------
    
    -- ligaçao entre os blocos
    signal reg_in_load, reg_out_load : std_logic;
    signal clk_gate_on, enc_reset : std_logic;

------------------------------------------------------------------------------------- 
    
begin

    my_datapath: enc_8b10b_datapath
        port map (
            -- sinais da interface
            I_RST_DATAPATH  =>  I_RST_8B10B, 
            I_CLK_DATAPATH  =>  I_CLK_8B10B, 
            I_DATA_DATAPATH =>  I_DATA_8B10B,                 
            O_DATA_DATAPATH =>  O_DATA_8B10B,                 
            -- comunicaçao com a controladora
            I_ENC_RESET_DATAPATH    =>  enc_reset, 
            I_CLK_GATE_ON_DATAPATH  =>  clk_gate_on,           
            I_REG_IN_LOAD_DATAPATH  =>  reg_in_load,         
            I_REG_OUT_LOAD_DATAPATH =>  reg_out_load         
        );    

    my_controller: enc_8b10b_controller
        port map (
            -- sinais da interface
            I_RST_CTRL      =>  I_RST_8B10B,
            I_CLK_CTRL      =>  I_CLK_8B10B,
            I_VALID_CTRL    =>  I_VALID_8B10B,            
            I_CONSUME_CTRL  =>  I_CONSUME_8B10B,          
            O_VALID_CTRL    =>  O_VALID_8B10B,            
            O_IN_READY_CTRL =>  O_IN_READY_8B10B,         
            -- comunicaçao com o caminho de dados
            O_ENC_RESET_CTRL    =>  enc_reset,
            O_CLK_GATE_ON_CTRL  =>  clk_gate_on,     
            O_REG_IN_LOAD_CTRL  =>  reg_in_load,     
            O_REG_OUT_LOAD_CTRL =>  reg_out_load     
        );    
    
end architecture estrutural;