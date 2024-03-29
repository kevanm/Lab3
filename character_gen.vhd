----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:58:44 05/03/2014 
-- Design Name: 
-- Module Name:    character_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity character_gen is
end character_gen;

architecture Behavioral of character_gen is
	COMPONENT font_rom
		PORT(
			clk : IN std_logic;
			addr: IN std_logic_vector(10 downto 0);
			data: OUT std_logic_vector(7 downto 0)
			);
	END COMPONENT;
	
	COMPONENT char_screen_buffer
		PORT(
			  clk        : in std_logic;
           we         : in std_logic;                     -- write enable
           address_a  : in std_logic_vector(11 downto 0); -- write address, primary read address
           address_b  : in std_logic_vector(11 downto 0); -- dual read address
           data_in    : in std_logic_vector(7 downto 0);  -- data input
           data_out_a : out std_logic_vector(7 downto 0); -- primary data output
           data_out_b : out std_logic_vector(7 downto 0)  -- dual output port
         );
		END COMPONENT;

signal sel, column_sig_1, column_sig_2 : std_logic_vector(2 downto 0);
signal row_sig_1, row_sig_2 : std_logic_vector(3 downto 0);
signal font_connector : std_logic_vector(10 downto 0);
signal output : std_logic;
signal data_from_font, b_data_signal : std_logic_vector(7 downto 0);
signal address_b_12_bit, counter, counter_helper : std_logic_vector(11 downto 0);
signal address_b_signal : std_logic_vector(13 downto 0);

begin
	sel <= column_sig_2(2 downto 0);
	
	process(sel, data_from_font)
	begin
		case sel is
			when "000" => 
				output <= data_from_font(7);
			when "001" =>
				output <= data_from_font(6);
			when "010" =>
				output <= data_from_font(5);
			when "011" =>
				output <= data_from_font(4);
			when "100" =>
				output <= data_from_font(3);
			when "101" =>
				output <= data_from_font(2);
			when "110" =>
				output <= data_from_font(1);				
			when others =>
				output <= data_from_font(0);
				end Behavioral;
		end case;
		
end process;

r <= (others => '1') when output = '1' e;se
								(others => '0');
								
g<= (others => '0');
b<= (others => '0');

font_connector <= b_data_signal(6 downto 0) & row_sig_1;

Inst_font_rom: font_rom PORT MAP(
	clk => clk,
	addr => font_connector,
	data => data_from_fonr
	);
Inst_char_screen_buffer: char_screen_buffer PORT MAP(
			  clk => clk,
           we  => write_en,                     -- write enable
           address_a => counter,
           address_b => address_b_12_bit,
			  data_in => ascii_to_write,
			  data_out_a => open,
           data_out_b => b_data_signal
			 );
address_b_signal <= std_logic_vector(((unsigned(column(10 downto 3))) + unsigned(row(10 downto 4))*80));
address_b_12_bit <= address_b_signal(11 downto 0);


counter_helper <= (others => '0') when reset = '1' else counter;

coutner <= std_logic_vector(unsigned(counter_helper)+1) when rising_edge(write_en) else counter_helper;

process(clk)
	begin
		if(rising_edge(clk)) then 
			row_sig_1 <= row(3 downto 0);
			column_sig_1 <= column(2 downto 0);
			end if;
end process;
	
process(clk)
	begin
			if(rising_edge(clk)) then
				row_sig_1 <= row(3 downto 0);
				column_sig_1 <= column(2 downto 0);
			end if;
end process;

process(clk)
	begin
		if(rising_edge(clk)) then
			column_sig_2 <= column_sig_1(2 downto 0);
		end if;
	end process;

end Behavioral;