----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:20:44 03/04/2014 
-- Design Name: 
-- Module Name:    atlys_lab_font_controller - Behavioral 
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

entity atlys_lab_font_controller is
	port(
			clk	: in std_logic;
			reset : in std_logic;
			start : in std_logic;
			switch: in std_logic(7 downto 0);
			led	: out std_logic(7 downto 0);
			tmds	: out std_logic(3 downto 0);
			tmdsb	: out std_logic(3 downto 0);
		);
end atlys_lab_font_controller;

architecture Behavioral of atlys_lab_font_controller is

	COMPONENT character_gen
		 port ( clk            : in std_logic;
				  blank          : in std_logic;
				  reset			  : in std_logic;
              row            : in std_logic_vector(10 downto 0);
				  column         : in std_logic_vector(10 downto 0);
              ascii_to_write : in std_logic_vector(7 downto 0);
              write_en       : in std_logic;
              r,g,b          : out std_logic_vector(7 downto 0)
         );
	END COMPONENT;
	
	COMPONENT vga_sync
		 port ( clk            : in std_logic;
				  reset          : in std_logic;
              h_sync         : out std_logic;
				  v_sync         : out std_logic;
              v_completed    : out std_logic;
              blank          : out std_logic;
				  row				  : out unsigned(10 downto 0);
              column         : out unsigned(10 downto 0)
         );
		END COMPONENT;
	
	COMPONENT input_to_pulse
		port(
				clk : in std_logic;
				reset : in std_logic;
				input : in std_logic;
				pulse : out std_logic
			);
	END COMPONENT;

	
	signal row_connector, column_connector : unsigned(10 downto 0);
	signal red_sig, blue_sig, green_sig: std_logic_vector(7 downto 0);
	signal h_sync_sig, h_sync_sig2, v_sync_sig, v_sync_sig2, blank1, blank2 : std_logic;
	signal button, pixel_clk, h_sync, v_sync, blank, v_comp : std_logic;
	
begin

	inst_DCM_pixel: DCM
	generic map(
						CLKFX_MULTIPLY => 2,
						CLKFX_DIVIDE => 8,
						CLK_FEEDBACK =>"1X"
					)
	port map(
					clkin => clk,
					rst => reset,
					clkfx => pixel_clk
				);
				
	inst_DCM_serialize: DCM
	generic map(
						CLKFX_MULTIPLY => 10,
						CLKFX_DIVIDE => 8,
						CLK_FEEDBACK =>"1X"
					)
	port map(
					clkin => clk,
					rst => reset,
					clkfx => pixel_clk
				);
	
	Inst_character_gen: character_gen PORT MAP(
		clk => pixel_clk,
		blank => blank_sig_2,
		reset => reset,
		row => std_logic_vector(row_connector),
		column => std_logic_vector(column_connector),
		ascii_to_write => switch,
		write_en => enable_connector,
		r => red_sig,
		g => green_sig,
		b => blue_sig
		);
	
	Inst_vga_sync: vga_sync PORT MAP(
		clk => pixel_clk,
		reset => reset,
		h_sync => h_sync_sig,
		v_sync => v_sync_sig,
		v_completed => open,
		blank => blank_sig,
		row => row_connector,
		column => column_connector
		);
	
	Inst_input_to_pulse: input_to_pulse PORT MAP(
		clk => pixel_clk,
		reset => reset,
		input => start,
		pulse => enable_connector
		);
	
	inst_dvid: entity work.dvid
    port map(
          clk => serialize_clk,
          clk_n => serialize_clk_n,
          clk_pixel => pixel_clk,
          red_p => red_sig,
          green_p => green_sig,
          blue_p => blue_sig,
          blank => blank_sig_2,
          hsync => h_sync_sig_2,
          vsync => v_sync_sig_2,
           -- outputs to TMDS drivers
          red_s => red_s,
          green_s => green_s,
          blue_s => blue_s,
          clock_s => clock_s
           );
	
	 OBUFDS_blue : OBUFDS port map
        ( O => TMDS(0), OB => TMDSB(0), I => blue_s );
    OBUFDS_red : OBUFDS port map
        ( O => TMDS(1), OB => TMDSB(1), I => green_s );
    OBUFDS_green : OBUFDS port map
        ( O => TMDS(2), OB => TMDSB(2), I => red_s );
    OBUFDS_clock : OBUFDS port map
        ( O => TMDS(3), OB => TMDSB(3), I => clock_s );

	process(pixel_clk)
		begin
			if(rising_edge(pixel_clk)) then
				blank_sig_1 <= blank_sig;
				h_sync_sig_1 <= h_sync_sig;
				v_sync_sig_1  v_sync_sig;
			end if;
	end process;		
	
	process(pixel_clk)
		begin
			if(rising_edge(pixel_clk)) then
				blank_sig_2 <= blank_sig_1;
				h_sync_sig_2 <= h_sync_sig_1;
				v_sync_sig_2  v_sync_sig_1;
			end if;
	end process;
end Behavioral;

