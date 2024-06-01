LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.mtx_pkg.ALL;
----------------------------------------
ENTITY CuentaAtras IS
	PORT 	(	clk				:	IN	STD_LOGIC;
				rst				:	IN	STD_LOGIC;
				ena				:	IN	STD_LOGIC;
				tick_timer_1s	:	IN	STD_LOGIC;
				wr_en			:	OUT	STD_LOGIC;
				w_addr_j		:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				w_addr_i		:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				w_data			:	OUT	STD_LOGIC);
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF CuentaAtras IS
	
	SIGNAL	w_addr_s1_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s1_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s1	:	STD_LOGIC;
	SIGNAL	wr_en_s1		:	STD_LOGIC;
	SIGNAL	w_addr_s2_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s2_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s2	:	STD_LOGIC;
	SIGNAL	wr_en_s2		:	STD_LOGIC;
	SIGNAL	w_addr_s3_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s3_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s3	:	STD_LOGIC;
	SIGNAL	wr_en_s3		:	STD_LOGIC;
	SIGNAL	w_addr_sc_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_sc_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_sc	:	STD_LOGIC;
	SIGNAL	wr_en_sc		:	STD_LOGIC;

	TYPE state IS (st0, st1, st2, st3, st4, st5);
	SIGNAL pr_state, nx_state	:	state;
	
	CONSTANT Ima0: Img_mtx:=(
				"0000000000000000",
				"0001000000010000",
				"0001100000011000",
				"0001010000010100",
				"0001000000010000",
				"0001000000010000",
				"0011110000111100",
				"0000000000000000");
			
	CONSTANT Ima1: Img_mtx:=(
				"0000000000000000",
				"0011110000111100",
				"0010000000100000",
				"0011110000111100",
				"0000010000000100",
				"0000010000000100",
				"0011110000111100",
				"0000000000000000");
			
	CONSTANT Ima2: Img_mtx:=(
				"0000000000000000",
				"0011110000111100",
				"0010000000100000",
				"0011110000111100",
				"0010000000100000",
				"0010000000100000",
				"0011110000111100",
				"0000000000000000");
				
	CONSTANT Img: Img_mtx:=(
				"0000000000000000",
				"0000000000000000",
				"0000000000000000",
				"0000000000000000",
				"0000000000000000",
				"0000000000000000",
				"0000000000000000",
				"0000000000000000");
BEGIN
		
	frame3_print: ENTITY work.ManejoImagen
				PORT MAP (clk      =>	clk,
							rst      =>	rst,
							ena      =>	ena,
							imageIn	=>	Ima0,
							wr_en		=>	wr_en_s1,
							w_addr_j	=>	w_addr_s1_j,
							w_addr_i	=>	w_addr_s1_i,
							w_data	=>	w_data_s1);
	
	frame2_print:	ENTITY work.ManejoImagen
				PORT MAP(clk      =>	clk,
						rst      =>	rst,
						ena      =>	ena,
						imageIn	=> Ima1,
						wr_en		=>	wr_en_s2,
						w_addr_j	=>	w_addr_s2_j,
						w_addr_i	=>	w_addr_s2_i,
						w_data	=>	w_data_s2);
	
	frame1_print:	ENTITY work.ManejoImagen
				PORT MAP(clk      =>	clk,
						rst      =>	rst,
						ena      =>	ena,
						imageIn	=>	Ima2,
						wr_en		=>	wr_en_s3,
						w_addr_j	=>	w_addr_s3_j,
						w_addr_i	=>	w_addr_s3_i,
						w_data	=>	w_data_s3);
	

	framec_print: ENTITY work.ManejoImagen
				PORT MAP (clk      =>	clk,
							rst      =>	rst,
							ena      =>	'1',
							imageIn	=>	Img,
							wr_en		=>	wr_en_sc,
							w_addr_j	=>	w_addr_sc_j,
							w_addr_i	=>	w_addr_sc_i,
							w_data	=>	w_data_sc);
	
	-------------------------------------------------------------
	--                 LOWER SECTION OF FSM                    --
	-------------------------------------------------------------
	sequential: PROCESS(rst, clk)
	BEGIN
		IF (rst = '1') THEN
			pr_state	<=	st5;
		ELSIF (rising_edge(clk)) THEN
			pr_state	<=	nx_state;
		END IF;
	END PROCESS sequential;
	
	-------------------------------------------------------------
	--                 UPPER SECTION OF FSM                    --
	-------------------------------------------------------------
	combinational: PROCESS(tick_timer_1s)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				wr_en		<=	wr_en_s1;
				w_addr_j	<=	w_addr_s1_j;
				w_addr_i	<=	w_addr_s1_i;
				w_data	<=	w_data_s1;
				
				IF (tick_timer_1s = '1') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st0;
				END IF;
			WHEN st1	=>
				wr_en		<=	wr_en_sc;
				w_addr_j	<=	w_addr_sc_j;
				w_addr_i	<=	w_addr_sc_i;
				w_data	<=	w_data_sc;
				nx_state	<=	st2;
			WHEN st2	=>
				wr_en		<=	wr_en_s2;
				w_addr_j	<=	w_addr_s2_j;
				w_addr_i	<=	w_addr_s2_i;
				w_data	<=	w_data_s2;
				
--				i <= "01";
				
				IF (tick_timer_1s = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st2;
				END IF;
			WHEN st3	=>
				wr_en		<=	wr_en_sc;
				w_addr_j	<=	w_addr_sc_j;
				w_addr_i	<=	w_addr_sc_i;
				w_data	<=	w_data_sc;
				nx_state	<=	st4;
			WHEN st4	=>
				wr_en		<=	wr_en_s3;
				w_addr_j	<=	w_addr_s3_j;
				w_addr_i	<=	w_addr_s3_i;
				w_data	<=	w_data_s3;
				
				nx_state	<= st4;
			WHEN st5	=>
				wr_en		<=	wr_en_sc;
				w_addr_j	<=	w_addr_sc_j;
				w_addr_i	<=	w_addr_sc_i;
				w_data	<=	w_data_sc;
				nx_state	<=	st0;
				
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;