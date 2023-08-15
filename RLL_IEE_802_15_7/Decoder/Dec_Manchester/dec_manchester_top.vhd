-- documentacao completa na pasta IC GabrielG 2021

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_manchester_top is
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
end entity dec_manchester_top;


architecture estrutral of dec_manchester_top is

component dec_manchester_datapath is
    port (
        -- interface externa
        I_RST_DATAPATH, I_CLK_DATAPATH      :   in std_logic;
        I_DATA_DATAPATH                     :   in std_logic_vector(1 downto 0);
        O_DATA_DATAPATH                     :   out std_logic_vector(0 downto 0);
        O_ERR_DATAPATH                      :   out std_logic;
        -- interface com a controladora
        I_REG_IN_LOAD_DATAPATH              :   in std_logic;
        I_REG_OUT_LOAD_DATAPATH             :   in std_logic
    );
end component dec_manchester_datapath;

component dec_manchester_controller is
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
end component dec_manchester_controller;

------------------------------------------------------------------------------------

-- ligaçao entre os blocos
signal reg_in_load, reg_out_load : std_logic;

-------------------------------------------------------------------------------------

begin
    
my_datapath: dec_manchester_datapath
    port map(
        -- interface externa
        I_RST_DATAPATH  =>  I_RST_MAN,
        I_CLK_DATAPATH  =>  I_CLK_MAN,   
        I_DATA_DATAPATH =>  I_DATA_MAN,                   
        O_DATA_DATAPATH =>  O_DATA_MAN,
        O_ERR_DATAPATH  =>  O_ERR_MAN,                     
        -- interface com a controladora
        I_REG_IN_LOAD_DATAPATH  =>  reg_in_load,            
        I_REG_OUT_LOAD_DATAPATH =>  reg_out_load             
    );

my_controller: dec_manchester_controller
        port map(
        -- interface externa
        I_RST_CTRL      =>  I_RST_MAN,        
        I_CLK_CTRL      =>  I_CLK_MAN,          
        I_VALID_CTRL    =>  I_VALID_MAN,                 
        I_CONSUME_CTRL  =>  I_CONSUME_MAN,                   
        O_VALID_CTRL    =>  O_VALID_MAN,                  
        O_IN_READY_CTRL =>  O_IN_READY_MAN,       
        -- interface com o datapath
        O_REG_IN_LOAD_CTRL  =>  reg_in_load,   
        O_REG_OUT_LOAD_CTRL =>  reg_out_load      
        );
    
end architecture estrutral;