library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity controller is 
	port(
    	clk   	  	 : in std_logic;
        reset 	  	 : in std_logic;
        start 	  	 : in std_logic;
        from_uart 	 : in std_logic_vector (7 downto 0);
        from_spi  	 : in std_logic_vector (7 downto 0);
        spi_recieved : in std_logic;
        
        length	  : out std_logic_vector (4 downto 0);
        addr	  : out std_logic_vector (1 downto 0);
        to_spi	  : out std_logic_vector (7 downto 0);
        to_uart   : out std_logic_vector (7 downto 0);
        
        send_to_spi  : out std_logic;
        send_to_uart : out std_logic
        );
end entity controller;

architecture RTL of controller is
	
    signal r_length : std_logic_vector (4 downto 0);
    signal r_addr	: std_logic_vector (1 downto 0);
    signal r_to_spi : std_logic_vector (7 downto 0);
    

    signal mode			  : std_logic;
    signal r_send_to_spi  : std_logic := '0';
    signal r_send_to_uart : std_logic := '0';
    
    signal startcnt : integer range 0 to 2 := 0;
    signal  bitcnt  : integer := 0;
    signal length_i : integer ;    

    type SM is (
    CONFIGURE,WAIT_DATA,DATA,
    RECIEVE_FROM_SPI,STOP);
    
    signal	 state :  SM := CONFIGURE;
    
      
   
    
    begin
    	length_i <= 1 when r_length(4) = '1' else 0 ;
    	process(clk)
        	begin
            	if rising_edge(clk) then
                	case state is
                        when CONFIGURE =>
                        	if start = '0' or reset = '1' then
                            	state <= CONFIGURE;
                            else
                            	r_length <= from_uart(4 downto 0);
                                r_addr   <= from_uart(6 downto 5);
                                mode	 <= from_uart(7);
                                
                                if from_uart(7) = '0' then
                                	state <= WAIT_DATA;
                                
                                else
                                	r_to_spi <= (others => 'Z');
                                    state    <= RECIEVE_FROM_SPI;
                                    r_send_to_spi <= '1';
                                
                                end if;
                            end if;
                        
                        when WAIT_DATA =>
                        	if start = '0' then
                            	state <= WAIT_DATA;
                                r_send_to_spi <= '0';
                        	else
                            	if mode = '0' then
                                	state <= DATA;
                                else
                                	r_to_spi <= (others => 'Z');
                                    state 	 <= RECIEVE_FROM_SPI;
                                end if;
                            
                            end if;
                        
                        when DATA =>
                        	r_to_spi <= from_uart;
                            r_send_to_spi <= '1';
                            if bitcnt < length_i then
                                bitcnt <= bitcnt + 1;
                                state  <= WAIT_DATA;
                            else
                                bitcnt <= 0;
                            	state <= STOP;
                            	

                            end if;
                            
                        when RECIEVE_FROM_SPI =>
                        	r_send_to_spi <= '0';
                            if spi_recieved = '1' then
                            	to_uart <= from_spi;
                                state <= STOP;
                            else
                            	state <= RECIEVE_FROM_SPI;
                            end if;
                        
                        when STOP =>
                            r_send_to_spi <= '0';
                            state <= CONFIGURE;
                            
                    end case;        
                end if;            	
        
        end process;
        
        process(clk)
        	begin
            	
                if rising_edge(clk) then
                	if spi_recieved = '1' and mode = '1' then
                    	r_send_to_uart <= '1';
                    else
                    	if startcnt >= 2 then
                        	r_send_to_uart <= '0';
                            startcnt <= 0;
                            
                        else
                        	r_send_to_uart <= r_send_to_uart;
                            startcnt <= startcnt + 1;
                        end if;
                    end if;
                end if;
                
        end process;
        
        send_to_uart <= r_send_to_uart;
        to_spi <= r_to_spi;
        addr <= r_addr;
        length <= r_length;
        send_to_spi <= r_send_to_spi;

end RTL;
