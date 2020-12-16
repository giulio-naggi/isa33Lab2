library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    PROD  : in std_logic_vector(31 downto 0);
	END_SIM : in std_logic);
end data_sink;

architecture beh of data_sink is
signal end_write : std_logic := '0';
signal en_write : integer := 0;
begin  -- beh
	
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			en_write <= en_write+1;
		end if;
	end process;

	process(CLK)
	begin
		if CLK'event and CLK = '1' and END_SIM = '1' then
			end_write <= '1';
		end if;
	end process;

	process (CLK, RST_n)
		file res_fp : text open WRITE_MODE is "./results_vhdl.hex";
		variable line_out : line;    
	begin  -- process
		if RST_n = '0' then                 -- asynchronous reset (active low)
			null;
		elsif CLK'event and CLK = '1' then  -- rising clock edge
			if (end_write = '0' and en_write > 5) then
				hwrite(line_out, PROD);
				writeline(res_fp, line_out);
			end if;
		end if;
	end process;

end beh;
