library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity maquinaTiempos is
    Port ( clk, clear: in  STD_LOGIC;-- Reloj y Clear
           cuenta : out  STD_LOGIC_VECTOR (1 downto 0);
		   sControReg : out STD_LOGIC_VECTOR (5 downto 0)); --Las salidas Para los OE y LE
attribute pin_numbers of maquinaTiempos:entity is
"clk:1 "& --ENTRADAS
"clear:2 "&


"sControReg(0):23 "& -- OE de Ra
"sControReg(1):22 "& -- LE de Ra

"sControReg(2):21 "& -- OE de Rb
"sControReg(3):20 "& -- LE de Rb

"sControReg(4):19 "& -- OE de Rc
"sControReg(5):18 "; -- LE de Rc


end maquinaTiempos;

architecture Behavioral of maquinaTiempos is
-- Señal que nos ayuda a sumar cada pulso de reloj
signal cuenta_int: std_logic_vector(1 downto 0) := (others => '0');
begin
	P1: process (clk) -- Proceso de Contar
	begin
		if (clk = '1' and clk'event) then --Por cada pulso del reloj
			if  clear = '1' then -- Si el clear esta activo reseteamos la salida
				cuenta_int <= "00";
			else
				cuenta_int <= cuenta_int+1; -- En caso contrario sumamos 1
			end if;
		end if;
	end process;

	cuenta <= cuenta_int; -- para mostrar lo que va contando

   	P2: process (clk) -- Procesopara el intercambio
	begin
		case cuenta_int is
			when "00" => sControReg<="101010"; --nada --Tiempo 0
			when "01" => sControReg<="100011"; --Rc <- Rb, Tiempo 1
			when "10" => sControReg<="001110"; --Rb <- Ra, Tiempo 2
			when "11" => sControReg<="111001"; --Ra <- Rc, Tiempo 3
			when others => sControReg<="101010"; --nada
	
		end case;		
	end process;

end Behavioral;
