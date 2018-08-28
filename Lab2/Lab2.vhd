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

begin

-- this process verify the number of the count
process(clock,ps2_clk) 

begin
	if(ps2_clk'EVENT and ps2_clk='1') then

		ps2_array(count) <= ps2_data;

		if(count = 10)then
			--mostrar hexadecimal
			l1(0) <= ps2_array(1);
			l1(1) <= ps2_array(2);
			l1(2) <= ps2_array(3);
			l1(3) <= ps2_array(4);
			
			r1(0) <= ps2_array(5);
			r1(1) <= ps2_array(6);
			r1(2) <= ps2_array(7);
			r1(3) <= ps2_array(8);


			case r1 is
				when "0000" => display_right <= "0000001";--0
				when "0001" => display_right <= "1001111";--1
				when "0010" => display_right <= "0010010";--2
				when "0011" => display_right <= "0000110";--3
				when "0100" => display_right <= "1001100";--4
				when "0101" => display_right <= "0100100";--5	
				when "0110" => display_right <= "0100000";--6	
				when "0111" => display_right <= "0001111";--7	
				when "1000" => display_right <= "0000000";--8
				when "1001" => display_right <= "0001100";--9
				when "1010" => display_right <= "0001000";--A
				when "1011" => display_right <= "1100000";--b
				when "1100" => display_right <= "0110001";--c
				when "1101" => display_right <= "1000010";--d	
				when "1110" => display_right <= "0110000";--e	
				when others => display_right <= "0111000";--f	--"1111"
			end case;
			
			case l1 is
				when "0000" => display_left <= "0000001";--0
				when "0001" => display_left <= "1001111";--1
				when "0010" => display_left <= "0010010";--2
				when "0011" => display_left <= "0000110";--3
				when "0100" => display_left <= "1001100";--4
				when "0101" => display_left <= "0100100";--5	
				when "0110" => display_left <= "0100000";--6			
				when "0111" => display_left <= "0001111";--7		
				when "1000" => display_left <= "0000000";--8
				when "1001" => display_left <= "0001100";--9
				when "1010" => display_left <= "0001000";--A
            when "1011" => display_left <= "1100000";--b
				when "1100" => display_left <= "0110001";--c
				when "1101" => display_left <= "1000010";--d	
				when "1110" => display_left <= "0110000";--e	
				when others => display_left <= "0111000";--f	--"1111"
			end case;
			count <= 0;
			else
				count <= count +1;
			end if;
		end if;


end process;	 


end FSM;