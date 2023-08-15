-- documentaçao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


LIBRARY lpm;
USE lpm.all;

entity Encoder_SR8 is
    port (
        CLK_SR8, RST_SR8  : in std_logic;
        P_IN_SR8   : in std_logic_vector(7 downto 0);
        P_LOAD_SR8 : in std_logic;
        S_READ_SR8 : in std_logic;
        S_OUT_SR8  : out std_logic
    );
end entity Encoder_SR8;

architecture rtl of Encoder_SR8 is
    
	COMPONENT lpm_shiftreg
	GENERIC (
		lpm_direction	: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL
	);
	PORT (
			clock	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			enable	: IN STD_LOGIC ;
			load	: IN STD_LOGIC ;
			sclr	: IN STD_LOGIC ;
			shiftout	: OUT STD_LOGIC 
	);
	END COMPONENT;

--------------------------------------------------------------------------

signal enable_shiftreg, load_shiftreg   : std_logic;

--------------------------------------------------------------------------

begin
    
    LPM_SHIFTREG_component : LPM_SHIFTREG
	GENERIC MAP (
		lpm_direction => "RIGHT",
		lpm_type => "LPM_SHIFTREG",
		lpm_width => 8
	)
	PORT MAP (
		clock => CLK_SR8,
		data => P_IN_SR8,
		enable => enable_shiftreg,
		load => load_shiftreg,
		sclr => RST_SR8,
		shiftout => S_OUT_SR8
	);

------------------------------------------------------------------------- 
    
load_shiftreg   <= P_LOAD_SR8 and not S_READ_SR8; -- so carrega se nao estiver lendo

enable_shiftreg <= S_READ_SR8 or P_LOAD_SR8;

------------------------------------------------------------------------------

end architecture rtl;