library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Encoder_FIFO is
	port (
		CLK_FIFO, RST_FIFO	: in std_logic;
		INPUT_FIFO			: in std_logic;
		LOAD_FIFO			: in std_logic;
		READ_FIFO			: in std_logic;
		LAST_BIT_FIFO		: out std_logic;
		OUTPUT_FIFO			: out std_logic
	);
end entity Encoder_FIFO;

architecture estrutural of Encoder_FIFO is
	
	COMPONENT scfifo
	GENERIC (
		add_ram_output_register		: STRING;
		almost_empty_value		: NATURAL;
		intended_device_family		: STRING;
		lpm_numwords		: NATURAL;
		lpm_showahead		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL;
		lpm_widthu		: NATURAL;
		overflow_checking		: STRING;
		underflow_checking		: STRING;
		use_eab		: STRING
	);
	PORT (
			clock	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
			rdreq	: IN STD_LOGIC ;
			sclr	: IN STD_LOGIC ;
			wrreq	: IN STD_LOGIC ;
			almost_empty	: OUT STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
	END COMPONENT;

--------------------------------------------------------------------------------

--signal empty : std_logic;
--signal r_last_empty: std_logic;

begin
	
	scfifo_component : scfifo
	GENERIC MAP (
		add_ram_output_register => "OFF",
		almost_empty_value => 2,
		intended_device_family => "MAX 10",
		lpm_numwords => 16,
		lpm_showahead => "OFF",
		lpm_type => "scfifo",
		lpm_width => 1,
		lpm_widthu => 4,
		overflow_checking => "ON",
		underflow_checking => "ON",
		use_eab => "ON"
	)
	PORT MAP (
		clock	=> CLK_FIFO,
		data(0)	=> INPUT_FIFO,
		rdreq	=> READ_FIFO,
		sclr	=> RST_FIFO,
		wrreq	=> LOAD_FIFO,
		almost_empty	=> LAST_BIT_FIFO,
		q(0)	=> OUTPUT_FIFO
	);	

-----------------------------------------------------------------

-- registrador que so atualiza quando há uma leitura da FIFO

-- reg_last : process(CLK_FIFO)
-- begin
-- 	if(rising_edge(CLK_FIFO))then
-- 		if(RST_FIFO = '1') then
-- 			r_last_empty <= '1'; -- fifo inicia vazia
-- 		else
-- 			if(rdreq = '1') then
-- 				r_last_empty <= empty;
-- 			end if;
-- 		end if;
-- 	end if;
-- end process reg_last;

-- -- so eh o ultimo bit quando acabou de esvaziar : borda de subida de empty
-- LAST_BIT_FIFO <= 	'1' when r_last_empty = '0' and empty = '1' else
-- 					'0';

end architecture estrutural;