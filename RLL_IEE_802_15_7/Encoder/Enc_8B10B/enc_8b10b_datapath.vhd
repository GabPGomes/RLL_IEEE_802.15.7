-- documentacao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity enc_8b10b_datapath is
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
end entity enc_8b10b_datapath;

architecture estrutural of enc_8b10b_datapath is
   
    component enc_8b10b is	
        port(
            RESET : in std_logic ;		-- Global asynchronous reset (active high) 
            SBYTECLK : in std_logic ;	-- Master synchronous send byte clock
            KI : in std_logic ;			-- Control (K) input(active high)
            AI, BI, CI, DI, EI, FI, GI, HI : in std_logic ;	-- Unencoded input data
            JO, HO, GO, FO, IO, EO, DO, CO, BO, AO : out std_logic 	-- Encoded out 
            );
    end component enc_8b10b;

------------------------------------------------------------------------------------

signal clock_after_gating, reg_clock_gating: std_logic;
signal reg_in   : std_logic_vector(7 downto 0);
signal reg_out, encoded_symbol  : std_logic_vector(9 downto 0);

------------------------------------------------------------------------------------

begin

    my_encoder: enc_8b10b	
        port map(
            -- gerias
            RESET       =>  I_ENC_RESET_DATAPATH,
            SBYTECLK    =>  clock_after_gating,
            -- entradas
            KI  =>  '0', -- somente codificaçao de dados, sem simbolo de controle 			
            AI  =>  reg_in(0),   
            BI  =>  reg_in(1),   
            CI  =>  reg_in(2),
            DI  =>  reg_in(3),
            EI  =>  reg_in(4),
            FI  =>  reg_in(5),
            GI  =>  reg_in(6),
            HI  =>  reg_in(7),
            -- saidas 
            JO  =>  encoded_symbol(9),
            HO  =>  encoded_symbol(8),
            GO  =>  encoded_symbol(7),
            FO  =>  encoded_symbol(6),
            IO  =>  encoded_symbol(5),
            EO  =>  encoded_symbol(4),
            DO  =>  encoded_symbol(3),
            CO  =>  encoded_symbol(2),
            BO  =>  encoded_symbol(1),
            AO  =>  encoded_symbol(0)
            );   


-------------------------------------------------------------------------------------    

-- logica do clock gating

falledge_reg: process(I_CLK_DATAPATH)
begin
    if falling_edge(I_CLK_DATAPATH) then
        if I_RST_DATAPATH = '1' then
            reg_clock_gating <= '0';
        else
            reg_clock_gating <= I_CLK_GATE_ON_DATAPATH;
        end if;
    end if;
end process falledge_reg;

clock_after_gating <= reg_clock_gating and I_CLK_DATAPATH;

--------------------------------------------------------------------------------------------

-- inferindo registradores
regs: process(I_CLK_DATAPATH)
begin
    if rising_edge(I_CLK_DATAPATH) then
        if I_RST_DATAPATH = '1' then
            reg_in  <=  "00000000";
            reg_out <=  "0000000000";
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

----------------------------------------------------------------------------------------------------

 -- atribuindo valores as saidas
 
 O_DATA_DATAPATH <= reg_out;

end architecture estrutural;