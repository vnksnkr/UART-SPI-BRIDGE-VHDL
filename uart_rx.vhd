library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity uart_rx is
    generic (
        CLKS_PER_BIT: integer := 434
    );
    port (
        clk : in std_logic;
        rx  : in std_logic;
        
        rx_bytes : out std_logic_vector (7 downto 0);
        rx_dv    : out std_logic
    );
end entity uart_rx;

architecture RTL of uart_rx is
	
    type SM is (IDLE,START,DATA,STOP,CLEANUP);
    signal state: SM := IDLE;
    
    signal bytes        : std_logic_vector (7 downto 0);
    signal clkcnt       : integer range 0 to CLKS_PER_BIT -1 := 0;
    
    signal bitcnt       : integer range 0 to 7 := 0;
    
    signal rx_dv_r      : std_logic := '0';
    
begin
 	
    process (clk)
    begin
        if rising_edge(clk) then
        
            case state is
                when IDLE =>             	
                    bitcnt  <=  0;
                    clkcnt  <=  0;
                    rx_dv_r <= '0'; 
                    if rx = '0' then
                        state <= START;            
                    else
                        state <= IDLE;
                    end if;
                    
                when START => 	
                    if clkcnt < (CLKS_PER_BIT-1)/2  then                   	
                        if rx = '0' then                       	
                            clkcnt <= 0;
                            state  <= DATA;                        
                        else
                            state <= IDLE;			    
                        end if;
                    
                    else
                        clkcnt <= clkcnt + 1;
                        state  <= START;                 
                    end if;
                
                when DATA =>                   
                    if clkcnt < (CLKS_PER_BIT-1) then                   	
                        clkcnt <= clkcnt + 1;
                        state  <= DATA;
                    
                    else
                        clkcnt <= 0;
                        bytes(bitcnt) <= rx; 
                        if bitcnt < 7 then
                            bitcnt <= bitcnt + 1;
                            state  <= DATA;

                        else
                            bitcnt <= 0;
                            state  <= STOP;
                        end if;                   
                    end if;
                    
                when STOP =>                	
                    if clkcnt < (CLKS_PER_BIT-1) then                   	
                        clkcnt <= clkcnt + 1;
                        state  <= STOP;
                        
                    else
                        rx_dv_r <= '1';
                        clkcnt  <=  0;
                        state   <= CLEANUP;                   
                    end if;
                
                when CLEANUP =>                	
                    rx_dv_r <= '0';
                    state   <= IDLE;
                                
            end case;		    
        end if;
        
    end process;
    
    rx_bytes <= bytes;
    rx_dv    <= rx_dv_r;

end RTL;
