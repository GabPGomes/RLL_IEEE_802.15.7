library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

LIBRARY lpm;
USE lpm.all;

entity SIPO is
    generic(OUTPUT_WIDTH   	: natural 	:= 8;
			DIRECTION 		: string	:= "RIGHT"
	);
    port (
            CLK_SIPO, RST_SIPO 	: in std_logic;
            S_IN_SIPO   		:   in std_logic;
            S_LOAD_SIPO 		:   in std_logic;
            P_READ_SIPO 		:   in std_logic;
            P_OUT_SIPO  		:   out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
			ALM_FULL_SIPO   	:   out std_logic;
            FULL_SIPO   		:   out std_logic
    );
end entity SIPO;

architecture comportamental of SIPO is
  
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
			q	: OUT STD_LOGIC_VECTOR (OUTPUT_WIDTH-1 DOWNTO 0)
	);
	END COMPONENT;

---------------------------------------------------------------------------------

    signal number_counter  : unsigned(7 downto 0);
	signal full_counter, almost_full_counter : std_logic;
    signal enable_shiftreg : std_logic;

----------------------------------------------------------------------------------

begin
    
    LPM_SHIFTREG_component : LPM_SHIFTREG
	GENERIC MAP (
		lpm_direction => DIRECTION,
		lpm_type => "LPM_SHIFTREG",
		lpm_width => OUTPUT_WIDTH
	)
	PORT MAP (
		clock => CLK_SIPO,
		enable => enable_shiftreg,
		sclr => RST_SIPO,
		shiftin => S_IN_SIPO,
		q => P_OUT_SIPO
	); 

----------------------------------------------------------------------------------------

enable_shiftreg <= S_LOAD_SIPO and not full_counter;

----------------------------------------------------------------------------------------

bit_counter : process(CLK_SIPO)
begin
    if rising_edge(CLK_SIPO) then
        if RST_SIPO = '1' or (full_counter = '1' and P_READ_SIPO = '1') then
            number_counter <= (others => '0');
        else
            if(S_LOAD_SIPO = '1' and full_counter /= '1') then
                number_counter <= number_counter + 1;
            end if;
        end if;
    end if;
end process bit_counter;

-------------------------------------------------------------------------------------------

full_counter <= '1' when number_counter = to_unsigned(OUTPUT_WIDTH, 8) else '0';
FULL_SIPO <= full_counter;

almost_full_counter <= '1' when number_counter = to_unsigned(OUTPUT_WIDTH - 1, 8) else '0';
ALM_FULL_SIPO <= almost_full_counter;

end architecture comportamental;