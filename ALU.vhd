library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
package Functions_package is
  function multiply(AC : std_logic_vector(15 downto 0); DR : std_logic_vector(15 downto 0)) return std_logic_vector;
  function  SQR  ( d : UNSIGNED ) return UNSIGNED;
end Functions_package;

package body Functions_package is

  function multiply(AC : std_logic_vector(15 downto 0); DR : std_logic_vector(15 downto 0)) return std_logic_vector is
    variable result : std_logic_vector(31 downto 0) := (others => '0');
    variable multiplicand : std_logic_vector(31 downto 0);
    variable multiplier : std_logic_vector(31 downto 0);
    variable negative_ac : std_logic_vector(31 downto 0);
    begin
      multiplicand := AC & "0000000000000000";
      multiplier := "0000000000000000" & DR;
      negative_ac := not multiplicand + 1;  -- two's complement for subtraction

      for i in 0 to 15 loop
        if multiplier(0) = '1' and multiplier(1) = '0' then
          result := result + multiplicand;
        elsif multiplier(0) = '0' and multiplier(1) = '1' then
          result := result + negative_ac;
        end if;
        result := result(0) & result(31 downto 1);  -- shift right logical
        multiplier := multiplier(0) & multiplier(31 downto 1);
      end loop;

      return result(15 downto 0);  -- since we want only lower 16 bits
    end multiply;
	 
	function SQR( d : UNSIGNED ) return UNSIGNED is
		variable a : unsigned(15 downto 0);  --original input.
		variable q : unsigned(7 downto 0):=(others => '0');  --result.
		variable left,right,r : unsigned(9 downto 0):=(others => '0');  --input to adder/sub.r-remainder.
		variable i : integer:=0;
		begin
			a := d;
			for i in 0 to 7 loop
			right := (others => '0');
			right(0):='1';
			right(1):=r(9);
			right(9 downto 2):=q(7 downto 0);
			left := (others => '0');
			left(1 downto 0):=a(15 downto 14);
			left(9 downto 2):=r(7 downto 0);
			a(15 downto 2):=a(13 downto 0);
			a(1 downto 0) := (others => '0');
			if ( r(9) = '1') then
			r := left + right;
			else
			r := left - right;
			end if;
			q(7 downto 1) := q(6 downto 0);
			q(0) := not r(9);
			end loop;
			return q;
		end SQR;

end Functions_package;

use work.Functions_package.all;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ALU is
    Port (
    AC, DR     : in  STD_LOGIC_VECTOR(15 downto 0);  -- 2 inputs 16-bit
    opcode  : in  STD_LOGIC_VECTOR(5 downto 0);  -- 1 input 6-bit for selecting function
    ALU_out   : out  STD_LOGIC_VECTOR(15 downto 0); -- 1 output 16-bit 
    ALU_clk : in std_logic;
    E_out : out std_logic;       -- Carryout flag
	 E_in : in std_logic;
    inc_PC : out std_logic;
	 ALU_needed : in std_logic;
	 done : out std_logic
    );
end ALU; 

architecture Behavioral of ALU is

signal ALU_result : std_logic_vector (15 downto 0);
signal tmp: std_logic_vector (16 downto 0);
signal inc_PC_signal : std_logic;
signal done_signal : std_logic;

begin
   main : process(ALU_clk)
    begin
	  if rising_edge(ALU_clk) then
	  	 inc_PC_signal <= '0';
		 done_signal <= '0';

			if ALU_needed = '1' then 
				case opcode is
					  when "000001" =>
							 -- AND instruction
							 ALU_result <= (AC and DR);
					  when "000010" =>
							 -- Store instruction
							 ALU_result <= AC;
							 tmp <= ('0' & AC) + ('0' & DR); -- OverFlow
					  when "000011" =>
							 -- Load instruction
							 ALU_result <= DR;
							 tmp <= ('0' & AC) + ('0' & DR); -- OverFlow
					  when "000100" =>
							 -- Add instruction
							 ALU_result <= (AC + DR);
							 tmp <= ('0' & AC) + ('0' & DR); -- OverFlow
					  when "000101" =>
							 -- IncrementAC instruction
							 ALU_result <= std_logic_vector( unsigned(AC) + 1 );
							 tmp <= ('0' & AC) + ('0' & DR); -- OverFlow
					  when "000110" =>
							 -- ClearAC instruction
							 ALU_result <= (others => '0');
					  when "000111" =>
							 -- ClearE instruction
							 tmp <= (others => '0');
					  when "001000" =>
							 -- CircularLeftShift instruction
							 ALU_result <= AC(14 downto 0) & AC(15);
					  when "001001" =>
							 -- CircularRightShift instruction
							 ALU_result <= AC(0) & AC(15 downto 1);
					  when "001010" =>
							 -- SPA instruction
							 if AC(15) = '0' then
								inc_PC_signal <= '1';
							 end if;
					  when "001011" =>
							 -- SNA instruction
							 if AC(15) = '1' then
								inc_PC_signal <= '1';
							 end if;
					  when "001100" =>
							 -- SZE instruction
							 if E_in = '0' then
								inc_PC_signal <= '1';
							 end if;
					  when "001101" =>
							 -- SZA instruction
							 if AC = "0000000000000000" then
								inc_PC_signal <= '1';
							 end if;
					  when "001110" =>
							 -- LinearLeftShift instruction
							 ALU_result <= AC(14 downto 0) & '0';
					  when "001111" =>
							 -- LinearRightShift instruction
							 ALU_result <= '0' & AC(15 downto 1);
					  when "010000" =>
							 -- Multiply instruction
							 ALU_result <= std_logic_vector(multiply(AC,DR));
							 tmp <= ('0' & AC) + ('0' & DR); -- OverFlow
					  when "100000" =>
							 -- SquareRoot instruction
							 ALU_result <= "00000000" & std_logic_vector(SQR(unsigned(AC)));
					  when others =>
							 -- Do nothing  
				end case;
	  end if;
	end if;
	done_signal <= '1';
 end process main;
 
 inc_PC <= inc_PC_signal;
 ALU_out <= ALU_result; -- ALU out
 E_out <= tmp(16); -- Carryout flag
 done <= done_signal;
end Behavioral;