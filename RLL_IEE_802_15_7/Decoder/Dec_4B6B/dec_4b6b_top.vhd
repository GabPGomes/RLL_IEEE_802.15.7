-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_4b6b_top is
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
end entity dec_4b6b_top;

architecture estrutural of dec_4b6b_top is
    
    component dec_4b6b_datapath is
        port (
            -- interface externa
            I_RST_DATAPATH, I_CLK_DATAPATH      :   in std_logic;
            I_DATA_DATAPATH                     :   in std_logic_vector(5 downto 0);
            O_DATA_DATAPATH                     :   out std_logic_vector(3 downto 0);
            O_ERR_DATAPATH                      :   out std_logic;
            -- interface com a controladora
            I_REG_IN_LOAD_DATAPATH              :   in std_logic;
            I_REG_OUT_LOAD_DATAPATH             :   in std_logic 
        );
    end component dec_4b6b_datapath;
    
    component dec_4b6b_controller is
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
    end component dec_4b6b_controller;

------------------------------------------------------------------------------------
    
    -- ligaçao entre os blocos
    signal reg_in_load, reg_out_load : std_logic;

-------------------------------------------------------------------------------------

begin
    
    my_datapath: dec_4b6b_datapath
    port map(
        -- interface externa
        I_RST_DATAPATH  =>  I_RST_4B6B,
        I_CLK_DATAPATH  =>  I_CLK_4B6B,   
        I_DATA_DATAPATH =>  I_DATA_4B6B,                   
        O_DATA_DATAPATH =>  O_DATA_4B6B,
        O_ERR_DATAPATH  =>  O_ERR_4B6B,                     
        -- interface com a controladora
        I_REG_IN_LOAD_DATAPATH  =>  reg_in_load,            
        I_REG_OUT_LOAD_DATAPATH =>  reg_out_load             
    );

my_controller: dec_4b6b_controller
        port map(
        -- interface externa
        I_RST_CTRL      =>  I_RST_4B6B,        
        I_CLK_CTRL      =>  I_CLK_4B6B,          
        I_VALID_CTRL    =>  I_VALID_4B6B,                 
        I_CONSUME_CTRL  =>  I_CONSUME_4B6B,                   
        O_VALID_CTRL    =>  O_VALID_4B6B,                  
        O_IN_READY_CTRL =>  O_IN_READY_4B6B,       
        -- interface com o datapath
        O_REG_IN_LOAD_CTRL  =>  reg_in_load,   
        O_REG_OUT_LOAD_CTRL =>  reg_out_load      
        );    
    
end architecture estrutural;