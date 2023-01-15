

-- UnidadSyR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity maquinaTiempos is
    Port (
		T: in STD_LOGIC_VECTOR (2 downto 0);-- el contador de tiempos
		selctP: in STD_LOGIC_VECTOR (3 downto 0); -- selector para elegir la funcion
		selctS: in STD_LOGIC_VECTOR (3 downto 0); -- slector para decidir entre que registros se hara la operacion
	--	LERegA,LERegG,OERegG,CinALU: out  STD_LOGIC;-- 
		   sControReg : out STD_LOGIC_VECTOR (7 downto 0)); --Las salidas Para los OE y LE


attribute pin_numbers of maquinaTiempos:entity is

"sControReg(7):23 "& -- OE de R0
"sControReg(6):22 "& -- LE de R0

"sControReg(5):21 "& -- OE de R1
"sControReg(4):20 "& -- LE de R1

"sControReg(3):19 "& -- OE de R1
"sControReg(2):18 "& -- LE de R1

"sControReg(1):17 "& -- OE de R3
"sControReg(0):16 "; -- LE de R3

end maquinaTiempos;

architecture Behavioral of maquinaTiempos is
begin

process (T,selctP,selctS) -- Proceso SumaYRestar
begin
if (selctP = "1000" OR selctP = "1001") then -- si puchamos W xd se activa...
--	CinALU <= selctP(0); --Si es suma sera un 0 si es resta un 1
	
	if(T = "000") then --Nada
		sControReg <= "10101010";
	end if;
	if(T = "001") then 
--		LERegA <= '1'; --Madamos el Rx a El registro A
--		LERegG <= '0';
--		OERegG <= '1';
		case selctS is
		when "0000" => sControReg<="00101010"; -- R0 + R1
		when "0001" => sControReg<="00101010"; -- R0 + R2
		when "0010" => sControReg<="00101010"; -- R0 + R3

		when "0011" => sControReg<="10001010"; -- R1 + R0
		when "0100" => sControReg<="10001010"; -- R1 + R2
		when "0101" => sControReg<="10001010"; -- R1 + R3

		when "0110" => sControReg<="10100010"; -- R2 + R0
		when "0111" => sControReg<="10100010"; -- R2 + R1
		when "1000" => sControReg<="10100010"; -- R2 + R3

		when "1001" => sControReg<="10101000"; -- R3 + R0
		when "1010" => sControReg<="10101000"; -- R3 + R1
		when "1011" => sControReg<="10101000"; -- R3 + R2

		when others => sControReg<="10101010"; --nada
		end case;	
	end if;

	if(T = "010") then --Mandamos el valor del registro Ry al bus
--		LERegA <= '0'; --Guardamos el dato de el registro A
--		LERegG <= '1'; --Cachamos el resultado de la alu 
--		OERegG <= '1';
		case selctS is
		when "0000" => sControReg<="10001010"; -- R0 + R1
		when "0001" => sControReg<="10100010"; -- R0 + R2
		when "0010" => sControReg<="10101000"; -- R0 + R3

		when "0011" => sControReg<="00101010"; -- R1 + R0
		when "0100" => sControReg<="10100010"; -- R1 + R2
		when "0101" => sControReg<="10101000"; -- R1 + R3

		when "0110" => sControReg<="00101010"; -- R2 + R0
		when "0111" => sControReg<="10001010"; -- R2 + R1
		when "1000" => sControReg<="10101000"; -- R2 + R3

		when "1001" => sControReg<="00101010"; -- R3 + R0
		when "1010" => sControReg<="10001010"; -- R3 + R1
		when "1011" => sControReg<="10100010"; -- R3 + R2
		
		when others => sControReg<="10101010"; --nada
		end case;	
	end if;
	if(T = "011") then --Nada
		sControReg <= "10101010";
	end if;

	if(T = "100") then --Mandamos el valor del registro RG al Rx
--		LERegA <= '0'; 
--		LERegG <= '0'; --Guardamos el dato de el registro G
--		OERegG <= '0'; --Mandamos el valor del RG al bus
		case selctS is
		when "0000" => sControReg<="11101010"; -- R0 + R1
		when "0001" => sControReg<="11101010"; -- R0 + R2
		when "0010" => sControReg<="11101010"; -- R0 + R3

		when "0011" => sControReg<="10111010"; -- R1 + R0
		when "0100" => sControReg<="10111010"; -- R1 + R2
		when "0101" => sControReg<="10111010"; -- R1 + R3

		when "0110" => sControReg<="10101110"; -- R2 + R0
		when "0111" => sControReg<="10101110"; -- R2 + R1
		when "1000" => sControReg<="10101110"; -- R2 + R3

		when "1001" => sControReg<="10101011"; -- R3 + R0
		when "1010" => sControReg<="10101011"; -- R3 + R1
		when "1011" => sControReg<="10101011"; -- R3 + R2
		
		when others => sControReg<="10101010"; --nada
		end case;
	end if;
else
	sControReg<="ZZZZZZZZ"; --Se usa la otra GALCar-Muestra_Mover

end if;
end process;

end Behavioral;
