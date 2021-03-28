
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity uart_tx is
    generic (
        CLKS_PER_BIT: integer := 434
    );
    port (
        clk     : in std_logic;
        start   : in std_logic;
        
        din     : in std_logic_vector (7 downto 0);
 
        tx      : out std_logic;
        tx_done        : out std_logic;
        tx_busy        : out std_logic
    );
end entity uart_tx;

architecture RTL of uart_tx is

    type SM is (IDLE,START_s, DATA,STOP, CLEANUP );

    
    signal bytes        : std_logic_vector (7 downto 0);
    signal clkcnt       : integer range 0 to CLKS_PER_BIT-1 := 0;
    
    signal state        : SM := IDLE;
    signal bitcnt       : integer range 0 to 7 := 0;
    
    signal tx_busy_r    : std_logic := '0';
    signal tx_done_r    : std_logic := '0';
    
begin
    process (clk)
    begin
            
        if rising_edge(clk) then   
            case state is
                
                when IDLE =>
                    tx <= '1';
                    bitcnt <= 0;
                    clkcnt <= 0;
                    tx_done_r <= '0';
                    if start = '0' then
                        state <= IDLE;

                    else
                        tx_busy_r <= '1';
                        bytes <= din;
                        state <= START_s;
                    end if;
                 
                when START_s =>
                    tx <= '0';
                     
                    if clkcnt < CLKS_PER_BIT-1 then
                        clkcnt <= clkcnt + 1;
                        state  <= START_s;

                    else
                        clkcnt <= 0;
                        state  <= DATA;
                    end if;
                                    
                when DATA =>
                    tx <= bytes(bitcnt);         
                    if clkcnt < CLKS_PER_BIT -1 then
                        clkcnt <= clkcnt + 1;
                        state <= DATA;

                    else 
               	    clkcnt <= 0;
                        if bitcnt < 7 then 
                     	    bitcnt <= bitcnt + 1;
                     	    state  <= DATA;

                        else            
                            bitcnt <= 0;
                     	    state  <= STOP;
                        end if;                             
                    end if;
                            
                when STOP =>
                    tx <= '1';
                    if clkcnt < CLKS_PER_BIT -1 then                          
                        clkcnt <= clkcnt +1;
                        state <= STOP;
                    else                           
                        clkcnt <= 0;
                        state <= CLEANUP;
                        tx_busy_r <= '0';
                    end if;
                                                       
                when CLEANUP =>
                    clkcnt <= 0;
                    tx_done_r <= '1';
                    state <= IDLE;
                         
                when others =>
                    state <= IDLE;
                                        
            end case;                     
        end if;             
                 
    end process;
    
    tx_busy <= tx_busy_r;
    tx_done <= tx_done_r;

end RTL;
