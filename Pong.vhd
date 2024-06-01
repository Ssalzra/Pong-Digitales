LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.mtx_pkg.ALL;
----------------------------------------
ENTITY Pong IS
	PORT ( clk 			: 	IN 	STD_LOGIC;
			 rst        : 	IN  	STD_LOGIC;
			 ena        : 	IN  	STD_LOGIC;
			 start      :  IN    STD_LOGIC;
			 btn_up_P1  : 	IN  	STD_LOGIC;
			 btn_dwn_P1 : 	IN  	STD_LOGIC;
			 btn_up_P2  : 	IN  	STD_LOGIC;
			 btn_dwn_P2 : 	IN  	STD_LOGIC;
			 Puntaje_P1 :  OUT    STD_LOGIC_VECTOR(6 DOWNTO 0);
			 Puntaje_P2 :  OUT    STD_LOGIC_VECTOR(6 DOWNTO 0);
			 rows			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			 cols			:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
END Pong;

--------------------------
ARCHITECTURE arch OF Pong IS

-- Control de la matriz de leds --
SIGNAL r_data_lm 	  : STD_LOGIC;
SIGNAL r_addr_lm_i  : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL r_addr_lm_j  : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL max_tick_lmc :	STD_LOGIC;

-- Senales para el registro --
SIGNAL	w_addr_s_j		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	w_addr_s_i		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	w_data_s	  	 	:	STD_LOGIC;
SIGNAL	wr_en_s			:	STD_LOGIC;
SIGNAL	w_addr_s1_j		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	w_addr_s1_i		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	w_data_s1	  	:	STD_LOGIC;
SIGNAL	wr_en_s1			:	STD_LOGIC;
SIGNAL	w_addr_s2_j		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	w_addr_s2_i		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	w_data_s2	  	:	STD_LOGIC;
SIGNAL	wr_en_s2			:	STD_LOGIC;

-- Senales de posicion pelota y raqueta --
SIGNAL   x_sel       	: 	STD_LOGIC;
SIGNAL   y_sel      		: 	STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL   ini_st         :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL   x      	   	: 	STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   y       			: 	STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	x_next_s			:  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	y_next_s			:  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	x_Ra_P1_s		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	y_Ra_P1_s		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	x_Ra_P1_p1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	y_Ra_P1_p1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	x_Ra_P1_m1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	y_Ra_P1_m1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	x_Ra_P2_s		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	y_Ra_P2_s		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	x_Ra_P2_p1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	y_Ra_P2_p1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	x_Ra_P2_m1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	y_Ra_P2_m1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 ); 

-- senales de colisiones --
-- con borde --
SIGNAL	col_der			:	STD_LOGIC;
SIGNAL	col_izq			:	STD_LOGIC;
SIGNAL  	n_col_der_s 	: 	STD_LOGIC;
SIGNAL  	n_col_izq_s		: 	STD_LOGIC;
SIGNAL	col_tec			:	STD_LOGIC;
SIGNAL	col_pis			:	STD_LOGIC;

-- raqueta P1 --
SIGNAL  	arriba_ra_P1 	: 	STD_LOGIC;
SIGNAL  	medio_ra_P1 	: 	STD_LOGIC;
SIGNAL  	abajo_ra_P1 	: 	STD_LOGIC;
SIGNAL  	esq_I_abajo 	: 	STD_LOGIC;
SIGNAL  	esq_I_arriba 	: 	STD_LOGIC;
SIGNAL  	esq_I_abajo_s 	: 	STD_LOGIC;
SIGNAL  	esq_I_arriba_s : 	STD_LOGIC;

SIGNAL  	arriba_P1 		: 	STD_LOGIC;
SIGNAL  	medio_P1 		: 	STD_LOGIC;
SIGNAL  	abajo_P1 		: 	STD_LOGIC;

-- raqueta P2 --
SIGNAL  	arriba_ra_P2 	: 	STD_LOGIC;
SIGNAL  	medio_ra_P2 	: 	STD_LOGIC;
SIGNAL  	abajo_ra_P2 	: 	STD_LOGIC;
SIGNAL  	esq_D_abajo 	: 	STD_LOGIC;
SIGNAL  	esq_D_arriba 	: 	STD_LOGIC;
SIGNAL  	esq_D_abajo_s 	: 	STD_LOGIC;
SIGNAL  	esq_D_arriba_s : 	STD_LOGIC;

SIGNAL  	arriba_P2 		: 	STD_LOGIC;
SIGNAL  	medio_P2 		: 	STD_LOGIC;
SIGNAL  	abajo_P2 		: 	STD_LOGIC;

-- Manejo de entradas -- 

SIGNAL	btn_up_P1_s		:	STD_LOGIC;
SIGNAL	btn_dwn_P1_s	:	STD_LOGIC;
SIGNAL	btn_up_P2_s		:	STD_LOGIC;
SIGNAL	btn_dwn_P2_s	:	STD_LOGIC;

-- control velocidad bola --
SIGNAL   Velocidad		:  STD_LOGIC_VECTOR(27 DOWNTO 0);
SIGNAL   cambio_vel 		:  STD_LOGIC;

-- Start & Pause --
SIGNAL 	start_s   	: STD_LOGIC;
SIGNAL 	start_sig   : STD_LOGIC;

-- Imagenes_FSM senales --
	SIGNAL	max_izq			:	STD_LOGIC;
	SIGNAL	max_der			:	STD_LOGIC;
	SIGNAL	tick_timer_1s	:	STD_LOGIC;
	SIGNAL	tick_timer_3s	:	STD_LOGIC;
	SIGNAL	tick_timer_g	:	STD_LOGIC;
	SIGNAL	tick_timer_w	:	STD_LOGIC;
	SIGNAL	timer_ena_3s	:	STD_LOGIC;
	SIGNAL	timer_ena_g		:	STD_LOGIC;
	SIGNAL	timer_ena_w		:	STD_LOGIC;
	SIGNAL	rst_game			:	STD_LOGIC;
	SIGNAL	gol_sig_1		:	STD_LOGIC;
	SIGNAL	gol_s_1			:	STD_LOGIC;
	SIGNAL	gol_sig_2		:	STD_LOGIC;
	SIGNAL	gol_s_2			:	STD_LOGIC;
	
-- Puntos --
	SIGNAL punt_P1    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL punt_P2    : STD_LOGIC_VECTOR(3 DOWNTO 0);
 
	
BEGIN 

----------------- Manejo Matrices ---------------------
Registro: ENTITY work.register_file
			PORT MAP(clk		=>	clk,
						rst		=>	rst,
						wr_en		=>	wr_en_s,
						w_addr_i	=>	w_addr_s_i,
						w_addr_j	=>	w_addr_s_j,
						w_data	=>	w_data_s,
						r_addr_i	=>	r_addr_lm_i,
						r_addr_j	=>	r_addr_lm_j,
						r_data	=>	r_data_lm);
						
Led_mtx: ENTITY work.ledMatrixController
			PORT MAP(rst			=>	rst,
						readyTimer	=>	max_tick_lmc,
						ena			=>	ena,
						led_state	=>	r_data_lm,
						r_addr_j		=>	r_addr_lm_j,
						r_addr_i		=>	r_addr_lm_i,
						rows			=>	rows,
						cols			=>	cols);
				
			
counterLedMtx: ENTITY work.univ_bin_counter
			GENERIC MAP(	N	=>	10	)
			PORT MAP(clk		=>	clk,
						rst		=>	rst,
						ena		=>	ena,
						syn_clr	=>	rst,
						load		=>	'0',
						up			=>	'1',
						max		=>	"1111101000", --20u
						d			=>	"0000000000",
						max_tick	=>	max_tick_lmc);	
						
-------------------- Movimiento Pelota ------------------------------
----- Rebotes ------------
der_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	x,
					B		=>	"1111",
					sel	=>	'0',
					eq		=>	col_der);
					
izq_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	x,
					B		=>	"0000",
					sel	=>	'0',
					eq		=>	col_izq);
					
tec_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	"000",
					sel	=>	'0',
					eq		=>	col_tec);
					
pis_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	"111",
					sel	=>	'0',
					eq		=>	col_pis);
					
arriba_P1_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	y_Ra_P1_m1,
					sel	=>	'0',
					eq		=>	arriba_ra_P1);

medio_P1_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	y_Ra_P1_s,
					sel	=>	'0',
					eq		=>	medio_ra_P1);

abajo_P1_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	y_Ra_P1_p1,
					sel	=>	'0',
					eq		=> abajo_ra_P1);		
		
arriba_P2_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	y_Ra_P2_m1,
					sel	=>	'0',
					eq		=>	arriba_ra_P2);

medio_P2_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	y_Ra_P2_s,
					sel	=>	'0',
					eq		=>	medio_ra_P2);


abajo_P2_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y,
					B		=>	y_Ra_P2_p1,
					sel	=>	'0',
					eq		=> abajo_ra_P2);
					
col_esq_D_arriba: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_next_s,
					B		=>	y_Ra_P2_m1,
					sel	=>	'0',
					eq		=> esq_D_arriba_s);
					
col_esq_D_abajo: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_next_s,
					B		=>	y_Ra_P2_p1,
					sel	=>	'0',
					eq		=> esq_D_abajo_s);
					
col_esq_I_arriba: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_next_s,
					B		=>	y_Ra_P1_m1,
					sel	=>	'0',
					eq		=> esq_I_arriba_s);
					
col_esq_I_abajo: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_next_s,
					B		=>	y_Ra_P1_p1,
					sel	=>	'0',
					eq		=> esq_I_abajo_s);
	
der_n_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	x_next_s,
					B		=>	"1111",
					sel	=>	'0',
					eq		=>	n_col_der_s);
	
Izq_n_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	x_next_s,
					B		=>	"0000",
					sel	=>	'0',
					eq		=>	n_col_izq_s);
					
arriba_P2		<=	(arriba_ra_P2   AND n_col_der_s);
esq_D_arriba	<=	(esq_D_arriba_s AND n_col_der_s);
medio_P2			<=	(medio_ra_P2    AND n_col_der_s);
abajo_P2			<=	(abajo_ra_P2    AND n_col_der_s);
esq_D_abajo		<=	(esq_D_abajo_s  AND n_col_der_s);
	
arriba_P1		<=	(arriba_ra_P1   AND n_col_izq_s);
esq_I_arriba	<=	(esq_I_arriba_s AND n_col_izq_s);
medio_P1			<=	(medio_ra_P1    AND n_col_izq_s);
abajo_P1			<=	(abajo_ra_P1    AND n_col_izq_s);
esq_I_abajo		<=	(esq_I_abajo_s  AND n_col_izq_s);

------ Animacion Movimiento ------------
MovimientoFSM: ENTITY work.x_ymove
					PORT MAP(clk				=> clk,
								rst 				=> (rst OR rst_game),
								ena 				=> ena,
								en_id          => "00",
								col_izq			=> col_izq,
								col_der 			=> col_der,
								arriba_P1		=> arriba_P1,	
								medio_P1			=>	medio_P1,
								abajo_P1			=>	abajo_P1,
								esq_arriba_D 	=> esq_D_arriba,
								esq_abajo_D 	=> esq_D_abajo,
								arriba_P2 		=> arriba_P2,	
								medio_P2			=> medio_P2,
								abajo_P2 		=>	abajo_P2,
								esq_arriba_I 	=> esq_I_arriba,
								esq_abajo_I 	=> esq_I_abajo,
								col_pis 			=> col_pis,
								col_tec 			=> col_tec,
								ini_st 			=> ini_st,
								x_sel 			=> x_sel,
								y_sel 			=> y_sel);

---- Posicion -----------------
Coordenadas: ENTITY work.x_ycoords
					PORT MAP(clk 			=> clk,
							   rst 			=> (rst OR rst_game),
								ena 			=> ena,
								cambios_vel => cambio_vel,
								x_sel 		=> x_sel,
								y_sel 		=> y_sel,
								x_ini_st	 	=> "1000",
								y_ini_st 	=> "011",
								x_next 		=> x_next_s,
								y_next 		=> y_next_s, 
								x 				=> x,
								y 				=> y );
								
---------- Entrada para los Jugadores -------------
P1_up_button: ENTITY work.edge_detect
					PORT MAP(clk       =>	clk,
								async_sig =>	btn_up_P1,
								rise      =>	btn_up_P1_s);

P1_dwn_button: ENTITY work.edge_detect
					 PORT MAP(clk       =>	clk,
								 async_sig =>	btn_dwn_P1,
								 rise      =>	btn_dwn_P1_s);
								 
P1_position: ENTITY work.P1_racket_position
				  PORT MAP(clk 		 => clk,
							  rst 		 => (rst OR rst_game),
							  ena 		 => ena,
							  btn_up_P1	 => btn_dwn_P1_s,	
							  btn_dwn_P1 => btn_up_P1_s,		
							  x_Ra_P1 	 => x_Ra_P1_s,		
							  x_Ra_P1_p1 => x_Ra_P1_p1,
							  x_Ra_P1_m1 => x_Ra_P1_m1,	
							  y_Ra_P1 	 => y_Ra_P1_s,		
							  y_Ra_P1_p1 => y_Ra_P1_p1,	
							  y_Ra_P1_m1 => y_Ra_P1_m1);
							  
P2_up_button: ENTITY work.edge_detect
					PORT MAP(clk       =>	clk,
								async_sig =>	btn_up_P2,
								rise      =>	btn_up_P2_s);

P2_dwn_button: ENTITY work.edge_detect
					 PORT MAP(clk       =>	clk,
								 async_sig =>	btn_dwn_P2,
								 rise      =>	btn_dwn_P2_s);							  
							  
							  
P2_position: ENTITY work.P2_racket_position
				  PORT MAP(clk 		 => clk,
							  rst 		 => (rst OR rst_game),
							  ena 		 => ena,
							  btn_up_P2	 => btn_dwn_P2_s,	
							  btn_dwn_P2 => btn_up_P2_s,		
							  x_Ra_P2 	 => x_Ra_P2_s,		
							  x_Ra_P2_p1 => x_Ra_P2_p1,
							  x_Ra_P2_m1 => x_Ra_P2_m1,	
							  y_Ra_P2 	 => y_Ra_P2_s,		
							  y_Ra_P2_p1 => y_Ra_P2_p1,	
							  y_Ra_P2_m1 => y_Ra_P2_m1);
							  
------------------ Manejo de las imagenes animadas ---------------------------
Print: ENTITY work.ManejoImagenAnimada
			  PORT MAP (clk      =>	clk,
							rst      =>	(rst OR rst_game),
							ena      =>	'1',
							ena_comp => "1111111",
							x_1      => x,
							y_1      => y,
							x_2      => x_Ra_P1_s,
							y_2      => y_Ra_P1_s,
							x_3      => x_Ra_P1_p1,
							y_3      => y_Ra_P1_p1,
							x_4      => x_Ra_P1_m1,
							y_4      => y_Ra_P1_m1,
							x_5      => x_Ra_P2_s,
							y_5      => y_Ra_P2_s,
							x_6      => x_Ra_P2_p1,
							y_6      => y_Ra_P2_p1,
							x_7      => x_Ra_P2_m1,
							y_7      => y_Ra_P2_m1,
							wr_en		=>	wr_en_s2,
							w_addr_j	=>	w_addr_s2_j,
							w_addr_i	=>	w_addr_s2_i,
							w_data	=>	w_data_s2);
							

------- Estado inicial de la pelota ---------
--Cambia la forma de salida inicial de la pelota

InitialState: ENTITY work.univ_bin_counter
			GENERIC MAP(	N	=>	3	)
			PORT MAP(clk		=>	clk,
						rst		=>	rst,
						ena		=>	ena,
						syn_clr	=>	rst,
						load		=>	'0',
						up			=>	'1',
						max		=>	"101", 
						d			=>	"000",
						counter	=>	ini_st);		
						
---------------------- Velocidad Bola -----------------------------------------					
TimerBola: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 28 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	(rst OR rst_game),
					ena      =>	(ena),
					syn_clr  =>	(rst OR rst_game),
					load     =>	'0',
					up       =>	'1',
					d        =>	"0000000000000000000000000000",
					max      =>	unsigned(Velocidad),
					max_tick	=>	cambio_vel);	
					
VelocidadB: ENTITY work.Vel_bola
					PORT MAP(clk			=>	clk,
								rst			=>	(rst OR rst_game),
								ena			=>	(ena),
								Golpeos		=>	(arriba_P2 OR medio_P2 OR abajo_P2 OR arriba_P1 OR medio_P1 OR abajo_P1),
								Velocidad	=>	Velocidad);

------------------ Imagenes -----------------------------------
FSM_control: ENTITY work.Imagenes_FSM
	PORT MAP(clk				=>	clk,
				rst				=>	rst,
				ena				=>	ena,
				str_btn			=>	start_sig,
				col_izq			=>	col_izq,
				col_der			=>	col_der,
				max_izq			=>	max_izq,
				max_der			=>	max_der,
				tick_timer_1s	=>	tick_timer_1s,
				tick_timer_3s	=>	tick_timer_3s,
				tick_timer_g	=>	tick_timer_g,
				tick_timer_w	=>	tick_timer_w,
				timer_ena_3s	=>	timer_ena_3s,
				timer_ena_g		=>	timer_ena_g,
				timer_ena_w		=>	timer_ena_w,
				rst_game			=>	rst_game,
				gol_sig_1		=>	gol_sig_1,
				gol_sig_2		=>	gol_sig_2,
				wr_en				=>	wr_en_s1,
				w_addr_i			=>	w_addr_s1_i,
				w_addr_j			=>	w_addr_s1_j,
				w_data			=>	w_data_s1);
				
--------- Timers ------------------
Timer_g: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 26 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	rst,
					ena      =>	timer_ena_g,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00000000000000000000000000",
					max      =>	"10111110101111000010000000",
					max_tick	=>	tick_timer_g);
	
Timer_w: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 26 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	rst,
					ena      =>	timer_ena_w,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00000000000000000000000000",
					max      =>	"10111110101111000010000000",
					max_tick	=>	tick_timer_w);
					
time_1s:	ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 26 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	rst,
					ena      =>	timer_ena_3s,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00000000000000000000000000",
					max      =>	"10111110101111000010000000",
					max_tick =>	tick_timer_1s);
	
time_3s: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 2 )
	PORT	MAP(	clk      =>	tick_timer_1s,
					rst      =>	rst,
					ena      =>	ena,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00",
					max      =>	"11",
					max_tick	=>	tick_timer_3s);
					
--------- Puntaje --------------------------

ConteoPuntos_P1: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 4 )
	PORT	MAP(	clk      =>	gol_sig_1,
					rst      =>	rst,
					ena      =>	ena,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"0000",
					max      =>	"1001",
					max_tick	=>	max_der,
					counter  => punt_P1);
					
ConteoPuntos_P2: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 4 )
	PORT	MAP(	clk      =>	gol_sig_2,
					rst      =>	rst,
					ena      =>	ena,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"0000",
					max      =>	"1001",
					max_tick	=>	max_izq,
					counter  => punt_P2);
					
Puntos_P1: ENTITY work.bin_to_sseg
				PORT MAP(bin  => punt_P1,
							sseg => Puntaje_P1);
							
Puntos_P2: ENTITY work.bin_to_sseg
				PORT MAP(bin  => punt_P2,
							sseg => Puntaje_P2);
							
-------- Boton Start -------------------
Start_edge: ENTITY work.edge_detect
					PORT MAP(clk       =>	clk,
								async_sig =>	start,
								rise      =>	start_s);
	
startSt: ENTITY work.mydff_1
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	start_s,
					prn		=>	'0',
					ini_st	=>	'0',
					d			=>	NOT(start_sig),
					q			=>	start_sig);
					
-------- Selector de Impresion --------
selectorImpresion: ENTITY work.SelectordeSenal
							PORT MAP(clk			=>	clk,
										rst			=>	rst,
										game_sig		=>	rst_game,
										wr_en_s1		=>	wr_en_s1,
										w_addr_s1_i	=>	w_addr_s1_i,
										w_addr_s1_j	=>	w_addr_s1_j,
										w_data_s1	=>	w_data_s1,
										wr_en_s2		=>	wr_en_s2,
										w_addr_s2_i	=>	w_addr_s2_i,
										w_addr_s2_j	=>	w_addr_s2_j,
										w_data_s2	=>	w_data_s2,
										wr_en			=>	wr_en_s,
										w_addr_j		=>	w_addr_s_j,
										w_addr_i		=>	w_addr_s_i,
										w_data		=>	w_data_s);
	
END ARCHITECTURE;		