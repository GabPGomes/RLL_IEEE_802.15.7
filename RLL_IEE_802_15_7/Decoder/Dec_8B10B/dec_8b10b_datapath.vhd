-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_8b10b_datapath is
    port (
        -- sinais da interface
        I_RST_DATAPATH, I_CLK_DATAPATH  :   in std_logic;
        I_DATA_DATAPATH                 :   in std_logic_vector(9 downto 0);
        O_DATA_DATAPATH                 :   out std_logic_vector(7 downto 0);
        O_ERR_DATAPATH                  :   out std_logic;
        -- comunicaçao com a controladora
        I_REG_IN_LOAD_DATAPATH          :   in std_logic;
        I_REG_OUT_LOAD_DATAPATH         :   in std_logic
    );
end entity dec_8b10b_datapath;

architecture estrutural of dec_8b10b_datapath is
   
    component dec_8b10b is	
        port(
            RESET : in std_logic ;	-- Global asynchronous reset (AH) 
            RBYTECLK : in std_logic ;	-- Master synchronous receive byte clock
            AI, BI, CI, DI, EI, II : in std_logic ;
            FI, GI, HI, JI : in std_logic ; -- Encoded input (LS..MS)		
            KO : out std_logic ;	-- Control (K) character indicator (AH)
            HO, GO, FO, EO, DO, CO, BO, AO : out std_logic 	-- Decoded out (MS..LS)
            );
    end component dec_8b10b;

------------------------------------------------------------------------------------

signal reg_in   : std_logic_vector(9 downto 0);
signal reg_out, decoded_symbol  : std_logic_vector(7 downto 0);

------------------------------------------------------------------------------------

begin

    my_decoder: dec_8b10b	
        port map(
            RESET       =>  I_RST_DATAPATH,
            RBYTECLK    =>  I_CLK_DATAPATH,
            AI  => reg_in(0), 
            BI  => reg_in(1),
            CI  => reg_in(2),
            DI  => reg_in(3),
            EI  => reg_in(4),
            II  => reg_in(5),
            FI  => reg_in(6),
            GI  => reg_in(7),
            HI  => reg_in(8),
            JI  => reg_in(9),
            KO  => O_ERR_DATAPATH, 
            HO  => decoded_symbol(7),
            GO  => decoded_symbol(6),
            FO  => decoded_symbol(5),
            EO  => decoded_symbol(4),
            DO  => decoded_symbol(3),
            CO  => decoded_symbol(2),
            BO  => decoded_symbol(1),
            AO  => decoded_symbol(0)
        ); 

--------------------------------------------------------------------------------------------

-- inferindo registradores
regs: process(I_CLK_DATAPATH)
begin
    if rising_edge(I_CLK_DATAPATH) then
        if I_RST_DATAPATH = '1' then
            reg_in  <=  "0000000000";
            reg_out <=  "00000000";
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

----------------------------------------------------------------------------------------------------

 -- atribuindo valores as saidas
 
 O_DATA_DATAPATH <= reg_out;

end architecture estrutural;