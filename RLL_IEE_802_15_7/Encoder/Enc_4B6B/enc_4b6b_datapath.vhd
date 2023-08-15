-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_4b6b_datapath is
    port (
        -- interface externa
        I_RST_DATAPATH, I_CLK_DATAPATH      :   in std_logic;
        I_DATA_DATAPATH                     :   in std_logic_vector(3 downto 0);
        O_DATA_DATAPATH                     :   out std_logic_vector(5 downto 0);
        -- interface com a controladora
        I_REG_IN_LOAD_DATAPATH              :   in std_logic;
        I_REG_OUT_LOAD_DATAPATH             :   in std_logic 
    );
end entity enc_4b6b_datapath;

architecture estrtutural of enc_4b6b_datapath is
  
signal reg_in   : std_logic_vector(3 downto 0);
signal reg_out, encoded_symbol  : std_logic_vector(5 downto 0);     

begin

-----------------------------------------------------------------------------------------

-- inferindo registradores
regs: process(I_CLK_DATAPATH)
begin
    if rising_edge(I_CLK_DATAPATH) then
        if I_RST_DATAPATH = '1' then
            reg_in  <=  "0000";
            reg_out <=  "000000";
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
 
enc_4b6b_table: process(reg_in)
begin
    case reg_in is
        when "0000" =>  encoded_symbol <= "001110";
        when "0001" =>  encoded_symbol <= "001101";
        when "0010" =>  encoded_symbol <= "010011";
        when "0011" =>  encoded_symbol <= "010110";
        when "0100" =>  encoded_symbol <= "010101";
        when "0101" =>  encoded_symbol <= "100011";
        when "0110" =>  encoded_symbol <= "100110";
        when "0111" =>  encoded_symbol <= "100101";
        when "1000" =>  encoded_symbol <= "011001";
        when "1001" =>  encoded_symbol <= "011010";
        when "1010" =>  encoded_symbol <= "011100";
        when "1011" =>  encoded_symbol <= "110001";
        when "1100" =>  encoded_symbol <= "110010";
        when "1101" =>  encoded_symbol <= "101001";
        when "1110" =>  encoded_symbol <= "101010";
        when "1111" =>  encoded_symbol <= "101100";
        when others =>  encoded_symbol <= "000000";
	end case;
end process;

 ------------------------------------------------------------------------------------------
 
 -- atribuindo valores as saidas
 
 O_DATA_DATAPATH <= reg_out;   
    
end architecture estrtutural;