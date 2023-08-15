--------------------------------------------
-- este testbench testa os casos de excecao
--------------------------------------------
-- mcs_id invalido
-- ultimo dado
-- ultimo dado incompleto
-- sem codificacao, portanto vai direto

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RLL_Decoder_tb1 is
    generic(
        modo_a_testar : string := "M_10_8B10B" -- aqui seleciona qual testbench sera executado
    );
end entity RLL_Decoder_tb1;

architecture teste of RLL_Decoder_tb1 is

    component RLL_Decoder is
        port (
            CLK_RLL_DEC, RST_RLL_DEC    : in std_logic;
            I_MCS_ID_RLL_DEC            : in std_logic_vector(5 downto 0);
            I_VALID_RLL_DEC             : in std_logic;  
            I_DATA_RLL_DEC              : in std_logic;
            I_CONSUME_RLL_DEC           : in std_logic;
            I_LAST_DATA_RLL_DEC         : in std_logic;
            O_VALID_RLL_DEC             : out std_logic;
            O_LAST_DATA_RLL_DEC         : out std_logic;
            O_DATA_RLL_DEC              : out std_logic_vector(7 downto 0);
            O_IN_READY_RLL_DEC          : out std_logic;
            O_ERR_RLL_DEC               : out std_logic
    );
    end component RLL_Decoder;

-----------------------------------------------------------------------------------------

signal CLK_RLL_DEC          : std_logic := '1';
signal RST_RLL_DEC          : std_logic;
signal I_MCS_ID_RLL_DEC     : std_logic_vector(5 downto 0);
signal I_VALID_RLL_DEC      : std_logic;  
signal I_DATA_RLL_DEC       : std_logic;
signal I_CONSUME_RLL_DEC    : std_logic;
signal I_LAST_DATA_RLL_DEC  : std_logic;
signal O_VALID_RLL_DEC      : std_logic;
signal O_LAST_DATA_RLL_DEC  : std_logic;
signal O_DATA_RLL_DEC       : std_logic_vector(7 downto 0);
signal O_IN_READY_RLL_DEC   : std_logic;
signal O_ERR_RLL_DEC        : std_logic;

------------------------------------------------------------------------------------------

begin
    
    dut: RLL_Decoder
        port map(
            CLK_RLL_DEC             =>  CLK_RLL_DEC,
            RST_RLL_DEC             =>  RST_RLL_DEC,
            I_MCS_ID_RLL_DEC        =>  I_MCS_ID_RLL_DEC,
            I_VALID_RLL_DEC         =>  I_VALID_RLL_DEC,
            I_DATA_RLL_DEC          =>  I_DATA_RLL_DEC,
            I_CONSUME_RLL_DEC       =>  I_CONSUME_RLL_DEC,
            I_LAST_DATA_RLL_DEC     =>  I_LAST_DATA_RLL_DEC,
            O_VALID_RLL_DEC         =>  O_VALID_RLL_DEC,
            O_LAST_DATA_RLL_DEC     =>  O_LAST_DATA_RLL_DEC,
            O_DATA_RLL_DEC          =>  O_DATA_RLL_DEC,
            O_IN_READY_RLL_DEC      =>  O_IN_READY_RLL_DEC,
            O_ERR_RLL_DEC           =>  O_ERR_RLL_DEC
    );   

-------------------------------------------------------------------------

CLK_RLL_DEC <= not CLK_RLL_DEC after 5 ns;        
RST_RLL_DEC <= '1', '0' after 100 ns;

FLAG_8_NOCODE: if modo_a_testar =  "M_8_NOCODE" generate
    testbench_8NOCODE: process
    begin
        -- inicia as portas
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 110 ns;
        report "entrou em wait_in";
        -- entrega um MCS_ID valido do tipo NO_CODE
        -- WAIT_IN -> CHECK_MCS_ID
        I_MCS_ID_RLL_DEC    <= b"10_0000";   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '1';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        -- aguarda entrar no loop de leitura
        -- CHECK_MCS_ID -> CHECK_VALID_LAST
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        loop_NOCODE: loop
            report "entrou em check_valid_last";
            -- Coloca oito bits validos
            -- CHECK_VALID_LAST -> LOAD_IN (+8) -> PRE_READ_FIFO
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '1';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 80 ns;
            -- CHECK_VALID_LAST -> LOAD_IN (+8) -> PRE_READ_FIFO
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 80 ns;
            report "entrou em pre_read_fifo";
            wait for 10 ns;
            -- LOAD_SEC_IN (+7) -> WAIT_DEC_READY
            wait for 80 ns;
            report " entrou em wait_dec_ready";
            -- WAIT_DEC_READY -> WAIT_DEC_DONE -> LOAD_OUT
            wait for 20 ns;
            -- LOAD_OUT (+7) -> CHECK_LAST -> WAIT_LAST_OUT
            wait for 90 ns;
            report "entrou em wait_out";
            -- Le o dado
            -- WAIT_OUT -> RESET_DEC
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '1';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 10 ns;
            -- volta para o inicio
            -- RESET_DEC -> SET_COUNTER -> CHECK_I_VALID_LAST
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
        end loop;
    end process;
end generate;

FLAG_2_MAN: if modo_a_testar =  "M_2_MAN" generate
    testbench_2MAN : process
    begin
        -- inicia as portas
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 100 ns;
        report "entrou em wait_in";
        -- entrega um MCS_ID valido do tipo NO_CODE
        -- WAIT_IN -> CHECK_MCS_ID
        I_MCS_ID_RLL_DEC    <= b"00_0000";   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        -- aguarda entrar no loop de leitura
        -- CHECK_MCS_ID -> CHECK_VALID_LAST
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        loop_2MAN: loop
            report "entrou em check_valid_last";
            -- Coloca dois bits validos
            -- CHECK_VALID_LAST -> LOAD_IN (+2)
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN (+2) -> PRE_READ_FIFO
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '1';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
            report "entrou em pre_read_fifo";
            -- PRE_READ_FIFO -> LOAD_SEC_IN
            wait for 10 ns;
            -- LOAD_SEC_IN (+2) -> WAIT_DEC_READY
            wait for 20 ns;
            report " entrou em wait_dec_ready";
            -- WAIT_DEC_READY -> WAIT_DEC_DONE (+2) -> LOAD_OUT
            wait for 30 ns;
            -- LOAD_OUT -> CHECK_LAST -> WAIT_LAST_OUT
            wait for 20 ns;
            report "entrou em wait_out";
            -- Le o dado
            -- WAIT_OUT -> RESET_DEC
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '1';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 10 ns;
            -- volta para o inicio
            -- RESET_DEC -> SET_COUNTER -> CHECK_I_VALID_LAST
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
        end loop;
    end process;
end generate;

FLAG_8_MAN: if modo_a_testar =  "M_8_MAN" generate
    testbench_8MAN: process
    begin
        -- inicia as portas
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 100 ns;
        report "entrou em wait_in";
        -- entrega um MCS_ID valido do tipo NO_CODE
        -- WAIT_IN -> CHECK_MCS_ID
        I_MCS_ID_RLL_DEC    <= b"00_0011";   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        -- aguarda entrar no loop de leitura
        -- CHECK_MCS_ID -> CHECK_VALID_LAST
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        loop_8MAN: loop
            report "entrou em check_valid_last";
            for ii in 1 to 4 loop
                -- Coloca oito bits validos
                -- CHECK_VALID_LAST -> LOAD_IN (+2)
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '0';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
                -- CHECK_VALID_LAST -> LOAD_IN (+2) -> PRE_READ_FIFO
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '1';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
            end loop;
            report "entrou em pre_read_fifo";
            -- PRE_READ_FIFO -> LOAD_SEC_IN
            wait for 10 ns;
            -- LOAD_SEC_IN (+2) -> WAIT_DEC_READY -> WAIT_DEC_DONE (+2) -> LOAD_OUT -> loop 4 vezes -> CHECK_LAST
            wait for 240 ns;
            -- CHECK_LAST -> WAIT_LAST_OUT
            wait for 10 ns;
            report "entrou em wait_out";
            -- Le o dado
            -- WAIT_OUT -> RESET_DEC
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '1';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 10 ns;
            -- volta para o inicio
            -- RESET_DEC -> SET_COUNTER -> CHECK_I_VALID_LAST
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
        end loop;
    end process;
end generate;

FLAG_16_MAN: if modo_a_testar =  "M_16_MAN" generate
    testbench_16MAN: process
    begin
        -- inicia as portas
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 100 ns;
        report "entrou em wait_in";
        -- entrega um MCS_ID valido do tipo NO_CODE
        -- WAIT_IN -> CHECK_MCS_ID
        I_MCS_ID_RLL_DEC    <= b"00_0100";   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        -- aguarda entrar no loop de leitura
        -- CHECK_MCS_ID -> CHECK_VALID_LAST
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        loop_16MAN: loop
            report "entrou em check_valid_last";
            for ii in 1 to 8 loop
                -- Coloca oito bits validos
                -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_I_VALID_LAST
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '0';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
                -- CHECK_VALID_LAST -> LOAD_IN -> (na ultima iteracao) PRE_READ_FIFO
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '1';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
            end loop;
            report "entrou em pre_read_fifo";
            -- PRE_READ_FIFO -> LOAD_SEC_IN
            wait for 10 ns;
            -- LOAD_SEC_IN (+2) -> WAIT_DEC_READY -> WAIT_DEC_DONE (+2) -> LOAD_OUT -> loop 8 vezes -> CHECK_LAST
            wait for 480 ns;
            -- CHECK_LAST -> WAIT_LAST_OUT
            wait for 10 ns;
            report "entrou em wait_out";
            -- Le o dado
            -- WAIT_OUT -> RESET_DEC
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '1';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 10 ns;
            -- volta para o inicio
            -- RESET_DEC -> SET_COUNTER -> CHECK_I_VALID_LAST
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
        end loop;
    end process;
end generate;

FLAG_6_4B6B: if modo_a_testar =  "M_6_4B6B" generate
    testbench_64B6B : process
    begin
        -- inicia as portas
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 100 ns;
        report "entrou em wait_in";
        -- entrega um MCS_ID valido do tipo NO_CODE
        -- WAIT_IN -> CHECK_MCS_ID
        I_MCS_ID_RLL_DEC    <= b"00_0101";   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        -- aguarda entrar no loop de leitura
        -- CHECK_MCS_ID -> CHECK_VALID_LAST
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        loop_64B6B: loop
            report "entrou em check_valid_last";
            for ii in 1 to 3 loop
                -- Coloca oito bits validos
                -- CHECK_VALID_LAST -> LOAD_IN (+2)
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '0';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
                -- CHECK_VALID_LAST -> LOAD_IN (+2) -> PRE_READ_FIFO
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '1';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
            end loop;
            report "entrou em pre_read_fifo";
            -- PRE_READ_FIFO -> LOAD_SEC_IN
            wait for 10 ns;
            -- LOAD_SEC_IN (+6) -> WAIT_DEC_READY -> WAIT_DEC_DONE (+2) -> LOAD_OUT (+4) -> CHECK_LAST
            wait for 130 ns;
            -- CHECK_LAST -> WAIT_LAST_OUT
            wait for 10 ns;
            report "entrou em wait_out";
            -- Le o dado
            -- WAIT_OUT -> RESET_DEC
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '1';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 10 ns;
            -- volta para o inicio
            -- RESET_DEC -> SET_COUNTER -> CHECK_I_VALID_LAST
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
        end loop;
    end process;
end generate;

FLAG_12_4B6B: if modo_a_testar =  "M_12_4B6B" generate
    testbench_124B6B : process
    begin
        -- inicia as portas
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 100 ns;
        report "entrou em wait_in";
        -- entrega um MCS_ID valido do tipo NO_CODE
        -- WAIT_IN -> CHECK_MCS_ID
        I_MCS_ID_RLL_DEC    <= b"00_1000";   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        -- aguarda entrar no loop de leitura
        -- CHECK_MCS_ID -> CHECK_VALID_LAST
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        loop_124B6B: loop
            report "entrou em check_valid_last";
            for ii in 1 to 6 loop
                -- Coloca oito bits validos
                -- CHECK_VALID_LAST -> LOAD_IN (+2)
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '1';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
                -- CHECK_VALID_LAST -> LOAD_IN (+2) -> PRE_READ_FIFO
                I_MCS_ID_RLL_DEC    <= (others => '0');   
                I_VALID_RLL_DEC     <= '1';
                I_DATA_RLL_DEC      <= '0';
                I_CONSUME_RLL_DEC   <= '0';  
                I_LAST_DATA_RLL_DEC <= '0';
                wait for 20 ns;
            end loop;
            report "entrou em pre_read_fifo";
            -- PRE_READ_FIFO -> LOAD_SEC_IN
            wait for 10 ns;
            -- LOAD_SEC_IN (+6) -> WAIT_DEC_READY -> WAIT_DEC_DONE (+2) -> LOAD_OUT (+4) -> loop mais 1 vez -> CHECK_LAST
            wait for 260 ns;
            -- CHECK_LAST -> WAIT_LAST_OUT
            wait for 10 ns;
            report "entrou em wait_out";
            -- Le o dado
            -- WAIT_OUT -> RESET_DEC
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '1';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 10 ns;
            -- volta para o inicio
            -- RESET_DEC -> SET_COUNTER -> CHECK_I_VALID_LAST
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
        end loop;
    end process;
end generate;

FLAG_10_8B10B: if modo_a_testar = "M_10_8B10B" generate
    testbench_108B10B: process
    begin
        -- inicia as portas
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '0';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 100 ns;
        report "entrou em wait_in";
        -- entrega um MCS_ID valido do tipo NO_CODE
        -- WAIT_IN -> CHECK_MCS_ID
        I_MCS_ID_RLL_DEC    <= b"01_1000";   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        -- aguarda entrar no loop de leitura
        -- CHECK_MCS_ID -> CHECK_VALID_LAST
        I_MCS_ID_RLL_DEC    <= (others => '0');   
        I_VALID_RLL_DEC     <= '1';
        I_DATA_RLL_DEC      <= '0';
        I_CONSUME_RLL_DEC   <= '0';  
        I_LAST_DATA_RLL_DEC <= '0';
        wait for 10 ns;
        loop_108B10B: loop
            report "entrou em check_valid_last";
            -- Coloca dez bits validos "10_1011_0010" = "1001_1111"
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '1';
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '0';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '1';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '0';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '1';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '1';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '0';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '0';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> CHECK_VALID_LAST   
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '1';  
            wait for 20 ns;
            -- CHECK_VALID_LAST -> LOAD_IN -> PRE_READ_FIFO  
            I_VALID_RLL_DEC     <= '1';
            I_DATA_RLL_DEC      <= '0';  
            wait for 20 ns;
            report "entrou em pre_read_fifo";
            -- PRE_READ_FIFO -> LOAD_SEC_IN
            wait for 10 ns;
            -- LOAD_SEC_IN (+10) -> WAIT_DEC_READY -> WAIT_DEC_DONE (+3) -> LOAD_OUT (+8) -> CHECK_LAST
            wait for 220 ns;
            -- CHECK_LAST -> WAIT_LAST_OUT
            wait for 10 ns;
            report "entrou em wait_out";
            -- Le o dado
            -- WAIT_OUT -> RESET_DEC
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '1';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 10 ns;
            -- volta para o inicio
            -- RESET_DEC -> SET_COUNTER -> CHECK_I_VALID_LAST
            I_MCS_ID_RLL_DEC    <= (others => '0');   
            I_VALID_RLL_DEC     <= '0';
            I_DATA_RLL_DEC      <= '0';
            I_CONSUME_RLL_DEC   <= '0';  
            I_LAST_DATA_RLL_DEC <= '0';
            wait for 20 ns;
        end loop;
    end process;
end generate;

end architecture teste;