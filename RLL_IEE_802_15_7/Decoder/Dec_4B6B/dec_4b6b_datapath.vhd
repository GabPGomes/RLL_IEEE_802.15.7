-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_4b6b_datapath is
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
end entity dec_4b6b_datapath;

architecture estrtutural of dec_4b6b_datapath is
  
signal reg_in   : std_logic_vector(5 downto 0);
signal reg_out, decoded_symbol  : std_logic_vector(3 downto 0); 
signal err_symbol  : std_logic;    

begin

-----------------------------------------------------------------------------------------

-- inferindo registradores
regs: process(I_CLK_DATAPATH)
begin
    if rising_edge(I_CLK_DATAPATH) then
        if I_RST_DATAPATH = '1' then
            reg_in  <=  "000000";
            reg_out <=  "0000";
        else
            
            if(I_REG_IN_LOAD_DATAPATH = '1') then
                reg_in  <= I_DATA_DATAPATH;
            end if;

            if(I_REG_OUT_LOAD_DATAPATH = '1') then
                reg_out <= decoded_symbol;
            end if;

        end if;
    end if;
end process regs;

------------------------------------------------------------------------------------------
    
 -- logica do codificador
 
enc_4b6b_table: process(reg_in)
begin
    case reg_in is
        when "000000" => -- 0  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "000001" => -- 1  
            decoded_symbol  <= "0001";  
            err_symbol      <= '1';
        when "000010" => -- 2  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "000011" => -- 3  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "000100" => -- 4  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "000101" => -- 5  
            decoded_symbol  <= "0001";  
            err_symbol      <= '1';
        when "000110" => -- 6  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "000111" => -- 7  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "001000" => -- 8  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "001001" => -- 9  
            decoded_symbol  <= "0001";  
            err_symbol      <= '1';
        when "001010" => -- 10  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "001011" => -- 11  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "001100" => -- 12  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "001101" => -- 13  
            decoded_symbol  <= "0001";  
            err_symbol      <= '0';
        when "001110" => -- 14  
            decoded_symbol  <= "0000";  
            err_symbol      <= '0';
        when "001111" => -- 15  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "010000" => -- 16  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "010001" => -- 17  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "010010" => -- 18  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "010011" => -- 19  
            decoded_symbol  <= "0010";  
            err_symbol      <= '0';
        when "010100" => -- 20  
            decoded_symbol  <= "0011";  
            err_symbol      <= '1';
        when "010101" => -- 21  
            decoded_symbol  <= "0100";  
            err_symbol      <= '0';
        when "010110" => -- 22  
            decoded_symbol  <= "0011";  
            err_symbol      <= '0';
        when "010111" => -- 23  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "011000" => -- 24  
            decoded_symbol  <= "1000";  
            err_symbol      <= '1';
        when "011001" => -- 25  
            decoded_symbol  <= "1000";  
            err_symbol      <= '0';
        when "011010" => -- 26  
            decoded_symbol  <= "1001";  
            err_symbol      <= '0';
        when "011011" => -- 27  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "011100" => -- 28  
            decoded_symbol  <= "1010";  
            err_symbol      <= '0';
        when "011101" => -- 29  
            decoded_symbol  <= "0001";  
            err_symbol      <= '1';
        when "011110" => -- 30  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "011111" => -- 31  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "100000" => -- 32  
            decoded_symbol  <= "0101";  
            err_symbol      <= '1';
        when "100001" => -- 33  
            decoded_symbol  <= "0101";  
            err_symbol      <= '1';
        when "100010" => -- 34  
            decoded_symbol  <= "0101";  
            err_symbol      <= '1';
        when "100011" => -- 35  
            decoded_symbol  <= "0101";  
            err_symbol      <= '0';
        when "100100" => -- 36  
            decoded_symbol  <= "0110";  
            err_symbol      <= '1';
        when "100101" => -- 37  
            decoded_symbol  <= "0111";  
            err_symbol      <= '0';
        when "100110" => -- 38  
            decoded_symbol  <= "0110";  
            err_symbol      <= '0';
        when "100111" => -- 39  
            decoded_symbol  <= "0101";  
            err_symbol      <= '1';
        when "101000" => -- 40  
            decoded_symbol  <= "1101";  
            err_symbol      <= '1';
        when "101001" => -- 41  
            decoded_symbol  <= "1101";  
            err_symbol      <= '0';
        when "101010" => -- 42  
            decoded_symbol  <= "1110";  
            err_symbol      <= '0';
        when "101011" => -- 43  
            decoded_symbol  <= "0101";  
            err_symbol      <= '1';
        when "101100" => -- 44  
            decoded_symbol  <= "1111";  
            err_symbol      <= '0';
        when "101101" => -- 45  
            decoded_symbol  <= "0001";  
            err_symbol      <= '1';
        when "101110" => -- 46  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "101111" => -- 47  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "110000" => -- 48  
            decoded_symbol  <= "1011";  
            err_symbol      <= '1';
        when "110001" => -- 49  
            decoded_symbol  <= "1011";  
            err_symbol      <= '0';
        when "110010" => -- 50  
            decoded_symbol  <= "1100";  
            err_symbol      <= '0';
        when "110011" => -- 51  
            decoded_symbol  <= "0101";  
            err_symbol      <= '1';
        when "110100" => -- 52  
            decoded_symbol  <= "0011";  
            err_symbol      <= '1';
        when "110101" => -- 53  
            decoded_symbol  <= "0100";  
            err_symbol      <= '1';
        when "110110" => -- 54  
            decoded_symbol  <= "0011";  
            err_symbol      <= '1';
        when "110111" => -- 55  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "111000" => -- 56  
            decoded_symbol  <= "1000";  
            err_symbol      <= '1';
        when "111001" => -- 57  
            decoded_symbol  <= "1000";  
            err_symbol      <= '1';
        when "111010" => -- 58  
            decoded_symbol  <= "1001";  
            err_symbol      <= '1';
        when "111011" => -- 59  
            decoded_symbol  <= "0010";  
            err_symbol      <= '1';
        when "111100" => -- 60  
            decoded_symbol  <= "1010";  
            err_symbol      <= '1';
        when "111101" => -- 61  
            decoded_symbol  <= "0001";  
            err_symbol      <= '1';
        when "111110" => -- 62  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when "111111" => -- 63  
            decoded_symbol  <= "0000";  
            err_symbol      <= '1';
        when others =>
            decoded_symbol <= "0000";
            err_symbol <= '0';
	end case;
end process;

 ------------------------------------------------------------------------------------------
 
 -- atribuindo valores as saidas
 
 O_DATA_DATAPATH <= reg_out;
 
 O_ERR_DATAPATH <= err_symbol;
    
end architecture estrtutural;