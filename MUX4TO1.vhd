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
