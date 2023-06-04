library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity ROM is
    port(
        ROM_clk : in std_logic;   -- renamed from ROM_exe
        address : in  std_logic_vector(9 downto 0);
        inst_out    : out std_logic_vector(15 downto 0);
		  ROM_needed : in std_logic;
		  done : out std_logic
    );
end entity ROM;

architecture Instructions of ROM is
    type ROM_Inst_List is array (0 to 1023) of std_logic_vector(15 downto 0);
    constant our_ROM : ROM_Inst_List := ( others => "0000000000000000");
	 signal done_signal : std_logic:= '0';
     -- Instructions goes here
     -- like "opcode/address"
     -- Exp: "0000010000000001"
begin
    main : process(ROM_clk)   -- changed from ROM_exe
    begin
	 	  done_signal <= '0';
        if rising_edge(ROM_clk) then   -- used a clock here
				if ROM_needed = '1' then
					inst_out <= our_ROM(to_integer(unsigned(address)));
				end if;
        end if;
		  done_signal <= '1';
    end process main;
	 done <= done_signal;
end architecture Instructions;
