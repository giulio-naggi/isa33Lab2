library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity TB is 
end entity;

architecture beh of TB is 
	component data_maker is
	  port (
		CLK  : in  std_logic;
		A,B : out std_logic_vector(31 downto 0);
		END_SIM: out std_logic);
	end component data_maker;
	
	component data_sink is
	  port (
		CLK   : in std_logic;
		RST_n : in std_logic;
		PROD  : in std_logic_vector(31 downto 0);
		END_SIM : in std_logic);
	end component data_sink;
	
	component clk_gen is
	  port (
		END_SIM : in  std_logic;
		CLK     : out std_logic;
		RST_n   : out std_logic);
	end component clk_gen;
	
	component FPmul is
	   port( 
		  RST_n : IN 	std_logic;
		  FP_A : IN     std_logic_vector (31 DOWNTO 0);
		  FP_B : IN     std_logic_vector (31 DOWNTO 0);
		  clk  : IN     std_logic;
		  FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
	   );
	end component FPmul ;
	
	signal CLK_s : std_logic;
	signal END_SIM_s : std_logic;
	signal RST_n_s : std_logic;
	signal A_s : std_logic_vector(31 downto 0);
	signal B_s : std_logic_vector(31 downto 0);
	signal PROD_s : std_logic_vector(31 downto 0);
begin
	
	data_make: data_maker port map(CLK => CLK_s, A => A_s, B => B_s, END_SIM => END_SIM_s);
	data_sin: data_sink port map(CLK => CLK_s, RST_n => RST_n_s, PROD => PROD_s, END_SIM => END_SIM_s);
	clk_g: clk_gen port map(END_SIM => END_SIM_s, CLK => CLK_s, RST_n => RST_n_s);
	mul: FPmul port map(RST_n => RST_n_s, FP_A => A_s, FP_B => B_s, clk => CLK_s, FP_Z => PROD_s);

end architecture;
