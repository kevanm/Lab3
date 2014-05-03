library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;


entity input_to_pulse is
    port ( clk          : in std_logic;
           reset        : in std_logic;
           input        : in std_logic;
           pulse        : out std_logic
         );
end input_to_pulse;

architecture Behavioral of input_to_pulse is
	
	type button_type is
		(idle, press, release);
		
	signal button_reg, button_next : button_type;
	
	signal count, count_next : unsigned(19 downto 0);
	
	signal pulse_reg, pulse_next, button_old, button_new, button_debounced : std_logic;
	
begin

--flippity floppy
	process(clk,reset)
	begin
		if( reset = '1') then
			button_reg <= idle;
		elsif(rising_edge(clk)) then
			button_reg <= button_next;
		end if;
	end process;
	

	process(count, input, button_reg)
	begin
	
	button_next <= button_reg;
	
	case button_reg is
		when idle =>
			if(input = '1') then
				button_next <= '1';
			end if;
		when press =>
			if( count > 55000 and input ='0') then
				button_next <= press;
			end if;
		when release
			button_next <= idle;
	end case;
	
	end process;
	
	pulse <= button_new;
	
	process(clk,reset,button_next, count)
	begin
	
		if( reset = '1') then
			count <= to_unsigned(0,20);	
		elsif( rising_edge(clk)) then
			count <= count_next;
		end if;
		
		if(button_next = press) then
			count_next <= count +1;
		else
			count_next <= to unsigned(0,20);
		end if;		
	end process;			
				
end Behavioral;
				
				
				
				
			
			
