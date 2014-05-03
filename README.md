#Lab3
====

##Font Controller
Using VHDL to create a font controller that allows a character to be writen to a 30x80 char grid. A user can scroll through chars with a switch and a button. The VHDL code uses a top level module that instantiates other modules. 

#Implementation


- This lab used D flip flops for states (current and next) as well as for the buffers.
  - Example of a Flip Flop in VHDL
``` VHDL
-- state register
	process(clk, reset)
	begin
		if (reset = '1') then
			state <= idle;
		elsif(rising_edge(clk)) then
			state <= state_next;
		end if;
	end process;
```

# `atlys_lab_font_controller`
The top level module. This instantias vga_sync, dvid, pixel_gen, input_to_pulse, and character_gen.

# `vga_sync`
This connects v_sync and h_sync. It instantiates both of them.

# `v_sync_gen`
This generates the vertical signals. It cycles throught the 5 states that are in the state diagram. It uses three flip flops for next state logic, count logic and reset logic.

# `h_sync_gen`
This generates the horizontal signals. It cycles throught the 5 states that are in the state diagram. It uses three flip flops for next state logic, count logic and reset logic.

# `character_gen`
This assigns RGB to different values to display different colors. The higher the value, the higher the intensity.
This determines which pixels are colored in based off of the letter with font_rom.

# `font_rom`
This contains the information of which columns and rows are used by which characters.
Basically, all of the specific information of how to generate each character.

# `input_to_pulse`
This debounces the buttons. The button cycles through three different states: idle, press, and release.

# Testing and Debugging
- BE CAREFUL WITH SIGNALS!!! ALWAYS PAY ATTENTION AND MATCH UP THE CORRECT SIGNALS!!


# Conclusion
- This lab was useful in learning something completely different than anything I had done before and how to figure out how to wire things up more so than any other lab before this.
- This lab also taught that sometimes delays are necessary to sync different signals up

