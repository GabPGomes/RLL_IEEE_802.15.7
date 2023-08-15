-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_manchester_datapath is
    port (
        -- interface externa
        I_RST_DATAPATH, I_CLK_DATAPATH      :   in std_logic;
        I_DATA_DATAPATH                     :   in std_logic;
        O_DATA_DATAPATH                     :   out std_logic_vector(1 downto 0);
        -- interface com a controladora
        I_REG_IN_LOAD_DATAPATH              :   in std_logic;
        I_REG_OUT_LOAD_DATAPATH             :   in std_logic
    );
end entity enc_manchester_datapath;

architecture estrutural of enc_manchester_datapath is

signal reg_in   : std_logic;
signal reg_out, encoded_symbol  : std_logic_vector(1 downto 0);  

begin
-----------------------------------------------------------------------------------------   
-- inferindo registradores
regs: process(I_CLK_DATAPATH)
begin
    if rising_edge(I_CLK_DATAPATH) then
        if I_RST_DATAPATH = '1' then
            reg_in  <=  '0';
            reg_out <=  "00";
        else
            
            if(I_REG_IN_LOAD_DATAPATH = '1') then
                reg_in  <= I_DATA_DATAPATH;
            end if;

            if(I_REG_OUT_LOAD_DATAPATH = '1') then
                reg_out <= encoded_symbol;
            end if;

        end if;
    end if;
end process regs;

------------------------------------------------------------------------------------------
 -- logica do codificador
 
 encoded_symbol(1) <= reg_in;
 encoded_symbol(0) <= not reg_in;

 ------------------------------------------------------------------------------------------
 -- atribuindo valores as saidas
 
 O_DATA_DATAPATH <= reg_out;

end architecture estrutural;