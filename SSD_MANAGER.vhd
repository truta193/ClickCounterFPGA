LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SSD_MANAGER IS
  PORT (
  	CLOCK: in std_logic;
  	RESET: in std_logic;
	NUMBER: in std_logic_vector(15 downto 0);
	ANODES: out std_logic_vector(3 downto 0);
	CATODES: out std_logic_vector(6 downto 0)
    );
END SSD_MANAGER;


ARCHITECTURE Structural OF SSD_MANAGER IS
	COMPONENT FREQUENCY_DIVIDER IS
	  PORT (
	  	CLOCK_100: in std_logic;
	  	RESET: in std_logic;
	  	CLK_DIVIDED: out std_logic
		);
	END component;

	component RING_SHIFTER IS
	  PORT (
		CLOCK: in std_logic;
		RESET: in std_logic;
		OUTPUT: out std_logic_vector(3 downto 0)
	    );
	END component;

	component PRIORITY_ENCODER IS
		  PORT (
			INPUT: in std_logic_vector(3 downto 0);
			OUTPUT: out std_logic_vector(1 downto 0)
		    );
	END component;

	component DIGIT_SPLITTER IS
	  PORT (
		NUMBER: in std_logic_vector(15 downto 0);
		D1, D2, D3, D4: out std_logic_vector(3 downto 0)
	    );
	END component;

	component MUX4TO1 IS
	  PORT (
		INPUT1: in std_logic_vector(3 downto 0);
		INPUT2: in std_logic_vector(3 downto 0);
		INPUT3: in std_logic_vector(3 downto 0);
		INPUT4: in std_logic_vector(3 downto 0);
		SELECTION: in std_logic_vector(1 downto 0);
		OUTPUT: out std_logic_vector(3 downto 0)
	    );
	END component;

	component BCD7SGT IS
	  PORT (
	  	INPUT: in std_logic_vector(3 downto 0);
	  	OUTPUT: out std_logic_vector(6 downto 0)
	    );
	END component;

	signal CLOCK_DIVIDED: std_logic;
	signal ANODES_SIGNAL: std_logic_vector(3 downto 0);
	signal ANODE_SELECT: std_logic_vector(1 downto 0);
	signal DIGIT_SELECT: std_logic_vector(3 downto 0);
	signal DIGIT1, DIGIT2, DIGIT3, DIGIT4: std_logic_vector(3 downto 0);

BEGIN

FREQ_DIV: FREQUENCY_DIVIDER port map(CLOCK, RESET, CLOCK_DIVIDED);
RING_SHIFT: RING_SHIFTER port map(CLOCK_DIVIDED, RESET, ANODES_SIGNAL);
ANODES <= ANODES_SIGNAL;
PRIORITY_ENC: PRIORITY_ENCODER port map(ANODES_SIGNAL, ANODE_SELECT);
DIGIT_SPLT: DIGIT_SPLITTER port map(NUMBER, DIGIT1, DIGIT2, DIGIT3, DIGIT4);
MUX: MUX4TO1 port map(DIGIT1, DIGIT2, DIGIT3, DIGIT4, ANODE_SELECT, DIGIT_SELECT);
DIGIT_DEC: BCD7SGT port map(DIGIT_SELECT, CATODES);
END Structural;


-------------------------------------------------------
------------------ FREQUENCY DIVIDER ------------------
-------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY FREQUENCY_DIVIDER IS
  PORT (
  	CLOCK_100: in std_logic;
  	RESET: in std_logic;
  	CLK_DIVIDED: out std_logic
	);
END FREQUENCY_DIVIDER;


ARCHITECTURE Behavioral OF FREQUENCY_DIVIDER IS

BEGIN

	process(CLOCK_100)
	variable nr: std_logic_vector (15 downto 0) := (others => '0');
	begin
		if RESET = '0' then
			nr := (others => '0');
		elsif rising_edge(CLOCK_100) then
			nr := nr + 1;
		end if;
		--CHANGE TO 15
		CLK_DIVIDED <= nr(15);
	end process;

END Behavioral;


-------------------------------------------------------
--------------------- RING SHIFTER --------------------
-------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY RING_SHIFTER IS
  PORT (
	CLOCK: in std_logic;
	RESET: in std_logic;
	OUTPUT: out std_logic_vector(3 downto 0)
    );
END RING_SHIFTER;

ARCHITECTURE TypeArchitecture OF RING_SHIFTER IS
	signal CONTENT: std_logic_vector(3 downto 0) := "0001";
BEGIN

	CLOCK_SIGNAL: process (CLOCK)
	begin
		
		if RESET = '0' then
			CONTENT <= "0001";
		elsif rising_edge(CLOCK) then
			CONTENT <= CONTENT(0) & CONTENT(3 downto 1);
		end if;

		OUTPUT <= CONTENT;

	end process;

END TypeArchitecture;




-------------------------------------------------------
------------------- PROPRITY ENCODER ------------------
-------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY PRIORITY_ENCODER IS
  PORT (
	INPUT: in std_logic_vector(3 downto 0);
	OUTPUT: out std_logic_vector(1 downto 0)
    );
END PRIORITY_ENCODER;

ARCHITECTURE Behavioral OF PRIORITY_ENCODER IS

BEGIN

	OUTPUT <= "11" when INPUT(3) = '1' else
			"10" when INPUT(3 downto 2) = "01" else
			"01" when INPUT(3 downto 1) = "001" else
			"00" when INPUT(3 downto 0) = "0001";

END Behavioral;


-------------------------------------------------------
------------------- DIGIT_SPLITTER --------------------
-------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY DIGIT_SPLITTER IS
  PORT (
	NUMBER: in std_logic_vector(15 downto 0);
	D1, D2, D3, D4: out std_logic_vector(3 downto 0)
    );
END DIGIT_SPLITTER;


ARCHITECTURE Behavioral OF DIGIT_SPLITTER IS

BEGIN
	SPLIT: process(NUMBER) 
	variable DECIMAL : integer := 0;
	variable N: integer := 0;
	begin
		N := conv_integer(NUMBER);
		DECIMAL := N rem 10;
		D1 <= std_logic_vector(to_unsigned(DECIMAL, 4));
		N := N / 10;
		DECIMAL := N rem 10;
		D2 <= std_logic_vector(to_unsigned(DECIMAL, 4));
		N := N / 10;
		DECIMAL := N rem 10;
		D3 <= std_logic_vector(to_unsigned(DECIMAL, 4));
		N := N / 10;
		DECIMAL := N rem 10;
		D4 <= std_logic_vector(to_unsigned(DECIMAL, 4));
	end process;

END Behavioral;


-------------------------------------------------------
------------------ MUX 4 TO 1 4BIT --------------------
-------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY MUX4TO1 IS
  PORT (
	INPUT1: in std_logic_vector(3 downto 0);
	INPUT2: in std_logic_vector(3 downto 0);
	INPUT3: in std_logic_vector(3 downto 0);
	INPUT4: in std_logic_vector(3 downto 0);
	SELECTION: in std_logic_vector(1 downto 0);
	OUTPUT: out std_logic_vector(3 downto 0)
    );
END MUX4TO1;

ARCHITECTURE Behavioral OF MUX4TO1 IS
BEGIN

	OUTPUT <= INPUT1 when SELECTION = "00" else
		INPUT2 when SELECTION = "01" else
	 	INPUT3 when SELECTION = "10" else 
	 	INPUT4 when SELECTION = "11";

END Behavioral;



-------------------------------------------------------
------------------- BCD TO 7 SEGMENT ------------------
-------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY BCD7SGT IS
  PORT (
  	INPUT: in std_logic_vector(3 downto 0);
  	OUTPUT: out std_logic_vector(6 downto 0)
    );
END BCD7SGT;


ARCHITECTURE Behavioral OF BCD7SGT IS

BEGIN
	with INPUT select OUTPUT <=
		"1111110" when "0000",
		"0110000" when "0001",
		"1101101" when "0010",
		"1111001" when "0011",
		"0110011" when "0100",
		"1011011" when "0101",
		"1011111" when "0110",
		"1110000" when "0111",
		"1111111" when "1000",
		"1111011" when "1001",
		"1110111" when "1010",
		"0011111" when "1011",
		"1001110" when "1100",
		"0111101" when "1101",
		"1001111" when "1110",
		"1000111" when "1111",
		"0000000" when others;
END Behavioral;


