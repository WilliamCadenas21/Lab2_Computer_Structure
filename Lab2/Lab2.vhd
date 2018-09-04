library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-----------------------------------------------------

entity lab2 is
port(	

--inputs
	clock:		in std_logic;
	reset:		in std_logic;	
	velocity:	in std_logic;
	
	--Clock
	ps2_clk:		IN  STD_LOGIC; --clock signal from PS2 keyboard
	ps2_data: 	IN  STD_LOGIC;
	
	
	--LCD
	lcd:			out std_logic_vector(7 downto 0);  --LCD data pins
	enviar: 		out std_logic;    --Send signal
	rs:			out std_logic;    --Data or command
	rw: 			out std_logic;   --read/write
	--data signal from PS2 keyboard


--outputs
	display_right : out  STD_LOGIC_VECTOR (0 to 6);
	display_left : out  STD_LOGIC_VECTOR (0 to 6); 
	led1: out STD_LOGIC;
	led2: out STD_LOGIC


);
end lab2;

-----------------------------------------------------

architecture FSM of lab2 is
	signal info: std_logic_vector(7 downto 0);
	signal ascii: std_logic_vector(7 downto 0);
	signal clockTimer: integer:= 12500000; --2hz 
	signal count: integer := 0;
	signal sw: integer := 0;
	signal r1: std_logic_vector(3 downto 0);
	signal l1: std_logic_vector(3 downto 0); 
	signal ps2_array : STD_LOGIC_VECTOR(10 DOWNTO 0);		
	type state_type is (encender, configpantalla,encenderdisplay, limpiardisplay, configcursor,listo,fin);    --Define dfferent states to control the LCD
   signal estado: state_type;
	constant milisegundos: integer := 50000;
	constant microsegundos: integer := 50;
	
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
	
	function returnAscii (vector : std_logic_vector(7 downto 0))
	return std_logic_vector is
	variable output :std_logic_vector(7 downto 0);
	begin
			case vector is
				when "00011100" => output := "01000001";--A LISTO
				when "00011011" => output := "01000010";--B LISTO
				when "00110001" => output := "01000011";--C
				when "00110011" => output := "01000100";--D
				when "" => output := "01000110";--E
				when "" => output := "01000101";--F
				when "" => output := "01000111";--G
				when "" => output := "01001000";--H
				when "" => output := "01001001";--I
				when "" => output := "01001010";--J
				when "" => output := "01001011";--K
				when "" => output := "01001100";--L
				when "" => output := "01001101";--M
				when "" => output := "01001110";--N
				when "" => output := "01001111";--O
				when "" => output := "01010000";--P
				when "" => output := "01010001";--Q
				when "" => output := "01010010";--R
				when "" => output := "01010011";--S
				when "" => output := "01010100";--T
				when "" => output := "01010101";--U
				when "00011100" => output := "01010110";--V
				when "11110000" => output := "01010111";--W
				when "11110000" => output := "01011000";--X
				when "11110000" => output := "01011001";--Y
				when "11110000" => output := "01011010";--Z
				when others => output := "00100100";	--$ hex=24
			end case;
			return output;
	end;
	
	begin

--	process(info)
--		begin
----			if (sw = 0) then
----				if(info = "11110000")then --F0
----					sw <= 1;
----				else
--					-- verificar que letra es para saber 
--					--que asccii enviar
--					case info is
--						when "00011100" => ascii <= "01000001";--A
--						when "11110000" => ascii <= "01000110";--f
--						when others => ascii <= "01001111";	--o
--					end case;
----				end if;
----			else
----				sw <= 0;
----			end if;
--	end process;



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
			
			if(NOT(ps2_array(8 downto 5) = "1111"))then
				info <= ps2_array(8 downto 1);
			end if;

			count <= 0;
			end if;
		end if;
end process;

comb_logic: process(clock, info)
  variable contar: integer := 0;
  begin
	if (clock'event and clock='1') then
	
	  case estado is
	  
	    when encender =>
		  if (contar < 50*milisegundos) then    --Wait for the LCD to start all its components
				contar := contar + 1;
				estado <= encender;
			else
				enviar <= '0';
				contar := 0; 
				estado <= configpantalla;
			end if;
			
			--From this point we will send diffrent configuration commands as shown in class
			--You should check the manual to understand what configurations we are sending to
			--The display. You have to wait between each command for the LCD to take configurations.
	    when configpantalla =>
			if (contar = 0) then
				contar := contar +1;
				rs <= '0';
				rw <= '0';
				lcd <= "00111000";
				enviar <= '1';
				estado <= configpantalla;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= configpantalla;
			else
				enviar <= '0';
				contar := 0;
				estado <= encenderdisplay;
			end if;
			
	    when encenderdisplay =>
			if (contar = 0) then
				contar := contar +1;
				lcd <= "00001111";				
				enviar <= '1';
				estado <= encenderdisplay;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= encenderdisplay;
			else
				enviar <= '0';
				contar := 0;
				estado <= limpiardisplay;
			end if;
			
	    when limpiardisplay =>	
			if (contar = 0) then
				contar := contar +1;
				lcd <= "00000001";				
				enviar <= '1';
				estado <= limpiardisplay;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= limpiardisplay;
			else
				enviar <= '0';
				contar := 0;
				estado <= configcursor;
			end if;
			
	    when configcursor =>	
			if (contar = 0) then
				contar := contar +1;
				lcd <= "00000100";				
				enviar <= '1';
				estado <= configcursor;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= configcursor;
			else
				enviar <= '0';
				contar := 0;
				estado <= listo;
			end if;
			--The display is now configured now it you just can send data to de LCD 
			--In this example we are just sending letter A, for this project you
			--Should make it variable for what has been pressed on the keyboard.
			
	    when listo =>	
			if (contar = 0) then
				rs <= '1';
				rw <= '0';
				enviar <= '1';
				lcd <= returnAscii(info); -- ascii 
				contar := contar + 1;
				estado <= listo;
			elsif (contar < 1000*milisegundos) then
				contar := contar + 1;
				estado <= listo;
			else
				enviar <= '0';
				contar := 0;
				estado <= fin;
			end if;
			
		  when fin =>
			estado <= listo;
			
	    when others =>
			estado <= encender;
	  end case;
	end if;
 end process;	 

end FSM;