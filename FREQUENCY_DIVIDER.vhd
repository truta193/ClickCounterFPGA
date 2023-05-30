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
		CLK_DIVIDED <= nr(15);
	end process;

END Behavioral;
