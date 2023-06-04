library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity RAM is
	port(
		address: in std_logic_vector(9 downto 0); 
		data_in: in std_logic_vector(15 downto 0);
		write_in: in std_logic; 
		RAM_clk: in std_logic; 
		data_out: out std_logic_vector(15 downto 0);
		RAM_needed: in std_logic;
		done : out std_logic
	);
end RAM;

architecture Memory of RAM is
	type RAM_Array is array (0 to 1023 ) of std_logic_vector (15 downto 0);
	signal RAM_data: RAM_Array := (others => "0000000000000000");
	signal done_signal : std_logic;
	

begin
	main : process (RAM_clk)
	begin 
	done_signal <= '0';
	if rising_edge(RAM_clk) then
		if RAM_needed = '1' then
				if(write_in = '1') then 
					RAM_data(to_integer(unsigned(address))) <= data_in;
				else
					data_out <= RAM_data(to_integer(unsigned(address)));
				end if;
		end if;
	end if;
	done_signal <= '1';
	end process main;
	done <= done_signal;
end architecture Memory;
