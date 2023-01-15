
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity maquinaTiempos is
    Port ( clk, clear: in  STD_LOGIC;-- Reloj y Clear
		  selectP : in  STD_LOGIC_VECTOR (3 downto 0);
           cuentaT : out  STD_LOGIC_VECTOR (2 downto 0);
		   Realizado,OERegExterno,CinALU,LERegA,LERegG,OERegG: out  STD_LOGIC); 


end maquinaTiempos;

architecture Behavioral of maquinaTiempos is
-- Señal que nos ayuda a sumar cada pulso de reloj
signal cuenta_int: std_logic_vector(2 downto 0) := (others => '0');
begin
	P1: process (clk) -- Proceso de Contar
	begin
		if (clk = '1' and clk'event) then --Por cada pulso del reloj
			if  (clear = '1' or cuenta_int = "100")then -- Si el clear esta activo reseteamos la salida
				cuenta_int <= "000";
			else
				cuenta_int <= cuenta_int+1; -- En caso contrario sumamos 1
			end if;
		end if;
	end process;

	cuentaT <= cuenta_int; -- para mostrar lo que va contando
	
	P2: process (cuenta_int, selectP) --Proceos de la funcion
	begin
		--Es una carga de datos habilitamos el dip de entrada
		if (selectP = "0000" OR selectP = "0001" OR selectP = "0010" OR selectP = "0011") then
			OERegExterno <= '0';
		else
			OERegExterno <= '1';
		end if;
		
		--Si es resta amndamos un 1 a la ALU
		if (selectP = 1001) then 
			CinALU <= '1';
		end if;

	   	if(cuenta_int = "000") then --Nada
			LERegA <= '0'; 
			LERegG <= '0';
			OERegG <= '1';
		end if;

		if(cuenta_int = "001") then 
			LERegA <= '1'; --Madamos el Rx a El registro A
			LERegG <= '0';
			OERegG <= '1';
		end if;

		if(cuenta_int = "010") then 
			LERegA <= '0'; --Ya guardado el Rx a El registro A
			LERegG <= '1'; --Cachamos el reusltado de la ALU
			OERegG <= '1';
		end if;

		if(cuenta_int = "011") then 
			LERegA <= '0'; 
			LERegG <= '0'; --Guardamos el resultado de la alu
			OERegG <= '1'; --
		end if;

		if(cuenta_int = "100") then 
		LERegA <= '0'; 
		LERegG <= '0'; 
		OERegG <= '0'; --Soltamos el valor del RegG al bus
		Realizado <= '1';
		else
			Realizado <= '0';
		end if;
	end process;

end Behavioral;
