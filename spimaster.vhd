library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity spimaster is
	port(
    	
        clk    : in std_logic;
        reset  : in std_logic;
        
        length : in std_logic_vector (4 downto 0);
        addr   : in std_logic_vector (1 downto 0);
        
        t_data 		 : in std_logic_vector (7 downto 0);
        send_to_spi  : in std_logic;
        miso		 : in std_logic;
        
        r_data : out std_logic_vector (7 downto 0);
        sclk   : out std_logic;
        
        ss0	   : out std_logic;
        ss1	   : out std_logic;
        ss2	   : out std_logic;
        ss3	   : out std_logic;
        
        mosi   : out std_logic;
        
        spi_recieved : out std_logic
        );

end entity spimaster;

architecture RTL of spimaster is
	
    type SM is (IDLE,SEND, WAIT_FOR_NB);

    signal state   : SM := IDLE;
        
    signal ss_r    : std_logic := '1';
    signal sendclk : std_logic := '0';
    signal load    : std_logic := '0';
    
    signal bitcnt   : integer range 0 to 8  := 0;
    signal r_bitcnt : integer range 0 to 7  := 0;
    signal cnt		: integer range 0 to 16 := 0;
    
    signal sclk_r 	: std_logic;
    signal mosi_r 	: std_logic_vector (7 downto 0);
    signal r_data_r : std_logic_vector (7 downto 0);
    
begin

	process(clk)
    
    begin
    
    	if falling_edge(clk) then
        	
            if reset = '1' then
            	state <= IDLE;
            else
            	
                case state is
                
                when IDLE =>
                	
                    if send_to_spi = '1' then
                    	load <= '1';
                    	state <= SEND;
                    
                    else
                    	state <= IDLE;
            			ss_r <= '0';
            			sendclk <= '0';
            			spi_recieved <= '0';
                    
                    end if;
                    
                when SEND =>
                	
                    if cnt < to_integer(unsigned(length)) then
                    	
                        sendclk <= '1';
                        
                        if bitcnt < 8 then
                        	spi_recieved <= '0';
                            if load = '1' then
                            	mosi_r <= t_data;
                                load   <= '0';
                                ss_r <= '1';
                                state <= SEND;
                                bitcnt <= bitcnt + 1;
                                cnt <= cnt + 1;
                            
                            else
                            	mosi_r <= '0' & mosi_r(7 downto 1);
								ss_r <= '1';
								bitcnt <= bitcnt + 1;
								cnt <= cnt + 1;
								state <= SEND;
                    		end if;
                            
                        else
                        	spi_recieved <= '1';
							ss_r <= '0';
							bitcnt <= 0;
							state <= WAIT_FOR_NB;
                        
                        end if;    
     			 	
                    else
                    	spi_recieved <= '1';
						bitcnt <= 0;
						cnt <= 0;
						sendclk <= '0';
						ss_r <= '0';
						state <= IDLE;
                    
                    end if;
                    
                when WAIT_FOR_NB =>
                
                	spi_recieved <= '0';
                    if cnt = 15 then
                        state <= IDLE;
                        
                    elsif send_to_spi = '1' then
                    	state <= SEND;
                        load  <= '1';
                    else
                    	state <= WAIT_FOR_NB;
                	end if;
                    
            	end case;
        
        
            end if;
        end if;    
    end process;
    
    mosi   <= mosi_r(0) and sendclk;
    r_data <= r_data_r;
    ss0    <= not(ss_r and (not addr(0) and not addr(1)));
    ss1    <= not(ss_r and (not addr(0) and addr(1)));
    ss2    <= not(ss_r and (addr(0) and not addr(1)));
    ss3    <= not(ss_r and (addr(0) and addr(1)));
    sclk   <= sclk_r;
    
    process(clk)
    
    begin
    	if sendclk = '1' then
        	sclk_r <= clk;
        else
            sclk_r <= '0'; 	
        end if;
        
    end process;
    
    process(sclk_r)
    begin
    	if rising_edge(sclk_r) then
        	if ss_r = '1' then
            	if r_bitcnt = 7 then
                r_bitcnt <= 0;
                end if;
            	r_data_r(r_bitcnt) <= miso;
                if r_bitcnt < 7 then
                r_bitcnt <= r_bitcnt + 1;
            	end if;
            end if;
        
        end if;
    
    end process;
    
end RTL;