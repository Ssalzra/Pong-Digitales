LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------
ENTITY x_ymove IS
	PORT	(	clk			:	IN		STD_LOGIC;
				rst			:	IN		STD_LOGIC;
				ena			:	IN		STD_LOGIC;
				en_id       :  IN    STD_LOGIC_VECTOR(1 DOWNTO 0);
				col_izq		:	IN		STD_LOGIC;
				col_der		:	IN		STD_LOGIC;
				arriba_P1	:	IN		STD_LOGIC;
				medio_P1		:	IN		STD_LOGIC;
				abajo_P1		:	IN		STD_LOGIC;
				esq_arriba_D:  IN    STD_LOGIC;
				esq_abajo_D	:  IN    STD_LOGIC;
				arriba_P2	:	IN		STD_LOGIC;
				medio_P2		:	IN		STD_LOGIC;
				abajo_P2		:	IN		STD_LOGIC;
				esq_arriba_I:  IN    STD_LOGIC;
				esq_abajo_I	:  IN    STD_LOGIC;
				col_tec		:	IN		STD_LOGIC;
				col_pis		:	IN		STD_LOGIC;
				ini_st		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_sel			:	OUT	STD_LOGIC;
				y_sel			:	OUT	STD_LOGIC_VECTOR( 1 DOWNTO 0 ));
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF x_ymove IS

	SIGNAL	col_izq_s	:	STD_LOGIC;
	SIGNAL	col_der_s	:	STD_LOGIC;
	SIGNAL	col_tec_s	:	STD_LOGIC;
	SIGNAL	col_pis_s	:	STD_LOGIC;

	TYPE state IS (st0, st1, st2, st3, st4, st5);
	SIGNAL pr_state, nx_state	:	state;
	
BEGIN

	col_der_s	<=	col_der AND en_id(0);
	col_izq_s	<=	col_izq AND en_id(1);
	col_tec_s   <= col_tec;
	col_pis_s   <= col_pis;
	
	-------------------------------------------------------------
	--                 LOWER SECTION OF FSM                    --
	-------------------------------------------------------------
	sequential: PROCESS(rst, clk)
	BEGIN
		IF (rst = '1') THEN
				IF	(ini_st = "000") THEN
				pr_state	<=	st1;
			ELSIF	(ini_st = "001") THEN
				pr_state	<=	st1;
			ELSIF	(ini_st = "010") THEN
				pr_state	<=	st2;
			ELSIF	(ini_st = "011") THEN
				pr_state	<=	st3;
			ELSIF	(ini_st = "100") THEN
				pr_state	<=	st4;
			ELSE
				pr_state	<=	st1;
			END IF;
		ELSIF (rising_edge(clk)) THEN
			pr_state	<=	nx_state;
		END IF;
	END PROCESS sequential;
	
	-------------------------------------------------------------
	--                 UPPER SECTION OF FSM                    --
	-------------------------------------------------------------
	combinational: PROCESS(pr_state, col_izq_s, col_der_s, col_pis_s, col_tec_s, arriba_P1, medio_P1, abajo_P1, esq_abajo_D, esq_arriba_D, arriba_P2, medio_P2, abajo_P2, esq_abajo_I, esq_arriba_I)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				y_sel	<=	"00";
				x_sel	<=	'1';
				IF (col_izq_s = '1' OR medio_P1 = '1') THEN
					nx_state	<= st5;
				ELSIF (arriba_P1 = '1') THEN
					nx_state	<= st1;
				ELSIF (abajo_P1 = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st0;
				END IF;
------------------------------------------------------------------
			WHEN st1	=>
				y_sel	<=	"10";
				x_sel	<=	'0';
				IF (col_der_s = '1' OR arriba_P2 = '1') THEN
					nx_state	<= st2;
				ELSIF (medio_P2 = '1') THEN
					nx_state	<= st0;
				ELSIF (abajo_P2 = '1' OR ((NOT(arriba_P2 OR medio_P2 OR abajo_P2) AND esq_abajo_D) = '1')) THEN
					nx_state	<= st4;
				ELSIF (col_tec_s = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st1;
				END IF;
------------------------------------------------------------------
			WHEN st2	=>
				y_sel	<=	"10";
				x_sel	<=	'1';
				IF (col_izq_s = '1' OR arriba_P1 = '1') THEN
					nx_state	<= st1;
				ELSIF (medio_P1 = '1') THEN
					nx_state	<= st5;
				ELSIF (abajo_P1 = '1' OR ((NOT(arriba_P1 OR medio_P1 OR abajo_P1) AND esq_abajo_I) = '1')) THEN
					nx_state	<= st3;
				ELSIF (col_tec_s = '1') THEN
					nx_state	<= st4;
				ELSE
					nx_state	<= st2;
				END IF;
------------------------------------------------------------------
			WHEN st3	=>
				y_sel	<=	"01";
				x_sel	<=	'0';
				IF (col_der_s = '1' OR abajo_P2 = '1') THEN
					nx_state	<= st4;
				ELSIF (arriba_P2 = '1' OR ((NOT(arriba_P2 OR medio_P2 OR abajo_P2) AND esq_arriba_D) = '1')) THEN
					nx_state	<= st2;
				ELSIF (medio_P2 = '1') THEN
					nx_state	<= st0;
				ELSIF (col_pis_s = '1') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st3;
				END IF;
------------------------------------------------------------------
			WHEN st4	=>
				y_sel	<=	"01";
				x_sel	<=	'1';
				IF (col_izq_s = '1' OR abajo_P1 = '1') THEN
					nx_state	<= st3;
				ELSIF (arriba_P1 = '1' OR ((NOT(arriba_P1 OR medio_P1 OR abajo_P1) AND esq_arriba_I) = '1')) THEN
					nx_state	<= st1;
				ELSIF (medio_P1 = '1') THEN
					nx_state	<= st5;
				ELSIF (col_pis_s = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st4;
				END IF;
------------------------------------------------------------------
			WHEN st5	=>
				y_sel	<=	"00";
				x_sel	<=	'0';
				IF (col_der_s = '1' OR medio_P2 = '1') THEN
					nx_state	<= st0;
				ELSIF (arriba_P2 = '1') THEN
					nx_state	<= st2;
				ELSIF (abajo_P2 = '1') THEN
					nx_state	<= st4;
				ELSE
					nx_state	<= st5;
				END IF;
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;