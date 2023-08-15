library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_nocode is
    port (
        I_DATA_NOCODE              : in std_logic_vector(7 downto 0);
        O_DATA_NOCODE              : out std_logic_vector(7 downto 0);
        O_VALID_NOCODE             : out std_logic;
        O_IN_READY_NOCODE          : out std_logic
        -- nao usados
        -- I_CLK_NOCODE
        -- I_RST_NOCODE
        -- I_VALID_NOCODE
        -- I_CONSUME_NOCODE
        -- I_LAST_DATA_NOCODE
        -- O_LAST_DATA_NOCODE
        -- O_ERR_NOCODE
    );  
end entity dec_nocode;

architecture estrutural of dec_nocode is
    
begin

-- saidas sempre em um porque nao precisa esperar nada
O_VALID_NOCODE      <= '1';  
O_IN_READY_NOCODE   <= '1';

-- sinal passa direto
O_DATA_NOCODE <= I_DATA_NOCODE;

end architecture estrutural;