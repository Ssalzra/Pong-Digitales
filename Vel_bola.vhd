LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.mtx_pkg.ALL;
----------------------------------------
ENTITY Vel_bola IS
	PORT	(	clk				:	IN		STD_LOGIC;
				rst				:	IN		STD_LOGIC;
				ena				:	IN		STD_LOGIC;
				Golpeos 			:	IN		STD_LOGIC;
				Velocidad		:	OUT	STD_LOGIC_VECTOR( 27 DOWNTO 0 ));
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF Vel_bola IS

	TYPE state IS (st0, st1, st2, st3, st4, st5, st6, st7, st8, st9, st10, st11, st12, st13, st14, st15);
	SIGNAL nx_state	:	state;
	SIGNAL pr_state	:	state;
	
BEGIN
	
	-------------------------------------------------------------
	--                 LOWER SECTION OF FSM                    --
	-------------------------------------------------------------
	sequential: PROCESS(rst, clk)
	BEGIN
		IF (rst = '1') THEN
			pr_state	<=	st0;
		ELSIF (rising_edge(clk)) THEN
			pr_state	<=	nx_state;
		END IF;
	END PROCESS sequential;
	
	-------------------------------------------------------------
	--                 UPPER SECTION OF FSM                    --
	-------------------------------------------------------------
	combinational: PROCESS(Golpeos)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				
				Velocidad	<=	"0001011111010111100001000000";--0.50s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st0;
				END IF;
				
			WHEN st1	=>
				
				Velocidad	<=	"0001011001101001010011100000";--0.47s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st1;
				END IF;
				
			WHEN st2	=>
				
				Velocidad	<=	"0001010011111011000110000000";--0.44s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st2;
				END IF;
				
			WHEN st3	=>
				
				Velocidad	<=	"0001001110001100111000100000";--0.41s
					
				IF (Golpeos = '1') THEN
					nx_state	<= st4;
				ELSE
					nx_state	<= st3;
				END IF;
				
			WHEN st4	=>
				
				Velocidad	<=	"0001001000011110101011000000";--0.38s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st5;
				ELSE
					nx_state	<= st4;
				END IF;
				
			WHEN st5	=>
				
				Velocidad	<=	"0001000010110000011101100000";--0.35s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st6;
				ELSE
					nx_state	<= st5;
				END IF;
			
			WHEN st6	=>
				
				Velocidad	<=	"0000111101000010010000000000";--0.32s
					
				IF (Golpeos = '1') THEN
					nx_state	<= st7;
				ELSE
					nx_state	<= st6;
				END IF;
				
			WHEN st7	=>
				
				Velocidad	<=	"0000110111010100000010100000";--0.29s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st8;
				ELSE
					nx_state	<= st7;
				END IF;
				
			WHEN st8	=>
				
				Velocidad	<=	"0000110001100101110101000000";--0.26s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st9;
				ELSE
					nx_state	<= st8;
				END IF;
			
			WHEN st9	=>
				
				Velocidad	<=	"0000101011110111100111100000";--0.23s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st10;
				ELSE
					nx_state	<= st9;
				END IF;
				
			WHEN st10	=>
				
				Velocidad	<=	"0000100110001001011010000000";--0.20s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st11;
				ELSE
					nx_state	<= st10;
				END IF;
			
			WHEN st11	=>
				
				Velocidad	<=	"0000100000011011001100100000";--0.17s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st12;
				ELSE
					nx_state	<= st11;
				END IF;
				
			WHEN st12	=>
				
				Velocidad	<=	"0000011010101100111111000000";--0.14s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st13;
				ELSE
					nx_state	<= st12;
				END IF;
				
			WHEN st13	=>
				
				Velocidad	<=	"0000010100111110110001100000";--0.11s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st14;
				ELSE
					nx_state	<= st13;
				END IF;
				
			WHEN st14	=>
				
				Velocidad	<=	"0000001111010000100100000000";--0.08s
				
				IF (Golpeos = '1') THEN
					nx_state	<= st15;
				ELSE
					nx_state	<= st14;
				END IF;
				
			WHEN st15	=>
				
				Velocidad	<=	"0000001001100010010110100000";--0.05s
				
				nx_state	<= st15;
				
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;