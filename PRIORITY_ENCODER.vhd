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
