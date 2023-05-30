LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CONTROL_UNIT IS
  PORT (
	CLOCK: in std_logic;
	RESET: in std_logic;
	REVERSE: in std_logic;
	LEFT_CLICK, RIGHT_CLICK: in std_logic;
	IS_LEFT, INC, DEC: out std_logic
    );
END CONTROL_UNIT;


ARCHITECTURE Behavioral OF CONTROL_UNIT IS

BEGIN
	CONTROL_UNIT: process (CLOCK, RESET)
	begin
		if RESET = '0' then
			INC <= '0';
			DEC <= '0';
		elsif rising_edge(CLOCK) then
			INC <= '0';
			DEC <= '0';
			if REVERSE = '0' then
				IS_LEFT <= '1';
				if LEFT_CLICK = '1' then
					INC <= '1';
		
				elsif RIGHT_CLICK = '1' then
					DEC <= '1';
					
				end if;
			else
				IS_LEFT <= '0';
				if LEFT_CLICK = '1' then
					DEC <= '1';
					
				elsif RIGHT_CLICK = '1' then
					INC <= '1';
					
				end if;
				
			end if;
		end if;
	end process;

END Behavioral;
