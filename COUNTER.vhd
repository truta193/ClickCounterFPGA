LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY COUNTER IS
  PORT (
  	CLOCK: in std_logic;
  	RESET: in std_logic;
  	INCREMENT, DECREMENT: in std_logic;
  	OUTNUMBER: out std_logic_vector(15 downto 0)
    );
END COUNTER;



ARCHITECTURE Behavioral OF COUNTER IS
signal NUMBER: std_logic_vector(15 downto 0) := (others => '0');
BEGIN
	CLOCK_ACTIVE: process (CLOCK, RESET)
	begin
		if RESET = '0' then
			NUMBER <= (others => '0');
		elsif rising_edge(CLOCK) then
			if INCREMENT = '1' then
				if NUMBER < 9999 then
					NUMBER <= NUMBER + 1;
				else
					NUMBER <= "0010011100001111"; --9999
				end if;
			elsif DECREMENT = '1' then
				if NUMBER > 0 then
					NUMBER <= NUMBER - 1;
				else 
					NUMBER <= (others => '0');
				end if;
			end if;
		end if;
		OUTNUMBER <= NUMBER;
	end process;

END Behavioral;
