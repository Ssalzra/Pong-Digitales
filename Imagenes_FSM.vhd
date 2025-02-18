LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.mtx_pkg.ALL;
----------------------------------------
ENTITY Imagenes_FSM IS
	PORT	(	clk				:	IN	STD_LOGIC;
				rst				:	IN	STD_LOGIC;
				ena				:	IN	STD_LOGIC;
				str_btn			:	IN	STD_LOGIC;
				col_izq			:	IN	STD_LOGIC;
				col_der			:	IN	STD_LOGIC;
				max_izq			:	IN	STD_LOGIC;
				max_der			:	IN	STD_LOGIC;
				tick_timer_1s	:	IN	STD_LOGIC;
				tick_timer_3s	:	IN	STD_LOGIC;
				tick_timer_g	:	IN	STD_LOGIC;
				tick_timer_w	:	IN	STD_LOGIC;
				timer_ena_3s	:	OUT	STD_LOGIC	:=	'0';
				timer_ena_g		:	OUT	STD_LOGIC	:=	'0';
				timer_ena_w		:	OUT	STD_LOGIC	:=	'0';
				gol_sig_1		:	OUT	STD_LOGIC	:=	'0';
				gol_sig_2		:	OUT	STD_LOGIC	:=	'0';
				rst_game			:	OUT	STD_LOGIC	:=	'1';
				wr_en				:	OUT	STD_LOGIC;
				w_addr_j			:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				w_addr_i			:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				w_data			:	OUT	STD_LOGIC);
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF Imagenes_FSM IS
	
	SIGNAL	w_addr_s0_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s0_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s0	:	STD_LOGIC;
	SIGNAL	wr_en_s0		:	STD_LOGIC;
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
	SIGNAL	w_addr_s4_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s4_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s4	:	STD_LOGIC;
	SIGNAL	wr_en_s4		:	STD_LOGIC;
	SIGNAL	w_addr_sc_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_sc_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_sc	:	STD_LOGIC;
	SIGNAL	wr_en_sc		:	STD_LOGIC;

	
	TYPE state IS (st0, st1, st2, st3, st4, st5, st6, st7);
	SIGNAL pr_state, nx_state	:	state;
	
	
	CONSTANT Ima0: Img_mtx:=(
				"0000000000000000",
				"1111011101110111",
				"0001010101010101",
				"1101010101010111",
				"1001010101010001",
				"1111010101110001",
				"0000000000000000",
				"1111011101110111");
	
	CONSTANT Ima1: Img_mtx:=(
				"0000000000000000",
				"1000101111011110",
				"1000101001000010",
				"1000101001000010",
				"1000101001011010",
				"0000101001010010",
				"1011101111011110",
				"0000000000000000");
	
	CONSTANT Ima2: Img_mtx:=(
				"0010100001100111",
				"0000000001001001",
				"0100010001000111",
				"0011100011100001",
				"0100000000000000",
				"0101110111010101",
				"0001010101010101",
				"0101010111001010");
				
	CONSTANT Ima3: Img_mtx:=(
				"0010100011100111",
				"0000000011001001",
				"0100010000100111",
				"0011100011100001",
				"0100000000000000",
				"0101110111010101",
				"0001010101010101",
				"0101010111001010");

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
	
	pong_print:	ENTITY work.ManejoImagen
				PORT MAP(clk      =>	clk,
						rst      =>	rst,
						ena      =>	ena,
						imageIn	=>	Ima0,
						wr_en		=>	wr_en_s0,
						w_addr_j	=>	w_addr_s0_j,
						w_addr_i	=>	w_addr_s0_i,
						w_data	=>	w_data_s0);
	
	conteo_fsm: ENTITY work.CuentaAtras
				PORT MAP(clk     		=>	clk,
						rst      		=>	rst,
						ena      		=>	ena,
						tick_timer_1s	=>	tick_timer_1s,
						wr_en			=>	wr_en_s1,
						w_addr_j		=>	w_addr_s1_j,
						w_addr_i		=>	w_addr_s1_i,
						w_data			=>	w_data_s1);
	
	g_print:	ENTITY work.ManejoImagen
				PORT MAP(clk      =>	clk,
						rst      =>	rst,
						ena      =>	ena,
						imageIn	=>	Ima1,
						wr_en		=>	wr_en_s2,
						w_addr_j	=>	w_addr_s2_j,
						w_addr_i	=>	w_addr_s2_i,
						w_data	=>	w_data_s2);
	
	w1_print:	ENTITY work.ManejoImagen
				PORT MAP(clk      =>	clk,
						rst      =>	rst,
						ena      =>	ena,
						imageIn	=>	Ima2,
						wr_en		=>	wr_en_s3,
						w_addr_j	=>	w_addr_s3_j,
						w_addr_i	=>	w_addr_s3_i,
						w_data	=>	w_data_s3);
	
	w2_print:	ENTITY work.ManejoImagen
				PORT MAP(clk      =>	clk,
						rst      =>	rst,
						ena      =>	ena,
						imageIn	=>	Ima3,
						wr_en		=>	wr_en_s4,
						w_addr_j	=>	w_addr_s4_j,
						w_addr_i	=>	w_addr_s4_i,
						w_data	=>	w_data_s4);
	
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
			pr_state	<=	st0;
		ELSIF (rising_edge(clk)) THEN
			pr_state	<=	nx_state;
		END IF;
	END PROCESS sequential;
	
	-------------------------------------------------------------
	--                 UPPER SECTION OF FSM                    --
	-------------------------------------------------------------
	combinational: PROCESS(str_btn, col_der, col_izq, max_der, max_izq, tick_timer_3s, tick_timer_1s, tick_timer_g, tick_timer_w)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				
				wr_en		<=	wr_en_s0;
				w_addr_j	<=	w_addr_s0_j;
				w_addr_i	<=	w_addr_s0_i;
				w_data	<=	w_data_s0;
					
				timer_ena_3s	<=	'0';
				timer_ena_g		<=	'0';
				timer_ena_w		<=	'0';
				rst_game		<=	'1';
				
				gol_sig_1	<=	'0';
				gol_sig_2	<=	'0';
				
				IF (str_btn = '1') THEN
					nx_state	<= st7;
				ELSE
					nx_state	<= st0;
				END IF;
			WHEN st1	=>
				
				timer_ena_3s	<=	'1';
				timer_ena_g		<=	'0';
				timer_ena_w		<=	'0';
				rst_game		<=	'1';
				
				wr_en		<=	wr_en_s1;
				w_addr_j	<=	w_addr_s1_j;
				w_addr_i	<=	w_addr_s1_i;
				w_data	<=	w_data_s1;
				
				gol_sig_1	<=	'0';
				gol_sig_2	<=	'0';
				
				IF (tick_timer_3s = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st1;
				END IF;
			WHEN st2	=>
				
				wr_en		<=	'1';
				w_addr_j	<=	"0000";
				w_addr_i	<=	"000";
				w_data	<=	'0';
				
				timer_ena_3s	<=	'0';
				timer_ena_g		<=	'0';
				timer_ena_w		<=	'0';
				rst_game		<=	'0';
				
				IF (col_der = '1') THEN
					nx_state	<= st3;	
				ELSIF (col_izq = '1') THEN
					nx_state	<= st5;
				ELSIF (max_der = '1') THEN
					nx_state	<= st4;
				ELSIF (max_izq = '1') THEN
					nx_state	<= st6;
				ELSE
					nx_state	<= st2;
				END IF;
				
			WHEN st3	=>
				
				wr_en		<=	wr_en_s2;
				w_addr_j	<=	w_addr_s2_j;
				w_addr_i	<=	w_addr_s2_i;
				w_data	<=	w_data_s2;
				
				timer_ena_3s	<=	'0';
				timer_ena_g		<=	'1';
				timer_ena_w		<=	'0';
				rst_game		<=	'1';
				
				gol_sig_1	<=	'1';
				gol_sig_2	<=	'0';
					
				IF (max_der = '1') THEN
					nx_state	<= st4;
				ELSIF (tick_timer_g = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st3;
				END IF;
				
			WHEN st4	=>
				
				wr_en		<=	wr_en_s3;
				w_addr_j	<=	w_addr_s3_j;
				w_addr_i	<=	w_addr_s3_i;
				w_data	<=	w_data_s3;
				
				timer_ena_3s	<=	'0';
				timer_ena_g		<=	'0';
				timer_ena_w		<=	'1';
				rst_game		<=	'1';
				
				gol_sig_1	<=	'0';
				gol_sig_2	<=	'0';
				
				IF (tick_timer_w = '1') THEN
					nx_state	<= st0;
				ELSE
					nx_state	<= st4;
				END IF;
				
			WHEN st5	=>
				
				wr_en		<=	wr_en_s2;
				w_addr_j	<=	w_addr_s2_j;
				w_addr_i	<=	w_addr_s2_i;
				w_data	<=	w_data_s2;
				
				timer_ena_3s	<=	'0';
				timer_ena_g		<=	'1';
				timer_ena_w		<=	'0';
				rst_game		<=	'1';
				
				IF (max_izq = '1') THEN
					nx_state	<= st6;
				ELSIF (tick_timer_g = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st5;
				END IF;
			
				gol_sig_2	<=	'1';
				gol_sig_1	<=	'0';
			
			WHEN st6	=>
				
				wr_en		<=	wr_en_s4;
				w_addr_j	<=	w_addr_s4_j;
				w_addr_i	<=	w_addr_s4_i;
				w_data	<=	w_data_s4;
					
				timer_ena_3s	<=	'0';
				timer_ena_g		<=	'0';
				timer_ena_w		<=	'1';
				rst_game		<=	'1';
				
				gol_sig_1	<=	'0';
				gol_sig_2	<=	'0';
					
				IF (tick_timer_w = '1') THEN
					nx_state	<= st0;
				ELSE
					nx_state	<= st6;
				END IF;
				WHEN st7	=>
				wr_en		<=	wr_en_sc;
				w_addr_j	<=	w_addr_sc_j;
				w_addr_i	<=	w_addr_sc_i;
				w_data	<=	w_data_sc;
				nx_state	<=	st1;
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;