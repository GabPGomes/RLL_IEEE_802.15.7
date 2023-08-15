library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RLL_ENCODER_tb_modes is
end entity RLL_ENCODER_tb_modes;

architecture teste of RLL_ENCODER_tb_modes is

    component RLL_ENCODER is
        port (
                CLK_RLL_ENC, RST_RLL_ENC    : in std_logic;
                I_MCS_ID_RLL_ENC            : in std_logic_vector(5 downto 0);
                I_VALID_RLL_ENC             : in std_logic;  
                I_DATA_RLL_ENC              : in std_logic_vector(7 downto 0);
                I_CONSUME_RLL_ENC           : in std_logic;
                I_LAST_DATA_RLL_ENC         : in std_logic;
                O_VALID_RLL_ENC             : out std_logic;
                O_LAST_DATA_RLL_ENC         : out std_logic;
                O_DATA_RLL_ENC              : out std_logic;
                O_IN_READY_RLL_ENC          : out std_logic;
                O_ERR_RLL_ENC               : out std_logic
        );
    end component RLL_ENCODER;

-------------------------------------------------------------------------------------------

signal CLK_RLL_ENC                 : std_logic := '1';
signal RST_RLL_ENC                 : std_logic;
signal I_MCS_ID_RLL_ENC            : std_logic_vector(5 downto 0);
signal I_VALID_RLL_ENC             : std_logic;  
signal I_DATA_RLL_ENC              : std_logic_vector(7 downto 0);
signal I_CONSUME_RLL_ENC           : std_logic;
signal I_LAST_DATA_RLL_ENC         : std_logic;

signal O_VALID_RLL_ENC             : std_logic;
signal O_LAST_DATA_RLL_ENC         : std_logic;
signal O_DATA_RLL_ENC              : std_logic;
signal O_IN_READY_RLL_ENC          : std_logic;
signal O_ERR_RLL_ENC               : std_logic;

--------------------------------------------------------------------------------------------

begin
 
    dut: RLL_ENCODER
        port map (
                CLK_RLL_ENC         =>  CLK_RLL_ENC,             
                RST_RLL_ENC         =>  RST_RLL_ENC,             
                I_MCS_ID_RLL_ENC    =>  I_MCS_ID_RLL_ENC,        
                I_VALID_RLL_ENC     =>  I_VALID_RLL_ENC,         
                I_DATA_RLL_ENC      =>  I_DATA_RLL_ENC,          
                I_CONSUME_RLL_ENC   =>  I_CONSUME_RLL_ENC,       
                I_LAST_DATA_RLL_ENC =>  I_LAST_DATA_RLL_ENC,
                O_VALID_RLL_ENC     =>  O_VALID_RLL_ENC,              
                O_LAST_DATA_RLL_ENC =>  O_LAST_DATA_RLL_ENC,          
                O_DATA_RLL_ENC      =>  O_DATA_RLL_ENC,               
                O_IN_READY_RLL_ENC  =>  O_IN_READY_RLL_ENC,
                O_ERR_RLL_ENC       => O_ERR_RLL_ENC         
        );

--------------------------------------------------------------------------------------------    

CLK_RLL_ENC <= not CLK_RLL_ENC after 5 ns;
RST_RLL_ENC <= '1', '0' after 100 ns;

--
-- DESCOMENTE O TRECHO DE CODIGO CORRESPONDENTE AO MODO DE OPERACAO DESEJADO
--

test_proc: process
begin

    -- ERRO --
    --========
    -- I_DATA_RLL_ENC      <= (others => '1');
    -- -- inicia a porta
    -- I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
    -- I_VALID_RLL_ENC     <= '0';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 100 ns;
    -- report "entrou em WAIT_IN";
    -- -- WAIT_IN -> CHECK_MCS_ID
    -- I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
    -- I_VALID_RLL_ENC     <= '1';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 10 ns; 
    -- -- CHECK_MCS_ID -> ERR_MCS_ID -> WAIT_IN
    -- wait for 20 ns;
    -- report "Voltou para WAIT_IN";
    -- I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
    -- I_VALID_RLL_ENC     <= '0';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait; 

    -- 3_MAN =
    --========
    -- -- inicia a porta
    -- I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
    -- I_VALID_RLL_ENC     <= '0';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_DATA_RLL_ENC      <= (others => '1');
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 100 ns;
    -- report "entrou em WAIT_IN";
    -- -- WAIT_IN -> CHECK_MCS_ID -> CHECK_VALID
    -- I_MCS_ID_RLL_ENC    <= "000001";
    -- I_VALID_RLL_ENC     <= '1';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_DATA_RLL_ENC      <= b"0000_1111";
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 20 ns;
    -- loop
    --     report "Entrou em CHECK_VALID";
    --     -- CHECK_VALID -> LOAD_IN -> LOAD_SEC_IN
    --     I_MCS_ID_RLL_ENC    <= "000001";
    --     I_VALID_RLL_ENC     <= '1';
    --     I_CONSUME_RLL_ENC   <= '0';
    --     I_DATA_RLL_ENC      <= b"0000_1111";
    --     I_LAST_DATA_RLL_ENC <= '0';
    --     wait for 20 ns;
    --     report "entrou em LOAD_SEC_IN";
    --     -- LOAD_SEC_IN -> WAIT_ENC_READY -> WAIT_ENC_DONE -> -> LOAD_OUT -> -> LOAD_SEC_IN
    --     -- três vezes
    --     wait for 180 ns;
    --     report "Entrou em READ_CHECK_FIFO";
    --     -- READ_CHECK_FIFO -> WAIT_OUT_CONTINUE -> READ_CHECK_FIFO
    --     -- cinco vezes
    --     I_MCS_ID_RLL_ENC    <= "000001";
    --     I_VALID_RLL_ENC     <= '0';
    --     I_CONSUME_RLL_ENC   <= '1';
    --     I_DATA_RLL_ENC      <= (others => '1');
    --     I_LAST_DATA_RLL_ENC <= '0';
    --     wait for 100 ns;
    --     -- READ_CHECK_FIFO -> WAIT_OUT_FINISH_WORD -> RESET_ENC_FINISH_WORD
    --     wait for 20 ns;
    --     report "Entrou em RESET_ENC_FINISH_WORD";
    --     -- RESET_ENC_FINISH_WORD -> CHECK_VALID
    --     wait for 10 ns;
    -- end loop;


    -- 4_MAN =
    --========
    -- inicia a porta
    -- I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
    -- I_VALID_RLL_ENC     <= '0';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_DATA_RLL_ENC      <= (others => '1');
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 100 ns;
    -- report "entrou em WAIT_IN";
    -- -- WAIT_IN -> CHECK_MCS_ID -> CHECK_VALID
    -- I_MCS_ID_RLL_ENC    <= "000000";
    -- I_VALID_RLL_ENC     <= '1';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_DATA_RLL_ENC      <= b"0000_1111";
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 20 ns;
    -- loop
    --     report "Entrou em CHECK_VALID";
    --     -- CHECK_VALID -> LOAD_IN -> LOAD_SEC_IN
    --     I_MCS_ID_RLL_ENC    <= "000000";
    --     I_VALID_RLL_ENC     <= '1';
    --     I_CONSUME_RLL_ENC   <= '0';
    --     I_DATA_RLL_ENC      <= b"0000_1100";
    --     I_LAST_DATA_RLL_ENC <= '0';
    --     wait for 20 ns;
    --     report "entrou em LOAD_SEC_IN";
    --     -- LOAD_SEC_IN -> WAIT_ENC_READY -> WAIT_ENC_DONE -> -> LOAD_OUT -> -> LOAD_SEC_IN
    --     -- quatro vezes
    --     wait for 240 ns;
    --     report "Entrou em READ_CHECK_FIFO";
    --     -- READ_CHECK_FIFO -> WAIT_OUT_CONTINUE -> READ_CHECK_FIFO
    --     -- sete vezes
    --     I_MCS_ID_RLL_ENC    <= "000001";
    --     I_VALID_RLL_ENC     <= '0';
    --     I_CONSUME_RLL_ENC   <= '1';
    --     I_DATA_RLL_ENC      <= (others => '1');
    --     I_LAST_DATA_RLL_ENC <= '0';
    --     wait for 140 ns;
    --     -- READ_CHECK_FIFO -> WAIT_OUT_FINISH_WORD -> RESET_ENC_FINISH_WORD
    --     wait for 20 ns;
    --     report "Entrou em RESET_ENC_FINISH_WORD";
    --     -- RESET_ENC_FINISH_WORD -> CHECK_VALID
    --     wait for 10 ns;
    -- end loop;


    -- 8_MAN =
    --========
    -- inicia a porta
    -- I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
    -- I_VALID_RLL_ENC     <= '0';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_DATA_RLL_ENC      <= (others => '1');
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 100 ns;
    -- report "entrou em WAIT_IN";
    -- -- WAIT_IN -> CHECK_MCS_ID -> CHECK_VALID
    -- I_MCS_ID_RLL_ENC    <= "000100";
    -- I_VALID_RLL_ENC     <= '1';
    -- I_CONSUME_RLL_ENC   <= '0';
    -- I_DATA_RLL_ENC      <= b"0000_1111";
    -- I_LAST_DATA_RLL_ENC <= '0';
    -- wait for 20 ns;
    -- loop
    --     report "Entrou em CHECK_VALID";
    --     -- CHECK_VALID -> LOAD_IN -> LOAD_SEC_IN
    --     I_MCS_ID_RLL_ENC    <= "000100";
    --     I_VALID_RLL_ENC     <= '1';
    --     I_CONSUME_RLL_ENC   <= '0';
    --     I_DATA_RLL_ENC      <= b"0000_1111";
    --     I_LAST_DATA_RLL_ENC <= '0';
    --     wait for 20 ns;
    --     report "entrou em LOAD_SEC_IN";
    --     -- LOAD_SEC_IN -> WAIT_ENC_READY -> WAIT_ENC_DONE -> -> LOAD_OUT -> -> LOAD_SEC_IN
    --     -- oito vezes
    --     wait for 480 ns;
    --     report "Entrou em READ_CHECK_FIFO";
    --     -- READ_CHECK_FIFO -> WAIT_OUT_CONTINUE -> READ_CHECK_FIFO
    --     -- quinze vezes
    --     I_MCS_ID_RLL_ENC    <= "000100";
    --     I_VALID_RLL_ENC     <= '0';
    --     I_CONSUME_RLL_ENC   <= '1';
    --     I_DATA_RLL_ENC      <= (others => '1');
    --     I_LAST_DATA_RLL_ENC <= '0';
    --     wait for 300 ns;
    --     -- READ_CHECK_FIFO -> WAIT_OUT_FINISH_WORD -> RESET_ENC_FINISH_WORD
    --     wait for 20 ns;
    --     report "Entrou em RESET_ENC_FINISH_WORD";
    --     -- RESET_ENC_FINISH_WORD -> CHECK_VALID
    --     wait for 10 ns;
    -- end loop;


    -- 4_4B6B =
    --=========
   -- inicia a porta
   I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
   I_VALID_RLL_ENC     <= '0';
   I_CONSUME_RLL_ENC   <= '0';
   I_DATA_RLL_ENC      <= (others => '1');
   I_LAST_DATA_RLL_ENC <= '0';
   wait for 100 ns;
   report "entrou em WAIT_IN";
   -- WAIT_IN -> CHECK_MCS_ID -> CHECK_VALID
   I_MCS_ID_RLL_ENC    <= "000101";
   I_VALID_RLL_ENC     <= '1';
   I_CONSUME_RLL_ENC   <= '0';
   I_DATA_RLL_ENC      <= b"0000_0100";
   I_LAST_DATA_RLL_ENC <= '0';
   wait for 20 ns;
   loop
       report "Entrou em CHECK_VALID";
       -- CHECK_VALID -> LOAD_IN -> LOAD_SEC_IN
       I_MCS_ID_RLL_ENC    <= "000101";
       I_VALID_RLL_ENC     <= '1';
       I_CONSUME_RLL_ENC   <= '0';
       I_DATA_RLL_ENC      <= b"0000_0100";
       I_LAST_DATA_RLL_ENC <= '0';
       wait for 20 ns;
       I_MCS_ID_RLL_ENC    <= "000101";
       I_VALID_RLL_ENC     <= '0';
       I_CONSUME_RLL_ENC   <= '0';
       I_DATA_RLL_ENC      <= b"0000_0100";
       I_LAST_DATA_RLL_ENC <= '0';
       report "entrou em LOAD_SEC_IN";
       -- LOAD_SEC_IN -> -> -> -> WAIT_ENC_READY -> WAIT_ENC_DONE -> -> LOAD_OUT -> -> -> -> -> -> LOAD_SEC_IN
       -- uma vez
       wait for 130 ns;
       report "Entrou em READ_CHECK_FIFO";
       -- READ_CHECK_FIFO -> WAIT_OUT_CONTINUE -> READ_CHECK_FIFO
       -- cinco vezes
       I_MCS_ID_RLL_ENC    <= "000101";
       I_VALID_RLL_ENC     <= '0';
       I_CONSUME_RLL_ENC   <= '1';
       I_DATA_RLL_ENC      <= b"0000_0100";
       I_LAST_DATA_RLL_ENC <= '0';
       wait for 100 ns;
       -- READ_CHECK_FIFO -> WAIT_OUT_FINISH_WORD -> RESET_ENC_FINISH_WORD
       wait for 20 ns;
       report "Entrou em RESET_ENC_FINISH_WORD";
       -- RESET_ENC_FINISH_WORD -> CHECK_VALID
       wait for 10 ns;
   end loop;


    -- 8_4B6B =
    --=========
   -- inicia a porta
--    I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
--    I_VALID_RLL_ENC     <= '0';
--    I_CONSUME_RLL_ENC   <= '0';
--    I_DATA_RLL_ENC      <= (others => '1');
--    I_LAST_DATA_RLL_ENC <= '0';
--    wait for 100 ns;
--    report "entrou em WAIT_IN";
--    -- WAIT_IN -> CHECK_MCS_ID -> CHECK_VALID
--    I_MCS_ID_RLL_ENC    <= "001000";
--    I_VALID_RLL_ENC     <= '1';
--    I_CONSUME_RLL_ENC   <= '0';
--    I_DATA_RLL_ENC      <= b"0100_1110";
--    I_LAST_DATA_RLL_ENC <= '0';
--    wait for 20 ns;
--    loop
--        report "Entrou em CHECK_VALID";
--        -- CHECK_VALID -> LOAD_IN -> LOAD_SEC_IN
--        I_MCS_ID_RLL_ENC    <= "001000";
--        I_VALID_RLL_ENC     <= '1';
--        I_CONSUME_RLL_ENC   <= '0';
--        I_DATA_RLL_ENC      <= b"0100_1110";
--        I_LAST_DATA_RLL_ENC <= '0';
--        wait for 20 ns;
--        report "entrou em LOAD_SEC_IN";
--        -- LOAD_SEC_IN -> -> -> -> WAIT_ENC_READY -> WAIT_ENC_DONE -> -> LOAD_OUT -> -> -> -> -> -> LOAD_SEC_IN
--        -- duas vezes
--        wait for 260 ns;
--        report "Entrou em READ_CHECK_FIFO";
--        -- READ_CHECK_FIFO -> WAIT_OUT_CONTINUE -> READ_CHECK_FIFO
--        -- onze vezes
--        I_MCS_ID_RLL_ENC    <= "001000";
--        I_VALID_RLL_ENC     <= '0';
--        I_CONSUME_RLL_ENC   <= '1';
--        I_DATA_RLL_ENC      <= (others => '1');
--        I_LAST_DATA_RLL_ENC <= '0';
--        wait for 220 ns;
--        -- READ_CHECK_FIFO -> WAIT_OUT_FINISH_WORD -> RESET_ENC_FINISH_WORD
--        wait for 20 ns;
--        report "Entrou em RESET_ENC_FINISH_WORD";
--        -- RESET_ENC_FINISH_WORD -> CHECK_VALID
--        wait for 10 ns;
--    end loop;


    -- 88B10B =
    --=========
--    -- inicia a porta
--    I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
--    I_VALID_RLL_ENC     <= '0';
--    I_CONSUME_RLL_ENC   <= '0';
--    I_DATA_RLL_ENC      <= (others => '1');
--    I_LAST_DATA_RLL_ENC <= '0';
--    wait for 100 ns;
--    report "entrou em WAIT_IN";
--    -- WAIT_IN -> CHECK_MCS_ID -> CHECK_VALID
--    I_MCS_ID_RLL_ENC    <= "011000";
--    I_VALID_RLL_ENC     <= '1';
--    I_CONSUME_RLL_ENC   <= '0';
--    I_DATA_RLL_ENC      <= b"1110_0011";
--    I_LAST_DATA_RLL_ENC <= '0';
--    wait for 20 ns;
--    loop
--        report "Entrou em CHECK_VALID";
--        -- CHECK_VALID -> LOAD_IN -> LOAD_SEC_IN
--        I_MCS_ID_RLL_ENC    <= "011000";
--        I_VALID_RLL_ENC     <= '1';
--        I_CONSUME_RLL_ENC   <= '0';
--        I_DATA_RLL_ENC      <= b"1110_0011";
--        I_LAST_DATA_RLL_ENC <= '0';
--        wait for 20 ns;
--        I_MCS_ID_RLL_ENC    <= "011000";
--        I_VALID_RLL_ENC     <= '0';
--        I_CONSUME_RLL_ENC   <= '0';
--        I_DATA_RLL_ENC      <= b"1110_0011";
--        I_LAST_DATA_RLL_ENC <= '0';
--        report "entrou em LOAD_SEC_IN";
--        -- LOAD_SEC_IN (8x ->) WAIT_ENC_READY -> WAIT_ENC_DONE (5x ->) LOAD_OUT (10x ->) LOAD_SEC_IN
--        -- uma vez
--        wait for 240 ns;
--        report "Entrou em READ_CHECK_FIFO";
--        -- READ_CHECK_FIFO -> WAIT_OUT_CONTINUE -> READ_CHECK_FIFO
--        -- nove vezes
--        I_MCS_ID_RLL_ENC    <= "011000";
--        I_VALID_RLL_ENC     <= '0';
--        I_CONSUME_RLL_ENC   <= '1';
--        I_DATA_RLL_ENC      <= b"1110_0011";
--        I_LAST_DATA_RLL_ENC <= '0';
--        wait for 180 ns;
--        -- READ_CHECK_FIFO -> WAIT_OUT_FINISH_WORD -> RESET_ENC_FINISH_WORD
--        wait for 20 ns;
--        report "Entrou em RESET_ENC_FINISH_WORD";
--        -- RESET_ENC_FINISH_WORD -> CHECK_VALID
--        wait for 10 ns;
--    end loop;

    --==========
    -- 8NOCODE =
    --==========
   -- inicia a porta
--    I_MCS_ID_RLL_ENC    <= "001001"; -- invalido
--    I_VALID_RLL_ENC     <= '0';
--    I_CONSUME_RLL_ENC   <= '0';
--    I_DATA_RLL_ENC      <= (others => '1');
--    I_LAST_DATA_RLL_ENC <= '0';
--    wait for 100 ns;
--    report "entrou em WAIT_IN";
--    -- WAIT_IN -> CHECK_MCS_ID -> CHECK_VALID
--    I_MCS_ID_RLL_ENC    <= "100000";
--    I_VALID_RLL_ENC     <= '1';
--    I_CONSUME_RLL_ENC   <= '0';
--    I_DATA_RLL_ENC      <= b"1110_0011";
--    I_LAST_DATA_RLL_ENC <= '0';
--    wait for 20 ns;
--    loop
--        report "Entrou em CHECK_VALID";
--        -- CHECK_VALID -> LOAD_IN -> LOAD_DIRECT
--        I_MCS_ID_RLL_ENC    <= "100000";
--        I_VALID_RLL_ENC     <= '1';
--        I_CONSUME_RLL_ENC   <= '0';
--        I_DATA_RLL_ENC      <= b"1111_0000";
--        I_LAST_DATA_RLL_ENC <= '0';
--        wait for 20 ns;
--        report "entrou em LOAD_DIRECT";
--        -- LOAD_DIRECT (8x ->) READ_CHECK_FIFO
--        -- uma vez
--        wait for 80 ns;
--        report "Entrou em READ_CHECK_FIFO";

--        -- READ_CHECK_FIFO -> WAIT_OUT_CONTINUE -> READ_CHECK_FIFO
--        -- sete vezes
--        I_MCS_ID_RLL_ENC    <= "011000";
--        I_VALID_RLL_ENC     <= '0';
--        I_CONSUME_RLL_ENC   <= '1';
--        I_DATA_RLL_ENC      <= b"1111_0000";
--        I_LAST_DATA_RLL_ENC <= '0';
--        wait for 140 ns;
--        -- READ_CHECK_FIFO -> WAIT_OUT_FINISH_WORD -> RESET_ENC_FINISH_WORD
--        wait for 20 ns;
--        report "Entrou em RESET_ENC_FINISH_WORD";
--        -- RESET_ENC_FINISH_WORD -> CHECK_VALID
--        wait for 10 ns;
--    end loop;

end process; 

    
end architecture teste;
