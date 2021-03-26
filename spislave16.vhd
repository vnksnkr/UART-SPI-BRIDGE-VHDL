library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity SPI_slave16 is
	port(
    	SCK  	: in std_logic;
        MOSI 	: in std_logic;
        SSEL 	: in std_logic;
        MISO 	: out std_logic;
        r_bytes : out std_logic_vector(15 downto 0)
        );
end entity SPI_slave16;        

architecture RTL of SPI_slave16 is
	
    signal r_bitcnt : integer range 0 to 15 := 0;
    signal t_bytes	: std_logic_vector(15 downto 0) := "1010101010101010";
    
    signal MISO_r : std_logic := '0';
    
    begin
    	
        process(SCK)
        	begin
            	if rising_edge(SCK) then
        			if (SSEL = '0') then
                    	if(r_bitcnt < 15) then
                        	r_bitcnt <= r_bitcnt + 1;
                        else
                        	r_bitcnt <= 0;
                        end if;    
            			r_bytes(r_bitcnt) <= MOSI;
                        t_bytes <= '1' & t_bytes(15 downto 1);
    				end if;	
        		end if;
                
        end process;
        MISO <= t_bytes(0) when SSEL = '0' else 'Z';
            
        
end RTL;

