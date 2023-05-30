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
