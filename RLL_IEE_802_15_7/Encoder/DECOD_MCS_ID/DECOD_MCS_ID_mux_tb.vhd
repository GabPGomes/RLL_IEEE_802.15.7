library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DECOD_MCS_ID is
    port (
        MCS_ID          : in  std_logic_vector(5 downto 0);
        OP_MODE         : out std_logic_vector(2 downto 0);
        VALID_MCS_ID    : out std_logic;
        NO_CODE_MCS_ID  : out std_logic
    );
end entity DECOD_MCS_ID;

architecture estrutural of DECOD_MCS_ID is
  -- tabela para traduzir melhor os modos de operação
  constant M_3MAN     : std_logic_vector(2 downto 0) := "000";
  constant M_4MAN     : std_logic_vector(2 downto 0) := "001";
  constant M_8MAN     : std_logic_vector(2 downto 0) := "010";
  constant M_44B6B    : std_logic_vector(2 downto 0) := "011";
  constant M_84B6B    : std_logic_vector(2 downto 0) := "100";
  constant M_88B10B   : std_logic_vector(2 downto 0) := "101";
  constant M_8NOCODE  : std_logic_vector(2 downto 0) := "110";
  constant M_INVALID  : std_logic_vector(2 downto 0) := "111";
 
--------------------------------------------------------------------------

signal sig_op_mode : std_logic_vector(2 downto 0); 

begin
                -- PHY I
    sig_op_mode	<=  M_4MAN    when MCS_ID = "000000" else
                    M_3MAN    when MCS_ID = "000001" else
                    M_3MAN    when MCS_ID = "000010" else
                    M_4MAN    when MCS_ID = "000011" else
                    M_8MAN    when MCS_ID = "000100" else
                    M_44B6B   when MCS_ID = "000101" else
                    M_44B6B   when MCS_ID = "000110" else
                    M_44B6B   when MCS_ID = "000111" else
                    M_84B6B   when MCS_ID = "001000" else
                    -- PHY II 16 + 
                    M_84B6B   when MCS_ID = "010000" else
                    M_84B6B   when MCS_ID = "010001" else
                    M_84B6B   when MCS_ID = "010010" else
                    M_84B6B   when MCS_ID = "010011" else
                    M_84B6B   when MCS_ID = "010100" else
                    M_88B10B  when MCS_ID = "010101" else
                    M_88B10B  when MCS_ID = "010110" else
                    M_88B10B  when MCS_ID = "010111" else
                    M_88B10B  when MCS_ID = "011000" else
                    M_88B10B  when MCS_ID = "011001" else
                    M_88B10B  when MCS_ID = "011010" else
                    M_88B10B  when MCS_ID = "011011" else
                    M_88B10B  when MCS_ID = "011100" else
                    M_88B10B  when MCS_ID = "011101" else
                    -- PHY III 32 + 
                    M_8NOCODE when MCS_ID = "100000" else
                    M_8NOCODE when MCS_ID = "100001" else
                    M_8NOCODE when MCS_ID = "100010" else
                    M_8NOCODE when MCS_ID = "100011" else
                    M_8NOCODE when MCS_ID = "100100" else
                    M_8NOCODE when MCS_ID = "100101" else
                    M_8NOCODE when MCS_ID = "100110" else
                    M_INVALID;

    OP_MODE         <= sig_op_mode;
    
    VALID_MCS_ID    <= '0' when sig_op_mode = M_INVALID else '1';

    NO_CODE_MCS_ID  <= '1' when MCS_ID(5) = '1' else '0';

                  

    
    
end architecture estrutural;