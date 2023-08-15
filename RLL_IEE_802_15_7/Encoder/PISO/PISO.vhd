-- documentaçao completa na pasta IC GabrielG 2021
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


LIBRARY lpm;
USE lpm.all;

entity PISO is
    generic(INPUT_WIDTH : natural 	:= 8;
			DIRECTION   : string 	:= "LEFT"
	);
    port (
        CLK_PISO, RST_PISO  : in std_logic;
        P_IN_PISO   : in std_logic_vector(INPUT_WIDTH-1 downto 0);
        P_LOAD_PISO : in std_logic;
        S_READ_PISO : in std_logic;
        EMPTY_PISO  : out std_logic;
		ALM_EMPTY_PISO  : out std_logic;
        S_OUT_PISO  : out std_logic
    );
end entity PISO;

architecture rtl of PISO is
    
	COMPONENT lpm_shiftreg
	GENERIC (
		lpm_direction		: STRING;
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

signal number_counter : unsigned(7 downto 0);
signal empty_counter, almost_empty_counter    : std_logic;
signal enable_shiftreg, load_shiftreg   : std_logic;

--------------------------------------------------------------------------

begin
    
    LPM_SHIFTREG_component : LPM_SHIFTREG
	GENERIC MAP (
		lpm_direction => DIRECTION,
		lpm_type => "LPM_SHIFTREG",
		lpm_width => INPUT_WIDTH
	)
	PORT MAP (
		clock => CLK_PISO,
		data => P_IN_PISO,
		enable => enable_shiftreg,
		load => load_shiftreg,
		sclr => RST_PISO,
		shiftout => S_OUT_PISO
	);

------------------------------------------------------------------------- 
    
load_shiftreg   <= P_LOAD_PISO;

enable_shiftreg <= (S_READ_PISO and not empty_counter) or P_LOAD_PISO;

-------------------------------------------------------------------------

bit_counter: process(CLK_PISO)
begin
    if rising_edge(CLK_PISO) then
        if RST_PISO = '1' then -- condicao especial de reset
        
            number_counter <= (others => '0');
        
        else
            
            if (P_LOAD_PISO = '1' and empty_counter = '1') then
                number_counter <= to_unsigned(INPUT_WIDTH, 8);
            elsif (S_READ_PISO = '1' and empty_counter /= '1') then
                number_counter <= number_counter - 1;
            end if;

        end if;

    end if;
end process bit_counter;

------------------------------------------------------------------------------

empty_counter   <= '1' when number_counter = to_unsigned(0, 8) else '0';

EMPTY_PISO      <= empty_counter;

almost_empty_counter   <= '1' when number_counter = to_unsigned(1, 8) else '0';

ALM_EMPTY_PISO      <= almost_empty_counter;
------------------------------------------------------------------------------


end architecture rtl;