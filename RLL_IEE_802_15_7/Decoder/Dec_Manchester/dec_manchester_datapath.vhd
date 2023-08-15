-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_manchester_datapath is
    port (
        -- interface externa
        I_RST_DATAPATH, I_CLK_DATAPATH      :   in std_logic;
        I_DATA_DATAPATH                     :   in std_logic_vector(1 downto 0);
        O_DATA_DATAPATH                     :   out std_logic_vector(0 downto 0);
        O_ERR_DATAPATH                     :   out std_logic;
        -- interface com a controladora
        I_REG_IN_LOAD_DATAPATH              :   in std_logic;
        I_REG_OUT_LOAD_DATAPATH             :   in std_logic
    );
end entity dec_manchester_datapath;

architecture estrutural of dec_manchester_datapath is

signal reg_in   : std_logic_vector(1 downto 0);
signal reg_out, decoded_symbol, reg_err, err_symbol  : std_logic;

begin
-----------------------------------------------------------------------------------------   
-- inferindo registradores
regs: process(I_CLK_DATAPATH)
begin
    if rising_edge(I_CLK_DATAPATH) then
        if I_RST_DATAPATH = '1' then
            reg_in  <=  "00";
            reg_out <=  '0';
            reg_err <=  '0';
        else
            
            if(I_REG_IN_LOAD_DATAPATH = '1') then
                reg_in  <= I_DATA_DATAPATH;
            end if;

            if(I_REG_OUT_LOAD_DATAPATH = '1') then
                reg_out <= decoded_symbol;
                reg_err <= err_symbol;
            end if;

        end if;
    end if;
end process regs;

------------------------------------------------------------------------------------------
 -- logica do codificador

 decoded_symbol <= reg_in(1);

 err_symbol <=  '1' when reg_in = "11" or reg_in = "00" else
                '0';

 ------------------------------------------------------------------------------------------
 -- atribuindo valores as saidas
 
 O_DATA_DATAPATH(0) <= reg_out;

 O_ERR_DATAPATH <= reg_err;


end architecture estrutural;