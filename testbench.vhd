-- Code your testbench here
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is
	
    
    constant CLK_PERIOD : time := 20 ns;
    
    constant c_CLKS_PER_BIT : integer := 434;
    
    constant c_BIT_PERIOD : time := 8680 ns;

	signal clk : std_logic := '0';
    signal start : std_logic := '0';
    signal reset : std_logic := '0';
    signal r_bytes : std_logic_vector (7 downto 0);
    signal spi0_slave_data : std_logic_vector (7 downto 0);
    signal spi1_slave_data : std_logic_vector (7 downto 0);
    signal spi2_slave_data : std_logic_vector (15 downto 0);
    signal spi3_slave_data : std_logic_vector (15 downto 0);
    signal din : std_logic_vector (7 downto 0);
    
    component top
	generic (
    		CLKS_PER_BIT : integer := 434
            );
    port	(
    		clk			   : in std_logic;
            din            : in std_logic_vector (7 downto 0);
            start          : in std_logic;
            reset          : in std_logic;
            r_bytes        : out std_logic_vector (7 downto 0);
            spi0_slave_data : out std_logic_vector (7 downto 0);
            spi1_slave_data : out std_logic_vector (7 downto 0);
            spi2_slave_data : out std_logic_vector (15 downto 0);
            spi3_slave_data : out std_logic_vector (15 downto 0)
            );
     end component;       

	begin
    	
        top_inst : top 
        generic map(
        CLKS_PER_BIT => c_CLKS_PER_BIT
        )
        port map(
        clk => clk,
        din => din,
        start => start,
        reset => reset,
        r_bytes => r_bytes,
        spi0_slave_data => spi0_slave_data,
        spi1_slave_data => spi1_slave_data,
        spi2_slave_data => spi2_slave_data,
        spi3_slave_data => spi3_slave_data
        );
        
        
        clk <= not clk after CLK_PERIOD/2;
        
        process
        begin
        	
        	reset <= '1';
            wait for 20 ns;
            reset <= '0';
            wait for 20 ns;
            din <= "00001000";
            start <= '1';
            wait for 20 ns;
            start <= '0';
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for 20 ns;
        	
        	
        	din <= "10011000";
            start <= '1';
            wait for 20 ns;
            start <= '0';
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;            
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            
        	
        	din <= "10101000";
            start <= '1';
            wait for 20 ns;
            start <= '0';            
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
            wait for c_BIT_PERIOD;
                   	
            
            
            
            
            
            
            
            
            
            
 ---------------16 bit--------------------------------


         	
          	din <= "01110000";
            start <= '1';
            wait for 20 ns;
            start <= '0';
            wait for c_BIT_PERIOD * 12;
            wait for 20 ns;
        	
        	din <= "10011000";
            start <= '1';
            wait for 20 ns;
            start <= '0';
            wait for c_BIT_PERIOD * 12;

            
        	din <= "11110000";
            start <= '1';
            wait for 20 ns;
            start <= '0';            
            wait for c_BIT_PERIOD * 12;
            
            
            
            din <= "11010000";
            start <= '1';
            wait for 20 ns;
            start <= '0';
            wait for c_BIT_PERIOD * 12;
            wait for 20 ns; 
       
          	din <= "11010000";
            start <= '1';
            wait for 20 ns;
            start <= '0';
            wait for c_BIT_PERIOD * 15;
            wait for 20 ns; 
         	        	
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        end process;
end tb;        
           