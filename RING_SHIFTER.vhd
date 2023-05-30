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
	CLOCK_SIGNAL: process (CLOCK, RESET)
	begin
		if RESET = '0' then
			CONTENT <= "0001";
		elsif rising_edge(CLOCK) then
			CONTENT <= CONTENT(0) & CONTENT(3 downto 1);
		end if;
		OUTPUT <= CONTENT;

	end process;

END TypeArchitecture;
