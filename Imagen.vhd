LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.mtx_pkg.ALL;
----------------------------------------
ENTITY Imagen IS
	PORT ( clk 			: 	IN 	STD_LOGIC;
			 rst        : 	IN  	STD_LOGIC;
			 ena        : 	IN  	STD_LOGIC;
			 rows			:	OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			 cols			:	OUT	STD_LOGIC_VECTOR( 15 DOWNTO 0 ));
END Imagen;

--------------------------
ARCHITECTURE arch OF Imagen IS

SIGNAL r_data_lm : STD_LOGIC;
SIGNAL r_addr_lm_i : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL r_addr_lm_j : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL	max_tick_lmc	:	STD_LOGIC;

SIGNAL	w_addr_s_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL	w_addr_s_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL	w_data_s	   :	STD_LOGIC;
SIGNAL	wr_en_s		:	STD_LOGIC;

CONSTANT Img: Img_mtx:=(
			"0011110000000000",
			"0100001001100110",
			"1010010111111111",
			"1000000111111111",
			"1010010101111110",
			"1001100100111100",
			"0100001000011000",
			"0011110000000000");

CONSTANT Im: Img_mtx:=(
			"0011110001011010",
			"0100001001011010",
			"1010010100100100",
			"1000000100000000",
			"1010010101100111",
			"1001100101001001",
			"0100001001000111",
			"0011110011100001");
			
CONSTANT Ima: Img_mtx:=(
			"0010100001100111",
			"0000000001001001",
			"0100010001000111",
			"0011100011100001",
			"0100000000000000",
			"0101110111010101",
			"0001010101010101",
			"0101010111001010");

BEGIN 

Print: ENTITY work.ManejoImagen
			  PORT MAP (clk      =>	clk,
							rst      =>	rst,
							ena      =>	'1',
							imageIn	=>	Ima,
							wr_en		=>	wr_en_s,
							w_addr_j	=>	w_addr_s_j,
							w_addr_i	=>	w_addr_s_i,
							w_data	=>	w_data_s);

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
			GENERIC MAP(	N	=>	14	)
			PORT MAP(clk		=>	clk,
						rst		=>	rst,
						ena		=>	ena,
						syn_clr	=>	rst,
						load		=>	'0',
						up			=>	'1',
						max		=>	"01100101100100", --130u
						d			=>	"00000000000000",
						max_tick	=>	max_tick_lmc);			
	
END ARCHITECTURE;							
	