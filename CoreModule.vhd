library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
    Port ( clk : in std_logic;
           reset : in std_logic;
			  FSM_done : out std_logic
    );
end FSM;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

architecture Behavioral of FSM is

    --Signals
    type state_type is (Fetch, Decode, read_signal, Execute);
    signal state : state_type:= Fetch;
    signal AC : std_logic_vector (15 downto 0):= (others => '0');
    signal DR : std_logic_vector (15 downto 0):= (others => '0');
    signal IR : std_logic_vector (15 downto 0):= (others => '0');
    signal E : std_logic:= '0';
    signal PC : std_logic_vector (9 downto 0):= (others => '0');
    signal opcode  : STD_LOGIC_VECTOR(5 downto 0):= (others => '0');
    signal address: std_logic_vector(9 downto 0):= (others => '0');
    signal write_in: std_logic:= '0';
    signal ALU_clk :  std_logic:= '0';
	 signal RAM_clk : std_logic:= '0';
	 signal ROM_clk : std_logic:= '0';
	 signal inc_PC : std_logic:= '0';
	 signal init_start : std_logic:= '1';
	 signal ALU_done : std_logic:= '0';
	 signal RAM_done : std_logic:= '0';
	 signal ROM_done : std_logic:= '0';
	 signal ALU_needed : std_logic:= '0';
	 signal RAM_needed : std_logic:= '0';
	 signal ROM_needed : std_logic:= '0';

	 
    
    -- Components
    component ALU is
        Port (
			 AC, DR     : in  STD_LOGIC_VECTOR(15 downto 0);  -- 2 inputs 16-bit
			 opcode  : in  STD_LOGIC_VECTOR(5 downto 0);  -- 1 input 6-bit for selecting function
			 ALU_clk : in std_logic;
			 ALU_out   : out  STD_LOGIC_VECTOR(15 downto 0); -- 1 output 16-bit 
			 E_out : out std_logic;       -- Carryout flag
			 E_in : in std_logic;
			 inc_PC : out std_logic;
			 ALU_needed : in std_logic;
			 done : out std_logic
			 );
    end component;

    component RAM is
			port(
				address: in std_logic_vector(9 downto 0); 
				data_in: in std_logic_vector(15 downto 0);
				write_in: in std_logic; 
				RAM_clk: in std_logic; 
				data_out: out std_logic_vector(15 downto 0);
				RAM_needed : in std_logic;
				done : out std_logic

			);
    end component;

    component ROM is
			 port(
				  ROM_clk : in std_logic;   -- renamed from ROM_exe
				  address : in  std_logic_vector(9 downto 0);
				  inst_out    : out std_logic_vector(15 downto 0);
				  ROM_needed : in std_logic;
				  done : out std_logic

			 );
    end component;
    
    -- Signals for components:

begin

    -- Port Maps
    Instance_ALU: ALU port map(
        AC => AC,
        DR => DR,
        opcode => opcode,
		  ALU_clk => clk,
        ALU_out => AC,
        E_in => E,
		  E_out => E,
		  inc_PC => inc_PC,
		  ALU_needed => ALU_needed,
		  done => ALU_done
    );

    Instance_RAM: RAM port map(
        address => address,
        data_in => AC,
        write_in => write_in,
        RAM_clk => clk,
        data_out => DR,
		  RAM_needed => RAM_needed,
		  done => RAM_done
    );

    Instance_ROM: ROM port map(
        address => PC,
		  ROM_clk => clk,
        inst_out =>IR,
		  ROM_needed => ROM_needed,
		  done => ROM_done
    );

    process (clk, reset)
    begin
        if reset = '1' then
            state <= Fetch;
            PC <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when Fetch =>
                    -- Fetch code
                    -- Replace the comment with Fetch code
						  if init_start = '1' then
							  PC <= std_logic_vector(unsigned(PC) + 1);
							  ROM_needed <= '1';
							  init_start <= '0';
						  end if;
						  
						  if ROM_done = '1' then	
							  state <= Decode;
							  init_start <= '1';
							  ROM_needed <= '0';
						  end if;
						  
                when Decode =>
                    -- Decode code
                    -- Replace the comment with Decode code
						  
                    opcode <= IR(15 downto 10);
                    address <= IR(9 downto 0);
						  
						  state <= read_signal;
                when read_signal =>
                    -- Read code
                    -- Replace the comment with Read code
						  if init_start = '1' then
							  if opcode = "000010" then -- Store instrucion
                        write_in <= '1';
							  end if;
							  
							  if address /= "0000000000" then
									RAM_needed <= '1';
							  end if;
							  init_start <= '0';
						  end if;
						  
						  if RAM_done = '1' then	
							  state <= Execute;
							  init_start <= '1';
							  RAM_needed <= '0';
							  write_in <= '0';
						  end if;  
                when Execute =>
                    -- Execute code
                    -- Replace the comment with Execute code
						  if init_start = '1' then
							  ALU_needed <= '1';
							  init_start <= '0';
						  end if;
						  
						  if ALU_done = '1' then	
							  if inc_PC = '1' then
									PC <= std_logic_vector(unsigned(PC) + 1);
							  end if;

							  state <= Fetch;
							  init_start <= '1';
							  ALU_needed <= '0';
						  end if;
            end case;
        end if;
		  FSM_done <= '1';
    end process;
end Behavioral;