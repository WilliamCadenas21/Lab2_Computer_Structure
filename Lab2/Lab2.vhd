library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-----------------------------------------------------

entity lab2 is
port(	

--inputs
clock:	in std_logic;

reset:	in std_logic;
velocity:	in std_logic;
ps2_clk    : IN  STD_LOGIC;                     --clock signal from PS2 keyboard
  ps2_data   : IN  STD_LOGIC;                     --data signal from PS2 keyboard


--outputs
display_right : out  STD_LOGIC_VECTOR (0 to 6);
display_left : out  STD_LOGIC_VECTOR (0 to 6); 
led1: out STD_LOGIC;
led2: out STD_LOGIC


);
end lab2;

-----------------------------------------------------

architecture FSM of lab2 is

	signal clockTimer: integer:= 0; --2hz 
	signal count: integer := 0;
	signal r1: std_logic_vector(3 downto 0);
	signal l1: std_logic_vector(3 downto 0); 
	signal ps2_array : STD_LOGIC_VECTOR(10 DOWNTO 0);
	
	function show (vector : std_logic_vector(3 downto 0))
	return std_logic_vector is
	variable output :std_logic_vector(6 downto 0);
	
	begin
			case vector is
				when "0000" => output := "0000001";--0
				when "0001" => output := "1001111";--1
				when "0010" => output := "0010010";--2
				when "0011" => output := "0000110";--3
				when "0100" => output := "1001100";--4
				when "0101" => output := "0100100";--5	
				when "0110" => output := "0100000";--6	
				when "0111" => output := "0001111";--7	
				when "1000" => output := "0000000";--8
				when "1001" => output := "0001100";--9
				when "1010" => output := "0001000";--A
				when "1011" => output := "1100000";--b
				when "1100" => output := "0110001";--c
				when "1101" => output := "1000010";--d	
				when "1110" => output := "0110000";--e	
				when others => output := "0111000";--f	--"1111"
			end case;
			return output;
	end;
	
begin
-- this process verify the number of the count
process(ps2_clk) 

begin
	if(ps2_clk'EVENT and ps2_clk='0') then

		ps2_array(count) <= ps2_data;

		if(count < 10)then
			count <= count + 1;
			
			else
			--mostrar hexadecimal
			display_right <= show(ps2_array(8 downto 5));
			display_left <= show(ps2_array(4 downto 1));
--			l1(0) <= ps2_array(1);
--			l1(1) <= ps2_array(2);
--			l1(2) <= ps2_array(3);
--			l1(3) <= ps2_array(4);
			
--			r1(0) <= ps2_array(5);
--			r1(1) <= ps2_array(6);
--			r1(2) <= ps2_array(7);
--			r1(3) <= ps2_array(8);

			count <= 0;
			end if;
		end if;
end process;	 


end FSM;