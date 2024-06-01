LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------
ENTITY x_ycoords IS
	PORT	(	clk			:	IN		STD_LOGIC;
				rst			:	IN		STD_LOGIC;
				ena			:	IN		STD_LOGIC;
				cambios_vel :  IN    STD_LOGIC;
				x_sel			:	IN		STD_LOGIC;
				y_sel			:	IN		STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				x_ini_st	   :	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_ini_st	   :	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_next     	:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_next     	:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x     		:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y		      :	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 ));
END x_ycoords;
----------------------------------------
ARCHITECTURE arch OF x_ycoords IS

	SIGNAL	x_next_s	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	x_s		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	x_s_p1	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	x_s_m1	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	
	SIGNAL	y_next_s	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	y_s		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	y_s_p1	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	y_s_m1	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	
	SIGNAL   en_s     :  STD_LOGIC;
	
----------------------------------------
BEGIN

	en_s   <= cambios_vel;
	
	mux_x: ENTITY work.mux2_1
	GENERIC MAP(	N	=>	4	)
	PORT MAP(	X1		=>	x_s_p1,
					X2    =>	x_s_m1,
					sel	=>	x_sel,
					Y		=>	x_next_s);
	
	dff_x: ENTITY work.mydff
	GENERIC MAP(	N => 4 )
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	en_s,
					prn		=>	'0',
					ini_st	=>	x_ini_st,
					d			=>	x_next_s,
					q			=>	x_s);

	x_s_p1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(x_s))+1), x_s_p1'length));
	x_s_m1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(x_s))-1), x_s_m1'length));
	
	x	<=	x_s;
	x_next <= x_next_s;
	
	mux_y: ENTITY work.mux4_1
	GENERIC MAP(	N	=>	3	)
	PORT MAP(	X1		=>	y_s,
					X2		=>	y_s_p1,
					X3		=>	y_s_m1,
					X4		=>	y_s,
					sel	=>	y_sel,
					Y		=>	y_next_s);
	
	dff_y: ENTITY work.mydff
	GENERIC MAP(	N => 3 )
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	en_s,
					prn		=>	'0',
					ini_st	=>	y_ini_st,
					d			=>	y_next_s,
					q			=>	y_s);
	
	y_s_p1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(y_s))+1), y_s_p1'length));
	y_s_m1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(y_s))-1), y_s_m1'length));
	
	y	<=	y_s;
	y_next <= y_next_s;

END ARCHITECTURE;