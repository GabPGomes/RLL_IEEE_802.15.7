library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Encoder_DECOD_MCS_ID is -- RLL Encoder component
    port (
        MCS_ID          : in  std_logic_vector(5 downto 0);
        OP_MODE         : out std_logic_vector(2 downto 0);
        VALID_MCS_ID    : out std_logic;
        NO_CODE_MCS_ID  : out std_logic 
    );
end entity Encoder_DECOD_MCS_ID;

architecture estrutural of Encoder_DECOD_MCS_ID is
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
    
    decod: process(MCS_ID)
    begin
        case MCS_ID is
            -- PHY I
            when "000000"   =>  sig_op_mode	<=  M_4MAN;
            when "000001"   =>  sig_op_mode	<=  M_3MAN;
            when "000010"   =>  sig_op_mode	<=  M_3MAN;
            when "000011"   =>  sig_op_mode	<=  M_4MAN;
            when "000100"   =>  sig_op_mode	<=  M_8MAN;
            when "000101"   =>  sig_op_mode	<=  M_44B6B;
            when "000110"   =>  sig_op_mode	<=  M_44B6B;
            when "000111"   =>  sig_op_mode	<=  M_44B6B;
            when "001000"   =>  sig_op_mode	<=  M_84B6B;
            -- PHY II
            when "010000"   =>  sig_op_mode <=  M_84B6B;        
            when "010001"   =>  sig_op_mode <=  M_84B6B;
            when "010010"   =>  sig_op_mode <=  M_84B6B;
            when "010011"   =>  sig_op_mode <=  M_84B6B;
            when "010100"   =>  sig_op_mode <=  M_84B6B;
            when "010101"   =>  sig_op_mode <=  M_88B10B;
            when "010110"   =>  sig_op_mode <=  M_88B10B;
            when "010111"   =>  sig_op_mode <=  M_88B10B;
            when "011000"   =>  sig_op_mode <=  M_88B10B;
            when "011001"   =>  sig_op_mode <=  M_88B10B;
            when "011010"   =>  sig_op_mode <=  M_88B10B;
            when "011011"   =>  sig_op_mode <=  M_88B10B;
            when "011100"   =>  sig_op_mode <=  M_88B10B;
            when "011101"   =>  sig_op_mode <=  M_88B10B;
            -- PHY III
            when "100000"  =>  sig_op_mode <= M_8NOCODE;
            when "100001"  =>  sig_op_mode <= M_8NOCODE;
            when "100010"  =>  sig_op_mode <= M_8NOCODE;
            when "100011"  =>  sig_op_mode <= M_8NOCODE;
            when "100100"  =>  sig_op_mode <= M_8NOCODE;
            when "100101"  =>  sig_op_mode <= M_8NOCODE;
            when "100110"  =>  sig_op_mode <= M_8NOCODE;
            when others => sig_op_mode <= M_INVALID;
        end case;
    end process;
    
    OP_MODE         <= sig_op_mode;
    
    VALID_MCS_ID    <= '0' when sig_op_mode = M_INVALID else '1';

    NO_CODE_MCS_ID  <= '1' when MCS_ID(5) = '1' else '0';
    
end architecture estrutural;