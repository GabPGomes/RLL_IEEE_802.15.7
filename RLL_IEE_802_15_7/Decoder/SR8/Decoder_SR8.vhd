-- documentaçao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


LIBRARY lpm;
USE lpm.all;

entity Decoder_SR8 is
    port (
        CLK_SR8, RST_SR8  : in std_logic;
        S_IN_SR8   : in std_logic;
        S_LOAD_SR8 : in std_logic;
        P_OUT_SR8  : out std_logic_vector(7 downto 0)
    );
end entity Decoder_SR8;

architecture rtl of Decoder_SR8 is
    
    COMPONENT lpm_shiftreg
	GENERIC (
		lpm_direction		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL
	);
	PORT (
			clock	: IN STD_LOGIC ;
			enable	: IN STD_LOGIC ;
			sclr	: IN STD_LOGIC ;
			shiftin	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;

--------------------------------------------------------------------------

--------------------------------------------------------------------------

begin

    LPM_SHIFTREG_component : LPM_SHIFTREG
	GENERIC MAP (
		lpm_direction => "LEFT",
		lpm_type => "LPM_SHIFTREG",
		lpm_width => 8
	)
	PORT MAP (
		clock => CLK_SR8,
		enable => S_LOAD_SR8,
		sclr => RST_SR8,
		shiftin => S_IN_SR8,
		q => P_OUT_SR8 
	);

------------------------------------------------------------------------------

end architecture rtl;